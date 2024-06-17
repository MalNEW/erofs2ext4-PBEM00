#!/usr/bin/sh

################################################
#          Clean Project Folder Script         #
################################################
echo Removing img files...
rm -rf ./*.img
echo Removing output folder...
rm -rf ./output
echo Removing repack folder...
rm -rf ./repack
echo Removing mount folder...
rm -rf ./mount
echo DONE!
