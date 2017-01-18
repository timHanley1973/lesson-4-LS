# The answer to question 2 in Twenty-One Bonus Features:

# The first two calls of the play_again? method are based on absolutes whereas the final call
# requires additional logic for the comparison step.

hearts = "\u2665"
spades = "\u2660"
clubs = "\u2663"
diamonds = "\u2666"

HEARTS = hearts.encode('utf-8')
SPADES = spades.encode('utf-8')
CLUBS = clubs.encode('utf-8')
DIAMONDS = diamonds.encode('utf-8')

SUITS = [HEARTS, SPADES, CLUBS, DIAMONDS].freeze
VALUES = %w(A 2 3 4 5 6 7 8 9 10 J Q K).freeze

def prompt(msg)
  puts "~~~~~~> #{msg}"
end

def init_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0
             10
           else
             value.to_i
           end
  end

  values.count { |value| value == "A" }.times do
    sum -= 10 if sum > 21
  end

  sum
end

def bust?(cards)
  total(cards) > 21
end


def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end



def display_result(dealer_cards, player_cards, dealer_total, player_total)
  puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}."
  prompt "You have #{player_cards}, for a total of: #{player_total}."
  puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  result = detect_result(dealer_cards, player_cards)

  case result
  when :player_busted
    :dealer
    prompt "Busted! Dealer wins!"
  when :dealer_busted
    :player
    prompt "Dealer bust! You win!"
  when :player
    :player
    prompt "Victory!"
  when :dealer
    :dealer
    prompt "You lose!"
  when :tie
    :tie
    prompt "Tie game."
  end
end

def play_again?
  puts "------------------------------"
  prompt "Play again?"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

player_counter = 0
dealer_counter = 0

loop do
  if dealer_counter == 5
    player_counter = dealer_counter = 0
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "           DEALER WINS THE                 "
    puts "             TOURNAMENT!                   "
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"

  elsif player_counter == 5

    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    puts "             YOU WON THE                   "
    puts "             TOURNAMENT!                   "
    puts "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    player_counter = dealer_counter = 0

  end
  prompt "LET'S PLAY TWENTY-ONE!!!!!"
  deck = init_deck #  <----- Shuffles deck, initializes dealer/player hands
  player_cards = []
  dealer_cards = []

  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  prompt "TOURNAMENT SCORE: DEALER  #{dealer_counter}  PLAYER  #{player_counter}"
  prompt "Dealer has #{dealer_cards[0]} showing."
  prompt "You have #{player_cards[0]} and #{player_cards[1]} showing.
                       YOUR SCORE: #{total(player_cards)}"

  # player turn:
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)
  loop do
    player_turn = nil
    loop do
      prompt "(h)it or (s)tay?"
      player_turn = gets.chomp.downcase
      break if %w(h s).include?(player_turn)
      prompt "Enter 'h' or 's'."
    end

    if player_turn == 'h'
      player_cards << deck.pop
      player_total = total(player_cards)
      hit_prompt = <<-HITMSG
      You chose to hit.
      Your cards are now #{player_cards}.
      Your total is now #{player_total}.
      HITMSG
      prompt(hit_prompt)
    end

    break if player_turn == 's' || bust?(player_cards)
  end

  if bust?(player_cards)
    display_result(dealer_cards, player_cards, dealer_total, player_total)
    result = detect_result(dealer_cards, player_cards)
    if result == :dealer || result == :player_busted
      dealer_counter += 1
    elsif result == :player || result == :dealer_busted
      player_counter += 1
   end
    # dealer_win
    play_again? ? next : break
  else
    prompt "You stayed at #{player_total}"
  end

  # dealer turn
  prompt "Dealer turn:"
  loop do
    break if bust?(dealer_cards) || dealer_total >= 17
    prompt "Dealer hits."
    dealer_cards << deck.pop
    dealer_total = total(dealer_cards)
    prompt "Dealer now showing #{dealer_cards}."
  end

  if bust?(dealer_cards)
    prompt "Dealer shows #{dealer_total}."
    display_result(dealer_cards, player_cards, dealer_total, player_total)
    result = detect_result(dealer_cards, player_cards)
    prompt "2 result #{result}"

    if result == :dealer || result == :player_busted
      dealer_counter += 1
    elsif result == :player || result == :dealer_busted
      player_counter += 1
    end

    play_again? ? next : break
  else
    prompt "Dealer stays at #{dealer_total}."
  end

  break unless play_again?
end

prompt "PEACE OUT!!!!!"
