{-# LANGUAGE NoImplicitPrelude   #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE PackageImports      #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE UnicodeSyntax       #-}

{-|
[@ISO639-1@]        -

[@ISO639-2B@]       paa

[@ISO639-3@]        hui

[@Native name@]     -

[@English name@]    Huli
-}

module Text.Numeral.Language.PAA
    ( -- * Language entry
      entry
      -- * Conversions
    , cardinal
      -- * Structure
    , struct
      -- * Bounds
    , bounds
    ) where


--------------------------------------------------------------------------------
-- Imports
--------------------------------------------------------------------------------

import "base" Data.Function ( ($), const, fix )
import "base" Data.Maybe    ( Maybe(Just) )
import "base" Data.Monoid   ( Monoid )
import "base" Data.String   ( IsString )
import "base" Prelude       ( Integral )
import "base-unicode-symbols" Data.Function.Unicode ( (.) )
import qualified "containers" Data.Map as M ( fromList, lookup )
import           "this" Text.Numeral
import qualified "this" Text.Numeral.Exp as E
import "this" Text.Numeral.Entry


--------------------------------------------------------------------------------
-- PAA
--------------------------------------------------------------------------------

{-
TODO:
Need new Exp constructor to express
42 = (15 × 2) + (12 obj. of the 3rd 15) = ngui ki, ngui tebone-gonaga hombearia

Probably also need a constructor to express "4 obj" as opposed to just "4".
-}

entry :: Entry
entry = emptyEntry
    { entIso639_2    = ["paa"]
    , entIso639_3    = Just "hui"
    , entEnglishName = Just "Huli"
    , entCardinal    = Just Conversion
                       { toNumeral   = cardinal
                       , toStructure = struct
                       }
    }

cardinal :: (Integral a, Monoid s, IsString s) => a -> Maybe s
cardinal = cardinalRepr . struct

struct :: (Integral a, E.Unknown b, E.Lit b, E.Add b, E.Mul b) => a -> b
struct = checkPos
       $ fix
       $ findRule ( 1, lit       )
                [ (16, add 15 R  )
                , (30, mul 15 R R)
                , (31, add 30 R  )
                ]
                  100

bounds :: (Integral a) => (a, a)
bounds = (1, 100)

cardinalRepr :: (Monoid s, IsString s) => Exp -> Maybe s
cardinalRepr = render defaultRepr
               { reprValue = \n -> M.lookup n syms
               , reprAdd   = Just (⊞)
               , reprMul   = Just (⊡)
               }
    where
      -- (_ ⊞ _) _ = ", ngui "
      (_ ⊞ _) _ = "-ni "

      (_ ⊡ _) _ = " "

      syms =
          M.fromList
          [ ( 1, const "mbira")
          , ( 2, \c -> case c of
                        CtxMul {} -> "ki"
                        _         -> "kira"
            )
          , ( 3, const "tebira")
          , ( 4, const "maria")
          , ( 5, const "duria")
          , ( 6, const "waragaria")
          , ( 7, const "karia")
          , ( 8, const "halira")
          , ( 9, const "dira")
          , (10, const "pira")
          , (11, const "bearia")
          , (12, const "hombearia")
          , (13, const "haleria")
          , (14, const "deria")
          , (15, \c -> case c of
                        CtxMul {} -> "ngui"
                        _         -> "nguira"
            )
          ]
