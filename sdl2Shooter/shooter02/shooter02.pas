{
  Opening a SDL2 - Window
  author: shenchunqian
  created: 2023-02-27
}

program shooter02;

{$mode objfpc}
{$h+}

uses
  {sdl2}
  sdl2,
  {shooter02}
  defs, structs, init, draw, input;

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

begin
  if not initSDL then
    Exit;

  player.x := 100;
  player.y := 100;
  player.texture := loadTexture('gfx/player.png');

  AddExitProc(@atExit);

  while true do
  begin
    prepareScene;
    if not doInput then
      Exit;

    blit(player.texture, player.x, player.y);
    presentScene;
    SDL_Delay(16);
  end;

end.
