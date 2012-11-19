module PokergameHelper
  
    def generate_deck_of_cards
        @pokerdeck = []
        #club spade heart and diamond
        suits = ["c","s","h","d"]
        suits.each do |s|
            (1..13).each do |i|
            x = i
            @pokerdeck << [x, s]
        end
      end
    end
    
    def shuffle_cards
        @pokerdeck.shuffle!
    end
    
    def deal
        users.each 
    end
    
    def deal_flop
        @pokerdeck.pop
        flop = @pokerdeck.pop(3)
        return flop
    end
    
    def deal_turn
        @pokerdeck.pop
        turn = @pokerdeck.pop
        return turn
    end
    
    def deal_river
        @pokerdeck.pop
        river = @pokerdeck.pop
        return river
    end
    
  end
