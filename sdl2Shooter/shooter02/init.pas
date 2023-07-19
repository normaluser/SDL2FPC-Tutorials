
unit init;

{$mode objfpc}
{$H+}

// -------------------- interface --------------------
interface

function initSDL: Boolean;

procedure cleanup;

// -------------------- implementation --------------------
implementation

uses
  {rtl}
  sysutils,
  {sdl2}
  sdl2, sdl2_image,
  {base}
  structs, defs;

// 
function initSDL: Boolean;
var
  rendererFlags, windowFlags: Integer;
begin
  rendererFlags := SDL_RENDERER_ACCELERATED;
  windowFlags := 0;

  if SDL_Init(SDL_INIT_VIDEO) < 0 then
  begin
    WriteLn(Format('Couldn''t initialize SDL: %s', [SDL_GetError()]));
    Result := false;
    Exit;
  end;

  app.window := SDL_CreateWindow('Shooter 01',
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SCREEN_WIDTH,
                                  SCREEN_HEIGHT,
                                  windowFlags);
  if app.window = NIL then
  begin
    WriteLn(Format('Failed to open %d x %d window: %s', [SCREEN_WIDTH, SCREEN_WIDTH, SDL_GetError()]));
    Result := false;
    Exit;
  end;

  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');
  app.renderer := SDL_CreateRenderer(app.window, -1, rendererFlags);

  if app.renderer = NIL then
  begin
    WriteLn(Format('Failed to create renderer: %s', [SDL_GetError()]));
    Result := false;
    Exit;
  end;

  IMG_Init(IMG_INIT_PNG or IMG_INIT_JPG);

  Result := true;
  Exit;
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
