########################################################
# Activate virtual environment
########################################################

VENV_ODATIX=venv

_RED='\033[0;31m'
_CYAN='\033[0;36m'
_ENDCOLOR='\033[0m'

# Check if the virtual environment directory exists
if [ ! -d "$VENV_ODATIX" ] || [ ! -f "$VENV_ODATIX/bin/activate" ]; then
    echo -e "${_RED}Error: Virtual environment '$VENV_ODATIX' does not exist.${_ENDC}"
    echo -e "${_CYAN}Please create it first by running 'source install.sh'.${_RED}"
else
    source $VENV_ODATIX/bin/activate
fi
