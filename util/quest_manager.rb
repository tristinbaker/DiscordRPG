module Util
  class QuestManager
    def initialize(quests)
      @quests = quests
    end

    def print_quest_log(player)
      opts = {}
      opts[:title] = "#{player.player_name} Quest Log"
      opts[:description] = ""
      quests = player.player_quest_log.quests
      quests.each_with_index do |(quest_id, quest), i|
        opts[:description] += "#{i + 1}) **#{quest[:quest_name]}** - *#{quest[:quest_description]}*\nProgress: #{quest[:quest_enemies_killed]} / #{quest[:quest_enemy_required]} #{quest[:quest_enemy]}s\n"
      end
      opts[:opts] = Hash.new("")
      return opts
    end

    def check_quest_status(quest, player)
    end
  end
end
