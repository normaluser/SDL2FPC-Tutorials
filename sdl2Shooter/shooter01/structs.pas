
unit structs;

{$mode objfpc}
{$H+}

{-------------------- interface --------------------}
interface

uses
  {sdl2}
  sdl2;

type
  TApp = record
    renderer: PSDL_Renderer;
    window: PSDL_Window;
  end;

var
  app: TApp;

{-------------------- implementation --------------------}
implementation

end.
