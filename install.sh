#!/usr/bin/env bash

PREFIX=/unipath/cross-host/lgc-prof/.xopt
echo $PREFIX

mkdir -p ./contrib/build

export fg_bright_yellow='[33m[1m'
export fg_reset='[0m'

echo_hl()
{
  echo -e "${fg_bright_yellow}$@ ${fg_reset}"
}

cwd=$(pwd)
check_done=${cwd}/contrib/build/.check.done
buffer_done=${cwd}/contrib/build/.buffer.done
cork_done=${cwd}/contrib/build/.cork.done

build_autogen()
{
	dir=$1
	cd $dir &&                          \
		./autogen.sh &&                 \
		./configure --prefix=$PREFIX && \
		make -j$(nproc) &&              \
		sudo make install
}

if ! test -f ${check_done}; then
	true &&                                      \
		rm -rf contrib/check/build &&            \
		mkdir -p contrib/check/build &&          \
		cd contrib/check/build &&                \
		cmake .. && make &&                      \
		sudo make install &&                     \
		cd $cwd &&                               \
		echo "build check done ${check_done}" && \
		touch ${check_done}
fi

if ! test -f ${buffer_done}; then
	true &&                                        \
		echo_hl "build buffer" &&                  \
		build_autogen contrib/buffer &&            \
		cd $cwd &&                                 \
		echo "build buffer done ${buffer_done}" && \
		touch ${buffer_done}
fi

if ! test -f ${cork_done}; then
	true &&                                         \
		echo_hl "build libcork" &&                  \
		build_autogen contrib/libcork &&            \
		cd $cwd &&                                  \
		echo_hl "build buffer done ${cork_done}" && \
		touch ${cork_done}
fi
