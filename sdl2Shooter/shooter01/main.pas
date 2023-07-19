
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program shooter01;

{$mode objfpc}
{$h+}

uses
  {sdl2}
  sdl2,
  {base}
  defs, structs, init, draw, input;

// 
procedure atExit;
begin
  SDL_DestroyRenderer(app.renderer);
  SDL_DestroyWindow(app.window);
  SDL_Quit;
  if ExitCode <> 0 then
    WriteLn(SDL_GetError)
  else
    WriteLn('Successful done.');
end;

// 
begin
  if not initSDL then
    Exit;
  AddExitProc(@atExit);

  while true do
  begin
    prepareScene;
    if not doInput then
      Exit;
    presentScene;
    SDL_Delay(16);
  end;

end.
