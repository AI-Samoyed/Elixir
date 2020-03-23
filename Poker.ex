#Authors: Thi Thach Thao Nguyen [500881222]

#Version 3
#Date: March 8, 2020

defmodule Poker do

    def deal(list) do
        left = Enum.sort([] ++ [Enum.at(list,0)] ++ [Enum.at(list,2)] ++ [Enum.at(list,4)] ++ [Enum.at(list,6)] ++ [Enum.at(list,8)])
        right = Enum.sort([] ++ [Enum.at(list,1)] ++ [Enum.at(list,3)] ++ [Enum.at(list,5)] ++ [Enum.at(list,7)] ++ [Enum.at(list,9)])
        rankL= ranking(left)
        rankR = ranking(right)
        cond do 
            rankL > rankR -> display(left)
            rankR > rankL -> display(right)
            rankL == 10 -> display(compare10(left,right))
            rankL == 9 -> display(compare5(left,right))
            rankL == 8 -> display(compare8(left,right))
            rankL == 7 -> display(compare7(left,right))
            rankL == 6 -> display(compare6(left,right))
            rankL == 5 -> display(compare5(left,right))
            rankL == 4 -> display(compare7(left,right))
            rankL == 3 -> display(compare3(left,right))
            rankL == 2-> display(compare2(left,right))
            rankL == 1 -> display(compare1(left,right))
        end
        
    end
    
    def ranking(hand) do
        
        cond do
            royalFlush?(hand) == true-> 10
            straightFlush?(hand) == true-> 9
            fourOfAKind?(hand) == true -> 8
            fullHouse?(hand) == true-> 7
            flush?(hand) == true-> 6
            straight?(remSort(hand))  == true-> 5
            threeOfAKind?(hand)  == true-> 4
            twoPair?(hand)  == true-> 3
            pair?(hand)  == true-> 2
            true -> 1
        end
        
    end
    
    #functions getSuit(), displayOne(), display() are to display the
    # winning hand
    def getSuit(num) do
        range1 = 1..13
        range2 = 14..26
        range3 = 27..39
        range4 = 40..52
        cond do 
            num in range1 ->"C"
            num in range2 -> "D"
            num in range3 -> "H"
            num in range4 -> "S"
        end
    end

    def displayOne(num) do
        r = rem(num,13)
        case r do
            0 -> "13" <> getSuit(num)
            _ -> to_string(r) <> getSuit(num)
        end
    end
    
    def display(hand) do

        list = Enum.sort(hand, &(rem(&1,13) <= rem(&2,13)))
        case Enum.at(list,0) do
            0 -> Enum.map(tl(list) ++ [0], fn n -> displayOne(n) end)
            13 -> Enum.map(tl(list) ++ [13], fn n -> displayOne(n) end)
            26 -> Enum.map(tl(list) ++ [26], fn n -> displayOne(n) end)
            39 -> Enum.map(tl(list) ++ [39], fn n -> displayOne(n) end)
            52 -> Enum.map(tl(list) ++ [52], fn n -> displayOne(n) end)
            _ -> Enum.map(list, fn n -> displayOne(n) end)
        end
       
    end

    def straight?([1,2,3,4,5]) do
        true
    end
    def straight?([0,9,10,11,12]) do
        true
    end
    def straight?([0,1,10,11,12])do
        true
    end
    def straight?(hand) when length(hand) > 1 do
        (hd hand) == (hd (tl hand)) - 1 and straight?(tl hand)
    end
    def straight?([_]) do
        true
    end

    def royalFlush?(hand)do
        case hand do
            [1,10,11,12,13] -> true
            [27,36,37,38,39] -> true
            [14,23,24,25,26] -> true
            [40,49,50,51,52] -> true
            _ -> false
        end
    end

    def straightFlush?(hand)do
        not royalFlush?(hand) and straight?(sort(hand)) and flush?(hand)
    end
    def fourOfAKind?(hand) do
        length(quad(hand)) > 0
    end
    def fullHouse?(hand) do
        (length(triple(hand)) > 0) and (length(double(hand)) > 0)
    end
    def threeOfAKind?(hand) do
        length(triple(hand)) > 0
    end
    def twoPair?(hand) do
        length(double(hand))  == 2
    end
    def pair?(hand) do
        length(double(hand))  == 1
    end
    def double(hand) do
        remSort(hand) |> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
    end
    
    def triple(hand) do
        remSort(hand)|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
    end
    
    def quad(hand) do
        remSort(hand)|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
    end
    def flush?(hand) do
        range1 = 1..13
        range2 = 14..26
        range3 = 27..39
        range4 = 40..52
        Enum.all?(hand, fn num -> Enum.member?(range1,num) end) ||
        Enum.all?(hand, fn num -> Enum.member?(range2,num) end) ||
        Enum.all?(hand, fn num -> Enum.member?(range3,num) end) ||
        Enum.all?(hand, fn num -> Enum.member?(range4,num) end)
        
        
    end

    

    #compare 2 royal-flush hands:
    def compare10(hand1,hand2) do
        x = Enum.at(hand1,0)
        y = Enum.at(hand2,0)
        cond do
            x > y -> hand1
            y > x -> hand2
        end
    end
    #compare 2 hands with 4 of a kinds:
    def compare8(hand1,hand2) do
        
        x = remSort(hand1)|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        y = remSort(hand2)|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        case compare1Card(x,y) do
            :left -> hand1
            :right -> hand2
        end
    end
    
    
    #tie breaking for 2 full house hands or three of a kinds
    def compare7(hand1,hand2) do
        t1 = remSort(hand1) |> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        t2 = remSort(hand2) |> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        case compare1Card(t1,t2) do
            :left -> hand1
            :right -> hand2
        end
    end

    
    #compare 2 straight or straightflush hands
    def compare5(hand1,hand2) do
        c1 = highestC(remSort(hand1))
        c2 = highestC(remSort(hand2))
        
        case compare1Card(c1,c2) do
            :left -> hand1
            :right -> hand2
            :equal -> compareSuit(c1,hand1,hand2)
        end   
    end
    
    
    #tie breaking flush cards
    def compare6(hand1,hand2) do
        ls1 = remSort(hand1)
        ls2 = remSort(hand2)
        h11 = highestC(ls1)
        h21 = highestC(ls2)
        h12 = highestC(ls1 -- [h11])
        h22 = highestC(ls2 -- [h21])
        h13 = highestC(ls1 -- [h11,h12])
        h23 = highestC(ls2 -- [h21,h22])
        h14 = highestC(ls1 -- [h11,h12,h13])
        h24 = highestC(ls2 -- [h21,h22,h23])
        h15 = ls1 -- [h11,h12,h13,h14]
        h25 = ls2 -- [h21,h22,h23,h24]
        case compare1Card(h11,h21) do
            :left -> hand1
            :right -> hand2
            :equal ->  case compare1Card(h12,h22) do
                :left -> hand1 
                :right -> hand2
                :equal -> case compare1Card(h13,h23) do
                    :left -> hand1
                    :right -> hand2
                    :equal -> case compare1Card(h14,h24) do
                        :left -> hand1
                        :right -> hand2
                        :equal -> case compare1Card(h15,h25) do
                            :left -> hand1
                            :right -> hand2
                            :equal -> compareSuit(h15, hand1, hand2)
                        end
                    end
                end
            end
            
        end
    end
    
    #compare 2 hands that have the same rank 3, both have 2 pairs
    def compare3(hand1,hand2) do
        ls1 = remSort(hand1) |> Enum.group_by(&(&1)) |> Enum.filter(fn {_, [_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
        ls2 = remSort(hand2) |> Enum.group_by(&(&1)) |> Enum.filter(fn {_, [_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end)
        h11 = highestC(ls1)
        h21 = highestC(ls2)
        h12 = highestC(ls1 -- [h11])
        h22 = highestC(ls2 -- [h21])
        h13 = remSort(hand1) -- [h11,h11,h12,h12]
        h23 = remSort(hand2) -- [h21,h21,h22,h22]
        

        case compare1Card(h11,h21) do
            :left -> hand1
            :right -> hand2
            :equal ->  case compare1Card(h12,h22) do
                :left -> hand1 
                :right -> hand2
                :equal -> case compare1Card(h13,h23) do
                    :left -> hand1
                    :right -> hand2
                    :equal -> compareSuit(h13,hand1,hand2)
                end
            end
            
        end
        
    end
    #tie breaking for pair 
    def compare2(hand1, hand2) do
        ls1 = remSort(hand1)
        ls2 = remSort(hand2)
        h11 = hand1|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        h21 = hand2|> Enum.group_by(&(&1))|> Enum.filter(fn {_, [_,_]} -> true; _ -> false end)|> Enum.map(fn {x, _} -> x end) |> Enum.at(0)
        h12 = highestC(ls1 -- [h11])
        h22 = highestC(ls2 -- [h21])
        h13 = highestC(ls1 -- [h11,h12])
        h23 = highestC(ls2 -- [h21,h22])
        h14 = highestC(ls1 -- [h11,h12,h13])
        h24 = highestC(ls2 -- [h21,h22,h23])

        case compare1Card(h11,h21) do
            :left -> hand1
            :right -> hand2
            :equal ->  case compare1Card(h12,h22) do
                :left -> hand1 
                :right -> hand2
                :equal -> case compare1Card(h13,h23) do
                    :left -> hand1
                    :right -> hand2
                    :equal -> case compare1Card(h14,h24) do
                        :left -> hand1
                        :right -> hand2
                        :equal -> compareSuit(h12, hand1,hand2)
                    end
                end
            end
            
        end
    end

    #tie breaking - high cards
    def compare1(hand1,hand2) do
        ls1 = remSort(hand1)
        ls2 = remSort(hand2)
        h11 = highestC(ls1)
        h21 = highestC(ls2)
        h12 = highestC(ls1 -- [h11])
        h22 = highestC(ls2 -- [h21])
        h13 = highestC(ls1 -- [h11,h12])
        h23 = highestC(ls2 -- [h21,h22])
        h14 = highestC(ls1 -- [h11,h12,h13])
        h24 = highestC(ls2 -- [h21,h22,h23])
        h15 = ls1 -- [h11,h12,h13,h14]
        h25 = ls2 -- [h21,h22,h23,h24]
        case compare1Card(h11,h21) do
            :left -> hand1
            :right -> hand2
            :equal ->  case compare1Card(h12,h22) do
                :left -> hand1 
                :right -> hand2
                :equal -> case compare1Card(h13,h23) do
                    :left -> hand1
                    :right -> hand2
                    :equal -> case compare1Card(h14,h24) do
                        :left -> hand1
                        :right -> hand2
                        :equal -> case compare1Card(h15,h25) do
                            :left -> hand1
                            :right -> hand2
                            :equal -> compareSuit(h11, hand1, hand2)
                        end
                    end
                end
            end
            
        end
    end
    #Some supporting functions:
    def compare1Card(x1,y1) do
        cond do
            x1 == y1 -> :equal
            x1 == 1 -> :left
            y1 == 1 -> :right
            x1 == 0 -> :left
            y1 == 0 -> :right
            x1 > y1  -> :left
            y1 > x1-> :right
        end    
    end
    
    def highestC(list) do
        cond do 
            1 in list -> 1
            0 in list -> 0
            true -> Enum.at(list,length(list)-1)
        end
    end
    
    #compare suits of 2 cards have the same ranks (9C vs 9H)
    #parameter: r is the card rank or the rem(card,13)
    def compareSuit(r, hand1,hand2) do
        elem1 = Enum.find(hand1, fn x -> rem(x,13) == r end)
        elem2 = Enum.find(hand2, fn x -> rem(x,13) == r end)
        cond do 
            elem1 > elem2 -> hand1
            elem2 > elem1 -> hand2
        end
    end

    def sort(hand)do
        Enum.sort(hand)
    end
    
    # Sort the cards according as ranks excepts Ace = 1, Kings = 0 
    def remSort(hand) do
        Enum.sort(Enum.map(hand, fn num -> rem(num, 13) end))
    end
end
