
unit structs;

{$mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2,
  {base}
  defs;

type
  TDelegate = record
    logic, draw: procedure;
  end;

  TApp = record
    renderer: PSDL_Renderer;
    window: PSDL_Window;
    delegate: TDelegate;
    keyboard: array[0..MAX_KEYBOARD_KEYS] of Integer;
  end;

  PEntity = ^TEntity;
  TEntity = record
    x, y: Double;
    w, h: Integer;
    dx, dy: Double;
    health: Boolean;
    reload: Integer;
    texture: PSDL_Texture;
    next: PEntity;
  end;

  TStage = record
    fighterHead, bulletHead: TEntity;
    fighterTail, bulletTail: PEntity;
  end;

function createEntity: PEntity;

procedure disposeEntity(e: PEntity);

var
  app: TApp;
  player: TEntity;
  stage_: TStage;

  bulletTexture: PSDL_Texture;

// ******************** implementation ********************
implementation

// 
function createEntity: PEntity;
var
  e: PEntity;
begin
  New(e);
  with e^ do
  begin
    x := 0.0;
    y := 0.0;
    dx := 0.0;
    dy := 0.0;
    h := 0;
    w := 0;
    health := false;
    reload := 0;
    Texture := Nil;
    next := Nil;
  end;
  Result := e;
end;

// 
procedure disposeEntity(e: PEntity);
begin
  Dispose(e);
end;

end.
