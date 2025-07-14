+++
title = "Exploring MirageOS"
authors = ["rctcwyvrn"]

[extra]
terrarium_tag = "yes"
blurb = "Digging around MirageOS internals"
+++

Ongoing blog post for digging into MirageOS

# Devices 

Devices: [https://github.com/mirage/mirage/tree/main/lib/devices](https://github.com/mirage/mirage/tree/main/lib/devices)

# Functoria
How MirageOS compiles the OCaml: [https://github.com/mirage/functoria](https://github.com/mirage/functoria)

```
Phases
Configuration is separated into phases:

Specialized DSL keys The specialized DSL's keys (along with functoria's keys) are resolved.
Compilation and dynlink of the config file.
Registering. When the register function is called, the list of jobs is recorded and immediately transformed into a graph.
Switching keys and tree evaluation. The switching keys are the keys inside the [If]. Those keys are resolved and the graph is simplified. At this point, the actual modules used are fully known. Note: for the describe command, Only partial evaluation is done, which means decision nodes are resolved only if the value was given on the command line, disregarding default values.
Full Key resolution. Once the actual modules are known, we can resolve all the keys and figure out libraries and packages.
Dependency handling, configuration and code emission.
Phases 1. to 4. are also applied for the clean command.
```

# `paf`

[https://github.com/dinosaure/paf-le-chien](https://github.com/dinosaure/paf-le-chien)

I wonder if I can steal `paf` as my http layer -> ie if the library can have it's entire backend swapped out for something else...

It kinda looks like the answer to that is yes?

```
Paf wants to provide an agnostic implementation of HTTP with the ability to launch a server or a client from an user-defined context: a Mimic.ctx. It does not exist one and unique way to use Paf because the context can be:

a MirageOS
a simple executable
something else like a JavaScript script (with js_of_ocaml)
```