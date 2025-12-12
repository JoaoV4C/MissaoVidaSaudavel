extends VBoxContainer

@onready var apples_container = $apples_container
@onready var carrots_container = $carrots_container

var player
var apple_borders = []
var carrot_borders = []
const BORDER_WIDTH = 1
const BORDER_PADDING = 2  # Espaço entre a borda e o conteúdo

func _ready():
	# Encontrar o player
	player = get_tree().get_first_node_in_group("Player")
	
	# Criar 4 bordas para maçã (topo, baixo, esquerda, direita)
	create_borders(apples_container, apple_borders)
	
	# Criar 4 bordas para cenoura
	create_borders(carrots_container, carrot_borders)
	
	# Inicializar com apple visível
	set_borders_visible(apple_borders, true)
	set_borders_visible(carrot_borders, false)

func create_borders(container: Control, border_array: Array):
	var border_color = Color(1, 1, 0, 1)  # Amarelo
	
	# Borda superior
	var top = ColorRect.new()
	top.color = border_color
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(top)
	container.move_child(top, 0)
	border_array.append(top)
	
	# Borda inferior
	var bottom = ColorRect.new()
	bottom.color = border_color
	bottom.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(bottom)
	container.move_child(bottom, 0)
	border_array.append(bottom)
	
	# Borda esquerda
	var left = ColorRect.new()
	left.color = border_color
	left.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(left)
	container.move_child(left, 0)
	border_array.append(left)
	
	# Borda direita
	var right = ColorRect.new()
	right.color = border_color
	right.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(right)
	container.move_child(right, 0)
	border_array.append(right)

func set_borders_visible(border_array: Array, visible: bool):
	for border in border_array:
		border.visible = visible

func update_borders(container: Control, border_array: Array):
	if border_array.size() != 4:
		return
	
	var size = container.size
	var offset = -BORDER_PADDING
	var extended = BORDER_PADDING * 2
	
	# Borda superior
	border_array[0].position = Vector2(offset, offset)
	border_array[0].size = Vector2(size.x + extended, BORDER_WIDTH)
	
	# Borda inferior
	border_array[1].position = Vector2(offset, size.y + BORDER_PADDING)
	border_array[1].size = Vector2(size.x + extended, BORDER_WIDTH)
	
	# Borda esquerda
	border_array[2].position = Vector2(offset, offset)
	border_array[2].size = Vector2(BORDER_WIDTH, size.y + extended)
	
	# Borda direita
	border_array[3].position = Vector2(size.x + BORDER_PADDING, offset)
	border_array[3].size = Vector2(BORDER_WIDTH, size.y + extended)

func _process(_delta):
	if not player:
		player = get_tree().get_first_node_in_group("Player")
		return
	
	# Atualizar posição e tamanho das bordas
	update_borders(apples_container, apple_borders)
	update_borders(carrots_container, carrot_borders)
	
	# Atualizar visibilidade baseado na arma atual
	if player.current_projectile == 0:  # APPLE
		set_borders_visible(apple_borders, true)
		set_borders_visible(carrot_borders, false)
	else:  # CARROT
		set_borders_visible(apple_borders, false)
		set_borders_visible(carrot_borders, true)
