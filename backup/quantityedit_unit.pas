unit quantityEdit_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, JButton, JLabeledFloatEdit,ticket_unit;

type

  { TquantityEdit_frm }

  TquantityEdit_frm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    price_edit: TEdit;
    saveCount_btn: TJButton;
    Panel1: TPanel;
    count_close: TSpeedButton;
    count_edit: TEdit;
    remove_btn: TJButton;
    procedure count_closeClick(Sender: TObject);
    procedure count_editKeyPress(Sender: TObject; var Key: char);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure price_editKeyPress(Sender: TObject; var Key: char);
    procedure remove_btnClick(Sender: TObject);
    procedure saveCount_btnClick(Sender: TObject);
  private

  public
  ticket_id,variation_id:integer;
  count,price,stockLeft,qty,quantity:double;
  end;

var
  quantityEdit_frm: TquantityEdit_frm;
  myTicket:Ticket;
  MouseIsDown:boolean;
  PX,PY:integer;

implementation
uses main_unit;
{$R *.lfm}

{ TquantityEdit_frm }

procedure TquantityEdit_frm.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
     MouseIsDown:=true;
     PX:=X;
     PY:=Y;
   end;
end;

procedure TquantityEdit_frm.count_closeClick(Sender: TObject);
begin
  quantityEdit_frm.Close;
end;

procedure TquantityEdit_frm.count_editKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
     if(count_edit.Text<>'')then begin
        if(TryStrToFloat(count_edit.Text,count))then begin
             price_edit.Text:=floatToStr(strToFloat(count_edit.Text)*price);
        end else begin
             showMessage('Please insert a valid integer.');
             count_edit.Text:='';
        end;
     end;
  end;
end;

procedure TquantityEdit_frm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if MouseIsDown then begin
    SetBounds(Left+(X-PX),Top+(Y-PY),Width,Height);
  end;
end;

procedure TquantityEdit_frm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown:=False;
end;

procedure TquantityEdit_frm.price_editKeyPress(Sender: TObject; var Key: char);
var
  userPrice:double;
begin
  if Key = #13 then begin
     if(price_edit.Text<>'')then begin
        if(TryStrToFloat(price_edit.Text,userPrice))then begin
          //Format('%.2f',[newQty]);
             //count_edit.Text:=floatToStr(strToFloat(price_edit.Text)/price);
             count_edit.Text:= Format('%.2f',[(strToFloat(price_edit.Text)/price)]);
        end else begin
             showMessage('Please insert a valid integer.');
             price_edit.Text:='';
        end;
     end;
  end;
end;

procedure TquantityEdit_frm.remove_btnClick(Sender: TObject);
begin
  myTicket.removeItemFromticket(ticket_id);
  myTicket.populateTicket;
  if(myTicket.getSubTotal <> '0')then begin
          main_form.subTotal.Caption:=myTicket.getSubTotal;{get and display subtotal}
  end else begin
      main_form.subTotal.Caption:='0.00';
  end;
  quantityEdit_frm.Close;
end;

procedure TquantityEdit_frm.saveCount_btnClick(Sender: TObject);
begin
       if(TryStrToFloat(count_edit.Text,count))then begin
             count:=strToFloat(count_edit.Text);
             if((count>quantity) and ((stockLeft-((count-quantity)*qty))>=0) and (count<>0))then begin
                  stockLeft:=stockLeft-((count-quantity)*qty);
                  myTicket.autoUpdateStockLeftOnSameVarId(stockLeft,variation_id);
                  myTicket.addQuantityOnIteminTicket(ticket_id,price,count,stockLeft);
                  count_edit.Text:='';
                  stockLeft:=0;
                  quantityEdit_frm.Close;
             end
             else if((count<quantity) and ((stockLeft+((quantity-count)*qty))>=0) and (count<>0))then begin
                  stockLeft:=stockLeft+((quantity-count)*qty);
                  myTicket.autoUpdateStockLeftOnSameVarId(stockLeft,variation_id);
                  myTicket.addQuantityOnIteminTicket(ticket_id,price,count,stockLeft);
                  count_edit.Text:='';
                  stockLeft:=0;
                  quantityEdit_frm.Close;
             end else begin
                  showMessage('kindly double check the quantity.');
                  quantityEdit_frm.Close;
             end;

             myTicket.populateTicket;{populate item in ticket}
             if((myTicket.getSubTotal <> '0') and (count<>0))then begin
                  main_form.subTotal.Caption:=myTicket.getSubTotal;{get and display subtotal}
             end else begin
                  main_form.subTotal.Caption:='0.00';
             end;
        end else begin
             showMessage('Please insert a valid integer.');
             count_edit.Text:='';
        end;
        count_edit.Text:='';

end;

end.

