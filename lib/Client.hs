module Client where

import           Notification            (notifySend)
import           Types
-- import           Network.HTTP.Client     (ManagerSettings, managerModifyRequest)
import           Control.Monad           (when)
import           Network.HTTP.Client.TLS (newTlsManager)
import           Servant.Client


-- Shape of the API url

api :: Proxy BusAPI
api = Proxy

bus :: BusLine -> BusStop -> BusDir -> ClientM APIMessage
bus = client api

-- Actual data that is being passed to the query constructor
queries :: AppConfig -> ClientM APIMessage
queries AppConfig{..} = bus line stop direction

-- For debug purposes only
-- settings :: ManagerSettings
-- settings = tlsManagerSettings
--             {
--               managerModifyRequest = \req -> print req >> return req
--             }

run :: AppConfig -> Bool -> IO ()
run params sendNotif = do
  -- mgr <- newTlsManagerWith settings
  mgr <- newTlsManager
  res <- runClientM (queries params) (mkClientEnv mgr (BaseUrl Https "api-ratp.pierre-grimaud.fr" 443 "v3/schedules"))
  case res of
    Left err  -> putTextLn $ "[!] " <> show err
    Right ret -> process ret sendNotif

process :: APIMessage -> Bool -> IO ()
process apiMessage sendNotif = do
  let msg = buildMessage (result apiMessage)
  when sendNotif $ notifySend msg
  putText msg

buildMessage :: APIResult -> Text
buildMessage apiResult = unlines concatMessage
  where
    dests = map destination $ schedules apiResult
    times = map message     $ schedules apiResult
    res   = zip dests times
    concatMessage = map (\x -> fst x <> ": " <> snd x) res
