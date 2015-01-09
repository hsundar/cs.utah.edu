--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Binary (Binary)
import           Data.Typeable
import           Data.Monoid (mappend, mconcat)
import qualified Data.Set as S
import           Text.Pandoc.Options
import           Hakyll
--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
    match ("images/*.png" .||. "images/*.jpg" .||. "images/svg/*.svg" .||. "files/**" .||. "teaching/bigdata/*.pdf" .||. "teaching/bigdata/*.gz") $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*.scss" $ do
        route $ setExtension "css"
        compile sassCompiler

    match ("css/*.css" .||. "css/theme/*.css") $ do
        route   idRoute
        compile compressCssCompiler

{-
    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls
-}
    match "teaching/paralg/slides/*.md" $ do
        route   $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/slides.html" defaultContext
            >>= relativizeUrls

    match ("teaching/bigdata/*.md" .||. "teaching/paralg/*.md") $ do
        route   $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "teaching/*.md" $ do
        route   $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "blog/*" $ do
        route $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "research/*.md" $ do
        route $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    match "talks/*" $ do
        route $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/talk.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["blog/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "blog/*.md"
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
            talks <- fmap (take 3) . recentFirst =<< loadAll "talks/*.md"
            posts <- fmap (take 3) . recentFirst =<< loadAll "blog/*.md"
            let indexCtx =
                    listField "talks" postCtx (return talks) `mappend`
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
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
sassCompiler :: Compiler (Item String)
sassCompiler =
    getResourceString
        >>= withItemBody (unixFilter "sass" ["-s", "--scss"])
        >>= return . fmap compressCss
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
pandocMathCompiler =
    let mathExtensions = [Ext_tex_math_dollars, Ext_tex_math_double_backslash,
                          Ext_latex_macros]
        defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = foldr S.insert defaultExtensions mathExtensions
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions,
                          writerHTMLMathMethod = MathJax ""
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
        {   deployCommand = "rsync -rltogDvz -e ssh ./_site/ shell.cs.utah.edu:~/public_html/"}

--------------------------------------------------------------------------------
