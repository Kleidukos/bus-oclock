module Main where

import           Client              (run)
import           Dhall
import           Options.Applicative hiding (auto)
import           Types


runWithOptions :: AppArgs -> IO ()
runWithOptions AppArgs{..} = do
  configData <- input auto configFile
  run configData sendNotif

main :: IO ()
main = execParser opts >>= runWithOptions
  where
    parser = AppArgs <$> argument str (metavar "CONFIG_PATH")
                     <*> switch (short 'n' <>
                                 long "notify-send" <>
                                 help "Also sends the result in a desktop notification")
    opts = info parser mempty
