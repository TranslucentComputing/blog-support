#!/bin/bash
set +e  # Continue on errors

if [ -f "requirements.txt" ]; then
    echo "Installing Python Dependencies"
    python -m pip install --root-user-action=ignore --quiet --upgrade pip
    python -m pip install --root-user-action=ignore --quiet -r requirements.txt -r dev-requirements.txt
fi

COLOR_RED="\033[38;5;1m"
COLOR_BLUE="\033[38;5;4m"
COLOR_GREEN="\033[38;5;2m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_BLUE}"
echo -e "  ████████╗██████╗  █████╗ ███╗   ██╗███████╗██╗     ██╗   ██╗ ██████╗███████╗███╗   ██╗████████╗"
echo -e "  ╚══██╔══╝██╔══██╗██╔══██╗████╗  ██║██╔════╝██║     ██║   ██║██╔════╝██╔════╝████╗  ██║╚══██╔══╝"
echo -e "     ██║   ██████╔╝███████║██╔██╗ ██║███████╗██║     ██║   ██║██║     █████╗  ██╔██╗ ██║   ██║   "
echo -e "     ██║   ██╔══██╗██╔══██║██║╚██╗██║╚════██║██║     ██║   ██║██║     ██╔══╝  ██║╚██╗██║   ██║   "
echo -e "     ██║   ██║  ██║██║  ██║██║ ╚████║███████║███████╗╚██████╔╝╚██████╗███████╗██║ ╚████║   ██║   "
echo -e "     ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   "
echo -e "${COLOR_RESET}";

echo -e "${COLOR_RED}"
echo -e " ██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗ ████████╗     █████╗ ███████╗███████╗██╗███████╗████████╗ █████╗ ███╗   ██╗████████╗"
echo -e " ██║ ██╔╝██║   ██║██╔══██╗██╔════╝██╔══██╗╚══██╔══╝    ██╔══██╗██╔════╝██╔════╝██║██╔════╝╚══██╔══╝██╔══██╗████╗  ██║╚══██╔══╝"
echo -e " █████╔╝ ██║   ██║██████╔╝█████╗  ██████╔╝   ██║       ███████║███████╗███████╗██║███████╗   ██║   ███████║██╔██╗ ██║   ██║   "
echo -e " ██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ██╔══██╗   ██║       ██╔══██║╚════██║╚════██║██║╚════██║   ██║   ██╔══██║██║╚██╗██║   ██║   "
echo -e " ██║  ██╗╚██████╔╝██████╔╝███████╗██║  ██║   ██║       ██║  ██║███████║███████║██║███████║   ██║   ██║  ██║██║ ╚████║   ██║   "
echo -e " ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   "
echo -e "${COLOR_RESET}";

echo -e "${COLOR_GREEN}################################################################################"
echo -e "#                                                                              #"
echo -e "#                      Welcome to your development container!                  #"
echo -e "#                                                                              #"
echo -e "################################################################################${COLOR_RESET}"
echo -e "Run ${COLOR_GREEN}python run.py${COLOR_RESET} to start the application"
echo -e ""

# Set terminal prompt
if [ -n "$BASH" ]; then
    export PS1="\[${COLOR_BLUE}\]devspace\[${COLOR_RESET}\] ./\W \[${COLOR_BLUE}\]\\$\[${COLOR_RESET}\] "
else
    export PS1="$ ";
fi

# Include project's bin/ folder in PATH
export PATH="./bin:$PATH"

# Open shell
bash --norc
