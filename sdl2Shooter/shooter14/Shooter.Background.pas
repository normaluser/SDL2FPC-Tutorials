


unit Shooter.Background;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs,
  Shooter.Structs;

type
  TBackground = class(TObject)
    public
      bgX: Integer;
      bgTexture: PSDL_Texture;
      stars: array[0..MAX_STARS] of TStar;

      constructor create;
      destructor destroy; override;

      procedure doBackground;
      procedure doStarfield;
      procedure drawStarfield;
      procedure drawBackground;

    private
      procedure initStarfield;
  end;

// ******************** var ********************
var
  background: TBackground;

procedure initBackground;

// ******************** implementation ********************
implementation

uses
  {shooter}
  Shooter.App,
  Shooter.Draw;

// 
constructor TBackground.create;
var
  i: Integer;
begin
  inherited;
  bgTexture := loadTexture('gfx/background.png');
  bgX := 0;
  for i := 0 to MAX_STARS do
  begin
    stars[i].x := 0;
    stars[i].y := 0;
    stars[i].speed := 0;
  end;
end;

// 
destructor TBackground.destroy;
begin
  inherited destroy;
end;

// 
procedure TBackground.initStarfield;
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
procedure TBackground.doBackground;
begin
  Dec(bgX);
  if bgX < -SCREEN_WIDTH then
    bgX := 0;
end;

// 
procedure TBackground.doStarfield;
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
procedure TBackground.drawStarfield;
var
  i: Integer;
  c: Integer;
begin
  for i := 0 to (MAX_STARS - 1) do
  begin
    c := (32 * stars[i].speed) - 1;

    SDL_SetRenderDrawColor(app.renderer, c, c, c, 255);
    SDL_RenderDrawLine(app.renderer, stars[i].x, stars[i].y, stars[i].x + 3, stars[i].y);
  end;
end;

// 
procedure TBackground.drawBackground;
var
  dest: TSDL_Rect;
  x: Integer;
begin
  x := bgX;
  while x < SCREEN_WIDTH do
  begin
    dest.x := x;
    dest.y := 0;
    dest.w := SCREEN_WIDTH;
    dest.h := SCREEN_HEIGHT;

    SDL_RenderCopy(app.renderer, bgTexture, Nil, @dest);

    x += SCREEN_WIDTH;
  end;
end;

// 
procedure initBackground;
begin
  background := TBackground.create;

  background.initStarfield;
end;

end.
