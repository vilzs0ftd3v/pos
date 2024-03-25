unit pos_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql57conn, SQLDB, Dialogs, DB;

type

  { Tpos_dm }

  Tpos_dm = class(TDataModule)
    dbConnection: TMySQL57Connection;
    loginQuery: TSQLQuery;
    retailQuery: TSQLQuery;
    isItemCart: TSQLQuery;
    cartQuery: TSQLQuery;
    addQuantity_query: TSQLQuery;
    getInvoiceReceiptQuery: TSQLQuery;
    receiptDetails_query: TSQLQuery;
    sales_query: TSQLQuery;
    config_query: TSQLQuery;
    salesDetails_query: TSQLQuery;
    cancelinvoice_query: TSQLQuery;
    reprintReceipt_query: TSQLQuery;
    updateTicket: TSQLQuery;
    subTotalQuery: TSQLQuery;
    ticketQuery: TSQLQuery;
    wholesaleQuery: TSQLQuery;
    SqlTransaction: TSQLTransaction;

  private

  public
        {configure db -----------------------------------------------db con}
        procedure configDB;
        {db con -----------------------------------------------------db con}

        {db con -----------------------------------------------------db con}
        function connectDB:boolean;
        {db con -----------------------------------------------------db con}

        {db con -----------------------------------------------------db con}
        function disconnectDB:boolean;
        {db con -----------------------------------------------------db con}

        {login -------------------------------------------------------login}
        function allowUserAccess(username:string;password:string):boolean;
        {login -------------------------------------------------------login}

        {POS item -----------------------------------------------------item}
        procedure populateSearchItem(keyword:string;sellTypes:string);
        {item ---------------------------------------------------------item}

        {ticket -----------------------------------------------------ticket}
        procedure populateTicket;
        {ticket -----------------------------------------------------ticket}

        {receipt ticket ---------------------------------------------ticket}
        procedure populateReceiptTicket;
        {receipt ticket ---------------------------------------------ticket}

        {reprint receipt ---------------------------------------------reprint receipt}
        procedure populateReprintReceipt(receipt_no:integer);
        {reprint receipt ---------------------------------------------reprint receipt}

  end;

var
  pos_dm: Tpos_dm;

implementation
uses LCLType;
{$R *.lfm}



procedure Tpos_dm.configDB;
begin

    config_query.SQL.Clear;
    config_query.SQL.Add('set GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,"ONLY_FULL_GROUP_BY",""));');
    config_query.ExecSQL;
    SqlTransaction.Commit;

    config_query.SQL.Clear;
    config_query.SQL.Add('set GLOBAL sql_mode="ALLOW_INVALID_DATES";');
    config_query.ExecSQL;
    SqlTransaction.Commit;
end;
function Tpos_dm.connectDB:boolean;
begin
     try
       dbConnection.DatabaseName:='pos_db';
       dbConnection.HostName:='localhost';
       dbConnection.Port:=3306;
       dbConnection.Username:='root';
       dbConnection.Password:='70986019';
       dbConnection.Transaction:=SqlTransaction;
       dbConnection.Connected:=true;
       result:=true;
     except
       on E : EDatabaseError do
       begin
       showMessage('DB ERROR:'+' '+ E.ClassName+' '+ E.Message);
        result:=false;
       end;
     end;
end;
function Tpos_dm.disconnectDB:boolean;
begin
     dbConnection.Connected:=false;
end;

{login -------------------------------------------------------------------login}
function Tpos_dm.allowUserAccess(username:string;password:string):boolean;
begin
       loginQuery.Close;
       loginQuery.Params.ParamByName('username').Value:=username;
       loginQuery.Params.ParamByName('password').Value:=password;
       loginQuery.Open;
       if (loginQuery.RecordCount = 1) then
         begin
              result:=true;
         end else begin
              result:=false;
         end;
end;
{POS item -----------------------------------------------------------------item}
procedure Tpos_dm.populateSearchItem(keyword:string;sellTypes:string);
begin
     if(sellTypes = 'retail')then begin
       retailQuery.Close;
       retailQuery.Params.ParamByName('keyword').Value:=keyword;
       retailQuery.Open;
     end;

     if(sellTypes = 'wholesale')then begin
       wholesaleQuery.Close;
       wholesaleQuery.Params.ParamByName('keyword').Value:=keyword;
       wholesaleQuery.Open;
     end;
end;
{ticket -----------------------------------------------------ticket in main form}
procedure Tpos_dm.populateTicket;
begin
     ticketQuery.Close;
     ticketQuery.Open;
end;
{ticket -----------------------------------------------------ticket in receipt form}
procedure Tpos_dm.populateReceiptTicket;
begin
     receiptDetails_query.Close;
     receiptDetails_query.Open;
end;
procedure Tpos_dm.populateReprintReceipt(receipt_no:integer);
begin
     reprintReceipt_query.Close;
     reprintReceipt_query.Params.ParamByName('receipt_no').Value:=receipt_no;
     reprintReceipt_query.Open;
end;

end.

