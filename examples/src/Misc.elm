matrixToString : Matrix.Matrix Int -> String
matrixToString matrix =
    let
        ( sx, sy ) =
            Matrix.size matrix

        xs =
            List.range 0 sx

        ys =
            List.range 0 sy
    in
    List.map (\y -> Matrix.getYs matrix y) ys
        |> List.map (\a -> Array.map String.fromInt a)
        |> List.map (\a -> Array.toList a)
        |> List.map (\l -> String.join "" l)
        |> String.join (String.fromChar '\n')
