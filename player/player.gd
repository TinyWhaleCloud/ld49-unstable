class_name Player
extends Node
signal earned_capitalism_units(amount, balance, reason)
signal passenger_dead(passenger)

export var capitalism_units:float = 0


# Initialize player to start a new game
func start(start_pos):
    $Spaceship.start(start_pos)
    capitalism_units = 0
    $Spaceship.connect("passenger_dead", self, "_on_spaceship_passenger_dead")


func _on_spaceship_passenger_dead(passenger):
    emit_signal("passenger_dead", passenger)


func _on_DestinationMenu_rotate_player(target, away):
    $Spaceship.rotate_towards(target, away, false)

func _on_Hud_unpaused():
    $Spaceship.toggle_pause()


func _on_DestinationMenu_passenger_picked_up(passenger):
    $Spaceship.current_passenger = passenger
    $PassengerDropoffTime.start(passenger.payment)

func handle_passenger_drop_off():
    var units_earned = floor($PassengerDropoffTime.time_left)
    capitalism_units+= units_earned
    print("Units earned: %d, New balance: %d" % [units_earned, capitalism_units])
    $PassengerDropoffTime.stop()
    emit_signal("earned_capitalism_units", units_earned, capitalism_units, "Passenger dropped off.")

    $Spaceship.current_passenger = {"name": "nobody"}


func _on_Goosington_passenger_dropped_off():
    handle_passenger_drop_off()

func _on_SuspicousCube_passenger_dropped_off():
    handle_passenger_drop_off()

func _on_InhabitableRed_passenger_dropped_off():
    handle_passenger_drop_off()

func _on_ShallowSpaceSeven_passenger_dropped_off():
    handle_passenger_drop_off()
