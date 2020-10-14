Config = {}
Config.Locale = 'en'

Config.MarkerType   = 2
Config.DrawDistance = 100.0

Config.BlipSpawner = {
	Sprite = 479,
	Color = 2,
	Display = 2,
	Scale = 1.0
}

Config.MarkerInfo = {
	r = 0, g = 255, b = 0,     -- Green Color
	x = 0.8, y = 1.0, z = 0.8  -- Standard Size Circle
}

Config.MarkerInfo2 = {
	r = 255, g = 0, b = 0,     -- Red Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.EnableSpecificOnly = true -- If true it will only show Blips to Job Specific Players | false shows it to Everyone.
Config.EnableBlips = false -- If true then it will show blips | false does the Opposite.

Config.SpawnerLocations = {
	Vehicles = {
		Marker =  { x = 436.4, y = -1015.08, z = 28.73 },
		Spawner = { x = 449.32, y = -1015.03, z = 28.51, h = 87.47},
		Deleter = { x = 463.35, y = -1019.39, z = 28.10 }
	},

	Vehicles2 = {
		Marker =  { x = 431.2, y = -1015.22, z = 28.86 },
		Spawner = { x = 449.51, y = -1022.29, z = 28.48, h = 100.2},
		Deleter = { x = 463.58, y = -1015.09, z = 28.07 }
	}

}
	

Config.Vehicles = {
	{
		model = 'policeb',
		label = 'Police Bike'

	},
{
		model = 'polthrust',
		label = 'Police Special Bike'

	},
	{
		model = 'pol718',
		label = 'Police Porsche'

	},
	{
		model = 'police2',
		label = 'Police Charger'

	},
	--[[{
		model = 'police3',
		label = 'Police Car'

	},]]
	{
		model = 'camarorb',
		label = 'Police Camaro'

	},
	{
		model = '2015polstang',
		label = 'Police Mustang GT'

	},
	--[[{
		model = 'LSPD',
		label = 'Police Charger'
	},]]
	{
		model = 'polchiron',
		label = 'Police Chiron'

	},
	{
		model = 'sheriff2',
		label = 'Sheriff SUV'

	},
	{
		model = 'srt8police',
		label = 'Police Interceptor SUV'

	},
	{
		model = 'LSPDEXP',
		label = 'Police 911'

	},

	{
		model = 'pin',
		label = 'Police SUV'

	},
	{
		model = 'riot',
		label = 'Police riot'

	},
	{
		model = 'PBus',
		label = 'Police Bus'

	},
	{
		model = 'emsroamer',
		label = 'Ambulance Suv'

	}
				
}
