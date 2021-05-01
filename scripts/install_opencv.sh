#!/bin/sh

echo_blue "installing dependencies for openCV"

CUR_DIR="$(pwd)"

# required dependencies before running this file include:
# build-essential cmake git python-dev python-numpy
# (these should already be installed from previous install scripts)

# other dependencies before installing openCV
sudo apt install -y libopenblas-dev liblapacke-dev tesseract-ocr libtesseract-dev
sudo apt install -y ocl-icd-libopencl1 opencl-headers clinfo
sudo apt install -y libgtk-3-dev pkg-config libavcodec-dev libavformat-dev
sudo apt install -y libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev
sudo apt install -y libtiff-dev libjasper-dev libdc1394-22-dev ffmpeg
sudo apt install -y libv41-dev libxvidcore-dev libx264-dev hdf5-tools
sudo apt install -y libatlas-base-dev gfortran libhdf5-serial-dev
sudo apt install -y libeigen-stl-containers-dev libavresample-dev
sudo apt install -y libprotobuf-dev libgtkglext1-dev libceres-dev libcaffe-cuda-dev
sudo apt install -y libleptonica-dev libboost-all-dev libtbb-dev ocl-icd-opencl-dev
sudo apt install -y coinor-libclp-dev libogre-1.9-dev ogre-1.9-tools ocl-icd-dev
# sudo apt install libvtk7-dev (broken - ROS uses vtk6)

echo_blue "updating/upgrading apt"

sudo apt update
sudo apt upgrade

echo_blue "downloading most recent openCV tag"

# fix header file sourcing location issues with OpenBLAS
sudo ln -s /usr/include/x86_64-linux-gnu/cblas.h /usr/include/cblas.h

### Uncomment lines below if you want to install the extra modules
mkdir ~/software/OpenCV
cd ~/software/OpenCV
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
git clone https://github.com/opencv/opencv_extra.git
cd opencv
git checkout $(curl --silent "https://api.github.com/repos/opencv/opencv/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
cd ../opencv_contrib
git checkout $(curl --silent "https://api.github.com/repos/opencv/opencv/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
cd ../opencv_extra
git checkout $(curl --silent "https://api.github.com/repos/opencv/opencv/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
cd ..

## for real sense camera
## librealsense with apt
#sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE
#sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u
#sudo apt install librealsense2-dkms librealsense2-utils librealsense2-dev librealsense2-dbg

## OR librealsense from source
#git clone https://github.com/IntelRealSense/librealsense.git
#cd librealsense
#git co $(curl --silent "https://api.github.com/repos/IntelRealSense/librealsense/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
# [figure out how to build]

echo_blue "installing openCV, this may take a while"

cd opencv
mkdir build && cd build
if ls /usr/local | grep -q "cuda"; then
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=/usr/local/opencv \
            -D WITH_CUDA=ON \
            -D ENABLE_FAST_MATH=1 \
            -D CUDA_FAST_MATH=1 \
            -D WITH_CUBLAS=1 \
            -D INSTALL_PYTHON_EXAMPLES=OFF \
            -D ENABLE_PRECOMPILED_HEADERS=OFF \
            -D WITH_OPENMP=ON \
            -D WITH_NVCUVID=ON \
            -D OPENCV_EXTRA_MODULES_PATH=~/software/OpenCV/opencv_contrib/modules \
            -D BUILD_opencv_cudacodec=OFF \
            -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
            -D BUILD_USE_SYMLINKS=ON \
            -D BUILD_PERF_TESTS=OFF \
            -D BUILD_TESTS=OFF \
            -D BUILD_JAVA=OFF \
            -D BUILD_PROTOBUF=ON \
            -D BUILD_opencv_java_bindings_gen=OFF \
            -D BUILD_opencv_cnn_3dobj=OFF \
            -D WITH_GDAL=ON \
            -D WITH_CLP=ON \
            -D Tesseract_INCLUDE_DIR=/usr/include/tesseract \
            -D Tesseract_LIBRARY=/usr/lib/x86_64-linux-gnu/libtesseract.so \
            -D OpenBLAS_LIB=/usr/lib/x86_64-linux-gnu/openblas/libblas.so \
            -D WITH_OPENGL=ON \
            -D WITH_VULKAN=ON \
            -D PYTHON3_INCLUDE_DIR2=~/.local/include/python3.6m \
            -D INSTALL_C_EXAMPLES=OFF \
            -D OPENCV_ENABLE_NONFREE=ON \
            -D BUILD_EXAMPLES=OFF \
            .. > cmake_log.txt 2>&1
    cmake -DOPENCV_PYTHON3_VERSION=ON .. >> cmake_log.txt 2>&1
else
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
            -D CMAKE_INSTALL_PREFIX=/usr/local/opencv \
            -D INSTALL_PYTHON_EXAMPLES=OFF \
            -D INSTALL_C_EXAMPLES=OFF \
            -D OPENCV_ENABLE_NONFREE=ON \
            -D BUILD_EXAMPLES=OFF \
            -D OPENCV_EXTRA_MODULES_PATH=~/software/OpenCV/opencv_contrib/modules \
            .. > cmake_log.txt 2>&1
fi

if grep -q 'Configuring done' cmake_log.txt; then
    echo_green "cmake configuration finished"
    make -j8
    sudo make install
    sudo ldconfig
    echo_green "openCV was installed"
else
    echo_red "[ERROR] cmake configuration failed"
    cat cmake_log.txt
fi

cd $CUR_DIR
