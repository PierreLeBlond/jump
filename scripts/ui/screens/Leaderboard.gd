extends Screen

class_name Leaderboard

@export var quit_to_title_screen_button: Button

@export var score_names_container: Control
@export var score_values_container: Control

@export var time_names_container: Control
@export var time_values_container: Control

@export var score_skeleton: Control
@export var time_skeleton: Control

func _ready() -> void:
    quit_to_title_screen_button.pressed.connect(quit_to_title_screen)

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
    quit_to_title_screen_button.grab_focus()

func update() -> void:
    clear()

    var scores_result = await Talo.leaderboards.get_entries(Globals.SCORES_LEADERBOARD_INTERNAL_NAME)
    var scores_entries = scores_result.entries

    if score_skeleton:
        score_skeleton.queue_free()
        score_skeleton = null

    for score in scores_entries:
        var name_label = Label.new()
        name_label.text = score.player_alias.identifier
        score_names_container.add_child(name_label)

        var value_label = Label.new()
        value_label.text = str(int(score.score))
        score_values_container.add_child(value_label)

    var times_result = await Talo.leaderboards.get_entries(Globals.TIMES_LEADERBOARD_INTERNAL_NAME)
    var times_entries = times_result.entries

    if time_skeleton:
        time_skeleton.queue_free()
        time_skeleton = null

    for time in times_entries:
        var name_label = Label.new()
        name_label.text = time.player_alias.identifier
        time_names_container.add_child(name_label)

        var value_label = Label.new()
        value_label.text = Utils.format_time(time.score)
        time_values_container.add_child(value_label)

func disable() -> void:
    quit_to_title_screen_button.disabled = true

func enable() -> void:
    quit_to_title_screen_button.disabled = false