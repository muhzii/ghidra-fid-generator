#!/bin/bash

if [[ $# -ne 2 ]] && [[ $# -ne 3 ]]; then
	echo "usage: ${0} <libpath> <libversion> [libvariant]"
	exit 1
fi

libpath="${1}"
libpath=$(realpath ${libpath})
version="${2}"
variant="${3}"
if [ "$variant" == "" ]; then
    variant="none"
fi

libname=$(basename ${libpath})
rm -f ./fidb/*${libname%.*}*

root_lib_path="lib/${libname%.*}"
extracted_lib_path="${root_lib_path}/${libname%.*}/$version/$variant"
mkdir -p extracted_lib_path

if ! 7z -y x ${libpath} -o"${extracted_lib_path}";  then
    echo "7z failed" && exit 1
fi

./03-ghidra-import.sh $(realpath ${root_lib_path})
./04-checklog.sh $(realpath ${root_lib_path})
./05-ghidra-fidb.sh $(realpath ${root_lib_path})
