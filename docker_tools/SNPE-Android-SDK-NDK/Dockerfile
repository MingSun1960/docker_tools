FROM ubuntu:18.04

MAINTAINER Ming Sun <ming.sun@zebra.com>

# LABEL about this image
LABEL maintainer="ming.sun@zebra.com"
LABEL version="3"
LABEL description="This is custom Docker Image for SNPE 1.42 with Android Studio and SSH"

ARG USER=android

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
        build-essential git neovim wget unzip sudo cython zip\
        libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386 \
        libxrender1 libxtst6 libxi6 libfreetype6 libxft2 software-properties-common\
        qemu qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils libnotify4 libglu1 libqt5widgets5 openjdk-8-jdk xvfb \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Install Python 3.5
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt-get install python3.5 -y

RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1

#Install python3-venv and python3-dev python3-pip
RUN apt-get install python3-venv python3-dev -y
RUN apt install python3-pip -y
RUN apt install xauth xterm -y
RUN pip3 install --upgrade pip

#Install SNPE required Python packages
RUN pip3 install numpy==1.16.5
RUN pip3 install sphinx==2.2.1
RUN pip3 install scipy==1.3.1
RUN pip3 install matplotlib==3.0.3
RUN pip3 install scikit-image==0.15.0
RUN pip3 install protobuf==3.6.0
RUN pip3 install pyyaml==5.1
RUN pip3 install mako

RUN pip3 install tensorflow==2.3

RUN groupadd -g 1000 -r $USER
RUN useradd -u 1000 -g 1000 --create-home -r $USER
RUN adduser $USER libvirt
RUN adduser $USER kvm
#Change password
RUN echo "$USER:$USER" | chpasswd
#Make sudo passwordless
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-$USER
RUN usermod -aG sudo $USER
RUN usermod -aG plugdev $USER


# Add user to sudo group for ssh: ming, zhijia, kui
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ett
RUN echo 'ett:ett' | chpasswd 

#Install Android Studio
RUN mkdir /studio-data
VOLUME /studio-data
RUN chown $USER:$USER /studio-data

COPY provisioning/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
COPY provisioning/ndkTests.sh /usr/local/bin/ndkTests.sh
RUN chmod +x /usr/local/bin/*
COPY provisioning/51-android.rules /etc/udev/rules.d/51-android.rules

# install SSH
RUN apt-get install openssh-server -y
# Configure SSHD.
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN mkdir /var/run/sshd
RUN bash -c 'install -m755 <(printf "#!/bin/sh\nexit 0") /usr/sbin/policy-rc.d'
RUN ex +'%s/^#\zeListenAddress/\1/g' -scwq /etc/ssh/sshd_config
RUN ex +'%s/^#\zeHostKey .*ssh_host_.*_key/\1/g' -scwq /etc/ssh/sshd_config
RUN RUNLEVEL=1 dpkg-reconfigure openssh-server
RUN ssh-keygen -A -v
RUN update-rc.d ssh defaults


EXPOSE 22


USER $USER

WORKDIR /home/$USER

ARG ANDROID_STUDIO_URL=https://dl.google.com/dl/android/studio/ide-zips/4.2.2.0/android-studio-ide-202.7486908-linux.tar.gz
ARG ANDROID_STUDIO_VERSION=4.2.2.0
#ARG ANDROID_STUDIO_URL=https://dl.google.com/dl/android/studio/ide-zips/4.2.1.0/android-studio-ide-202.7351085-linux.tar.gz
#ARG ANDROID_STUDIO_VERSION=4.2.1.0

# instal Android studio
RUN wget "$ANDROID_STUDIO_URL" -O android-studio.tar.gz
RUN tar xzvf android-studio.tar.gz
RUN rm android-studio.tar.gz

RUN ln -s /studio-data/profile/AndroidStudio$ANDROID_STUDIO_VERSION .AndroidStudio$ANDROID_STUDIO_VERSION
RUN ln -s /studio-data/Android Android
RUN ln -s /studio-data/profile/android .android
RUN ln -s /studio-data/profile/java .java
RUN ln -s /studio-data/profile/gradle .gradle
ENV ANDROID_EMULATOR_USE_SYSTEM_LIBS=1

#Ubuntu18.04 installation of Android Studio does not include the sdk tools commandline.  Do it manually
#ENV ANDROID_HOME="./Android"
#RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip
#RUN unzip -X sdk-tools.zip && rm sdk-tools.zip
#RUN sudo mkdir -p /studio-data/Android/Sdk/tools
#RUN sudo mv cmdline-tools /studio-data/Android/Sdk/tools/
#ENV PATH="${ANDROID_HOME}/Sdk/tools/bin:${PATH}"

#Add SNPE SDK folder.  Change the version name here
curl -H "Authorization: Bearer ya29.A0ARrdaM9NskdJyi1oxJFmcYkBRIm5tUadYKIRy36jA8lQdU3MsrA_dTxwRTzBr7AXl5fvzxVLGykvsePkk0mDFoYVN1GsMaYUyrfUuPPIlOAc8C1XeEmk3aZBDzrfJ9EdplFC0QgVTgjDnOr_6xvNl3PxYQTq" "https://storage.googleapis.com/storage/v1/b/snpe-libs-for-docker/o/snpe-1.41.0.zip?alt=media" output snpe-1.41.0.zip
RUN unzip -X snpe-1.41.0.zip 
RUN rm snpe-1.41.0.zip snpe-1.41.0.split.*
#RUN /bin/bash -c 'source /home/$USER/snpe-1.41.0.2173/bin/envsetup.sh -t /usr/local/lib/python3.6/dist-packages/'


WORKDIR /home/$USER

#Downlaod NDK and set up ANDROID_NDK_ROOT
#RUN yes | sudo /studio-data/Android/Sdk/tools/bin/sdkmanager --install 'ndk;22.1.7171670' --sdk_root="${ANDROID_HOME}/Sdk/"
#Set up environment for tensorflow
#ENV ANDROID_NDK_ROOT="${ANDROID_HOME}/Sdk/ndk/22.1.7171670"


#Not automatically start studio.sh in docker_entrypoint.sh
#ENTRYPOINT [ "/usr/local/bin/docker_entrypoint.sh" ]

CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D", "-o", "ListenAddress=0.0.0.0"]
