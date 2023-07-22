
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
  {sdl2}
  sdl2;

// 
procedure doInput;
var
  event: TSDL_Event;
begin
  while SDL_PollEvent(@event) = 1 do
  begin
    case event.Type_ of
      SDL_QUITEV: Halt(0);
    end;
  end;
end;

end.
