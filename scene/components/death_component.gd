extends Node2D
class_name DeathComponent

@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D
@onready var sprite_offset: Node2D = $SpriteOffset


func _ready() -> void:
	$HitSoundComponent.play()
	$AudioStreamPlayer2D.play()
