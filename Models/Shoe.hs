module Models.Shoe where


import Import
import Data.UUID.V4(nextRandom)
import System.FilePath((</>))
import qualified Data.ByteString as B
import qualified Data.Text as T

-- convert photo file path to relative url path
buildFilePath :: Text -> [Text]
buildFilePath f = [f]

-- save photo on disc and return file name
savePhoto :: B.ByteString -> IO Text
savePhoto bs = do
  u <- show <$> nextRandom
  let name = "files" </> u
  B.writeFile name bs
  return $ T.pack u
