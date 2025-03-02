
extends StateBehaviour
class_name StateWolfMarch

const STATE_NAME := &"MarchForeward"


@export var wolf: Wolf
@export var pivot: Node2D

@export var ray_floor: RayCast2D
@export var ray_wall: RayCast2D
