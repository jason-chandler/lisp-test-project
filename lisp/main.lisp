;; main.lisp
(in-package :godot)
(ql:quickload :cffi)
(ql:quickload :claw)
(compile-file "../lisp/x86_64-pc-linux-gnu.lisp")

(%aw-godot::make-+)
(defparameter *my-vec3* (iffi:make-intricate-instance '%aw-godot::+quaternion))
(cffi:foreign-alloc '%aw-godot::+animatable-body3d)

(defparameter *quat* (iffi:intricate-alloc '%aw-godot::+quaternion))
(defparameter *vec* (iffi:intricate-alloc '%aw-godot::+vector3))

(%aw-godot::+operator* '(:pointer %aw-godot::+vector3) *vec* '(:pointer %aw-godot::+vector3) *vec*)
(defparameter *my-node* (iffi:make-intricate-instance '%aw-godot::+node3d))


(
 )
(iffi:make-intricate-instance '%aw-godot::+quaternion)
(%aw-godot::+quaternion)
(setf cffi::*cffi-ecl-method* :c/c++)
(setf cffi::*cffi-ecl-method* :dffi)
(setf cffi::*cffi-ecl-method* :dlopen)
(setq C::*CC* "gcc")
(setq C:*USER-CC-FLAGS* " -std=c++17 -fPIC -O0 -fpermissive -I/home/jason/godot-projects/lisp-test-project/lisp-extension -isystem /home/jason/godot-cpp/include -isystem /home/jason/godot-cpp/gen/include -isystem /home/jason/godot-cpp/gdextension ")
(setq C:*user-linker-libs* "-L/home/jason/godot-projects/lisp-test-project/lisp-extension -Wl,-rpath,/home/jason/godot-projects/lisp-test-project/lisp-extension  -leclcpp.linux.debug.x86_64 /home/jason/godot-projects/lisp-test-project/lisp-extension/libgodot-cpp.linux.debug.64.a ")

(%aw-)

(defparameter float-1 (cffi:foreign-type-size :float))
(defparameter float-2 (cffi:foreign-type-size '%aw-godot::+VECTOR3))

(%aw-godot::+math+is-equal-approx :float float-1 :float float-2)

(cffi:foreign-alloc '%aw-godot::+vector3i)
(defvar iffi:*allocator* #'cffi::foreign-alloc)
(defvar iffi:*extricator* #'iffi::aligned-free)
(inspect #'%aw-godot::+math+is-equal-approx)

(defun pretty-print-hash-table (hash-table &key (stream *standard-output*))
  "Pretty print a HASH-TABLE to STREAM."
  (format stream "{~%")
  (maphash (lambda (key value)
             (format stream "  ~S => ~S~%" key value))
           hash-table)
  (format stream "}~%"))

(pretty-print-hash-table (slot-value ()(iffi::find-intricate-record '%aw-godot::+collision-shape2d) 'iffi::field-map))

(defun get-all-symbols (&optional package)
  (let ((lst ())
        (package (find-package package)))
    (do-all-symbols (s lst)
      (when (fboundp s)
        (if package
            (when (eql (symbol-package s) package)
              (push s lst))
            (push s lst))))
    lst))

(defparameter *project-include-folder* "/home/jason/godot-projects/lisp-test-project/lisp-extension/")

(defun find-size ()
  (ffi:clines "#include <godot_cpp/classes/collision_shape2d.hpp>")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline () () :int
                "@(return) = sizeof(godot::CollisionShape2D);"))


(defun find-size2 ()
  (ffi:clines "#include <godot_cpp/classes/collision_shape2d.hpp>")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline () () :int
                "@(return) = __claw_sizeof__ZN5godot16CollisionShape2DC2EPKc();"))




(find-size)
(defun get-node->symbol-impl (name symbol)
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:clines "using namespace godot;")
  (let ((sym-name (symbol-name symbol)))
    (ffi:c-inline (name sym-name) (:cstring :cstring) :pointer-void
                "Array arr = Array();
                 arr.resize(1);
                 arr[0] = #0;
                 @(return) = LispSingleton::singleton->call_deferred_to_symbol(#1, LispSingleton::singleton, \"get_node\", arr);")))

(defmacro get-node->symbol (name symbol)
  `(get-node->symbol-impl ,name ',symbol))

(defun get-node (name)
  (get-node->symbol-impl name (gensym)))

(defun get-name (ptr)
  (ffi:clines "#include <godot_cpp/classes/object.hpp>")
  (ffi:clines "#include <godot_cpp/classes/node.hpp>")
  (ffi:clines "using namespace godot;")
   (ffi:c-inline (ptr) (:pointer-void) :cstring
                "
                 Node* node = Object::cast_to<Node>(reinterpret_cast<Object*>(#0));
                 String str_name = String(node->get_name());
                 CharString utf8_name = str_name.utf8();
                 const char* name = utf8_name.get_data();
                 @(return)=name;"))


(defun set-name (ptr name)
  (ffi:clines "#include <godot_cpp/classes/object.hpp>")
  (ffi:clines "#include <godot_cpp/classes/node.hpp>")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline (ptr name) (:pointer-void :cstring) :void
                "
                 Node* node = Object::cast_to<Node>(reinterpret_cast<Object*>(#0));
                 node->call_deferred(\"set_name\", String(#1));"))

(defun get-position (node-ptr)
  (ffi:clines "#include <godot_cpp/variant/array.hpp>")
  (ffi:clines "#include <godot_cpp/variant/vector3.hpp>")
  (ffi:clines "#include \"lisp_singleton.hpp\"")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline (node-ptr (string (gensym)))
                (:pointer-void :cstring)
                :pointer-void
                   "@(return) = LispSingleton::singleton->call_deferred_to_symbol(#1, #0, \"get_position\", Array());"))


(defun set-position (node-ptr x y z)
  (ffi:clines "#include <godot_cpp/classes/object.hpp>")
  (ffi:clines "#include <godot_cpp/classes/node3d.hpp>")
  (ffi:clines "#include <godot_cpp/variant/vector3.hpp>")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline (node-ptr x y z)
                (:pointer-void :double :double :double)
                :void
                "Node3D* node = Object::cast_to<Node3D>(reinterpret_cast<Object*>(#0));
                 if(node == NULL) {
                   return;
                 }
                 Vector3 vec3 = Vector3(#1, #2, #3);
                 node->call_deferred(\"set_position\", vec3);
                 "))

(eval-when :execute)
(defun write-header-to-file ()
  (with-open-file (stream (concatenate 'string *project-include-folder* "lisp_class.hpp")
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)
    (loop :for line :in '("#ifndef LISP_CLASS_H_"
                          "#define LISP_CLASS_H_"
                          "#include <godot_cpp/classes/character_body3d.hpp>"
                          "#include <godot_cpp/core/class_db.hpp>"
                          "namespace godot {"
                          "class LispClass : public CharacterBody3D {"
                          "GDCLASS(LispClass, CharacterBody3D);"
                          "public:"
                          "LispClass();"
                          "~~LispClass();"
                          "static void _bind_methods();"
                          "void ready();"
                          "void _physics_process(double delta);"
                          "};~%"
                          "}~%"
                          "#endif // LISP_CLASS_H_")
          :do (format stream (concatenate 'string line "~%")))))

(eval-when :execute)
(defun write-cpp-to-file ()
  (with-open-file (stream (concatenate 'string *project-include-folder* "lisp_class.cpp")
                          :direction :output
                          :if-exists :supersede
                          :if-does-not-exist :create)
    (loop :for line :in '("#include \"lisp_class.hpp\""
                          "using namespace godot;"
                          "void LispClass::_bind_methods() {"
                          "//ClassDB::bind_method(D_METHOD(\"\"), &LispSingleton::initialize_lisp);"
                          "}"
                          "void LispClass::ready() {}"
                          "void LispClass::_physics_process(double delta) {"
                          "this->set_velocity(this->get_velocity() + Vector3(0.0d, -9.8d * delta, 0.0d));"
                          "this->move_and_slide();"
                          "}")
          :do (format stream (concatenate 'string line "~%")))))

(write-cpp-to-file)

(defun instantiate-lisp-class ()
  (ffi:clines "#include \"lisp_class.hpp\"")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline ()
                ()
                :pointer-void
                "@(return) = memnew(LispClass);"))


(ffi:defcallback move-and-slide :int ((char-ptr :pointer-void) (delta :double) (x :double) (y :double) (z :double))
  (ffi:clines "#include <godot_cpp/classes/object.hpp>")
  (ffi:clines "#include <godot_cpp/variant/vector3.hpp>")
  (ffi:clines "#include <godot_cpp/classes/character_body3d.hpp>")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline (char-ptr delta x y z)
                (:pointer-void :double :double :double :double)
                :bool
                "CharacterBody3D* cb = Object::cast_to<CharacterBody3D>(reinterpret_cast<Object*>(#0));
                 if(cb == NULL) {
                   @(return) = NULL;
                 }
                 cb->set_velocity(cb->get_velocity() + Vector3(#2 * #1, #3 * #1, #4 * #1));

                 bool collision = cb->move_and_slide();
                 @(return) = collision;
                 "))

(move-and-slide char-body 0 0 0)

(defun vec3 (x y z)
  (ffi:clines "#include <godot_cpp/variant/vector3.hpp>")
  (ffi:clines "#include <iostream>")
  (ffi:clines "using namespace godot;")
  (ffi:c-inline (x y z)
                (:double :double :double)
                :pointer-void
                "Vector3 vec3 = Vector3(#0, #1, #2);
                 std::cout << vec3.x << std::endl;
                 @(return) = &vec3;"))

(vec3 5 0 0)
(get-position rigid-body)
(set-position rigid-body 0 0 -5)
(move-and-collide rigid-body 0 0 1)
(get-node->symbol "cam" camera)
(get-node->symbol "cam/char" char-body)
(set-name rigid-body "the rigid body")
(get-name rigid-body)
(princ camera)
