version=3.17
build=1

rm -rf ~/temp_cmake_install

mkdir ~/temp_cmake_install
cd ~/temp_cmake_install
wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
tar -xzvf cmake-$version.$build.tar.gz
cd cmake-$version.$build/

./bootstrap
make -j$(nproc)
sudo make install

# before stepping away
# this script looks good; created disk image on node-0; node-1 cmake doesn't work; extended 5 days

# wait... overnight node-1 cmake --version suddenly works! leaving things here, VM needs a restart
