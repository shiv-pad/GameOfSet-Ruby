class Card
  # Generate a random number between 0 and 2
  def random_num
    Random.rand(0..2)
  end

  # Generate a new card
  def generate_card
    number_of_shapes = Random.rand(1..3)

    shape_type = ["diamond", "squiggle", "oval"]
    shape = shape_type[random_num]

    shading_type = ["solid", "stripped", "open"]
    shading = shading_type[random_num]

    color_type = ["red", "green", "purple"]
    color = color_type[random_num]

    [number_of_shapes, shape, shading, color]
  end

  
  # Check if three cards form a set
  def check_cards(card_one, card_two, card_three, card_collector)
    card_one_index = card_one.to_i
    card_two_index = card_two.to_i
    card_three_index = card_three.to_i

    if(card_collector[card_one_index-1] == "No Card" || card_collector[card_two_index-1] == "No Card" || card_collector[card_three_index-1] == "No Card")
      count_check = false
    else
      count_check = (card_collector[card_one_index - 1][0] == card_collector[card_two_index - 1][0] && card_collector[card_two_index - 1][0] == card_collector[card_three_index - 1][0] && card_collector[card_one_index - 1][0] == card_collector[card_three_index - 1][0]) ||
                    (card_collector[card_one_index - 1][0] != card_collector[card_two_index - 1][0] && card_collector[card_two_index - 1][0] != card_collector[card_three_index - 1][0] && card_collector[card_one_index - 1][0] != card_collector[card_three_index - 1][0])

      shape_check = (card_collector[card_one_index - 1][1] == card_collector[card_two_index - 1][1] && card_collector[card_two_index - 1][1] == card_collector[card_three_index - 1][1] && card_collector[card_one_index - 1][1] == card_collector[card_three_index - 1][1]) ||
                    (card_collector[card_one_index - 1][1] != card_collector[card_two_index - 1][1] && card_collector[card_two_index - 1][1] != card_collector[card_three_index - 1][1] && card_collector[card_one_index - 1][1] != card_collector[card_three_index - 1][1]) 

      shading_check = (card_collector[card_one_index - 1][2] == card_collector[card_two_index - 1][2] && card_collector[card_two_index - 1][2] == card_collector[card_three_index - 1][2] && card_collector[card_one_index - 1][2] == card_collector[card_three_index - 1][2]) ||
                      (card_collector[card_one_index - 1][2] != card_collector[card_two_index - 1][2] && card_collector[card_two_index - 1][2] != card_collector[card_three_index - 1][2] && card_collector[card_one_index - 1][2] != card_collector[card_three_index - 1][2]) 

      color_check = (card_collector[card_one_index - 1][3] == card_collector[card_two_index - 1][3] && card_collector[card_two_index - 1][3] == card_collector[card_three_index - 1][3] && card_collector[card_one_index - 1][3] == card_collector[card_three_index - 1][3]) ||
                      (card_collector[card_one_index - 1][3] != card_collector[card_two_index - 1][3] && card_collector[card_two_index - 1][3] != card_collector[card_three_index - 1][3] && card_collector[card_one_index - 1][3] != card_collector[card_three_index - 1][3]) 
    end
                      
                      
    count_check && shape_check && shading_check && color_check 
  end


  #generate a card and check if it has occurred already
  def generate_and_check(card_collector,cards_done)
    card = generate_card
    if card_collector.include?(card) || cards_done.include?(card)
        while card_collector.include?(card) || cards_done.include?(card)
            card = generate_card
        end
    end
    card
  end

  def count_cards_not_nil(card_collector)
    card_collector.count { |card| card != nil }
  end

  #displays the cards
  def display_cards(card_collector)
    count = 0
    while count < card_collector.length
      # Only display the card if it's not nil
      unless card_collector[count].nil?
        if card_collector[count] == "No Card"
          puts "#{count+1}. No Card"
        else
          puts "#{count+1}.    #{card_collector[count][0]},  #{card_collector[count][1]},  #{card_collector[count][2]},  #{card_collector[count][3]}"
        end
        count += 1
      end
    end
  end
  
  #checks if sets are available
  def sets_available?(card_collector)
    num_cards = card_collector.length
    sets_found = false # Flag to track if any set is found
  
    # Iterate through all unique combinations of three cards
    (0...num_cards).each do |i|
      (i+1...num_cards).each do |j|
        (j+1...num_cards).each do |k|
          # Use the existing check_cards method to see if they form a set
          if card_collector[i] != "No Card" && card_collector[j] != "No Card" && card_collector[k] != "No Card" && check_cards((i+1).to_s, (j+1).to_s, (k+1).to_s, card_collector)
            sets_found = true
          end
        end
      end
    end
  
    sets_found
  end


  #displays sets from the board
  def display_sets(card_collector)
    num_cards = card_collector.length
  
    # Iterate through all unique combinations of three cards
    (0...num_cards).each do |i|
      (i+1...num_cards).each do |j|
        (j+1...num_cards).each do |k|
          # Use the existing check_cards method to see if they form a set
          if card_collector[i] != "No Card" && card_collector[j] != "No Card" && card_collector[k] != "No Card" && check_cards((i+1).to_s, (j+1).to_s, (k+1).to_s, card_collector)
            # Print out the valid set combination
            puts "Valid set found: Card #{i+1}, Card #{j+1}, Card #{k+1}"
            puts "  Card #{i+1}: #{card_collector[i].inspect}"
            puts "  Card #{j+1}: #{card_collector[j].inspect}"
            puts "  Card #{k+1}: #{card_collector[k].inspect}"
          end
        end
      end
    end
  end
end

