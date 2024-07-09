extends CharacterBody2D

# States that the enemy can have
@onready var animationPlayer = $AnimationPlayer
enum states {EXPLORE, CHASE, ATTACK}
var currentState := states.EXPLORE
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facingRight := true
const WALK_SPEED := 90
var isColliding := false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Dependiendo del estado actual, ejecuta un comportamiento diferente
	match currentState:
		states.EXPLORE: 
			exploreBehaviour()
		states.CHASE:
			pass
		states.ATTACK:
			# comportamiento de atacar
			pass

	# Mover al enemigo y cambiar las animaciones
	handleAnimations()
	move_and_slide()
	
	
# Aquí vamos a hacer que se mueva y explore
	# Mover hacia un lado hasta que colisione
	# entonces cambiar de lado
func exploreBehaviour():
	velocity.x = WALK_SPEED if facingRight else -WALK_SPEED

	# Flip sprite and direction
	if is_on_wall():
		if not isColliding:
			switchSide()
			isColliding = true
	else:
		isColliding = false


	
func switchSide():
	$Sprite2D.flip_h = facingRight
	# Cambiar variable de direccion
	facingRight = not facingRight

func handleAnimations():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if animationPlayer.current_animation != "Enemies/EnemyRun" && is_on_floor():
				animationPlayer.play("Enemies/EnemyRun")
