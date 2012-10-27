class PuppetPerimeter < Kindergarten::Perimeter
  purpose :puppets

  class Puppet
  end

  govern do
    can [:play_with,:dress,:nappy_change], Puppet
    cannot [:tear, :bbq], Puppet
  end

  def grab_puppet
    guard(:play_with, Puppet.new)
  end

  def play_puppet(puppet, action)
    guard(:action, puppet)
  end

  sandbox :grab_puppet, :play_puppet
end
