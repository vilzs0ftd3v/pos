unit sales_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls, Calendar, EditBtn, JLabeledDateEdit, JButton,salesModification_unit,LCLType,salesQuantity_unit,pos_unit;

type

  { Tsales_frm }

  Tsales_frm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    close_btn: TSpeedButton;
    search_btn: TJButton;
    salesDetails_ds: TDataSource;
    salesDetails_grid: TDBGrid;
    void_btn: TJButton;
    credit_btn: TJButton;
    print_btn: TJButton;
    return_btn: TJButton;
    salesTo_date: TJLabeledDateEdit;
    sales_ds: TDataSource;
    sales_grid: TDBGrid;
    salesFrom_date: TJLabeledDateEdit;
    Panel1: TPanel;
    search_edit: TEdit;
    procedure close_btnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure print_btnClick(Sender: TObject);
    procedure return_btnClick(Sender: TObject);
    procedure salesDetails_gridCellClick(Column: TColumn);
    procedure sales_gridCellClick(Column: TColumn);
    procedure search_btnClick(Sender: TObject);
    procedure search_editKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure setQuantityPerItem(count:double);
    function getQuantityPerItem:double;

    procedure setQuantityInDb(count:integer);
    function getQuantityInDb:integer;

    procedure cancelInvoicePerReceipt(cancelType:string);
    procedure cancelInvoicePerItem(cancelType:string);
    procedure void_btnClick(Sender: TObject);
  private

  public
  itemReference_id:integer;
  itemReference_type:string;
  quantityPerItem:double;
  quantityInDb:integer;
  end;

var
  sales_frm: Tsales_frm;
  MouseIsDown:boolean;
  PX,PY:integer;
  MySales:Sales;

implementation
uses report_unit;
{$R *.lfm}

{ Tsales_frm }
procedure Tsales_frm.setQuantityPerItem(count:double);
begin
     quantityPerItem:=count;
end;
function Tsales_frm.getQuantityPerItem:double;
begin
     result:=quantityPerItem;
end;
procedure Tsales_frm.setQuantityInDb(count:integer);
begin
     quantityInDb:=count;
end;
function Tsales_frm.getQuantityInDb:integer;
begin
     result:=quantityInDb;
end;

procedure Tsales_frm.close_btnClick(Sender: TObject);
begin
  MySales.closeSalesHistoryConnection;
  sales_frm.Close;
end;

procedure Tsales_frm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  MySales.closeSalesHistoryConnection;
end;

procedure Tsales_frm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if Button = mbLeft then begin
     MouseIsDown:=true;
     PX:=X;
     PY:=Y;
   end;
end;

procedure Tsales_frm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown then begin
    SetBounds(Left+(X-PX),Top+(Y-PY),Width,Height);
  end;
end;

procedure Tsales_frm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown:=False;
end;

procedure Tsales_frm.FormShow(Sender: TObject);
var
  thisDay:TdateTime;
begin

     search_edit.Text:= '';
     salesFrom_date.Text:='';
     salesTo_date.Text:='';
     thisDay:=Now;

     MySales.displaySalesHistory('',FormatDateTime('YYYY-MM-DD',thisDay),FormatDateTime('YYYY-MM-DD',thisDay));
end;

procedure Tsales_frm.print_btnClick(Sender: TObject);
begin
  pos_dm.populateReprintReceipt(itemReference_id);
  //reports_frm.receipt_no.Text:=intToStr(itemReference_id);
  reports_frm.reprintReceiptTotal.Text:=floatToStr(quantityPerItem);
  reports_frm.reprintReceipt_frm.PreviewModal;

end;

procedure Tsales_frm.return_btnClick(Sender: TObject);
var
  Reply, BoxStyle:integer;
  cancelType:string;
begin
    cancelType:='return';
    if(itemReference_type = 'per item') then begin
          if(salesDetails_grid.DataSource.DataSet.Fields[2].Value > 1)then begin

          end;
    end;

    if(itemReference_type = 'per receipt') then begin
        BoxStyle:=MB_ICONQUESTION+MB_YESNO;
        Reply:=Application.MessageBox('Do you want to return this invoice?','Sales',BoxStyle);
        if Reply = IDYES then begin
             cancelInvoicePerReceipt(cancelType);
           end;
    end;




end;

procedure Tsales_frm.salesDetails_gridCellClick(Column: TColumn);
begin
  itemReference_type:='per item';{refers to only item on an invoice}

  itemReference_id:=salesDetails_grid.DataSource.DataSet.Fields[0].Value;{get the invoice_id}
  setQuantityInDb(salesDetails_grid.DataSource.DataSet.Fields[2].Value);
  if(salesDetails_grid.DataSource.DataSet.Fields[2].Value > 1)then begin
      //salesQuantity_frm.ShowModal;
  end;
end;

procedure Tsales_frm.sales_gridCellClick(Column: TColumn);
begin

  if sales_grid.DataSource.DataSet.IsEmpty = false then begin
     itemReference_type:='per receipt';{all items in invoice or for each receipt}
     itemReference_id:=sales_grid.DataSource.DataSet.Fields[0].Value;{obtain receipt_no}
     quantityPerItem:=sales_grid.DataSource.DataSet.Fields[2].Value;{obtain total}
     MySales.displaySalesDetailsHistory(sales_grid.DataSource.DataSet.Fields[0].Value);
  end;
end;

procedure Tsales_frm.search_btnClick(Sender: TObject);
var
  fromDate,toDate:TdateTime;
begin
  if((salesFrom_date.Text<>'') and (salesTo_date.Text<>'')) then begin
      fromDate:=StrToDateTime(salesFrom_date.Text);
      toDate:=StrToDateTime(salesTo_date.Text);
      MySales.displaySalesHistory('',FormatDateTime('YYYY-MM-DD',fromDate),FormatDateTime('YYYY-MM-DD',toDate));
      salesFrom_date.Text:='';
      salesTo_date.Text:='';
  end else begin
    showMessage('Please select a date.');
  end;

end;

procedure Tsales_frm.search_editKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then begin
     if(search_edit.Text <> '')then begin
          MySales.displaySalesHistory(search_edit.Text,'','');
          search_edit.Text:= '';
     end;
  end;
end;
procedure Tsales_frm.cancelInvoicePerReceipt(cancelType:string);
begin

     pos_dm.cancelinvoice_query.UpdateSQL.Clear;
     if(cancelType = 'return')then begin
          pos_dm.cancelinvoice_query.Clear;
          pos_dm.cancelinvoice_query.UpdateSQL.Add('update invoice_tbl set status =:status where receipt_no =:receipt_no;');
          pos_dm.cancelinvoice_query.Open;
          pos_dm.cancelinvoice_query.Edit;
          pos_dm.cancelinvoice_query.FieldByName('status').Value:='return';
          pos_dm.cancelinvoice_query.FieldByName('receipt_no').Value:=itemReference_id;
          pos_dm.cancelinvoice_query.Post;
          pos_dm.cancelinvoice_query.ApplyUpdates;
          pos_dm.SqlTransaction.Commit;
          pos_dm.cancelinvoice_query.Close;

     end;
     if(cancelType = 'void')then begin
          showMessage('void');
     end;
     if(cancelType = 'credit')then begin
          showMessage('credit');
     end;
end;

procedure Tsales_frm.cancelInvoicePerItem(cancelType:string);
begin

     pos_dm.cancelinvoice_query.UpdateSQL.Clear;
     if(cancelType = 'return')then begin
          pos_dm.cancelinvoice_query.UpdateSQL.Add('update invoice_tbl set status =:status where receipt_no =:receipt_no;');
          pos_dm.cancelinvoice_query.Open;
          pos_dm.cancelinvoice_query.Edit;
          pos_dm.cancelinvoice_query.FieldByName('status').Value:='return';
          pos_dm.cancelinvoice_query.FieldByName('receipt_no').Value:=itemReference_id;
          pos_dm.cancelinvoice_query.Post;
          pos_dm.cancelinvoice_query.ApplyUpdates;
          pos_dm.SqlTransaction.Commit;
          pos_dm.cancelinvoice_query.Close;

     end;
     if(cancelType = 'void')then begin
          showMessage('void');
     end;
     if(cancelType = 'credit')then begin
          showMessage('credit');
     end;
end;

procedure Tsales_frm.void_btnClick(Sender: TObject);
begin

end;

end.

