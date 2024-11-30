extends LispSingleton


# Called when the node enters the scene tree for the first time.
func _ready():
	self.initialize_lisp()
	self.run_swank()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
