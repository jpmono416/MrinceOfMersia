# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
onready var animationPlayer = $AnimationPlayer
 
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
		velocity.y = JUMP_VELOCITY

	# Stop character when not moving
	if !Input.get_axis("ui_left", "ui_right"):
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Get input for movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("ui_down"):
		velocity.y += SPEED
	if Input.is_action_pressed("ui_up"):
		velocity.y -= SPEED

	# Apply movement
	velocity = move_and_slide(velocity)

func handleAnimations():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if animationPlayer.current_animation != "run":
				animationPlayer.play("run")
		else:
			if animationPlayer.current_animation != "run":
				animationPlayer.play("run")

		if velocity.x < 0:
			$Sprite.flip_h = true # Flip sprite for left movement
		elif velocity.x > 0:
			$Sprite.flip_h = false # Normal sprite for right movement
	else:
		if animationPlayer.current_animation != "Idle":
			animationPlayer.play("Idle")
