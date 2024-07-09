extends CharacterBody2D

# States that the enemy can have
@onready var animationPlayer = $AnimationPlayer
@onready var playerDetectionArea = $PlayerDetectionArea
@onready var player = get_node("/root/Node2D/Player")

# Constants
const WALK_SPEED := 90
const CHASE_SPEED := 160

enum states {EXPLORE, CHASE, ATTACK}
var currentState := states.EXPLORE
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isColliding := false
var direction := Vector2.RIGHT

func _ready():
	playerDetectionArea.connect("body_entered", self.onDetectPlayer)
	playerDetectionArea.connect("body_exited", self.onLosePlayer)

func _physics_process(delta):
	
	# Dependiendo del estado actual, ejecuta un comportamiento diferente
	match currentState:
		states.EXPLORE: 
			exploreBehaviour()
		states.CHASE:
			chaseBehaviour()
		states.ATTACK:
			# comportamiento de atacar
			pass
			
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Asegurar que mira hacia donde tiene que mirar
	$Sprite2D.flip_h = not direction.x > 0
	
	# Mover al enemigo y cambiar las animaciones
	handleAnimations()
	move_and_slide()
	
	
func onDetectPlayer(body):
	# Cambiar el estado a CHASE
	if body == player:
		setState(states.CHASE)
	
func onLosePlayer(body):
	# Cambiar el estado a EXPLORE
	if body == player:
		setState(states.EXPLORE)

func setState(newState: states):
	currentState = newState

# Aquí vamos a hacer que se mueva y explore
	# Mover hacia un lado hasta que colisione
	# entonces cambiar de lado
func exploreBehaviour():
	velocity = direction * WALK_SPEED

	# Flip sprite and direction
	if is_on_wall():
		if not isColliding:
			direction = -direction
			isColliding = true
	else:
		isColliding = false

func chaseBehaviour():
	# Aquí vamos a hacer que el enemigo persiga al jugador
	# Para ello vamos a necesitar la posición del jugador
	# y vamos a mover al enemigo hacia esa posición
	var playerPos = player.global_position
	direction = (playerPos - global_position).normalized()
	direction.y = 0
	
	velocity = direction * CHASE_SPEED

	# TODO: Si la dirección es menor que X cambiar al estado ATTACK
	# Flip sprite and direction
	

func handleAnimations():
	if velocity.length() > 0:
		#if abs(velocity.x) > abs(velocity.y):
		match currentState:
			states.EXPLORE:
				if animationPlayer.current_animation != "Enemies/EnemyWalk" && is_on_floor():
					animationPlayer.play("Enemies/EnemyWalk")
			states.CHASE:
				if animationPlayer.current_animation != "Enemies/EnemyRun" && is_on_floor():
					animationPlayer.play("Enemies/EnemyRun")
		# else si está subiendo o bajando
