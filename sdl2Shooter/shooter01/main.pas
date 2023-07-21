
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program main;

{$Mode objfpc}
{$H+}

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs, Shooter.App, Shooter.Init, Shooter.Draw, Shooter.Input;

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
