
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
  end;

  TEntity = record
    x: Integer;
    y: Integer;
    texture: PSDL_Texture;
  end;

var
  app: TApp;
  player: TEntity;

// ******************** implementation ********************
implementation

end.
