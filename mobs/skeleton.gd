extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var chase = false
var alive = true

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var player = $"../../Player/player"
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true:
			velocity.x = direction.x * SPEED
			anim.play("walk")
		else: 
			velocity.x = 0
			anim.play("idle")
		
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player":
		chase = true

func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player":
		chase = false

func _on_death_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.velocity.y -= 300
		death()
			
func death():
	alive = false
	anim.play("death")
	await anim.animation_finished
	queue_free()

func _on_death_2_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if alive == true:
			body.health -= 40
			death()
	
