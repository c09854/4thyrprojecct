module PokergameHelper
    
    class Card
        
        def initialize(number,suit)
            @number = number
            @suit = suit
        end
        
        def suit
            @suit
        end
        
        def number
            @number
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
                suit = s
                number = i
                card = Card.new(number,suit)
                @pokerdeck << card
               # @pokerdeck << [x,i]
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
        @eg_users
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
            @usr = user[0]
            @best_hand[@usr] = []
            cards = []
            cards = Array.new(@communal_cards)
            cards << user[1]
            cards << user[2]
            calculate_hand cards
        end
       best_hnd_key = determine_winner
    end
    
    def determine_winner
        num = 10
        best_hnd_key = ""
        hand_list = {"straight flush" => 1,"four of a kind" => 2,"fullhouse" => 3,"flush" => 4,"straight" =>5,"three of a kind" =>6,"two pair" =>7,"pair" => 8,"high card" => 9}
        @best_hand.each do |key,value|
            hand = value.pop
            if num > hand_list[hand]
                num = hand_list[hand] 
                best_hnd_key = key
            end
        end
        best_hnd_key
    end
    
    # calculates hand 
    def calculate_hand cards
        straight? cards
        hand_hsh = {}
        suit_hsh = {}
        cards.each do |card|
            determine_cards(card,hand_hsh)
            determine_suits(card,suit_hsh)
        end
        get_best_hand hand_hsh,suit_hsh
    end
    
    # common method for assigning both card value and suit to hashes. called in determine suit, determine facevalue
    def assign_to_hsh hsh,card,key 
        hsh[key] = [] unless hsh.has_key? key
        hsh[key] << card
    end
    
        
    def get_best_hand hand_hsh,suit_hsh
        win_arr = []
        num = 5
        hand = ""
        win_hsh = suit_hsh.select {|key, value| value.length == num};   
        unless win_hsh.empty?
            hand = "flush" 
            win_arr = win_hsh[win_hsh.keys[0]]
        
            str_arr = straight? win_arr
            if str_arr.length == 5
                win_arr = str_arr
                hand = "straight flush"
                win_arr << hand
            end
        end
        win_hsh.clear
        if hand != "straight flush"
            while win_hsh.empty?
                num = num - 1
                    win_hsh = hand_hsh.select {|key, value| value.length == num};
                    win_arr = win_hsh[win_hsh.keys[0]]
            end
        
            case num
                    #selects high card to accompany four of a kind
                when 4
                    compile_hand win_arr,num,hand_hsh,1
                    hand ="four of a kind"
                    # determines if it is a full house or just 3 of a kind and assigns high cards accordingly 
                when 3
                    # if theres two sets of three remove one card to make a fullhouse
                    hand = "fullhouse"
                    if win_arr.length > 3
                        
                        win_arr.sort! {|x,y| y.number <=> x.number}
                        win_arr.pop()
                        
                    else
                        other_card_hsh = hand_hsh.select {|key, card_arr| card_arr.length == 2};
                        
                        if other_card_hsh.empty?
                            win_arr = compile_hand win_arr,num,hand_hsh,2
                            hand = "three of a kind"
                            
                        else
                            pair_arr = []
                            other_card_hsh.each_value {|card_arr| pair_arr = pair_arr + card_arr}     
                            pair_arr.sort! {|x,y| y.number <=> x.number}
                            while pair_arr.length > 2
                                pair_arr.pop
                            end
                                win_arr = win_arr + pair_arr
                        end   
                    end
                        
                    # determines if its two pair or a single pair and assigns high cards accordingly
                when 2
                    # if theres 3 pairs remove the lowest denomination one
                    if win_arr.length > 4
                        win_arr.sort! {|x,y| y.number <=> x.number}
                        win_arr.pop(1)
                    end
                    # if it is two pair one high card required
                    if win_arr.length == 4
                        ################################# needs its own method or lowest demonination pair wont be counted as high card
                       win_arr = compile_hand win_arr,num,hand_hsh,1
                       hand = "two pair"
                     # if it is one pair three high cards required
                    else
                        win_arr = compile_hand win_arr,num,hand_hsh,3
                        hand = "pair"
                    end
                    
                # if there is no pair determine high card
                when 1
                    hand = "high card"
                    win_arr = win_arr + determine_high_card(hand_hsh,5)
            end
        end
            win_arr << hand
            @best_hand[@usr] = win_arr
    end
        
    
    def remove_lowest_value_cards num
        if win_arr.length > num
                win_arr.sort! {|x,y| y.number <=> x.number}
                win_arr.pop()
        end
    end
    #
    #def better_then_flush hand,new_hand, win_arr
    #    unless hand == "flush"
    #        @best_hand[@usr] = win_arr
    #    end
    #end
    #
     #after determining the the type of each card deciding the best hand the player can make called in calculate hand
    def straight? arr
        arr.sort! {|x,y| y.number <=> x.number}
        r = 0
        card_ace = Card.new(14,arr[arr.length-1].suit)
        card = nil
        str_arr = []
        #if arr.include? 10 and arr.include? 11 and arr.include? 12 and arr.include? 13 and arr.include? 1
        #    straight = true
        arr.insert(0,card_ace)if arr[arr.length-1] == 1
            arr.each do |next_card|
                unless card.nil?
                    unless r == 5
                        if card.number - 1 == next_card.number 
                            r = r + 1
                            str_arr << card
                        else
                            str_arr.clear
                            r = 1
                            str_arr << card
                        end
                    end
                else
                    r = 1
                    card = next_card
                    str_arr << card
                end
            end
        @straight = true if r == 5
        if str_arr.include? card_ace
            str_arr.slice!(0)
            str_arr.insert(0,arr[arr.length-1])
        end
    end
    
    def compile_hand win_arr,num,hand_hsh,high_cards
        other_card_hsh = hand_hsh.select {|key, value| value.length < num};
        win_arr = win_arr + determine_high_card(other_card_hsh,high_cards)
    end
    
   # determines if highcards are needed which cards should be in the winning hand called in called in get_hand
    def determine_high_card hsh,num
        arr = []
        num1 = 2

        hsh.each_value {|card| arr << card}
        arr.flatten!
        arr.sort! {|x,y| y.number <=> x.number}
        while arr.length > num
            arr.pop
        end
        return arr
    end
    
    # assigns cards to hash based on there number value called in calculate hand
    def determine_cards(card,hsh)
        case card.number
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
    end
    
    def determine_suits(card,hsh)
        case card.suit
            
            when 'd'
                assign_to_hsh(hsh,card,:diomand)
            when 's'
                assign_to_hsh(hsh,card,:spade)
            when 'h'
                assign_to_hsh(hsh,card,:heart)
            when 'c'
                assign_to_hsh(hsh,card,:club)
        end
    end
end
