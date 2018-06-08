extends KinematicBody2D

var spike = preload("spike.tscn")
var screen = preload("screen.tscn")

export var WALK_SPEED = 200
export var max_spikes = 10
export var player_number = "1"

var velocity = Vector2()

var player_spikes
var player_screens
var carying_spike

func _ready():
	player_spikes = get_node("/root/level/player_spikes" + player_number)
	player_screens = get_node("/root/level/player_screens" + player_number)
	carying_spike = get_node("carying_spike")
	
func _physics_process(delta):
	if Input.is_action_pressed("ui_left" + player_number):
		velocity.x = -WALK_SPEED
	if Input.is_action_pressed("ui_right" + player_number):
		velocity.x = WALK_SPEED
	if Input.is_action_pressed("ui_up" + player_number):
		velocity.y = -WALK_SPEED
	if Input.is_action_pressed("ui_down" + player_number):
		velocity.y = WALK_SPEED
	if !Input.is_action_pressed("ui_down" + player_number) && !Input.is_action_pressed("ui_up"+ player_number):
		velocity.y = 0
	if !Input.is_action_pressed("ui_left"+ player_number) && !Input.is_action_pressed("ui_right"+ player_number):
		velocity.x = 0
		
	if Input.is_action_just_pressed("ui_set_spike" + player_number):
		if max_spikes > 0:
			player_spikes.add_child(build_spike())
			
			if(player_spikes.get_children().size() > 1):
				player_screens.add_child(build_screen())
			
			max_spikes = max_spikes - 1
			if max_spikes == 0:
				carying_spike.hide()
			
	move_and_slide(velocity, Vector2(0, -1))

func build_spike():
	var new_spike = spike.instance()
	new_spike.position = self.position + Vector2(35, 0)
	return new_spike
	
func build_screen():
	var new_screen = screen.instance()
	var last_spike_index = player_spikes.get_child_count() - 1
	
	var first_spike = player_spikes.get_child(last_spike_index - 1)
	var second_spike = player_spikes.get_child(last_spike_index)

	var delta = (second_spike.position - first_spike.position)
	new_screen.position = second_spike.position - delta / 2
	new_screen.scale = Vector2(delta.length() / new_screen.size.x, 0.2)
	new_screen.rotation = delta.angle()

	return new_screen