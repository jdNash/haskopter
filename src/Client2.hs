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

main = withSocketsDo $ do 
        (navAddr:_) <- getAddrInfo Nothing (Just droneip) (Just $ show navPort)
        (contAddr:_) <- getAddrInfo Nothing (Just droneip) (Just $ show controlPort)
        navS <- socket (addrFamily navAddr) Datagram defaultProtocol
                --bindSocket s (addrAddress serveraddr)
        contS <- socket (addrFamily contAddr) Datagram defaultProtocol
        connect navS (addrAddress navAddr) 
        connect contS (addrAddress contAddr)
        navSConnected <- sIsConnected navS
        putStrLn (show navSConnected)
        contSConnected <- sIsConnected contS
        putStrLn (show contSConnected)
        
        B.send navS byte
        send contS "AT*REF=0,0\rAT*PCMD=1,0,0,0,0,0\r"
        recv navS 1024
        send contS "AT*CONFIG=1,\"general:navdata_demo\",\"FALSE\"\r" 
        send contS "AT*CONFIG=2,\"general:navdata_demo\",\"FALSE\"\r" 
        forever $ do
            send contS "AT*REF=0,0\rAT*PCMD=1,0,0,0,0,0\r"
            recv navS 1024
        sClose navS
        sClose contS
        return ()