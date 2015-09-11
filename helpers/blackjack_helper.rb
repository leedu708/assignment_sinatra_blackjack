module Blackjack

  def deal_cards

    session[:bet_value] = nil
    session[:cards] = ["A", 2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K"]
    session[:player] = session[:cards].sample(2)
    session[:computer] = session[:cards].sample(2)
    session[:blackjack] = (add_hand(session[:player]) == 21)

  end

  def add_hand(hand)

    hand_value = 0

    hand.each do |card|
      if [2,3,4,5,6,7,8,9,10].include?(card)
        hand_value += card
      elsif ["J","Q","K"].include?(card)
        hand_value += 10
      end
    end

    # need separate logic for "A". all other cards must be added first otherwise an early "A" can sometimes wrongfully have a value of 11
    hand.each do|card|
      if card == "A"
        if hand_value + 11 > 21
          hand_value += 1
        else
          hand_value += 11
        end
      end
    end

    # return the sum
    hand_value

  end

  def make_play

    session[:bet_value] = params[:bet_choice].to_i if session[:bet_value] == nil
    result = "win"

    unless session[:blackjack]

      result = ""
      # if player hits and computer hand is less than or equal to 16, give both player and computer a card
      if params[:play] == "hit" && add_hand(session[:computer]) <= 16

        session[:player] << session[:cards].sample
        session[:computer] << session[:cards].sample
        result = check_bust(session[:player])

      # if player hits and computer hand is greater than 16, give only the player a card
      elsif params[:play] == "hit" && add_hand(session[:computer]) > 16

        session[:player] << session[:cards].sample
        result = check_bust(session[:player])

      # if player stands and computer hand is less than or equal to 16, give computer cards until hand is greater than 16
      elsif params[:play] == "stand" && add_hand(session[:computer]) <= 16

        until add_hand(session[:computer]) > 16

          session[:computer] << session[:cards].sample

        end

        result = check_win(add_hand(session[:computer]), add_hand(session[:player]))

      # if player stands and computer hand is greater than 16, check who wins
      elsif params[:play] == "stand" && add_hand(session[:computer]) > 16

        result = check_win(add_hand(session[:computer]), add_hand(session[:player]))

      end

    end
    
    calc_money(result)
    result = "out-of-money" if session[:money] <= 0
    result

  end

  def calc_money(result)

    session[:money] -= session[:bet_value] if result == "loss" || result == "bust"
    session[:money] += session[:bet_value] if result == "win"
    session[:money] += (session[:bet_value] / 2) if session[:blackjack]
    
    session[:money]

  end

  def check_win(computer, player)

    if computer > 21
      return "win"
    elsif computer < player
      return "win"
    elsif computer == player
      return "push"
    end

    return "loss"

  end

  def check_bust(player_hand)

    if add_hand(player_hand) > 21
      return "bust"
    else
      return ""
    end

  end

end
