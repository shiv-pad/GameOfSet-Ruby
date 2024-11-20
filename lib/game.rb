require_relative 'player_creator'
require_relative 'card'

class Game
  # Initialize the game with a player creator
  def initialize
    @player_creator = PlayerCreator.new
  end
  # Add players to the game
  def add_players
    @players = @player_creator.get_players
    puts "Welcome Players #{@players.join(' ')}"
  end
  # Get the number of players
  def get_players
    @player_creator.num_of_players
  end
  # Get a player's score
  def get_player_score(player_ID)
    @player_creator.player_score(player_ID)
  end
  # Update a player's score
  def change_player_score(player_ID,point)
    @player_creator.update_player_score(player_ID, point)
  end
  # Display the scores
  def display_score()
    puts "Score(s): "
    get_players.times do |index|
      puts "Player#{index+1}: #{get_player_score(index+1)}"
    end
    puts "\n"
  end
  
  # Start the game
  def start
    total = 0
    card_collector = []
    
    add_players
    @card_s = Card.new
    # Generate 12 initial cards
    while total < 12
      card = @card_s.generate_card
      if card_collector.include?(card)
        while card_collector.include?(card)
          card = @card_s.generate_card
        end
      end
      card_collector.push(card)
      total += 1
    end
    # Display the initial cards
    @card_s.display_cards(card_collector)


    cards_done = []
    game_on = true
    # Game loop
    while(game_on)
      #check sets availability
      if (@card_s.sets_available?(card_collector))
        puts "There are sets that can be made on the board"
      else
        puts "There are no sets on the board. Add cards to game"
      end
      
      card_one = nil
      # Get the first card selection from the player
      loop do
        puts "Enter 'q' to quit, 'add' to add three more cards, 'h' for hint to display possible sets or select a card number (1-#{@card_s.count_cards_not_nil(card_collector)}):"
        card_one = gets.chomp
    
        # Handle 'q', 'add', or valid card number input
        if card_one == "q"
          puts "Final Score"
          display_score
          game_on = false
          break
        elsif card_one == "add"
          if total == 81
            puts "All 81 cards have been dealt"
          else
            3.times do
              card_collector.push(@card_s.generate_and_check(card_collector, cards_done))
              total += 1
            end
            puts "3 new cards have been added!" 
            if (@card_s.sets_available?(card_collector))
              puts "There are sets that can be made on the board"
            else
              puts "There are no sets on the board. Add cards to game"
            end
            @card_s.display_cards(card_collector)
          end
        elsif card_one == "h"
          @card_s.display_sets(card_collector)
        elsif card_one.match?(/^\d+$/) && card_one.to_i.between?(1, @card_s.count_cards_not_nil(card_collector))
          break # valid card number, exit the loop
        else
          puts "Invalid input."
        end
      end

      break unless game_on
      card_two = nil
      # Get the second card selection from the player
      loop do
        puts "Enter 2nd card number: "
        card_two = gets.chomp

        # Check if the input is a valid integer between 
        if card_two.match?(/^\d+$/) && card_two.to_i.between?(1, @card_s.count_cards_not_nil(card_collector))
          break # Exit the loop if input is valid
        else
          puts "Invalid input."
        end
      end
      card_three = nil
      # Get the third card selection from the player
      loop do
        puts "Enter 3rd card number: "
        card_three = gets.chomp

        # Check if the input is a valid integer 
        if card_three.match?(/^\d+$/) && card_three.to_i.between?(1, @card_s.count_cards_not_nil(card_collector))
          break # Exit the loop if input is valid
        else
          puts "Invalid input."
        end
      end


      # Check if the cards form a valid set
      if @card_s.check_cards(card_one, card_two, card_three, card_collector)
        if(total>=81)
          puts "All cards have been distributed"
          cards_done.push(card_collector[card_one.to_i-1])
          card_collector[card_one.to_i-1] = "No Card"
    
          cards_done.push(card_collector[card_two.to_i-1])
          card_collector[card_two.to_i-1] = "No Card"

          cards_done.push(card_collector[card_three.to_i-1])
          card_collector[card_three.to_i-1] = "No Card"
        else
          puts "That's a valid set! The three cards have been replaced" 
          cards_done.push(card_collector[card_one.to_i-1])
          card_collector[card_one.to_i-1] = @card_s.generate_and_check(card_collector,cards_done)
    
          cards_done.push(card_collector[card_two.to_i-1])
          card_collector[card_two.to_i-1] = @card_s.generate_and_check(card_collector,cards_done)

          cards_done.push(card_collector[card_three.to_i-1])
          card_collector[card_three.to_i-1] = @card_s.generate_and_check(card_collector,cards_done)
          total+=3
        end

        #give  or deduct point to appropriate player
        if(get_players>1)

          loop do
            puts "Enter player number who got this set(ex. 1): "
            name = gets.chomp
            # Check if the input is a valid integer between 1 and 6
            if name.match?(/^\d+$/) && name.to_i.between?(1, get_players)
              change_player_score(name.to_i,1)
              break # Exit the loop if input is valid
            else
              puts "Invalid input. Please enter a valid player number."
            end
          end

        else
          change_player_score(0,1)
        end

      else
        puts "Not a valid set!"
        if(get_players>1)

          loop do
            puts "Enter player number who did not get this set(ex. 1): "
            name = gets.chomp
            # Check if the input is a valid integer between 1 and 6
            if name.match?(/^\d+$/) && name.to_i.between?(1, get_players)
              change_player_score(name.to_i,-1)
              break # Exit the loop if input is valid
            else
              puts "Invalid input. Please enter a valid player number."
            end
          end

        else
          change_player_score(0,-1)
        end
      end

      display_score
      @card_s.display_cards(card_collector)

      #checks if game is over
      if(total == 81 && @card_s.sets_available?(card_collector) == false)
        puts "Game Over! No more sets to be made"
        display_score
        break
      end
    end
    
  end
end