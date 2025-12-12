extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var item_sprite: TextureRect = $Panel/VBoxContainer/ItemSprite
@onready var item_name_label: Label = $Panel/VBoxContainer/ItemName
@onready var item_description: Label = $Panel/VBoxContainer/ItemDescription
@onready var continue_label: Label = $Panel/VBoxContainer/ContinueLabel

var item_data = {
	"apple": {
		"name": "Granada da Vitalidade",
		"description": "\"Explosao de Sabores e Nutrientes!\"\n\nAo ser lancada, a maca explode em um burst de vitaminas e fibras que atinge varios Junkz na area, quebrando suas defesas gordurosas.",
		"texture_uid": "uid://bisx3qseefq0j"
	},
	"carrot": {
		"name": "Raio Laranja da Precisao",
		"description": "\"Foco da Visao e Mira Perfeita!\"\n\nRica em betacaroteno, a cenoura e disparada como um tiro laser que corta o ar, acertando os Junkz mais rapidos e distantes com precisao cirurgica.",
		"texture_uid": "uid://bvnvktmhmfw"
	},
	"water": {
		"name": "Jato de Hidratacao Pura",
		"description": "\"A Forca da Limpeza e Restauracao!\"\n\nA agua, essencial para o corpo, nao apenas enche rapidamente sua barra de Vitalidade, mas tambem \"lava\" o cansaco e a lentidao causados pela poluicao dos Junkz, restaurando seu ritmo e energia.",
		"texture_uid": "uid://bwlcu511eweq6"
	}
}

func _ready():
	hide()
	continue_label.text = "Pressione qualquer tecla para continuar..."

func show_item(item_type: String):
	if not item_data.has(item_type):
		print("[ITEM_POPUP] Item type não encontrado: ", item_type)
		return
	
	var data = item_data[item_type]
	
	# Configurar textura do item
	var texture = load(data["texture_uid"])
	if texture:
		item_sprite.texture = texture
	
	# Configurar textos
	item_name_label.text = data["name"]
	item_description.text = data["description"]
	
	# Pausar o jogo e mostrar popup
	get_tree().paused = true
	show()
	
	# Aguardar 2 segundos antes de permitir fechar
	await get_tree().create_timer(2.0, true, false, true).timeout
	
	# Aguardar input para fechar
	await _wait_for_input()
	
	# Despausar e esconder
	hide()
	get_tree().paused = false

func _wait_for_input():
	while true:
		await get_tree().process_frame
		if Input.is_anything_pressed():
			await get_tree().create_timer(0.1).timeout
			break

func _input(event):
	if visible and event is InputEventKey and event.pressed:
		get_viewport().set_input_as_handled()
