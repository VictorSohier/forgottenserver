#!/bin/bash

# This exists because I was having difficulties with cmake and dependency
# management. I was at the point where just writing out the compilation commands
# myself would've been easier. See the ancient version requirement for libfmt
PROJ_NAME=tfs
CCOMPILER=clang
CXXCOMPILER=clang++
COMMONCXXFLAGS=" \
src/*.cpp \
-include-pch src/otpch.h.pch \
-I/usr/local/include \
-l:libfmt.so.6.1.2 \
-lboost_date_time \
-lboost_system \
-lboost_filesystem \
-lboost_iostreams \
-lcryptopp \
-lm \
-lpthread \
-llua \
-lluajit-5.1 \
-lpugixml \
-lmariadb \
-std=c++17 \
-save-temps=obj \
"
DEBUGCXXFLAGS=" \
-glldb \
-O0 \
"
RELEASECXXFLAGS=" \
-O2 \
-DNDEBUG \
"
#FILES=$(find src -name "**.c" | xargs -d "\n" realpath | tr "\n" " ")

mkdir -p build/{debug,release}/{bin,obj}

case $1 in
	"ccommands")
		echo "[$(
			eval "$CXXCOMPILER -MJ /dev/stdout -o /dev/null $COMMONCXXFLAGS $DEBUGCXXFLAGS $FILES" 2> /dev/null
		)]" > build/compile_commands.json
		;;
	"debug")
		eval "$CXXCOMPILER $COMMONCXXFLAGS -o build/$1/obj/$PROJ_NAME $DEBUGCXXFLAGS $FILES"
		mv build/$1/obj/$PROJ_NAME build/$1/bin/$PROJ_NAME
		;;
	"release")
		eval "$CXXCOMPILER $COMMONCXXFLAGS -o build/$1/obj/$PROJ_NAME $RELEASECXXFLAGS $FILES"
		mv build/$1/obj/$PROJ_NAME build/$1/bin/$PROJ_NAME
		;;
	"clean")
		rm -rf build
		;;
esac
