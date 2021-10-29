extends BaseDestination


func _ready():
       stats = destination_stats.new('Suspicious Cube', 100, 0,0, 'Normal', 'Recession', 'Something about this base is off, but you are not sure what.', 0.6)


func _on_PassengerSpawner_passenger_spawned(start, end):
    handle_passenger_spawn_signal(start, end)


func _on_DestinationMenu_passenger_picked_up(passenger):
    handle_passenger_picked_up_signal(passenger)


func _on_Player_passenger_dead(passenger):
    handle_passenger_dead(passenger)
