require_relative 'game_board'

game = GameBoard.new
game.code
visual = []

def clear
  system 'clear'
  system "echo '                                           \e[1;34m MASTERMIND\e[0m'"
  system "echo '                           Try to guess the code, you have ten guesses'"
  system "echo '                   \e[1;31m Red\e[0m peg means you have a correct color in a correct place,'"
  system "echo '                  \e[1;37m White\e[0m peg means you have a correct color in the wrong place'"
end

def check_loss(turn)
  if turn == 10
    game.show_code(true)
    puts 'you lost'
  end
end

(1..10).each do |turn|
  game.reset_visual
  (1..4).each do |count|
    clear
    game.update_board
    game.show_code(false)
    visual = game.guess(count)
  end

  result = ''
  (0..3).each { |num| result += visual[num] }
  system "echo '#{result}\n'"

  clear
  game.add_guess(visual, turn)
  result, dup = game.answer_red(visual)
  if dup.length == 4
    game.print_guess("winner!! It took you #{turn} turns to get here", turn)
    game.update_board
    game.show_code(true)
    break
  else
    game.print_guess(game.answer_white(visual, result, dup), turn)
  end

  game.update_board
  game.show_code(false)
  check_loss(turn)
end
