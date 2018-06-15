require_relative './section-8-provided'

class Character
  def initialize hp
    @hp = hp
  end

  def resolve_encounter enc
    if !is_dead?
      play_out_encounter enc
    end
  end

  def is_dead?
    @hp <= 0
  end

  private
  def play_out_encounter enc
    enc.encounter self
  end
end

class Knight < Character
  def initialize(hp, ap)
    super hp
    @ap = ap
  end

  def to_s
    "HP: " + @hp.to_s + " AP: " + @ap.to_s
  end

  def damage_knight(dam, hp, ap)
    if ap == 0
      [hp - dam, 0]
    else
      if dam < ap then damage_knight(dam-ap, hp, 0) else [hp, ap-dam] end
    end
  end

  def encounterFloorTrap floor_trap
      hPoints, aPoints = damage_knight(floor_trap.dam, @hp, @ap)
      Knight.new(hPoints, aPoints)
  end

  def encounterMonster monster
    hPoints, aPoints = damage_knight(monster.dam, @hp, @ap)
    Knight.new(hPoints, aPoints)
  end

  def encounterPotion potion
    Knight.new(potion.hp + @hp, @ap)
  end

  def encounterArmor armor
    Knight.new(@hp, armor.ap + @ap)
  end
end

class Wizard < Character
  def initialize(hp, mp)
    super hp
    @mp = mp
  end

  def to_s
    "HP: " + @hp.to_s + " MP: " + @mp.to_s
  end

  def encounterFloorTrap floor_trap
    if @mp > 0
      Wizard.new(@hp, @mp - 1)
    else
      Wizard.new(@hp - floor_trap.dam, @mp)
    end
  end

  def encounterMonster monster
    Wizard.new(@hp, @mp - monster.hp)
  end

  def encounterPotion potion
    Wizard.new(@hp + potion.hp, @mp + potion.mp)
  end

  def encounterArmor armor
    self
  end
end

class FloorTrap < Encounter
  attr_reader :dam

  def initialize dam
    @dam = dam
  end

  def to_s
    "A deadly floor trap dealing " + @dam.to_s + " point(s) of damage lies ahead!"
  end

  def encounter character
    character.encounterFloorTrap self
  end
end

class Monster < Encounter
  attr_reader :dam, :hp

  def initialize(dam, hp)
    @dam = dam
    @hp = hp
  end

  def to_s
    "A horrible monster lurks in the shadows ahead. It can attack for " +
        @dam.to_s + " point(s) of damage and has " +
        @hp.to_s + " hitpoint(s)."
  end

  def encounter character
    character.encounterMonster self
  end
end

class Potion < Encounter
  attr_reader :hp, :mp

  def initialize(hp, mp)
    @hp = hp
    @mp = mp
  end

  def to_s
    "There is a potion here that can restore " + @hp.to_s +
        " hitpoint(s) and " + @mp.to_s + " mana point(s)."
  end

  def encounter character
    character.encounterPotion self
  end
end

class Armor < Encounter
  attr_reader :ap

  def initialize ap
    @ap = ap
  end

  def to_s
    "A shiny piece of armor, rated for " + @ap.to_s +
        " AP, is gathering dust in an alcove!"
  end

  def encounter character
    character.encounterArmor self
  end
end

if __FILE__ == $0
  Adventure.new(Stdout.new, Knight.new(15, 3),
    [Monster.new(1, 1),
    FloorTrap.new(3),
    Monster.new(5, 3),
    Potion.new(5, 5),
    Monster.new(1, 15),
    Armor.new(10),
    FloorTrap.new(5),
    Monster.new(10, 10)]).play_out

    Adventure.new(Stdout.new, Wizard.new(15, 3),
      [Monster.new(1, 1),
      FloorTrap.new(3),
      Monster.new(5, 3),
      Potion.new(5, 5),
      Monster.new(1, 15),
      Armor.new(10),
      FloorTrap.new(5),
      Monster.new(10, 10)]).play_out
end
