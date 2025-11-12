extends PanelContainer

class_name TextInput

const MAX_LENGTH: int = 16

@export var line_edit: LineEdit
@export var length_label: Label
@export var keyboard: Keyboard

func _ready() -> void:
    line_edit.max_length = MAX_LENGTH
    line_edit.text_changed.connect(_on_text_changed)

    keyboard.key_pressed.connect(_on_key_pressed)

    if focus_next:
        keyboard.focus_next = get_node(focus_next).get_path()

func _on_text_changed(text: String) -> void:
    length_label.text = str(text.length()) + "/" + str(MAX_LENGTH)

func _on_key_pressed(key_data: Dictionary) -> void:
    var keycode = key_data.get("keycode")
    var text = key_data.get("text")
    var action = key_data.get("action")

    if (action != null):
        _on_action_pressed(action)
    elif (text != null):
        _on_character_entered(text)
    else:
        _on_keycode_pressed(keycode)

func _on_keycode_pressed(keycode: int) -> void:
    if (keycode == KEY_SPACE):
        _on_space_key_pressed()
    elif (keycode == KEY_BACKSPACE):
        _on_backspace_key_pressed()
    elif (keycode == KEY_LEFT):
        _on_left_key_pressed()
    elif (keycode == KEY_RIGHT):
        _on_right_key_pressed()

func _on_action_pressed(action: Keyboard.SpecialActions) -> void:
    if (action == Keyboard.SpecialActions.VALIDATE):
        _on_validate_key_pressed()

func _on_space_key_pressed() -> void:
    line_edit.insert_text_at_caret(" ")
    line_edit.text_changed.emit(line_edit.text)

func _on_backspace_key_pressed() -> void:
    line_edit.delete_char_at_caret()
    line_edit.text_changed.emit(line_edit.text)

func _on_left_key_pressed() -> void:
    line_edit.set_caret_column(line_edit.get_caret_column() - 1)
    line_edit.text_changed.emit(line_edit.text)

func _on_right_key_pressed() -> void:
    line_edit.set_caret_column(line_edit.get_caret_column() + 1)
    line_edit.text_changed.emit(line_edit.text)

func _on_validate_key_pressed() -> void:
    var next_valid_focus = find_next_valid_focus()
    if (next_valid_focus == null):
        return
    next_valid_focus.grab_focus()

func _on_character_entered(text: String) -> void:
    line_edit.insert_text_at_caret(text)
    line_edit.text_changed.emit(line_edit.text)
