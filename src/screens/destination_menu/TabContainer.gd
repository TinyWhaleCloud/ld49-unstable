extends TabContainer


func _input(event):
    if event.is_action_pressed("ui_next_tab"):
        current_tab = (get_child_count() + current_tab + 1) % get_child_count()
    elif event.is_action_pressed("ui_previous_tab"):
        current_tab = (get_child_count() + current_tab - 1) % get_child_count()


func cycle_tab(backwards = false):
    var next_tab = current_tab + (-1 if backwards else 1)
    current_tab = (get_child_count() + next_tab) % get_child_count()
