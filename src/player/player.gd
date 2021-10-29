class_name Player
extends Node

signal capitalism_units_changed(capitalism_units)
signal earned_capitalism_units(amount, balance, reason)
signal passenger_dead(passenger)
signal cockpit_destroyed
signal player_crashed(on)

const START_CAPITALISM_UNITS = 100

export var capitalism_units: float = 0
var passengers_total = 0


# Initialize player to start a new game
func start(start_pos):
    $Spaceship.start(start_pos)
    $Spaceship.connect("passenger_dead", self, "_on_spaceship_passenger_dead")
    $Spaceship.connect("cockpit_destroyed", self, "_on_spaceship_cockpit_destroyed")
    $Spaceship.connect("crashed", self, "_on_spaceship_crashed")

    capitalism_units = START_CAPITALISM_UNITS
    emit_signal("capitalism_units_changed", capitalism_units)

func _on_spaceship_crashed(on):
    emit_signal("player_crashed", on)

func _on_spaceship_cockpit_destroyed():
    emit_signal("cockpit_destroyed")

func _on_spaceship_passenger_dead(passenger):
    emit_signal("passenger_dead", passenger)

func _on_DestinationMenu_rotate_player(target, away):
    $Spaceship.rotate_after_planet_menu(target)

func _on_Hud_unpaused():
    $Spaceship.toggle_pause()


func _on_DestinationMenu_passenger_picked_up(passenger):
    $Spaceship.current_passenger = passenger
    $PassengerDropoffTime.start(passenger.payment)

func handle_passenger_drop_off():
    var units_earned = floor($PassengerDropoffTime.time_left)
    earn_capitalism_units(units_earned, "Passenger dropped off.")
    print("Units earned: %d, New balance: %d" % [units_earned, capitalism_units])
    $PassengerDropoffTime.stop()
    passengers_total += 1
    $Spaceship.current_passenger = {"name": "nobody"}

func earn_capitalism_units(units_earned, reason):
    capitalism_units += units_earned
    emit_signal("earned_capitalism_units", units_earned, capitalism_units, reason)
    emit_signal("capitalism_units_changed", capitalism_units)

func pay_capitalism_units(amount) -> bool:
    if amount <= capitalism_units:
        capitalism_units -= amount
        emit_signal("capitalism_units_changed", capitalism_units)
        return true
    return false

func _on_Goosington_passenger_dropped_off():
    handle_passenger_drop_off()

func _on_SuspiciousCube_passenger_dropped_off():
    handle_passenger_drop_off()

func _on_InhabitableRed_passenger_dropped_off():
    handle_passenger_drop_off()

func _on_ShallowSpaceSeven_passenger_dropped_off():
    handle_passenger_drop_off()
