
unit stage;

{$mode objfpc}
{$H+}

// ******************** interface ********************
interface

procedure initStage;

// ******************** implementation ********************
implementation

uses
  {sdl2}
  sdl2,
  {base}
  defs, structs, draw;

// 
procedure fireBullet;
var
  bullet: PEntity;
begin
  bullet := createEntity;

  stage_.bulletTail^.next := bullet;
  stage_.bulletTail := bullet;

  bullet^.x := player.x;
  bullet^.y := player.y;
  bullet^.dx := PLAYER_BULLET_SPEED;
  bullet^.health := true;
  bullet^.texture := bulletTexture;
  SDL_QueryTexture(bullet^.texture, Nil, Nil, @bullet^.w, @bullet^.h);

  bullet^.y := bullet^.y + (player.h Div 2) - (bullet^.h Div 2);
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

    player.x := player.x + player.dx;
    player.y := player.y + player.dy;
end;

// 
procedure doBullets;
var
  b, prev: PEntity;
begin
  prev := @stage_.bulletHead;

  b := stage_.bulletHead.next;
  while b <> Nil do
  begin
    b^.x += b^.dx;
    b^.y += b^.dy;

    if b^.x > SCREEN_WIDTH then
    begin
      if b = stage_.bulletTail then
      begin
        stage_.bulletTail := prev;
      end;

      prev^.next := b^.next;
      
      disposeEntity(b);
      b := prev;
    end;

    prev := b;
    if (b <> Nil) then
      b := b^.next;
  end;
end;

// 
procedure drawPlayer;
begin
  blit(player.texture, player.x, player.y);
end;

// 
procedure drawBullets;
var
  b: PEntity;
begin
  b := stage_.bulletHead.next;
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
  doBullets;
end;

// 
procedure draw;
begin
  drawPlayer;
  drawBullets;
end;

// 
procedure initPlayer;
begin
  stage_.fighterTail^.next := @player;
  stage_.fighterTail := @player;

  player.x := 100;
  player.y := 100;
  player.texture := loadTexture('gfx/player.png');
  SDL_QueryTexture(player.texture, Nil, Nil, @player.w, @player.h);
end;

// 
procedure initStage;
begin
  app.delegate.logic := @logic;
  app.delegate.draw := @draw;

  stage_.fighterHead := createEntity^;
  stage_.bulletHead := createEntity^;

  stage_.fighterTail := @stage_.fighterHead;
  stage_.bulletTail := @stage_.bulletHead;

  initPlayer;
  bulletTexture := loadTexture('gfx/playerBullet.png');
end;

end.
