extends Node2D

signal card_flipped

@export var card_type: int = -1
var is_flipped = false
var is_matched = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $Sprite2D/AnimatedSprite2D

# Detect mouse click events on the card
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_local_mouse_position()
		if $Sprite2D.get_rect().has_point(mouse_position):
			print("Card clicked:", card_type)
			flip()  # Trigger the flip

func flip():
	if is_flipped or is_matched:
		return
	is_flipped = true
	animation_player.play("card_flip")
	animated_sprite.frame = card_type
	emit_signal("card_flipped", self)
		
func flip_back():
	if is_matched:
		return
	is_flipped = false
	animation_player.play_backwards("card_flip")

#func _input(event):
	#if event.is_action_pressed("flip_card"):
		#print("Card clicked:", self)
		#animation_player.play("card_flip")
		#is_flipped = !is_flipped
		#flip()
		
#func is_hovered() -> bool:
	## Check if the mouse is over the card (you can improve this with an Area2D)
	#var mouse_pos = get_global_mouse_position()
	#return $Sprite.get_rect().has_point(mouse_pos - global_position)
