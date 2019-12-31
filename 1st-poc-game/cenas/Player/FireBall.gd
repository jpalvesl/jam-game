extends Area2D

const SPEED = 200
var velocity = Vector2()
var direction = 1

func _ready():
	pass
	
func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")

func set_fireball_direction(lado):
	direction = lado
	if lado == -1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func _on_FireBall_body_entered(body):
	queue_free()
	

