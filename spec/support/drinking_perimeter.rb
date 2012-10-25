class DrinkingPerimeter < Kindergarten::Perimeter
  # supposed to work
  def create_bar(args)
    Bar.create(scrub(args, :name, :description))
  end
  
  # should raise Unscrubbed
  def create_bar_wo(args)
    Bar.create(args)
  end
  
  # should raise Unscrubbed
  def create_joint(args)
    Joint.create(args)
  end
  
  # should not raise Unscrubbed
  def build_joint(args)
    Joint.new(scrub(args, :name))
  end
  
  # should raise Unscrubbed
  def build_dirty_joint
    Joint.new(:name => "dirty")
  end
  
  # should not raise Unscrubbed
  def update_bar(bar, args)
    bar.update_attributes(scrub(args, :name, :city, :street))
  end
  
  # should raise
  def update_bar_dirty(bar, args)
    bar.update_attributes(args)
  end
  
  sandbox :create_bar, :create_bar_wo, :create_joint, :build_joint,
    :build_dirty_joint, :update_bar, :update_bar_dirty
end