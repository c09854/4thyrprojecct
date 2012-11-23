module PokergameHelper
    
    class card
        
        def initilize(number,suit)
            @number = number
            @suit = suit
        end
        
        def suit
            @suit
        end
        
        def number
            @number
        end
        
        def card
            [@number,@suit]
        end
    end 
    
    def generate_deck_of_cards
        @eg_users = [[1],[2]]
        @winninghand = {}
        @pokerdeck = []
        #club spade heart and diamond
        suits = ["c","s","h","d"]
        suits.each do |s|
            (1..13).each do |i|
                x = i
                #card = Card.new(x,s)
                #@pokerdeck << card
                @pokerdeck << [x,i]
            end
        end
    end
    
    
    
    # shuffles poker deck
    def shuffle_cards
        @pokerdeck.shuffle!
    end
    
    
    
    #deals a card to each user
    def deal_card
        @eg_users.each do |user|
            user << @pokerdeck.pop
        end
    end
    
    
    #  burns one card and deals three cards for the flop
    def deal_flop
        @pokerdeck.pop
        flop = @pokerdeck.pop(3)
        @communal_cards = flop
        return flop
    end
    
    
    # burns one card and deals a card for the turn
    def deal_turn
        @pokerdeck.pop
        turn = @pokerdeck.pop
        @communal_cards << turn
        return turn
    end
    
    
    #burn one card and deals a card for the river
    def deal_river
        @pokerdeck.pop
        river = @pokerdeck.pop
        @communal_cards << river
        return river
    end
    
    
    #determines the winner of the hand of poker
    def winner
        @best_hand = {}
        @eg_users.each do |user|
           #require 'debugger' ; debugger
            @usr = user[0]
            @best_hand[@usr] = []
            cards = []
            cards = cards + @communal_cards
            cards << user[1]
            cards << user[2]
            calculate_hand cards,@usr
        end
        determine_winner
    end
    
    # calculates hand 
    def calculate_hand cards
       # d,s,h,c,ace,two,three,four,five,six,seven,eight,nine,ten,jack,queen,king = 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        hand_hsh
        cards.each do |card|
            determine_cards(card,hand_hsh)
        end
        get_hand hand_hsh
    end
    
    
    # assigns cards to hash based on there number value called in calculate hand
    def determine_cards(card,hsh)
        case card[0]
        when 1
            assign_to_hsh(hsh,card,:ace)
        when 2
            assign_to_hsh(hsh,card,:two)
        when 3
            assign_to_hsh(hsh,card,:three)
        when 4
            assign_to_hsh(hsh,card,:four)
        when 5
            assign_to_hsh(hsh,card,:five)
        when 6
            assign_to_hsh(hsh,card,:six)
        when 7
            assign_to_hsh(hsh,card,:seven)
        when 8
            assign_to_hsh(hsh,card,:eight)
        when 9
            assign_to_hsh(hsh,card,:nine) 
        when 10
            assign_to_hsh(hsh,card,:ten)
        when 11
            assign_to_hsh(hsh,card,:jack)
        when 12
            assign_to_hsh(hsh,card,:queen)
        when 13
            assign_to_hsh(hsh,card,:king)
        end
        
        case card[1]
        
        when 'd'
            assign_to_hsh(hsh,d,card,:diomand)
        when 's'
            assign_to_hsh(hsh,s,card,:spade)
        when 'h'
            assign_to_hsh(hsh,h,card,:heart)
        when 'c'
            assign_to_hsh(hsh,c,card,:club)
        end
    end
    
    # common method for assigning both card value and suit to hashes. called in determine suit, determine facevalue
    def assign_to_hsh hsh,card,key 
        hsh[key] = [] unless hsh.has_key? key
        hsh[key] << card
    end
    
    # after determining the the type of each card deciding the best hand the player can make called in calculate hand
    def get_hand hand_hsh
        hand = ""
        get_best_hand hand_hsh,hand  
    end
    
    def straight? hsh
        arr = []
        str_arr = []
        hsh.each do |key,value|
            value.each do |card|
                arr << card
            end
        end
        arr.sort! {|x,y| y[0] <=> x[0]}
        a.selec
        r = 0
        if arr.include? 10 and arr.include? 11 and arr.include? 12 and arr.include? 13 and arr.include? 1
            straight = true
        else
            arr.each do |card,next_card|
                unless r == 5
                    if card[0] - 1 == next_card[0]
                        r + 1
                        str_arr << card
                    else
                        r = 1
                    endla
                end
            end
        end
        straight = true if r == 5
        straight,str_arr
    end
    
    
    def get_best_hand hand_hsh,hand
        win_arr = []
        num = 5
        win_hsh = hand_hsh.select {|key, value| value.length == num};
        unless win_hsh.empty?
           win_arr = win_hsh[win_hsh.keys[0]]
        while win_hsh.empty?
            num = num - 1
            win_hsh = hand_hsh.select {|key, value| value.length == num};
        end
        case num
        #selects high card to accompany four of a kind
        when 4
            other_card_hsh = hand_hsh.select {|key, value| value.length < 4};
            win_hsh.merge(determine_high_card(other_card_hsh,1))
            hand = "four of a kind"
            # determines if it is a full house or just 3 of a kind and assigns high cards accordingly 
        when 3
            other_card_hsh = hand_hsh.select {|key, value| value.length == 2};
            if other_card_hsh.empty?
                other_card_hsh = hand_hsh.select {|key, value| value.length == 1};
                win_hsh.merge(determine_high_card(other_card_hsh,3))
                better_then_flush win_hsh, hand, "three of a kind"
            end
            win_hsh.merge(other_card_hsh)
            hand = "fullHouse"
            # determines if its two pair or a single pair and assigns high cards accordingly
        when 2    
        # if it is two pair one high card required
            if win_hsh.length == 4
                
                other_card_hsh = hand_hsh.select {|key, value| value.length < 2};
                win_hsh.merge(determine_high_card(other_card_hsh,1))
                better_then_flush win_hsh, hand, "two pair"
                # if it is one pair three high cards required
            else
                
                other_card_hsh = hand_hsh.select {|key, value| value.length < 2};
                win_hsh.merge(determine_high_card(other_card_hsh,3))
                 better_then_flush win_hsh, hand, "pair"
            end   
        
        # if there is no pair determine high card
        when 1
            win_hsh.merge(determine_high_card(hand_hsh,5))
            better_then_flush win_hsh, hand, "high card"
        end
        return hand,win_hsh
    end
    
    def better_then_flush hsh,hand,new_hand
        unless hand == "flush"
            hand = new_hand
            hsh.each do |key, value|
                value.each do |card|
                    @best_hand[@usr] << card
                end
            end
        end
    end
    
    
   # determines if highcards are needed which cards should be in the winning hand called in called in get_hand
    def determine_high_card hsh,num
        arr = []
        num1 = 2
        while hsh.length > num
            hsh.delete_if {|key,value| value[0][0] == num1}
            num1 = num1 + 1
        end
    end 
end
