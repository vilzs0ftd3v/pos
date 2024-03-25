unit salesModification_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,pos_unit,Dialogs,DB;
type
  Sales = object
  private
  public
  procedure displaySalesHistory(ticket_no:string;dateFrom:string;dateTo:string);
  procedure displaySalesDetailsHistory(ticket_no:string);
  procedure closeSalesHistoryConnection;

  procedure cancelInvoicePerReceipt(receipt_no:string;cancelType:string);
  procedure cancelInvoicePerItem(receipt_no:string;cancelType:string);
  end;

implementation
procedure Sales.closeSalesHistoryConnection;
begin
     pos_dm.sales_query.Close;
     pos_dm.salesDetails_query.Close;
end;

procedure Sales.displaySalesHistory(ticket_no:string;dateFrom:string;dateTo:string);
begin
     pos_dm.sales_query.Close;
     pos_dm.sales_query.Params.ParamByName('keyword').Value:=ticket_no;
     pos_dm.sales_query.Params.ParamByName('fromDate').Value:=dateFrom;
     pos_dm.sales_query.Params.ParamByName('toDate').Value:=dateTo;
     pos_dm.sales_query.Open;
end;
procedure Sales.displaySalesDetailsHistory(ticket_no:string);
begin
     pos_dm.salesDetails_query.Close;
     pos_dm.salesDetails_query.Params.ParamByName('keyword').AsString:=ticket_no;
     //showMessage(ticket_no);
     pos_dm.salesDetails_query.Open;
end;

procedure Sales.cancelInvoicePerReceipt(receipt_no:string;cancelType:string);
begin
     pos_dm.cancelinvoice_query.Clear;
     if(cancelType = 'return')then begin
          pos_dm.cancelinvoice_query.SQL.Add('update invoice_tbl set status = :status where receipt_no =:receipt_no;');
          pos_dm.cancelinvoice_query.Params.ParamByName('status').AsString:='return';
          pos_dm.cancelinvoice_query.Params.ParamByName('receipt_no').AsString:=receipt_no;
          pos_dm.cancelinvoice_query.ExecSQL;
          pos_dm.SqlTransaction.CommitRetaining;
     end;
     if(cancelType = 'void')then begin
          showMessage('void');
     end;
     if(cancelType = 'credit')then begin
          showMessage('credit');
     end;
end;
procedure Sales.cancelInvoicePerItem(receipt_no:string;cancelType:string);
begin

     if(cancelType = 'return')then begin
          showMessage('return');
     end;
     if(cancelType = 'void')then begin
          showMessage('void');
     end;
     if(cancelType = 'credit')then begin
          showMessage('credit');
     end;
end;
end.

