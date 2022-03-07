extends Reference
class_name StatObservable

signal value_changed(old_val, new_val)

var value setget set_value, get_value

func _to_config() -> Dictionary:
	return {"v":value}

func _from_config(c):
	if c == null:
		return
	value = c.get("v", 0)

func set_value(val, skip_eventing=false):
	var old_val = value
	value = val
	if !skip_eventing and old_val != val:
		emit_signal("value_changed", old_val, val)

func get_value():
	return value
