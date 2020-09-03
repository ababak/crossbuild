#
# Author:
# Andriy Babak <ababak@gmail.com>
#
# Build the docker image:
# docker build --rm -t crossbuild .
#
# Run the shell:
# docker run --rm -it -v "$(pwd):/work" crossbuild:latest bash
#
# Compile:
# docker run --rm -it -v "$(pwd):/work" crossbuild:latest bash -c '$CXX hello_python.cpp -shared -lboost_python27 -lpython27 -o hello_python.pyd' 
#
# See README.md for details

FROM dockcross/windows-static-x64

LABEL maintainer="ababak@gmail.com"

ENV COMPILEDIR /compile
ENV INSTALLDIR /usr/src/mxe/usr/${CROSS_TRIPLE}
ENV WINDRES /usr/src/mxe/usr/bin/${CROSS_TRIPLE}-windres

RUN mkdir -p ${COMPILEDIR} && cd ${COMPILEDIR} && wget -O - https://downloads.sourceforge.net/project/boost/boost/1.70.0/boost_1_70_0.tar.gz  | tar xz
WORKDIR ${COMPILEDIR}/boost_1_70_0

RUN echo "using gcc : mingw32 : ${CROSS_TRIPLE}-g++ ;"  > user-config.jam
RUN ./bootstrap.sh
ADD ./Python27/include/* /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/
ADD ./Python27/libs/* /usr/src/mxe/usr/x86_64-w64-mingw32.static/lib/
RUN ./b2 --user-config=user-config.jam cxxflags="-DMS_WIN64" toolset=gcc-mingw32 cxxstd=11 target-os=windows variant=release address-model=64 binary-format=pe threadapi=win32 threading=multi link=static --prefix=${INSTALLDIR} install

# Make some symlinks as workaround for Linux filename case sensitivity vs Windows
RUN ln -s /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/winsock2.h /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/Winsock2.h \
    && ln -s /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/shlwapi.h /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/Shlwapi.h   \
    && ln -s /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/windows.h /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/Windows.h   \
    && ln -s /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/accctrl.h /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/AccCtrl.h   \
    && ln -s /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/aclapi.h /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/Aclapi.h     \
    && ln -s /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/ws2tcpip.h /usr/src/mxe/usr/x86_64-w64-mingw32.static/include/WS2tcpip.h

RUN ls -la /usr/src/mxe/usr/x86_64-w64-mingw32.static/lib/libboost_*

WORKDIR /work
