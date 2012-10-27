class DiningPerimeter < Kindergarten::Perimeter
  purpose :eating

  # should raise Unscrubbed
  def create_restaurant_scrubbed(args)
    Restaurant.create(scrub(args, :name, :description))
  end

  # should work
  def create_restaurant(args)
    safe = rinse(args, :name => /([\w\s\-]+)/, :description => :pass)
    Restaurant.create(safe)
  end

  sandbox :create_restaurant_scrubbed, :create_restaurant
end
