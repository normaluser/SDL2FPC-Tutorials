
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.App;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs;

// ******************** type ********************
type
  ILogicAndRender = interface
    ['{2EC79BCE-AC61-4E51-B187-1C5C9850ED0C}']
    procedure logic;
    procedure draw;
  end;

  TApp = class(TObject)
    public
      renderer: PSDL_Renderer;
      window: PSDL_Window;
      keyboard: array[0..MAX_KEYBOARD_KEYS] of Integer;

      delegate: ILogicAndRender;

      constructor create;
      destructor destroy; override;
  end;

// ******************** var ********************
var
  app: TApp;

procedure initApp;

// ******************** implementation ********************
implementation

uses
  {rtl}
  sysutils,
  {sdl2}
  sdl2_image;

// 
constructor TApp.create;
var
  i: Integer;
  rendererFlags: Integer;
  windowFlags: Integer;
begin
  inherited;

  // keyboard init
  for i := 0 to MAX_KEYBOARD_KEYS do
    keyboard[i] := 0;

  rendererFlags := SDL_RENDERER_ACCELERATED;
  windowFlags := 0;

  if SDL_Init(SDL_INIT_VIDEO) < 0 then
  begin
    WriteLn(Format('Couldn''t initialize SDL: %s', [SDL_GetError()]));
    Halt(1);
  end;

  // window init
  window := SDL_CreateWindow('Shooter',
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SCREEN_WIDTH,
                                  SCREEN_HEIGHT,
                                  windowFlags);
  if window = NIL then
  begin
    WriteLn(Format('Failed to open %d x %d window: %s', [SCREEN_WIDTH, SCREEN_WIDTH, SDL_GetError()]));
    Halt(1);
  end;

  SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, 'linear');

  // renderer init
  renderer := SDL_CreateRenderer(window, -1, rendererFlags);
  if renderer = NIL then
  begin
    WriteLn(Format('Failed to create renderer: %s', [SDL_GetError()]));
    Halt(1);
  end;

  IMG_Init(IMG_INIT_PNG or IMG_INIT_JPG);
end;

// 
destructor TApp.destroy;
begin
  IMG_Quit;

  SDL_DestroyRenderer(renderer);

  SDL_DestroyWindow(window);

  SDL_Quit;
  inherited destroy;
end;

procedure initApp;
begin
  app := TApp.create;
end;

end.
