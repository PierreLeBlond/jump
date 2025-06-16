extends Node2D

class_name SoubaCoupe

signal captured_player

@export var speed: float = 100

@export var area2d: Area2D

func end_game() -> void:
    var tree = get_tree()
    tree.change_scene_to_file("res://scenes/ui/TitleScreen.tscn")

func on_body_entered(body: Node2D) -> void:
    if (body is ProjectileCharacter):
        captured_player.emit()
        call_deferred("end_game")

func _ready() -> void:
    area2d.body_entered.connect(on_body_entered)

func _physics_process(delta: float) -> void:
    position += Vector2(speed * delta, 0)