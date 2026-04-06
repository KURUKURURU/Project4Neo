extends Node2D

@onready var folder1 = $files/folder
@onready var folder1_alert = $files/folder/click

@onready var folder2 = $files/folder2
@onready var folder2_alert = $files/folder2/click

@onready var folder3 = $files/folder3
@onready var folder3_alert = $files/folder3/click

@onready var folder4 = $files/folder4
@onready var folder4_alert = $files/folder4/click

@onready var weight = $Weight/Number

@export var current_weight := 0

var day := 1
var person := 1
var new_alert = preload("res://images/alert.png")

func _ready() -> void:
	folder1.hide()
	folder2.hide()
	folder3.hide()
	folder4.hide()


func _process(delta: float) -> void:
	
	weight = str(current_weight)
	
	match person:
		1:
			folder1_alert.texture_normal = new_alert
			folder2_alert.texture_normal = null
			folder3_alert.texture_normal = null
			folder4_alert.texture_normal = null
		2:
			folder1_alert.texture_normal = null
			folder2_alert.texture_normal = new_alert
			folder3_alert.texture_normal = null
			folder4_alert.texture_normal = null
		3:
			folder1_alert.texture_normal = null
			folder2_alert.texture_normal = null
			folder3_alert.texture_normal = new_alert
			folder4_alert.texture_normal = null
		4:
			folder1_alert.texture_normal = null
			folder2_alert.texture_normal = null
			folder3_alert.texture_normal = null
			folder4_alert.texture_normal = new_alert
			
		

#func notes() -> void:
	
