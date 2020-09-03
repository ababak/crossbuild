# crossbuild
Build Windows targets inside the Linux container.

## Prepare the image

    docker build --rm -t crossbuild .

## Run the interactive shell

    docker run --rm -it -v "$(pwd):/work" crossbuild:latest bash

## Build the Python module

    cd src
    docker run --rm -it -v "$(pwd):/work" crossbuild:latest bash -c '$CXX -DBOOST_PYTHON_STATIC_LIB hello_python.cpp -shared -lboost_python27 -lpython27 -o hello_python.pyd'
