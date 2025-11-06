extends CharacterBody2D

const SPEED := 150.0
const JUMP_FORCE := -325.0

@onready var anim: AnimatedSprite2D = $anim
@onready var remote_transform := $remote as RemoteTransform2D

var is_jumping := false

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		is_jumping = true
	else:
		is_jumping = false

	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	# horizontal movement
	var dir := Input.get_axis("move_left", "move_right")

	if dir != 0:
		velocity.x = dir * SPEED
		# flip sprite
		anim.scale.x = sign(dir)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# animation
	_play_anim(dir)

	move_and_slide()

func _play_anim(dir: float) -> void:
	if is_jumping:
		anim.play("jump")
	elif dir != 0:
		anim.play("run")
	else:
		anim.play("idle")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		queue_free()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
