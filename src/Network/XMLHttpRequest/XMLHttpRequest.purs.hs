module Network.XMLHttpRequest where

import Data.Foreign
-- Access to the outside world.
import Control.Monad.Eff
import Data.Maybe
import Data.Either

-- Effects
foreign import data XHR :: *

foreign import data XHRReq :: !

type URI = String

-- Stolen from Network.HTTP <3
-- TODO make Network.HTTP live again.
data Verb = DELETE
          | GET
          | HEAD
          | OPTIONS
          | PATCH
          | POST
          | PUT

instance showHTTPVerb :: Show Verb where
  show DELETE  = "DELETE"
  show GET     = "GET"
  show HEAD    = "HEAD"
  show OPTIONS = "OPTIONS"
  show PATCH   = "PATCH"
  show POST    = "POST"
  show PUT     = "PUT"

data XHRResponse = XHRResponse { readyState :: Number
                               , status :: Number
                               , statusText :: String
                               , response :: String
                               , responseText :: String
                               , responseType :: String
                               }

instance readXHRResponse :: ReadForeign XHRResponse where
  read = do
    redySt <- prop "readyState"
    st     <- prop "status"
    stT    <- prop "statusText"
    rs     <- prop "response"
    rsTe   <- prop "responseText"
    rsTy   <- prop "responseType"
    return $ XHRResponse { readyState: redySt
                         , status: st
                         , statusText: stT
                         , response: rs
                         , responseText: rsTe
                         , responseType: rsTy
                         }

------------------------------
-- Foreign Import Functions --
------------------------------
foreign import startXHR
  "function startXHR() {\
  \  return new XMLHttpRequest(); \
  \};" :: forall a. Eff (x :: XHRReq | a) XHR

foreign import assignOnStateChange
  "function assignOnStateChange(xhr) {\
  \  return function(f) {\
  \    return function() {\
  \      xhr.onreadystatechange = function() { f(xhr); }; \
  \      return xhr; \
  \    }; \
  \  }; \
  \};" :: forall eff a b. XHR -> (XHR -> a) -> Eff (x :: XHRReq | b) XHR

foreign import open
  "function open(xhr) {\
  \  return function(type) {\
  \    return function(url) {\
  \      return function() {\
  \        xhr.open(type, url, true); \
  \        return xhr; \
  \      }; \
  \    }; \
  \  }; \
  \};" :: forall a. XHR -> String -> URI -> Eff (x :: XHRReq | a) XHR

foreign import sendEmpty
  "function sendEmpty(xhr) {\
  \  return function() {\
  \    xhr.send(null); \
  \    return xhr; \
  \  }; \
  \};" :: forall eff. XHR -> Eff (x :: XHRReq | eff) XHR

foreign import sendPayload
  "function sendPayload(xhr) {\
  \  return function(payload) {\
  \    return function() {\
  \      xhr.send(payload); \
  \      return x; \
  \    }; \
  \  }; \
  \};" :: forall eff a. XHR -> a -> Eff (x :: XHRReq | eff) XHR

foreign import maybeXhr
  "function maybeXhr(req) {\
  \    console.log(req != undefined); \
  \    if (req != undefined) {\
  \      return PS.Data_Maybe.Just(req.valueOf()); \
  \    } \
  \    else {\
  \      return PS.Data_Maybe.Nothing; \
  \    }\
  \};" :: XHR -> Maybe Foreign

maybeResponse :: XHR -> Either String XHRResponse
maybeResponse x = case maybeXhr x of
  Just r -> parseForeign (read) r
  Nothing -> Left ("Error Parsing XHR Target")
