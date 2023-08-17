
// Copyright (C) 2023 CHUNQIAN SHEN. All rights reserved.

unit Shooter.Core;

{$Mode objfpc}
{$H+}

// ******************** interface ********************
interface

type
  TCoreInterfacedObject = class(TInterfacedObject)
  protected
    function _AddRef: longint; {$IFNDEF WINDOWS} cdecl {$ELSE WINDOWS} stdcall {$ENDIF WINDOWS};
    function _Release: longint; {$IFNDEF WINDOWS} cdecl {$ELSE WINDOWS} stdcall {$ENDIF WINDOWS};
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

// ******************** implementation ********************
implementation

function TCoreInterfacedObject._AddRef: longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := 1;
end;

function TCoreInterfacedObject._Release: longint; {$IFNDEF WINDOWS}cdecl{$ELSE}stdcall{$ENDIF};
begin
  Result := 1;
end;

procedure TCoreInterfacedObject.AfterConstruction;
begin
end;

procedure TCoreInterfacedObject.BeforeDestruction;
begin
end;

end.
