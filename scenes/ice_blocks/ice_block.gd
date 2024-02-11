class_name IceBlock
extends Node3D

@export var health: int = 8 : set=set_health

@onready var area_3d: Area3D = $Area3D
@onready var sprite_3d: Sprite3D = $Sprite3D

var penguins: int = 0


func _ready() -> void:
	area_3d.body_entered.connect(_on_body_entered)
	area_3d.body_exited.connect(_on_body_exited)
	sprite_3d.texture = $Sprite3D/SubViewport.get_texture()


func set_health(value: int) -> void:
	health = value
	%Health.text = "%s / 8" % value
	
	if health <= 0:
		queue_free()


func _on_body_entered(penguin: Penguin) -> void:
	if not penguin:
		return
	
	penguins += 1
	health -= penguins
	Events.ice_block_jumped_on.emit(self)


func _on_body_exited(penguin: Penguin) -> void:
	if not penguin:
		return
	
	penguins -= 1
	
	if penguins <= 0:
		health -= 1
	
	Events.ice_block_jumped_off.emit(self)
