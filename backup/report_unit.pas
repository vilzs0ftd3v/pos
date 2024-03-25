unit report_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, RLReport;

type

  { Treports_frm }

  Treports_frm = class(TForm)
    date1: TRLDBText;
    name_db1: TRLDBText;
    receiptDetails_ds: TDataSource;
    reprintReceipt_ds: TDataSource;
    date: TRLDBText;
    reprintReceipt_frm: TRLReport;
    reprintReceipt_no: TRLDBText;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLBand5: TRLBand;
    RLBand6: TRLBand;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    solution1: TRLDBText;
    reprint_subtotal: TRLDBText;
    total: TRLDBText;
    RLLabel3: TRLLabel;
    solution: TRLDBText;
    RLBand1: TRLBand;
    receipt_no: TRLDBText;
    RLBand2: TRLBand;
    name_db: TRLDBText;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    receiptDetails_frm: TRLReport;
    subtotal: TRLDBText;
    reprintReceiptTotal: TRLDBText;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  reports_frm: Treports_frm;

implementation

{$R *.lfm}

{ Treports_frm }

procedure Treports_frm.FormCreate(Sender: TObject);
begin

end;

end.

