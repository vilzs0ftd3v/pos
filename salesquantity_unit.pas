unit salesQuantity_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  JButton,StdCtrls;

type

  { TsalesQuantity_frm }

  TsalesQuantity_frm = class(TForm)
    Bevel1: TBevel;
    count_close: TSpeedButton;
    quantity_edit: TEdit;
    Panel1: TPanel;
    saveCount_btn: TJButton;
    procedure count_closeClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure quantity_editKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure saveCount_btnClick(Sender: TObject);
  private

  public

  end;

var
  salesQuantity_frm: TsalesQuantity_frm;
  MouseIsDown:boolean;
  PX,PY:integer;

implementation
uses sales_unit,LCLType;
{$R *.lfm}

{ TsalesQuantity_frm }

procedure TsalesQuantity_frm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if Button = mbLeft then begin
     MouseIsDown:=true;
     PX:=X;
     PY:=Y;
   end;
end;

procedure TsalesQuantity_frm.count_closeClick(Sender: TObject);
begin
  salesQuantity_frm.Close;
end;

procedure TsalesQuantity_frm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if MouseIsDown then begin
    SetBounds(Left+(X-PX),Top+(Y-PY),Width,Height);
  end;
end;

procedure TsalesQuantity_frm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown:=False;
end;

procedure TsalesQuantity_frm.quantity_editKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     if (Key = VK_RETURN) then begin
     if((quantity_edit.Text<>'') and (sales_frm.getQuantityInDb >= strToFloat(quantity_edit.Text)) and (quantity_edit.Text<>'0') and (strToFloat(quantity_edit.Text)>0))then begin
       sales_frm.setQuantityPerItem(strToFloat(quantity_edit.Text));
       salesQuantity_frm.Close;
     end else begin
       showMessage('Invalid input');
     end;
   end;
end;

procedure TsalesQuantity_frm.saveCount_btnClick(Sender: TObject);
begin
  //showMessage(quantity_edit.Text);
  if((quantity_edit.Text<>'') and (sales_frm.getQuantityInDb >= strToFloat(quantity_edit.Text)) and (quantity_edit.Text<>'0') and (strToFloat(quantity_edit.Text)>0))then begin
       sales_frm.setQuantityPerItem(strToFloat(quantity_edit.Text));
       salesQuantity_frm.Close;
  end else begin
       showMessage('Invalid input');
  end;
end;

end.

