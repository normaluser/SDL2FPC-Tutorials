
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program main;

{$Mode objfpc}
{$H+}

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs, Shooter.App, Shooter.Init, Shooter.Draw, Shooter.Input, Shooter.Stage;

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
procedure capFrameRate(var then_: Integer; var remainder: Double);
var
  wait, frameTime: Integer;
begin
  wait := 16 + Trunc(remainder);
  remainder := remainder - Trunc(remainder);
  frameTime := SDL_GetTicks - then_;
  wait := wait - frameTime;

  if wait < 1 then
    wait := 1;
  SDL_Delay(wait);
  remainder := remainder + 0.667;
  then_ := SDL_GetTicks;
end;

// 
var
  then_: Integer;
  remainder: Double;
begin
  if not initSDL then
    Exit;

  AddExitProc(@atExit);

  initStage;

  then_ := SDL_GetTicks;
  remainder := 0;

  while true do
  begin
    prepareScene;
    if not doInput then
      Exit;

    app.delegate.logic;

    app.delegate.draw;

    presentScene;
    capFrameRate(then_, remainder);
  end;

end.
