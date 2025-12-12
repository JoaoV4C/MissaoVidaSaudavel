extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	fall,
	duck,
	wall,
	hurt,
	dead
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var left_wall_detector: RayCast2D = $LeftWallDetector
@onready var right_wall_detector: RayCast2D = $RightWallDetector
@onready var projectile_spawn: Marker2D = $ProjectileSpawn

@onready var reload_timer: Timer = $ReloadTimer

@export var max_speed = 180.0
@export var acceleration = 400.0
@export var deceleration = 400.0
@export var wall_acceleration = 40.0
@export var wall_jump_velocity = 240.0
@export var water_max_speed = 100
@export var water_acceleration = 200
@export var water_jump_force = -100

const JUMP_VELOCITY = -300.0

var jump_count = 0
@export var max_jump_count = 2
var direction = 0
var status: PlayerState
var health = 3
var is_invincible = false
var invincibility_timer = 0.0
const INVINCIBILITY_DURATION = 1.0

enum ProjectileType {
	APPLE,
	CARROT
}
var current_projectile = ProjectileType.APPLE
var throw_cooldown = 0.0
const THROW_COOLDOWN_DURATION = 0.5
var distance_traveled = 0.0
const ENERGY_PER_1000_PIXELS = 10
const ENERGY_PER_DOUBLE_JUMP = 10
		
func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	# Atualizar timer de invencibilidade
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			is_invincible = false
	
	# Atualizar cooldown de arremesso
	if throw_cooldown > 0:
		throw_cooldown -= delta
	
	# Alternar tipo de projétil com Q
	if Input.is_action_just_pressed("switch_weapon"):  # Tecla Q
		toggle_projectile()
	
	# Arremessar projétil com botão esquerdo do mouse
	if Input.is_action_just_pressed("shoot") and throw_cooldown <= 0:
		throw_projectile()
	
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.duck:
			duck_state(delta)
		PlayerState.wall:
			wall_state(delta)
		PlayerState.hurt:
			hurt_state(delta)
		PlayerState.dead:
			dead_state(delta)
			
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")

func go_to_jump_state():
	# Impedir double jump se energia estiver em 0
	if jump_count >= 1 and Globals.energy <= 0:
		print("[ENERGY] Sem energia para double jump!")
		return
	
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	jump_count += 1
	
	# Perder energia no double jump
	if jump_count == 2:
		print("[ENERGY] Double jump! Energia antes: ", Globals.energy)
		Globals.energy = max(0, Globals.energy - ENERGY_PER_DOUBLE_JUMP)
		print("[ENERGY] Energia depois do double jump: ", Globals.energy)
	
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall")
	
func go_to_duck_state():
	status = PlayerState.duck
	anim.play("duck")
	set_small_collider()
	
func exit_from_duck_state():
	set_large_collider()
	
	
func go_to_wall_state():
	status = PlayerState.wall
	anim.play("wall")
	velocity = Vector2.ZERO
	jump_count = 0

func go_to_hurt_state():
	status = PlayerState.hurt
	anim.play("getting hit")
	velocity.x = 0
	
func go_to_dead_state():
	if status == PlayerState.dead:
		return
	
	status = PlayerState.dead
	anim.play("dead")
	velocity.x = 0
	reload_timer.start()

func idle_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x != 0:
		go_to_walk_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return
	
func walk_state(delta):
	apply_gravity(delta)
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if !is_on_floor():
		jump_count += 1
		go_to_fall_state()
		return
		
func jump_state(delta):
	apply_gravity(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if velocity.y > 0:
		go_to_fall_state()
		return
		
func fall_state(delta):
	apply_gravity(delta)
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return
		
	if (left_wall_detector.is_colliding() or right_wall_detector.is_colliding()) && is_on_wall():
		go_to_wall_state()
		return
		
func duck_state(delta):
	apply_gravity(delta)
	update_direction()
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return
		
func wall_state(delta):
	
	velocity.y += wall_acceleration * delta
	
	if left_wall_detector.is_colliding():
		anim.flip_h = false
		direction = 1
	elif right_wall_detector.is_colliding():
		anim.flip_h = true
		direction = -1
	else:
		go_to_fall_state()
		return
	
	if is_on_floor():
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_jump_velocity * direction
		go_to_jump_state()
		return

func hurt_state(delta):
	apply_gravity(delta)
	# Estado de hurt é controlado pela animação - quando terminar volta ao estado normal
		
func dead_state(delta):
	apply_gravity(delta)

func move(delta):
	update_direction()
	
	if direction:
		# Reduzir velocidade se energia estiver em 0
		var current_speed = max_speed
		if Globals.energy <= 0:
			current_speed = max_speed * 0.5  # 50% da velocidade normal
		
		velocity.x = move_toward(velocity.x, direction * current_speed, acceleration * delta)
		# Acumular distância percorrida
		distance_traveled += abs(velocity.x * delta)
		# Perder energia a cada 1000 pixels
		if distance_traveled >= 1000:
			print("[ENERGY] 1000 pixels percorridos! Distância: ", distance_traveled)
			print("[ENERGY] Energia antes: ", Globals.energy)
			Globals.energy = max(0, Globals.energy - ENERGY_PER_1000_PIXELS)
			print("[ENERGY] Energia depois de andar: ", Globals.energy)
			distance_traveled -= 1000
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
func update_direction():
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		anim.flip_h = true
	elif direction > 0:
		anim.flip_h = false

func can_jump() -> bool:
	return jump_count < max_jump_count

func set_small_collider():
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 10
	collision_shape.position.y = 3
	
	hitbox_collision_shape.shape.size.y = 10
	hitbox_collision_shape.position.y = 3
	
func set_large_collider():
	collision_shape.shape.radius = 6
	collision_shape.shape.height = 16
	collision_shape.position.y = 0
	
	hitbox_collision_shape.shape.size.y = 15
	hitbox_collision_shape.position.y = 0.5

func _on_hitbox_area_entered(area: Area2D) -> void:
	# Ignorar projéteis disparados pelo próprio player
	if area.is_in_group("PlayerProjectile"):
		return
	
	if area.is_in_group("Enemies"):
		hit_enemy(area)
	elif area.is_in_group("LethalArea"):
		hit_lethal_area()
		
func _on_hitbox_body_entered(body: Node2D) -> void:
	# Ignorar projéteis disparados pelo próprio player
	if body.is_in_group("PlayerProjectile"):
		return
	
	if body.is_in_group("LethalArea"):
		go_to_dead_state()

func hit_enemy(area: Area2D):
	if velocity.y > 0:
		# inimigo morre
		area.get_parent().take_damage()
		go_to_jump_state()
		
		# Ejetar player para o lado
		var enemy = area.get_parent()
		var direction_to_player = sign(global_position.x - enemy.global_position.x)
		if direction_to_player == 0:
			direction_to_player = 1  # Padrão para direita se estiver exatamente em cima
		velocity.x = direction_to_player * 150  # Empurrar para o lado
	else:
		# player toma dano
		take_damage()
	
func hit_lethal_area():
	take_damage()

func take_damage():
	# Se está invencível, ignorar dano
	if is_invincible:
		print("[PLAYER] Invencível - dano ignorado")
		return
	
	health -= 1
	print("Player health: ", health)
	
	# Ativar invencibilidade
	is_invincible = true
	invincibility_timer = INVINCIBILITY_DURATION
	
	if health <= 0:
		go_to_dead_state()
	else:
		go_to_hurt_state()

func _on_reload_timer_timeout() -> void:
	# Resetar munição e energia ao reiniciar a cena
	Globals.apples = 10
	Globals.carrots = 10
	Globals.energy = 100
	get_tree().reload_current_scene()

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Water"):
		jump_count = 0
		go_to_jump_state()

func toggle_projectile():
	if current_projectile == ProjectileType.APPLE:
		current_projectile = ProjectileType.CARROT
		print("[PLAYER] Trocou para CARROT")
	else:
		current_projectile = ProjectileType.APPLE
		print("[PLAYER] Trocou para APPLE")

func throw_projectile():
	# Verificar se tem munição disponível
	if current_projectile == ProjectileType.APPLE:
		if Globals.apples <= 0:
			print("[PLAYER] Sem maçãs disponíveis!")
			return
	else:  # CARROT
		if Globals.carrots <= 0:
			print("[PLAYER] Sem cenouras disponíveis!")
			return
	
	var projectile_scene
	var projectile_script
	
	# Selecionar cena e script baseado no tipo atual
	if current_projectile == ProjectileType.APPLE:
		projectile_scene = load("res://entities/apple.tscn")
		Globals.apples -= 1
		print("[PLAYER] Maçãs restantes: ", Globals.apples)
	else:  # CARROT
		projectile_scene = load("res://entities/carrot.tscn")
		projectile_script = load("res://scripts/carrot_projectile.gd")
		Globals.carrots -= 1
		print("[PLAYER] Cenouras restantes: ", Globals.carrots)
	
	var projectile = projectile_scene.instantiate()
	add_sibling(projectile)
	
	# Aplicar script da cenoura se necessário
	if current_projectile == ProjectileType.CARROT:
		projectile.set_script(projectile_script)
	
	# Determinar direção baseada no flip do sprite
	var throw_direction = -1 if anim.flip_h else 1
	
	# Ajustar posição do spawn baseado na direção
	var spawn_offset = projectile_spawn.position
	if anim.flip_h:  # Virado para esquerda
		spawn_offset.x = -abs(spawn_offset.x)
	else:  # Virado para direita
		spawn_offset.x = abs(spawn_offset.x)
	
	projectile.global_position = global_position + spawn_offset
	projectile.set_direction(throw_direction)
	
	# Iniciar cooldown
	throw_cooldown = THROW_COOLDOWN_DURATION

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "getting hit":
		anim.play("getting up")
	elif anim.animation == "getting up":
		if is_on_floor():
			go_to_idle_state()
		else:
			go_to_fall_state()
