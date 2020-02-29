defmodule Poker do
    def deal(list) do
        
    end
    
    
    def pokerHandRankings do
        
    end


    def Royalflush?(hand) do
        case hand do
            [1,10,11,12,13] -> true
            [27,36,37,38,39] -> true
            [14,23,24,25,26] -> true
            [40,49,50,51,52] -> true
            _ -> false
        end
    end



    def Royalflush?([1,10,11,12,13]) do
        true
    end
    def Royalflush?([14,23,24,25,26]) do
        true
    end
    def Royalflush?([27,36,37,38,39]) do 
        true
    end
    def Royalflush?([40,49,50,51,52]) do
        true
    end

    
    def flush?(hand) 
        range1 = 1..13
        range2 = 14..26
        range3 = 27..39
        range4 = 40..52
        lst1 = Enum.map(hand, fn num -> Enum.member?(range1,num) end) 
        lst2 = Enum.map(hand, fn num -> Enum.member?(range2,num) end) 
        lst3 = Enum.map(hand, fn num -> Enum.member?(range3,num) end) 
        lst4 = Enum.map(hand, fn num -> Enum.member?(range4,num) end)
        case lst1 lst do
            
        end
        
    end
    
    def straight?(hand) 
    
end
