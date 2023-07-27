
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Init;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

procedure initSDL;
procedure cleanup;

// ******************** implementation ********************
implementation

uses
  {rtl}
  sysutils,
  {sdl2}
  sdl2,
  sdl2_image,
  {shooter}
  Shooter.Defs,
  Shooter.App;

// 
procedure initSDL;
var
  rendererFlags: Integer;
  windowFlags: Integer;
begin
  rendererFlags := SDL_RENDERER_ACCELERATED;
  windowFlags := 0;

  if SDL_Init(SDL_INIT_VIDEO) < 0 then
  begin
    WriteLn(Format('Couldn''t initialize SDL: %s', [SDL_GetError()]));
    Halt(1);
  end;

  app.window := SDL_CreateWindow('Shooter',
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SCREEN_WIDTH,
                                  SCREEN_HEIGHT,
                                  windowFlags);
  if app.window = NIL then
  begin
    WriteLn(Format('Failed to open %d x %d window: %s', [SCREEN_WIDTH, SCREEN_WIDTH, SDL_GetError()]));
    Halt(1);
  end;

  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');
  app.renderer := SDL_CreateRenderer(app.window, -1, rendererFlags);

  if app.renderer = NIL then
  begin
    WriteLn(Format('Failed to create renderer: %s', [SDL_GetError()]));
    Halt(1);
  end;

  IMG_Init(IMG_INIT_PNG or IMG_INIT_JPG);
end;

// 
procedure cleanup;
begin
  IMG_Quit;
  SDL_DestroyRenderer(app.renderer);
  SDL_DestroyWindow(app.window);
  SDL_Quit;
end;

end.
