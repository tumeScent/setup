sudo apt update && sudo apt install -y \
	htop tmux vim git curl wget unzip \
       python3 python3-pip

python3 --version
pip3 --version

pip3 install virtualenv
virtualenv venv
source venv/bin/activate
pip3 install -r requirements.txt
