{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module Network.DigitalOcean.Services.Action where

import Data.Aeson
import Network.DigitalOcean.Types
import Data.Time.Clock

data Action = Action
  { _id            :: Int
  -- , _status        :: String -- TODO: Make a type
  , _type'         :: String
  , _startedAt     :: UTCTime
  , _completedAt   :: UTCTime
  , _resourceId    :: Int
  , _resourceType  :: String -- TODO: Make a type
  , _regionSlug    :: String
  } deriving (Show)

instance FromJSON (Response Action) where
  parseJSON (Object v) =
    fmap Response $ parseJSON =<< (v .: "action")

instance FromJSON Action where
  parseJSON (Object v) =
    Action
      <$> v .: "id"
      -- <*> v .: "status"
      <*> v .: "type"
      <*> v .: "started_at"
      <*> v .: "completed_at"
      <*> v .: "resource_id"
      <*> v .: "resource_type"
      <*> v .: "region_slug"

instance FromJSON (PaginationState Action) where
  parseJSON (Object v) = do
    actions <- v .: "actions"
    links <- v .: "links"
    -- meta <- v .: "meta"
    pages <- links .: "pages"
    next <- pages .:? "next"
    total <- v .: "meta" >>= (.: "total")
    let page = 1
    return $ PaginationState actions page next total False

instance Paginatable Action where

