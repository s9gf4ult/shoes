module Models.Shoe where


import Import
import Data.UUID.V4(nextRandom)
import System.FilePath((</>))
import qualified Data.ByteString as B
import qualified Data.Text as T

buildFilePath :: Text -> [Text]
buildFilePath = undefined

-- save photo on disc and return file name
savePhoto :: B.ByteString -> IO Text
savePhoto bs = do
  u <- show <$> nextRandom
  let name = "files" </> u
  B.writeFile name bs
  return $ T.pack u
