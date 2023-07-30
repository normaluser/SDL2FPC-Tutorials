
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Text;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2;

procedure initFonts;
procedure drawText(x, y: Integer; r, g, b: Integer; outText: String);

// ******************** implementation ********************
implementation

uses
  {shooter}
  Shooter.Draw;

// ******************** const ********************
const
  GLYPH_HEIGHT = 28;
  GLYPH_WIDTH = 18;

// ******************** var ********************
var
  fontTexture: PSDL_Texture;

procedure initFonts;
begin
  fontTexture := loadTexture('gfx/font.png');
end;

procedure drawText(x, y: Integer; r, g, b: Integer; outText: String);
var
  i: Integer;
  len: Integer;
  c: Char;
  rect: TSDL_Rect;
begin
  len := LENGTH(outText);
  outText := UPCASE(outText);

  rect.w := GLYPH_WIDTH;
  rect.h := GLYPH_HEIGHT;
  rect.y := 0;
  SDL_SetTextureColorMod(fontTexture, r, g, b);

  // fpc 字符串的索引是从1开始
  for i := 1 to len do
  begin
    c := outText[i];
    if c in [' '..'Z'] then
    begin
      rect.x := (Ord(c) - Ord(' ')) * GLYPH_WIDTH;
      blitRect(fontTexture, @rect, x, y);
      Inc(x, GLYPH_WIDTH);
    end;
  end;
end;

end.
