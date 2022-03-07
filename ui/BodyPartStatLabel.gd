extends Label

func connect_gauge(stat_gauge):
	stat_gauge.connect('value_changed', self, 'gauge_changed', [stat_gauge])
	stat_gauge.connect('max_value_changed', self, 'gauge_changed', [stat_gauge])
	gauge_changed(stat_gauge, 0, stat_gauge.value)

func connect_value(stat_observable):
	stat_observable.connect('value_changed', self, 'value_changed', [stat_observable])
	value_changed(stat_observable, 0, stat_observable.value)

func gauge_changed(stat_gauge, old_val, new_val):
	text = '  '+str(stepify(stat_gauge.value, 0.1))+'/'+str(stepify(stat_gauge.max_value, 0.1))+'  '

func value_changed(stat_observable, old_val, new_val):
	text = '  '+str(stepify(stat_observable.value, 0.1))+'  '
