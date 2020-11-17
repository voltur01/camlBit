open CamlBit

let x = ref 2
let y = ref 2

let reset_position () = 
  x := Random.int 4;
  y := Random.int 4

let () =
  Random.init(running_time());
  while true do
    Display.set_pixel !x !y false;
    if ButtonA.is_pressed() && ButtonB.is_pressed() then
      reset_position()
    else if ButtonA.is_pressed() then
      x := max (!x - 1)  0
    else if ButtonB.is_pressed() then
      x := min (!x + 1) 4;
    Display.set_pixel !x !y true;
    sleep(200)
  done
