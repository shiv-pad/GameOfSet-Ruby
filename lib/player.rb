class Player
    attr_reader :name
    attr_accessor :score

    #player is created 
    def initialize(name)
        @name = name
        @score = 0
    end

    def to_s
        "#{@name}"
    end
    #score updated for player
    def update_score(point)
        @score+=point
    end

end