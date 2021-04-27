tool

extends Area2D

enum FlowerType {DAFFODIL, PANSY, TULIP}
export(FlowerType) var flower_type setget set_flower_type

func set_flower_type(value):
	match value:
		FlowerType.DAFFODIL:
			$Daffodil.show()
			$Pansy.hide()
			$Tulip.hide()
		FlowerType.PANSY:
			$Daffodil.hide()
			$Pansy.show()
			$Tulip.hide()
		FlowerType.TULIP:
			$Daffodil.hide()
			$Pansy.hide()
			$Tulip.show()
	flower_type = value
