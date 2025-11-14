extends Node

class_name OptionsManager

signal options_closed()

@export var options_menu_scene: PackedScene

var _options_menu: OptionsMenu

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS

    _options_menu = options_menu_scene.instantiate()

func _input(event: InputEvent) -> void:
    if !event.is_action_pressed("ui_cancel") || !get_children().has(_options_menu):
        return

    get_viewport().set_input_as_handled()
    close_options()

func open_options() -> void:
    add_child(_options_menu)
    _options_menu.focus()
    _options_menu.wants_to_quit.connect(close_options)

func close_options() -> void:
    _options_menu.wants_to_quit.disconnect(close_options)
    remove_child(_options_menu)
    emit_signal("options_closed")
