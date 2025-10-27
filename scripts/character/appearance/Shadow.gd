extends Node2D

class_name Shadow

@export var player: Player
@export var remote_transform: RemoteTransform2D

@export var shadow_receiver: Node2D

@export var sub_viewport: SubViewport

@export var view: Node2D

var _shadow_sprite: Sprite2D

func _ready() -> void:
    _shadow_sprite = player.sprite_2d.duplicate()
    view.add_child(_shadow_sprite)

func _process(_delta: float) -> void:
    # make the shadow match the player's animated sprite
    # TODO: offset the shadow contact point when the animation requires it
    _shadow_sprite.frame = player.sprite_2d.frame

    # make the subviewport's camera to be the same as the main viewport one
    sub_viewport.canvas_transform = get_viewport().get_canvas_transform()

    # make the render of the subviewport follow the main viewport's camera
    shadow_receiver.global_position = get_viewport().get_camera_2d().get_screen_center_position()
    shadow_receiver.scale = Vector2(1.0 / get_viewport().get_camera_2d().zoom.x, 1.0 / get_viewport().get_camera_2d().zoom.y)
