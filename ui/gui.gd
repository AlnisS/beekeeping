extends MarginContainer

signal pause_pressed

var honey := 10.0 setget set_honey
var honey_disp := 10.0
var pollen := 0.0 setget set_pollen
var pollen_disp := 0.0
var bee_count := 0 setget set_bee_count
var bee_total := 0 setget set_bee_total
var time := 0.0

func _process(delta):
	honey_disp += (honey - honey_disp) * delta * 10
	pollen_disp += (pollen - pollen_disp) * delta * 10
	
	$TopBar/Bars/HoneyBar/TextureProgress.value = honey_disp
	$TopBar/Bars/PollenBar/TextureProgress.value = pollen_disp
	$TopBar/Counters/BeeCount/Label.text = str(bee_count) + "/" + str(bee_total)
	
	var time_string = (
		"%02d:%06.3f" % [time / 60.0, fmod(time, 60.0)]
	)
	$TopBar/Counters/TimeLabel.text = time_string

func set_honey(value: float) -> void:
	honey = value

func set_pollen(value: float) -> void:
	pollen = value

func set_bee_count(value: int) -> void:
	bee_count = value

func set_bee_total(value: int) -> void:
	bee_total = value

func set_time(value: float) -> void:
	time = value

func set_max_values(max_honey: float, max_pollen: float) -> void:
	$TopBar/Bars/HoneyBar/TextureProgress.max_value = max_honey
	$TopBar/Bars/PollenBar/TextureProgress.max_value = max_pollen

func _on_Hive_hive_update(honey, pollen, bee_count, bee_total, time):
	set_honey(honey)
	set_pollen(pollen)
	set_bee_count(bee_count)
	set_bee_total(bee_total)
	set_time(time)


func _on_Hive_hive_max_values(max_honey: float, max_pollen: float):
	set_max_values(max_honey, max_pollen)


func _on_PauseButton_pressed():
	emit_signal("pause_pressed")
