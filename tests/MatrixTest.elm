module MatrixTest exposing (suite)

import Array
import Expect
import Matrix
import Test exposing (Test, describe, test)


threeByThree : Matrix.Matrix String
threeByThree =
    Matrix.initialize 3 3 initFn


tenBy15 : Matrix.Matrix String
tenBy15 =
    Matrix.initialize 10 15 initFn


twoByThree : Matrix.Matrix String
twoByThree =
    Matrix.initialize 2 3 initFn


twoByThreeInt : Matrix.Matrix Int
twoByThreeInt =
    Matrix.initialize 2 3 initFnInt


initFn : Int -> Int -> String
initFn r c =
    "(" ++ String.fromInt r ++ "," ++ String.fromInt c ++ ")"


initFnInt : Int -> Int -> Int
initFnInt r c =
    r * c


suite : Test
suite =
    describe "Matrix suite"
        [ describe "Test Matrix get function"
            [ test "get from empty Matrix will return Nothing" <|
                \() -> Expect.equal Nothing (Matrix.get 0 0 Matrix.empty)
            , test "get where the cell exists" <|
                \() -> Expect.equal (Just "(2,1)") (Matrix.get 2 1 threeByThree)
            , test "get where the cell does not exists" <|
                \() -> Expect.equal Nothing (Matrix.get 3 99 threeByThree)
            ]
        , describe "Test Matrix set function"
            [ test "Insert into empty matrix is empty" <|
                \() -> Expect.equal Matrix.empty (Matrix.set 0 0 42 Matrix.empty)
            , test "Insert correctly and get" <|
                \() -> Expect.equal (Just "X") (Matrix.get 1 2 (Matrix.set 1 2 "X" threeByThree))
            ]
        , describe "Test Matrix size function"
            [ test "Empty matrix" <|
                \() -> Expect.equal ( 0, 0 ) (Matrix.size Matrix.empty)
            , test "Three by three matrix" <|
                \() -> Expect.equal ( 3, 3 ) (Matrix.size threeByThree)
            , test "Ten by 15 matrix" <|
                \() -> Expect.equal ( 10, 15 ) (Matrix.size tenBy15)
            ]
        , describe "Test to get all the X values"
            [ test "A (2,3) sized" <|
                \() -> Expect.equal [ "(1,0)", "(1,1)", "(1,2)" ] (Array.toList (Matrix.getRow 1 twoByThree))
            , test "Of limits is empty" <|
                \() -> Expect.equal Array.empty (Matrix.getRow 999 threeByThree)
            ]
        , describe "Test to get all the Y values"
            [ test "A (2,3) sized" <|
                \() -> Expect.equal [ "(0,2)", "(1,2)" ] (Array.toList (Matrix.getCol 2 twoByThree))
            , test "Of limits is empty" <|
                \() -> Expect.equal Array.empty (Matrix.getCol 999 threeByThree)
            ]
        , describe "Map function"
            [ test "Double contents" <|
                \() -> Expect.equal (Array.fromList [ Array.fromList [ 0, 0, 0 ], Array.fromList [ 0, 2, 4 ] ]) (Matrix.map (\n -> n * 2) twoByThreeInt)
            ]
        , describe "IndexedMap function"
            [ test "Contents depending on x, y" <|
                \() ->
                    Expect.equal (Array.fromList [ Array.fromList [ "0(0,0)0", "0(0,1)1", "0(0,2)2" ], Array.fromList [ "1(1,0)0", "1(1,1)1", "1(1,2)2" ] ])
                        (Matrix.indexedMap indexedConvert twoByThree)
            ]
        , describe "Fold"
            [ test "Fold left on a 3x3 matrix where contents are row + col and we accumulate the sum of all cells." <|
                \_ ->
                    let
                        m =
                            Matrix.initialize 3 3 (\row col -> row + col)
                    in
                    Matrix.foldl (\c a -> a + c) 0 (+) m
                        |> Expect.equal 18
            ]
        , describe "Initialize with repeat"
            [ test "Zero initialize" <|
                \() -> Expect.equal (Array.fromList [ Array.fromList [ 0, 0, 0 ], Array.fromList [ 0, 0, 0 ] ]) (Matrix.repeat 2 3 0)
            ]
        , describe "Neighbours, gotta love them."
            [ test "Neighbours of a cell" <|
                \() ->
                    Expect.equal (Array.fromList [ Just "(0,1)", Just "(0,2)", Nothing, Just "(1,1)", Nothing, Nothing, Nothing, Nothing ])
                        (Matrix.neighbours twoByThree 1 2)
            ]
        ]


indexedConvert : Int -> Int -> String -> String
indexedConvert row col value =
    String.fromInt row ++ value ++ String.fromInt col
