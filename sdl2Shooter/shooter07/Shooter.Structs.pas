
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Structs;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs;

type
  TDelegate = record
    logic: procedure;
    draw: procedure;
  end;

  TApp = record
    renderer: PSDL_Renderer;
    window: PSDL_Window;
    delegate: TDelegate;
    keyboard: array[0..MAX_KEYBOARD_KEYS] of Integer;
  end;

  PEntity = ^TEntity;
  TEntity = record
    x: Double;
    y: Double;
    w: Integer;
    h: Integer;
    dx: Double;
    dy: Double;
    health: Boolean;
    reload: Integer;
    side: Integer;
    texture: PSDL_Texture;
    next: PEntity;
  end;

// ******************** implementation ********************
implementation

end.
