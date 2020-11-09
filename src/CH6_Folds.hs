{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module CH6_Folds where

import Control.Lens

-- import Control.Applicative
-- import Data.Char
import qualified Data.Map as M
import qualified Data.Set as S
import qualified Data.Text as T

data Role
  = Gunner
  | PowderMonkey
  | Navigator
  | Captain
  | FirstMate
  deriving (Show, Eq, Ord)

data CrewMember =
  CrewMember { _name :: String
             , _role :: Role
             , _talents :: [String]
             }
  deriving Show
makeLenses ''CrewMember

beastSizes :: [(Int, String)]
beastSizes = [(3, "Sirens"), (882, "Kraken"), (92, "Ogopogo")]

quotes :: [(T.Text, T.Text, T.Text)]
quotes = [("Why", "So", "Serious?"), ("This", "is", "SPARTA")]

{- Exercises -}

{-
  Exercise 1.
  Guess the result of the following expressions
-}

-- $> import CH6_Folds
--
-- $> import qualified Data.Text as T
--
-- $> import qualified Data.Map as M

---- $> beastSizes ^.. folded
--
---- $> beastSizes ^.. folded . folded
--
---- $> beastSizes ^.. folded . folded . folded
--
---- $> beastSizes ^.. folded . _2
--
---- $> toListOf (folded . folded) [[1, 2, 3], [4, 5, 6]]
--
---- $> toListOf (folded . folded) (M.fromList [("Jack", "Captain"), ("Will", "First Mate")])
--
---- $> ("Hello", "It's me") ^.. both . folded
--
---- $> ("Why", "So", "Serious?") ^.. each
--
---- $>  quotes ^.. each . each . each

{-
  Exercise 2.
  Write out the type signature for the combinators in the below expressions
-}

a2 :: [Int]
a2 = toListOf
        ((folded :: Fold [(Int, Char)] (Int, Char)) . (_1 :: Fold (Int,Char) Int))
        [(1, 'a'), (2, 'b'), (3, 'c')]

b2 :: [String]
b2 = (toListOf :: (Fold (Bool, S.Set String) String -> (Bool, S.Set String) -> [String]))
        ((_2 :: Fold (Bool, S.Set String) (S.Set String)) . (folded :: Fold (S.Set String) String))
        (False, S.fromList ["one", "two", "three"])

c2 :: String
c2 = (toListOf :: Fold (M.Map String String) Char -> M.Map String String -> [Char])
      ((folded :: Fold (M.Map String String) String) . (folded :: Fold String Char))
      (M.fromList [("Jack", "Captain"), ("Will", "First Mate")])

{-
  Exercise 3.
  fill in the blank to get the desired output
-}

-- >>> [1, 2, 3] ^.. _
---- $> [1, 2, 3] ^.. folded
-- [1, 2, 3]

-- >>> ("Light", "Dark") ^.. _
---- $> ("Light", "Dark") ^.. _1
-- ["Light"]

-- >>> [("Light", "Dark"), ("Happy", "Sad")] ^.. _
---- $> [("Light", "Dark"), ("Happy", "Sad")] ^.. (folded . both)
-- ["Light","Dark","Happy","Sad"]

-- >>> [("Light", "Dark"), ("Happy", "Sad")] ^.. _
---- $> [("Light", "Dark"), ("Happy", "Sad")] ^.. (folded . _1)
-- ["Light","Happy"]

-- >>> [("Light", "Dark"), ("Happy", "Sad")] ^.. _
-- $> [("Light", "Dark"), ("Happy", "Sad")] ^.. (folded . _2 . folded)
-- "DarkSad"

-- >>> ("Bond", "James", "Bond") ^.. _
-- $> ("Bond", "James", "Bond") ^.. each
-- ["Bond","James","Bond"]
