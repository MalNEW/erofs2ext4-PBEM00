#!/usr/bin/sh

################################################
#   Script to Make SGSI for OPPO R17(PBEM00)   #
#     Made by Malware_MEZM(github@MalNEW)      #
################################################

################ Script Config ################

#Uncomment to enable unpack informaton
#export unpackInformation="i"

################ ToolsBinary Path ################
export eU="./bin/erofsUnpack"
export lm="./bin/lpmake"
export mkext4fs="./bin/make_ext4fs"
export pldump="./bin/payload-dumper-go"
export s2i="./bin/simg2img"
export i2s="./bin/img2simg"
export s2s="./bin/simg2simg"

################ Img Path ################
export SysImg="./system.img"
export VenImg="./vendor.img"

################ Output Path ################
export SysOut="./output/system_erofs/"
export VenOut="./output/vendor_erofs/"

if [ ! -d $SysOut ]; then
    echo "[\033[34m+\033[0m] Create system output folder at $SysOut"
    mkdir ./output/
    mkdir ./output/system
fi

if [ ! -d $VenOut ]; then
    echo "[\033[34m+\033[0m] Create vendor output folder at $VenOut"
    mkdir ./output/vendor
fi

################ Repack Path ################
export repackOut="./repack"

if [ ! -d $repackOut ]; then
    echo "[\033[34m+\033[0m] Create repack output folder at $SysOut"
    mkdir ./repack
fi

################ Mount Path ################
export sysMount="./mount/sys"
export venMount="./mount/sys"

if [ ! -d $sysMount ]; then
    echo "[\033[34m+\033[0m] Create repack output folder at $SysOut"
    mkdir ./mount/
    mkdir ./mount/sys/
fi

if [ ! -d $venMount ]; then
    echo "[\033[34m+\033[0m] Create repack output folder at $SysOut"
    mkdir ./mount/ven/
fi

################ Infomation ################
export Version="1.0.0.0-test"
export RelDate="2024/06/17"
clear
echo "=============== Environment Variables ==============="
echo "erofsUnpack=$eU"
echo "lpMake=$lm"
echo "make_ext4fs=$mkext4fs"
echo "payloadDumper=$pldump"
echo "simg2img=$s2i"
echo "img2simg=$i2s"
echo "simg2simg=$s2s"
echo "systemImagePath=$SysImg"
echo "vendorImagePath=$VenImg"
echo "systemOutputPath=$SysOut"
echo "vendorOutputPath=$VenOut"
echo "systemFilesystemSize=3G"
echo "vendorFilesystemSize=2G"
echo "repackFolder=$repackOut"
echo "systemMountFolder=$sysMount"
echo "vendorMountFolder=$venMount"
echo "====================================================="

echo "- Script Version:$Version"
echo "- Release Date:$RelDate"

################ Unpack&Repack ################
###############
#System Unpack#
###############
echo "[\033[34m+\033[0m] Unpacking System.img [EROFS]"
if [ -f $SysImg ]; then
    #If system.img exist then execute:
    $eU $SysImg $SysOut $unpackInformation
    echo "\033[32m Process complete! repacking... \033[0m"

    ###############
    #System Repack#
    ###############
    #Repack system as simg
    $mkext4fs -l 3G -s -a system $repackOut/sys_repack_simg.img $SysOut/system
    #Convert simg to raw filesystem img
    $s2i $repackOut/sys_repack_simg.img $repackOut/sys_repack_rimg.img
else
    #If system.img not exist then execute:
    echo "\033[5;31;1m [ERROR] '$SysImg' not exist,ending script...\033[0m"
    exit 255
fi
###############
#Vendor Unpack#
###############
echo "[\033[34m+\033[0m] Unpacking Vendor.img [EROFS]"
if [ -f $VenImg ]; then
    #If vendor.img exist then execute:
    $eU $VenImg $VenOut $unpackInformation

    ###############
    #Vendor Repack#
    ###############
    echo "\033[32m Process complete! repacking... \033[0m"
    $mkext4fs -l 3G -s -a vendor $repackOut/ven_repack_simg.img $VenOut/vendor
    #Convert simg to raw filesystem img
    $s2i $repackOut/ven_repack_simg.img $repackOut/ven_repack_rimg.img
else
    #If vendor.img not exist then execute:
    echo "\033[5;31;1m [ERROR] '$VenImg' not exist,ending script...\033[0m"
    exit 255
fi

echo "\033[32mConvert done,now you can put sys_repack_rimg.img and ven_repack_rimg.img into Xiaoxindada's SGSI Build Tool Folder!\033[0m"
