--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Text.Pandoc.Options
import           Text.Pandoc.Highlighting
import qualified Data.Set as S
--------------------------------------------------------------------------------
syntaxStyle = zenburn

pandocCustomCompiler =
    let mathExtensions = extensionsFromList [Ext_tex_math_dollars, Ext_tex_math_double_backslash,
                          Ext_latex_macros]
        defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = mathExtensions <> defaultExtensions <> githubMarkdownExtensions
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions,
                          writerHTMLMathMethod = MathJax "",--,
                          writerHighlightStyle = Just syntaxStyle
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions

main :: IO ()
main = do
    generateCSS
    hakyll $ do

        match "images/*" $ do
            route   idRoute
            compile copyFileCompiler

        match "css/*" $ do
            route   idRoute
            -- compile compressCssCompiler
            compile copyFileCompiler
            
        match (fromList ["info/about.md", "info/contact.md"]) $ do
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
                all_posts <- recentFirst =<< loadAll "posts/*"
                limited_posts <- limitPosts =<< return all_posts
                let indexCtx =
                        listField "all_posts" postCtx (return all_posts) `mappend`
                        listField "posts" postCtx (return limited_posts) `mappend`
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

-- I don't want to have every single post on my homepage, so just take the most recent 5
limitPosts :: (MonadMetadata m, MonadFail m) => [Item a] -> m [Item a]
limitPosts xs = (return $ take 5 xs)

generateCSS :: IO ()
generateCSS = do
    let css = styleToCss syntaxStyle
    writeFile "css/syntax.css" css
    return ()