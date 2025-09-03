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
	done_file=$2
	if test -f $done_file; then
		echo_hl "${dir} has been installed"
	else

		true &&                                      \
			echo_hl "build ${dir}" &&                \
			cd $dir &&                               \
			./autogen.sh &&                          \
			./configure --prefix=$PREFIX &&          \
			make -j$(nproc) &&                       \
			sudo make install &&                     \
			cd $cwd &&                               \
			echo_hl "build ${done_file}" && \
			touch $done_file
	fi
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

build_autogen ./contrib/buffer ${buffer_done}
build_autogen ./contrib/libcork ${cork_done}
