extends Node2D

@onready var folder1 = $files/folder
@onready var folder1_alert = $files/folder/click

@onready var folder2 = $files/folder2
@onready var folder2_alert = $files/folder2/click

@onready var folder3 = $files/folder3
@onready var folder3_alert = $files/folder3/click

@onready var folder4 = $files/folder4
@onready var folder4_alert = $files/folder4/click

@onready var page = $pages/Page
@onready var page_T = $pages/Page/Title
@onready var page_B = $pages/Page/text

@onready var _image = $pages/Page/image

var Timothy = preload("res://images/ID_Timothy.png")
var Shelly = preload("res://images/ID_Shelly.png")

@onready var weight = $Weight/Number

@onready var click_sfx = $click/click_sfx

@export var current_weight := 0
@export var day := 0
@export var person := 0

var loop_load = "Processing"
var Title := ""
var Body := ""


var new_alert = preload("res://images/alert.png")

func _ready() -> void:
	
	folder1.hide()
	folder2.hide()
	folder3.hide()
	folder4.hide()
	


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("click") and self.visible:
		click_sfx.play()
	
	page_B.text = Body
	page_T.text = Title
	
	await _loop_load()
	
	weight.text = str(current_weight)
	
	match person:
		1:
			folder1.show()
			
			folder1_alert.texture_normal = new_alert
			folder2_alert.texture_normal = null
			folder3_alert.texture_normal = null
			folder4_alert.texture_normal = null
		2:
			folder2.show()
			
			folder1_alert.texture_normal = null
			folder2_alert.texture_normal = new_alert
			folder3_alert.texture_normal = null
			folder4_alert.texture_normal = null
		3:
			folder3.show()
			
			folder1_alert.texture_normal = null
			folder2_alert.texture_normal = null
			folder3_alert.texture_normal = new_alert
			folder4_alert.texture_normal = null
		4:
			folder4.show()
			
			folder1_alert.texture_normal = null
			folder2_alert.texture_normal = null
			folder3_alert.texture_normal = null
			folder4_alert.texture_normal = new_alert
			
		

var dots = ""

func _loop_load():
	loop_load = loop_load + dots
	
	dots = "."
	await wait(0.2)
	dots = ".."
	await wait(0.2)
	dots = "..."
	await wait(0.2)

func notes() -> void:
	_image.texture = null
	Title = "Limits on Entry"
	Body = "Weight Maximum 
(Small Vehicles)    3500 lbs          

Weight Maximum 
(Large Vehicles)    8000 lbs

Zone Clearance 
(Minimum)            Level 5                            



Limitations help limit 
possible smuggling of items
in and out facility.
"
	

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


func folder_1() -> void:
	Title = "New_Import_209324239294"
	Body = ""
	_image.texture = Timothy

func folder_2() -> void:
	Title = "New_Import_453234523455"
	Body = ""
	_image.texture = Shelly

func folder_3() -> void:
	Title = "New_Import_796735679674"
	Body = ""

func folder_4() -> void:
	Title = "New_Import_4645779556367"
	Body = ""
