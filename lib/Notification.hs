module Notification where

import           DBus.Notify
import           System.Info (os)

notifySend :: Text -> IO ()
notifySend msg =
  case os of
      "linux" -> do
        client <- connectSession
        let startNote = appNote { summary="Next buses"
                                , body=Just $ Text (toString msg)
                                }
        notify client startNote
        return ()
      _ -> return ()
    where
        appNote = blankNote { appName="Rhasktp" }
