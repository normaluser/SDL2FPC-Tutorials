
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program main;

{$Mode objfpc}
{$H+}

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.App,
  Shooter.Init,
  Shooter.Draw,
  Shooter.Input;

// 
procedure atExit;
begin
  cleanUp;
  
  if ExitCode <> 0 then
    WriteLn(SDL_GetError)
  else
    WriteLn('Successful done.');
end;

// 
begin
  initSDL;

  AddExitProc(@atExit);

  while true do
  begin
    prepareScene;

    doInput;

    presentScene;
    
    SDL_Delay(16);
  end;

end.
