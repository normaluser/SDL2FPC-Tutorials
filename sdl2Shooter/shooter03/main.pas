
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program main;

{$Mode objfpc}
{$H+}

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.App, Shooter.Init, Shooter.Draw, Shooter.Input;

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
  initSDL;

  player.x := 100;
  player.y := 100;
  player.texture := loadTexture('gfx/player.png');

  AddExitProc(@atExit);

  while true do
  begin
    prepareScene;
    doInput;

    if app.up then player.y -= 4;
    if app.down then player.y += 4;
    if app.left then player.x -= 4;
    if app.right then player.x += 4;

    blit(player.texture, player.x, player.y);
    presentScene;
    SDL_Delay(16);
  end;

end.
