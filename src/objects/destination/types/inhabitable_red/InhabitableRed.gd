extends BaseDestination


func _ready():
    stats = destination_stats.new('Inhabitable Red', 50, 0,0, 'Normal', 'Bubble', 'An planet that is pretty much inhabitable. There is some water but all of it is frozen and the weather is just terrible; not to mention the sandstorms. It\'s no wonder the population is not very friendly.', 0.5)


func _on_PassengerSpawner_passenger_spawned(start, end):
    handle_passenger_spawn_signal(start, end)


func _on_DestinationMenu_passenger_picked_up(passenger):
    handle_passenger_picked_up_signal(passenger)


func _on_Player_passenger_dead(passenger):
    handle_passenger_dead(passenger)
