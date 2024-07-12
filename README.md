<h1 align="center">Installation du Lab Acropolix</h1>

<p align="center">
<a href="https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html" alt="GPL v2.0"><img src="https://img.shields.io/badge/License-GPL_v2-blue.svg" /></a>
</p>
<br />

Ce dépôt contient tous les éléments nécessaires pour reproduire l'environnement de travail du Lab Acropolix : 

| Fichiers | Descriptions |
|:--------|:----------------|
| alphasys-config.tar.gz      | Configuration du kernel Linux personnalisé pour Raspberry Pi 4 64 bits, obtenu par Buildroot  |
| aarch64-buildroot-linux-uclibc_sdk-buildroot.tar.gz     | Outils de compilation croisée, obtenus via Buildroot |
| install.sh      | Script bash permettant d'installer tout l'environnement de travail du Lab Acropolix |

<br />


**_⚠️ Remarque :_** <br />
Tout ce qui suit ne pourra être applicable que sur un environnement GNU/Linux. <br />
Si vous êtes sur Windows, je vous invite à installer l'outil WSL 2 (Windows Subsystem for Linux) qui vous permettra d'avoir un environnement Linux en ligne de commande depuis votre Windows. [Comment installer Linux sur Windows avec WSL ?](https://learn.microsoft.com/fr-fr/windows/wsl/install).<br />
Si vous êtes sur MacOS, le meilleur moyen est d'installer une machine virtuelle GNU/Linux en utilisant l'outil [Tart](https://tart.run) (qui offre des performances plus que satisfaisante).

<br />

## Prérequis
Un certain nombre de paquets sont nécessaires pour faire fonctionner ce script. Pour cela, consultez le fichier [prerequisites.txt](https://github.com/LabAcropolix/LabConfig/blob/master/prerequisites.txt), et installez-les en fonction de votre distribution GNU/Linux. Nous nous sommes basés sur une distribution Debian, il se peut que certains paquets n'existent pas pour une autre distribution, ou aient un autre nom. 

## Installation

Clônez ce dépôt dans votre dossier personnel :
```shell
cd # Pour se placer directement dans votre dossier personnel /home
git lfs clone https://github.com/LabAcropolix/LabConfig.git # Cloner ce dépôt
```

**_⚠️ Remarque :_** <br />
Pourquoi utiliser ``git lfs clone`` au lieu de ``git clone`` ?
Dans le dépôt sont présents deux fichiers _.tar.gz_ volumineux. Git-LFS (Git Long File System) est nécessaire pour pouvoir récupérer ces fichiers dans notre dépôt local, sinon, avec un simple clone habituel, nous ne récupérons qu'un lien dynamique vers le serveur sur lequel sont hébergés ces fichiers, ne permettant pas au script de les installer sur notre machine de développement.


Un nouveau dossier nommé Install_Lab est créé, déplacez-vous dans celui-ci :

```shell
cd Install_Lab
```

Ajoutez les droits d'exécution au script install.sh  s'il n'est pas déjà exécutable :

```shell
chmod +x install.sh
```

et lancez-le pour lancer la procédure d'installation de l'environnement de travail :

```shell
 ./install.sh
 ```

Le script se lance et vous n'avez plus qu'à patienter le temps que tout soit mis en place.

## Post-installation
Si vous souhaitez que votre Raspberry Pi se connecte à votre réseau WiFi, il est nécessaire d'apporter des modifications dans le fichier de configuration wpa_supplicant.conf.
Pour cela, déplacez-vous dans le dossier d'installation du Lab :
```shell
cd $HOME/br-lab
```

Puis éditez le fichier wpa_supplicant.conf :
```shell
nano alphasys-config/custom-rootfs/etc/wpa_supplicant.conf
```

Et renseignez-y le nom de votre réseau WiFi :
```shell
   ssid="le nom de votre réseau WiFi"
```
ainsi que le mot de passe :
```shell
   psk="le mot de passe de votre réseau WiFi"
```

Sauvegardez le fichier par la combinaison de touches _Ctrl + O_, puis quittez l'éditeur par la combinaison de touches _Ctrl + X_.

Enfin, soit vous pouvez lancer la compilation du noyau Linux personnalisé :
```shell
cd $HOME/br-lab/build-alphasys
make
```

soit, vous pouvez apporter d'autres modifications dans la configuration du noyau Linux :
```shell
cd $HOME/br-lab/build-alphasys
make menuconfig
```
