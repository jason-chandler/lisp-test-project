#ifndef TYPED_METHOD_BIND
#define TYPED_METHOD_BIND
#endif

#ifndef LISP_SINGLETON_H_
#define LISP_SINGLETON_H_

#include <godot_cpp/classes/node.hpp>

namespace godot {

    class LispSingleton : public Node {
            GDCLASS(LispSingleton, Node);

        private:
            int initialized;

        public:
            LispSingleton();
            ~LispSingleton();
            static void LispSingleton::_bind_methods();
            virtual void initialize_lisp();
            virtual void shut_down_lisp();
            void _process(double delta) override;
    
    };
}
#endif // LISP_SINGLETON_H_
