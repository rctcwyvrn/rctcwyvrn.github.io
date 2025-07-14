+++
title = "Day 1: Scoping out the project"
authors = ["rctcwyvrn"]

[extra]
terrarium_tag = "yes"
blurb = "Figuring out the basics"
+++

New beginnings are always so exciting!

What did I do today?

Spend like three hours setting up mastodon and this blog properly

Haha

Very productive

Anyway

# Terrarium

[Terrarium](https://github.com/rctcwyvrn/terrarium) is the working title for the project that I'd like to work on every day for the next year or so

The gist is that I'd like to create a Hubris/MirageOS inspired unikernel compiler that can compile OCaml programs into bootable kernels

This is extreme hubris

# What I envision

Here's what I have in mind, using the example of a webserver

1. You write a web server in OCaml

Using a copy of something like [https://github.com/anuragsoni/shuttle_http](https://github.com/anuragsoni/shuttle_http) 

2. The http library calls into `soil`

`soil` being the equivalent of `core_unix` for terrarium, giving an interface for OS functionality

Running example: our http library calls `Soil.pipe` on a `Soil.File_descriptor.t`

3. `soil` calls into libraries also written in OCaml which implement the OS

A `Soil.File_descriptor.t` is just an OCaml datatype and provides functions for storing data to disk

`soil` implements storing data to disk by calling into OCaml driver libraries

4. An OCaml driver library flushes the bytes to disk 

I Have No Idea How Drivers Work :smile:

But the idea is that it would be an `async` based interface, meaning it would do async stuff to return a `Deferred.t` in place of the blocking task of reading/writing bytes from/to disk

# Why do I think this could work?

From my very naive understanding, OCaml makes for a decent OS runtime
- It's designed to compile to a single static binary
- The garbage collector can clean up all the memory if everything is an OCaml object
- The `async` runtime can handle threading if the entire program is just one giant async scheduler + async jobs

# What do I need?

This is a classic situation of not knowing what I don't know

Here is what I do know that I'll need

## Something to boot

Bootloading is something I'm not at all familiar with, but the plan will be to write this in Rust (ala [https://github.com/gamozolabs/chocolate_milk](https://github.com/gamozolabs/chocolate_milk))

I expect to steal a lot from that project

## An OCaml compiler pipeline

I'm not doing OCaml parsing and typechecking (been there, done that, it didn't end well - that's how this project died it's first death) so the plan will be to write a compiler pipeline starting from **OCaml Lambda** and compiling down to x86

Important reference: [https://github.com/stedolan/malfunction](https://github.com/stedolan/malfunction)

This will probably be structured somewhat like the [UBC CPSC 411 compiler](https://github.com/cpsc411/cpsc411-book) since that's a compiler I've already implemented once before

Another reference I'll be using is Compiling with Continuations (probably)

## Soil

A library that implements `core_unix`-like functionality by calling into...

## Driver libraries

A set of driver libraries that can drive network IO, disk, and displays

# Steal ideas from

The obvious two
1. [Hubris](https://hubris.oxide.computer/reference/) 

Hubris uses IPC and tasks with one supervisor task to handle running things. I want to have the OCaml async runtime and the OCaml calling convention handle that for me

2. [MirageOS](https://mirage.io/) 

MirageOS is honestly probably extremely similar to what I have in mind (possibly identical, I haven't actually dug that deep into it yet). Even if what I'm making is just MirageOS, I want to make it my own

# Milestones

## Bootloader
1. Something that boots in qemu and writes "hi" to the display

Requirements:
- A bootloader (in rust and asm)
- A display driver (in ocaml)


## Compiler
1. A runnable hello world in lambda-lite (a stripped down ocaml-lambda)

Requirements: A compiler from lambda-lite to x86

2. A runnable ocaml hello world 

Requirements: A full fat ocaml-lambda compiler, hooked up to the ocaml frontend, running the ocaml runtime

3. Compiling `base` and `async`: A runnable ocaml hello world under an `async` `Command.t`

## First boot test
1. Something that boots in qemu and writes an ocaml string to the display

Requirements: Taping the ocaml compiler to the bootloader

## Building libraries
1. Start writing `soil` (implementing an interface around the display driver)
2. Write a keyboard driver (in ocaml) and its `soil` interface
3. Write an `echo` program which just takes keyboard input and writes it to display

## Http server
1. Write a network driver (in ocaml) and its `soil` interface
2. Write a http/af backend using `soil`
3. Host a hello world blog post using `terrarium`

# Todo tomorrow
- Dig into MirageOS
- Re-listen to the Hubris Oxide & Friends podcast episode
- Poke around `chocolate-milk`
- Read [https://www.sigarch.org/leave-your-os-at-home-the-rise-of-library-operating-systems/](https://www.sigarch.org/leave-your-os-at-home-the-rise-of-library-operating-systems/) and [https://events19.linuxfoundation.org/wp-content/uploads/2017/12/Library-OS-is-the-New-Container-Why-is-Library-OS-A-Better-Option-for-Compatibility-and-Sandboxing-Chia-Che-Tsai-UC-Berkeley.pdf](https://events19.linuxfoundation.org/wp-content/uploads/2017/12/Library-OS-is-the-New-Container-Why-is-Library-OS-A-Better-Option-for-Compatibility-and-Sandboxing-Chia-Che-Tsai-UC-Berkeley.pdf)
- Poke around [https://github.com/gramineproject/gramine](https://github.com/gramineproject/gramine)