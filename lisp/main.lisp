;; main.lisp

(defun get-node->symbol-impl (name symbol)
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:clines "using namespace godot;")
  (let ((sym-name (symbol-name symbol)))
    (ffi:c-inline (name sym-name) (:cstring :cstring) :pointer-void
                "Array arr = Array();
                 arr.resize(1);
                 arr[0] = #0;
                 LispSingleton::singleton->call_deferred_to_symbol(#1, LispSingleton::singleton, \"get_node\", arr);")))

(defmacro get-node->symbol (name symbol)
  `(get-node->symbol-impl ,name ',symbol))

(defun get-node (name)
  (get-node->symbol-impl name (gensym)))

(get-node->symbol "cam" camera)

(defun get-node (name)
  (ffi:clines "#include <godot_cpp/classes/object.hpp>")
  (ffi:clines "#include <godot_cpp/classes/node.hpp>")
  (ffi:clines "#include <iostream>")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline (name) (:cstring) :pointer-void
                "LispSingleton::singleton->call_deferred(\"get_node\", #0)
                 Node* node = Object::cast_to<Node>(obj);
                 std::cout << String(node->get_name()).utf8() << std::endl;"))

(defun get-name (ptr)
  (ffi:clines "#include <godot_cpp/classes/object.hpp>")
  (ffi:clines "#include <godot_cpp/classes/node.hpp>")
  (ffi:clines "using namespace godot;")
   (ffi:c-inline (ptr) (:pointer-void) :object
                "
                 Node* node = Object::cast_to<Node>(reinterpret_cast<Object*>(#0));

                 String str_name = String(node->get_name());
                 CharString utf8_name = str_name.utf8();
                 const char* name = utf8_name.get_data();
                 char* dynamic_name = new char[(strlen(name))];
                 strcpy(dynamic_name, name);
                 std::cout << name << std::endl;
                 cl_object lisp_string = ecl_make_constant_base_string(dynamic_name, -1);
                 return lisp_string;"))
(get-name camera)
(princ camera)
(pointer-to-object camera)
