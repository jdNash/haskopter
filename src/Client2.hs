module Main where

import Network.Socket
import System.IO
import Control.Monad (forever, liftM)
import Control.Monad.Loops (whileM_)
import qualified Network.Socket.ByteString as B
import qualified Data.ByteString as P
import Data.Word 

controlPort = 5556
navPort = 5554
droneip = "192.168.1.1"
byte = P.singleton $ (1 :: Word8)

main :: IO ()
main = withSocketsDo $ do 
        (navS, contS) <- initSockets
        -- Wait for command input 30ms
        --  timeout function
        -- no input, send holding with current n
        --  case on maybe
        -- return new n
        -- receive data
        -- pass to processing
        -- repeat
        navDataInit navS contS 
        
        sClose navS
        sClose contS
        return ()


initSockets :: IO(Socket, Socket)
initSockets = do
    (navAddr:_) <- getAddrInfo Nothing (Just droneip) (Just $ show navPort)
    (contAddr:_) <- getAddrInfo Nothing (Just droneip) (Just $ show controlPort)
    navS <- socket (addrFamily navAddr) Datagram defaultProtocol
    contS <- socket (addrFamily contAddr) Datagram defaultProtocol
    connect navS (addrAddress navAddr) 
    connect contS (addrAddress contAddr)
    navSConnected <- sIsConnected navS
    putStrLn ("navS connected: " ++ show navSConnected)
    contSConnected <- sIsConnected contS
    putStrLn ("contS connected: " ++ show contSConnected)
    return (navS, contS)

navDataInit :: Socket -> Socket -> IO(Int)
navDataInit navS contS = do
     B.send navS byte
     send contS "AT*REF=0,0\rAT*PCMD=1,0,0,0,0,0\r"
     recv navS 1024
     send contS "AT*CONFIG=2,\"general:navdata_demo\",\"TRUE\"\r" 

{- 
keepSignal :: Int -> String -> Socket -> Socket -> IO(String, Int)
keepSignal n [] navS contS = do
    send contS $ "AT*REF=" ++ (show n) ++ ",0\rAT*PCMD="++(show $ n+1)++",0,0,0,0,0\r"
    --putStrLn (show n)
    navData <- recv navS 1024
    return (navData, n+2)
keepSignal n s navS contS = do
    send contS s 
    navData <- recv navS 1024
-}

sendComm :: Int -> String -> Socket -> IO Int
sendComm n s contS = do
    let (s', n') = constructComm n s 
    send contS s'
    return n'

recvNav :: Socket -> IO String
recvNav navS = do
    recv navS 1024

constructComm :: Int -> String -> (String, Int)
constructComm n s = (s, n)

--test ::, Int -> String -> (String, Int)
--test n 