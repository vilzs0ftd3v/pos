unit search_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  Buttons, StdCtrls,pos_unit, DB, main_unit, ticket_unit;

type

  { Tsearch_frm }

  Tsearch_frm = class(TForm)
    Button1: TButton;
    close_btn: TSpeedButton;
    wholesaleDs: TDataSource;
    retailDs: TDataSource;
    itemSearch_grid: TDBGrid;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure close_btnClick(Sender: TObject);
    procedure itemSearch_gridCellClick(Column: TColumn);
    procedure itemSearch_gridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private

  public
        procedure populateItem(keyword:string;sellTypes:string;isCheckAlphabetical:boolean);
        procedure setTableCols(sellTypes:string);
        procedure getValueFromGrid;
  end;

var
  search_frm: Tsearch_frm;
  MouseIsDown:boolean;
  PX,PY:integer;
  myTicket:Ticket;
  variation_id, unit_id:integer;
  prices, quantity, stockLeft, qty, cost:double;
  variation_name,units:string;
implementation
 uses LCLType;
{$R *.lfm}

{ Tsearch_frm }
procedure Tsearch_frm.getValueFromGrid;
begin
     variation_id:=itemSearch_grid.DataSource.DataSet.Fields[0].Value;
     unit_id:=itemSearch_grid.DataSource.DataSet.Fields[7].Value;
     prices:=itemSearch_grid.DataSource.DataSet.Fields[2].Value;
     stockLeft:=((itemSearch_grid.DataSource.DataSet.Fields[3].Value));
     qty:=itemSearch_grid.DataSource.DataSet.Fields[6].Value;
     quantity:=1;
     cost:=itemSearch_grid.DataSource.DataSet.Fields[5].Value;
     variation_name:=itemSearch_grid.DataSource.DataSet.Fields[1].Value;
     units:=itemSearch_grid.DataSource.DataSet.Fields[4].Value;
end;

procedure Tsearch_frm.populateItem(keyword:string;sellTypes:string;isCheckAlphabetical:boolean);
begin

     if(isCheckAlphabetical)then begin
        pos_dm.populateSearchItem(keyword+'%',sellTypes);
     end else begin
        pos_dm.populateSearchItem('%'+keyword+'%',sellTypes);
     end;

     setTableCols(sellTypes);
end;
procedure Tsearch_frm.setTableCols(sellTypes:string);
begin
     if(sellTypes = 'retail')then begin
        itemSearch_grid.DataSource:= retailDs;
     end;

     if(sellTypes = 'wholesale')then begin
        itemSearch_grid.DataSource:= wholesaleDs;
     end;
end;
procedure Tsearch_frm.FormShow(Sender: TObject);
begin
     populateItem(main_form.search_edit.Text,main_form.sellTypes_cmb.Text,main_form.isAlphabetical.Checked);
     myTicket.populateTicket;{populate item in ticket}


end;
procedure Tsearch_frm.close_btnClick(Sender: TObject);
begin
     search_frm.close;
end;

procedure Tsearch_frm.itemSearch_gridCellClick(Column: TColumn);
begin
  if(retailDs.DataSet.RecordCount <>0 ) then begin  {check upon clicking on table if theres an item results}

    getValueFromGrid;

     myTicket.isItemVarIdExist(variation_id,stockLeft);

     if((myTicket.checkItemInTicket(variation_id,unit_id,prices,stockLeft)) and (myTicket.isItemVarIdExist(variation_id,stockLeft) = true) and (myTicket.getStockLeft>=qty)) then begin {check if item is in the ticket_tbl}

       stockLeft:=(myTicket.getStockLeft-qty);
       myTicket.autoUpdateStockLeftOnSameVarId(stockLeft,variation_id);
       myTicket.addQuantityOnIteminTicket(myTicket.getTicketId,prices,(myTicket.getQuantity+1),stockLeft);
     end
     else if((myTicket.checkItemInTicket(variation_id,unit_id,prices,stockLeft)) and (myTicket.isItemVarIdExist(variation_id,stockLeft) = false) and (myTicket.getStockLeft>=qty)) then begin {check if item is in the ticket_tbl}

       stockLeft:=(stockLeft-qty);
       myTicket.addQuantityOnIteminTicket(myTicket.getTicketId,prices,(myTicket.getQuantity+1),stockLeft);
     end
     else if((myTicket.checkItemInTicket(variation_id,unit_id,prices,stockLeft)=false) and (myTicket.isItemVarIdExist(variation_id,stockLeft) = true) and (myTicket.getStockLeft>=qty)) then begin {check if item is in the ticket_tbl}

       stockLeft:=(myTicket.getStockLeft-qty);
       myTicket.autoUpdateStockLeftOnSameVarId(stockLeft,variation_id);//update the stock left of other items with the same ID
       myTicket.insertIteminTicket(variation_id,prices,quantity,variation_name,stockLeft,units,qty,cost,unit_id);{insert into ticket_tbl}
     end
     else if((myTicket.checkItemInTicket(variation_id,unit_id,prices,stockLeft)=false) and (myTicket.isItemVarIdExist(variation_id,stockLeft) = false) and (myTicket.getStockLeft>=qty)) then begin {check if item is in the ticket_tbl}

       stockLeft:=(stockLeft-qty);//get the stockLeft initiate and obtain by isItemVarIdExist method
       myTicket.insertIteminTicket(variation_id,prices,quantity,variation_name,stockLeft,units,qty,cost,unit_id);{insert into ticket_tbl}

     end else begin

       showMessage('Kindy check the stocks left.');
     end;

     myTicket.populateTicket;{populate item in ticket}
     if(myTicket.getSubTotal <> '0')then begin
          main_form.subTotal.Caption:=myTicket.getSubTotal;{get and display subtotal}
     end else begin
          main_form.subTotal.Caption:='0.00';
     end;

     populateItem(main_form.search_edit.Text,main_form.sellTypes_cmb.Text,main_form.isAlphabetical.Checked);{populate item search result}
     itemSearch_grid.DataSource.DataSet.Locate('unit_id',unit_id,[]);{auto focus to the item that recently added}
  end;

  {==========================================================================}


end;

procedure Tsearch_frm.itemSearch_gridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_ESCAPE) then begin
      search_frm.close;
   end;
end;

procedure Tsearch_frm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
     MouseIsDown:=true;
     PX:=X;
     PY:=Y;
   end;
end;

procedure Tsearch_frm.Button1Click(Sender: TObject);
begin
  ManualFloat(Rect(0,0,724,409));
end;

procedure Tsearch_frm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown then begin
    SetBounds(Left+(X-PX),Top+(Y-PY),Width,Height);
  end;
end;

procedure Tsearch_frm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown:=False;
end;

end.

