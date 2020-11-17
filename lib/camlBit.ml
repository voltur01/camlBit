(** CamlBit (stylized as [caml:bit]) is an OCaml module to program [micro:bit]. 
  CamlBit tries to keep API similar to MicroPython for [micro:bit]. *)

(** Pauses execution for a specified period of time.
  - [ms] Number of milliseconds to pause execution for. *)
let sleep (ms: int): unit = Microbit_prims.delay ms

(** Provides the up time.
  @return the up time in milliseconds. *)
let running_time (): int = Microbit_prims.millis ()

(** Defines the onboard button interface. *)
module type Button = sig
  (** @return [true] is the button is pressed, [false] otherwise. *)
  val is_pressed: unit -> bool
end

(** Implements the button interface for the hardware button A.*)
module ButtonA : Button = struct
  let is_pressed (): bool = Microbit_prims.button_is_pressed 0
end

(** Implements the button interface for the hardware button B.*)
module ButtonB : Button = struct
  let is_pressed (): bool = Microbit_prims.button_is_pressed 1
end

(** Defines the onboard LED display interface. *)
module Display = struct
  (** Clears the display, i.e. turns all LEDs off. *)
  let clear (): unit = Microbit_prims.clear_screen ()

  (** Turns the corresponding LEDs on or off. 
    - [x] X coordinate, 0..4, left to right.
    - [y] Y coordinate, 0..4, top to bottom.
    - [turn_on] [True] or [False] to turn the LEDon or off.
    *)
  let set_pixel (x: int) (y: int) (turn_on: bool): unit = Microbit_prims.write_pixel x y turn_on

  (*let get_pixel (x: int) (y: int): int = TODO *)
  
  (** Shows a string on the display by scrolling it, if needed. 
    - [s] The string to show
    *)
  let show_string (s: string): unit = Microbit_prims.print_string s

  (** Shows an image on the display. 
    - [ims] The image encoded into a string. Example: ["01010:01010:01010:01010:01010"] encodes two vertical lines.
    *)
  let show_image (ims: string): unit = Microbit_prims.print_image (
      let no_colons = String.split_on_char ':' ims |> String.concat "" in
      let digits_to_numbers = String.map (fun ch -> if ch == '0' then '\x00' else '\x01') no_colons in
        Bytes.of_string digits_to_numbers)
end

(** Defines supported GPIO pins. *)
type pin = PIN0 | PIN1 | PIN2 | PIN8 | PIN12 | PIN16

(** Coverts a PIN into an internal representation. TODO: hide. 
  - [pin] The PIN.
  
  @return Internal PIN number. *)
let pin_num pin = match pin with
  | PIN0 -> 0
  | PIN1 -> 1
  | PIN2 -> 2
  | PIN8 -> 3
  | PIN12 -> 4
  | PIN16 -> 5

(** Defines a module to work with GPIO ports. *)
module GPIO = struct
  (** Sets the mode of operation for a PIN: read or write. TODO: define the mode type. 
    - [pin] The PIN to configure. 
    - [mode] The mode to set. *)
  let set_pin_mode (pin: pin) (mode: int): unit = Microbit_prims.pin_mode (pin_num pin) mode (* TODO *)

  (** Writes a digital output. 
    - [pin] The PIN to write to.
    - [v] The digital value to write: [0] or [1].*)
  let write_digital (pin: pin) (v: int): unit = Microbit_prims.digital_write (pin_num pin) v

  (** Reads a digital inpit. 
    - [pin] The PIN to read.
    
    @return The read value: [0] or [1].*)
  let read_digital (pin: pin): int = if Microbit_prims.digital_read (pin_num pin) then 1 else 0

  (** Writes an analog output. 
    - [pin] The PIN to write to.
    - [v] The value to write: [0..1023]. *)
  let write_analog (pin:pin) (v: int): unit = Microbit_prims.analog_write (pin_num pin) v

  (** Reads an analog input.
    - [pin] The PIN to read from.
    
    @return The analog value: [0..1023]. *)
  let read_analog pin = Microbit_prims.analog_read (pin_num pin)
end

(** Defines the signature for a PIN module. *)
module type PinBase = sig
  val pin: int
  val write_digital: int -> unit
  val read_digital: unit -> int
  val write_analog: int -> unit
  val read_analog: unit -> int
end

(** Implements the PIN0 module. *)
module Pin0: PinBase = struct
  (** Internal representation of the PIN number. *)
  let pin: int = 0

  (** Writes a digital output. 
    - [v] The value to write: [0] or [1].*)
  let write_digital (v: int): unit = Microbit_prims.digital_write pin v

  (** Reads a digital input. 
    @retrun The read value: [0] or [1].*)
  let read_digital (): int = if Microbit_prims.digital_read pin then 1 else 0

  (** Writes an analog output.
    - [v] The value to write: [0..1023]. *)
  let write_analog (v: int): unit = Microbit_prims.analog_write pin v

  (** Reads an analog input.
    @return The value read: [0..1023]. *)
  let read_analog() = Microbit_prims.analog_read pin
end

(** A functor to generate a sequence of PIN modules to cover all PINs. *)
module NextPin (P: PinBase): PinBase = struct
  let pin = P.pin + 1
  let write_digital = P.write_digital
  let read_digital = P.read_digital
  let write_analog = P.write_analog
  let read_analog = P.read_analog
end

(** Implements the PIN1 module. *)
module Pin1 = NextPin(Pin0)

(** Implements the PIN2 module. *)
module Pin2 = NextPin(Pin1)

(** Implements the PIN8 module. *)
module Pin8 = NextPin(Pin2)

(** Implements the PIN12 module. *)
module Pin12 = NextPin(Pin8)

(** Implements the PI16 module. *)
module Pin16 = NextPin(Pin12)

(** Defines the serial port module. *)
module Uart = struct
  (** Reads one char from the serial port. 
    @return The char read.*)
  let read(): char = Microbit_prims.serial_read()

  (** Writes one char to the serial port. 
    - [ch] The char to write.*)
  let write (ch: char):unit = Microbit_prims.serial_write ch

  (** Reads a line from the serial port. 
    @return The string read. *)
  let read_line(): string = Microbit_prims.serial_read_string()

  (** Writes a line to the serial port. 
    - [ln] The string to write. *)
  let write_line (str: string): unit = Microbit_prims.serial_write_string str

  (** Prompts for an input from the serial port by printing the provided message and reading a line. 
    - [message] The message to print to the serial line.

    @return The line read from serial port. *)
  let prompt (message: string) :string = 
      write_line message; 
      read_line()
end

(** Defines the Debug module.*)
module Debug = struct
  (** Writes a tracing message via UART and returns the passed value.
    Is convenient to use inside expressions to preserve the original type of the return value.
    - [msg] The message to write.
    - [a] The value to return. 
    
    @return [a]. *)
  let trace (msg: string) a = 
    Uart.write_line msg; 
    Uart.write_line "\n"; 
    a

  (** Writes a log messages via UART.
    - [msg] The message to write.
  *)
  let log (msg: string): unit = Uart.write_line msg

  (** Writes a log messages and a formatted integer values via UART.
    - [msg] The message to write.
    - [ivalue] The integer value to write.
  *)
  let log_int (msg:string) (ivalue: int): unit = 
    Uart.write_line msg; 
    Uart.write_line (string_of_int ivalue)
end

(** Defines a simple game main loop. *)
module Game = struct
  (** Runs a game using provided initial state and handling functions.
    - [update] The function to update the game state based on time.
    - [draw] The function to draw the game on the Display.
    - [handle_buttons] The function to update the game state based on buttons pressed.
    - [state] The initial game state. *)
  let rec run (update: 's -> 's) (draw: 's -> unit) (handle_buttons: 's -> bool -> bool -> 's) (state: 's): unit = 
    draw state;
    sleep(250);
    let next_state = handle_buttons state (ButtonA.is_pressed()) (ButtonB.is_pressed()) |> update in
      (run[@tailcall]) update draw handle_buttons next_state
end

let () = ()
