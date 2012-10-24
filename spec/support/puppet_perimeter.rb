class PuppetPerimeter < Kindergarten::Perimeter
  class Puppet
  end

  govern do |child|
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