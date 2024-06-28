cl.exe -I. -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/gen/include -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/include/ -IC:/Users/chand/Documents/ecl-24.5.10/msvc/ /TP /EHsc /DGC_DLL /DGC_BUILD /nologo /wd4068 /wd4715 /wd4716 /D_CRT_SECURE_NO_DEPRECATE /DNDEBUG /MD /O2 /O2 /std:c++17 -c ./
libeclcpp.cc -Fo./libeclcpp.dll

cl.exe -I. -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/gen/include -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/include/ -IC:/Users/chand/Documents/ecl-24.5.10/msvc/ /TP /EHsc /DGC_DLL /DGC_BUILD /nologo /wd4068 /wd4715 /wd4716 /D_CRT_SECURE_NO_DEPRECATE /DNDEBUG /MD /O2 /O2 /std:c++17 -c ./libeclcpp.cc /link ./libgodot-cpp.windows.template_debug.x86_64 -Fo./libeclcpp.dll

cl.exe /LDd -I. -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/gen/include -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/include/ -IC:/Users/chand/Documents/ecl-24.5.10/msvc/ /TP /EHsc /DGC_DLL /DGC_BUILD /nologo /wd4068 /wd4715 /wd4716 /D_CRT_SECURE_NO_DEPRECATE /DNDEBUG /MD /O2 /O2 /std:c++17 ./libeclcpp.cc /link libgodot-cpp.windows.template_debug.x86_64.lib ecl.lib /NODEFAULTLIB:LIBCMT


cl.exe /LDd -I. -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/gen/include -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/include/ -IC:/Users/chand/Documents/ecl-24.5.10/msvc/ /TP /EHsc /DGC_DLL /DGC_BUILD /nologo /wd4068 /wd4715 /wd4716 /D_CRT_SECURE_NO_DEPRECATE /DNDEBUG /MT /O2 /O2 /std:c++17 ./libeclcpp.cc /link libgodot-cpp.windows.template_debug.x86_64.lib ecl.lib


cl.exe /LDd -I. -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/gen/include -IC:/Users/chand/Documents/godot-cpp-godot-4.2.2-stable/include/ -IC:/Users/chand/Documents/ecl-24.5.10/msvc/ /TP /EHsc /DGC_DLL /DGC_BUILD /nologo /wd4068 /wd4715 /wd4716 /D_CRT_SECURE_NO_DEPRECATE /MTd /std:c++17 ./libeclcpp.cc lisp_singleton.cpp /link libgodot-cpp.windows.template_debug.dev.x86_64.lib ecl.lib /Fo ./temp/