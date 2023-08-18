
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
    texture: PSDL_Texture;
    next: PEntity;
  end;

procedure disposeAndNext(t: PEntity; ignore: PEntity);

function createEntity: PEntity;

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
procedure disposeAndNext(t: PEntity; ignore: PEntity);
var
  e: PEntity;
  prev: PEntity;
begin
  prev := t;
  e := t^.next;
  while e <> Nil do
  begin
    if (e <> ignore) then
    begin
      prev^.next := e^.next;
      Dispose(e);
      e := prev;
    end;
    prev := e;

    e := e^.next;
  end;
end;

end.
