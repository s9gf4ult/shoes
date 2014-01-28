module Handler.Shoes where

import Data.Aeson.Parser(json)
import Data.Aeson.Types(fromJSON, Result(..))
import Data.Conduit(($$))
import Data.Conduit.Attoparsec(sinkParser)
import Import
import Models.Shoe
import Network.Wai(requestBody)
-- import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.ByteString.Base64 as B64

getShoesR :: Handler Html
getShoesR = do
  shoes <- runDB $ selectList [] []
  defaultLayout $(widgetFile "Shoes/index")

postShoesR :: Handler ()
postShoesR = do
  req <- waiRequest
  let body = requestBody req
  j <- liftIO $ body $$ (sinkParser json)
  let r = fromJSON j
  case r of
    Error e -> error $ "Could not parse Json as Shoe " ++ e
    Success shoe -> do
      let photo = B64.decode $ T.encodeUtf8 $ shoePhoto shoe
      case photo of
        Left e -> error $ "Base64 picture is broken: " ++ e
        Right p -> do
          fname <- liftIO $ savePhoto p
          runDB $ insert_ $ shoe{shoePhoto = fname}

getShoeR :: ShoeId -> Handler Html
getShoeR sid = do
  shoe <- runDB $ get404 sid
  defaultLayout $(widgetFile "Shoes/show")
