extends CanvasLayer
signal rotate_player
signal passenger_picked_up

export (PackedScene) var PickupOption
var target_position = Vector2(0, 0)
var spaceship


func _ready():
    spaceship = get_spaceship()


func getFriendlinessStringFromScore(score):
    if (score < 100):
        return 'Hostile'
    elif (score > 500):
        return 'Friendly'
    else:
        return 'Normal'


func hide_passenger_options():
    for child in $"PopupMenu/ColorRect/TabContainer/Potential Passengers/OptionContainer".get_children():
        if child is PassengerPickupOption:
            child.queue_free()

func set_already_carrying_message_visibility(to:bool):
    $"PopupMenu/ColorRect/TabContainer/Potential Passengers/OptionContainer/AlreadyCarryingPassenger".visible = to

func show_passenger_options(passengers):
    hide_passenger_options()

    if spaceship.current_passenger.name != 'nobody':
        print(spaceship.current_passenger.name)
        set_already_carrying_message_visibility(true)
        return
    else:
        set_already_carrying_message_visibility(false)

    if passengers.size() == 0:
        $"PopupMenu/ColorRect/TabContainer/Potential Passengers/OptionContainer/No passengers".visible = true
    else:
        $"PopupMenu/ColorRect/TabContainer/Potential Passengers/OptionContainer/No passengers".visible = false
        for passenger in passengers:
            var option = PickupOption.instance()
            option.set_passenger(passenger)
            $"PopupMenu/ColorRect/TabContainer/Potential Passengers/OptionContainer".add_child(option)
            option.connect("option_selected", self, "_on_passenger_option_selected")


func _on_passenger_option_selected(passenger):
    emit_signal("passenger_picked_up", passenger)
    hide_passenger_options()
    set_already_carrying_message_visibility(true)


func show(stats, position):
    get_tree().paused = true
    $PopupMenu/ColorRect/NameLabel.text = stats.name
    $PopupMenu/ColorRect/FriendlinessValue.text = getFriendlinessStringFromScore(stats.friendliness_score)
    $PopupMenu/ColorRect/SpentValue.text = str(stats.units_spent) + ' Cu'
    $PopupMenu/ColorRect/TransportedValue.text = str(stats.transported) + ' Passengers'
    $PopupMenu/ColorRect/StabilityValue.text = stats.stability
    $PopupMenu/ColorRect/EconomyValue.text = stats.economy
    $PopupMenu/ColorRect/FlavorTextContainer/FlavorText.text = stats.flavor_text
    show_passenger_options(stats.passengers)
    $PopupMenu.popup_centered()
    target_position = position


func _on_PopupMenu_hide():
    print("Popup canvas hidden")
    get_tree().paused = false
    emit_signal('rotate_player', target_position, true)


func _on_LeaveButton_pressed():
    $PopupMenu.hide()

func get_spaceship():
    var spaceship_results = get_tree().get_nodes_in_group("Spaceship")
    if spaceship_results.size() > 0:
        return spaceship_results[0]
    return null
