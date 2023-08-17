
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Stage;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {shooter}
  Shooter.Core,
  Shooter.App,
  Shooter.Structs;

type
  TStage = class(TCoreInterfacedObject, ILogicAndRender)
    public
      fighterHead: TEntity;
      bulletHead: TEntity;
      fighterTail: PEntity;
      bulletTail: PEntity;

      constructor create;
      destructor destroy; override;

    private
      procedure initPlayer;
      procedure reset;
      procedure fireBullet;
      procedure doPlayer;
      procedure doFighters;
      procedure doBullets;
      procedure doEnemies;
      procedure drawFighters;
      procedure drawBullets;
      procedure spawnEnemies;
      procedure fireAlienBullet(e: PEntity);
      procedure clipPlayer;
      
      function bulletHitFighter(b: PEntity): Boolean;

      // ILogicAndRender
      procedure logic;
      procedure draw;
  end;

// ******************** var ********************
var
  stage: TStage;

procedure initStage;

// ******************** implementation ********************
implementation

uses
  {rtl}
  sysutils,
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs,
  Shooter.Draw,
  Shooter.Util;

var
  player: PEntity;

  playerTexture: PSDL_Texture;
  enemyTexture: PSDL_Texture;
  bulletTexture: PSDL_Texture;
  alienBulletTexture: PSDL_Texture;

  enemySpawnTimer: Integer;
  stageResetTimer: Integer;

// 
constructor TStage.create;
begin
  fighterHead := createEntity^;
  bulletHead := createEntity^;

  fighterTail := @fighterHead;
  bulletTail := @bulletHead;
end;

// 
destructor TStage.destroy;
begin
  inherited destroy;
end;

// 
procedure TStage.initPlayer;
begin
  player := createEntity;
  self.fighterTail^.next := player;
  self.fighterTail := player;

  player^.health := true;
  player^.x := 100;
  player^.y := 100;
  player^.texture := playerTexture;
  SDL_QueryTexture(player^.texture, Nil, Nil, @player^.w, @player^.h);

  player^.side := SIDE_PLAYER;
end;

// 
procedure TStage.fireBullet;
var
  bullet: PEntity;
begin
  bullet := createEntity;

  self.bulletTail^.next := bullet;
  self.bulletTail := bullet;

  bullet^.x := player^.x;
  bullet^.y := player^.y;
  bullet^.dx := PLAYER_BULLET_SPEED;
  bullet^.health := true;
  bullet^.texture := bulletTexture;
  bullet^.side := SIDE_PLAYER;
  SDL_QueryTexture(bullet^.texture, Nil, Nil, @bullet^.w, @bullet^.h);

  bullet^.y += (player^.h Div 2) - (bullet^.h Div 2);
  player^.reload := 8;
end;

// 
procedure TStage.doPlayer;
begin
  if player <> Nil then
  begin
    player^.dx := 0;
    player^.dy := 0;

    if player^.reload > 0 then
      Dec(player^.reload);

    if app.keyboard[SDL_SCANCODE_UP] = 1 then
      player^.dy := (-1 * PLAYER_SPEED);

    if app.keyboard[SDL_SCANCODE_DOWN] = 1 then
      player^.dy := PLAYER_SPEED;

    if app.keyboard[SDL_SCANCODE_LEFT] = 1 then
      player^.dx := (-1 * PLAYER_SPEED);

    if app.keyboard[SDL_SCANCODE_RIGHT] = 1 then
      player^.dx := PLAYER_SPEED;

    if (app.keyboard[SDL_SCANCODE_SPACE] = 1) and (player^.reload <= 0) then
      fireBullet;
  end;

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

    if (e <> player) and (e^.x < -e^.w) then
      e^.health := false;

    if not e^.health then
    begin
      if e = player then
        player := Nil;
      if e = self.fighterTail then
        self.fighterTail := prev;

      prev^.next := e^.next;
      Dispose(e);
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

    if bulletHitFighter(b) or
    (b^.x < -b^.w) or
    (b^.y < -b^.h) or
    (b^.x > SCREEN_WIDTH) or
    (b^.y > SCREEN_HEIGHT) then
    begin
      if b = self.bulletTail then
        self.bulletTail := prev;

      prev^.next := b^.next;
      
      Dispose(b);
      b := prev;
    end;

    prev := b;
    b := b^.next;
  end;
end;

// 
procedure TStage.doEnemies;
var
  e: PEntity;
begin
  e := fighterHead.next;
  while e <> Nil do 
  begin
    if (e <> player) and (player <> Nil) then
    begin
      Dec(e^.reload);
      if e^.reload <= 0 then
        fireAlienBullet(e);
    end;

    e := e^.next;
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

    enemy^.reload := FPS * (1 + Random(3));

    enemySpawnTimer := 30 + (Random(FPS));
  end;
end;

// 
procedure TStage.fireAlienBullet(e: PEntity);
var
  bullet : PEntity;
begin
  bullet := createEntity;
  bulletTail^.next := bullet;
  bulletTail := bullet;

  bullet^.x := e^.x;
  bullet^.y := e^.y;
  bullet^.health := true;
  bullet^.texture := alienBulletTexture;
  bullet^.side := SIDE_ALIEN;
  SDL_QueryTexture(bullet^.texture, Nil, Nil, @bullet^.w, @bullet^.h);

  bullet^.x += (e^.w Div 2) - (bullet^.w Div 2);
  bullet^.y += (e^.h Div 2) - (bullet^.h Div 2);

  calcSlope(player^.x + (player^.w Div 2),
            player^.y + (player^.h Div 2),
            e^.x,
            e^.y,
            bullet^.dx,
            bullet^.dy);

  bullet^.dx *= ALIEN_BULLET_SPEED;
  bullet^.dy *= ALIEN_BULLET_SPEED;

  e^.reload := Random(FPS * 2);
end;

// 
procedure TStage.clipPlayer;
begin
  if player <> Nil then
  begin
    if player^.x < 0 then
      player^.x := 0;

    if player^.y < 0 then
      player^.y := 0;

    if player^.x > (SCREEN_WIDTH - player^.w) then
      player^.x := SCREEN_WIDTH - player^.w;

    if player^.y > (SCREEN_HEIGHT - player^.h) then
      player^.y := SCREEN_HEIGHT - player^.h;
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
procedure TStage.logic;
begin
  doPlayer;
  doEnemies;
  doFighters;
  doBullets;
  spawnEnemies;
  clipPlayer;

  if player = Nil then
  begin
    Dec(stageResetTimer);
    if stageResetTimer <= 0 then
      reset;
  end;

end;

// 
procedure TStage.draw;
begin
  drawFighters;
  drawBullets;
end;

// 
procedure TStage.reset;
var
  e: PEntity;
begin
  while fighterHead.next <> Nil do 
  begin
    e := fighterHead.next;
    fighterHead.next := e^.next;
    Dispose(e);
  end;

  while bulletHead.next <> Nil do 
  begin
    e := bulletHead.next;
    bulletHead.next := e^.next;
    Dispose(e);
  end;

  fighterTail := @fighterHead;
  bulletTail := @bulletHead;

  initPlayer;

  enemySpawnTimer := 0;
  stageResetTimer := FPS * 2;
end;

// 
procedure initStage;
begin
  stage := TStage.create;

  playerTexture := loadTexture('gfx/player.png');
  enemyTexture := loadTexture('gfx/enemy.png');
  bulletTexture := loadTexture('gfx/playerBullet.png');
  alienBulletTexture := loadTexture(('gfx/alienBullet.png'));

  stage.initPlayer;

  enemySpawnTimer := 0;
  stageResetTimer := FPS * 2;

  app.delegate := stage;
end;

end.
