
unit structs;

{$mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2;

type
  TApp = record
    renderer: PSDL_Renderer;
    window: PSDL_Window;
    up, down, left, right: Boolean;
    fire: Boolean;
  end;

  TEntity = record
    x, y: Integer;
    dx, dy: Integer;
    health: Boolean;
    texture: PSDL_Texture;
  end;

var
  app: TApp;
  player: TEntity;
  bullet: TEntity;

// ******************** implementation ********************
implementation

end.
