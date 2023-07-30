
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Audio;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

uses
  {sdl2}
  sdl2_mixer,
  {shooter}
  Shooter.Defs;

// ******************** type ********************
type
  PAudio = ^TAudio;
  TAudio = class(TObject)
    public
      sounds: array[0..SND_MAX] of PMix_Chunk;
      music: PMix_Music;

      constructor create;
      destructor destroy; override;

      procedure playMusic(loop: Integer);
      procedure playSound(id, channel: Integer);

      class procedure createAndInit;
      class procedure destroyAndNil;

    private
      procedure loadMusic;
      procedure loadSounds;
  end;

// ******************** var ********************
var
  audio: TAudio;

// ******************** implementation ********************
implementation

// 
constructor TAudio.Create;
var
  i: Integer;
begin
  inherited;
  for i := 0 to SND_MAX do
    sounds[i] := Nil;
  music := Nil;
end;

// 
destructor TAudio.destroy;
begin
  inherited destroy;
end;

// 
procedure TAudio.loadSounds;
begin
  sounds[SND_PLAYER_FIRE] := Mix_LoadWAV('sound/334227__jradcoolness__laser.ogg');
  sounds[SND_ALIEN_FIRE] := Mix_LoadWAV('sound/196914__dpoggioli__laser-gun.ogg');
  sounds[SND_PLAYER_DIE] := Mix_LoadWAV('sound/245372__quaker540__hq-explosion.ogg');
  sounds[SND_ALIEN_DIE] := Mix_LoadWAV('sound/10 Guage Shotgun-SoundBible.com-74120584.ogg');
  sounds[SND_POINTS] := Mix_LoadWAV('sound/342749__rhodesmas__notification-01.ogg');
end;

// 
procedure TAudio.loadMusic;
begin
  if music <> Nil then
  begin
    Mix_HaltMusic;
    Mix_FreeMusic(music);
    music := Nil;
  end;

  music := Mix_LoadMUS(PAnsiChar('music/Mercury.ogg'));
end;

// 
procedure TAudio.playMusic(loop: Integer);
begin
  if loop <> 0 then
    Mix_PlayMusic(music, -1)
  else
    Mix_PlayMusic(music, 0);
end;

// 
procedure TAudio.playSound(id, channel: Integer);
begin
  Mix_PlayChannel(channel, sounds[id], 0);
end;

// 
class procedure TAudio.createAndInit;
begin
  audio := TAudio.Create;
  
  audio.loadMusic;
  audio.loadSounds;
end;

// 
class procedure TAudio.destroyAndNil;
begin
  audio.destroy;
end;

end.
