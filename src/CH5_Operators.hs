{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TemplateHaskell #-}

module CH5_Operators where

import Control.Lens

-- import Control.Applicative
import Data.Char
-- import qualified Data.Map as M
-- import qualified Data.Set as S
-- import qualified Data.Text as T

data Gate
  = Gate
      { _open :: Bool,
        _oilTemp :: Float
      }
  deriving (Show, Eq)

makeLenses ''Gate

data Army
  = Army
      { _archers :: Int,
        _knights :: Int
      }
  deriving (Show, Eq)

makeLenses ''Army

data Kingdom
  = Kingdom
      { _name :: String,
        _army :: Army,
        _gate :: Gate
      }
  deriving (Show, Eq)

makeLenses ''Kingdom

duloc :: Kingdom
duloc =
  Kingdom
    { _name = "Duloc",
      _army =
        Army
          { _archers = 22,
            _knights = 14
          },
      _gate =
        Gate
          { _open = True,
            _oilTemp = 10.0
          }
    }

-- | Exercise 1. use lenses to transform duloc into the below result
testA :: Kingdom
testA = Kingdom
  { _name = "Duloc: a perfect place",
    _army =
      Army
        { _archers = 22,
          _knights = 42
        },
    _gate =
      Gate
        { _open = False,
          _oilTemp = 10.0
        }
  }

goalA :: Kingdom
goalA = duloc
  & name <>~ ": a perfect place"
  & army . knights +~ 28
  & gate . open &&~ False


---- $> goalA
--
---- $> testA == goalA

testB :: Kingdom
testB = Kingdom
  { _name = "Dulocinstein",
    _army =
      Army
        { _archers = 17,
          _knights = 26
        },
    _gate =
      Gate
        { _open = True,
          _oilTemp = 100.0
        }
  }

goalB :: Kingdom
goalB = duloc
  & name <>~ "instein"
  & army . archers -~ 5
  & army . knights +~ 12
  & gate . oilTemp *~ 10

---- $> goalB
--
---- $> testB == goalB
--
testC :: (String, Kingdom)
testC = ( "Duloc: Home",
  Kingdom
    { _name = "Duloc: Home of the talking Donkeys",
      _army =
        Army
          { _archers = 22,
            _knights = 14
          },
      _gate =
        Gate
          { _open = True,
            _oilTemp = 5.0
          }
    }
  )

goalC :: (String, Kingdom)
goalC = duloc
  & name <<>~ ": Home"
  & _2 . name <>~ " of the talking Donkeys"
  & _2 . gate . oilTemp -~ 5.0

---- $> goalC
--
---- $> testC == goalC

-- | Exercise 2.
goal2A :: (Bool, String)
goal2A = (False, "opossums") & _1 ||~ True

test2A :: (Bool, String)
test2A = (True, "opossums")

---- $> goal2A
--
---- $> test2A == goal2A

---- $> 2 & id *~ 3

goal2B :: ((Bool, String), Double)
goal2B = ((True, "Dudley"), 55.0)
            & _1 . _2 <>~ " - the worst"
            & _2 -~ 15
            & _2 //~ 2
            & _1 . _2 %~ map toUpper
            & _1 . _1 &&~ False

test2B :: ((Bool, String), Double)
test2B = ((False,"DUDLEY - THE WORST"),20.0)
---- $> goal2B
--
---- $> goal2B == test2B
