open CamlBit

let () =
  Display.show_string "Hello camlBit!";
  while true do
    if ButtonA.is_pressed() then
      Display.show_string "A";
    if ButtonB.is_pressed() then
      Display.show_string "B"
  done
