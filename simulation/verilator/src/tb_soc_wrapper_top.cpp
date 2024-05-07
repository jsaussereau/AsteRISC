#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsoc_wrapper_top.h"
#include "Vsoc_wrapper_top_soc_wrapper_top.h"
#include "Vsoc_wrapper_top_soc_min__PBz1_PCz2_PGa_PM0.h"
#include "Vsoc_wrapper_top_soc_min__PBz1_PCz2_PGa_PM0_PQ1.h"
#include "Vsoc_wrapper_top_soc_sp_ram__pi3.h"
#include "Vsoc_wrapper_top_soc_sp_ram__pi4.h"
#include "Vsoc_wrapper_top_wrap_ram_imem__pi1.h"
#include "Vsoc_wrapper_top_wrap_ram_dmem__pi2.h"


#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>
#include <string>
#include <getopt.h>

#define PERIOD 10 // Mettez la période en nanosecondes ici

#define _BOLD "\x1b[1m"
#define _END "\x1b[0m"
#define _BLACK "\x1b[30m"
#define _RED "\x1b[31m"
#define _GREEN "\x1b[32m"
#define _YELLOW "\x1b[33m"
#define _BLUE "\x1b[34m"
#define _MAGENTA "\x1b[35m"
#define _CYAN "\x1b[36m"
#define _WHITE "\x1b[37m"

void help() {
    std::cout << "\n" << _BOLD << "Description:\n" << _END
                 "  This program simulates AsteRISC using Verilator.\n"
                 "\n" << _BOLD "Options:\n" << _END
                 "  -i, --imem_file \tPath to the instruction memory initialization file.\n"
                 "  -d, --dmem_file \tPath to the data memory initialization file.\n"
                 "  -I, --imem_depth\tPower of two representing the depth of the instruction memory.\n"
                 "  -D, --dmem_depth\tPower of two representing the depth of the data memory.\n"
                 "  -v, --vcd_file  \tPath to the output VCD file for waveform dumping.\n"
                 "\n" << _BOLD "Example:\n" << _END
                 "  ./Vsoc_wrapper_top --imem_file=imem.hex --dmem_file=dmem.hex --vcd_file=output.vcd --imem_depth=10 --dmem_depth=12\n\n";
}

int main(int argc, char** argv) {

    int opt;
    std::string imem_file_path, dmem_file_path, vcd_file_path;
    int p_imem_depth_pw2, p_dmem_depth_pw2;

    // Définition des options à lire avec getopt_long
    static struct option long_options[] = {
        {"imem_file", required_argument, 0, 'i'},
        {"dmem_file", required_argument, 0, 'd'},
        {"imem_depth", required_argument, 0, 'I'},
        {"dmem_depth", required_argument, 0, 'D'},
        {"vcd_file", required_argument, 0, 'v'},
        {"help", no_argument, 0, 'h'},
        {0, 0, 0, 0}
    };

    int option_index = 0;
    std::cout << std::endl << _BOLD << "Options: " << _END << std::endl;
    while ((opt = getopt_long(argc, argv, "i:d:I:D:v:h", long_options, &option_index)) != -1) {
        switch (opt) {
            case 'i':
                imem_file_path = optarg;
                std::cout << "  imem_file = " << imem_file_path << std::endl;
                break;
            case 'd':
                dmem_file_path = optarg;
                std::cout << "  dmem_file = " << dmem_file_path << std::endl;
                break;
            case 'I':
                p_imem_depth_pw2 = std::stoi(optarg);
                std::cout << "  imem_depth = 2^" << p_imem_depth_pw2 << std::endl;
                break;
            case 'D':
                p_dmem_depth_pw2 = std::stoi(optarg);
                std::cout << "  dmem_depth = 2^" << p_dmem_depth_pw2 << std::endl;
                break;
            case 'v':
                vcd_file_path = optarg;
                std::cout << "  vcd_file_path = " << vcd_file_path << std::endl;
                break;
            case 'h':
                help();
                return 0;
            default:
                std::cout << _BOLD << _RED << "error: invalid option '" << (char)opt << "'" << _END << std::endl;
                return 1;
        }
    }

    std::cout << std::endl;

    // Vérifiez le nombre d'arguments
    if (imem_file_path.empty() || dmem_file_path.empty() || vcd_file_path.empty()) {
        std::cout << _BOLD << _RED << "error: missing required arguments" << _END << std::endl;
        help();
        return 1;
    }

    // Initialise Verilator
    Verilated::commandArgs(argc, argv);

    // Créez une instance du modèle Verilated
    Vsoc_wrapper_top* top = new Vsoc_wrapper_top;

    // Initialisez l'horloge et la réinitialisation
    top->i_xtal_p = 0;
    top->i_xtal_n = 0;
    top->i_xclk = 0;
    top->i_xrst = 1;

    // Ouvrez et initialisez les fichiers imem et dmem
    std::ifstream imem_file(imem_file_path, std::ios::in);
    if (!imem_file.is_open()) {
        std::cout << _BOLD << _RED << "error: could not open imem init file \"" << imem_file_path << "\" " << _END << std::endl;
        return 1;
    }
    std::ifstream dmem_file(dmem_file_path, std::ios::in);
    if (!dmem_file.is_open()) {
        std::cout << _BOLD << _RED << "error: could not open dmem init file \"" << imem_file_path << "\" " << _END << std::endl;
        return 1;
    }

    // Chargez imem et dmem
    for (uint32_t i = 0 ; i < (1 << top->soc_wrapper_top->p_imem_depth_pw2) ; i++) {
        std::string line;
        if (std::getline(imem_file, line)) {
            std::istringstream iss(line);
            uint32_t value;
            if (iss >> std::hex >> value) {
                top->soc_wrapper_top->soc_top_level->imem->imem->set_mem_content(i, value);
                //uint32_t mem_content = top->soc_wrapper_top->soc_top_level->imem->imem->get_mem_content(i);
                //std::cout << std::hex << std::setw(8) << std::setfill('0') << value << std::endl;
            } else {
                std::cout << _BOLD << _RED << "error: failed parsing " << _END << std::endl;
            }
        } else {
            break;
        }
    }

    for (uint32_t i = 0 ; i < (1 << top->soc_wrapper_top->p_dmem_depth_pw2) ; i++) {
        std::string line;
        if (std::getline(dmem_file, line)) {
            std::istringstream iss(line);
            uint32_t value;
            if (iss >> std::hex >> value) {
                top->soc_wrapper_top->soc_top_level->dmem->dmem->set_mem_content(i, value);
            } else {
                std::cout << _BOLD << _RED << "error: failed parsing " << _END << std::endl;
            }
        } else {
            break;
        }
    }

    // Fermez les fichiers de mémoire
    /*imem_file.close();
    dmem_file.close();*/

    // Initialisez le fichier VCD
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open(vcd_file_path.c_str());

    // Commencez la simulation
    for (int time = 0; time < 20000; ++time) {
        // Basculez l'horloge
        top->i_xtal_p = !top->i_xtal_p;

        // Évaluez le modèle Verilated
        top->eval();

        // Enregistrez l'état des signaux dans le fichier VCD
        tfp->dump(time);

        // Avancez dans le temps d'une demi-période
        Verilated::timeInc(PERIOD / 2);

        // Réinitialisez à un moment donné si nécessaire
        if (time == 30) {
            top->i_xrst = 0;
        }
    }

    // Fermez le fichier VCD
    tfp->close();

    // Nettoyez
    delete top;
    delete tfp;

    return 0;
}
