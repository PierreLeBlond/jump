extends GutTest

var _keyboard: Keyboard

var _mouse_sender = InputSender.new(Input)

func before_all():
    _mouse_sender.mouse_warp = true
    _mouse_sender.draw_mouse = true

func before_each():
    _keyboard = Keyboard.new()
    add_child(_keyboard)

    # Wait for call_deferred calls from _ready methods
    await get_tree().process_frame

func after_each():
    remove_child(_keyboard)
    _keyboard.free()
    _keyboard = null

    _mouse_sender.release_all()
    _mouse_sender.clear()

func test_should_have_key_pressed_signal():
    assert_has_signal(_keyboard, "key_pressed")

func test_should_emit_key_pressed_signal_on_keyboard_input():
    var sender = InputSender.new(_keyboard)

    watch_signals(_keyboard)

    sender.key_down("KEY_Q")

    assert_signal_emitted(_keyboard, "key_pressed")

func test_should_emit_key_pressed_signal_on_key_button_mouse_down():
    var key_button = _keyboard._key_buttons[KEY_Q] as Button

    watch_signals(_keyboard)

    var position = key_button.global_position + Vector2(64, 64)
    _mouse_sender.mouse_left_button_down(position).mouse_left_button_up(position).wait_frames(TestGlobals.WAIT_FRAMES_COUNT)

    await (_mouse_sender.idle)

    assert_signal_emitted(_keyboard, "key_pressed")
