extends GutTest

var _text_input_scene: PackedScene = preload("res://scenes/ui/components/TextInput.tscn")

var _text_input: TextInput
var _line_edit: LineEdit
var _keyboard: Keyboard

var _input_sender = InputSender.new(Input)

func before_each():
    _text_input = _text_input_scene.instantiate()
    add_child(_text_input)

    _line_edit = _text_input.find_children("*", "LineEdit")[0]
    _keyboard = _text_input.find_children("*", "Keyboard")[0]

    # Wait for call_deferred calls from _ready methods
    await get_tree().process_frame

func after_each():
    _input_sender.release_all()
    _input_sender.clear()

    remove_child(_text_input)
    _text_input.free()
    _text_input = null

    # Wait for child to be removed
    await get_tree().process_frame

# gut does not send unicode with key events, resulting in line edit not consuming the event
func _send_key_event_with_unicode(key: int):
    var own_event = InputEventKey.new()
    own_event.shift_pressed = false
    own_event.alt_pressed = false
    own_event.meta_pressed = false
    own_event.ctrl_pressed = false
    own_event.pressed = true
    own_event.keycode = key
    own_event.unicode = key if key != KEY_TAB else 0 # Fixes tab key being interpreted as a character

    Input.parse_input_event(own_event)

func _click_key_button(id: String):
    var key_button = _keyboard._get_button_by_id("default", id)
    var position = key_button.global_position + Vector2(32, 32)

    var down_event = InputEventMouseButton.new()
    down_event.button_index = MOUSE_BUTTON_LEFT
    down_event.position = get_viewport().get_screen_transform() * position
    down_event.pressed = true
    Input.parse_input_event(down_event)

    var up_event = InputEventMouseButton.new()
    up_event.button_index = MOUSE_BUTTON_LEFT
    up_event.position = get_viewport().get_screen_transform() * position
    up_event.pressed = false
    Input.parse_input_event(up_event)

    await get_tree().process_frame


func test_should_have_one_line_edit():
    var line_edits = _text_input.find_children("*", "LineEdit")
    assert_eq(line_edits.size(), 1)

func test_should_have_one_keyboard():
    var keyboards = _text_input.find_children("*", "Keyboard")
    assert_eq(keyboards.size(), 1)

func test_sould_emit_on_key_down():
    var sender = InputSender.new(_keyboard)

    watch_signals(_keyboard)

    sender.key_down(KEY_Q)

    assert_signal_emitted(_keyboard, "key_pressed")

func test_should_insert_text_at_caret_on_key_pressed():
    var sender = InputSender.new(_keyboard)

    sender.key_down(KEY_Q)

    assert_eq(_line_edit.text, "q")

func test_should_not_emit_on_line_edit_key_pressed():
    watch_signals(_keyboard)

    _line_edit.grab_focus()
    _line_edit.edit()

    _send_key_event_with_unicode(KEY_Q + 32)

    await get_tree().process_frame

    assert_signal_not_emitted(_keyboard, "key_pressed")
    assert_eq(_line_edit.text, "q")

func test_should_insert_text_at_caret_on_key_clicked():
    await _click_key_button("q")

    assert_eq(_line_edit.text, "q")

func test_should_insert_space_at_caret_on_space_key_pressed():
    var sender = InputSender.new(_keyboard)

    sender.key_down(KEY_SPACE)

    assert_eq(_line_edit.text, " ")

func test_should_not_treat_space_as_ui_accept():
    var q_button = _keyboard._get_button_by_id("default", "q")
    q_button.grab_focus()

    _input_sender.key_down(KEY_SPACE).wait_frames(TestGlobals.WAIT_FRAMES_COUNT).key_up(KEY_SPACE).wait_frames(TestGlobals.WAIT_FRAMES_COUNT)

    await (_input_sender.idle)

    assert_eq(_line_edit.text, " ")

func test_should_remove_text_at_caret_on_backspace_key_pressed():
    var sender = InputSender.new(_keyboard)

    sender.key_down(KEY_Q)

    assert_eq(_line_edit.text, "q")

    sender.key_down(KEY_BACKSPACE)

    assert_eq(_line_edit.text, "")

func test_should_move_caret_left_on_left_key_pressed():
    var sender = InputSender.new(_keyboard)

    sender.key_down(KEY_Q)
    sender.key_down(KEY_LEFT)

    assert_eq(_line_edit.caret_column, 0)

func test_should_move_caret_right_on_right_key_pressed():
    var sender = InputSender.new(_keyboard)

    sender.key_down(KEY_Q)
    sender.key_down(KEY_LEFT)
    sender.key_down(KEY_RIGHT)

    assert_eq(_line_edit.caret_column, 1)

func test_should_focus_out_of_keyboard_on_validate_key_pressed():
    var q_button = _keyboard._get_button_by_id("default", "q")
    q_button.grab_focus()

    var another_button = Button.new()
    another_button.text = "Another Button"
    add_child(another_button)

    await get_tree().process_frame

    _text_input.focus_next = another_button.get_path()

    await _click_key_button("validate")

    assert_eq(q_button.has_focus(), false)
    assert_eq(another_button.has_focus(), true)

    remove_child(another_button)
    another_button.free()
    another_button = null

func test_should_insert_text_on_key_ui_accept():
    var q_button = _keyboard._get_button_by_id("default", "q")
    q_button.grab_focus()

    _input_sender.key_down(KEY_ENTER).wait_frames(TestGlobals.WAIT_FRAMES_COUNT).key_up(KEY_ENTER).wait_frames(TestGlobals.WAIT_FRAMES_COUNT)
    await (_input_sender.idle)

    assert_eq(_line_edit.text, "q")
