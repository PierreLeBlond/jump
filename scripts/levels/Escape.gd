extends Node

class_name Escape

@onready var souba_coupe: SoubaCoupe = $SoubaCoupe

@onready var end_area: Area2D = $EndArea

func _ready() -> void:
    souba_coupe.captured_player.connect(on_player_captured)
    end_area.body_entered.connect(on_player_entered_end_area)

func end_game() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func on_player_captured() -> void:
    call_deferred("end_game")

func on_player_entered_end_area(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    call_deferred("end_game")
