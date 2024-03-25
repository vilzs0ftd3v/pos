program pos;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, login_unit, pos_unit, main_unit, search_unit, ticket_unit,
  quantityEdit_unit, report_unit, sales_unit, salesModification_unit, 
salesQuantity_unit, item_unit, cash_unit;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tpos_dm, pos_dm);
  Application.CreateForm(Tlogin_frm, login_frm);
  Application.CreateForm(Tmain_form, main_form);
  Application.CreateForm(Tsearch_frm, search_frm);
  Application.CreateForm(TquantityEdit_frm, quantityEdit_frm);
  Application.CreateForm(Treports_frm, reports_frm);
  Application.CreateForm(Tsales_frm, sales_frm);
  Application.CreateForm(TsalesQuantity_frm, salesQuantity_frm);
  Application.CreateForm(Titem_frm, item_frm);
  Application.CreateForm(Tcash_frm, cash_frm);
  Application.Run;
end.

