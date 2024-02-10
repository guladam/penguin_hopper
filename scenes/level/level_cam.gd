extends Camera3D

const CAM_MOVE_THRESHOLD := 4

@export var starting_block: Node3D

var current_dist: float
var target_x: float = 0.0


func _ready() -> void:
	current_dist = global_position.distance_to(starting_block.global_position)
	Events.ice_block_jumped_on.connect(_ice_block_jumped_on)
	Events.penguin_selected.connect(_on_penguin_selected)


func _process(delta: float) -> void:
	if not is_equal_approx(target_x, 0.0):
		global_position.x = lerp(global_position.x, target_x, delta * 10)
		if is_equal_approx(global_position.x, target_x):
			target_x = 0.0


func _ice_block_jumped_on(block: IceBlock) -> void:
	var dist := global_position.distance_to(block.global_position)
	var diff := dist - current_dist
	
	if abs(diff) > CAM_MOVE_THRESHOLD:
		target_x = global_position.x + CAM_MOVE_THRESHOLD * sign(diff)


func _on_penguin_selected(penguin: Penguin) -> void:
	target_x = penguin.global_position.x - 5	
