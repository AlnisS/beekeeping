extends MarginContainer

var honey := 10.0 setget set_honey
var honey_disp := 10.0
var pollen := 0.0 setget set_pollen
var pollen_disp := 0.0
var bee_count := 0 setget set_bee_count
var bee_total := 0 setget set_bee_total

func _process(delta):
	honey_disp += (honey - honey_disp) * delta * 10
	pollen_disp += (pollen - pollen_disp) * delta * 10
	$TopBar/Bars/HoneyBar/TextureProgress.value = honey_disp
	$TopBar/Bars/PollenBar/TextureProgress.value = pollen_disp
	$TopBar/Counters/BeeCount/Label.text = str(bee_count) + "/" + str(bee_total)

func set_honey(value: float) -> void:
	honey = value

func set_pollen(value: float) -> void:
	pollen = value

func set_bee_count(value: int) -> void:
	bee_count = value

func set_bee_total(value: int) -> void:
	bee_total = value

func _on_Hive_hive_update(honey, pollen, bee_count, bee_total):
	set_honey(honey)
	set_pollen(pollen)
	set_bee_count(bee_count)
	set_bee_total(bee_total)
