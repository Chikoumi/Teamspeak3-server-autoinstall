#!/bin/bash
echo -e "\\033[1;33m|---------------------------------------|\033[0m"
echo -e "\\033[1;33m|--- Script installation Teamspeak 3 ---|\033[0m"
echo -e "\\033[1;33m|---------------------------------------|\033[0m"

#Creation du dossier.
echo -n "[En cours] Creation du dossier..."
while true
do 
mkdir /home/teamspeak
if [ -d "/home/teamspeak" ]; then
    echo -e "\r\e[0;32m[OK]\e[0m Creation du dossier                 "
    break
else
    echo -e "\r\e[0;31m[Erreur] Creation du dossier                  "
fi
done

#Creation user teamspeak
echo -n "[En cours] Creation utilisateur..."
while true
do 
useradd --home /home/teamspeak teamspeak
user=$(cut -d: -f1 < /etc/passwd | grep teamspeak)
if [ "${user}" = "teamspeak" ]; then
    echo -e "\r\e[0;32m[OK]\e[0m Creation utilisateur                "
    break
else
    echo -e "\r\e[0;31m[Erreur] Creation utilisateur                 "
fi
done


#On va dans le dossier de ts
echo -n "[En cours] Aller dans le dossier de teamspeak..."
cd /home/teamspeak
echo -e "\r\e[0;32m[OK]\e[0m Aller dans le dossier de teamspeak      "


#On telecharge archive
echo -n "[En cours] Telechargement de l'archive...                   "
while true
do 
wget -q http://dl.4players.de/ts/releases/3.0.11.2/teamspeak3-server_linux-amd64-3.0.11.2.tar.gz --no-check-certificate
if [ -f "teamspeak3-server_linux-amd64-*.tar.gz" ]; then
    echo -e "\r\e[0;32m[OK]\e[0m Telechargement de l'archive         "
    break
else
    echo -e "\r\e[0;31m[Erreur] Telechargement de l'archive          "
fi
done

#On extrait archive
echo -n "[En cours] Extraction de l'archive..."
while true
do 
tar xzvf teamspeak3* > /dev/null
if [ -d "teamspeak3-server_linux-amd64" ]; then
    echo -e "\r\e[0;32m[OK]\e[0m Extraction de l'archive             "
    rm teamspeak3-server_linux-amd64-*.tar.gz
    break
else
    echo -e "\r\e[0;31m[Erreur] Extraction de l'archive              "
fi
done

#on defini droit de teamspeak
echo -n "[En cours] Droit de propriete..."
chown -R teamspeak:teamspeak /home/teamspeak && chmod -R 755 /home/teamspeak
sleep 3s
 echo -e "\r\e[0;32m[OK]\e[0m Droit de propriete                "

#on va dans le dossier de teamspeak
echo -n "[En cours] Aller dans le dossier teamspeak3-server_linux-amd64..."
cd teamspeak3-server_linux-amd64
sleep 3s
 echo -e "\r\e[0;32m[OK]\e[0m Aller dans le dossier teamspeak3-server_linux-amd64                "

#On telecharge le script
echo -n "[En cours] Telechargement du script de service..."
cd /etc/init.d

while true
do 
wget -q "https://raw.githubusercontent.com/Chikoumi/Teamspeak3-server-autoinstall/master/teamspeak" --no-check-certificate
if [ -f "teamspeak" ]; then
    echo -e "\r\e[0;32m[OK]\e[0m Telechargement du script de service                "
    break
else
    echo -e "\r\e[0;31m[Erreur] Telechargement du script de service                      "
fi
done

#On convertie le fichier 
echo -n "[En cours] Conversion du fichier..."
apt-get -qq update && apt-get install dos2unix -y -qq
dos2unix -q teamspeak > /dev/null
sleep 3s
echo -e "\r\e[0;32m[OK]\e[0m Conversion du fichier                "


#On rends le fichier executable
echo -n "[En cours] On rend le fichier executable..."
chmod +x /etc/init.d/teamspeak
sleep 3s
echo -e "\r\e[0;32m[OK]\e[0m On rend le fichier executable                 "

#on ajoute teamspeak au demmarage du VPS
echo -n "[En cours] On lance teamspeak au demmarage..."
update-rc.d teamspeak defaults > /dev/null
sleep 3s
echo -e "\r\e[0;32m[OK]\e[0m On lance teamspeak au demmarage                "

#Info
echo "Vous avez acces a :"
echo "service teamspeak start"
echo "service teamspeak restart"
echo "service teamspeak stop"
echo -e "\r\e[0;32m |----------------------------------| \e[0m                "
echo -e "\r\e[0;32m |----- Installation terminee! -----| \e[0m                "
echo -e "\r\e[0;32m |----- Le token admin va etre -----| \e[0m                "
echo -e "\r\e[0;32m |------- genere juste apres -------| \e[0m                "
echo -e "\r\e[0;32m |----------------------------------| \e[0m                "

#On informe utilisateur
echo -n "Lancement du script de teamspeak3..."
su teamspeak -c "cd /home/teamspeak/teamspeak3-server_linux-amd64 && ./ts3server_startscript.sh start"
sleep 20
