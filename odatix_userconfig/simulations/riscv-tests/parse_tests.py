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

"""
Parse the software print log of the riscv-tests simulation and write a
per-test OK/KO report, along with summary statistics read by Odatix
(see _metrics.yml).

Print log format (produced by the tests themselves, see riscv_test.h):
  <test_name>..OK      -> the test passed
  <test_name>..ERROR   -> the test failed (the program stops right after)

A test that never printed anything is reported as NOT_RUN (this happens
for every test located after a failing one, since the failure triggers an
ebreak, and also when the simulation times out).
"""

import os
import re
import sys

TEST_RESULT_RE = re.compile(r"([A-Za-z_][A-Za-z0-9_.]*?)\s*\.\.\s*(OK|ERROR)")
EXPECTED_TEST_RE = re.compile(r"^\s*TEST\s*\(\s*([A-Za-z_][A-Za-z0-9_]*)\s*\)")


def read_expected_tests(start_file):
  """Get the ordered list of tests from the TEST(...) calls of the start file."""
  if not start_file or not os.path.isfile(start_file):
    return []
  expected = []
  with open(start_file, "r", errors="replace") as f:
    for line in f:
      match = EXPECTED_TEST_RE.match(line)
      if match and match.group(1) not in expected:
        expected.append(match.group(1))
  return expected


def read_results(print_file):
  """Get the {test name: OK/KO} results printed during the simulation."""
  results = {}
  if not os.path.isfile(print_file):
    return results
  with open(print_file, "r", errors="replace") as f:
    content = f.read()
  for name, status in TEST_RESULT_RE.findall(content):
    results[name] = "OK" if status == "OK" else "KO"
  return results


def write_report(report_file, tests, results):
  passed = [t for t in tests if results.get(t) == "OK"]
  failed = [t for t in tests if results.get(t) == "KO"]
  not_run = [t for t in tests if t not in results]

  total = len(tests)
  pass_rate = (100.0 * len(passed) / total) if total else 0.0

  os.makedirs(os.path.dirname(os.path.abspath(report_file)), exist_ok=True)
  with open(report_file, "w") as f:
    for test in tests:
      f.write("{}: {}\n".format(test, results.get(test, "NOT_RUN")))
    f.write("\n")
    f.write("Tests_Total: {}\n".format(total))
    f.write("Tests_Passed: {}\n".format(len(passed)))
    f.write("Tests_Failed: {}\n".format(len(failed)))
    f.write("Tests_Not_Run: {}\n".format(len(not_run)))
    f.write("Pass_Rate: {:.2f}\n".format(pass_rate))
    f.write("All_Tests_Passed: {}\n".format(1 if total and not failed and not not_run else 0))
    f.write("Failed_Tests: {}\n".format(", ".join(failed) if failed else "none"))
    f.write("Not_Run_Tests: {}\n".format(", ".join(not_run) if not_run else "none"))

  return len(passed), len(failed), len(not_run), total


def main():
  print_file = sys.argv[1] if len(sys.argv) > 1 else "log/print.log"
  report_file = sys.argv[2] if len(sys.argv) > 2 else "log/tests_results.yml"
  start_file = sys.argv[3] if len(sys.argv) > 3 else ""

  results = read_results(print_file)
  tests = read_expected_tests(start_file)
  # Keep tests that were run but are not listed in the start file (if any)
  tests += [t for t in results if t not in tests]
  if not tests:
    print("warning: no test result found in \"{}\"".format(print_file))

  passed, failed, not_run, total = write_report(report_file, tests, results)
  print("  {}/{} tests passed ({} failed, {} not run)".format(passed, total, failed, not_run))
  print("  report saved to \"{}\"".format(report_file))


if __name__ == "__main__":
  main()
