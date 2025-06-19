extends Area2D

class_name EndArea

@export var next_scene: PackedScene

func _ready() -> void:
    body_entered.connect(on_body_entered)

func load_next_scene() -> void:
    var tree = get_tree()
    tree.change_scene_to_packed(next_scene)

func on_body_entered(body: Node2D) -> void:
    if (body is not ProjectileCharacter):
        return

    load_next_scene.call_deferred()