{-# LANGUAGE NoImplicitPrelude, UnicodeSyntax #-}

module Text.Numeral.Misc where

--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------

-- base
import Data.Function         ( const )
import Data.Maybe            ( Maybe(Nothing, Just) )
import Prelude               ( (^), Integer )

-- base-unicode-symbols
import Data.Function.Unicode ( (∘) )


--------------------------------------------------------------------------------
-- Misc
--------------------------------------------------------------------------------

withSnd ∷ (a → b → c) → (d, a) → (e, b) → c
withSnd f (_, x) (_, y) = f x y

d ∷ Integer → Integer
d = (10 ^)

const2 ∷ a → b → c → a
const2 = const ∘ const

weave ∷ [a] → [a] → [a]
weave []     ys = ys
weave (x:xs) ys = x : weave ys xs

untilNothing ∷ [Maybe a] → [a]
untilNothing []             = []
untilNothing (Just x  : xs) = x : untilNothing xs
untilNothing (Nothing : _)  = []