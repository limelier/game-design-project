extends Area2D

var velocity = Vector2()
const speed = 100

func _ready():
	velocity = Vector2.DOWN * speed
	

func _process(delta):
	position += velocity * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

