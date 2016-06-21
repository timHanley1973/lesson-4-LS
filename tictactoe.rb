# Exercise 1, Tic Tac Toe

require 'pry'

CHOOSE = 'choose'.freeze
INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMP_MARKER = 'O'.freeze
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def joinor(num_arr, w='or') # TTT Bonus Features 1
  num_arr[-1] = "#{w} #{num_arr.last}"
  num_arr.join(', ')
end

SQUARE_NUMBERS = joinor([1, 2, 3, 4, 5, 6, 7, 8, 9])

def prompt(message)
  puts "=> #{message}"
end

def who_goes_first #                <-----------------Here's the method to give the user the option to go first or not.
  prompt "Would you like to go first? (y or n)"
  turn = gets.chomp
  if turn.downcase.start_with?('y')
    return PLAYER_MARKER
  else
    return COMP_MARKER
  end
end

def display_board(brd)
  system 'clear'

  game_board = <<-GB
PLAYER IS #{PLAYER_MARKER}. COMPUTER IS #{COMP_MARKER}.
   SHOW COMPUTER WHAT YOU GOT!

        |     |
     #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}
        |     |
   -----+-----+-----
        |     |
     #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}
        |     |
   -----+-----+-----
        |     |
     #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}
        |     |

  GB

  prompt(game_board)
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def detect_threat(line, board, _marker)
  if board.values_at(*line).count(PLAYER_MARKER) == 2
    board.select { |brd, square_num| line.include?(brd) && square_num == INITIAL_MARKER }.keys.first
  end
end

def computer_places_piece!(brd)
  square = nil

  if !square
    WINNING_LINES.each do |line|
      square = detect_threat(line, brd, COMP_MARKER)
      break if square
    end

    WINNING_LINES.each do |line|
      square = detect_threat(line, brd, PLAYER_MARKER)
      break if square
    end
  end

  if !square
    square = if brd[5] == ' '
               5
             else
               empty_squares(brd).sample
             end
  end

  brd[square] = COMP_MARKER
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square #{SQUARE_NUMBERS}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "That is not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMP_MARKER) == 3
      return 'Comp'
    end
  end
  nil
end

def alternate_player(current_player)
  if current_player == PLAYER_MARKER
    return COMP_MARKER
  else
    return PLAYER_MARKER
  end
end

keep_score = []
loop do
  board = initialize_board

  first = PLAYER_MARKER
  if CHOOSE == 'choose'
    first = who_goes_first
  end
  turn_manager = 0

  loop do
    display_board(board)
    if first == PLAYER_MARKER
      player_places_piece!(board)
    else
      computer_places_piece!(board)
    end
    break if someone_won?(board) || board_full?(board)
    first = alternate_player(first)

    turn_manager += 1
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "Tie game."
  end

  if detect_winner(board) == 'Player' # <------- I wrote the scorekeeping code write into the loop using an array.
    keep_score << 'p'
  elsif detect_winner(board) == 'Comp'
    keep_score << 'c'
  end

  if keep_score.count('p') == 5
    p "Player wins the round!"
    keep_score = []
  elsif keep_score.count('c') == 5
    p "Computer wins the round!"
    keep_score = []
  end

  prompt "Would you like to play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "'A strange game. The only winning move is not to play. How about a nice game of chess?' -- Joshua"
