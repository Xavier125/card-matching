extends Node2D

@export var total_pairs: int = 5
@export var heart_scene: PackedScene
@export var card_scene: PackedScene
@onready var gameover_label: Label = $GameoverLabel
@onready var v_box_container: VBoxContainer = $VBoxContainer

var selected_cards = []
var matches_found = 0
var health = 5
var is_game_over = false

func _ready():
	setup_game()
	
func setup_game():
	print("Setting up game...")
	var card_types = []
	for i in range(total_pairs):
		card_types.append(i)
		card_types.append(i)
	card_types.shuffle()
	
	var rows = 2
	var cols = 5
	var card_size = Vector2(100, 150)
	var start_pos = Vector2(100, 100)
	
	# Create cards
	for i in range(card_types.size()):
		var card = card_scene.instantiate()
		card.card_type = card_types[i]
		card.connect("card_flipped", Callable(self, "_on_card_flipped"))
		var row = i / cols
		var col = i % cols
		card.position = start_pos + Vector2(col * card_size.x, row * card_size.y)
		$GridContainer.add_child(card)

	# Create health hearts
	for i in range(health):
		var heart = heart_scene.instantiate()
		var row = i / cols
		var col = i % cols
		heart.position = start_pos + Vector2(col * card_size.x, row * card_size.y)
		$HBoxContainer.add_child(heart)

func _on_card_flipped(card):
	if card in selected_cards or card.is_matched:
		return

	selected_cards.append(card)

	if selected_cards.size() == 2:
		check_match()
		
func check_match():
	if selected_cards[0].card_type == selected_cards[1].card_type:
		for card in selected_cards:
			card.is_matched = true
		matches_found += 1

		if matches_found == total_pairs:
			is_game_over = true
			_on_game_over()
	else:
		health -= 1
		update_health()
		if health <= 0:
			is_game_over = true
			_on_game_over()
		else:
			await get_tree().create_timer(2.0)
			for card in selected_cards:
				card.flip_back()

	selected_cards.clear()

func update_health():
	for i in range($HBoxContainer.get_child_count()):
		$HBoxContainer.get_child(i).visible = i < health

func _on_game_over():
	Engine.time_scale = 0
	if health <= 0 and is_game_over == true:
		gameover_label.visible = true
		gameover_label.text = "Game Over!"
	else:
		gameover_label.visible = true
		gameover_label.text = "You Win!"
	v_box_container.visible = true
	
func _on_play_again_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://menu.tscn")
