extends Node

class_name PopOutControl

const TWEEN_DURATION_IN: float = 0.8
const TWEEN_DURATION_OUT: float = 0.1

var _shadow: Control

var _tween: Tween

var _is_popped_out: bool = false

func _ready() -> void:
    get_viewport().gui_focus_changed.connect(func(_new_focus: Control): _on_focus_changed())
    get_parent().resized.connect(func(): _on_focus_changed(true))

    var stylebox = load("res://themes/StyleBox/button_shadow.tres")

    _shadow = PanelContainer.new()
    _shadow.add_theme_stylebox_override("panel", stylebox)
    _shadow.show_behind_parent = true
    _shadow.set_anchors_preset(Control.PRESET_FULL_RECT)
    _shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE

    get_parent().add_child.call_deferred(_shadow)

func is_popped_out() -> bool:
    return _is_popped_out

func _has_focus_from_mouse() -> bool:
    return Rect2(Vector2(), get_parent().size).has_point(get_parent().get_local_mouse_position())

func _has_focus_from_children() -> bool:
    return get_parent().has_focus() or get_parent().find_children("*", "Control", true, false).any(func(child): return child.has_focus())

func _on_focus_changed(force: bool = false) -> void:
    if _has_focus_from_mouse() or _has_focus_from_children():
        pop_out(force)
    else:
        pop_in(force)

func pop_out(force: bool = false) -> void:
    if _is_popped_out and !force:
        return

    _is_popped_out = true

    if _tween != null:
        _tween.kill()
        _tween = null

    _tween = create_tween()
    _tween.tween_property(get_parent(), "position:y", -8, TWEEN_DURATION_IN).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
    _tween.parallel().tween_property(_shadow, "position:y", 8, TWEEN_DURATION_IN).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func pop_in(force: bool = false) -> void:
    if !_is_popped_out and !force:
        return

    _is_popped_out = false

    if _tween != null:
        _tween.kill()
        _tween = null

    _tween = create_tween()
    _tween.tween_property(get_parent(), "position:y", 0, TWEEN_DURATION_OUT).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
    _tween.parallel().tween_property(_shadow, "position:y", 0, TWEEN_DURATION_OUT).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func _input(event: InputEvent) -> void:
    if event is not InputEventMouseMotion:
        return

    _on_focus_changed()
