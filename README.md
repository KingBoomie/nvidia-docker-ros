This is a docker container that I'm using as a GUI environment for a ROS1 robot (robotont) 
with a realsense d435 camera. It's running apriltag detector. PlotJuggler and floxglove-studio
are included for debugging. 

There's probably some other solution needed when **not** using a proproetary nvidia driver,
but that's what I have. 

## Setting up

```
cd nvidia-docker-ros
mkdir src
cd src
git clone --depth 1 https://github.com/IntelRealSense/realsense-ros.git \
  && git clone --depth 1 https://github.com/pal-robotics/ddynamic_reconfigure \
  && git clone --depth 1 https://github.com/AprilRobotics/apriltag \
  && git clone --depth 1 https://github.com/AprilRobotics/apriltag_ros \
  && git clone --depth 1 https://github.com/robotont/robotont_msgs \
  && git clone --depth 1 https://github.com/PlotJuggler/plotjuggler_msgs.git \
  && git clone --depth 1 https://github.com/facontidavide/PlotJuggler.git \
  && git clone --depth 1 https://github.com/PlotJuggler/plotjuggler-ros-plugins.git
```


## Credits
Inspired by

https://github.com/iory/docker-ros-realsense    
https://github.com/pierrekilly/docker-ros-box    

