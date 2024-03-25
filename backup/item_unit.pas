unit item_unit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls, JButton;

type

  { Titem_frm }

  Titem_frm = class(TForm)
    barcode_edit: TEdit;
    Bevel10: TBevel;
    Label1: TLabel;
    quantity_edit: TEdit;
    unit_edit: TEdit;
    cost_edit: TEdit;
    wholesale_edit: TEdit;
    retail_edit: TEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    close_btn: TSpeedButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    JButton2: TJButton;
    JButton3: TJButton;
    JButton4: TJButton;
    Panel1: TPanel;
    save_btn: TJButton;
    save_btn1: TJButton;
    search_edit: TEdit;
    name_edit: TEdit;
    category_edit: TEdit;
    procedure close_btnClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure JButton2Click(Sender: TObject);
    procedure save_btnClick(Sender: TObject);

  private

  public

  end;

var
  item_frm: Titem_frm;

  MouseIsDown:boolean;
  PX,PY:integer;


implementation

{$R *.lfm}

{ Titem_frm }

procedure Titem_frm.close_btnClick(Sender: TObject);
begin
  item_frm.Close;
end;

procedure Titem_frm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
     MouseIsDown:=true;
     PX:=X;
     PY:=Y;
   end;
end;

procedure Titem_frm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown then begin
    SetBounds(Left+(X-PX),Top+(Y-PY),Width,Height);
  end;
end;

procedure Titem_frm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseIsDown:=False;
end;

procedure Titem_frm.JButton2Click(Sender: TObject);
begin
    showMessage('delete button click!');
end;

procedure Titem_frm.save_btnClick(Sender: TObject);
begin
     showMessage('save button click!');
end;



end.

