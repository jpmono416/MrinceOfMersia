extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animationPlayer = $AnimationPlayer
const SPEED = 220
const JUMP_VELOCITY = -515

func _physics_process(delta):
	handleMovement(delta)
	handleAnimations()
	move_and_slide()

func handleMovement(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animationPlayer.play("Jump")
		velocity.y = JUMP_VELOCITY

	# Stop character when not moving
	if !Input.get_axis("ui_left", "ui_right"):
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Get input for movement
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	if Input.is_action_pressed("ui_up"):
		velocity.y = SPEED

func handleAnimations():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if animationPlayer.current_animation != "Run" && is_on_floor():
				animationPlayer.play("Run")
		else:
			if velocity.y > 0:
				if animationPlayer.current_animation != "Fall":
					animationPlayer.play("Fall")
			else:
				if animationPlayer.current_animation != "Jump":
					animationPlayer.play("Jump")

		if velocity.x < 0:
			$Sprite2D.flip_h = true # Flip sprite for left movement
		elif velocity.x > 0:
			$Sprite2D.flip_h = false # Normal sprite for right movement
	else:
		if animationPlayer.current_animation != "Idle":
			animationPlayer.play("Idle")
