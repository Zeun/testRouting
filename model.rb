# Instead of loading all of Rails, load the
# particular Rails dependencies we need
require 'sqlite3'
require 'active_record'

# Set up a database that resides in RAM
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

# Set up database tables and columns
ActiveRecord::Schema.define do
  create_table :cities, force: true do |t|
    t.string :name
    t.string :region
  end
  
  create_table :routes, force: true do |t|
    t.datetime :starts_at
    t.datetime :ends_at
    t.string :load_type
    t.integer :load_sum
    t.integer :stops_amount
    t.references :route_cities
    t.references :assign
  end

  create_table :vehicles, force: true do |t|
    t.integer :capacity
    t.string :load_type
    t.references :driver
  end

  create_table :drivers, force: true do |t|
    t.string :name
    t.string :phone
    t.string :email
    t.references :driver_banned_cities
  end

  create_table :route_cities, force: true do |t|
    t.references :city
    t.references :route
  end

  create_table :driver_banned_cities, force: true do |t|
    t.references :city
    t.references :driver
  end

  create_table :assigns, force: true do |t|
    t.datetime :starts_at
    t.datetime :ends_at
    t.references :driver
    t.references :route
  end

  # create_table :driver_vehicles, force: true do |t|
  #   t.references :driver
  #   t.references :vehicle
  # end
end

# Set up model classes
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Route < ApplicationRecord
  has_many :route_cities
  has_one :assign
end

class City < ApplicationRecord
end

class RouteCity < ApplicationRecord
  belongs_to :route
  belongs_to :city
end

class Driver < ApplicationRecord
  has_one :vehicle
  has_many :driver_banned_cities
end

class DriverBannedCity < ApplicationRecord
  belongs_to :driver
  belongs_to :city
end

class Vehicle < ApplicationRecord
  belongs_to :driver
end

class Assign < ApplicationRecord
  belongs_to :driver
  belongs_to :route
end

# class DriverVehicles < ApplicationRecord
#   belongs_to :driver
#   belongs_to :vehicle
#   belongs_to :assign
# end
