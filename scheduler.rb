# Prueba Routing

# Load the above file
require './model'

# Load Seeds
eval File.read("./seeds.rb")


def displayData()
  puts "\nROUTES"
  Route.all().each do |route|
    puts route.inspect
  end

  puts "----\n\n"
  puts 'DRIVERS'
  Driver.all().each do |driver|
    puts driver.inspect
  end

  puts "----\n\n"
  puts 'VEHICLES'
  Vehicle.all().each do |vehicle|
    puts vehicle.inspect
  end
  
  puts "\nEnd of Data \n----\n\n"
end

def schedule()
  # Get routes for the next day
  currentDate = DateTime.now
  nextDayDate = currentDate.next

  # Get all routes without and assignment for the next day
  routes = Route.where(
    'id NOT IN (SELECT route_id FROM assigns WHERE starts_at BETWEEN ? AND ?)', nextDayDate.beginning_of_day, nextDayDate.end_of_day
  )

  routes.each do |route|
    # Get all drivers without and assignment for the next day
    drivers = Driver.where(
      'id NOT IN (SELECT driver_id FROM assigns WHERE (starts_at BETWEEN ? AND ?) OR (ends_at BETWEEN ? AND ?))',
      route.starts_at,
      route.ends_at,
      route.starts_at,
      route.ends_at
    )

    # Get the route's cities
    cities = route.route_cities.map(&:id)

    drivers.each do |driver|
      # Get the driver banned's cities
      driver_cities = driver.driver_banned_cities.map(&:id)

      # Skip driver if driver has any route city banned
      next if (cities & driver_cities).length > 0

      # Skip driver if load type is different
      next unless driver.vehicle.load_type == route.load_type

      # Skip driver if capacity of vehicle is less than route required capacity
      next if driver.vehicle.capacity < route.load_sum

      # Create assign for the first driver that meet the requirement
      route.create_assign(driver: driver, starts_at: route.starts_at, ends_at: route.ends_at)
      break

    end
  end
end

def printResults()
  puts "ID Vehículo, ID Conductor, ID RUTA, Hora Inicio, Hora Fin"
  Assign.all().includes(:driver).order("drivers.id asc, assigns.starts_at asc").each do |assign|
    puts "#{assign.driver.vehicle.id}, #{assign.driver.id}, #{assign.route.id}, #{assign.starts_at}, #{assign.ends_at}"
  end
  
  routes_ids = Route.joins('left join assigns on assigns.route_id = routes.id').where('assigns.route_id is null').map(&:id)
  
  puts "\nThe list of unasigned routes id is #{routes_ids}" if routes_ids.length > 0
end

displayData()
schedule()
printResults()
