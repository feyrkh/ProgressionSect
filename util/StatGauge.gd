extends "res://util/StatObservable.gd"

signal max_value_changed(old_val, new_val)

const BONUS_MAX_PERCENT = 'BMP'
const BONUS_MAX_VALUE = 'BMV'

const EMPTY = {}
var max_value = null setget set_max_value, get_max_value
var effects = {} #{{"bonus_max":{"levelup":10}, "bonus_max_percent":...}
var can_go_below_zero = false

func _to_config() -> Dictionary:
	var result = ._to_config()
	if (max_value != null): result['mv'] = max_value
	if (effects.size() > 0): result['e'] = effects
	return result

func _from_config(c):
	if c == null:
		return
	._from_config(c)
	max_value = c.get("mv", null)
	effects = c.get("e", {})

func set_value(val, skip_eventing=false):
	if val < 0 and !can_go_below_zero:
		val = 0
	if max_value != null and val > max_value:
		val = max_value
	.set_value(val, skip_eventing)
	
func set_max_value(val):
	if (val != max_value):	
		var old_val = value
		max_value = val
		emit_signal("max_value_changed", old_val, val)

func get_max_value():
	var effect_values = 0
	var effect_percents = 1.0
	var value_bonuses = effects.get(BONUS_MAX_VALUE, EMPTY)
	var pct_bonuses = effects.get(BONUS_MAX_PERCENT, EMPTY)
	for k in value_bonuses:
		effect_values += value_bonuses[k]
	for k in pct_bonuses:
		effect_percents *= pct_bonuses[k]
	return (max_value + effect_values) * effect_percents

func get_max_value_ratio(should_clamp=true):
	if value == 0:
		return 0
	if should_clamp:
		return clamp(value/get_max_value(), 0, 1)
	else:
		return value / get_max_value()

func bonus_max_value_effect(effect_name, bonus_amount):
	_update_max_effect(effect_name, BONUS_MAX_VALUE, bonus_amount)

func bonus_max_percent_effect(effect_name, bonus_amount):
	_update_max_effect(effect_name, BONUS_MAX_PERCENT, bonus_amount)

func _update_max_effect(effect_name, bonus_type, bonus_amount):
	var active_effects = effects.get(bonus_type, {})
	var prev_max = get_max_value()
	if bonus_amount == null or bonus_amount == 0:
		active_effects.erase(effect_name)
	else:
		active_effects[effect_name] = bonus_amount
	effects[bonus_type] = active_effects
	var new_max = float(get_max_value())
	var change_ratio = new_max/prev_max
	value = value * change_ratio

