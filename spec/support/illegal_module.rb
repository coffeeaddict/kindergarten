class IllegalModule < Kindergarten::Perimeter
  purpose :none

  expose :fire
  def fire
    warn "You should not see me"
  end
end
