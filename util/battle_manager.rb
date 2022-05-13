require_relative "../entities/enemy"
require_relative "../events/battle"
require_relative "./message_helper"

module Util
  class BattleManager
    attr_accessor :active_battles, :finished_battles

    def initialize
      @active_battles = []
      @finished_battles = []
    end

    def add_battle(player, gsm, arguments)
      opts = {}
      battle = @active_battles.select { |ab| ab.player == player }&.first
      if battle.nil?
        enemy = gsm.enemies.select { |enmy| enmy.name.downcase == arguments[2].downcase }&.first
        if enemy.nil?
          opts = MessageHelper.unknown_enemy_opts(arguments[2])
        else
          enemy = Entities::Enemy.new(enemy.enemy_id, gsm.db)
          battle = Events::Battle.new(player, enemy, gsm.db)
          @active_battles << battle
          opts = print_player_battle(battle)
        end
      else
        opts = MessageHelper.battle_already_started_opts
      end
      return opts
    end

    def print_player_battle(battle)
      opts = {}
      opts = MessageHelper.show_battle_opts(battle)
      return opts
    end
  end
end
