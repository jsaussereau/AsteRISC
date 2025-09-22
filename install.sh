########################################################
# Install
########################################################

VENV_ODATIX=venv

_GREEN='\033[0;32m'
_ENDC='\033[0m'

python3 -m venv $VENV_ODATIX

source activate.sh

python3 -m pip install -U pip
python3 -m pip install odatix

# Check if Odatix was installed correctly
if command -v odatix &> /dev/null
then
    echo -e "\n${_GREEN}Environnement installation complete!${_ENDC}"
else
    echo -e "\n${_RED}Environnement installation failed!${_ENDC}"
fi
 
deactivate
