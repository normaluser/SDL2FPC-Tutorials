
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Highscores;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Core,
  Shooter.App,
  Shooter.Defs,
  Shooter.Structs;

type
  THighscores = class(TCoreInterfacedObject, ILogicAndRender)
    public
      scores: array[0..NUM_HIGHSCORES] of THighscore;
      nameScore: PHighscore;
      cursor: Integer;

      constructor create;
      destructor destroy; override;

      procedure addHighscore(score: Integer);
      procedure reset;

      // ILogicAndRender
      procedure logic;
      procedure draw;

    private
      procedure drawHighscores;
      procedure doNameInput;
      procedure drawNameInput;
  end;

// ******************** var ********************
var
  highscores: THighscores;

procedure initHighscores;

// ******************** implementation ********************
implementation

uses
  {rtl}
  sysutils,
  generics.Defaults,
  generics.Collections,
  {shooter}
  Shooter.Background,
  Shooter.Stage,
  Shooter.Text,
  Shooter.Title;

// 
constructor THighscores.create;
var
  i: Integer;
begin
  inherited;
  for i := 0 to NUM_HIGHSCORES do
  begin
    scores[i].recent := 0;
    scores[i].score := NUM_HIGHSCORES - i;
    scores[i].name := 'ANONYMOUS';
  end;

  nameScore := Nil;
  cursor := 0;
end;

// 
destructor THighscores.destroy;
begin
  inherited destroy;
end;

// 
procedure THighscores.drawHighscores;
var
  i: Integer;
  y: Integer;
  r, g, b: Integer;
begin
  y := 100;

  drawText(SCREEN_WIDTH Div 2, 20, 255, 255, 255, TEXT_CENTER, 'HIGHSCORES');

  for i := 0 to (NUM_HIGHSCORES - 1) do
  begin
    r := 255;
    g := 255;
    b := 255;

    if scores[i].recent <> 0 then
      b := 0;

    drawText( SCREEN_WIDTH Div 2, 
              y, 
              r, g, b, 
              TEXT_CENTER, 
              Format('#%d. %-15s ...... %0.3d', [
                (i + 1), 
                scores[i].name, 
                scores[i].score
              ])
            );

    y += 50;
  end;

  drawText(SCREEN_WIDTH Div 2, 530, 255, 255, 255, TEXT_CENTER, 'PRESS FIRE TO PLAY!');
end;

// 
procedure THighscores.reset;
var
  i: Integer;
begin
  for i := 0 to NUM_HIGHSCORES do
  begin
    scores[i].recent := 0;
    scores[i].score := NUM_HIGHSCORES - i;
  end;
end;

// 
function highscoreComparator(constref a: THighscore; constref b: THighscore): Integer;
begin
  if a.score < b.score then
    Result := 1
  else if a.score > b.score then
    Result := -1
  else
    Result := 0;
end;

// 
procedure THighscores.addHighscore(score: Integer);
var
  i: Integer;
  t: THighscore;
  newScores: specialize TList<THighscore>;
  comparer: specialize IComparer<THighscore>;
  newScore: THighscore;
begin
  newScores := specialize TList<THighscore>.Create;

  // Copy scores to newScores
  for i := 0 to (NUM_HIGHSCORES - 1) do
  begin
    t := scores[i];
    t.recent := 0;
    newScores.Add(t);
  end;

  newScore.score := score;
  newScore.recent := 1;
  newScores.Add(newScore);  // Add the new score to the list

  comparer := specialize TComparer<THighscore>.Construct(@highscoreComparator);
  
  newScores.Sort(comparer);

  nameScore := Nil;

  for i := 0 to (NUM_HIGHSCORES - 1) do
  begin
    scores[i] := newScores[i];

    if scores[i].recent <> 0 then
      nameScore := @scores[i];
  end;

  newScores.Free;  // Don't forget to free the memory for the list after using it
end;

// 
procedure THighscores.logic;
begin
  background.doBackground;

  background.doStarfield;

  if nameScore <> Nil then
    doNameInput
  else
  begin
    Dec(title.timeout);
    if title.timeout <= 0 then
    begin
      initTitle;
      app.delegate := title;
    end;

    if app.keyboard[SDL_SCANCODE_SPACE] <> 0 then
    begin
      initStage;
      app.delegate := stage;
    end;
  end;

  Inc(cursor);
  if cursor >= FPS then
    cursor := 0;
end;

// 
procedure THighscores.draw;
begin
  background.drawBackground;

  background.drawStarfield;

  if nameScore <> Nil then
    drawNameInput
  else
    drawHighscores;
end;

// 
procedure THighscores.doNameInput;
var
  i: Integer;
  n: Integer;
  c: Char;
begin
  n := Length(nameScore^.name);

  for i := 1 to Length(app.inputText) do
  begin
    c := UpCase(app.inputText[i]);

    if (n < MAX_SCORE_NAME_LENGTH - 1) and (c >= ' ') and (c <= 'Z') then
    begin
      nameScore^.name += c;
      Inc(n);
    end;
  end;

  if (n > 0) and (app.keyboard[SDL_SCANCODE_BACKSPACE] = 1) then
  begin
    nameScore^.name[n] := #0;
    app.keyboard[SDL_SCANCODE_BACKSPACE] := 0;
  end;

  if app.keyboard[SDL_SCANCODE_RETURN] = 1 then
  begin
    if Length(nameScore^.name) = 0 then
      nameScore^.name := 'ANONYMOUS';

    nameScore := nil;
  end;
end;

// 
procedure THighscores.drawNameInput;
var
  r: TSDL_Rect;
begin
  drawText(SCREEN_WIDTH Div 2, 70, 255, 255, 255, TEXT_CENTER, 'CONGRATULATIONS, YOU''VE GAINED A HIGHSCORE!');

  drawText(SCREEN_WIDTH Div 2, 120, 255, 255, 255, TEXT_CENTER, 'ENTER YOUR NAME BELOW:');

  drawText(SCREEN_WIDTH Div 2, 250, 128, 255, 128, TEXT_CENTER, nameScore^.name);

  if cursor < (FPS Div 2) then
  begin
    r.x := ((SCREEN_WIDTH Div 2) + (Length(nameScore^.name) * GLYPH_WIDTH) Div 2) + 5;
    r.y := 250;
    r.w := GLYPH_WIDTH;
    r.h := GLYPH_HEIGHT;

    SDL_SetRenderDrawColor(app.renderer, 0, 255, 0, 255);
    SDL_RenderFillRect(app.renderer, @r);
  end;

  drawText(SCREEN_WIDTH Div 2, 625, 255, 255, 255, TEXT_CENTER, 'PRESS RETURN WHEN FINISHED');
end;

procedure initHighscores;
begin
  if highscores = Nil then
    highscores := THighscores.create;

  highscores.reset;
end;

end.
