open CamlBit

type base = { x: int }
type bullet = { x: int; y: int }
type alien = { x: int; y: int }
type tick = int
type game_state = {
  base: base;
  bullets: bullet list;
  aliens: alien list;
  ticks: tick
}

let update_bullets (state: game_state): game_state = 
  {state with 
    bullets = state.bullets 
        |> List.filter (fun (b: bullet): bool -> b.y > 0) (* filter out ones that left the screen *)
        |> List.map (fun (b: bullet): bullet -> {b with y = b.y - 1}); (* move the rest up *)
    aliens = state.aliens |> List.filter (
        fun a -> (List.find_opt (fun (b: bullet) -> b == {x = a.x; y = a.y}) state.bullets) == None)
  }

let update_aliens (state: game_state): game_state =
  match state.ticks with
  | 1 -> {state with aliens = {x = (Random.int 4); y = 0} :: state.aliens} (* add a new alien *)
  | 5 -> {state with aliens = (* randomly move them left ot right *)
        List.map (fun (a: alien): alien -> {a with x = a.x + ((Random.int 2)-2)}) state.aliens}
  | 10 -> {state with aliens = state.aliens
      |> List.filter (fun (a: alien): bool -> a.y < 4) (* filter out ones that left the screen *)
      |> List.map (fun (a: alien): alien -> {a with y = a.y + 1}) } (* move the rest down *)
  | _ -> state

let update_ticks (state: game_state): game_state = 
  match state.ticks with
    | 10 -> {state with ticks = 0} (* reset after 10 ticks *)
    | _ -> {state with ticks = state.ticks + 1}

let update (state: game_state): game_state = 
  state |> update_bullets |> update_aliens |> update_ticks

let draw (state: game_state): unit = 
  Display.clear();
  Display.set_pixel state.base.x 4 true;
  List.iter (fun (b: bullet) -> Display.set_pixel b.x b.y true) state.bullets;
  List.iter (fun (a: alien) ->  Display.set_pixel a.x a.y true) state.aliens

let handle_buttons (state: game_state) (a_pressed: bool) (b_pressed: bool): game_state = 
  if a_pressed && b_pressed then (* A+B to fire! *)
    {state with bullets = {x = state.base.x; y = 3} :: state.bullets}
  else if a_pressed && state.base.x > 0 then (* A to move left *)
  {state with base = {x = state.base.x - 1}}
  else if b_pressed && state.base.x < 4 then (* B to move right *)
  {state with base = {x = state.base.x + 1}}
  else state

let () =
  Random.init(running_time());
  Game.run update draw handle_buttons {base = {x = 2}; bullets = []; aliens = []; ticks = 0}
