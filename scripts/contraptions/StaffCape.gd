extends Node2D

class_name StaffCape

@export var player: Player
@export var polygon_2d: Polygon2D

@export var label: Label

@export var offset: Vector2 = Vector2(0, 0)
@export var speed: Vector2 = Vector2(1.0, 1.0)

@export var cape_length: float = 128.0

var _bones: Array[Bone2D]

func _ready() -> void:
    for bone in find_children("*", "", true, false):
        if bone is Bone2D:
            _bones.append(bone)

    var bones_count = _bones.size()
    var spacing = cape_length / (bones_count - 1)
    for i in range(bones_count):
        var bone = _bones[i]
        var target_position = get_bone_target_position(i, spacing)
        bone.global_position.x = target_position.x
        bone.global_position.y = target_position.y

    update_label(0)
    
func get_bone_target_position(index: int, spacing: float) -> Vector2:
    return player.global_position - Vector2((offset.x + index * spacing) * player.direction, offset.y)
    
func update(delta: float, ratio: float) -> void:
    update_bones(delta, ratio)

func update_label(count: int) -> void:
    label.text = "= " + str(count)

func update_bones(delta: float, ratio: float) -> void:
    var bones_count = _bones.size()
    var spacing = cape_length / (bones_count - 1)
    for i in range(bones_count):
        var bone = _bones[i]
        var vertical_weight = 1.0 - pow(float(i) * 0.1, speed.y)
        var horizontal_weight = 1.0 - pow(float(i) * 0.1, speed.x)
        var target_position = get_bone_target_position(i, spacing)
        bone.global_position.x = lerp(bone.global_position.x, target_position.x, horizontal_weight)
        bone.global_position.y = lerp(bone.global_position.y, target_position.y, vertical_weight)

    var offset_x = polygon_2d.material.get_shader_parameter("offset_x")
    polygon_2d.material.set_shader_parameter("offset_x", lerp(offset_x, 1.0 - ratio, delta * 10.0))
