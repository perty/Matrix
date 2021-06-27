# Example for the Matrix package

## Game of Life

Using the Matrix package and elm-ui, this examples implements the 
famous Game of Life. It demonstrates the `neighbour` and `indexedMap` functions.

In the game, each cell will survive to the next generation if it 
has 2 or 3 neighbours. An empty spot with 3 neighbour cells will give
birth to a new cell.

The popularity of the game is probably that some starting patterns
sort of come to life and either oscillate or change constantly
into new patterns.

The example therefore has a button that loads an interesting
pattern.