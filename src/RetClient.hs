module Main where

import Network.Socket
import Control.Monad (forever)

port = 5554
host = "192.168.1.1"


main = withSocketsDo $ do
        s <- socket AF_INET Datagram defaultProtocol
        hostAddr <- inet_addr host
        sendTo s "AT*CONFIG=\"general:navdata_demo\",\"TRUE\"\\r" (SockAddrInet port hostAddr) 
        sendTo s "AT*CONFIG=\"general:navdata_demo\",\"TRUE\"\\r" (SockAddrInet port hostAddr) 
        forever $ do
               -- msg <- getLine
               -- sendTo s msg (SockAddrInet port hostAddr) 
                msg' <- recv s 1024
                putStrLn msg'
        sClose s
        return ()
{-
main = withSocketsDo $ bracket getSocket sClose handler
        where getSocket = do
                (serveraddr:_) <- getAddrInfo Nothing (Just "127.0.1.1") (Just port)
                s <- socket (addrFamily serveraddr) Datagram defaultProtocol
                --bindSocket s (addrAddress serveraddr)
                connect s (addrAddress serveraddr) >> return s
              handler conn = do
                send s "AT*CONFIG=\"general:navdata_demo\",\"TRUE\"\\r"
                sport <- socketPort conn
                (msg,n,d) <- recvFrom conn 1024
                putStrLn $ "< " ++ msg ++ "from " ++ (show sport)
-}
{-
    do
        handle <- connectTo "localhost" (PortNumber 5556)
        input <- getContents
        sequence_ $ map (\a -> do
            hPutStr handle $ a ++ "\n"
            hFlush handle) $ lines input
        hClose handle
-}
