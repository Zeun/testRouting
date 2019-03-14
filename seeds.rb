# Load Model
require './model'
require './constant'
require './utils'

# Load Cities
LOCATIONS.each do |region, cities|
  cities.each do |city|
    City.create(name: city, region: region)
  end
end

cities = City.where(region: 'RM')
cities_len = cities.length

# Load data into Driver
NUM_DRIVERS.times do |n|
  driver = Driver.create(
    name: "Driver #{n}",
    phone: random_phone(9),
    email: "driver#{n}@test.com"
  )

  # Random to create a Vehicle asociated to Driver
  # if [true, false].sample
  driver.create_vehicle(
    capacity: getCapacity(),
    load_type: getLoadType()
  )
  # end

  rand(cities_len).times do |d|
    driver.driver_banned_cities.create(
      city: cities[rand(cities_len) - 1]
    )
  end
end

# Load data into Vehicle without Driver
# client_vehicles = NUM_VEHICLES - Vehicle.count()
# client_vehicles.times do |n|
#   Vehicle.create(
#     capacity: getCapacity(),
#     load_type: getLoadType()
#   )
# end

# Load data into Route
NUM_ROUTES.times do |n|
  starts_at = getRandomStartDate()
  route = Route.create(
    starts_at: starts_at,
    ends_at: getRandomEndDate(starts_at),
    load_type: getLoadType(),
    load_sum: getCapacity(),
    stops_amount: rand(cities_len)
  )
  # add random cities to the route
  rand(cities_len).times do |d|
    route.route_cities.create(
      city: cities[rand(cities_len) - 1]
    )
  end
end
