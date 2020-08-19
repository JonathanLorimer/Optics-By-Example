module CH2_Optics where

import Control.Lens
import Control.Applicative
import Data.Char
import qualified Data.Map as M
import qualified Data.Set as S
import qualified Data.Text as T


-- $> view _1 ('1','2')
--
-- $> view _2 ('1','2')
