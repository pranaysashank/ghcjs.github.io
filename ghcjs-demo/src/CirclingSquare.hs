{-# LANGUAGE FlexibleContexts #-}

-- Take look at the commented code as well.

module CirclingSquare
    ( playCirclingSquare
    ) where

import Streamly
import Streamly.Prelude as S
import Control.Monad.IO.Class (liftIO)
import Data.IORef
import System.Clock

import GHCJS.DOM
import GHCJS.DOM.Types
import GHCJS.DOM.Document
import GHCJS.DOM.Element
import GHCJS.DOM.NonElementParentNode
import GHCJS.DOM.HTMLCanvasElement
import GHCJS.DOM.CanvasRenderingContext2D
import GHCJS.DOM.GlobalEventHandlers
import GHCJS.DOM.EventM

domText :: String
domText = "<h1>Hello and welcome to Circling Square</h1>\
\<canvas id=surface width=640 height=480 style=\"background-color: rgb(55,60,64);\">\
\</canvas>"

initDom :: IORef (Float, Float) -> JSM ()
initDom cref = do
    Just doc <- currentDocument
    Just body <- getBody doc
    setInnerHTML body domText
    surface <- uncheckedCastTo HTMLCanvasElement <$> getElementByIdUnchecked doc "surface"
    _ <- on surface mouseMove $ do
        (x, y) <- mouseClientXY
        liftIO $ writeIORef cref (fromIntegral x, fromIntegral y)
    return ()

display :: (Float, Float) -> JSM ()
display (playerX, playerY) = do
    Just doc <- currentDocument
    surface <- uncheckedCastTo HTMLCanvasElement <$> getElementByIdUnchecked doc "surface"
    ctx <- (CanvasRenderingContext2D . unRenderingContext) <$> getContextUnchecked surface "2d" ([] :: String)
    clearRect ctx 0 0 640 480
    setFillStyle ctx "rgb(212, 108, 73)"
    let side = 20
    fillRect ctx (playerX - 8) (playerY - 89) side side

updateDisplay :: TimeSpec -> IORef (Float, Float) -> IO ()
updateDisplay initTime cref = do
    time <- getTime Monotonic
    (x, y) <- readIORef cref
    let t =
            fromIntegral (toNanoSecs initTime - toNanoSecs time) * speed /
            1000000000
     in display (x + cos t * radius, y + sin t * radius)
  where
    speed = 6
    radius = 60

playCirclingSquare :: IO ()
playCirclingSquare = do
    cref <- newIORef (0,0)
    initTime <- getTime Monotonic
    initDom cref
    runStream $ asyncly $ constRate 40 $
              S.repeatM (updateDisplay initTime cref)

{-

initDom :: JSM ()
initDom = do
    Just doc <- currentDocument
    Just body <- getBody doc
    setInnerHTML body domText
    surface <- uncheckedCastTo HTMLCanvasElement <$> getElementByIdUnchecked doc "surface"
    hello <- uncheckedCastTo HTMLDivElement <$> getElementByIdUnchecked doc "hello"
    return ()

updateDisplay :: TimeSpec -> SerialT IO ()
updateDisplay initTime = do
    Just doc <- currentDocument
    surface <- liftIO $ uncheckedCastTo HTMLCanvasElement <$> getElementByIdUnchecked doc "surface"
    cs <- mousePosition surface
    liftIO $ display cs

mousePosition ::
       (IsGlobalEventHandlers e, IsEventTarget e)
    => e
    -> SerialT IO (Float, Float)
mousePosition ele = do
    cref <- liftIO $ newIORef (0, 0)
    _ <- liftIO $ on ele mouseMove $ do
        (x, y) <- mouseClientXY
        liftIO $ writeIORef cref (fromIntegral x, fromIntegral y)
    S.repeatM (readIORef cref)

playCirclingSquare :: IO ()
playCirclingSquare = do
    initTime <- getTime Monotonic
    initDom
    runStream $ updateDisplay initTime
-}
