
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

program main;

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

  player.x := 100;
  player.y := 100;
  player.texture := loadTexture('gfx/player.png');

  bullet.texture := loadTexture('gfx/playerBullet.png');

  AddExitProc(@atExit);

  while true do
  begin
    prepareScene;
    if not doInput then
      Exit;

    player.x := player.x + player.dx;
    player.y := player.y + player.dy;

    if app.up then player.y := player.y - 4;
    if app.down then player.y := player.y + 4;
    if app.left then player.x := player.x - 4;
    if app.right then player.x := player.x + 4;

    if app.fire and not bullet.health then
    begin
      bullet.x := player.x;
      bullet.y := player.y;
      bullet.dx := 16;
      bullet.dy := 0;
      bullet.health := true;
    end;

    bullet.x := bullet.x + bullet.dx;
    bullet.y := bullet.y + bullet.dy;

    if bullet.x > SCREEN_WIDTH then
      bullet.health := false;

    blit(player.texture, player.x, player.y);

    if bullet.health then
      blit(bullet.texture, bullet.x, bullet.y);

    presentScene;
    SDL_Delay(16);
  end;

end.
