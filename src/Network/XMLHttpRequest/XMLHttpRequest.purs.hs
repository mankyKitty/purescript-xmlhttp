module Network.XMLHttpRequest where

-- Access to the outside world.
import Control.Monad.Eff

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

foreign import startXHR
  "function startXHR() {\
  \  return new XMLHttpRequest(); \
  \};" :: forall a. Eff (x :: XHRReq | a) XHR

foreign import assignOnload
  "function assignOnload(xhr) {\
  \  return function(f) {\
  \    return function() {\
  \      xhr.onLoad = f; \
  \      return xhr; \
  \    }; \
  \  }; \
  \};" :: forall eff a b. XHR -> (XHR -> Eff eff a) -> Eff (x :: XHRReq | b) XHR

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
 
foreign import getResponseText
  "function getResponseText(xhr) {\
  \  return function() {\
  \    console.log(xhr.responseText); \
  \    return xhr.responseText; \
  \  }; \
  \};" :: forall eff. XHR -> Eff (x :: XHRReq | eff) String

main = do
  xr <- startXHR
  xr' <- assignOnload xr (getResponseText)
  xr'' <- open xr' (show GET) "#"
  xrP <- sendEmpty xr''
  Debug.Trace.trace "Worky?"
