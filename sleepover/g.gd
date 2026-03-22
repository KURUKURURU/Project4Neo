extends Node

func wait(seconds):
	await get_tree().create_timer(1.0).timeout
