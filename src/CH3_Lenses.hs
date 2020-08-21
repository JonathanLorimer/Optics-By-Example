{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TemplateHaskell #-}
module CH3_Lenses where

import Control.Lens
import Data.Char (isSpace)


-- | Law Exercises
-- 1. set-get -> view lens $ set lens a structure === a
--
-- 2. get-set -> set lens (view lens structure') structure === structure'
--
-- 3. set-set -> set lens b $ set lens a structure === set lens b structure

-- | 1. Implement a lens which breaks the second and/or third law. That’s get-set and set-set
-- respectively.

data Product = Product { _field1 :: Int
                       , _field2 :: Either String Int
                       }

field2 :: Lens' (Either String Int) String
field2 = lens getLeft setLeft
  where
    getLeft (Left s) = s
    getLeft (Right _) = ""
    setLeft (Left _) v = Left $ reverse v
    setLeft (Right _) _ = Left ""

-- $> set field2 (view field2 (Left "hello" :: Either String Int)) (Right 2)
--  Left ""
-- $> set field2 (view field2 (Left "hello" :: Either String Int)) (Left "2")
--  Left "olleh"

-- | 3. There’s a different way we could have written the msg lens such that it would PASS the set-get
-- law and the set-set law, but fail get-set. Implement this other version.

field2' :: Lens' (Either String Int) String
field2' = lens getLeft setLeft
  where
    getLeft (Left s) = s
    getLeft (Right _) = ""
    setLeft (Left _) v = Left v
    setLeft (Right _) v = Left v

-- $> view field2' $ set field2' "hello" (Right 2)
-- passes: "hello"

-- $> view field2' $ set field2' "hello" (Left "2")
-- passes: "hello"

-- $> set field2' "goodbye" $ set field2' "hello" (Left "2")
-- passes: Left "goodbye"

-- $> set field2' "goodbye" $ set field2' "hello" (Right 2)
-- passes: Left "goodbye"

-- $> set field2' (view field2' (Left "hello")) (Right 2)
-- passes: Left "hello"

-- $> set field2' (view field2' (Right 2)) (Right 2)
-- fails: Left ""

-- $> set field2' (view field2' (Right 2)) (Left "Hello")
-- fails: Left ""


-- | Virtual Fields Exercises
-- 1. abstract username with a lens

data User =
  User { _firstName :: String
       , _lastName :: String
       , _email :: String
       }
makeLenses ''User

username :: Lens' User String
username = lens getUsername setUsername
  where
    getUsername = view email
    setUsername = flip (set email)

-- 2. create a getter and setter for fullname

fullname :: Lens' User String
fullname = lens getFullname setFullname
  where
    getFullname user = view lastName user ++ view firstName user
    setFullname user fname =
      let (firstname, lastname) = (break isSpace fname)
       in set firstName firstname $ set lastName lastname user


-- | Data Validation

data ProducePrices =
  ProducePrices { _limePrice :: Float
                , _lemonPrice :: Float
                } deriving Show

-- 1. add min value to setters && 2. clamp price to within 50 cents of other produce

clamp :: Float -> Float -> Float -> Float
clamp minVal maxVal a = min maxVal . max minVal $ a

limePrice :: Lens' ProducePrices Float
limePrice = lens getLimePrice setLimePrice
  where
    getLimePrice (ProducePrices{ _limePrice }) = _limePrice
    setLimePrice produce newPrice =
        let
          correctedLime =  max 0.0 newPrice
          correctedLemon = clamp (correctedLime - 0.5) (correctedLime + 0.5) correctedLime
         in produce { _limePrice = correctedLime, _lemonPrice = correctedLemon }

lemonPrice :: Lens' ProducePrices Float
lemonPrice = lens getLemonPrice setLemonPrice
  where
    getLemonPrice (ProducePrices{ _lemonPrice }) = _lemonPrice
    setLemonPrice produce newPrice =
        let
          correctedLemon =  max 0.0 newPrice
          correctedLime = clamp (correctedLemon - 0.5) (correctedLemon + 0.5) correctedLemon
         in produce { _limePrice = correctedLime, _lemonPrice = correctedLemon }


