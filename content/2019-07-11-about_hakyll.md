+++
title = "How does Hakyll work?"
authors = ["rctcwyvrn"]

[extra]
blurb = "A few messy notes on how hakyll works underneath the hood"
+++


How does Hakyll work? A quick rundown from someone completely new to both web design _and_ haskell.

After you create and build the project you have the following:  
- site.hs  
- a folder of templates  
- a folder of css   
- a folder of markdown posts  

Here's how hakyll generates each page of the website (I think, I'm still figuring it out)  

The index:  

1. Apply the proper templates to make index.html have the list of posts  
2. Take that index.html and make it $content$  (lmao I just noticed that it becomes inline LaTeX, $x+y=1$)
3. Take the default.html and replace the instances of $content$ on the template with index.html  
4. Export that as index.html  

The posts and stuff:  

1. Take the post's markdown data  
2. Pull out the metadata, called the 'context'  
3. Apply whatever templates you want to it, using the metadata if you want  

Here's how I made the favorite section on the index: 
  
1. Add a favorite tag to the metadata of the post I want to favorite  
2. Make a new template called favorite-list  
3. Use the hakyll DSL syntax to make the template do the same thing as post-list but only if the favorite tag is present  
4. Add to index.html a partial that uses favorite-list  

Using pandocCompilerWith to make stuff like laTeX

\\[ \\ln x = \\int_{-\\infty}^x \\frac 1 y \\, dy . \\]

I followed this: [http://travis.athougies.net/posts/2013-08-13-using-math-on-your-hakyll-blog.html](http://travis.athougies.net/posts/2013-08-13-using-math-on-your-hakyll-blog.html)
The idea is that you just need to set the proper extensions and options for pandoc's writing. 

**Note**
You need to make sure the math.jax script is https or else github pages (smartly) refuses to load it

How to add a block of text to every post of a certain type:

1. Generate the html file for the stuff you want to add, for me this was abit.html, which is an about paragraph
2. Add a tag to the metadata for your post's markdown
3. Edit the post.html template to check for the tag
4. Make the template load that html file as a partial if the tag is present


```haskell
main :: IO ()
main = hakyll $ do
	    match "images/*" $ do
	        route   idRoute
```