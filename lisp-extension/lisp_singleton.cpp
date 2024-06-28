#include "lisp_singleton.hpp"
#include <godot_cpp/core/class_db.hpp>
#include <ecl/ecl.h>
#include <iostream>

using namespace godot;

void LispSingleton::_bind_methods() {
    ClassDB::bind_method(D_METHOD("initialize_lisp"), &LispSingleton::initialize_lisp);
}
// // Define a function to run arbitrary Lisp expressions
// cl_object lisp(const std::string & call) {
//     return cl_safe_eval(c_string_to_object(call.c_str()), Cnil, Cnil);
// }

void LispSingleton::initialize_lisp() {
    int booted = (int)ecl_get_option(ECL_OPT_BOOTED);
    if(booted == 0) {
        std::cout << "\nBooting...\n";

        char arg0[] = "app";
        char* argv[] = { arg0, nullptr };  // argv array with "app" and a NULL terminator
        cl_boot(1, argv);
        std::cout << "Booted. " << (int)ecl_get_option(ECL_OPT_BOOTED);
    }
}

void LispSingleton::shut_down_lisp() {
    int booted = (int)ecl_get_option(ECL_OPT_BOOTED);
    if(booted == 1) {
        std::cout << "\nShutting down...\n";

        cl_shutdown();
        std::cout << "Shut down complete.";
    }
}

LispSingleton::LispSingleton() {
    call_deferred("initialize_lisp");
}

LispSingleton::~LispSingleton() {
    call_deferred("shutdown_down_lisp");
}

void LispSingleton::_process(double delta) {

}
