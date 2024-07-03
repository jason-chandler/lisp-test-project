#include <iostream>
#include <cstdlib>
#include <gdextension_interface.h>
#include <ecl/ecl.h>
#include <lisp_singleton.hpp>

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

// Initialisation does the following
// 1) "Bootstrap" the lisp runtime
// 2) Load an initrc to provide initial
//    configuration for our Lisp runtime
// 3) Make our accessors available to Lisp
// 4) Any In-line Lisp functions for later reference

using namespace godot;
void initialize_ecl_module(ModuleInitializationLevel p_level) {
    if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
        return;
    }

	GDREGISTER_CLASS(LispSingleton);
}
void uninitialize_ecl_module(ModuleInitializationLevel p_level) {
	if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
		return;
	}

}

extern "C" {
// Initialization.

    GDExtensionBool GDE_EXPORT ecl_cpp_init(GDExtensionInterfaceGetProcAddress p_get_proc_address, GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
        godot::GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);

        init_obj.register_initializer(initialize_ecl_module);
        init_obj.register_terminator(uninitialize_ecl_module);
        init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

        return init_obj.init();
    }

}

