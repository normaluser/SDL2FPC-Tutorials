
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Draw;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2;

procedure prepareScene;
procedure presentScene;
procedure blit(texture: PSDL_Texture; x, y: Double);

function loadTexture(filename: String): PSDL_Texture;

// ******************** implementation ********************
implementation

uses
  {sdl2}
  sdl2_image,
  {shooter}
  Shooter.App;

// 
procedure prepareScene;
begin
  SDL_SetRenderDrawColor(app.renderer, 32, 32, 32, 255);
  SDL_RenderClear(app.renderer);
end;

// 
procedure presentScene;
begin
  SDL_RenderPresent(app.renderer);
end;

// 
procedure blit(texture: PSDL_Texture; x, y: Double);
var
  dest: TSDL_Rect;
begin
  dest.x := Trunc(x);
  dest.y := Trunc(y);

  SDL_QueryTexture(texture, NIL, NIL, @dest.w, @dest.h);
  SDL_RenderCopy(app.renderer, texture, NIL, @dest);
end;

// 
function loadTexture(filename: String): PSDL_Texture;
var
  texture: PSDL_Texture;
begin
  SDL_LogMessage(SDL_LOG_CATEGORY_APPLICATION, SDL_LOG_PRIORITY_INFO, 'Loading %s'#13, [PChar(filename)]);
  texture := IMG_LoadTexture(app.renderer, PChar(filename));
  Result := texture;
end;

end.
