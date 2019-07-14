{-# LANGUAGE OverloadedStrings #-}

-- | Gonna generate me some Haskell code, string-wise. Template Haskell sux
module VultrMetaServant where

import Data.Text (Text)
import Servant.API
import qualified Data.Text as T
import qualified Data.Text.IO as T

import Vultr hiding (main)

-- All we need is a printer. We can print Endpoint and basically we're done.
printEndpoint :: Endpoint -> Text
printEndpoint (Endpoint p d a m r e ps)
    = printPath p
    <:> printAddDescription d
    <:> printApiHeader a
    <:> printMethod m
    <:>  "LOL"

a <:> b = a <> " :> " <> b

printMethod :: Method -> Text
printMethod = T.pack . show

apiKeyTy = "ApiKey"

printPath :: Path -> Text
printPath (Path ps) = T.intercalate " :> " (map stringLit ps)

printApiHeader :: Bool -> Text
printApiHeader True = "Header \"API-Key\" " <> apiKeyTy
printApiHeader False = "Header' '['Strict, 'Optional] \"API-Key\" " <> apiKeyTy

-- | Add a description to a printed thing.
printAddDescription :: Text -> Text
printAddDescription t = "Description " <> stringLit t

main = T.putStrLn $ printEndpoint nullEP
    { path = Path (T.words "v1 backup list")
    , edescription = "List all backups on the current account. Required access: Subscriptions."
    , needsAPIKey = True
    , method = Get
    }

stringLit t = "\"" <> t <> "\""
{-
type A = "v1" :> "backup" :> "list"
    :> $(apiKeyHeader (nullEP { needsAPIKey = True }))
    :> (Description "Filter result set to only contain backups of this subscription object."
        :> QueryParam' '[Optional, Strict] "SUBID" SubId)
    :> (Description "Filter result set to only contain this backup"
        :> QueryParam' '[Optional, Strict] "BACKUPID" BackupId)
    :> Description "List all backups on the current account. Required access: Subscriptions."
    :> Get '[JSON] [(BackupId, Backup)]

-}
