module Handler.Shoes where

import Import

getShoesR :: Handler Html
getShoesR = do
  shoes <- runDB $ selectList [] []
  defaultLayout $(widgetFile "Shoes/index")

postShoesR :: Handler Html
postShoesR = error ""

getShoeR :: ShoeId -> Handler Html
getShoeR = error ""
