
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Structs;

{$Mode objfpc}
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
    up: Boolean;
    down: Boolean;
    left: Boolean;
    right: Boolean;
    fire: Boolean;
  end;

  TEntity = record
    x: Integer;
    y: Integer;
    dx: Integer;
    dy: Integer;
    health: Boolean;
    texture: PSDL_Texture;
  end;

// ******************** implementation ********************
implementation

end.
