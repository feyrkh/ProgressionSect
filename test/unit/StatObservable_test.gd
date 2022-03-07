extends "res://addons/gut/test.gd"

var v
var previous_value
var modified_value

func before_each():
	v = StatObservable.new()
	previous_value = null
	modified_value = null

func test_can_set_and_get_string():
	v.value = 'some value'
	assert_eq('some value', v.value)

func test_can_set_and_get_number():
	v.value = 42
	assert_eq(42, v.value)

func test_observable():
	v.connect('value_changed', self, 'value_changed')
	v.value = 1
	assert_eq(null, previous_value)
	assert_eq(1, modified_value)
	v.value = 2
	assert_eq(1, previous_value)
	assert_eq(2, modified_value)

func test_serde():
	v.value = 42
	assert_eq(42, v.value)
	var saved = v._to_config()
	var restored = StatObservable.new()
	restored._from_config(saved)
	assert_eq(42, restored.value)

func value_changed(old_val, new_val):
	previous_value = old_val
	modified_value = new_val
