
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Util;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

function collision(x1, y1, w1, h1, x2, y2, w2, h2: Double): Boolean;

// ******************** implementation ********************
implementation

uses
  {shooter}
  Shooter.Defs;

function collision(x1, y1, w1, h1, x2, y2, w2, h2: Double): Boolean;
begin
  if (MAX(x1, x2) < MIN(x1 + w1, x2 + w2)) and (MAX(y1, y2) < MIN(y1 + h1, y2 + h2)) then
    Result := true
  else
    Result := false;
end;

end.
