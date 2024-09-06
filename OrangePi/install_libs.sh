sudo apt-get update
sudo apt-get install build-essential libssl-dev cmake git

git clone https://github.com/WiringPi/WiringPi.git
cd WiringPi
sudo ./build

sudo apt-get update
sudo apt-get install build-essential libssl-dev cmake

git clone https://github.com/eclipse/paho.mqtt.c.git

cd paho.mqtt.c
mkdir build
cd build
cmake ..
make
sudo make install

echo "/usr/local/lib" | sudo tee -a /etc/ld.so.conf.d/paho-mqtt.conf
sudo ldconfig
