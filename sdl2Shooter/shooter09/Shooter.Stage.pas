
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
  TStage = class
    public
      fighterHead: TEntity;
      bulletHead: TEntity;
      explosionHead: TExplosion;
      debrisHead: TDebris;

      fighterTail: PEntity;
      bulletTail: PEntity;
      explosionTail: PExplosion;
      debrisTail: PDebris;

      constructor Create;
      destructor Destroy; override;

    private
      procedure initPlayer;
      procedure initStarfield;

      procedure doPlayer;
      procedure doFighters;
      procedure doBullets;
      procedure doEnemies;
      procedure doBackground;
      procedure doStarfield;
      procedure doExplosions;
      procedure doDebris;

      procedure drawFighters;
      procedure drawBullets;
      procedure drawBackground;
      procedure drawStarfield;
      procedure drawExplosions;
      procedure drawDebris;

      procedure addExplosions(x: Double; y: Double; num: Integer);
      procedure addDebris(e: PEntity);

      procedure fireBullet;
      procedure spawnEnemies;
      procedure fireAlienBullet(e: PEntity);
      procedure clipPlayer;
      
      function bulletHitFighter(b: PEntity): Boolean;
  end;

procedure initStage;
procedure deinitStage;
procedure resetStage;
procedure logic;
procedure draw;

// ******************** implementation ********************
implementation

uses
  {rtl}
  SysUtils,
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs, Shooter.App, Shooter.Draw, Shooter.Util;

var
  player: PEntity;
  stage: TStage;

  playerTexture: PSDL_Texture;
  enemyTexture: PSDL_Texture;
  bulletTexture: PSDL_Texture;
  alienBulletTexture: PSDL_Texture;
  background: PSDL_Texture;
  explosionTexture: PSDL_Texture;

  enemySpawnTimer: Integer;
  stageResetTimer: Integer;
  backgroundX: Integer;
  stars: array[0..MAX_STARS] of TStar;

// 
constructor TStage.Create;
begin
  fighterHead := createEntity^;
  bulletHead := createEntity^;
  explosionHead := createExplosion^;
  debrisHead := createDebris^;

  fighterTail := @fighterHead;
  bulletTail := @bulletHead;
  explosionTail := @explosionHead;
  debrisTail := @debrisHead;

  initPlayer;
  initStarfield;
end;

// 
destructor TStage.Destroy;
begin

  inherited Destroy;
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
procedure TStage.initStarfield;
var
  i: Integer;
begin
  for i := 0 to (MAX_STARS - 1) do
  begin
    stars[i].x := Random(SCREEN_WIDTH);
    stars[i].y := Random(SCREEN_HEIGHT);
    stars[i].speed := 1 + Random(8);
  end;
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
  e := stage.fighterHead.next;
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
procedure TStage.doBackground;
begin
  Dec(backgroundX);
  if backgroundX < -SCREEN_WIDTH then
    backgroundX := 0;
end;

// 
procedure TStage.doStarfield;
var
  i: Integer;
begin
  for i := 0 to (MAX_STARS - 1) do
  begin
    stars[i].x -= stars[i].speed;
    if stars[i].x < 0 then
      stars[i].x := SCREEN_WIDTH + stars[i].x;
  end;
end;

// 
procedure TStage.doExplosions;
var
  e: PExplosion;
  prev: PExplosion;
begin
  prev := @stage.explosionHead;
  e := stage.explosionHead.next;
  while e <> Nil do
  begin
    e^.x += e^.dx;
    e^.y += e^.dy;

    Dec(e^.a);
    if e^.a <= 0 then
    begin
      if e = stage.explosionTail then
        stage.explosionTail := prev;

      prev^.next := e^.next;
      Dispose(e);
      e := prev;
    end;

    prev := e;
    e := e^.next;
  end;
end;

// 
procedure TStage.doDebris;
var
  d: PDebris;
  prev: PDebris;
begin
  prev := @stage.debrisHead;
  d := stage.debrisHead.next;
  while d <> Nil do
  begin
    d^.x += d^.dx;
    d^.y += d^.dy;
    
    d^.dy += 0.5;

    Dec(d^.life);
    if d^.life <= 0 then
    begin
      if d = stage.debrisTail then
        stage.debrisTail := prev;

      prev^.next := d^.next;
      Dispose(d);
      d := prev
    end;

    prev := d;
    d := d^.next;
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
procedure TStage.drawBackground;
var
  dest: TSDL_Rect;
  x: Integer;
begin
  x := backgroundX;
  while x < SCREEN_WIDTH do
  begin
    dest.x := x;
    dest.y := 0;
    dest.w := SCREEN_WIDTH;
    dest.h := SCREEN_HEIGHT;

    SDL_RenderCopy(app.renderer, background, Nil, @dest);

    x += SCREEN_WIDTH;
  end;
end;

// 
procedure TStage.drawStarfield;
var
  i: Integer;
  c: Integer;
begin
  for i := 0 to (MAX_STARS - 1) do
  begin
    c := 32 * stars[i].speed;

    SDL_SetRenderDrawColor(app.renderer, c, c, c, 255);
    SDL_RenderDrawLine(app.renderer, stars[i].x, stars[i].y, stars[i].x + 3, stars[i].y);
  end;
end;

// 
procedure TStage.drawExplosions;
var
  e: PExplosion;
begin
  SDL_SetRenderDrawBlendMode(app.renderer, SDL_BLENDMODE_ADD);
  SDL_SetTextureBlendMode(explosionTexture, SDL_BLENDMODE_ADD);

  e := stage.explosionHead.next;
  while e <> Nil do
  begin
    SDL_SetTextureColorMod(explosionTexture, e^.r, e^.g, e^.b);
    SDL_SetTextureAlphaMod(explosionTexture, e^.a);

    blit(explosionTexture, e^.x, e^.y);

    e := e^.next;
  end;

  SDL_SetRenderDrawBlendMode(app.renderer, SDL_BLENDMODE_NONE);
end;

// 
procedure TStage.drawDebris;
var
  d: PDebris;
begin
  d := stage.debrisHead.next;
  while d <> Nil do
  begin
    blitRect(d^.texture, @d^.rect, d^.x, d^.y);

    d := d^.next;
  end;
end;

// 
procedure TStage.addExplosions(x: Double; y: Double; num: Integer);
var
  i: Integer;
  e: PExplosion;
begin
  for i := 0 to (num - 1) do
  begin
    e := createExplosion;
    stage.explosionTail^.next := e;
    stage.explosionTail := e;

    e^.x := Trunc(x) + Random(32) - Random(32);
    e^.y := Trunc(y) + Random(32) - Random(32);
    e^.dx := Random(10) - Random(10);
    e^.dy := Random(10) - Random(10);

    e^.dx /= 10;
    e^.dy /= 10;

    case Random(4) of
      0: e^.r := 255;
      1:
      begin
        e^.r := 255;
        e^.g := 128;
      end;
      2:
      begin
        e^.r := 255;
        e^.g := 255;
      end;
      else
      begin
        e^.r := 255;
        e^.g := 255;
        e^.b := 255;
      end;
    end;

    e^.a := Random(FPS * 3);
  end;
end;

// 
procedure TStage.addDebris(e: PEntity);
var
  d: PDebris;
  x: Integer;
  y: Integer;
  w: Integer;
  h: Integer;
begin
  w := e^.w Div 2;
  h := e^.h Div 2;

  y := 0;
  while y <= h do
  begin
    x := 0;
    while x <= w do
    begin
      d := createDebris;
      stage.debrisTail^.next := d;
      stage.debrisTail := d;

      d^.x := e^.x + (e^.w Div 2);
      d^.y := e^.y + (e^.h Div 2);
      d^.dx := Random(5) - Random(5);
      d^.dy := -(5 + Random(12));
      d^.life := FPS * 2;
      d^.texture := e^.texture;

      d^.rect.x := x;
      d^.rect.y := y;
      d^.rect.w := w;
      d^.rect.h := h;

      x += w;
    end;

    y += h;
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
  stage.bulletTail^.next := bullet;
  stage.bulletTail := bullet;

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

    if player^.x > (SCREEN_WIDTH Div 2) then
      player^.x := SCREEN_WIDTH Div 2;

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

      addExplosions(e^.x, e^.y, 32);
      addDebris(e);

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
  stage.doBackground;
  stage.doStarfield;
  stage.doPlayer;
  stage.doEnemies;
  stage.doFighters;
  stage.doBullets;
  stage.doExplosions;
  stage.doDebris;
  stage.spawnEnemies;
  stage.clipPlayer;

  if player = Nil then
  begin
    Dec(stageResetTimer);
    if stageResetTimer <= 0 then
      resetStage;
  end;

end;

// 
procedure draw;
begin
  stage.drawBackground;
  stage.drawStarfield;
  stage.drawFighters;
  stage.drawDebris;
  stage.drawExplosions;
  stage.drawBullets;
end;

// 
procedure resetStage;
var
  e: PEntity;
  ex: PExplosion;
  d: PDebris;
begin
  while stage.fighterHead.next <> Nil do
  begin
    e := stage.fighterHead.next;
    stage.fighterHead.next := e^.next;
    Dispose(e);
  end;

  while stage.bulletHead.next <> Nil do
  begin
    e := stage.bulletHead.next;
    stage.bulletHead.next := e^.next;
    Dispose(e);
  end;

  while stage.explosionHead.next <> Nil do
  begin
    ex := stage.explosionHead.next;
    stage.explosionHead.next := ex^.next;
    Dispose(ex);
  end;

  while stage.debrisHead.next <> Nil do
  begin
    d := stage.debrisHead.next;
    stage.debrisHead.next := d^.next;
    Dispose(d);
  end;

  stage.fighterTail := @stage.fighterHead;
  stage.bulletTail := @stage.bulletHead;
  stage.explosionTail := @stage.explosionHead;
  stage.debrisTail := @stage.debrisHead;

  stage.initPlayer;
  stage.initStarfield;

  enemySpawnTimer := 0;
  stageResetTimer := FPS * 2;
end;

// 
procedure deinitStage;
begin
  
  stage.Destroy;
end;

// 
procedure initStage;
begin
  app.delegate.logic := @logic;
  app.delegate.draw := @draw;

  playerTexture := loadTexture('gfx/player.png');
  enemyTexture := loadTexture('gfx/enemy.png');
  bulletTexture := loadTexture('gfx/playerBullet.png');
  alienBulletTexture := loadTexture(('gfx/alienBullet.png'));
  background := loadTexture('gfx/background.png');
  explosionTexture := loadTexture('gfx/explosion.png');

  stage := TStage.Create;

  enemySpawnTimer := 0;
  stageResetTimer := FPS * 2;
end;

end.
