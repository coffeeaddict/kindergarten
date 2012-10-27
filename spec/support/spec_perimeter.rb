class SpecPerimeter < Kindergarten::Perimeter
  governess Kindergarten::StrictGoverness

  govern do
    can :view, String
  end

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

  sandbox :sandboxed, :not_guarded, :guarded, :unsafe
end
