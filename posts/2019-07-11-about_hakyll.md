---
title: How does Hakyll work?
author: rctcwyvrn
---

How does Hakyll work? A quick rundown from someone completely new to both web design _and_ haskell.

After you create and build the project you have the following
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

