#!/usr/bin/env ruby

module GameOfLife

  def GameOfLife.blinkers(row, column)
    row % 4 == 1 && column % 4 < 3
  end

  def GameOfLife.random(_, _)
    rand(2) == 1
  end

  class Game

    attr_reader :rows, :columns

    def initialize(rows, columns, &init)
      @rows = rows
      @columns = columns
      @init = init ? init : GameOfLife.method(:random)
    end

    def run
      board = Board.new(@rows, @columns)
      0.upto @rows - 1 do |row|
        0.upto @columns - 1 do |column|
          board[row, column] = @init.call(row, column)
        end
      end
      new_board = Board.new(@rows, @columns)
      while true
        $stdout.write board.to_s
        $stdout.flush
        0.upto @rows - 1 do |row|
          0.upto @columns - 1 do |column|
            new_board[row, column] = board[row, column]
          end
        end
        old_board = board
        board = new_board
        new_board = old_board
      end
    end
  end

  private

  class Board

    attr_reader :rows, :columns

    def initialize(rows, columns)
      @rows = rows
      @columns = columns
      @grid = Grid.new(rows, columns)
    end

    def [](row, column)
      @grid[row, column].next_state
    end

    def []=(row, column, alive)
      @grid[row, column].set_state(@grid, row, column, alive)
    end

    def to_s
      s = "\n+" << '-' * @columns << "+\n"
      0.upto @rows - 1 do |row|
        s << '|'
        0.upto @columns - 1 do |column|
          s << (@grid[row, column].alive ? 'O' : ' ')
        end
        s << "|\n"
      end
      s << '+' << '-' * @columns << '+'
    end
  end

  class Grid

    attr_reader :rows, :columns

    def initialize(rows, columns)
      @rows = rows
      @columns = columns
      @cells = Array.new(rows * columns)
      0.upto rows - 1 do |row|
        0.upto columns - 1 do |column|
          self[row, column] = Cell.new
        end
      end
    end

    def [](row, column)
      @cells[index(row, column)]
    end

    def []=(row, column, value)
      @cells[index(row, column)] = value
    end

    private

    def index(row, column)
      row * @columns + column
    end
  end

  class Cell

    attr_reader :alive

    def initialize
      @alive = false
      @neighbors = 0
    end

    def set_state(buffer, row, column, alive)
      if @alive != alive
        @alive = alive
        rows = buffer.rows
        columns = buffer.columns
        -1.upto 1 do |rowOffset|
          -1.upto 1 do |columnOffset|
            if rowOffset != 0 || columnOffset != 0
              neighbor_row = (rows + row + rowOffset) % rows
              neighbor_column = (columns + column + columnOffset) % columns
              buffer[neighbor_row, neighbor_column].update_neighbors(alive)
            end
          end
        end
      end
    end

    def next_state
      case @neighbors
        when 2 then @alive
        when 3 then true
        else false
      end
    end

    def update_neighbors(alive)
      if alive
        @neighbors += 1
      else
        @neighbors -= 1
      end
    end
  end
end

GameOfLife::Game.new(
    rows = $*[0].to_i,
    columns = $*[1].to_i,
    &init = $*[2] == "blinkers" ? GameOfLife.method(:blinkers) : GameOfLife.method(:random)
).run
