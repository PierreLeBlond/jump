extends GutTest

var _button_scene: PackedScene = preload("res://scenes/debug/Button.tscn")
var _button: Button

var _mouse_sender = InputSender.new(Input)

func before_all():
    _mouse_sender.mouse_warp = true
    _mouse_sender.draw_mouse = true

func before_each():
    _button = _button_scene.instantiate()
    add_child(_button)

func after_each():
    remove_child(_button)
    _button.free()
    _button = null

    _mouse_sender.release_all()
    _mouse_sender.clear()

func test_should_have_button_down_signal():
    assert_has_signal(_button, "button_down")

func test_should_emit_button_down_signal_on_button_down():
    watch_signals(_button)

    var position = _button.global_position + Vector2(64, 64)
    _mouse_sender.mouse_left_button_down(position).wait_frames(TestGlobals.WAIT_FRAMES_COUNT)

    await (_mouse_sender.idle)

    assert_signal_emitted(_button, "button_down")

    # pause_before_teardown()