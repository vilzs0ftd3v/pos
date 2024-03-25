unit ticket_unit;

{$mode ObjFPC}{$H+}


interface

uses
  Classes, SysUtils,pos_unit,Dialogs,DB;

type
Ticket = object
private

       ticket_id, variation_id:integer;
       price,quantity, stockLeft, cost, qty: double;
       variation_name, units:string;
public
       invoice_id:integer;
       procedure setStockLeft(stocks:double);
       function getStockLeft:double;

       procedure setQuantity(quantities:double);
       function getQuantity:double;

       procedure setTicketId(ticket_ids:integer);
       function getTicketId:integer;

       function getSubTotal:string;
       function checkItemInTicket(variation_ids:integer;unit_ids:integer;prices:double;stockLefts:double):boolean;
       procedure insertIteminTicket(variation_ids:integer;prices:double;quantities:double;variation_names:string;stockLefts:double;unitss:string;qtys:double;costs:double;unit_ids:integer);
       procedure addQuantityOnIteminTicket(ticket_ids:integer;prices:double;quantities:double;stockLefts:double);
       procedure populateTicket;
       procedure cancelTicket;
       function isItemVarIdExist(variation_ids:integer;stockLefts:double):boolean;
       procedure autoUpdateStockLeftOnSameVarId(stocks:double;variation_ids:integer);
       procedure removeItemFromticket(ticket_ids:integer);

       function receiptNo:integer;
       procedure saveItemsOnReceipt(receipt_no:integer;tenderAmount:double;customer_id:integer);

end;

implementation
procedure Ticket.setStockLeft(stocks:double);
begin
     stockLeft:=stocks;
end;
function Ticket.getStockLeft:double;
begin
     result:=stockLeft;
end;
procedure Ticket.setQuantity(quantities:double);
begin
     quantity:=quantities;
end;
function Ticket.getQuantity:double;
begin
     result:=quantity;
end;
procedure Ticket.setTicketId(ticket_ids:integer);
begin
     ticket_id:=ticket_ids;
end;
function Ticket.getTicketId:integer;
begin
     result:=ticket_id;
end;

function Ticket.isItemVarIdExist(variation_ids:integer;stockLefts:double):boolean;
begin

       try
         pos_dm.cartQuery.Close;
         pos_dm.cartQuery.SQL.Clear;
         pos_dm.cartQuery.SQL.Add('SELECT stockLeft FROM ticket_tbl where variation_id=:variation_id');
         pos_dm.cartQuery.Params.ParamByName('variation_id').Value:=variation_ids;
         pos_dm.cartQuery.Open;
         if(pos_dm.cartQuery.RecordCount > 0) then begin
            setStockLeft(pos_dm.cartQuery.Fields[0].Value);
            result:=true;
         end else begin
            setStockLeft(stocklefts);
            result:=false;
         end;
         pos_dm.cartQuery.Close;
         pos_dm.cartQuery.SQL.Clear;
       except
       on E : EDatabaseError do
         showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
       end;
end;

function Ticket.checkItemInTicket(variation_ids:integer;unit_ids:integer;prices:double;stockLefts:double):boolean;
begin
       try

         pos_dm.isItemCart.Close;
         pos_dm.isItemCart.Params.ParamByName('variation_id').Value:=variation_ids;
         pos_dm.isItemCart.Params.ParamByName('unit_id').Value:=unit_ids;
         pos_dm.isItemCart.Params.ParamByName('price').Value:=prices;
         //showMessage(intToStr(unit_ids));
         pos_dm.isItemCart.Open;

         if(pos_dm.isItemCart.RecordCount = 1) then begin
         setStockLeft(pos_dm.isItemCart.Fields[5].Value);
         setQuantity(pos_dm.isItemCart.Fields[3].Value);
         setTicketId(pos_dm.isItemCart.Fields[0].Value);
         result:=true;
         end else begin
           setStockLeft(stockLefts);
           result:=false;
         end;

       except
       on E : EDatabaseError do
         showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
       end;
end;
procedure Ticket.insertIteminTicket(variation_ids:integer;prices:double;quantities:double;variation_names:string;stockLefts:double;unitss:string;qtys:double;costs:double;unit_ids:integer);
begin
     try
       try
         pos_dm.cartQuery.Close;
         pos_dm.cartQuery.SQL.Clear;
         pos_dm.cartQuery.SQL.Add('INSERT INTO ticket_tbl(variation_id,price,quantity,variation_name,stockLeft,unit,qty,cost,unit_id) values(:variation_id,:price,:quantity,:variation_name,:stockLeft,:unit,:qty,:cost,:unit_id);');
         pos_dm.cartQuery.Params.ParamByName('variation_id').Value:=variation_ids;
         pos_dm.cartQuery.Params.ParamByName('price').Value:=prices;
         pos_dm.cartQuery.Params.ParamByName('quantity').Value:=quantities;
         pos_dm.cartQuery.Params.ParamByName('variation_name').Value:=variation_names;
         pos_dm.cartQuery.Params.ParamByName('stockLeft').Value:=stockLefts;
         pos_dm.cartQuery.Params.ParamByName('unit').Value:=unitss;
         pos_dm.cartQuery.Params.ParamByName('qty').Value:=qtys;
         pos_dm.cartQuery.Params.ParamByName('cost').Value:=costs;
         pos_dm.cartQuery.Params.ParamByName('unit_id').Value:=unit_ids;
         pos_dm.cartQuery.ExecSQL;
         pos_dm.SqlTransaction.Commit;
       except
       on E : EDatabaseError do
         showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
       end;
     finally

     end;

end;
procedure Ticket.addQuantityOnIteminTicket(ticket_ids:integer;prices:double;quantities:double;stockLefts:double);
begin
     try
        pos_dm.addQuantity_query.Close;
        pos_dm.addQuantity_query.Params.ParamByName('ticket_id').Value:=ticket_ids;
        pos_dm.addQuantity_query.Open;

        if(pos_dm.addQuantity_query.RecordCount<>0)then begin
             pos_dm.addQuantity_query.Edit;
             pos_dm.addQuantity_query.FieldByName('stockLeft').Value:=stockLefts;
             pos_dm.addQuantity_query.FieldByName('price').Value:=prices;
             pos_dm.addQuantity_query.FieldByName('quantity').Value:=quantities;
             pos_dm.addQuantity_query.Post;
             pos_dm.addQuantity_query.ApplyUpdates;
             pos_dm.SqlTransaction.Commit;
        end else begin
             pos_dm.addQuantity_query.Close;
        end;

     except
     on E:EDatabaseError do
      showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
     end;
end;
procedure Ticket.populateTicket;
begin
     try
       try
         pos_dm.ticketQuery.Close;
         pos_dm.ticketQuery.Open;
       except
       on E : EDatabaseError do
         showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
       end;
     finally

     end;

end;
function Ticket.getSubTotal:string;
begin
     try
       try
         pos_dm.subTotalQuery.Close;
         pos_dm.subTotalQuery.Open;
         result:=pos_dm.subTotalQuery.Fields[0].AsString;
       except
       on E : EDatabaseError do
         showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
       end;
     finally

     end;
end;
procedure Ticket.cancelTicket;
begin
     try
       try
         pos_dm.cartQuery.SQL.Clear;
         pos_dm.cartQuery.SQL.Add('DELETE FROM ticket_tbl;');
         pos_dm.cartQuery.ExecSQL;
         pos_dm.SqlTransaction.Commit;
       except
       on E : EDatabaseError do
         showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
       end;
     finally

     end;


end;
procedure Ticket.autoUpdateStockLeftOnSameVarId(stocks:double;variation_ids:integer);
begin
     try
        pos_dm.updateTicket.Close;
        pos_dm.updateTicket.Params.ParamByName('variation_id').Value:=variation_ids;
        pos_dm.updateTicket.Open;

        if(pos_dm.updateTicket.RecordCount<>0)then begin
             pos_dm.updateTicket.Edit;
             pos_dm.updateTicket.FieldByName('stockLeft').Value:=stocks;
             pos_dm.updateTicket.FieldByName('variation_id').Value:=variation_ids;
             pos_dm.updateTicket.Post;
             pos_dm.updateTicket.ApplyUpdates;
             pos_dm.SqlTransaction.Commit;
        end else begin
             pos_dm.updateTicket.Close;
        end;

     except
     on E:EDatabaseError do
      showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
     end;
end;
procedure Ticket.removeItemFromticket(ticket_ids:integer);
begin
       try
            pos_dm.cartQuery.Close;
            pos_dm.cartQuery.SQL.Clear;
            pos_dm.cartQuery.SQL.Text:='DELETE FROM ticket_tbl where ticket_id = :ticket_id;';
            pos_dm.cartQuery.Params.ParamByName('ticket_id').AsInteger:=ticket_ids;
            pos_dm.cartQuery.ExecSQL;
            pos_dm.SqlTransaction.Commit;
       except
       on E : EDatabaseError do
            showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
       end;
end;

procedure Ticket.saveItemsOnReceipt(receipt_no:integer;tenderAmount:double;customer_id:integer);
begin
     try
        pos_dm.cartQuery.Close;
        pos_dm.cartQuery.SQL.Clear;
        pos_dm.cartQuery.SQL.Text:='call invoice(:receipt_no,:tenderAmount,:customer_id);';
        pos_dm.cartQuery.Params.ParamByName('receipt_no').AsInteger:=receipt_no;
        pos_dm.cartQuery.Params.ParamByName('tenderAmount').AsFloat:=tenderAmount;
        pos_dm.cartQuery.Params.ParamByName('customer_id').AsInteger:=customer_id;
        pos_dm.cartQuery.ExecSQL;
        pos_dm.SqlTransaction.Commit;
     except
     on E : EDatabaseError do
            showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
     end;
end;
function Ticket.receiptNo:integer;
begin
     try
     pos_dm.getInvoiceReceiptQuery.Close;
     pos_dm.getInvoiceReceiptQuery.Open;
     if(pos_dm.getInvoiceReceiptQuery.RecordCount<>0)then begin
          result:=pos_dm.getInvoiceReceiptQuery.Fields[0].Value;
     end else begin
          result:=0;
     end;
     except
     on E : EDatabaseError do
            showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
     end;
end;

end.

