{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Applicative
import           Data.ByteString (ByteString)
import qualified Data.Text as T
import qualified Data.Map as M
import           Snap
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Snaplet.Session.Backends.CookieSession
import           Snap.Util.FileServe
import           System.Environment.Executable
import           Heist
import qualified Heist.Interpreted as I

import Language.Clafer
import Language.ClaferT
import Language.Clafer.Css
import Language.Clafer.ClaferArgs
import Language.Clafer.JSONMetaData
import Language.Clafer.QNameUID
import Language.Clafer.Generator.Html (highlightErrors)

------------------------------------------------------------------------------
import           Application

-- |> compile |>
-- | Show compiler HTML output 
handleCompiler :: AppHandler ()
handleCompiler = do
   html <- gets _vpProject 
   writeText html
-- <| compile <|

------------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("compile",   handleCompiler)     -- |> compile <|
         , ("",          serveDirectory "static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "Virtual Platform Development Tool" Nothing $ do
    -- |> compile |>
    claferModel <- liftIO $ readFile ".vp-project"
    let 
      args' = defaultClaferArgs { mode = [ Html ], self_contained = True }
      (Right resultMap) = compileOneFragment args' claferModel
      (Just result)  = M.lookup Html resultMap
      modelHtml = outputCode result
    -- <| compile <|
    h <- nestSnaplet "" heist $ heistInit "templates"
    s <- nestSnaplet "sess" sess $
           initCookieSessionManager "site_key.txt" "sess" (Just 3600)
    addRoutes routes
    return $ App h s $ T.pack $ modelHtml

-- |> compile |>
compileOneFragment :: ClaferArgs -> InputModel -> Either [ClaferErr] (M.Map ClaferMode CompilerResult)
compileOneFragment args' model =
  runClafer args' $  
    do
      addModuleFragment model
      parse
      compile
      generate
-- <| compile <|