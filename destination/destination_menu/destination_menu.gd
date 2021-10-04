extends CanvasLayer
signal rotate_player(position, turn_around)
signal passenger_picked_up(passenger)
signal capitalism_units_spent(amount)

export (PackedScene) var PickupOption
export (PackedScene) var RepairOpt

var target_position = Vector2(0, 0)
var spaceship
var purchase_handler
var price_multiplicator

func _ready():
    spaceship = get_spaceship()
    purchase_handler = get_purchase_handler()


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
        return false
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
        return true
    return false


func _on_passenger_option_selected(passenger):
    emit_signal("passenger_picked_up", passenger)
    hide_passenger_options()
    set_already_carrying_message_visibility(true)

func hide_repair_options():
    for child in $"PopupMenu/ColorRect/TabContainer/Ship Repairs/OptionContainer".get_children():
        if child is RepairOption:
            child.queue_free()

func set_no_repairs_needed_visibility(to: bool):
    $"PopupMenu/ColorRect/TabContainer/Ship Repairs/OptionContainer/NoRepaisNeededLabel".visible = to


func calculate_price_multiplicator(stats):
    var multiplicator = 1
    if (stats.friendliness_score < 100):
        multiplicator *= 1.5
    elif(stats.friendliness_score > 500):
        multiplicator *= 0.7
    if (stats.economy == "Recession"):
        multiplicator *= 0.9
    elif (stats.economy == "Depression"):
        multiplicator *= 0.8
    elif (stats.economy == "Recovery"):
        multiplicator *= 1.1
    elif (stats.economy == "Bubble"):
        multiplicator *= 1.2
    else:
        print("No multiplicator chage for economy: " + stats.economy)
    print("Planet price multiplicator: %d" % [multiplicator])
    return multiplicator


func show_repair_options():
    hide_repair_options()
    var borked = spaceship.get_borked_modules()
    if (borked.size() == 0):
        set_no_repairs_needed_visibility(true)
        return false
    else:
        set_no_repairs_needed_visibility(false)
    for module in borked:
        var option = RepairOpt.instance()
        option.set_module(module)
        option.purchase_handler = purchase_handler
        option.set_price(floor(module.base_price * price_multiplicator))
        $"PopupMenu/ColorRect/TabContainer/Ship Repairs/OptionContainer".add_child(option)
        option.connect("purchase_successful", self, "_on_repair_option_purchase_successful")
    return true

func _on_repair_option_purchase_successful():
    show_repair_options()
    update_current_balance_label()

func handle_capitalism_units_spent(amount: float):
    emit_signal("capitalism_units_spent", amount)
    update_current_balance_label()

func update_current_balance_label():
    $PopupMenu/ColorRect/GridContainer/CurrentBalanceValue.text = str(spaceship.get_parent().capitalism_units) + ' Cu'

func show(stats, position):
    get_tree().paused = true
    $PopupMenu/ColorRect/NameLabel.text = stats.name
    $PopupMenu/ColorRect/GridContainer/FriendlinessValue.text = getFriendlinessStringFromScore(stats.friendliness_score)
    $PopupMenu/ColorRect/GridContainer/SpentValue.text = str(stats.units_spent) + ' Cu'
    $PopupMenu/ColorRect/GridContainer/TransportedValue.text = str(stats.transported) + ' Passengers'
    $PopupMenu/ColorRect/GridContainer/StabilityValue.text = stats.stability
    $PopupMenu/ColorRect/GridContainer/EconomyValue.text = stats.economy
    $PopupMenu/ColorRect/FlavorTextContainer/FlavorText.text = stats.flavor_text
    update_current_balance_label()
    if show_passenger_options(stats.passengers):
        $PopupMenu/ColorRect/TabContainer.current_tab = 1
    price_multiplicator = calculate_price_multiplicator(stats)
    if show_repair_options():
        $PopupMenu/ColorRect/TabContainer.current_tab = 0
    target_position = position
    $PopupMenu.popup_centered()


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

func get_purchase_handler():
    var ph_results = get_tree().get_nodes_in_group("PurchaseHandler")
    if ph_results.size() > 0:
        return ph_results[0]
    return null
