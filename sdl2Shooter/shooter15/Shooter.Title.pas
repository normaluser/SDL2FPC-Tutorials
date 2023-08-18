
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Title;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.App,
  Shooter.Core;

type
  TTitle = class(TCoreInterfacedObject, ILogicAndRender)
    public
      sdl2Texture: PSDL_Texture;
      shooterTexture: PSDL_Texture;
      reveal: Integer;
      timeout: Integer;

      constructor create;
      destructor destroy; override;

      procedure reset;

      // ILogicAndRender
      procedure logic;
      procedure draw;

    private
      procedure drawLogo;
  end;

// ******************** var ********************
var
  title: TTitle;

procedure initTitle;

// ******************** implementation ********************
implementation

uses
  {shooter}
  Shooter.Defs,
  Shooter.Draw,
  Shooter.Background,
  Shooter.Highscores,
  Shooter.Stage,
  Shooter.Text;

// 
constructor TTitle.create;
begin
  inherited;
  sdl2Texture := loadTexture('gfx/sdl2.png');
  shooterTexture := loadTexture('gfx/shooter.png');

  reveal := 0;
  timeout := FPS * 5;
end;

// 
destructor TTitle.destroy;
begin
  inherited destroy;
end;

// 
procedure TTitle.reset;
begin
  reveal := 0;
  timeout := FPS * 5;
end;

// 
procedure TTitle.logic;
begin
  background.doBackground;

  background.doStarfield;

  if reveal < SCREEN_HEIGHT then
    Inc(reveal);

  Dec(timeout);
  if timeout <= 0 then
  begin
    initHighscores;
    app.delegate := highscores;
  end;

  if app.keyboard[SDL_SCANCODE_SPACE] <> 0 then
  begin
    initStage;
    app.delegate := stage;
  end;
end;

// 
procedure TTitle.draw;
begin
  background.drawBackground;

  background.drawStarfield;

  drawLogo;

  if (timeout Div 40) < 20 then
    drawText(SCREEN_WIDTH Div 2, 456, 255, 255, 255, TEXT_CENTER, 'PRESS FIRE TO PLAY!');
end;

// 
procedure TTitle.drawLogo;
var
  r: TSDL_Rect;
begin
  r.x := 0;
  r.y := 0;

  SDL_QueryTexture(sdl2Texture, Nil, Nil, @r.w, @r.h);

  r.h := MIN(reveal, r.h);

  blitRect(sdl2Texture, @r, (SCREEN_WIDTH Div 2) - (r.w Div 2), 100);

  SDL_QueryTexture(shooterTexture, Nil, Nil, @r.w, @r.h);

  r.h := MIN(reveal, r.h);

  blitRect(shooterTexture, @r, (SCREEN_WIDTH Div 2) - (r.w Div 2), 250);
end;

// 
procedure initTitle;
begin
  if title = Nil then
    title := TTitle.create;

  title.reset;
end;

end.
