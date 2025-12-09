main :: IO ()
main = do
    contents <- readFile "input"
    let blocks = splitOnDoubleNewLines contents
    let rawRanges = (blocks !! 0)
    let rangeLines = lines rawRanges
    let ranges = map splitRange rangeLines

    let rawQueries = (blocks !! 1)
    let queryLines = lines rawQueries
    let queries :: [Integer]
        queries = map read queryLines

    let count = length (filter (\q -> matchesAnyRange q ranges) queries)
    print count

splitOnDoubleNewLines :: String -> [String]
splitOnDoubleNewLines = filter (not .null) . go []
    where
        go acc [] = [reverse acc]
        go acc ('\n':'\n':xs) = reverse acc : go [] xs
        go acc (x:xs) = go (x:acc) xs

splitRange :: String -> (Integer, Integer)
splitRange s =
    let (a, _ : b) = break (== '-') s
    in (read a, read b)

inRange :: Integer -> (Integer, Integer) -> Bool
inRange q (lo, hi) = q >=lo && q <= hi

matchesAnyRange :: Integer -> [(Integer, Integer)] -> Bool
matchesAnyRange q ranges = any (inRange q) ranges
