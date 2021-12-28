require_relative 'colors'

class GameBoard
  include Colors

  def initialize
    @board = Array.new(10) { Array.new(4) }
    @board.map.with_index do |val, row|
      val.each_index { |col| @board[row][col] = "#{GRAY_BACK}  \e[0m  " }
    end
    @visual = Array.new(4, "#{GRAY_BACK}  \e[0m  ")
  end

  def update_board
    @board.map.with_index do |val, row|
      result = ''
      val.each_index do |col|
        result += @board[row][col]
      end
      system "echo '#{result}'"
      puts "\n"
    end
  end

  def reset_visual
    (0..3).each { |val| @visual[val] = "#{GRAY_BACK}  \e[0m  " }
  end

  def add_guess(choice, turn)
    turn = 10 - turn
    @board[turn].each_index do |col|
      @board[turn][col] = choice[col]
    end
  end

  def print_guess(result, turn)
    turn = 10 - turn
    @board[turn].push(result)
  end

  def answer_white(guess, result, dup)
    guess.each do |val|
      if @code.include?(val) && dup.none?(val)
        dup.push(val)
        result += "▊ \e[0m"
      end
    end
    result
  end

  def answer_red(guess)
    dup = []
    result = ''
    guess.map.with_index do |val, dex|
      if val == @code[dex]
        dup.push(val)
        result += "#{RED}▊ \e[0m"
      end
    end
    [result, dup]
  end

  def show_key
    result = ''
    key = []
    COLOR_BACK_ARRAY.each do |val|
      result += "#{val}  \e[0m  "
      key.push("#{val}  \e[0m  ")
    end
    key
  end

  def get_choice(result = '', num = 1)
    keyd = show_key
    keyd.each do |val|
      result += "#{num} - #{val}"
      num += 1
    end
    system "echo '#{result}'"
    puts 'Choose a color (1 - 6):'
    gets.chomp
  end

  def check_choice(choice)
    check_choice(get_choice) unless (1..6).include?(Integer(choice)) rescue check_choice(get_choice)
    choice
  end

  def guess(turn)
    result = ''
    (0..3).each { |num| result += @visual[num] }
    system "echo '#{result}\n'"
    choice = check_choice(get_choice)
    @visual[turn - 1] = "#{COLOR_BACK_ARRAY[Integer(choice) - 1]}  \e[0m  "
    @visual
  end

  def code
    @code = Array.new(4)
    @code.each_index do |dex|
      @code[dex] = "#{COLOR_BACK_ARRAY[rand(0..5)]}  \e[0m  "
    end
    @code
  end

  def show_code(visible)
    result = ''
    @code.each_index { |dex| result += @code[dex] } if visible == true
    @code.each { result += "#{DARK_BACK}??\e[0m  " } if visible == false
    system "echo '#{result}'"
    puts "\n"
  end
end
