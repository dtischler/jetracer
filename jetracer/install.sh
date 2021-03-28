#!/bin/sh

set -e

# Record the time this script starts
date

# Get the full dir name of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Keep updating the existing sudo time stamp
sudo -v
while true; do sudo -n true; sleep 120; kill -0 "$$" || exit; done 2>/dev/null &

# Install pip and some python dependencies
echo "\e[104m Install pip and some python dependencies \e[0m"
pip3 install --upgrade pip
pip3 install flask
pip3 install --upgrade numpy 

# Install the pre-built TensorFlow pip wheel
echo "\e[48;5;202m Install the pre-built TensorFlow pip wheel \e[0m"
pip3 install -U numpy grpcio absl-py py-cpuinfo psutil portpicker six mock requests gast astor termcolor protobuf keras-applications keras-preprocessing wrapt google-pasta
pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow

# Install the pre-built PyTorch pip wheel 
echo "\e[45m Install the pre-built PyTorch pip wheel  \e[0m"
cd
wget -N https://nvidia.box.com/shared/static/9eptse6jyly1ggt9axbja2yrmj6pbarc.whl -O torch-1.6.0-cp36-cp36m-linux_aarch64.whl  
pip3 install Cython
pip3 install numpy torch-1.6.0-cp36-cp36m-linux_aarch64.whl

# Install torchvision package
echo "\e[45m Install torchvision package \e[0m"
cd
git clone https://github.com/pytorch/vision torchvision
cd torchvision
git checkout tags/v0.7.0
python3 setup.py install
cd  ../
pip install 'pillow<7'

# setup Jetson.GPIO
#echo "\e[100m Install torchvision package \e[0m"
#sudo groupadd -f -r gpio
#sudo -S usermod -a -G gpio $USER
#sudo cp /opt/nvidia/jetson-gpio/etc/99-gpio.rules /etc/udev/rules.d/
#sudo udevadm control --reload-rules
#sudo udevadm trigger

# Install traitlets (master, to support the unlink() method)
echo "\e[48;5;172m Install traitlets \e[0m"
#sudo -H python3 -m pip install git+https://github.com/ipython/traitlets@master
python3 -m pip install git+https://github.com/ipython/traitlets@dead2b8cdde5913572254cf6dc70b5a6065b86f8

# Install Jupyter Lab
echo "\e[48;5;172m Install Jupyter Lab \e[0m"
pip3 install jupyter jupyterlab
jupyter labextension install @jupyter-widgets/jupyterlab-manager

# Install jetcard
echo "\e[44m Install jetcard \e[0m"
cd $DIR
pwd
python3 setup.py install

# Install TensorFlow models repository
echo "\e[48;5;202m Install TensorFlow models repository \e[0m"
cd
url="https://github.com/tensorflow/models"
tf_models_dir="TF-models"
if [ ! -d "$tf_models_dir" ] ; then
	git clone $url $tf_models_dir
	cd "$tf_models_dir"/research
	git checkout 5f4d34fc
	wget -O protobuf.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-aarch_64.zip
	# wget -O protobuf.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip
	unzip protobuf.zip
	./bin/protoc object_detection/protos/*.proto --python_out=.
	python3 setup.py install
	cd slim
	python3 setup.py install
fi

# Disable syslog to prevent large log files from collecting
#sudo service rsyslog stop
#sudo systemctl disable rsyslog

# Install jupyter_clickable_image_widget
echo "\e[42m Install jupyter_clickable_image_widget \e[0m"
cd
#sudo apt-get install nodejs-dev node-gyp libssl1.0-dev
#sudo apt-get install npm
git clone https://github.com/jaybdub/jupyter_clickable_image_widget
cd jupyter_clickable_image_widget
git checkout no_typescript
pip3 install -e .
jupyter labextension install js
jupyter lab build

# Install remaining dependencies for projects
echo "\e[104m Install remaining dependencies for projects \e[0m"


echo "\e[42m All done! \e[0m"

#record the time this script ends
date

