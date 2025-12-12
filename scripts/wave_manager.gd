extends Node

signal wave_completed
signal all_waves_completed
signal enemy_spawned
signal boss_spawned

const BURGER = preload("res://entities/burger.tscn")
const FRIES = preload("res://entities/fries.tscn")
const SODAZ = preload("res://entities/sodaz.tscn")
const BOSS = preload("res://entities/boss.tscn")

var current_wave = 1
var enemies_alive = 0
var wave_active = false
var spawn_points = []

# Configuração das ondas: [burgers, fries, sodaz, boss]
var waves = [
	{"burgers": 1, "fries": 0, "sodaz": 0, "boss": 0},  # Onda 1
	{"burgers": 3, "fries": 2, "sodaz": 1, "boss": 0},  # Onda 2
	{"burgers": 4, "fries": 3, "sodaz": 1, "boss": 0},  # Onda 3
	{"burgers": 5, "fries": 4, "sodaz": 2, "boss": 0},  # Onda 4
	{"burgers": 6, "fries": 5, "sodaz": 3, "boss": 0},  # Onda 5
	{"burgers": 3, "fries": 3, "sodaz": 2, "boss": 1}   # Onda 6 (com boss)
]

func _ready():
	# Encontrar todos os spawn points na cena
	get_tree().call_group("SpawnPoint", "_register_spawn_point", self)
	
	# Aguardar um frame para garantir que tudo está pronto
	await get_tree().process_frame
	
	# Iniciar primeira onda
	start_next_wave()

func register_spawn_point(spawn_point: Marker2D):
	spawn_points.append(spawn_point)
	print("[WAVE_MANAGER] Spawn point registrado: ", spawn_point.global_position)

func start_next_wave():
	if current_wave > waves.size():
		print("[WAVE_MANAGER] Todas as ondas completadas!")
		all_waves_completed.emit()
		return
	
	wave_active = true
	enemies_alive = 0
	
	var wave_data = waves[current_wave - 1]
	
	print("[WAVE_MANAGER] Iniciando onda ", current_wave, "/", waves.size())
	
	# Spawnar inimigos
	spawn_enemies(BURGER, wave_data["burgers"])
	spawn_enemies(FRIES, wave_data["fries"])
	spawn_enemies(SODAZ, wave_data["sodaz"])
	
	# Spawnar boss se houver
	if wave_data["boss"] > 0:
		spawn_boss()

func spawn_enemies(enemy_scene: PackedScene, count: int):
	for i in range(count):
		var spawn_pos = get_random_spawn_position()
		if spawn_pos == Vector2.ZERO:
			print("[WAVE_MANAGER] ERRO: Nenhum spawn point disponível!")
			continue
		
		var enemy = enemy_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.global_position = spawn_pos
		enemies_alive += 1
		
		# Conectar sinal de morte do inimigo
		if enemy.has_signal("tree_exiting"):
			enemy.tree_exiting.connect(_on_enemy_died.bind(enemy))
		
		enemy_spawned.emit()
		print("[WAVE_MANAGER] Inimigo spawnado em: ", spawn_pos, " (Total vivos: ", enemies_alive, ")")

func spawn_boss():
	var spawn_pos = get_random_spawn_position()
	if spawn_pos == Vector2.ZERO:
		print("[WAVE_MANAGER] ERRO: Nenhum spawn point para boss!")
		return
	
	var boss = BOSS.instantiate()
	get_parent().add_child(boss)
	boss.global_position = spawn_pos
	enemies_alive += 1
	
	if boss.has_signal("tree_exiting"):
		boss.tree_exiting.connect(_on_enemy_died.bind(boss))
	
	boss_spawned.emit()
	print("[WAVE_MANAGER] BOSS spawnado em: ", spawn_pos)

func get_random_spawn_position() -> Vector2:
	if spawn_points.is_empty():
		return Vector2.ZERO
	
	const MIN_DISTANCE = 50.0  # Distância mínima entre entidades
	const MAX_ATTEMPTS = 10
	
	for attempt in range(MAX_ATTEMPTS):
		var spawn_point = spawn_points.pick_random()
		var pos = spawn_point.global_position
		
		# Verificar se está muito perto do player
		var player = get_tree().get_first_node_in_group("Player")
		if player and player.global_position.distance_to(pos) < MIN_DISTANCE:
			continue
		
		# Verificar se está muito perto de outros inimigos
		var too_close = false
		var enemies = get_tree().get_nodes_in_group("Enemies")
		for enemy_hitbox in enemies:
			var enemy = enemy_hitbox.get_parent()
			if enemy and enemy.global_position.distance_to(pos) < MIN_DISTANCE:
				too_close = true
				break
		
		if not too_close:
			return pos
	
	# Se não encontrou posição boa após tentativas, retorna qualquer uma
	var spawn_point = spawn_points.pick_random()
	return spawn_point.global_position

func _on_enemy_died(_enemy):
	enemies_alive -= 1
	print("[WAVE_MANAGER] Inimigo morreu. Restantes: ", enemies_alive)
	
	if enemies_alive <= 0 and wave_active:
		wave_active = false
		print("[WAVE_MANAGER] Onda ", current_wave, " completada!")
		current_wave += 1
		wave_completed.emit()
		
		# Aguardar 3 segundos antes da próxima onda
		await get_tree().create_timer(3.0).timeout
		start_next_wave()
