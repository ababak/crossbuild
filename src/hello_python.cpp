// hello_python.cpp

#include <iostream>
#include <boost/python.hpp>

void say_hello()
{
    std::cout << "Hello, Python!\n";
}

BOOST_PYTHON_MODULE(hello_python) // Name here must match the name of the final shared library, i.e. hello_python.dll or hello_python.so
{
    boost::python::def("say_hello", &say_hello);
}
