# Docker Image for TensorFlow 2.5 Training
# OS must already installed Docker 20, NVIDIA driver 465, CUDA 11.3 and CUDA Toolkit
# Download base image NGC cuda 11.3.1 with cudnn8 run time on Ubuntu 20.04
# Installed with tensorflow_gpu, Anaconda 3 2021.05, Python 3.8, PIP3, jupyter notebook
FROM nvidia/cuda:11.3.1-cudnn8-runtime


# LABEL about this image
LABEL maintainer="ming.sun@zebra.com"
LABEL version="0.2"
LABEL description="This is custom Docker Image for TensorFlow 2.5 Training"

RUN apt-get update && \
    apt-get install -y file wget unzip net-tools sudo && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && yes|apt-get upgrade

# Add user ett with no password, add to sudo group
RUN adduser --disabled-password --gecos '' ett
RUN adduser ett sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ett
WORKDIR /home/ett/
RUN chmod a+rwx /home/ett/

# install python3-venv and python3-dev
RUN sudo apt-get install python3-venv python3-dev -y
RUN sudo apt-get install python3-pip -y


# install TensorFlow 2.5
RUN pip3 install tensorFlow_gpu

# Anaconda installing
RUN wget -P /tmp https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh
RUN bash /tmp/Anaconda3-2021.05-Linux-x86_64.sh -b
RUN rm /tmp/Anaconda3-2021.05-Linux-x86_64.sh


# Set path to conda
#ENV PATH /root/anaconda3/bin:$PATH
ENV PATH /home/ett/anaconda3/bin:$PATH


# Configuring access to Jupyter
RUN mkdir /home/ett/notebooks
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /home/ett/.jupyter/jupyter_notebook_config.py

# Jupyter listens port: 8888
EXPOSE 8888

# Run Jupyter notebook as Docker main process
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/ett/notebooks", "--ip='*'", "--port=8888", "--no-browser"]



