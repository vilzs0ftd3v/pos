unit main_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  ComCtrls, Menus, StdCtrls, DBGrids, DBCtrls, JButton, JDBGridControl,
  jdblabeledcurrencyedit, pos_unit, DB, process, ticket_unit,quantityEdit_unit;

type

  { Tmain_form }

  Tmain_form = class(TForm)
    ApplicationProperties1: TApplicationProperties;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    mainItemSearch_grid: TDBGrid;
    MenuItem1: TMenuItem;
    MenuItem3: TMenuItem;
    Panel2: TPanel;
    Process1: TProcess;
    retailMainDs: TDataSource;
    wholesaleMainDs: TDataSource;
    subTotal: TLabel;
    ticket_grid: TDBGrid;
    tender_edit: TEdit;
    change_edit: TEdit;
    JButton2: TJButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem5: TMenuItem;
    Panel1: TPanel;
    pay_btn: TJButton;
    search_edit: TEdit;
    sellTypes_cmb: TComboBox;
    StatusBar1: TStatusBar;
    ticketDs: TDataSource;
    MainMenu1: TMainMenu;
    sales_item: TMenuItem;
    MenuItem2: TMenuItem;
    isAlphabetical: TMenuItem;
    MenuItem4: TMenuItem;
    close_btn: TSpeedButton;
    procedure ApplicationProperties1Activate(Sender: TObject);
    procedure ApplicationProperties1Deactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure mainItemSearch_gridCellClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure close_btnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure JButton2Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure sales_itemClick(Sender: TObject);
    procedure pay_btnClick(Sender: TObject);
    procedure search_editKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure search_editKeyPress(Sender: TObject; var Key: char);
    procedure sellTypes_cmbChange(Sender: TObject);

    procedure tender_editChange(Sender: TObject);
    procedure ticket_gridCellClick(Column: TColumn);
  private

  public
  procedure getValueFromGrid;
  procedure populateItem(keyword:string;sellTypes:string;isCheckAlphabetical:boolean);
  procedure setTableCols(sellTypes:string);
  end;

var
  main_form: Tmain_form;
  MouseIsDown:boolean;
  PX,PY:integer;
  myTicket:Ticket;

  variation_id, unit_id:integer;
  prices, quantity, stockLeft, qty, cost:double;
  variation_name,units:string;

implementation
uses LCLType, login_unit, search_unit,report_unit,sales_unit, item_unit, cash_unit;
{$R *.lfm}

{ Tmain_form }
                            //-------------------------//
procedure Tmain_form.getValueFromGrid;
begin
     variation_id:=mainItemSearch_grid.DataSource.DataSet.Fields[0].Value;
     unit_id:=mainItemSearch_grid.DataSource.DataSet.Fields[7].Value;
     prices:=mainItemSearch_grid.DataSource.DataSet.Fields[2].Value;
     stockLeft:=((mainItemSearch_grid.DataSource.DataSet.Fields[3].Value));
     qty:=mainItemSearch_grid.DataSource.DataSet.Fields[6].Value;
     quantity:=1;
     cost:=mainItemSearch_grid.DataSource.DataSet.Fields[5].Value;
     variation_name:=mainItemSearch_grid.DataSource.DataSet.Fields[1].Value;
     units:=mainItemSearch_grid.DataSource.DataSet.Fields[4].Value;
end;
procedure Tmain_form.populateItem(keyword:string;sellTypes:string;isCheckAlphabetical:boolean);
begin

     if(isCheckAlphabetical)then begin
        pos_dm.populateSearchItem(keyword+'%',sellTypes);
     end else begin
        pos_dm.populateSearchItem('%'+keyword+'%',sellTypes);
     end;

     setTableCols(sellTypes);
end;
procedure Tmain_form.setTableCols(sellTypes:string);
begin
     if(sellTypes = 'retail')then begin
        mainItemSearch_grid.DataSource:= retailMainDs;
     end;

     if(sellTypes = 'wholesale')then begin
        mainItemSearch_grid.DataSource:= wholesaleMainDs;
     end;
end;                //----------------------------//


procedure Tmain_form.close_btnClick(Sender: TObject);
begin
  login_frm.close;
end;

procedure Tmain_form.FormShow(Sender: TObject);
begin
   //main_form.Hide;
   //login_frm.ShowModal;

  myTicket.populateTicket;{populate item in ticket}
     if(myTicket.getSubTotal <> '0')then begin
          subTotal.Caption:=myTicket.getSubTotal;{get and display subtotal}
     end else begin
          subTotal.Caption:='0.00';
     end;


   ticket_grid.Columns.Items[0].Width:=(ticket_grid.Width-419);
end;

procedure Tmain_form.JButton2Click(Sender: TObject);
begin
  myTicket.cancelTicket;
  subTotal.Caption:='0.00';

end;

procedure Tmain_form.MenuItem1Click(Sender: TObject);
begin
  item_frm.ShowModal;
end;

procedure Tmain_form.MenuItem3Click(Sender: TObject);
begin
  cash_frm.showModal;
end;

procedure Tmain_form.sales_itemClick(Sender: TObject);
begin
     //pos_dm.configDB;
     sales_frm.ShowModal;
end;

procedure Tmain_form.pay_btnClick(Sender: TObject);
var
   tendered,subtotals:double;
begin

     if(tender_edit.Text<>'')then begin
        if((TryStrToFloat(tender_edit.Text,tendered)) and (TryStrToFloat(stringReplace(subtotal.Caption,',','',[rfReplaceAll,rfIgnoreCase]),subtotals)))then begin
             if(tendered>=subtotals)then begin

                  //showMessage(intToStr(myTicket.receiptNo));
                  reports_frm.receipt_no.Text:=intToStr(myTicket.receiptNo);
                  reports_frm.total.Text:=subTotal.Caption;

                  //myTicket.saveItemsOnReceipt(myTicket.invoice_id,tendered,0);
                  myTicket.saveItemsOnReceipt(myTicket.receiptNo,tendered,0);
                  pos_dm.populateReceiptTicket;
                  reports_frm.receiptDetails_frm.PreviewModal;
                  myTicket.cancelTicket;
                  tender_edit.Text:='0.00';
                  change_edit.Text:='0.00';
                  myTicket.populateTicket;{populate item in ticket}


                  search_edit.SetFocus;
                  if(myTicket.getSubTotal <> '0')then begin
                      subTotal.Caption:=myTicket.getSubTotal;{get and display subtotal}
                  end else begin
                      subTotal.Caption:='0.00';
                  end;

             end;
        end else begin
             showMessage('Please insert a valid integer.');
             tender_edit.Text:='';
        end;
     end else begin
          showMessage('Please input a tendered amount.');
     end;



end;

procedure Tmain_form.search_editKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_RETURN) then begin
         if(search_edit.Text<>'')then begin
             search_frm.populateItem(main_form.search_edit.Text,main_form.sellTypes_cmb.Text,main_form.isAlphabetical.Checked);
             myTicket.populateTicket;{populate item in ticket}
              if(search_frm.retailDs.DataSet.RecordCount = 1 ) then begin  {check upon clicking on table if theres an item results}
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


  end else if(search_frm.retailDs.DataSet.RecordCount = 0) then begin
              showMessage('Item does not exist.');
  end else begin

            //search_frm.Show;  //change from showModal to Show
  end;


         end else begin
              showMessage('Kindly key in a search value.');
         end;
   end;
end;

procedure Tmain_form.search_editKeyPress(Sender: TObject; var Key: char);
begin
  if Key=#13 then
  begin
       //showMessage('Kindly key in a search value.');
  end;
end;

procedure Tmain_form.sellTypes_cmbChange(Sender: TObject);
begin
     showMessage(sellTypes_cmb.Text);
end;



procedure Tmain_form.tender_editChange(Sender: TObject);
var
   tendered,subtotals:double;
   changeVal:string;
begin
  if(tender_edit.Text<>'')then begin
        if((TryStrToFloat(tender_edit.Text,tendered)) and (TryStrToFloat(stringReplace(subtotal.Caption,',','',[rfReplaceAll,rfIgnoreCase]),subtotals)) )then begin
             change_edit.Text:=Format('%.2f',[tendered-subtotals]);
        end else begin
             change_edit.Text:='invalid';
        end;
  end else begin
        change_edit.Text:='0.00';
  end;

end;

procedure Tmain_form.ticket_gridCellClick(Column: TColumn);
begin
  if(ticket_grid.DataSource.DataSet.RecordCount<>0)then begin

       quantityEdit_frm.ticket_id:=ticket_grid.DataSource.DataSet.Fields[0].Value;
       quantityEdit_frm.price:=ticket_grid.DataSource.DataSet.Fields[4].Value;
       quantityEdit_frm.stockLeft:=ticket_grid.DataSource.DataSet.Fields[6].Value;
       quantityEdit_frm.qty:=ticket_grid.DataSource.DataSet.Fields[7].Value;
       quantityEdit_frm.variation_id:=ticket_grid.DataSource.DataSet.Fields[1].Value;
       quantityEdit_frm.quantity:=ticket_grid.DataSource.DataSet.Fields[5].Value;

       quantityEdit_frm.price_edit.Text:=ticket_grid.DataSource.DataSet.Fields[4].Value;
       if(quantityEdit_frm.qty<>1)then begin
            quantityEdit_frm.price_edit.Enabled:=false;
       end else begin
            quantityEdit_frm.price_edit.Enabled:=true;
       end;


       quantityEdit_frm.ShowModal;
  end;

end;

procedure Tmain_form.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
     MouseIsDown:=true;
     PX:=X;
     PY:=Y;
   end;
end;

procedure Tmain_form.ApplicationProperties1Activate(Sender: TObject);
begin
  pos_dm.connectDB;
  myTicket.populateTicket;{populate item in ticket}
  subTotal.Caption:=myTicket.getSubTotal;{get and display subtotal}
end;

procedure Tmain_form.ApplicationProperties1Deactivate(Sender: TObject);
begin
  pos_dm.disconnectDB;
end;

procedure Tmain_form.FormClose(Sender: TObject; var CloseAction: TCloseAction);

begin

end;

procedure Tmain_form.mainItemSearch_gridCellClick(Column: TColumn);
begin
 if(retailMainDs.DataSet.RecordCount <>0 ) then begin  {check upon clicking on table if theres an item results}

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
     mainItemSearch_grid.DataSource.DataSet.Locate('unit_id',unit_id,[]);{auto focus to the item that recently added}
  end;

  {==========================================================================}
end;

procedure Tmain_form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;


procedure Tmain_form.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown then begin
    SetBounds(Left+(X-PX),Top+(Y-PY),Width,Height);
  end;
end;

procedure Tmain_form.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown:=False;
end;

end.

