#!/bin/sh
#
# g++ -std=c++17 -L. -Wl,-rpath,. -shared libeclcpp.cpp lisp*.cpp -g -fPIC -I. -isystem ~/godot-cpp/include -isystem ~/godot-cpp/gen/include -isystem ~/godot-cpp/gdextension -isystem ~/ecl-24.5.10/build -fpermissive -lecl libgodot-cpp.linux.template_debug.x86_64.a -o libeclcpp.linux.debug.x86_64.so
# g++ -std=c++17 -L. -Wl,-rpath,. -shared libeclcpp.cpp lisp*.cpp -g -fPIC -I. -isystem ~/godot-cpp/include -isystem ~/godot-cpp/gen/include -isystem ~/godot-cpp/gdextension -isystem ~/ecl-24.5.10/build -fpermissive -lecl libgodot-cpp.linux.debug.64.a -O0 -o libeclcpp.linux.debug.x86_64.so

g++ -std=c++17 -L. -Wl,-rpath,. -shared libeclcpp.cpp lisp*.cpp -g -fPIC \
    -I. -isystem ~/godot-cpp/include -isystem ~/godot-cpp/gen/include \
    -isystem ~/godot-cpp/gdextension -isystem ~/ecl-24.5.10/build \
    -fpermissive -lecl \
    -Wl,--whole-archive libgodot-cpp.linux.debug.64.a -Wl,--no-whole-archive \
    -O0 -o libeclcpp.linux.debug.x86_64.so


# g++ -std=c++17 -L. -Wl,-rpath,. -shared libeclcpp.cpp lisp*.cpp -g -fPIC \
#     -I. -isystem ~/godot-cpp/include -isystem ~/godot-cpp/gen/include \
#     -isystem ~/godot-cpp/gdextension -isystem ~/ecl-24.5.10/build \
#     -fpermissive -lecl \
#     -Wl,--whole-archive libgodot-cpp.linux.debug.64.a -Wl,--no-whole-archive \
#     -Wl,--version-script=hidden_symbols.map \
#     -O0 -o libeclcpp.linux.debug.x86_64.so
