open CamlBit

let () =
  (* forever echo the UART input *)
  while true do
    let input_sting = Uart.prompt "? " in
      Uart.write_line (String.concat "\n" [""; input_sting; ""])
  done
