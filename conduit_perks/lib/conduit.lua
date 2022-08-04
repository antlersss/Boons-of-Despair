function gaussian(mean, variance, x, y)
	SetRandomSeed( x - y, GameGetFrameNum() % 111 )
	return math.sqrt(-2 * variance * math.log(Randomf(0,1))) * math.cos(2 * math.pi * Randomf(0,1)) + mean
end
