extends Node

var gen : RandomNumberGenerator = RandomNumberGenerator.new()

func normal_value():
	#return gen.randfn(0.5, 0.165)
	return min(1.0, max(0, gen.randfn(0.5, 0.163)))
