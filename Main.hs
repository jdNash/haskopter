module Main(main) where

import Network
import IO
import Control.Concurrent

main :: IO ()
main = withSocketsDo $ -- For windows compatibility
    do
        handle <- connectTo "localhost" (PortNumber 2048)
        input <- getContents
        sequence_ $ map (\a -> do
            hPutStr handle $ a ++ "\n"
            hFlush handle) $ lines input
        hClose handle

        