
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
procedure blitRect(texture: PSDL_Texture; src: PSDL_Rect; x, y: Double);

function loadTexture(filename: String): PSDL_Texture;

// ******************** implementation ********************
implementation

uses
  {rtl}
  sysutils,
  {sdl2}
  sdl2_image,
  {shooter}
  Shooter.App,
  Shooter.Structs;

procedure addTextureToCache(name: String; sdlTexture: PSDL_Texture); FORWARD;

function getTexture(name: String): PSDL_Texture; FORWARD;

// 
procedure prepareScene;
begin
  SDL_SetRenderDrawColor(app.renderer, 32, 32, 32, 255);
  SDL_RenderClear(app.renderer);
end;

// 
function getTexture(name: String): PSDL_Texture;
var
  t: PTexture;
begin
  t := app.textureHead.next;
  while t <> Nil do
  begin
    if Comparestr(t^.name, name) = 0 then
    begin
      Exit(t^.texture);
    end;
    t := t^.next;
  end;

  Result := Nil;
end;

// 
procedure addTextureToCache(name: String; sdlTexture: PSDL_Texture);
var
  texture: PTexture;
begin
  texture := createTexture;

  app.textureTail^.next := texture;
  app.textureTail := texture;

  texture^.name := name;
  texture^.texture := sdlTexture;
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
procedure blitRect(texture: PSDL_Texture; src: PSDL_Rect; x, y: Double);
var
  dest: TSDL_Rect;
begin
  dest.x := Trunc(x);
  dest.y := Trunc(y);
  dest.w := src^.w;
  dest.h := src^.h;

  SDL_RenderCopy(app.renderer, texture, src, @dest);
end;

// 
function loadTexture(filename: String): PSDL_Texture;
var
  texture: PSDL_Texture;
begin
  texture := getTexture(filename);
  if texture = Nil then
  begin
    SDL_LogMessage(SDL_LOG_CATEGORY_APPLICATION, SDL_LOG_PRIORITY_INFO, 'Loading %s'#13, [PChar(filename)]);
    texture := IMG_LoadTexture(app.renderer, PChar(filename));
    addTextureToCache(filename, texture);
  end;

  Result := texture;
end;

end.
