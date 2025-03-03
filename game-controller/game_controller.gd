extends Node2D

# Game state variables
var is_in_shop = false

func _ready():
    # Initialize game (e.g., set up UI, sounds, etc.)
    pass

func change_to_shop():
    is_in_shop = true
    get_tree().change_scene("res://levels/shop.tscn")

func change_to_overworld():
    is_in_shop = false
    get_tree().change_scene("res://levels/overworld.tscn")