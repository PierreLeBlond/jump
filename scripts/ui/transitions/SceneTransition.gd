extends CanvasLayer

class_name SceneTransition

@export var animation_player: AnimationPlayer

func transition_in() -> void:
    show()
    animation_player.play("transition")
    await animation_player.animation_finished
    await get_tree().process_frame

func transition_out() -> void:
    show()
    animation_player.play_backwards("transition")
    await animation_player.animation_finished
    await get_tree().process_frame