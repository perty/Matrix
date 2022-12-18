module Matrix exposing
    ( Matrix
    , empty, initialize, repeat
    , size, get, neighbours
    , set
    , map, indexedMap
    , foldl, getCol, getRow
    )

{-| Two-dimensional matrix backed by Array from the Elm core, the fast immutable array
implementation.


# Definition

@docs Matrix


# Creation

@docs empty, initialize, repeat


# Query

@docs size, get, getXs, getYs, neighbours


# Manipulate

@docs set


# Transform

@docs map, indexedMap

-}

import Array exposing (Array)


{-| Representation of immutable, two dimensional matrix. You can create a matrix of integers
(`Matrix Int`) or strings (`Matrix String`) or any other type of value you can dream up.
-}
type alias Matrix a =
    Array (Array a)


{-| Return an empty matrix.

    size empty == ( 0, 0 )

-}
empty : Matrix a
empty =
    Array.empty


{-| Return the size of a matrix in the form of a tuple, (rows, cols).
-}
size : Matrix a -> ( Int, Int )
size matrix =
    let
        rows =
            Array.length matrix

        cols =
            case Array.get 0 matrix of
                Just aCol ->
                    Array.length aCol

                Nothing ->
                    0
    in
    ( rows, cols )


{-| Initialize a matrix, given desired size and a function for the value of a cell,
given its row and col.

    Matrix.initialize 100 100 (\row col -> String.fromInt row ++ "," ++ String.fromInt col)

-}
initialize : Int -> Int -> (Int -> Int -> a) -> Matrix a
initialize rows cols fn =
    Array.initialize rows (\col -> Array.initialize cols (fn col))


{-| Initialize a matrix, given desired size and the value for every cell.

    Matrix.repeat 100 100 InitialValue

-}
repeat : Int -> Int -> a -> Matrix a
repeat rows cols value =
    Array.repeat rows (Array.repeat cols value)


{-| Set the cell at (row, col) to a new value. If the (x,y) is out of bounds, silently do nothing,
-}
set : Int -> Int -> a -> Matrix a -> Matrix a
set row col v matrix =
    case Array.get row matrix of
        Just aCol ->
            Array.set row (Array.set col v aCol) matrix

        Nothing ->
            matrix


{-| Maybe get the value of the cell at (row, col).
-}
get : Int -> Int -> Matrix a -> Maybe a
get row col matrix =
    getRow row matrix |> Array.get col


{-| Get all values along a given row as an array. If row is out of bounds, return an empty array.
-}
getRow : Int -> Matrix a -> Array a
getRow row matrix =
    Maybe.withDefault Array.empty (Array.get row matrix)


{-| Get all values along a given column as an array. If column is out of bounds, return an empty array.
-}
getCol : Int -> Matrix a -> Array a
getCol col matrix =
    Array.toList matrix |> pickColumn col |> Array.fromList


pickColumn : Int -> List (Array a) -> List a
pickColumn col arrays =
    case List.head arrays of
        Nothing ->
            []

        Just array0 ->
            case Array.get col array0 of
                Nothing ->
                    []

                Just v ->
                    case List.tail arrays of
                        Nothing ->
                            []

                        Just tail ->
                            v :: pickColumn col tail


{-| Apply a function on every element in a matrix.

    Matrix.map (\\n -> n \* 2) [ [ 0, 0, 0 ], [ 0, 1, 2 ] ] => [ [ 0, 0, 0 ], [ 0, 2, 4 ] ]

-}
map : (a -> b) -> Matrix a -> Matrix b
map function matrix =
    matrix |> Array.map (Array.map function)


{-| Apply a function on every element with its row and column as first arguments.

    Matrix.indexedMap (\\row col \_ -> (String.fromInt row + "," + String.fromInt col)(Matrix.repeat 2 3 "")
    => [[ "0,0", "0,1", "0,2" ],[ "1,0", "1,1", "1,2" ] ]

-}
indexedMap : (Int -> Int -> a -> b) -> Matrix a -> Matrix b
indexedMap function matrix =
    matrix |> Array.indexedMap (\row array -> Array.indexedMap (function row) array)


{-| Fold left on each x, then merge the accumulated results.
-}
foldl : (a -> b -> b) -> b -> (b -> b -> b) -> Matrix a -> b
foldl function acc merge matrix =
    Array.foldl (\ma a -> Array.foldl function acc ma |> merge a) acc matrix


{-| Return an array of possible neighbour cells for a given cell.
It is an array of Maybe, compare the get function that is a single Maybe.
-}
neighbours : Matrix a -> Int -> Int -> Array.Array (Maybe a)
neighbours matrix row col =
    let
        neighbourCoords : Array.Array ( Int, Int )
        neighbourCoords =
            [ ( row - 1, col - 1 )
            , ( row - 1, col )
            , ( row - 1, col + 1 )
            , ( row, col - 1 )
            , ( row, col + 1 )
            , ( row + 1, col - 1 )
            , ( row + 1, col )
            , ( row + 1, col + 1 )
            ]
                |> Array.fromList
    in
    Array.map (\( r, c ) -> get r c matrix) neighbourCoords
