extends Screen

class_name Leaderboard

@export var quit_to_main_menu_button: Button

@export var score_names_container: Control
@export var score_values_container: Control

@export var time_names_container: Control
@export var time_values_container: Control

@export var score_skeleton: Control
@export var time_skeleton: Control

func _ready() -> void:
    quit_to_main_menu_button.pressed.connect(quit_to_main_menu)

func clear() -> void:
    for child in score_names_container.get_children():
        child.queue_free()

    for child in score_values_container.get_children():
        child.queue_free()

    for child in time_names_container.get_children():
        child.queue_free()

    for child in time_values_container.get_children():
        child.queue_free()

func focus() -> void:
    quit_to_main_menu_button.grab_focus()

func update() -> void:
    clear()

    var scores_result = await SilentWolf.Scores.get_scores().sw_get_scores_complete

    if score_skeleton:
        score_skeleton.queue_free()
        score_skeleton = null

    for score in scores_result.scores:
        var name_label = Label.new()
        name_label.text = score.player_name
        score_names_container.add_child(name_label)

        var value_label = Label.new()
        value_label.text = str(int(score.score))
        score_values_container.add_child(value_label)

    var times_result = await SilentWolf.Scores.get_scores(10, "time").sw_get_scores_complete

    if time_skeleton:
        time_skeleton.queue_free()
        time_skeleton = null

    for time in times_result.scores:
        var name_label = Label.new()
        name_label.text = time.player_name
        time_names_container.add_child(name_label)

        var value_label = Label.new()
        value_label.text = Utils.format_time(-time.score)
        time_values_container.add_child(value_label)

func disable() -> void:
    quit_to_main_menu_button.disabled = true

func enable() -> void:
    quit_to_main_menu_button.disabled = false