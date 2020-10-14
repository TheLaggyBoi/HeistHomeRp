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
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.MarkerInfo2 = {
	r = 255, g = 0, b = 0,     -- Red Color
	x = 1.5, y = 1.5, z = 1.0  -- Standard Size Circle
}

Config.EnableSpecificOnly = true -- If true it will only show Blips to Job Specific Players | false shows it to Everyone.
Config.EnableBlips = false -- If true then it will show blips | false does the Opposite.

Config.SpawnerLocations = {
	Ambulance = {
		Marker =  { x = 325.79, y = -557.98, z = 28.74 },
		Spawner = { x = 323.67, y = -540.88, z = 28.74, h = 176.86},
		Deleter = { x = 347.60, y = -634.11, z = 29.29 }
	},

	Spawner_Docks = {
		Marker =  { x = 1246.31, y = -3256.8, z = 5.03 },
		Spawner = { x = 1274.09, y = -3238.27, z = 5.9, h = 93.17 },
		Deleter = { x = 1274.09, y = -3238.27, z = 4.9 }
	}
}
	

Config.Vehicles = {
	{
		model = 'emsroamer',
		label = 'Ambulance Suv'

	},
	{
		model = 'ambucara',
		label = 'Speedo Ambulance'

	},
	{
		model = 'ambulance',
		label = 'Ambulance'

	}
				
}
