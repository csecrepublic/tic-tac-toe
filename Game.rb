#-----------PLAYER CLASS-----------
class Player
    attr_reader :letter, :name

    def initialize(l)
        @letter = l
        @name = "Player " + self.letter
    end

    def mark(array, row, col)
        array[row][col] = letter
    end
    
end

#-----------GAME CLASS-----------
class Game
    attr_reader :grid, :playerX, :playerO
    attr_accessor :rounds, :won, :winner
    GRID_LIMIT = 3
    
    def initialize
        @grid = Array.new(GRID_LIMIT) { Array.new(GRID_LIMIT)}
        @playerX = Player.new("X")
        @playerO = Player.new("O")
        @rounds = 0
        @won = false
        @winner = "No one"
    end

    def print_grid
        grid.each do |array|
            array.each do |item|
                print "[" + item.to_s + "]"
            end
            print "\n"
        end
    end

    def play
        loop do
            self.won = checkWinner
            if self.won
                puts "Congratulations! " + winner.name + " won!"
                break
            elsif grid.flatten.none?(nil)
                puts "Looks like no one won. Better luck next time."
                break
            end

            puts "You're on round #{rounds}. Current state of play:"
            print_grid
            
            if self.rounds%2 == 0
                playOneRound(playerX)
            else
                playOneRound(playerO)
            end

            self.rounds += 1
        end
    end

    def playOneRound(player)
        begin
            puts "#{player.name}'s turn. Enter a row:"
            row = gets.chomp.to_i
            puts "Enter a column:"
            col = gets.chomp.to_i

            if row >= GRID_LIMIT || col >= GRID_LIMIT
                raise IndexError
            elsif grid[row][col] == nil
                player.mark(grid, row, col)
            else
                puts "Oops! That spot is taken. Try again."
            end
        rescue StandardError => e
            puts "Uh-oh, We've got an error. Try again." 
            retry   
        end
    end

    def checkWinner
        checkDiagonalWinner || checkRowWinner || checkColumnWinner
    end

    def checkDiagonalWinner
        wonReturn = false

        diagonalPosX = grid[2][0] == "X" && grid[1][1] == "X" && grid[0][2] == "X"
        diagonalPosO = grid[2][0] == "O" && grid[1][1] == "O" && grid[0][2] == "O"
        diagonalNegX = grid[0][0] == "X" && grid[1][1] == "X" && grid[2][2] == "X"
        diagonalNegO = grid[0][0] == "O" && grid[1][1] == "O" && grid[2][2] == "O"

        if diagonalPosX || diagonalNegX
            self.winner = playerX
            wonReturn = true
        elsif diagonalPosO || diagonalNegO
            self.winner = playerO
            wonReturn = true
        end
        
        wonReturn
    end

    def checkRowWinner
        wonReturn = false

        grid.each do |array|
            if array.all?("X")
                self.winner = playerX
                wonReturn = true
            elsif array.all?("0")
                self.winner = playerO
                wonReturn = true
            end
        end

        wonReturn
    end

    def checkColumnWinner
        wonReturn = false

        colGrid = grid.transpose
        colGrid.each do |array|
            if array.all?("X")
                self.winner = playerX
                wonReturn = true
            elsif array.all?("0")
                self.winner = playerO
                wonReturn = true
            end
        end

        wonReturn
    end
        

end

#-----------DRIVER-----------
game = Game.new
game.play