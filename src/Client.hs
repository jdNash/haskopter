module Main where

import Network.Socket
import System.IO
import Control.Monad (forever, liftM)
import Control.Monad.Loops (whileM_)

port = 5556
navport = 5554
host = "192.168.1.1"

{-

Todo
Bind two ports, control and data
send 1 byte, send empty pac
continue sending
send two true commands to true data



-}

main = withSocketsDo $ do
        s <- socket AF_INET Datagram defaultProtocol
        hostAddr <- inet_addr host
        --bindAddr <- inet_addr "127.0.0.1"
        --bindSocket s (SockAddrInet 5556 bindAddr)
        sendTo s "AT*CONFIG=1,\"control:altitude_max\",\"2000\"" (SockAddrInet port hostAddr)
        sendTo s "AT*CONFIG=1,\"control:altitude_max\",\"2000\"" (SockAddrInet port hostAddr)  
        forever $ do
                msg <- getLine
                case msg of 
                    "d" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*REF=102,290717696\r" s hostAddr
                            putStrLn "Loop ended"
                           -- sendTo s "AT*REF=102,290717696\r" (SockAddrInet port hostAddr)
                           -- sendTo s "AT*REF=102,290717696\r" (SockAddrInet port hostAddr) 
                    "u" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*REF=101,290718208\r" s hostAddr
                            putStrLn "Loop ended"
                           -- sendTo s "AT*REF=101,290718208\r" (SockAddrInet port hostAddr) 
                           -- sendTo s "AT*REF=101,290718208\r" (SockAddrInet port hostAddr)
                    "h" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=201,1,0,0,0,0\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=201,1,0,0,0,0\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=201,1,0,0,0,0\r" (SockAddrInet port hostAddr)
                    "gh" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=301,1,0,0,1036831949,0\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=301,1,0,0,1036831949,0\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=301,1,0,0,1036831949,0\r" (SockAddrInet port hostAddr)
                    "gf" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=302,1,0,0,-1110651699,0\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=302,1,0,0,-1110651699,0\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=302,1,0,0,-1110651699,0\r" (SockAddrInet port hostAddr)
                    "p[" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=303,1,1036831949,0,0,0\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=303,1,1036831949,0,0,0\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=303,1,1036831949,0,0,0\r" (SockAddrInet port hostAddr)
                    "po" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=304,1,-1110651699,0,0,0\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=304,1,-1110651699,0,0,0\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=304,1,-1110651699,0,0,0\r" (SockAddrInet port hostAddr)
                    "yu" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=305,1,0,0,0,1056964608\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=305,1,0,0,0,1036831949\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=305,1,0,0,0,1036831949\r" (SockAddrInet port hostAddr)
                    "yt" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=306,1,0,0,0,-3204448256\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=306,1,0,0,0,-1110651699\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=306,1,0,0,0,-1110651699\r" (SockAddrInet port hostAddr)
                    "rt" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=307,1,0,1036831949,0,0\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=307,1,0,1036831949,0,0\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=307,1,0,1036831949,0,0\r" (SockAddrIputStrLn "Loop ended"net port hostAddr)
                    "re" -> do
                            putStrLn $ "did: " ++ msg
                            arAction "AT*PCMD=308,1,0,-1110651699,0,0\r" s hostAddr
                            putStrLn "Loop ended"
                            --sendTo s "AT*PCMD=308,1,0,-1110651699,0,0\r" (SockAddrInet port hostAddr) 
                            --sendTo s "AT*PCMD=308,1,0,-1110651699,0,0\r" (SockAddrInet port hostAddr)
                    otherwise -> do
                                putStrLn $ "did: " ++ msg
                                
               -- msg' <- recv s 1024
                --putStrLn msg'
        sClose s
        return ()

arAction msg s hostAddr = whileM_ (liftM not $ hReady stdin) $ do
                        sendTo s msg (SockAddrInet port hostAddr)
                        sendTo s msg (SockAddrInet port hostAddr)

{-port = "5554"

main = withSocketsDo $ bracket getSocket sClose talk
        where getSocket = do
                (serveraddr:_) <- getAddrInfo Nothing (Just "127.0.1.1") (Just port)
                s <- socket (addrFamily serveraddr) Datagram defaultProtocol
                --bindSocket s (addrAddress serveraddr)
                connect s (addrAddress serveraddr) >> return s
              talk s = do
                send s "AT*CONFIG=1,\"control:altitude_max\",\"2000\""
                send s "AT*REF=101,290718208\r"
                recv s 1024 >>= \msg -> putStrLn $ "Received " ++ msg-}
{-
    do
        handle <- connectTo "localhost" (PortNumber 5556)
        input <- getContents
        sequence_ $ map (\a -> do
            hPutStr handle $ a ++ "\n"
            hFlush handle) $ lines input
        hClose handle
-}
