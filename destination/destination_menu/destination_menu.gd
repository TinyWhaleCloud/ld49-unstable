extends CanvasLayer
signal rotate_player


var target_position = Vector2(0, 0)

func _ready():
    pass # Replace with function body.


func getFriendlinessStringFromScore(score):
    if (score < 100):
        return 'Hostile'
    elif (score > 500):
        return 'Friendly'
    else:
        return 'Normal'

func show(stats, position):
    get_tree().paused = true
    $PopupMenu/ColorRect/NameLabel.text = stats.name
    $PopupMenu/ColorRect/FriendlinessValue.text = getFriendlinessStringFromScore(stats.friendliness_score)
    $PopupMenu/ColorRect/SpentValue.text = str(stats.units_spent) + ' Cu'
    $PopupMenu/ColorRect/TransportedValue.text = str(stats.transported) + ' Passengers'
    $PopupMenu/ColorRect/StabilityValue.text = stats.stability
    $PopupMenu/ColorRect/EconomyValue.text = stats.economy
    $PopupMenu/ColorRect/FlavorTextContainer/FlavorText.text = stats.flavor_text
    $PopupMenu.show()
    target_position = position


func _on_PopupMenu_hide():
    print("Popup canvas hidden")
    get_tree().paused = false
    emit_signal('rotate_player', target_position, true)


func _on_LeaveButton_pressed():
    $PopupMenu.hide()
