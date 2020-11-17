# `caml:bit`

`caml:bit` is an [OCaml](https://ocaml.org/) library to program [BBC micro:bit](https://microbit.org/), that is to run OCaml bytecode directly on the BBC micro:bit.

`caml:bit` relies on the OCaml runtime provided by the [OMicroB](https://github.com/stevenvar/OMicroB) project.

`caml:bit` tries to mimic the [MicroPython](https://micropython.org/) API for the BBC micro:bit, see [micro:bit Micropython API](https://microbit-micropython.readthedocs.io/en/latest/microbit_micropython_api.html).

## Why OCaml on the BBC micro:bit?

BBC micro:bit can be programmed in either the block based Microsoft MakeCode IDE or MicroPython. 

Blocks are a good way for kids without prior programming experience to start, however become limiting very quickly.

MicroPython is nice, except for the lack of a compilation step: in order to resolve a typo in a varibale name one has to actually flash the device, observe the scrolling (i.e. unreadable) error message on the 5x5 pixel screen, connect the UART, reset the device, reproduce the error, then _ta-da!_ see the full error message in the console and fix the problem.

From this point of view, OCaml has the following benefits:
* It uses syntax similar to Python, so it maintains the level of readability and expressiveness.
* It may have type annotations, but even without them, OCaml always does full static type checking using inferred types, so spots all the typos and more.
* It uses Algebraic Data Types as the core if its type system that combine simple mathematical concepets into powerful static verification tools, so helps prevent many types of logical errors.
* It compiles to compact and efficient bytecode, so delivers very good performance.

Here is a very detailed analysis for the curious [Python to OCaml: Retrospective](https://roscidus.com/blog/blog/2014/06/06/python-to-ocaml-retrospective/).

## How to use it

Note: This is not kids friendly yet, thus would require an adult support.

### Prerequisites

1. A Linux computer, e.g. Ubuntu 20.04.
1. _Requirements_ of [OMicroB](https://github.com/stevenvar/OMicroB).

Nice to have:

1. [Visual Studio Code](https://code.visualstudio.com/) with [OCaml plugin](https://github.com/hackwaly/vscode-ocaml) using Merlin to edit OCaml code.

    Note: Yes, there is a complete mess in the pugins with circular references of deprecation, but this one worked nicely for me.

1. [QEMU](https://www.qemu.org/) to run examples in the BBC micro:bit emulator.

### Steps

1. Clone the repository.

    ```console
    $ git clone
    ```

1. Configure the library.

    ```console
    ./configure
    ```

    What it does:
    - Checks out the `camlbit` branch from a fork of OMicroB with few extra patches.
    - Runs ```configure``` for OMicroB.
    - Runs ```make``` for OMicroB.
    - Copies Makefile settings from OMicroB to `caml:bit`.

1. Build the reference documentation.

    ```console
    make docs
    ```

    What it does:
    - Creates `docs/camlBit` folder with `caml:bit` reference documentation.
    - Creates `docs/stdlib` folder with the provided version of the OCaml standard library reference documentation.


1. Build the examples.

    ```console
    make
    ```

1. Run the examples.

    Some examples can be run with QEMU, however the real BBC micro:bit should be used to see and make use of all the features.

    Copy the resulting `*.hex` file to your BBC micro:bit via USB, see [How do I transfer my code onto the micro:bit via USB](https://support.microbit.org/support/solutions/articles/19000013986-how-do-i-transfer-my-code-onto-the-micro-bit-via-usb).

1. Create your own programs.

    Copy one of the examples and start hacking using e.g. Visual Studio Code.

    Consult the generated reference documentation for available OCaml standard library and `caml:bit` library features.
