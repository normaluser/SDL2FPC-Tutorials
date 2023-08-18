
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

      constructor create;
      destructor destroy; override;

      procedure addHighscore(score: Integer);
      procedure reset;

      // ILogicAndRender
      procedure logic;
      procedure draw;

    private
      procedure drawHighscores;
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
  Shooter.Text;

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
  end;
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
begin
  y := 100;

  drawText(375, 20, 255, 255, 255, 'HIGHSCORES');

  for i := 0 to (NUM_HIGHSCORES - 1) do
  begin
    if scores[i].recent <> 0 then
      drawText(375, y, 255, 255, 0, Format('#%d ............. %0.3d', [(i + 1), scores[i].score]))
    else
      drawText(375, y, 255, 255, 255, Format('#%d ............. %0.3d', [(i + 1), scores[i].score]));

    y += 50;
  end;

  drawText(375, 530, 255, 255, 255, 'PRESS FIRE TO PLAY!');
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
  for i := 0 to NUM_HIGHSCORES do
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

  for i := 0 to NUM_HIGHSCORES do
    scores[i] := newScores[i];

  newScores.Free;  // Don't forget to free the memory for the list after using it
end;

// 
procedure THighscores.logic;
begin
  background.doBackground;

  background.doStarfield;

  if app.keyboard[SDL_SCANCODE_SPACE] <> 0 then
  begin
    initStage;
    app.delegate := stage;
  end;
end;

// 
procedure THighscores.draw;
begin
  background.drawBackground;

  background.drawStarfield;

  drawHighscores;
end;

procedure initHighscores;
begin
  if highscores = Nil then
    highscores := THighscores.create;

  highscores.reset;
end;

end.
