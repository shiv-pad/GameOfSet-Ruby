require_relative 'player'

class PlayerCreator
  attr_reader :num_of_players
  
  #checks number of players that need to be created
    def get_players
      loop do
        puts "Enter number of players playing (1-6): "
        input = gets.chomp

        # Check if the input is a valid integer between 1 and 6
        if input.match?(/^\d+$/) && input.to_i.between?(1, 6)
          @num_of_players = input.to_i
          break # Exit the loop if input is valid
        else
          puts "Invalid input. Please enter a number between 1 and 6."
        end
      end

  # Create players based on the valid number of players entered
  @game_players = []
  @num_of_players.times do |index|
    @game_players.push(Player.new((index + 1).to_s))
  end
  @game_players
    end

    def player_score(player_num)
      @game_players[player_num-1].score
    end

    def update_player_score(player_num, point)
      @game_players[player_num-1].update_score(point)
    end

  
end