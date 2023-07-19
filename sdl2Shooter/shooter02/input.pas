
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
  sdl2;

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
    end;
    Exit;
  end;
end;

end.
