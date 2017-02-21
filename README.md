# Ruby Game of Life

This is a simple implementation of [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) 
using Ruby.
It's a fun project for comparison with another 
[implementation in Scala with Akka](https://github.com/christian-schlichtherle/akka-game-of-life).

## How to Use

For simulating a random pattern of cells on a board with 80 rows and 240 columns:

    ruby game-of-life.rb 80 240
    
To stop the program, signal TERM, usually by pressing Ctrl-C - the actual character depends on your terminal 
settings.

To simulate a simple test pattern of blinkers, use:

    ruby game-of-life.rb 80 240 blinkers
