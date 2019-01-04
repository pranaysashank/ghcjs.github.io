-- ghcjs-hello

module Hello where

import Control.DeepSeq (deepseq)

import GHCJS.DOM
import GHCJS.DOM.Types
import GHCJS.DOM.Document
import GHCJS.DOM.Element
import GHCJS.DOM.HTMLInputElement
import GHCJS.DOM.Node
import GHCJS.DOM.EventM
import GHCJS.DOM.GlobalEventHandlers
import GHCJS.DOM.HTMLHyperlinkElementUtils

hello :: JSM ()
hello = do
    Just doc <- currentDocument
    Just body <- getBody doc

    div <- uncheckedCastTo HTMLDivElement <$> createElement doc "div"

    heading <- uncheckedCastTo HTMLHeadingElement <$> do
        h1 <- createElement doc "h1"
        setAttribute h1 "id" "heading"
        setInnerHTML h1 "Hello and Welcome GHCJS"
        return h1
    appendChild_ div heading

    primeLabel <- uncheckedCastTo HTMLParagraphElement <$> do
        p <- createElement doc "p"
        setInnerHTML p "Know any good prime numbers?"
        return p

    primeInput <- uncheckedCastTo HTMLInputElement <$> do
        input <- createElement doc "input"
        setAttribute input "id" "num"
        setAttribute input "size" "8"
        return input

    primeResult <- uncheckedCastTo HTMLDivElement <$> do
        primeDiv <- createElement doc "div"
        setAttribute primeDiv "id" "prime"
        return primeDiv

    let setIsPrimeDiv = do
        n <- getValue primeInput
        setInnerHTML primeResult $ "Thinking about " ++ n
        let message = validatePrime n
        deepseq message $ setInnerHTML primeResult message

    _ <- on primeInput keyUp setIsPrimeDiv
    _ <- on primeInput keyPress setIsPrimeDiv

    appendChild_ primeLabel primeInput
    appendChild_ primeLabel primeResult
    appendChild_ div primeLabel

    appendChild_ body div

-- Integer uses goog.math.Integer compiled to Javascript
isPrime :: Integer -> Bool
isPrime p = p > 1 && (all (\n -> p `mod` n /= 0)
                     $ takeWhile (\n -> n*n <= p) [2..])

validatePrimeMessage :: Integer -> String
validatePrimeMessage p | isPrime p = "<b>Yes</b>, " ++ (show p) ++ " is a prime"
                       | otherwise = "<b>No</b>, " ++ (show p) ++ " is not a prime"

validatePrime :: String -> String
validatePrime s =
    case reads s of
        [(n, "")] -> validatePrimeMessage n
        _         -> "<b>No</b>, that is not a number"
