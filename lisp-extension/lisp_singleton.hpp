// #ifndef TYPED_METHOD_BIND
// #define TYPED_METHOD_BIND
// #endif

#ifndef LISP_SINGLETON_H_
#define LISP_SINGLETON_H_

#include <ecl/ecl.h>
#include <godot_cpp/classes/node3d.hpp>
#include <godot_cpp/variant/array.hpp>
#include <godot_cpp/core/object.hpp>
#include <godot_cpp/classes/rigid_body3d.hpp>
#include <godot_cpp/classes/input_event_key.hpp>

namespace godot {

    extern "C" godot::Variant get_node_by_name(char * name);
    void* get_singleton();
    class LispSingleton : public Node3D {
            GDCLASS(LispSingleton, Node3D);
        private:
            Array keep_alive;

        public:
            LispSingleton();
            ~LispSingleton();
            static void _bind_methods();
            void initialize_lisp();
            void shut_down_lisp();
            bool is_initialized();
            void lisp(godot::String call);
            void lisp_deferred(const std::string & call);
            void run_swank();
            void defer_swank();
            Array get_keep_alive() const;
            void set_keep_alive(const Array &arr);
            void call_to_symbol(godot::String symbol_name, Variant obj, godot::String method_name, const Array &arg_array);
            void* call_deferred_to_symbol(godot::String symbol_name, Variant obj, godot::String method_name, const Array & arg_array);

            Object* pointer_from_symbol(const char * symbol_name);
            void _process(double delta) override;
            virtual void _input(const Ref<InputEvent> &event) override;
            static LispSingleton* singleton;
            static void assign_to_pointer(Callable c, void* ptr);

    };
}
#endif // LISP_SINGLETON_H_
