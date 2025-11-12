@tool
extends PanelContainer

class_name Keyboard

enum SpecialActions {
    VALIDATE,
}

signal key_pressed(key: String)

var _special_key_datas = {
    "backspace": {"id": "backspace", "keycode": KEY_BACKSPACE, "icon": "arrow-left", "span": 2},
    "enter": {"id": "enter", "action": SpecialActions.VALIDATE, "icon": "corner-down-left", "span": 2},
    "shift-left": {"id": "shift-left", "icon": "arrow-big-up", "span": 2, "switch": ["default", "caps"]},
    "shift-right": {"id": "shift-right", "icon": "arrow-big-up", "span": 2, "switch": ["default", "caps"]},
    "specials": {"id": "specials", "text": "&123", "span": 2, "switch": ["default", "specials"]},
    "space": {"id": "space", "keycode": KEY_SPACE, "icon": "space", "span": 3},
    "left": {"id": "left", "keycode": KEY_LEFT, "icon": "chevron-left"},
    "right": {"id": "right", "keycode": KEY_RIGHT, "icon": "chevron-right"},
    "validate": {"id": "validate", "action": SpecialActions.VALIDATE, "icon": "square-arrow-down", "span": 2},
}

var _layout = [
    [ {"id": "q", "keycode": KEY_Q + 32, "text": "q"}, {"id": "w", "keycode": KEY_W + 32, "text": "w"}, {"id": "e", "keycode": KEY_E + 32, "text": "e"}, {"id": "r", "keycode": KEY_R + 32, "text": "r"}, {"id": "t", "keycode": KEY_T + 32, "text": "t"}, {"id": "y", "keycode": KEY_Y + 32, "text": "y"}, {"id": "u", "keycode": KEY_U + 32, "text": "u"}, {"id": "i", "keycode": KEY_I + 32, "text": "i"}, {"id": "o", "keycode": KEY_O + 32, "text": "o"}, {"id": "p", "keycode": KEY_P + 32, "text": "p"}, _special_key_datas.backspace],
    [ {"id": "a", "keycode": KEY_A + 32, "text": "a"}, {"id": "s", "keycode": KEY_S + 32, "text": "s"}, {"id": "d", "keycode": KEY_D + 32, "text": "d"}, {"id": "f", "keycode": KEY_F + 32, "text": "f"}, {"id": "g", "keycode": KEY_G + 32, "text": "g"}, {"id": "h", "keycode": KEY_H + 32, "text": "h"}, {"id": "j", "keycode": KEY_J + 32, "text": "j"}, {"id": "k", "keycode": KEY_K + 32, "text": "k"}, {"id": "l", "keycode": KEY_L + 32, "text": "l"}, _special_key_datas.enter],
    [_special_key_datas.get("shift-left"), {"id": "z", "keycode": KEY_Z + 32, "text": "z"}, {"id": "x", "keycode": KEY_X + 32, "text": "x"}, {"id": "c", "keycode": KEY_C + 32, "text": "c"}, {"id": "v", "keycode": KEY_V + 32, "text": "v"}, {"id": "b", "keycode": KEY_B + 32, "text": "b"}, {"id": "n", "keycode": KEY_N + 32, "text": "n"}, {"id": "m", "keycode": KEY_M + 32, "text": "m"}, _special_key_datas.get("shift-right")],
    [_special_key_datas.specials, _special_key_datas.space, _special_key_datas.left, _special_key_datas.right, _special_key_datas.validate],
]

var _caps_layout = [
    [ {"id": "q", "keycode": KEY_Q, "text": "Q"}, {"id": "w", "keycode": KEY_W, "text": "W"}, {"id": "e", "keycode": KEY_E, "text": "E"}, {"id": "r", "keycode": KEY_R, "text": "R"}, {"id": "t", "keycode": KEY_T, "text": "T"}, {"id": "y", "keycode": KEY_Y, "text": "Y"}, {"id": "u", "keycode": KEY_U, "text": "U"}, {"id": "i", "keycode": KEY_I, "text": "I"}, {"id": "o", "keycode": KEY_O, "text": "O"}, {"id": "p", "keycode": KEY_P, "text": "P"}, _special_key_datas.backspace],
    [ {"id": "a", "keycode": KEY_A, "text": "A"}, {"id": "s", "keycode": KEY_S, "text": "S"}, {"id": "d", "keycode": KEY_D, "text": "D"}, {"id": "f", "keycode": KEY_F, "text": "F"}, {"id": "g", "keycode": KEY_G, "text": "G"}, {"id": "h", "keycode": KEY_H, "text": "H"}, {"id": "j", "keycode": KEY_J, "text": "J"}, {"id": "k", "keycode": KEY_K, "text": "K"}, {"id": "l", "keycode": KEY_L, "text": "L"}, _special_key_datas.enter],
    [_special_key_datas.get("shift-left"), {"id": "z", "keycode": KEY_Z, "text": "Z"}, {"id": "x", "keycode": KEY_X, "text": "X"}, {"id": "c", "keycode": KEY_C, "text": "C"}, {"id": "v", "keycode": KEY_V, "text": "V"}, {"id": "b", "keycode": KEY_B, "text": "B"}, {"id": "n", "keycode": KEY_N, "text": "N"}, {"id": "m", "keycode": KEY_M, "text": "M"}, _special_key_datas.get("shift-right")],
    [_special_key_datas.specials, _special_key_datas.space, _special_key_datas.left, _special_key_datas.right, _special_key_datas.validate],
]

var specials_layout = [
    [ {"id": "one", "keycode": KEY_1, "text": "1"}, {"id": "two", "keycode": KEY_2, "text": "2"}, {"id": "three", "keycode": KEY_3, "text": "3"}, {"id": "four", "keycode": KEY_4, "text": "4"}, {"id": "five", "keycode": KEY_5, "text": "5"}, {"id": "six", "keycode": KEY_6, "text": "6"}, {"id": "seven", "keycode": KEY_7, "text": "7"}, {"id": "eight", "keycode": KEY_8, "text": "8"}, {"id": "nine", "keycode": KEY_9, "text": "9"}, {"id": "zero", "keycode": KEY_0, "text": "0"}, _special_key_datas.backspace],
    [
        {"id": "exclamation", "keycode": KEY_EXCLAM, "text": "!"},
        {"id": "at", "keycode": KEY_QUOTEDBL, "text": "@"},
        {"id": "number_sign", "keycode": KEY_NUMBERSIGN, "text": "#"},
        {"id": "dollar", "keycode": KEY_DOLLAR, "text": "$"},
        {"id": "percent", "keycode": KEY_PERCENT, "text": "%"},
        {"id": "ampersand", "keycode": KEY_AMPERSAND, "text": "&"},
        {"id": "asterisk", "keycode": KEY_ASTERISK, "text": "*"},
        {"id": "plus", "keycode": KEY_PLUS, "text": "+"},
        {"id": "minus", "keycode": KEY_MINUS, "text": "-"},
        _special_key_datas.enter],
    [
        _special_key_datas.get("shift-left"),
        {"id": "equal", "keycode": KEY_EQUAL, "text": "="},
        {"id": "underscore", "keycode": KEY_UNDERSCORE, "text": "_"},
        {"id": "slash", "keycode": KEY_SLASH, "text": "/"},
        {"id": "backslash", "keycode": KEY_BACKSLASH, "text": "\\"},
        {"id": "less", "keycode": KEY_LESS, "text": "<"},
        {"id": "greater", "keycode": KEY_GREATER, "text": ">"},
        {"id": "question", "keycode": KEY_QUESTION, "text": "?"},
        _special_key_datas.get("shift-right"),
    ],
    [_special_key_datas.specials, _special_key_datas.space, _special_key_datas.left, _special_key_datas.right, _special_key_datas.validate],
]

var _layouts = {
    "default": _layout,
    "caps": _caps_layout,
    "specials": specials_layout,
}

var _default_layout = "default"
var _current_layout = _default_layout

var _key_buttons: Dictionary = {
    "default": {},
    "caps": {},
    "specials": {},
}

func _add_button(layout_id: String, id: String, keycode: int, button: AnimatedButton) -> void:
    _key_buttons[layout_id][id] = {"keycode": keycode, "button": button}

func _get_button_by_id(layout_id: String, id: String) -> AnimatedButton:
    return _key_buttons[layout_id][id]["button"]

func _get_buttons_by_keycode_from_all_layouts(keycode: int) -> Array:
    return _layouts.keys().reduce(func(buttons, layout_id): return buttons + _get_buttons_by_keycode(layout_id, keycode), [])

func _get_buttons_by_keycode(layout_id: String, keycode: int) -> Array:
    return _key_buttons[layout_id].values().filter(func(key_button): return key_button["keycode"] == keycode).map(func(key_button): return key_button["button"])

func _get_first_button(layout_id: String) -> AnimatedButton:
    return _key_buttons[layout_id].values()[0]["button"]

var _keyboard_containers: Dictionary = {}

func _ready() -> void:
    _create_keyboards()
    _setup_keyboards_focus_order.call_deferred()
    _switch_layout.call_deferred(_current_layout)

    focus_entered.connect(_on_focus_entered)

func _on_focus_entered() -> void:
    var first_key_button = _get_first_button(_current_layout)
    if (first_key_button == null):
        return
    first_key_button.grab_focus()

func _on_key_pressed(key_data: Dictionary) -> void:
    key_pressed.emit(key_data)

func _on_switch_pressed(id: String, switch: Array) -> void:
    var layout_index = switch.find(_current_layout)
    if layout_index == -1:
        layout_index = 0
    else:
        layout_index = (layout_index + 1) % switch.size()

    for layout_name in _layouts.keys():
        for row in _layouts[layout_name]:
            for key_data in row:
                if key_data.has("switch") and key_data.get("switch").hash() == switch.hash() or key_data.get("id") == id:
                    _get_button_by_id(layout_name, key_data.get("id")).set_pressed_no_signal(layout_index > 0)

    var layout_name = switch[layout_index]
    for row in _layouts[layout_name]:
        for key_data in row:
            if key_data.has("switch") and key_data.get("switch").hash() == switch.hash() and key_data.get("id") == id:
                _get_button_by_id(layout_name, key_data.get("id")).grab_focus.call_deferred()

    _switch_layout(switch[layout_index])

func _create_keyboards() -> void:
    for layout_name in _layouts.keys():
        var keyboard = _create_keyboard(layout_name, _layouts[layout_name])
        add_child(keyboard)
        _keyboard_containers[layout_name] = keyboard

func _create_keyboard(layout_id: String, layout: Array) -> VBoxContainer:
    var keyboard_container = VBoxContainer.new()
    keyboard_container.size_flags_horizontal = SIZE_EXPAND_FILL
    keyboard_container.size_flags_vertical = SIZE_EXPAND_FILL

    for row in layout:
        var row_container = HBoxContainer.new()
        row_container.size_flags_horizontal = SIZE_EXPAND_FILL
        row_container.size_flags_vertical = SIZE_EXPAND_FILL

        for key_data in row:
            var id = key_data.get("id")
            var keycode = key_data.get("keycode") if key_data.has("keycode") else -1

            var key_button = AnimatedButton.new()
            _add_button(layout_id, id, keycode, key_button)

            if key_data.has("icon"):
                key_button.icon = load("res://assets/ui/" + key_data.get("icon") + ".png")
                key_button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
                key_button.add_theme_constant_override("icon_max_width", 32)
            else:
                key_button.text = key_data.get("text")

            key_button.size_flags_horizontal = SIZE_EXPAND_FILL
            key_button.size_flags_vertical = SIZE_EXPAND_FILL
            key_button.size_flags_stretch_ratio = key_data.get("span") if key_data.has("span") else 1

            key_button.add_theme_font_size_override("font_size", 32)

            if key_data.has("switch"):
                key_button.pressed.connect(func(): _on_switch_pressed(id, key_data.get("switch")))
                key_button.toggle_mode = true
            else:
                key_button.pressed.connect(_on_key_pressed.bind(key_data))

            row_container.add_child(key_button)

        keyboard_container.add_child(row_container)

    return keyboard_container

func _setup_keyboards_focus_order() -> void:
    for layout_name in _layouts.keys():
        _setup_focus_order(layout_name, _layouts[layout_name])

func _get_distance_between_buttons(button_1: AnimatedButton, button_2: AnimatedButton) -> int:
    var position_1 = button_1.global_position.x + button_1.size.x / 2
    var position_2 = button_2.global_position.x + button_2.size.x / 2
    return abs(position_1 - position_2)

func _setup_focus_order(layout_id: String, layout: Array) -> void:
    for row_index in range(layout.size()):
        var row = layout[row_index]

        var top_row_index = (row_index - 1) % layout.size()
        var bottom_row_index = (row_index + 1) % layout.size()

        var top_row = layout[top_row_index]
        var bottom_row = layout[bottom_row_index]

        for key_index in range(row.size()):
            var id = row[key_index].get("id")

            var button = _get_button_by_id(layout_id, id)
            var left_index = (key_index - 1) % row.size()
            var right_index = (key_index + 1) % row.size()

            var neighbor_left_id = row[left_index].get("id")
            var neighbor_right_id = row[right_index].get("id")

            var neighbor_top_button = top_row.map(func(row_key_data): return _get_button_by_id(layout_id, row_key_data.get("id"))).reduce(func(closest_button, candidate_button): return closest_button if _get_distance_between_buttons(closest_button, button) < _get_distance_between_buttons(candidate_button, button) else candidate_button)
            var neighbor_bottom_button = bottom_row.map(func(row_key_data): return _get_button_by_id(layout_id, row_key_data.get("id"))).reduce(func(closest_button, candidate_button): return closest_button if _get_distance_between_buttons(closest_button, button) < _get_distance_between_buttons(candidate_button, button) else candidate_button)

            button.focus_mode = Control.FOCUS_ALL
            button.focus_neighbor_left = _get_button_by_id(layout_id, neighbor_left_id).get_path()
            button.focus_neighbor_right = _get_button_by_id(layout_id, neighbor_right_id).get_path()

            button.focus_neighbor_top = neighbor_top_button.get_path()
            button.focus_neighbor_bottom = neighbor_bottom_button.get_path()

            # Should focus out of keyboard on ui_focus_next/previous key pressed if focus_next/previous are set
            if focus_next:
                var focus_next_node = get_node(focus_next)
                button.focus_next = focus_next_node.get_path()
            if focus_previous:
                var focus_previous_node = get_node(focus_previous)
                button.focus_previous = focus_previous_node.get_path()

func _switch_layout(layout_id: String) -> void:
    for layout_name in _layouts.keys():
        _keyboard_containers[layout_name].visible = false

    _current_layout = layout_id
    _keyboard_containers[_current_layout].visible = true
