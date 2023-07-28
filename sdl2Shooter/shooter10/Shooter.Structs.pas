
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

// ******************** type ********************
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

  PExplosion = ^TExplosion;
  TExplosion = record
    x: Double;
    y: Double;
    dx: Double;
    dy: Double;
    r: Integer;
    g: Integer;
    b: Integer;
    a: Integer;
    next: PExplosion;
  end;

  PDebris = ^TDebris;
  TDebris = record
    x: Double;
    y: Double;
    dx: Double;
    dy: Double;
    rect: TSDL_Rect;
    texture: PSDL_Texture;
    life: Integer;
    next: PDebris;
  end;

  TStar = record
    x: Integer;
    y: Integer;
    speed: Integer;
  end;

// ******************** implementation ********************
implementation

end.
