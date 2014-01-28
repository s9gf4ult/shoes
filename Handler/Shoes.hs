module Handler.Shoes where

import Import
import Models.Shoe
import Network.Wai(requestBody)
import Data.Aeson.Parser(json)
import Data.Aeson.Types(fromJSON, Result(..))
import Data.Conduit.Attoparsec(sinkParser)
import Data.Conduit(($$))

getShoesR :: Handler Html
getShoesR = do
  shoes <- runDB $ selectList [] []
  defaultLayout $(widgetFile "Shoes/index")

postShoesR :: Handler ()
postShoesR = do
  req <- waiRequest
  let body = requestBody req
  j <- liftIO $ body $$ (sinkParser json)
  let r = do
        shoe <- fromJSON j
        photo <- fromJSON j
        return (shoe, photo)
  case r of
    Error e -> error e
    Success (shoe, photo) -> do
      fname <- liftIO $ savePhoto photo
      runDB $ insert_ $ shoe{shoePhoto = fname}
      return ()

getShoeR :: ShoeId -> Handler Html
getShoeR sid = do
  shoe <- runDB $ get404 sid
  defaultLayout $(widgetFile "Shoes/show")
