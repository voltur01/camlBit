open CamlBit

let () =
  while true do
    (* using specific pins *)
    for i = 1 to 10 do
      Pin0.write_digital 1;
      sleep 250;
      Pin0.write_digital 0
    done;

    (* using a list of pins *)
    let blink pin = 
      GPIO.write_digital pin 1;
      sleep 250;
      GPIO.write_digital pin 0 in
        for i = 1 to 10 do
          List.iter blink [PIN0; PIN1; PIN2]
        done
  done
