mkdir ./ErrorReplication && cd ./ErrorReplication
if [[ $(uname) == "Linux" ]]; then
	sudo apt-get update
	sudo apt-get install libtool autoreconf make gcc g++ automake gettext libm clang clang++ cpp gcc-c++
fi
if [ -d ./PinTool-ErrorReplication ]; then
	rm -rf ./PinTool-ErrorReplication
fi
if [ -d ./libzmq ]; then
	rm -rf ./libzmq
fi
if [ ! -d ~/pin-2.13 ]; then
	export PIN_ROOT="$HOME/pin-2.13"
	export TOOLS_ROOT="$PIN_ROOT/source/tools"
	export CONFIG_ROOT="$TOOLS_ROOT/Config"
	echo 'export PIN_ROOT="$HOME/pin-2.13"'
	echo 'export TOOLS_ROOT="$PIN_ROOT/source/tools"'
	echo 'export CONFIG_ROOT="$TOOLS_ROOT/Config"'
	wget http://software.intel.com/sites/landingpage/pintool/downloads/pin-2.13-62732-gcc.4.4.7-linux.tar.gz
	tar -zxf pin-2.13-62732-gcc.4.4.7-linux.tar.gz && rm pin-2.13-62732-gcc.4.4.7-linux.tar.gz
	mv pin-2.13-62732-gcc.4.4.7-linux ~/pin-2.13
	cp ./PinTool-ErrorReplication/makefile.unix.config $CONFIG_ROOT/makefile.unix.config
	current_dir=$(pwd)
	cd ~/pin-2.13/source/tools
	make -j5
	cd $current_dir
	rm pin-2.13-62732-gcc4.4.7-linux.tar.gz
fi
git clone https://github.com/KennethAdamMiller/PinTool-ErrorReplication
git clone https://github.com/KennethAdamMiller/libzmq
cd libzmq
./autogen.sh
print "\n\nconfigure\n\n"
LOCAL_INSTALL_LOCATION=$(pwd)/../PinTool-ErrorReplication
./configure --prefix=$LOCAL_INSTALL_LOCATION CXXFLAGS="-DBIGARRAY_MULTIPLIER=1 -Wall -Werror -Wno-unknown-pragmas -fno-stack-protector -DTARGET_IA32E -DHOST_IA32E -fPIC -DTARGET_LINUX  -I$HOME/pin-2.13/source/include/pin -I$HOME/pin-2.13/source/include/pin/gen -I$HOME/pin-2.13/extras/components/include -I$HOME/pin-2.13/extras/xed2-intel64/include -I$HOME/pin-2.13/source/tools/InstLib -O3 -fomit-frame-pointer -fno-strict-aliasing  -g -std=c++11 -L$HOME/pin-2.13/intel64/lib -L$HOME/pin-2.13/intel64/lib-ext -L$HOME/pin-2.13/intel64/runtime/glibc -L$HOME/pin-2.13/extras/xed2-intel64/lib -lpin -lxed -ldwarf -lelf -ldl"
make clean 
make -j5 install
cd ../PinTool-ErrorReplication
make clean && make -j5
