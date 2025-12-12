# 🥗 Missão Vida Saudável

Um jogo educativo de plataforma 2D desenvolvido em Godot 4.4 que ensina sobre alimentação saudável e os perigos dos alimentos ultraprocessados.

## Desenvolvimento

**Desenvolvedor**: João Victor Alves  
**Disciplina**: EXA620 - JOGOS DIGITAIS  
**Professor**: Victor Travassos Sarinho

## Sobre o Projeto

**Missão Vida Saudável** é um jogo educativo onde você defende a Vila Viva contra inimigos que representam alimentos ultraprocessados. Através de mecânicas de combate e plataforma, o jogador aprende sobre a importância de uma alimentação equilibrada enquanto enfrenta ondas de inimigos cada vez mais desafiadoras.

## Gameplay

### Objetivo
Proteger a entrada da Vila Viva derrotando todas as 6 ondas de inimigos, incluindo um chefe final que representa a concentração de maus hábitos alimentares.

### Mecânicas Principais

- **Movimento**: WASD ou Setas do teclado
- **Pulo Duplo**: Barra de Espaço (2x) - consome energia
- **Atirar**: Botão esquerdo do mouse
- **Trocar Arma**: Tecla Q
- **Agachar**: S ou Seta para baixo

### Sistema de Combate

#### Armas
- **Maçã**: Ataque em área com 75 de dano e explosão em raio
- **Cenoura**: Ataque reto com 100 de dano direto
- **Pulo na Cabeça**: 100 de dano ao pular sobre inimigos

#### Sistema de Energia
- Energia inicial: 100 pontos
- Perde 10 de energia a cada duplo pulo
- Perde energia ao percorrer longas distâncias
- Sem energia: movimento lento e sem duplo pulo
- Recupera energia coletando itens no mapa

#### Sistema de Vida
- Começa com **3 corações**
- Máximo de **6 corações**
- Recupera vida coletando corações no chão
- Invencibilidade temporária após dano

### Inimigos

O jogo apresenta 4 tipos de inimigos, cada um representando um tipo de alimento ultraprocessado:

1. **Burgerz** - "A Massa da Preguiça"
   - Inimigo básico corpo a corpo
   - Representa fast food e excesso de gordura

2. **Fritoz** - "O Vício do Sal e do Carbo"
   - Ataca à distância com projéteis
   - Representa alimentos fritos e excesso de sódio

3. **Sodaz** - "A Doce Poluição"
   - Ataca com bolhas de refrigerante
   - Representa bebidas açucaradas
   - Dropa 100% água ao ser derrotado

4. **MegaBurgerz** (Boss) - "A Concentração de Maus Hábitos"
   - Chefe final com ataques poderosos
   - Representa todos os maus hábitos alimentares combinados

### Sistema de Ondas

O jogo possui **6 ondas progressivas**:

1. **Onda 1**: 1 Burgerz (introdução)
2. **Onda 2**: 3 Burgerz, 2 Fritoz, 1 Sodaz
3. **Onda 3**: 4 Burgerz, 3 Fritoz, 1 Sodaz
4. **Onda 4**: 5 Burgerz, 4 Fritoz, 2 Sodaz
5. **Onda 5**: 6 Burgerz, 5 Fritoz, 3 Sodaz
6. **Onda 6**: 3 Burgerz, 3 Fritoz, 2 Sodaz, 1 Boss

### Recursos Coletáveis

- **Maçã**: Munição para ataque em área
- **Cenoura**: Munição para ataque reto
- **Coração**: Recupera 1 vida (máximo 6)
- **Água**: Restaura energia

### Características Educativas

#### Popups Informativos
Na primeira vez que encontrar cada inimigo, aparece um popup educativo mostrando:
- Nome do inimigo
- Descrição do que ele representa
- Tipo de ataque
- Imagem ilustrativa

#### Diálogos do Personagem
O personagem comenta sobre os perigos dos alimentos ultraprocessados:
- Primeira vez ao ver inimigo comum
- Primeira vez ao ver o boss
- Mensagem de vitória ao completar todas as ondas

## Tecnologias

- **Engine**: Godot 4.4
- **Linguagem**: GDScript
- **Resolução**: 300x240 (pixel art style)
- **Plataforma**: Desktop (Windows, Linux, Mac)

## Estrutura do Projeto

```
MissaoVidaSaudavel/
├── assets/           # Recursos visuais (introdução, slides)
├── entities/         # Cenas dos personagens e inimigos
├── fonts/            # Fonte pixelmix.ttf
├── scene/            # Cenas principais (game, intro, tutorial)
├── scripts/          # Scripts GDScript
├── singletons/       # Globals (gerenciamento de estado)
├── sprites/          # Sprites dos personagens e tiles
└── tiles/            # Tilesets e decorações
```

## Conceitos Educativos Abordados

1. **Alimentos Ultraprocessados**: Representados pelos inimigos
2. **Alimentação Saudável**: Representada pelas armas (frutas e vegetais)
3. **Energia e Disposição**: Sistema de energia do personagem
4. **Hidratação**: Água recupera energia
5. **Consequências dos Maus Hábitos**: Boss representa acúmulo de hábitos ruins

## Como Jogar

### Requisitos
- Godot Engine 4.4 ou superior

### Instalação
1. Clone este repositório
2. Abra o projeto no Godot Engine 4.4+
3. Pressione F5 ou clique em "Play" para iniciar

### Dicas para Iniciantes
- Leia o **Tutorial** no menu principal
- Observe os popups informativos sobre cada inimigo
- Gerencie sua energia com cuidado
- Alterne entre maçã e cenoura conforme a situação
- Colete itens sempre que possível

## Sistema de Progressão

- **Ondas Progressivas**: Dificuldade aumenta gradualmente
- **Cooldown de Spawn**: Inimigos têm 1.5s de invulnerabilidade ao nascer
- **Invencibilidade**: 1 segundo após receber dano
- **Z-index Correto**: Todos os elementos renderizam na ordem apropriada

---

**Desenvolvido como projeto educativo sobre alimentação saudável**

*"Seu corpo é mais forte que os alimentos ultraprocessados!"*
