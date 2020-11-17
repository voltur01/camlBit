open CamlBit

let () =
  Random.init(running_time());
  Display.show_string "camlBit!";
  while true do
    Display.clear();
    Display.set_pixel (Random.int 4) (Random.int 4) true;
    sleep(100)
  done
