#include "lisp_singleton.hpp"
#include "ecl/ecl.h"
#include "ecl/external.h"
#include <godot_cpp/core/class_db.hpp>
#include <iostream>

using namespace godot;

LispSingleton* LispSingleton::singleton = nullptr;

void LispSingleton::_bind_methods() {
    ClassDB::bind_method(D_METHOD("initialize_lisp"), &LispSingleton::initialize_lisp);
    ClassDB::bind_method(D_METHOD("shut_down_lisp"), &LispSingleton::shut_down_lisp);
    ClassDB::bind_method(D_METHOD("is_initialized"), &LispSingleton::is_initialized);
    ClassDB::bind_method(D_METHOD("lisp"), &LispSingleton::lisp);
    ClassDB::bind_method(D_METHOD("run_slynk"), &LispSingleton::run_slynk);
    ClassDB::bind_method(D_METHOD("call_to_symbol", "symbol_name", "obj", "method_name", "args"), &LispSingleton::call_to_symbol);
    ClassDB::bind_method(D_METHOD("get_keep_alive"), &LispSingleton::get_keep_alive);
    ClassDB::bind_method(D_METHOD("set_keep_alive", "arr"), &LispSingleton::set_keep_alive);
    ADD_PROPERTY(PropertyInfo(Variant::ARRAY, "keep_alive"), "set_keep_alive", "get_keep_alive");
}

Array LispSingleton::get_keep_alive() const {
	return this->keep_alive;
}

void LispSingleton::set_keep_alive(const Array &arr) {
	this->keep_alive = arr;
}

// Define a function to run arbitrary Lisp expressions
void LispSingleton::lisp(godot::String call) {
    godot::CharString char_string = call.utf8();  // Convert to godot::CharString
    const char* c_string = char_string.get_data();
    //cl_safe_eval(c_string_to_object(c_string), Cnil, Cnil);
    cl_eval(c_string_to_object(c_string));
}

void LispSingleton::lisp_deferred(const std::string & call) {
    godot::String gd_string = godot::String(call.c_str());
    call_deferred("lisp", gd_string);
}

/*
void send_object_to_symbol(godot::String symbol_name, Object* var_ptr) {
    const cl_env_ptr l_env = ecl_process_env();
	ecl_setq(l_env, ecl_make_symbol(symbol_name.utf8(), "GODOT"), ecl_make_unsigned_integer((uintptr_t)var_ptr));
}
*/

void send_object_to_symbol(godot::String symbol_name, Object* var_ptr) {
    const cl_env_ptr l_env = ecl_process_env();
	ecl_setq(l_env, ecl_make_symbol(symbol_name.utf8(), "GODOT"), ecl_make_pointer(var_ptr));
}

void LispSingleton::call_to_symbol(godot::String symbol_name, Variant var, godot::String method_name, const Array &arg_array) {
	Callable method = Callable(var, method_name);
	Variant result = method.callv(arg_array);
	Object* obj = (Object*)result;
	//send_object_to_symbol(symbol_name, obj);
	send_object_to_symbol(symbol_name, &(*obj));
}

Object* LispSingleton::pointer_from_symbol(const char * symbol_name) {
	cl_object sym = ecl_make_symbol(symbol_name, "GODOT");
	cl_object sym_value = cl_symbol_value(sym);
	uintptr_t uintptr = ecl_to_unsigned_integer(sym_value);
	Object* result = reinterpret_cast<Object*>(uintptr);
	return result;
}

void* LispSingleton::call_deferred_to_symbol(godot::String symbol_name, Variant obj, godot::String method_name, const Array & arg_array) {
    cl_object sym = ecl_make_symbol(symbol_name.utf8(), "GODOT");
    cl_set(sym, Cnil);
    this->call_deferred("call_to_symbol", symbol_name, obj, method_name, arg_array);
    cl_object lisp_result = cl_symbol_value(sym);
    std::cout << (lisp_result == Cnil) << std::endl;
    while(lisp_result == Cnil) {
        lisp_result = cl_symbol_value(sym);
    }
    std::cout << lisp_result << std::endl;
    std::cout << (uintptr_t)lisp_result << std::endl;
    return lisp_result;
}

void LispSingleton::run_slynk() {
    int booted = (int)ecl_get_option(ECL_OPT_BOOTED);
    if(booted == 1) {
        const cl_env_ptr l_env = ecl_process_env();
        ecl_disable_interrupts_env(l_env);

        CL_CATCH_ALL_BEGIN(l_env) {
            CL_UNWIND_PROTECT_BEGIN(l_env) {
                std::cout << "\nStarting Slynk.\n";

                // set up the in/out filestream:
                ecl_setq(ecl_process_env(),
                         ecl_make_symbol("*STANDARD-OUTPUT*", "COMMON-LISP"),
                         ecl_make_stream_from_FILE(
                             ecl_make_constant_base_string("stdout",
                                                           -1), /* file name */
                             stdout,         /* pointer to FILE struct */
                             ecl_smm_output, /* stream mode */
                             8,              /* byte-size */
                             0,              /* default flags */
                             ecl_make_keyword("UTF-8")));
                /* external-format: utf-8 */


                si_safe_eval(3, ecl_read_from_cstring("(require :cmp)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(setq C:*USER-CC-FLAGS* \" -std=c++17 -fpermissive -I/home/jason/godot-projects/lisp-test-project/lisp-extension -isystem /home/jason/godot-cpp/include -isystem /home/jason/godot-cpp/gen/include -isystem /home/jason/godot-cpp/gdextension \")"),
                                                      (cl_object)l_env,
                                                      ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(setq C:*user-linker-libs* \"-L/home/jason/godot-projects/lisp-test-project/lisp-extension -Wl,-rpath,/home/jason/godot-projects/lisp-test-project/lisp-extension  -leclcpp.linux.debug.x86_64 /home/jason/godot-projects/lisp-test-project/lisp-extension/libgodot-cpp.linux.template_debug.dev.x86_64.a\")"),
                                                      (cl_object)l_env,
                                                      ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(require :ecl-quicklisp)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk)"), (cl_object)l_env, ecl_make_fixnum(1));

                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk-quicklisp)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk-macrostep)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk-asdf)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk-indentation)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk-stickers)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk-trace-dialog)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(ql:quickload :slynk-stepper)"), (cl_object)l_env, ecl_make_fixnum(1));
                si_safe_eval(3, ecl_read_from_cstring("(slynk:create-server)"), (cl_object)l_env, ecl_make_fixnum(1));

                std::cout << "\nSlynk has been started.\n";
            }
            CL_UNWIND_PROTECT_EXIT {}
            CL_UNWIND_PROTECT_END;
        }
        CL_CATCH_ALL_END;
    } else {
        std::cout << "\nCannot start Slynk: Lisp is not booted.\n";
    }
}

void LispSingleton::defer_slynk() {
    call_deferred("run_slynk");
}

static const char* _argv_[] = {"GODOT"};

extern "C" godot::Variant get_node_by_name(char * name) {
	godot::String converted_name = name;
    return (LispSingleton::singleton)->call_deferred("get_node", converted_name);
}

void LispSingleton::initialize_lisp() {
	LispSingleton::singleton = this;
	keep_alive = Array();
	keep_alive.resize(100);
    int booted = (int)ecl_get_option(ECL_OPT_BOOTED);
    if(booted == 0) {
        std::cout << "\nBooting Embeddable Common Lisp...\n";

        cl_boot(1, (char**)_argv_);
        const char* lisp_booted_p = ((int)ecl_get_option(ECL_OPT_BOOTED) == 1 ? "T" : "NIL");
        std::cout << "\nlisp-booted-p => " << lisp_booted_p << std::endl;
        this->lisp("(defpackage :godot (:use :cl))");
        this->lisp("(in-package :godot)");
    }
}

void LispSingleton::shut_down_lisp() {
    int booted = (int)ecl_get_option(ECL_OPT_BOOTED);
    if(booted == 1) {
        std::cout << "\nShutting down Embeddable Common Lisp...\n";

        cl_shutdown();
        std::cout << "Shut down complete.";
    }
}

LispSingleton::LispSingleton() {
}

LispSingleton::~LispSingleton() {
    call_deferred("shut_down_lisp");
}

void LispSingleton::_process(double delta) {

}

bool LispSingleton::is_initialized() {
    return (bool)ecl_get_option(ECL_OPT_BOOTED);
}
