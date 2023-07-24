
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Stage;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

procedure initStage;

// ******************** implementation ********************
implementation

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs, Shooter.Structs, Shooter.App, Shooter.Draw;

var
  player: TEntity;
  stage: TStage;

  fighterTexture: PSDL_Texture;
  enemyTexture: PSDL_Texture;
  bulletTexture: PSDL_Texture;

  enemySpawnTimer: Integer;

// 
procedure fireBullet;
var
  bullet: PEntity;
begin
  bullet := createEntity;

  stage.bulletTail^.next := bullet;
  stage.bulletTail := bullet;

  bullet^.x := player.x;
  bullet^.y := player.y;
  bullet^.dx := PLAYER_BULLET_SPEED;
  bullet^.health := true;

  bullet^.texture := bulletTexture;
  SDL_QueryTexture(bullet^.texture, Nil, Nil, @bullet^.w, @bullet^.h);

  bullet^.y += (player.h Div 2) - (bullet^.h Div 2);
  player.reload := 8;
end;

// 
procedure doPlayer;
begin
  player.dx := 0;
  player.dy := 0;

  if player.reload > 0 then
    Dec(player.reload);

  if app.keyboard[SDL_SCANCODE_UP] = 1 then
    player.dy := (-1 * PLAYER_SPEED);

  if app.keyboard[SDL_SCANCODE_DOWN] = 1 then
    player.dy := PLAYER_SPEED;

  if app.keyboard[SDL_SCANCODE_LEFT] = 1 then
    player.dx := (-1 * PLAYER_SPEED);

  if app.keyboard[SDL_SCANCODE_RIGHT] = 1 then
    player.dx := PLAYER_SPEED;

  if (app.keyboard[SDL_SCANCODE_SPACE] = 1) and (player.reload = 0) then
    fireBullet;

end;

// 
procedure doFighters;
var
  e, prev: PEntity;
begin
  prev := @stage.fighterHead;

  e := stage.fighterHead.next;
  while e <> Nil do
  begin
    e^.x += e^.dx;
    e^.y += e^.dy;

    if (e <> @player) and (e^.x < -e^.w) then
    begin
      if e = stage.fighterTail then
        stage.fighterTail := prev;

      prev^.next := e^.next;
      disposeEntity(e);
      e := prev;
    end;

    prev := e;
    e := e^.next;
  end;
end;

// 
procedure doBullets;
var
  b, prev: PEntity;
begin
  prev := @stage.bulletHead;

  b := stage.bulletHead.next;
  while b <> Nil do
  begin
    b^.x += b^.dx;
    b^.y += b^.dy;

    if b^.x > SCREEN_WIDTH then
    begin
      if b = stage.bulletTail then
        stage.bulletTail := prev;

      prev^.next := b^.next;
      
      disposeEntity(b);
      b := prev;
    end;

    prev := b;
    b := b^.next;
  end;
end;

// 
procedure spawnEnemies;
var
  enemy: PEntity;
begin
  Dec(enemySpawnTimer);
  if enemySpawnTimer <= 0 then
  begin
    enemy := createEntity;
    stage.fighterTail^.next := enemy;
    stage.fighterTail := enemy;

    enemy^.x := SCREEN_WIDTH;
    enemy^.y := Random(SCREEN_HEIGHT);

    enemy^.texture := enemyTexture;
    SDL_QueryTexture(enemy^.texture, Nil, Nil, @enemy^.w, @enemy^.h);

    enemy^.dx := -(2 + Random(4));
    enemySpawnTimer := 30 + (Random(60));
  end;
end;

// 
procedure drawFighters;
var
  e: PEntity;
begin
  e := stage.fighterHead.next;
  while e <> Nil do
  begin
    blit(e^.texture, e^.x, e^.y);
    e := e^.next;
  end;
end;

// 
procedure drawBullets;
var
  b: PEntity;
begin
  b := stage.bulletHead.next;
  while b <> Nil do
  begin
    blit(b^.texture, b^.x, b^.y);
    b := b^.next;
  end;
end;

// 
procedure logic;
begin
  doPlayer;
  doFighters;
  doBullets;
  spawnEnemies;
end;

// 
procedure draw;
begin
  drawFighters;
  drawBullets;
end;

// 
procedure initPlayer;
begin
  stage.fighterTail^.next := @player;
  stage.fighterTail := @player;

  player.x := 100;
  player.y := 100;
  player.texture := fighterTexture;
  SDL_QueryTexture(player.texture, Nil, Nil, @player.w, @player.h);
end;

// 
procedure initStage;
begin
  app.delegate.logic := @logic;
  app.delegate.draw := @draw;

  stage.fighterHead := createEntity^;
  stage.bulletHead := createEntity^;

  stage.fighterTail := @stage.fighterHead;
  stage.bulletTail := @stage.bulletHead;

  fighterTexture := loadTexture('gfx/player.png');
  enemyTexture := loadTexture('gfx/enemy.png');
  bulletTexture := loadTexture('gfx/playerBullet.png');

  enemySpawnTimer := 0;

  initPlayer;
end;

end.
