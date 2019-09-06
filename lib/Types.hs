module Types where

import           Data.Aeson  (FromJSON)
import           Dhall
import           Servant.API

data AppArgs = AppArgs { configFile :: Text
                       , sendNotif  :: Bool
                       }

data APISchedule = APISchedule
  { destination :: Text
  , message     :: Text
  } deriving (Show, Generic)

newtype APIResult = APIResult
  { schedules :: [APISchedule]
  } deriving (Show, Generic)

data APIMetadata = APIMetadata
  { call    :: Text
  , date    :: Text
  , version :: Int
  } deriving (Show, Generic)

data APIMessage = APIMessage
  { _metadata :: APIMetadata
  , result    :: APIResult
  } deriving (Show, Generic)


instance FromJSON APISchedule
instance FromJSON APIResult
instance FromJSON APIMetadata
instance FromJSON APIMessage


type BusAPI = "bus" :> Capture "line" BusLine :> Capture "stop" BusStop :> Capture "direction" BusDir :> Get '[JSON] APIMessage

-- Servant client datatypes
type BusLine = Natural
type BusStop = Text
data BusDir  = A | R deriving (Show, Generic)

instance ToHttpApiData BusDir where
  toUrlPiece A = "A"
  toUrlPiece R = "R"

data AppConfig = AppConfig { line      :: BusLine
                           , stop      :: BusStop
                           , direction :: BusDir
                           } deriving (Show, Generic)

-- instance Inject BusDir
instance Interpret BusDir
instance Interpret AppConfig
