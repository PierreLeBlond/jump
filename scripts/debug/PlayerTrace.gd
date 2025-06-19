@tool
extends Node2D

class_name PlayerTrace

@export var player: ProjectileCharacter

var last_position: Vector2

var points: Array[Vector2] = []

# Do not forget to reload saved scene after running the game to update the trace
func _ready() -> void:
    last_position = player.global_position
    if (Engine.is_editor_hint()):
      _load_points()
    else:
      _clear_points()

func _draw() -> void:
    for i in range(points.size() - 1):
        draw_line(points[i], points[i + 1], Color.RED, 2)

func _process(_delta: float) -> void:
    if (Engine.is_editor_hint()):
        return

    var current_position = player.global_position
    if (current_position == last_position):
        return

    points.append(current_position)
    last_position = current_position
    _save_points()
    queue_redraw()

func _save_points() -> void:
    var file = FileAccess.open("res://scripts/debug/player_trace.json", FileAccess.WRITE)
    file.store_var(points)
    file.close()

func _load_points() -> void:
    var file = FileAccess.open("res://scripts/debug/player_trace.json", FileAccess.READ)
    if (!file):
        return
    points = file.get_var()
    file.close()

func _clear_points() -> void:
    var file = FileAccess.open("res://scripts/debug/player_trace.json", FileAccess.WRITE)
    file.store_var([])
    file.close()