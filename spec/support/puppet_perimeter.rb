class PuppetPerimeter < Kindergarten::Perimeter
  purpose :puppets

  class Puppet
  end

  govern do
    can [:play_with,:dress,:nappy_change], Puppet
    cannot [:tear, :bbq], Puppet
  end

  def grab
    guard(:play_with, Puppet.new)
  end

  def play(action, puppet)
    guard(action, puppet)
    fire(:play, [action, puppet])
  end

  sandbox :grab, :play
end
