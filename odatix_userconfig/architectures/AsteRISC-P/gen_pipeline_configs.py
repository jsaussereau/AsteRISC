#!/usr/bin/env python3
#**********************************************************************#
#                               AsteRISC                               #
#**********************************************************************#
#
# Copyright (C) 2022 Jonathan Saussereau
#
# This file is part of AsteRISC.
# AsteRISC is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# AsteRISC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with AsteRISC. If not, see <https://www.gnu.org/licenses/>.
#

"""Generate the Odatix architecture files of the pipeline design space.

Nomenclature
------------

A pipeline topology is named after what it actually contains::

    P-IF1ID1EX3MA1WB1

that is ``P-`` followed by, for every pipeline group that has at least one
barrier, the group name and its depth, in pipeline order. A group with no
barrier is simply left out, so the name never carries a zero and stays as short
as the topology is simple. The total pipeline depth is the sum of the digits.

This replaces the old ``P0127`` naming, which was the decimal value of the
7-bit ``p_stage_*`` mask: that encoding could only ever say *whether* a barrier
existed, never how many, and it said nothing readable to a human. The mapping
from the old names is ``P0091 -> P-IF1ID1EX1MA1WB1``, ``P0127 ->
P-IF1IC1ID1RF1EX1MA1WB1``, and so on.

Adding a pipeline group later means adding one entry to ``GROUPS`` below (and
one barrier chain in ``cpu_core_pipe``); no name has to be renumbered, which is
the whole point of naming the groups instead of encoding them.
"""

import os

#! pipeline groups, in pipeline order. Extend here when a group is added.
GROUPS = ["IF", "IC", "ID", "RF", "EX", "MA", "WB"]

#! knobs that are not part of the pipeline topology, kept at their reference
#! value so that two topologies only ever differ by their topology
NON_PIPELINE = [
    ("p_fetch_buf",    0, "add buffers to fetch stage output"),
    ("p_decode_buf",   0, "add buffers to decode stage outputs"),
    ("p_rf_sp",        0, "register file is a single port ram"),
    ("p_rf_read_buf",  0, "register file has synchronous read"),
    ("p_mem_buf",      0, "add buffers to mem stage inputs"),
    ("p_wb_buf",       0, "add buffers to write back stage inputs"),
    ("p_branch_buf",   0, "add buffers to alu comp outputs (+1 cycle for conditionnal branches)"),
]

#! The design space. Each entry is a depth per group; a group left out is 0.
#!
#! `p_stage_IF` and `p_stage_MA` cannot be 0 (the instruction and data memory
#! reads are registered) and `p_stage_RF` cannot exceed 1 (the RF barrier *is*
#! the register file read register).
TOPOLOGIES = [
    # reference points, one barrier per group
    {"IF": 1, "ID": 1, "EX": 1, "MA": 1, "WB": 1},                          # ex-P0091, the default
    {"IF": 1, "IC": 1, "ID": 1, "RF": 1, "EX": 1, "MA": 1, "WB": 1},        # ex-P0127, every barrier
    {"IF": 1, "MA": 1},                                                     # ex-P0066, the shallowest
    # execute depth: what a pipelined multiplier needs
    {"IF": 1, "ID": 1, "EX": 2, "MA": 1, "WB": 1},
    {"IF": 1, "ID": 1, "EX": 3, "MA": 1, "WB": 1},
    {"IF": 1, "ID": 1, "EX": 4, "MA": 1, "WB": 1},
    # fetch depth: shortens the instruction memory path
    {"IF": 2, "ID": 1, "EX": 1, "MA": 1, "WB": 1},
    {"IF": 3, "ID": 1, "EX": 1, "MA": 1, "WB": 1},
    # one deeper group at a time, to isolate what each one costs
    {"IF": 1, "IC": 2, "ID": 1, "EX": 1, "MA": 1, "WB": 1},
    {"IF": 1, "ID": 2, "EX": 1, "MA": 1, "WB": 1},
    {"IF": 1, "ID": 1, "EX": 1, "MA": 2, "WB": 1},
    {"IF": 1, "ID": 1, "EX": 1, "MA": 1, "WB": 2},
    # combinations aiming at frequency rather than IPC
    {"IF": 2, "IC": 1, "ID": 1, "RF": 1, "EX": 2, "MA": 1, "WB": 1},
    {"IF": 1, "ID": 1, "RF": 1, "EX": 3, "MA": 2, "WB": 1},
    {"IF": 2, "IC": 2, "ID": 2, "RF": 1, "EX": 3, "MA": 2, "WB": 2},
]


def name_of(topology):
    """P-IF1ID1EX3MA1WB1: every group that exists, with its depth."""
    return "P-" + "".join(
        "{}{}".format(g, topology[g]) for g in GROUPS if topology.get(g, 0) > 0
    )


def depth_of(topology):
    return sum(topology.get(g, 0) for g in GROUPS)


def render(topology):
    lines = ["", "  parameter p_pipeline        = 1,", ""]
    lines.append("  // pipeline settings: {} barriers in total".format(depth_of(topology)))
    for g in GROUPS:
        lines.append("  parameter {:<17} = {},".format("p_stage_" + g, topology.get(g, 0)))
    lines.append("")
    lines.append("  // non pipeline settings:")
    for param, value, comment in NON_PIPELINE:
        lines.append("  parameter {:<17} = {},           //! {}".format(param, value, comment))
    lines.append("")
    return "\n".join(lines)


#! the testbench reaches the core through the `p_pipeline` generate branch, so
#! every pipeline architecture needs the same one-line simulation parameter
PIPE_HIERARCHY = "top->soc_wrapper_top->soc_top_level->pipe__DOT__cpu"


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    sims = os.path.normpath(os.path.join(here, "..", "..", "simulations"))

    names = []
    for topology in TOPOLOGIES:
        assert topology.get("IF", 0) >= 1, "p_stage_IF cannot be 0"
        assert topology.get("MA", 0) >= 1, "p_stage_MA cannot be 0"
        assert topology.get("RF", 0) <= 1, "p_stage_RF cannot exceed 1"
        name = name_of(topology)
        names.append(name)
        with open(os.path.join(here, name + ".txt"), "w") as f:
            f.write(render(topology))
        print("{}.txt  (depth {})".format(name, depth_of(topology)))

    # Simulation parameter files: without one, Odatix cannot point the
    # testbench at the pipelined core for a new architecture name. A sim whose
    # `tb_cpu/_settings.yml` carries a `match:` block already resolves `P*` to
    # the pipeline file on its own and needs nothing per architecture.
    if os.path.isdir(sims):
        for sim in sorted(os.listdir(sims)):
            tb_cpu = os.path.join(sims, sim, "sim_params", "tb_cpu")
            if not os.path.isdir(tb_cpu):
                continue
            settings = os.path.join(tb_cpu, "_settings.yml")
            if os.path.isfile(settings):
                with open(settings) as f:
                    if "match:" in f.read():
                        print("{}: matched by pattern, nothing to write".format(sim))
                        continue
            for name in names:
                with open(os.path.join(tb_cpu, name + ".txt"), "w") as f:
                    f.write(PIPE_HIERARCHY)
            print("{}: {} simulation parameter files".format(sim, len(names)))


if __name__ == "__main__":
    main()
