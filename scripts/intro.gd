extends Control # Ou Node2D, dependendo do nó raiz.

# Dicionário ou Array para armazenar Imagens e Legendas
# O formato aqui é: [["caminho/para/imagem1.png", "Primeira Legenda"], ["caminho/para/imagem2.png", "Segunda Legenda"], ...]
const INTRO_SLIDES = [
	["res://assets/intro_img/slide_1.png", "Era uma vez uma cidade naturalmente radiante chamada de Vila Viva. Seus edificios sao coloridos, os parques estao sempre cheios de criancas brincando, e no centro da cidade fica a Fonte da Saude, um monumento magico que irradia energia e vitalidade para todos os moradores. A Vila Viva prosperava com base em habitos saudaveis; todos amavam frutas, vegetais e passar tempo ao ar livre."],
	["res://assets/intro_img/slide_2.png", "Mas a alegria foi interrompida no Dia da Grande Preguica. Sob a lideranca do terrivel MegaBurgerz, uma legiao de criaturas pegajosas conhecidas como Junkz invadiu a cidade com um unico objetivo: roubar a vitalidade de todos e espalhar a preguica. O medo e o desanimo tomaram conta da Vila Viva, e o brilho dos moradores comecou a se apagar."],
	["res://assets/intro_img/slide_3.png", "Os Junkz eram implacaveis. Os Burgerz e Fritoz cobriram os parques com pocas de oleo e gordura, tornando o chao escorregadio e as criancas lentas demais para brincar. Ao mesmo tempo, os Sodaz poluiram todos os riachos e fontes, contaminando a agua pura e, pior, cobrindo a Fonte da Saude com uma gosma escura e nojenta, sugando toda a sua magia."],
	["res://assets/intro_img/slide_4.png", "Mas ha uma esperanca! Leo, nosso pequeno heroi, descobriu que, ao consumir as frutas e verduras restantes, ele ganha poderes especiais. Somente com a coragem de fazer escolhas saudaveis e usar o poder da natureza voce podera enfrentar os Junkz, restaurar a Fonte da Saude e salvar a Vila Viva!"],
	
]

var current_slide_index = 0

# Referências aos nós da interface
@onready var current_image = $ImageContainer/CurrentImage as TextureRect
@onready var current_caption = $ImageContainer/CurrentCaption as Label
@onready var button_prompt = $ButtonPrompt as Label # Opcional: para mostrar o prompt

# Variável para o nome da cena do jogo para onde vamos transicionar
const GAME_SCENE_PATH = "res://scenes/main_game.tscn"


func _ready():
	# Inicializa a apresentação com o primeiro slide
	_display_current_slide()
	
	# Configurar mensagem do botão
	if button_prompt:
		button_prompt.text = "Pressione ESPACO para avancar"


func _input(event):
	# Detecta a entrada para avançar o slide (pode ser "ui_accept" ou "space")
	if event.is_action_pressed("ui_accept"): # Mapeie "ui_accept" para a tecla que você deseja
		_advance_slide()


func _display_current_slide():
	# Verifica se ainda há slides para exibir
	if current_slide_index < INTRO_SLIDES.size():
		var slide_data = INTRO_SLIDES[current_slide_index]
		var image_path = slide_data[0]
		var caption_text = slide_data[1]

		# 1. Carregar e Exibir a Imagem
		var texture = load(image_path)
		if texture:
			current_image.texture = texture
			
		# 2. Exibir a Legenda
		current_caption.text = caption_text
		
		# Opcional: Adicionar um efeito de fadeIn/out aqui para a imagem e legenda.
		
	else:
		# Se todos os slides foram exibidos, transiciona para a cena do jogo
		_start_game()


func _advance_slide():
	# Incrementa o índice para o próximo slide
	current_slide_index += 1
	_display_current_slide()


func _start_game():
	get_tree().change_scene_to_file("res://scene/main_game.tscn")
