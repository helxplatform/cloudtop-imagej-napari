#!/usr/bin/with-contenv sh
USER_HOME=/home/$USER_NAME

if [ ! -f $USER_HOME/Desktop/napari.desktop ] ; then
   if [ ! -d $USER_HOME/Desktop ] ; then
      mkdir $USER_HOME/Desktop
   fi
   cp /headless/Desktop/napari.desktop $USER_HOME/Desktop/napari.desktop
   chown -R $USER_NAME:$USER_NAME $USER_HOME/Desktop
fi

if [ ! -f $USER_HOME/Desktop/imagej.desktop ] ; then
   if [ ! -d $USER_HOME/Desktop ] ; then
      mkdir $USER_HOME/Desktop
   fi
   cp /headless/Desktop/imagej.desktop $USER_HOME/Desktop/imagej.desktop
   chown -R $USER_NAME:$USER_NAME $USER_HOME/Desktop
fi
