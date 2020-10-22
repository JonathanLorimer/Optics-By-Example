{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TemplateHaskell #-}

module CH4_Polymorphic_Optics where

import Control.Lens

-- import Control.Applicative
-- import Data.Char
-- import qualified Data.Map as M
-- import qualified Data.Set as S
-- import qualified Data.Text as T

-- Exercises - Polymorphic Lenses

-- 1. Write the type signature of the polymorphic lens which would allow changing a Vorpal x to
-- a Vorpal y.
newtype Vorpal a = Vorpal {unVorpal :: a}

type VorpalLens x y = Lens (Vorpal x) (Vorpal y) x y

-- 2. Find one possible way to write a polymorphic lens which changes the type of the best and
-- worst fields in the Preferences type above. You’re allowed to change the type of the lenses or
-- alter the type itself!
data Preferences a
  = Preferences
      { _best :: a,
        _worst :: a
      }
  deriving (Show)

preferenceLens :: Lens (Preferences a) (Preferences b) (a, a) (b, b)
preferenceLens = lens getter setter
  where
    getter :: Preferences a -> (a, a)
    getter Preferences {_best, _worst} = (_best, _worst)
    setter :: Preferences a -> (b, b) -> Preferences b
    setter _ (b1, b2) = Preferences b1 b2

-- 3. We can change type of more complex types too. What is the type of a lens which could change
-- the type variable here:
data Result e
  = Result
      { _lineNumber :: Int,
        _result :: Either e String
      }

type ResultLens e e' = Lens (Result e) (Result e') (Either e String) (Either e' String)

-- 4. It’s thinking time! Is it possible to change more than one type variable at a time using a
-- polymorphic lens?

-- I don't think so?

-- 5. BONUS Come up with some sort of lens to change from a Predicate a to a Predicate b?

data Predicate a
  = Predicate (a -> Bool)

predLens :: Lens (Predicate a) (Predicate b) (a -> Bool) (b -> Bool)
predLens = lens getter setter
  where
    getter :: Predicate a -> a -> Bool
    getter (Predicate f) = f
    setter :: Predicate a -> (b -> Bool) -> Predicate b
    setter _ f = Predicate f
-- Exercises Lens Composition

-- 1.
---- $> view (_2 . _1 . _2) ("Ginerva", ((("Galileo", "Waldo"), "Malfoy")))

-- 2.
-- fiveEightDomino :: Lens' Five Eight
-- fiveEightDomino = undefined
-- mysteryDomino :: Lens' Eight Two
-- mysteryDomino = undefined
-- twoThreeDomino :: Lens' Two Three
-- twoThreeDomino = undefined

-- dominoTrain :: Lens' Five Three
-- dominoTrain = fiveEightDomino . mysteryDomino . twoThreeDomino

-- 3.
-- Lens Platypus BabySloth Armadillo HedgeHog
--         s        t         a         b

-- 4.
--
