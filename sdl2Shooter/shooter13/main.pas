
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program main;

{$Mode objfpc}
{$H+}

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.App,
  Shooter.Draw,
  Shooter.Input,
  Shooter.Stage,
  Shooter.Audio,
  Shooter.Text,
  Shooter.Background,
  Shooter.Highscores;

// 
procedure atExit;
begin
  audio.destroy;
  app.destroy;

  if ExitCode <> 0 then
    WriteLn(SDL_GetError)
  else
    WriteLn('Successful done.');
end;

// 
procedure capFrameRate(var then_: Integer; var remainder: Double);
var
  wait: Integer;
  frameTime: Integer;
begin
  wait := 16 + Trunc(remainder);
  remainder -= Trunc(remainder);

  frameTime := SDL_GetTicks - then_;
  wait -= frameTime;

  if wait < 1 then
    wait := 1;

  SDL_Delay(wait);
  remainder += 0.667;
  then_ := SDL_GetTicks;
end;

// ******************** var ********************
var
  then_: Integer;
  remainder: Double;
begin
  initApp;

  initBackground;

  initAudio;

  initFonts;

  initHighscores;

  AddExitProc(@atExit);

  then_ := SDL_GetTicks;
  remainder := 0;

  while true do
  begin
    prepareScene;

    doInput;

    if stage <> Nil then
    begin
      app.logic(stage as ILogicAndRender);

      app.draw(stage as ILogicAndRender);
    end;

    if (stage = Nil) and (highscores <> Nil) then
    begin
      app.logic(highscores as ILogicAndRender);

      app.draw(highscores as ILogicAndRender);
    end;

    presentScene;

    capFrameRate(then_, remainder);
  end;

end.
