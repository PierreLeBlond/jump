extends Button

class_name AnimatedButton

const TWEEN_DURATION_IN: float = 0.8
const TWEEN_DURATION_OUT: float = 0.1

var _shadow: Control

var _tween: Tween

var _highlight_count: int = 0

func _ready() -> void:
    focus_entered.connect(highlight_button)
    focus_exited.connect(unhighlight_button)

    mouse_entered.connect(highlight_button)
    mouse_exited.connect(unhighlight_button)

    var stylebox = load("res://themes/StyleBox/button_shadow.tres").duplicate() as StyleBoxFlat
    stylebox.corner_radius_bottom_left = get_theme_stylebox("normal").corner_radius_bottom_left
    stylebox.corner_radius_bottom_right = get_theme_stylebox("normal").corner_radius_bottom_right
    stylebox.corner_radius_top_left = get_theme_stylebox("normal").corner_radius_top_left
    stylebox.corner_radius_top_right = get_theme_stylebox("normal").corner_radius_top_right

    _shadow = PanelContainer.new()
    _shadow.add_theme_stylebox_override("panel", stylebox)
    _shadow.show_behind_parent = true
    _shadow.set_anchors_preset(PRESET_FULL_RECT)
    _shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE

    add_child(_shadow)

func highlight_button() -> void:
    _highlight_count += 1

    if _tween != null:
        _tween.kill()
        _tween = null

    _tween = create_tween()
    _tween.tween_property(self, "position:y", -8, TWEEN_DURATION_IN).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
    _tween.parallel().tween_property(_shadow, "position:y", 8, TWEEN_DURATION_IN).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func unhighlight_button() -> void:
    _highlight_count -= 1

    if _highlight_count > 0:
        return

    if _tween != null:
        _tween.kill()
        _tween = null

    _tween = create_tween()
    _tween.tween_property(self, "position:y", 0, TWEEN_DURATION_OUT).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
    _tween.parallel().tween_property(_shadow, "position:y", 0, TWEEN_DURATION_OUT).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func on_mouse_entered() -> void:
    highlight_button()

func on_mouse_exited() -> void:
    unhighlight_button()