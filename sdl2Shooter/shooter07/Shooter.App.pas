
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.App;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {shooter}
  Shooter.Structs;

var
  app: TApp;


function createEntity: PEntity;

procedure disposeEntity(e: PEntity);

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
