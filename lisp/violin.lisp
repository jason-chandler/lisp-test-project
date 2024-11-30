;; violin.lisp

;; (require :ecl-quicklisp)

;; (ql:quickload :slynk)

;; (setq C:*USER-CC-FLAGS* " -std=c++17 -fpermissive -I/home/jason/godot-projects/lisp-test-project/lisp-extension -isystem /home/jason/godot-cpp/include -isystem /home/jason/godot-cpp/gen/include -isystem /home/jason/godot-cpp/gdextension ")
;; (setq C:*user-linker-libs* "-L/home/jason/godot-projects/lisp-test-project/lisp-extension -Wl,-rpath,/home/jason/godot-projects/lisp-test-project/lisp-extension  -leclcpp.linux.debug.x86_64 /home/jason/godot-projects/lisp-test-project/lisp-extension/libgodot-cpp.linux.template_debug.dev.x86_64.a")


(setq C:*user-linker-libs* "-L/home/jason/godot-projects/lisp-test-project/src -L/home/jason/godot-projects/lisp-scons-test-project/bin/linux -Wl,-rpath,/home/jason/godot-projects/lisp-scons-test-project/bin/linux  -lecl-cpp.linux.template_debug.x86_64 /home/jason/godot-projects/lisp-scons-test-project/godot-cpp/bin/libgodot-cpp.linux.template_debug.dev.x86_64.a")
libecl-cpp.linux.template_debug.x86_64.so
ecl-cpp.linux.debug.x86_64
;;(setq C::*cc-flags* " -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -g -O2 -fPIC -D_THREAD_SAFE  -Dlinux ")
;;(setq C::*cc-flags* " -g -fPIC ")

(defun test-godot ()
  (ffi:clines "#include <iostream>")
  (ffi:c-inline () () :void "std::cout << \"hello, buns!\" << std::endl;" :one-liner t))

(test-godot)

(defparameter *singleton* nil)

(defun initialize-godot-symbols ()
  (labels ((fetch-singleton ()
             (ffi:clines "#include \"lisp_singleton.hpp\"")
             (ffi:clines "using namespace godot;")
             (ffi:c-inline () () :pointer-void "@(return)=LispSingleton::singleton;")))
  (setq *singleton* (fetch-singleton))))

(initialize-godot-symbols)

(defun get-name (obj)
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline (obj) (:pointer-void) :cstring
                "String c = ((Node*)(#0))->get_name();
                 (@(return) = c.utf8().ptr());"))

(get-name *singleton*)

(defparameter **)


(defun inp (event)
  (ffi:clines "#include <"))
(setf *input* (list (lambda (event) (princ event))))


(defun defer-to-pointer (obj fun-name)
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:clines "using namespace godot;")
  (let ((ptr (ffi:c-inline (obj fun-name) (:pointer-void :cstring) :pointer-void
                "Object* o;
                 Callable c = Callable(#0, #1);
                 LispSingleton::singleton->call_deferred(\"assign_to_pointer\", c, o);
                 (@(return) = (void*)(&(*o));")))
  (loop :for i :from 0 :until (not (eql (ffi:pointer-address ptr) (ffi:pointer-address (ffi:make-null-pointer :void)))))
  ptr))

(defer-to-pointer *singleton* "get_name")

(defun get-node (name)
  )







(defun check-for-child (name)
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:clines "#include <godot_cpp/classes/os.hpp>")
  (ffi:clines "#include <godot_cpp/variant/variant.hpp>")
  (ffi:c-inline (name) (:cstring) :void
                "
                 std::cout << \"test \" << #0 << std::endl;
                 //godot::NodePath path = godot::NodePath(#0);
                 //godot::Callable call = godot::Callable(godot::LispSingleton::self, \"get_node\").bind(path);
                 //godot::TypedArray<godot::NodePath> arg1 = godot::TypedArray<godot::NodePath>(path);
                 //godot::Variant var = call.callv(arg1);
                 //godot::Variant var = call.call();
                 //godot::Node* node = godot::Object::cast_to<godot::Node>(var);


                 godot::Array args = godot::Array();

                 //godot::Callable callable = godot::Callable(node, \"get_name\");
                 //godot::Variant var2 = callable.callv(args);
                 //godot::String str = godot::String(var2);
                 godot::String str = godot::String(godot::LispSingleton::self->call_deferred_thread_group(\"get_name\"));
                 std::cout << str.utf8() << std::endl;

                 //node->call_deferred(\"get_name\");
                 //godot::CharString chstr = str.utf8();
                 //cl_object retval = ecl_decode_from_cstring(chstr.get_data(), -1, Cnil);
                 //return retval;"
                ))

(defpackage :godot
  (:use :cl))
GODOT::CAMERA
(defun check ()
  (ffi:clines "#include <iostream>")
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:c-inline () () :void
                "cl_object lisp_ptr = cl_symbol_value(ecl_make_symbol(\"CAMERA\", \"GODOT\"));
                 uintptr_t int_ptr = ecl_to_unsigned_integer(lisp_ptr);
                 godot::Object* obj = reinterpret_cast<godot::Object*>(int_ptr);
                 //godot::Node* node = godot::Object::cast_to<godot::Node>(godot::LispSingleton::self->get_keep_alive()[0]);
                 godot::Node* node = godot::Object::cast_to<godot::Node>(obj);
                 std::cout << (uintptr_t)node << std::endl;
                 godot::StringName str = node->get_name();
                 std::cout << godot::String(str).utf8() << std::endl;
                 "))
(check)

(defun check ()
  (ffi:clines "#include <iostream>")
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:c-inline () () :void
                "godot::Object* obj = godot::LispSingleton::self->pointer_from_symbol(\"CAMERA\");
                 godot::Node* node = godot::Object::cast_to<godot::Node>(obj);
                 godot::String str = godot::String(node->get_name());
                 std::cout << \"fff\" << std::endl;
                 std::cout << str.utf8() << std::endl;
                 std::cout << \"fff\" << std::endl;
                 "))




(check)
(defun assign (name)
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:c-inline (name) (:cstring) :void
                "cl_env_ptr env = ecl_process_env();
                 void* ptr = &godot::LispSingleton::singleton->get_name();
                 ecl_setq(env, ecl_make_symbol(#0, \"GODOT\"), (intptr_t)ptr);"
                ))

GODOT::upchuck
(assign "UPCHUCK")
(princ godot::camera)
godot::camera
(check-for-child "cam")
(check-for-child "Camera3D/RigidBody3D2")
