
unit input;

{$mode objfpc}
{$H+}

// ******************** interface ********************
interface

function doInput: Boolean;

// ******************** implementation ********************
implementation

uses
  {sdl2}
  sdl2,
  {base}
  structs, defs;

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
function doInput: Boolean;
var
  event: TSDL_Event;
begin
  while SDL_PollEvent(@event) = 1 do
  begin
    case event.Type_ of
      SDL_QUITEV:
        Result := false;

      SDL_KEYDOWN:
        doKeyDown(@event);

      SDL_KEYUP:
        doKeyUp(@event);
    end;
    Exit;
  end;
end;

end.
