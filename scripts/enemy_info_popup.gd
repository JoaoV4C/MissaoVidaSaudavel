extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var enemy_name: Label = $Panel/VBoxContainer/EnemyName
@onready var enemy_sprite: TextureRect = $Panel/VBoxContainer/EnemySprite
@onready var enemy_subtitle: Label = $Panel/VBoxContainer/EnemySubtitle
@onready var enemy_description: Label = $Panel/VBoxContainer/EnemyDescription
@onready var enemy_attack: Label = $Panel/VBoxContainer/EnemyAttack
@onready var continue_label: Label = $Panel/VBoxContainer/ContinueLabel

const MIN_DISPLAY_TIME = 2.0

func show_enemy_info(enemy_type: String):
	var enemy_data = get_enemy_data(enemy_type)
	
	enemy_name.text = enemy_data["name"]
	enemy_sprite.texture = load(enemy_data["texture_uid"])
	enemy_subtitle.text = enemy_data["subtitle"]
	enemy_description.text = enemy_data["description"]
	enemy_attack.text = "Ataque: " + enemy_data["attack"]
	
	get_tree().paused = true
	show()
	
	# Aguardar tempo mínimo
	await get_tree().create_timer(MIN_DISPLAY_TIME, true, false, true).timeout
	
	# Aguardar input do jogador
	while not (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("jump")):
		await get_tree().process_frame
	
	hide()
	queue_free()
	get_tree().paused = false

func get_enemy_data(enemy_type: String) -> Dictionary:
	var data = {
		"burger": {
			"name": "Burgerz",
			"texture_uid": "uid://bufibajiqachm",
			"subtitle": "A Massa da Preguica",
			"description": "Representa o peso e a lentidao que a gordura e a comida pesada trazem ao corpo.",
			"attack": "Projeteis Engordurados (Tomates). Arremessa fatias de tomate com molho que causam dano e o deixa escorregadio."
		},
		"fries": {
			"name": "Fritoz",
			"texture_uid": "uid://cmrbbe3gudir",
			"subtitle": "O Vicio do Sal e do Carboidrato",
			"description": "Representa o pico de energia momentaneo, seguido de uma queda brusca (ou a dificuldade em resistir ao impulso).",
			"attack": "Arremesso de Sal. Lanca um punhado de batatas fritas individuais."
		},
		"sodaz": {
			"name": "Sodaz",
			"texture_uid": "uid://brnc7ovdyu5ys",
			"subtitle": "A Doce Poluicao",
			"description": "Representa o acucar excessivo, que corroi a saude e contamina a agua pura do corpo.",
			"attack": "Bolas de Acucar Explosivas. Lanca projeteis de liquido borbulhante (acucar concentrado) que causam dano em area."
		},
		"boss": {
			"name": "MegaBurgerz",
			"texture_uid": "uid://buliw0vul77le",
			"subtitle": "A Concentracao de Maus Habitos",
			"description": "E a soma de todos os vicios e a causa central do desanimo da cidade. 25x mais Vitalidade que um Burgerz normal, move-se e ataca mais rapido.",
			"attack": "Chuva de Tomates Engordurados. Dispara os projeteis de tomate em sequencia rapida e em padroes complexos."
		}
	}
	
	return data.get(enemy_type, data["burger"])
