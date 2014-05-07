#!/bin/bash

if [ -z "$1" ]; then
  echo "Please enter the url to download"
  exit
else
  URL=$1
fi

FILE=${URL##*/}
[ -n "$2" ] && USER=$2

# install Java JRE
wget -q https://raw.githubusercontent.com/panticz/installit/master/install.java-jdk.sh -O - | bash -

# get file
if [ ${URL:0:4} == "http" ]; then
  wget -q ${URL} -O /tmp/${FILE}
else
  cp ${URL} /tmp/${FILE}
fi

# extract
[ -d /opt ] || sudo mkdir /opt
sudo unzip /tmp/${FILE} -d /opt/
sudo chmod +x /opt/sqldeveloper/sqldeveloper.sh
rm /tmp/sqldeveloper-*-no-jre.zip

# create startet
cat << EOF | sudo tee -a "/usr/share/applications/Oracle SQL Developer.desktop"
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=Oracle SQL Developer
Type=Application
Terminal=false
Exec=/opt/sqldeveloper/sqldeveloper.sh
Icon=/opt/sqldeveloper/icon.png
Categories=Application;Development;
EOF

# create user config to the latest installed JDK version
[ -d /home/${USER}/.sqldeveloper ] || mkdir /home/${USER}/.sqldeveloper
[ -f /home/${USER}/.sqldeveloper/jdk ] || echo "/usr/lib/jvm/$(ls /usr/lib/jvm | grep oracle | tail -1)/" > /home/${USER}/.sqldeveloper/jdk

# set owner
chown -R ${USER}:${USER} /home/${USER}/.sqldeveloper/

# cleanup
rm /tmp/${FILE}
