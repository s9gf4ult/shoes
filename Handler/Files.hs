module Handler.Files where

import Import
import qualified Data.Text as T
import System.Directory (doesFileExist)
import System.FilePath((</>))
import qualified System.FilePath as P

getFilesR :: [Text] -> Handler Html
getFilesR [] = notFound
getFilesR p = do
  let path = "files" </> (P.joinPath $ map T.unpack p)
  e <- liftIO $ doesFileExist path
  if e
    then sendFile "" path
    else notFound
