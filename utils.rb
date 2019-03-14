require './constant'

# Return a random string with values from 1 to 9
def random_phone(output_length)
  "+56#{output_length.times.map{rand(2..9)}.join}"
end

# Return a random load type
def getLoadType()
  LOAD_TYPES[rand(LOAD_TYPES.length)]
end

# Return a random capacity
def getCapacity()
  rand(MIN_CAP..MAX_CAP)
end

# Return a random hour for the next day between a certain range of hours
def getRandomStartDate()
  t_hour = rand(START_HOUR..FINISH_HOUR - 1)
  DateTime.now.next.change(hour: t_hour)
end

# Return a random hour for the next day between a certain range of hours adding
# MIN_DURATION to initial hour
def getRandomEndDate(starts_at)
  start = starts_at.hour + MIN_DURATION
  t_hour = rand(start..FINISH_HOUR)
  starts_at.change(hour: t_hour)
end
