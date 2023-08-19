
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Input;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

procedure doInput;

// ******************** implementation ********************
implementation

uses
  {rtl}
  sysutils,
  {sdl2}
  sdl2,
  {shooter}
  Shooter.Defs,
  Shooter.App;

procedure doKeyUp(event: PSDL_KeyboardEvent); FORWARD;
procedure doKeyDown(event: PSDL_KeyboardEvent); FORWARD;

// 
procedure doKeyUp(event: PSDL_KeyboardEvent);
begin
  if (event^.repeat_ = 0) and (event^.keysym.scancode < MAX_KEYBOARD_KEYS) then
    app.keyboard[event^.keysym.scancode] := 0;
end;

// 
procedure doKeyDown(event: PSDL_KeyboardEvent);
begin
  if (event^.repeat_ = 0) and (event^.keysym.scancode < MAX_KEYBOARD_KEYS) then
    app.keyboard[event^.keysym.scancode] := 1;
end;

// 
procedure doInput;
var
  event: TSDL_Event;
  text: array[0..SDL_TEXTINPUTEVENT_TEXT_SIZE] of Char;
begin
  app.inputText := '';

  while SDL_PollEvent(@event) = 1 do
  begin
    case event.Type_ of
      SDL_QUITEV: Halt(0);

      SDL_KEYDOWN: doKeyDown(@event);

      SDL_KEYUP: doKeyUp(@event);

      SDL_TEXTINPUT:
      begin
        text := event.text.text;
        SetString(app.inputText, text, StrLen(text));
      end;
    end;
  end;
end;

end.
