
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Stage;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {shooter}
  Shooter.Structs;

type
  TStage = class(TObject)
    public
      fighterHead: TEntity;
      bulletHead: TEntity;
      fighterTail: PEntity;
      bulletTail: PEntity;

      constructor create;
      destructor destroy; override;

    private
      procedure initPlayer;
      procedure fireBullet;
      procedure doPlayer;
      procedure doFighters;
      procedure doBullets;
      procedure drawFighters;
      procedure drawBullets;
      procedure spawnEnemies;
      
      function bulletHitFighter(b: PEntity): Boolean;
  end;

procedure logic;
procedure draw;

procedure createStageAndInit;
procedure destroyStageAndNil;

// ******************** implementation ********************
implementation

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs,
  Shooter.App,
  Shooter.Draw,
  Shooter.Util;

var
  player: TEntity;
  stage: TStage;

  fighterTexture: PSDL_Texture;
  enemyTexture: PSDL_Texture;
  bulletTexture: PSDL_Texture;

  enemySpawnTimer: Integer;

// 
constructor TStage.create;
begin
  fighterHead := createEntity^;
  bulletHead := createEntity^;

  fighterTail := @fighterHead;
  bulletTail := @bulletHead;

  initPlayer;
end;

// 
destructor TStage.destroy;
begin

  inherited destroy;
end;

// 
procedure TStage.initPlayer;
begin
  self.fighterTail^.next := @player;
  self.fighterTail := @player;

  player.x := 100;
  player.y := 100;
  player.texture := fighterTexture;
  SDL_QueryTexture(player.texture, Nil, Nil, @player.w, @player.h);

  player.side := SIDE_PLAYER;
end;

// 
procedure TStage.fireBullet;
var
  bullet: PEntity;
begin
  bullet := createEntity;

  self.bulletTail^.next := bullet;
  self.bulletTail := bullet;

  bullet^.x := player.x;
  bullet^.y := player.y;
  bullet^.dx := PLAYER_BULLET_SPEED;
  bullet^.health := true;
  bullet^.side := SIDE_PLAYER;

  bullet^.texture := bulletTexture;
  SDL_QueryTexture(bullet^.texture, Nil, Nil, @bullet^.w, @bullet^.h);

  bullet^.y += (player.h Div 2) - (bullet^.h Div 2);
  player.reload := 8;
end;

// 
procedure TStage.doPlayer;
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
procedure TStage.doFighters;
var
  e: PEntity;
  prev: PEntity;
begin
  prev := @self.fighterHead;

  e := self.fighterHead.next;
  while e <> Nil do
  begin
    e^.x += e^.dx;
    e^.y += e^.dy;

    if (e <> @player) and ((e^.x < -e^.w) or not e^.health) then
    begin
      if e = self.fighterTail then
        self.fighterTail := prev;

      prev^.next := e^.next;
      disposeEntity(e);
      e := prev;
    end;

    prev := e;
    e := e^.next;
  end;
end;

// 
procedure TStage.doBullets;
var
  b: PEntity;
  prev: PEntity;
begin
  prev := @self.bulletHead;

  b := self.bulletHead.next;
  while b <> Nil do
  begin
    b^.x += b^.dx;
    b^.y += b^.dy;

    if bulletHitFighter(b) or (b^.x > SCREEN_WIDTH) then
    begin
      if b = self.bulletTail then
      begin
        self.bulletTail := prev;
      end;

      prev^.next := b^.next;
      
      disposeEntity(b);
      b := prev;
    end;

    prev := b;
    b := b^.next;
  end;
end;

// 
procedure TStage.drawFighters;
var
  e: PEntity;
begin
  e := self.fighterHead.next;
  while e <> Nil do
  begin
    blit(e^.texture, e^.x, e^.y);
    e := e^.next;
  end;
end;

// 
procedure TStage.drawBullets;
var
  b: PEntity;
begin
  b := self.bulletHead.next;
  while b <> Nil do
  begin
    blit(b^.texture, b^.x, b^.y);
    b := b^.next;
  end;
end;

// 
procedure TStage.spawnEnemies;
var
  enemy: PEntity;
begin
  Dec(enemySpawnTimer);
  if enemySpawnTimer <= 0 then
  begin
    enemy := createEntity;
    self.fighterTail^.next := enemy;
    self.fighterTail := enemy;

    enemy^.x := SCREEN_WIDTH;
    enemy^.y := Random(SCREEN_HEIGHT);

    enemy^.texture := enemyTexture;
    SDL_QueryTexture(enemy^.texture, Nil, Nil, @enemy^.w, @enemy^.h);

    enemy^.dx := -(2 + Random(4));

    enemy^.side := SIDE_ALIEN;
    enemy^.health := true;

    enemySpawnTimer := 30 + (Random(60));
  end;
end;

// 
function TStage.bulletHitFighter(b: PEntity): Boolean;
var
  e: PEntity;
begin
  e := self.fighterHead.next;
  while e <> Nil do
  begin
    if (e^.side <> b^.side) and
    (collision(b^.x, b^.y, b^.w, b^.h, e^.x, e^.y, e^.w, e^.h)) then
    begin
      b^.health := false;
      e^.health := false;

      Result := true;
      Exit;
    end;
    e := e^.next;
  end;

  Result := false;
end;

// 
procedure logic;
begin
  stage.doPlayer;
  stage.doFighters;
  stage.doBullets;
  stage.spawnEnemies;
end;

// 
procedure draw;
begin
  stage.drawFighters;
  stage.drawBullets;
end;

// 
procedure createStageAndInit;
begin
  app.delegate.logic := @logic;
  app.delegate.draw := @draw;

  fighterTexture := loadTexture('gfx/player.png');
  enemyTexture := loadTexture('gfx/enemy.png');
  bulletTexture := loadTexture('gfx/playerBullet.png');

  stage := TStage.create;

  enemySpawnTimer := 0;
end;

// 
procedure destroyStageAndNil;
begin
  stage.destroy;
end;

end.
