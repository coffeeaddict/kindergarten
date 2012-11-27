class SpecPerimeter < Kindergarten::Perimeter
  purpose :testing

  governess Kindergarten::StrictGoverness

  govern do
    can :view, String
  end

  subscribe :eating, :eat, :evented
  subscribe :puppets, :play, lambda { |event, purpose|
    purpose.sandbox.testing.dress!
  }

  # should pass and return the child
  def sandboxed
    guard(:view, child)
  end

  # should raise AccessDenied
  def guarded
    guard(:somethings, child)
  end

  # should not be accessible
  def unboxed
    $stderr.puts "I should never happen"
  end

  # should return "OK"
  def not_guarded
    unguarded
    "OK"
  end

  # should raise Unguarded
  def unsafe
    return child.reverse
  end

  # happens on dining.eat event
  def evented
    @evented = true
  end

  def evented?
    @evented == true ? true : false
  end

  expose :dress!
  def dress!
    unguarded
    @dressed = true
  end

  def puppet_dressed?
    unguarded
    @dressed == true ? true : false
  end

  sandbox :sandboxed, :not_guarded, :guarded, :unsafe, :evented
  expose :puppet_dressed?
end
