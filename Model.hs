module Model where

import Control.Applicative ((<$>), (<*>))
import Data.Aeson.Types (FromJSON(..), (.:), withObject)
import Data.Text (Text)
import Data.Typeable (Typeable)
import Database.Persist.Quasi
import Prelude
import Yesod

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlOnlySettings, mkMigrate "migrateAll"]
    $(persistFileWith lowerCaseSettings "config/models")


instance FromJSON Shoe where
  parseJSON val = flip (withObject "Shoe must be json object")
                  val $ \obj -> Shoe
                                <$> obj .: "description"
                                <*> obj .: "color"
                                <*> obj .: "size"
                                <*> obj .: "photo"
