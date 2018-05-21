# already installed on rasbpian_prebuilt.img from Parts & Crafts:
# sudo apt-get update
# sudo apt-get upgrade
# sudo apt-get dist-upgrade
# sudo apt-get install -y git
# git clone https://github.com/silvanmelchior/RPi_Cam_Web_Interface.git
# cd RPi_Cam_Web_Interface
# ./install.sh
# turn on camera
# sudo raspi-config 
# sudo ./start.sh 
# sudo vi /boot/config.txt 
# sudo vi /boot/cmdline.txt 
# 
# Install begins:
# 
apt-get install -y dnsmasq hostapd screen git-core curl
# welcome page
# cp /boot/templates/index.html ~/
# install nvm for nodejs
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install node
nvm use node
# link ~/www to /var/www and do bad things with permissions
ln -s /var/www/ ~/www
chmod -R 777 ~/
cd ~/www
cd www
git clone https://github.com/publiclab/infragram
cd infragram
npm install
# install wifi webgui - https://github.com/billz/raspap-webgui, includes lighttpd
wget -q https://git.io/voEUQ -O /tmp/raspap && bash /tmp/raspap
service lighttpd start
cp /boot/templates/raspap.php /etc/raspap/ 
cp /boot/templates/raspap_defaults /boot/templates/defaults 
mv /boot/templates/defaults /etc/raspap/networking/defaults 
cp /boot/templates/lighttpd.conf /etc/lighttpd/
cp /boot/templates/lighttpd /etc/init.d/
service lighttpd start
cp /boot/templates/dnsmasq.conf /etc/
cp /boot/templates/dhcpcd.conf /etc/
cp /boot/templates/hostapd /etc/default/
cp /boot/templates/interfaces /etc/network/
cp /boot/templates/rc.local /etc/
cp /boot/templates/wpa_supplicant.conf /etc/wpa_supplicant/
cp /boot/templates/hostapd.conf /etc/hostapd/
/usr/sbin/hostapd /etc/hostapd/hostapd.conf
systemctl status rc-local.service
update-rc.d dhcpcd disable
rpi-update 
systemctl restart dnsmasq
