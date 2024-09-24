VehicleConfig = {}

-- List of vehicles to be randomly chosen from when the category is 'vehicle'
VehicleConfig.Vehicles = {
    'adder',  -- Example vehicle
    'zentorno',  -- Another vehicle
    't20',  -- Another vehicle
    'entityxf'  -- Another vehicle
}

-- Function to get a random vehicle from the list
function VehicleConfig.GetRandomVehicle()
    return VehicleConfig.Vehicles[math.random(1, #VehicleConfig.Vehicles)]
end
