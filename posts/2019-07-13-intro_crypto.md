---
title: A brief introduction to modern cryptography
author: rctcwyvrn
abit_tag: yes
---

Cryptography has always been about one goal: Making a system for communicating between two parties securely. As the internet has grown and hackers have gotten smarter, the systems to keep secrets have gotten more and more complex to combat them.



Here is a basic rundown of the foundational concepts in cryptography in terms of the problem they aim to solve. This outlines (sort of) how cryptography was developed, 

1. New technique/idea/system
2. Problems with the new system
3. New techniques/ideas/systems to solve the new problems
4. Repeat



**Problem**: If someone gets ahold of my message then they can read its contents

**Solution**: Encryption. Encryption is the idea that the message can be "locked" in such a way that anyone who reads it without the key can't determine the original message. There are two ways to do encryption, one that works as you would expect and one that seems to work by mathematical magic.



Symmetric key ciphers
---

The seemingly obvious way first: Symmetric key ciphers. You and your partner have an identical key, you lock the message and send it to them, which they can then unlock. Anyone without the key has no way of opening the message because they don't have the key. Examples of this type of cipher include AES-256 and RC4. But this introduces a new problem:



**Problem**: How do you get you and your partner to have the same key?

**Solution**: Key exchanges. 



Public key exchange
----

The core idea of key exchange protocols is that both parties mix together their secret keys with some public value, and exchange the results. Then you mix your secret with what your partner sent you (their secret mixed with some public value) and they do the same, leaving you both with both secrets mixed with the public value. 

The mathematical trick is that the mixing is irreversible, if someone were to steal the secret mixed with public value, they would be unable to extract the secret out of it. The common metaphor is mixing two colours together, it's very difficult to extract out what the two original colours were without just brute force.



Now everything should be fine right?  

**Problem**: How do you know that the person you're talking to is your partner? How do you know that the message hasn't been tampered with? 

If you're having trouble imagining how this could possibly happen, imagine the same public key exchange, but with someone in the middle pretending to be your partner while your real partner is wondering why you haven't sent them anything. You and the middle-man end up establishing a key and then you end up sending messages to them that they can unlock with the key you just established with them.



**Solution**:Remember how I mentioned there were two ways of doing encryption? The solution to this problem is the other form of encryption, public key based encryption.



Public key encryption
----

Instead of explaining the math, here is how it works in practice. Imagine a wizard gave you two magic keys that had a simple property, whatever you locked with one key can _only_ be unlocked by the other key. 

You could then make duplicates of one of the keys (lets call it the public key) and give it to all of your friends, and keep the other one hidden away (called the private key). If friend A wants to send you a message they can lock it with the public key you gave them. The message is then safe from everyone but you, because only you have the the private key which is required to unlock it.



Now to solve the problem of man-in-the-middle attacks on key exchanges you can just slightly modify the procedure.

1. Mix your secret with the public value
2. Lock it with your _private_ key
3. Send it to your partner
4. Your partner can then try to unlock it with the public key you gave them
5. If it unlocks properly then your partner knows the message was from you, because only you have that private key
6. Continue as normal

This procedure is called "signing".



The magical keys come from the magical land of mathematics, and range from points on curves to matrices to prime numbers. The most famous of them all is RSA. I am hesitant to even mention RSA because despite its fame and success during it's time, [it is now extremely dangerous](https://blog.trailofbits.com/2019/07/08/fuck-rsa/). The one you should use is Elliptical Curve Cryptography.

So everything should be fine now right?

**Problem**: This one is kinda complicated. The obvious problem is that most public key encryption is slow. The other problem is that RSA keys are not ephemeral, ie randomly generated. Rather public/private keys are stored for potentially months at a time. This means that if someone steals your private key, they can use it for a long time to lots of bad things.

**Solution**: Use public key encryption to initially get a randomly generated shared secret secured between the parties, and then use MACs to guarentee sender identity and message integrity afterwards.


Message authentication codes (MACs)
----

The goal is to attach something to each message that an attacker cannot replicate, so you know to not accept any messages that does not have the correct tag. The tag needs to do two things, it needs to be unique for each message and contain information that only your partner would know (some predetermined secret). The tag also needs to be made in such a way so that an attacker can't stop a message and pull out the secret from it.



_Method 1_: Use a cipher. The basic idea is that you can just lock the message and send both the message and it's locked version. When your partner receives it they can just unlock and see if it matches the other message. (It's a bit more complicated than that though)



_Method 2_: Use a cryptographic hash function.

Hashing functions
----

Cryptographic hash functions are functions that take any message of any length and convert it to a fixed length, say 16 bytes, of data. They also have the unique property that if the original message is even slightly different, the result will be completely different. This means that the only way to get the original message from the resulting 16 bytes is to test all possible messages until you get one that hashes to the desired result. 



Now to make a MAC from this you can mix the message with the secret and then hash it. Then when your partner receives it they can mix the message with the secret in the same way and check that the hash is correct. If an attacker wants to change the message or pretend to be you, then they need to have the secret.




That should be the basic rundown for the core concepts of cryptography. Here is everything we talked about summed up in the standard way connections are secured over the internet, TLS.

A client wants to talk to a server securely
1. The client generates a random number, and the public value mixed with that random number (Diffie-Hellman key exchange)
2. The client encrypts this with the server's public key (So the client knows only the server could decrypt it)
3. The server does the same steps for the key exchange
4. Both parties calculate a shared secret, which was just randomly generated
5. Both parties then use that key to encrypt everything they send between each other (AES encryption)
6. They also include a MAC that guarentees the message's integrity and the sender's identity (HMAC)


Important thing not mentioned: Certificates and certificate authorities, look them up if you're curious, it's basically a third party that vouches for the server.


**To look further**:

- Wikipedia
- Computerphile videos detailing Diffie-hellman key exchanges and man in the middle attacks
- https://cryptopals.com/ for a whirlwind tour of how to break cryptography. Note: side effects include a sense of dread when realizing most security code is written poorly and even small mistakes lead to broken systems.