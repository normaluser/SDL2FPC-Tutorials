
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Defs;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

const
  SCREEN_WIDTH = 1024;
  SCREEN_HEIGHT = 576;

  FPS = 60;

  PLAYER_SPEED = 4;
  PLAYER_BULLET_SPEED = 20;
  ALIEN_BULLET_SPEED = 8;

  MAX_KEYBOARD_KEYS = 350;

  SIDE_PLAYER = 0;
  SIDE_ALIEN = 1;

  MAX_STARS = 500;

function MIN(a, b: Double): Double; inline;
function MAX(a, b: Double): Double; inline;

// ******************** implementation ********************
implementation

// 
function MIN(a, b: Double): Double;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

// 
function MAX(a, b: Double): Double;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

end.
