module Main where

import Network.Socket
import Control.Monad (forever)
import qualified Network.Socket.ByteString as B
import qualified Data.ByteString.Char8 as P
import Control.Concurrent

port = 5554
client = "192.168.1.2"
target = "192.168.1.1"

test = P.pack "1000"


main = withSocketsDo $ do
        (serveraddr:_) <- getAddrInfo Nothing (Just "192.168.1.1") (Just "5554")
        (serveraddr2:_) <- getAddrInfo Nothing (Just "192.168.1.1") (Just "5556")
        s <- socket (addrFamily serveraddr) Datagram defaultProtocol
                --bindSocket s (addrAddress serveraddr)
        s2 <- socket (addrFamily serveraddr2) Datagram defaultProtocol
        connect s (addrAddress serveraddr) 
        connect s2 (addrAddress serveraddr2)
        {-hostAddr <- inet_addr target
        clientAddr <- inet_addr client
        s <- socket AF_INET Datagram defaultProtocol
        bindSocket s (SockAddrInet 5554 iNADDR_ANY)
        s2 <- socket AF_INET Datagram defaultProtocol
        bindSocket s2 (SockAddrInet 5556 iNADDR_ANY)
        sport <- socketPort s
        putStrLn (show sport)-}
        {-bindAddr <- inet_addr client
        hostAddr <- inet_addr target
        bindSocket s (SockAddrInet 5554 bindAddr)
        B.sendTo s test (SockAddrInet port hostAddr) -}
        --hostAddr <- inet_addr target
        --sendTo s "AT*REF=0,0.AT*PCMD=1,0,0,0,0\r" (SockAddrInet 5556 hostAddr) 
        --sendTo s "AT*CONFIG=\"general:navdata_demo\",\"TRUE\"\r" (SockAddrInet 5556 hostAddr) 
        --sendTo s "AT*PCMD=1,0,0,0,0,0\rAT*REF=1,0\r" (SockAddrInet 5556 hostAddr)
        
       -- sendTo s "AT*CTRL=0\r" (SockAddrInet port hostAddr) 
        --sendTo s "AT*CTRL=0\r" (SockAddrInet port hostAddr) 
        --sendTo s "AT*CTRL=0" (SockAddrInet port hostAddr) 
        send s "\r" 
        --send s2 "AT*REF=0,0\rAT*PCMD=1,0,0,0,0,0\r" 
        send s2 "AT*CONFIG_IDS=1,\"0\",\"0\",\"0\"\r"
        send s2 "AT*CONFIG=0,\"general:navdata_demo\",\"TRUE\"\r" 
        threadDelay 100
        send s2 "AT*CTRL=0\r" 
        --send s2 "AT*COMWDG=1\r"
        --send s2 test


        --(msg, _, _) <- recvFrom s 1024
        --putStrLn msg
        forever $ do
               --B.sendTo s test (SockAddrInet port hostAddr) 
               
               --msg <- getLine
                               
               --putStrLn msg
               --sendTo s "AT*CONFIG=1,\"general:navdata_demo\",\"TRUE\"\r" (SockAddrInet 5556 hostAddr)
              
               --msg <- getLine
               --sendTo s msg (SockAddrInet port hostAddr) 
               --msg' <- recv s 1024
               --putStrLn msg'
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
