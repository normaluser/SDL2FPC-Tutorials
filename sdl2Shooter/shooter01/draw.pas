
unit draw;

{$mode objfpc}
{$H+}

{-------------------- interface --------------------}
interface

procedure prepareScene;
procedure presentScene;

{-------------------- implementation --------------------}
implementation

uses
  {sdl2}
  sdl2,
  {shooter01}
  structs;

procedure prepareScene;
begin
  SDL_SetRenderDrawColor(app.renderer, 96, 128, 255, 255);
  SDL_RenderClear(app.renderer);
end;

procedure presentScene;
begin
  SDL_RenderPresent(app.renderer);
end;

end.
