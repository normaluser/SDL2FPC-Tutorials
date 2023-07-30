
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Defs;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

// ******************** const ********************
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

  MAX_SND_CHANNELS = 8;

  CH_ANY = -1;
  CH_PLAYER = 0;
  CH_ALIEN_FIRE = 1;
  CH_POINTS = 2;

  SND_PLAYER_FIRE = 0;
  SND_ALIEN_FIRE = 1;
  SND_PLAYER_DIE = 2;
  SND_ALIEN_DIE = 3;
  SND_POINTS = 4;
  SND_MAX = 5;

function MIN(a, b: Double): Double; inline;
function MIN(a, b: Integer): Integer; inline;

function MAX(a, b: Double): Double; inline;
function MAX(a, b: Integer): Integer; inline;

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
function MIN(a, b: Integer): Integer;
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

// 
function MAX(a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

end.
