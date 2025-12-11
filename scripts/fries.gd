extends CharacterBody2D

enum FriesState {
	walk,
	attack,
	hurt
}

const SPINNING_PROJECT = preload("res://entities/tomato.tscn")

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var bone_start_position: Node2D = $BoneStartPosition

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

var status: FriesState

var direction = 1
var can_throw = true

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		FriesState.walk:
			walk_state(delta)
		FriesState.attack:
			attack_state(delta)
		FriesState.hurt:
			hurt_state(delta)

	move_and_slide()

func go_to_walk_state():
	status = FriesState.walk
	anim.play("walk")
	
func go_to_attack_state():
	status = FriesState.attack
	anim.play("attack")
	velocity = Vector2.ZERO
	can_throw = true
	
func go_to_hurt_state():
	status = FriesState.hurt
	anim.play("hurt")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	
func walk_state(_delta):
	if anim.frame == 3 or anim.frame == 4:
		velocity.x = SPEED * direction
	else:
		velocity.x = 0
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if player_detector.is_colliding():
		go_to_attack_state()
		return

func attack_state(_delta):
	if anim.frame == 2 && can_throw:
		throw_bone()
		can_throw = false

func hurt_state(_delta):
	pass
	
func take_damage():
	go_to_hurt_state()
	
func throw_bone():
	var new_bone = SPINNING_PROJECT.instantiate()
	add_sibling(new_bone)
	new_bone.position = bone_start_position.global_position
	new_bone.set_direction(self.direction)
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk_state()
		return
