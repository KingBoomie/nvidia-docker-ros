FROM osrf/ros:melodic-desktop-full

ENV ROS_DISTRO melodic
ARG NVDRIVER

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt -q -qq update && \
  DEBIAN_FRONTEND=noninteractive apt install -y \
  software-properties-common \
  wget mesa-utils binutils module-init-tools

RUN curl -sL -o/tmp/NVIDIA-DRIVER.run "http://us.download.nvidia.com/XFree86/Linux-x86_64/$NVDRIVER/NVIDIA-Linux-x86_64-$NVDRIVER.run" && sh /tmp/NVIDIA-DRIVER.run -a -N --ui=none --no-kernel-module
RUN rm /tmp/NVIDIA-DRIVER.run

RUN apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
RUN add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo bionic main" -u
RUN apt -q -qq update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  librealsense2-dkms librealsense2-dev \
  python-rosinstall \
  python-pip \
  python-catkin-tools \
  ros-${ROS_DISTRO}-jsk-tools \
  ros-${ROS_DISTRO}-rgbd-launch \
  ros-${ROS_DISTRO}-image-transport-plugins \
  ros-${ROS_DISTRO}-image-transport \
  qtbase5-dev libqt5svg5-dev libqt5websockets5-dev libqt5opengl5-dev libqt5x11extras5-dev qt5-default \
  libxtst6 xdg-utils

RUN pip install numpy scipy
RUN rosdep update

RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src
COPY --chown=1000:1000 src .

SHELL ["/bin/bash", "-c"]
WORKDIR /catkin_ws
RUN rosdep install --from-paths src --ignore-src -r -y

RUN source /opt/ros/${ROS_DISTRO}/setup.bash; source ./devel/setup.bash; catkin build -j20 -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release

RUN touch /root/.bashrc && \
  echo "source /catkin_ws/devel/setup.bash\n" >> /root/.bashrc
#  echo "rossetip\n" >> /root/.bashrc && \
#  echo "rossetmaster localhost"



RUN curl -sL -o/var/cache/apt/archives/foxglove-studio-0.10.deb https://github.com/foxglove/studio/releases/download/v0.10.2/foxglove-studio-0.10.2-linux-amd64.deb && sudo dpkg -i /var/cache/apt/archives/foxglove-studio-0.10.deb

RUN rm -rf /var/lib/apt/lists/*

COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
