--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import qualified Data.Set as S
import 			 Text.Pandoc.Options
--------------------------------------------------------------------------------
pandocCustomCompiler =
    let mathExtensions = [Ext_tex_math_dollars, Ext_tex_math_double_backslash,
                          Ext_latex_macros]
        defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = foldr S.insert defaultExtensions (mathExtensions <> githubMarkdownExtensions)
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions,
                          writerHTMLMathMethod = MathJax "",
                          writerHighlightStyle = Just syntaxHighlightingStyle
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions

main :: IO ()
main = hakyll $ do
	    match "images/*" $ do
	        route   idRoute
	        compile copyFileCompiler

	    match "css/*" $ do
	        route   idRoute
	        compile compressCssCompiler
	        
	    match (fromList ["about.rst", "contact.markdown"]) $ do
	        route   $ setExtension "html"
	        compile $ pandocCustomCompiler
	            >>= loadAndApplyTemplate "templates/default.html" defaultContext
	            >>= relativizeUrls

	    match "posts/*" $ do
	        route $ setExtension "html"
	        compile $ pandocCustomCompiler
	            >>= loadAndApplyTemplate "templates/post.html"    postCtx
	            >>= loadAndApplyTemplate "templates/default.html" postCtx
	            >>= relativizeUrls

	    create ["archive.html"] $ do
	        route idRoute
	        compile $ do
	            posts <- recentFirst =<< loadAll "posts/*"
	            let archiveCtx =
	                    listField "posts" postCtx (return posts) `mappend`
	                    constField "title" "Archives"            `mappend`
	                    defaultContext

	            makeItem ""
	                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
	                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
	                >>= relativizeUrls


	    match "index.html" $ do
	        route idRoute
	        compile $ do
	            posts <- recentFirst =<< loadAll "posts/*"
	            let indexCtx =
	                    listField "posts" postCtx (return posts) `mappend`
	                    constField "title" "Home"                `mappend`
	                    defaultContext

	            getResourceBody
	                >>= applyAsTemplate indexCtx
	                >>= loadAndApplyTemplate "templates/default.html" indexCtx
	                >>= relativizeUrls

	    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

