extends "res://destination/destination.gd"


func _ready():
        stats = destination_stats.new('Shallow Space 7', 600, 0,0, 'Good', 'Expansion', 'A badly drawn, terribly "hidden" reference. But hey, people seem pretty friendly around here.', 1)


func _on_PassengerSpawner_passenger_spawned(start, end):
    handle_passenger_spawn_signal(start, end)


func _on_DestinationMenu_passenger_picked_up(passenger):
    handle_passenger_picked_up_signal(passenger)


func _on_Player_passenger_dead(passenger):
    handle_passenger_dead(passenger)
