############################################################################################################
# 
# install.sh
#  
# This Bash script helps you to create the entire workspace for Lab Acropolix.
# It ONLY works on GNU/Linux system.
#
# Developped by : BOIDIN Emmanuel for Le Lab Acropolix
# Created on    : 06/19/2024 (english format)
#
#
# Copyright (C) 2024  Le Lab Acropolix
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
###########################################################################################################

#!/bin/bash

## VARIABLES ##
SCRIPT_INSTALL_PATH=$(pwd)                                          # Path where this script is

CURRENT_USER=$(whoami);                                             # Current user
HOME_PATH=$(echo $HOME);                                            # Home path for the current user
WORK_DIR="br-lab";                                                  # Buildroot directory
WORK_PATH="$HOME_PATH/$WORK_DIR";                                   # Worspace path

BR_GIT_LINK="https://gitlab.com/buildroot.org/buildroot.git"        # Link to the Buildroot's Github repository
BR_DIR="buildroot"                                                  # Name of the Buildroot directory created when cloning BR Github repository
BR_PATH="$WORK_PATH/$BR_DIR"                                        # Buildroot complete path

BUILD_DIR="build-alphasys";                                         # Build directory for the construction of the personnalized Linux kernel

CROSSCOMPILER_PATH="/opt/acropolix"                                 # Path where cross-compilation tools will be installed

# Text colors
COLOR_RESET='\033[0m'
COLOR_RED='\033[1;31m'
COLOR_GREEN='\033[1;32m'
COLOR_YELLOW='\033[1;33m'


printf "\033[8;25;145t"

## MAIN ##
echo "
 _____                                                                                                                                 _____ 
( ___ )                                                                                                                               ( ___ )
 |   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|   | 
 |   |      ██╗     ███████╗    ██╗      █████╗ ██████╗      █████╗  ██████╗██████╗  ██████╗ ██████╗  ██████╗ ██╗     ██╗██╗  ██╗      |   | 
 |   |      ██║     ██╔════╝    ██║     ██╔══██╗██╔══██╗    ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██╔═══██╗██║     ██║╚██╗██╔╝      |   | 
 |   |      ██║     █████╗      ██║     ███████║██████╔╝    ███████║██║     ██████╔╝██║   ██║██████╔╝██║   ██║██║     ██║ ╚███╔╝       |   | 
 |   |      ██║     ██╔══╝      ██║     ██╔══██║██╔══██╗    ██╔══██║██║     ██╔══██╗██║   ██║██╔═══╝ ██║   ██║██║     ██║ ██╔██╗       |   | 
 |   |      ███████╗███████╗    ███████╗██║  ██║██████╔╝    ██║  ██║╚██████╗██║  ██║╚██████╔╝██║     ╚██████╔╝███████╗██║██╔╝ ██╗      |   | 
 |   |      ╚══════╝╚══════╝    ╚══════╝╚═╝  ╚═╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝      ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═╝      |   | 
 |   |                                                                                                                                 |   | 
 |   |                  ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗      █████╗ ████████╗██╗ ██████╗ ███╗   ██╗                  |   | 
 |   |                  ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║                  |   | 
 |   |                  ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║                  |   | 
 |   |                  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║                  |   | 
 |   |                  ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║                  |   | 
 |   |                  ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝                  |   | 
 |___|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|___| 
(_____)                                                                                                                               (_____)"
echo
echo

echo "TASK: Verifying if $WORK_PATH exists ================================================================================================="
if [ ! -d $WORK_PATH ];
then
    echo "   $WORK_PATH does not exist. Creating it!"
    if ( $( mkdir -p $WORK_PATH ) ); then
        echo "      $COLOR_GREEN $WORK_PATH created successfully! $COLOR_RESET";
    else
        echo "      $COLOR_RED Error while creating $WORK_PATH! $COLOR_RESET";
        exit;
    fi
else
    echo "  $COLOR_YELLOW $WORK_PATH already exists. Skipping this step! $COLOR_RESET"
fi
echo

# Copying alphasys-config.tar.gz into the $WORK_PATH directory
echo "TASK: Installing config files ==============================================================================================================="
echo "   Copying alphasys-config.tar.gz"
if ( $( cp alphasys-config.tar.gz $WORK_PATH ) );
then
    echo "      $COLOR_GREEN alphasys-config.tar.gz copied successfully! $COLOR_RESET";
else
    echo "      $COLOR_RED Error while copying alphasys-config.tar.gz! $COLOR_RESET";
    exit;
fi
# Uncompress alphasys-config.tar.gz
# We are working in the workspace directory
cd $WORK_PATH;
echo "   Uncompressing alphasys-config.tar.gz file"
if ( $( tar xf alphasys-config.tar.gz ) );
then
    echo "      $COLOR_GREEN alphasys-config.tar.gz uncompressed successfully! $COLOR_RESET";
else
    echo "      $COLOR_RED Error while uncompressing alphasys-config.tar.gz! $COLOR_RESET";
fi
echo

# Cloning the Buildroot Github repository
echo "TASK: Verify if Buildroot is installed ======================================================================================================"
if [ ! -d $BR_DIR ];
then
    echo "   Buildroot is not installed. Cloning BR Github repository!"
    if ( $( git clone $BR_GIT_LINK ) );
    then
        chmod -R -w $BR_DIR;
        echo "      $COLOR_GREEN Buildroot installed successfully! $COLOR_RESET";
    else
        echo "      $COLOR_RED Error while cloning Buildroot Github repository! $COLOR_RESET";
        exit;
    fi
else
    echo "  $COLOR_YELLOW Buildroot already installed. Skipping this step! $COLOR_RESET";
fi
echo

cd $BR_PATH

# Making the Alpha System image
echo "TASK: Generating the Alpha System .config file =============================================================================================="
make  O=../$BUILD_DIR  BR2_EXTERNAL=../alphasys-config/  alphasys_defconfig
echo

# Installing cross-compilation tools
echo "TASK: Installing cross-compilation tools to $CROSSCOMPILER_PATH =================================================================================="
cd $SCRIPT_INSTALL_PATH
if [ ! -d $CROSSCOMPILER_PATH ];
then
    echo "   $CROSSCOMPILER_PATH does not exist. Creating it!"
    if ( $( sudo mkdir -p $CROSSCOMPILER_PATH ) ); then
        echo "      $COLOR_GREEN $CROSSCOMPILER_PATH created successfully! $COLOR_RESET";
    else
        echo "      $COLOR_RED Error while creating $CROSSCOMPILER_PATH! $COLOR_RESET";
        exit;
    fi
else
    echo "  $COLOR_YELLOW $CROSSCOMPILER_PATH already exists. $COLOR_RESET";
fi
echo "   Installing cross-compiler tools in $CROSSCOMPILER_PATH"
if ( $( sudo tar xf aarch64-buildroot-linux-uclibc_sdk-buildroot.tar.gz -C $CROSSCOMPILER_PATH ) );
then
    echo "      $COLOR_GREEN cross-compiler tools installed successfully! $COLOR_RESET";
else
    echo "      $COLOR_RED Error while isntalling cross-compiler tools! $COLOR_RESET";
fi
echo
echo
# Summary
echo "=============================================================================================================================================";
echo "                                         $COLOR_GREEN Le Lab Acropolix installed successfully $COLOR_RESET";
echo
echo " You can now generate the Alpha System image :";
echo "        cd $WORK_PATH/$BUILD_DIR";
echo "        make";
echo
echo " Then, you can update cross-compilation tools by making SDK, and place it to  :";
echo "        make sdk";
echo "        sudo tar xf $WORK_PATH/$BUILD_DIR/images/aarch64-buildroot-linux-uclibc_sdk-buildroot.tar.gz -C $CROSSCOMPILER_PATH"
echo "=============================================================================================================================================";