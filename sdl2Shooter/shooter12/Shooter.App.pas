
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.App;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {shooter}
  Shooter.Structs;

// ******************** var ********************
var
  app: TApp;

function createEntity: PEntity;
function createExplosion: PExplosion;
function createDebris: PDebris;

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
    health := 0;
    reload := 0;
    side := 0;
    Texture := Nil;
    next := Nil;
  end;
  Result := e;
end;

// 
function createExplosion: PExplosion;
var
  e: PExplosion;
begin
  New(e);
  with e^ do
  begin
    x := 0.0;
    y := 0.0;
    dx := 0.0;
    dy := 0.0;
    r := 0;
    g := 0;
    b := 0;
    a := 0;
    next := Nil;
  end;
  Result := e;
end;

// 
function createDebris: PDebris;
var
  e: PDebris;
begin
  New(e);
  with e^ do
  begin
    x := 0.0;
    y := 0.0;
    dx := 0.0;
    dy := 0.0;
    rect.x := 0;
    rect.y := 0;
    rect.w := 0;
    rect.h := 0;
    texture := nil;
    life := 0;
    next := Nil;
  end;
  Result := e;
end;

end.
