module Events
  class Battle
    attr_accessor :player, :enemy, :turn_number, :db

    def initialize(player, enemy, db)
      @player = player
      @enemy = enemy
      @turn_number = 1
      @db = db
    end

    def handle_player_attack
      attack_damage = @player.get_player_damage(@enemy)
      @enemy.hp -= attack_damage
      if @enemy.hp <= 0
        @player.experience += @enemy.experience_drop
        if @player.experience >= @player.experience_level
          @player.increase_level(@player, @db)
        end
      end
    end

    def handle_enemy_attack
      attack_damage = @enemy.get_enemy_damage(@player)
      @player.hp -= attack_damage
    end
  end
end
