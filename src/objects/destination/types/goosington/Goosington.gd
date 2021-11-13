extends BaseDestination


func _ready():
    stats = destination_stats.new('Goosington', 100, 0,0, 'Normal', 'Bubble', 'This planet was taken over by geese after the species that claimed to own it previously screwed it up majorly. Geese are naturally neutral but you should never piss one off.', 0.2)


func _on_PassengerSpawner_passenger_spawned(start, end):
    handle_passenger_spawn_signal(start, end)


func _on_DestinationMenu_passenger_picked_up(passenger):
    handle_passenger_picked_up_signal(passenger)


func _on_Player_passenger_dead(passenger):
    handle_passenger_dead(passenger)
