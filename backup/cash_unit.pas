unit cash_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Grids,
  StdCtrls;

type

  { Tcash_frm }

  Tcash_frm = class(TForm)
    StringGrid1: TStringGrid;

    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private

  public

  end;

var
  cash_frm: Tcash_frm;

implementation

{$R *.lfm}

{ Tcash_frm }



procedure Tcash_frm.StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
  var x,y,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10:double;

begin
  if(tryStrToFloat(StringGrid1.Cells[1,1],y) and tryStrToFloat(StringGrid1.Cells[0,1],x))then begin
  StringGrid1.Cells[2,1]:=floatToStr(y*x);
  y1:=y*x;
  end else begin
  StringGrid1.Cells[1,1] := '0';
  StringGrid1.Cells[2,1] := '0';
  end;
  if(tryStrToFloat(StringGrid1.Cells[1,2],y) and tryStrToFloat(StringGrid1.Cells[0,2],x))then begin
  StringGrid1.Cells[2,2]:=floatToStr(y*x);
  y2:=y*x;
  end else begin
    StringGrid1.Cells[1,2] := '0';
    StringGrid1.Cells[2,2] := '0';
  end;
   if(tryStrToFloat(StringGrid1.Cells[1,3],y) and tryStrToFloat(StringGrid1.Cells[0,3],x))then begin
  StringGrid1.Cells[2,3]:=floatToStr(y*x);
  y3:=y*x;
  end else begin
    StringGrid1.Cells[1,3] := '0';
    StringGrid1.Cells[2,3] := '0';
  end;
   if(tryStrToFloat(StringGrid1.Cells[1,4],y) and tryStrToFloat(StringGrid1.Cells[0,4],x))then begin
  StringGrid1.Cells[2,4]:=floatToStr(y*x);
  y4:=y*x;
  end else begin
    StringGrid1.Cells[1,4] := '0';
    StringGrid1.Cells[2,4] := '0';
  end;
  if(tryStrToFloat(StringGrid1.Cells[1,5],y) and tryStrToFloat(StringGrid1.Cells[0,5],x))then begin
  StringGrid1.Cells[2,5]:=floatToStr(y*x);
  y5:=y*x;
  end else begin
    StringGrid1.Cells[1,5] := '0';
    StringGrid1.Cells[2,5] := '0';
  end;
  if(tryStrToFloat(StringGrid1.Cells[1,6],y) and tryStrToFloat(StringGrid1.Cells[0,6],x))then begin
  StringGrid1.Cells[2,6]:=floatToStr(y*x);
  y6:=y*x;
  end else begin
    StringGrid1.Cells[1,6] := '0';
    StringGrid1.Cells[2,6] := '0';
  end;

   if(tryStrToFloat(StringGrid1.Cells[1,7],y) and tryStrToFloat(StringGrid1.Cells[0,7],x))then begin
  StringGrid1.Cells[2,7]:=floatToStr(y*x);
  y7:=y*x;
  end else begin
    StringGrid1.Cells[1,7] := '0';
    StringGrid1.Cells[2,7] := '0';
  end;

    if(tryStrToFloat(StringGrid1.Cells[1,8],y) and tryStrToFloat(StringGrid1.Cells[0,8],x))then begin
  StringGrid1.Cells[2,8]:=floatToStr(y*x);
  y8:=y*x;
  end else begin
    StringGrid1.Cells[1,8] := '0';
    StringGrid1.Cells[2,8] := '0';
  end;

     if(tryStrToFloat(StringGrid1.Cells[1,9],y) and tryStrToFloat(StringGrid1.Cells[0,9],x))then begin
  StringGrid1.Cells[2,9]:=floatToStr(y*x);
  y9:=y*x;
  end else begin
    StringGrid1.Cells[1,9] := '0';
    StringGrid1.Cells[2,9] := '0';
  end;

     if(tryStrToFloat(StringGrid1.Cells[1,10],y))then begin
  StringGrid1.Cells[2,10]:=floatToStr(y);
  y10:=y;
  end else begin
    StringGrid1.Cells[2,10] := '0';
  end;

  StringGrid1.Cells[2,11] := floatToStr(y1+y2+y3+y4+y5+y6+y7+y8+y9);
end;

end.

