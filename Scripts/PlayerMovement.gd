extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var animationPlayer = $AnimationPlayer
var SPEED = 150
var JUMP_VELOCITY = 200

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		print ("saltando")

	# Get input for movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED * delta
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED * delta
	if Input.is_action_pressed("ui_down"):
		velocity.y += SPEED * delta
	if Input.is_action_pressed("ui_up"):
		velocity.y -= SPEED * delta

	# Apply movement
	move_and_slide()

	# Handle animation changes
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if animationPlayer.current_animation != "Run":
				animationPlayer.play("Run")
		else:
			if animationPlayer.current_animation != "Run":
				animationPlayer.play("Run")

		if velocity.x < 0:
			$Sprite2D.flip_h = true # Flip sprite for left movement
		elif velocity.x > 0:
			$Sprite2D.flip_h = false # Normal sprite for right movement
	else:
		if animationPlayer.current_animation != "Idle":
			animationPlayer.play("Idle")
