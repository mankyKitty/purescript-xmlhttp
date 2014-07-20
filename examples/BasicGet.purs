module Main where

import Network.XMLHttpRequest

main = do
    xr <- startXHR
    xr' <- assignOnload xr (getResponseText)
    xr'' <- open xr' (show GET) "#"
    xrP <- sendEmpty xr''
    Debug.Trace.trace "Worky?"

