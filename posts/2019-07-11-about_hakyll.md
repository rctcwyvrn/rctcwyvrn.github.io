---
title: How does Hakyll work?
author: rctcwyvrn
---

How does Hakyll work? A quick rundown from someone completely new to both web design _and_ haskell.

After you create and build the project you have the following:  
- site.hs  
- a folder of templates  
- a folder of css   
- a folder of markdown posts  

Here's how hakyll generates each page of the website (I think, I'm still figuring it out)  

The index:  

1. Apply the proper templates to make index.html have the list of posts  
2. Take that index.html and make it $content$  
3. Take the default.html and replace the instances of $content$ on the template with index.html  
4. Export that as index.html  

The posts and stuff:  

1. Take the post's markdown data  
2. Pull out the metadata, called the 'context'  
3. Apply whatever templates you want to it  

Here's how I made the favorite section on the index: 
  
1. Add a favorite tag to the metadata of the post I want to favorite  
2. Make a new template called favorite-list  
3. Use the hakyll DSL syntax to make the template do the same thing as post-list but only if the favorite tag is present  
4. Add to index.html a partial that uses favorite-list  

Using pandocCompilerWith to make stuff like laTeX

\\[ \\ln x = \\int_{-\\infty}^x \\frac 1 y \\, dy . \\]

I followed this: http://travis.athougies.net/posts/2013-08-13-using-math-on-your-hakyll-blog.html
The idea is that you just need to set the proper extensions and options for pandoc's writing
