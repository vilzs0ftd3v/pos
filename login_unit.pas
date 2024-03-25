unit login_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ButtonPanel, Buttons, JButton, pos_unit, main_unit;

type

  { Tlogin_frm }

  Tlogin_frm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Process1: TProcess;
    Process2: TProcess;
    username_edit: TEdit;
    password_edit: TEdit;
    login_btn: TJButton;
    Panel1: TPanel;
    SpeedButton2: TSpeedButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure login_btnClick(Sender: TObject);
    procedure password_editKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure username_editKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private

  public

  end;

var
  login_frm: Tlogin_frm;
  MouseIsDown:boolean;
  PX,PY:integer;

implementation
uses LCLType;
{$R *.lfm}

{ Tlogin_frm }

procedure Tlogin_frm.login_btnClick(Sender: TObject);
begin
     if(pos_dm.allowUserAccess(username_edit.Text,password_edit.Text)) then
       begin

            main_form.Visible:=true;
            login_frm.Hide;
            //main_form.Show;
       end else begin
            showMessage('Incorrect username or password!');
     end;
end;

procedure Tlogin_frm.password_editKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_RETURN) then begin
     if(pos_dm.allowUserAccess(username_edit.Text,password_edit.Text)) then
       begin

            main_form.Visible:=true;
            login_frm.Hide;
       end else begin
            showMessage('Incorrect username or password!');
     end;
   end;
   pos_dm.configDB;
end;

procedure Tlogin_frm.SpeedButton2Click(Sender: TObject);
begin
     login_frm.close;
end;

procedure Tlogin_frm.username_editKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then begin
     if(pos_dm.allowUserAccess(username_edit.Text,password_edit.Text)) then
       begin
            main_form.Visible:=true;
            login_frm.Hide;
       end else begin
            showMessage('Incorrect username or password!');
     end;
   end;

end;

procedure Tlogin_frm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
     MouseIsDown:=true;
     PX:=X;
     PY:=Y;
   end;
end;

procedure Tlogin_frm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
timeNow: string;
begin
  timeNow := FormatDateTime('yy-mm-dd-hh-nn-ss', now);
   Process2.Executable:='C:/mysql-5.7.35-win32/bin/mysqldump';
   with Process2.Parameters do
   begin
     Add('--user=root');
     Add('--password=70986019');
     Add('--host=localhost');
     Add('--protocol=tcp');
     Add('--port=3306');
     Add('--default-character-set=utf8');
     Add('--routines');

     Add('--single-transaction=TRUE');
     Add('--all-databases');
     Add('--result-file=C:/mysql-5.7.35-win32/database/'+timeNow+'.sql');
   end;
   Process2.Options := Process2.Options + [poWaitOnExit, poUsePipes];
   Process2.Execute;
   Process2.free;
   //showMessage('close');
end;



procedure Tlogin_frm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if MouseIsDown then begin
    SetBounds(Left+(X-PX),Top+(Y-PY),Width,Height);
  end;
end;

procedure Tlogin_frm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   MouseIsDown:=False;
end;

procedure Tlogin_frm.FormShow(Sender: TObject);
var
timeNow: string;
begin
     pos_dm.connectDB;

     //pro:=TProcess.Create(nil);
  timeNow := FormatDateTime('yy-mm-dd-hh-nn-ss', now);
  Process1.Executable:='C:/mysql-5.7.35-win32/bin/mysqldump';
  with Process1.Parameters do
  begin
    Add('--user=root');
    Add('--password=70986019');
    Add('--host=localhost');
    Add('--protocol=tcp');
    Add('--port=3306');
    Add('--default-character-set=utf8');
    Add('--routines');

    Add('--single-transaction=TRUE');
    Add('--all-databases');
    Add('--result-file=C:/mysql-5.7.35-win32/database/'+timeNow+'.sql');
  end;
  Process1.Options := Process1.Options + [poWaitOnExit, poUsePipes];
  Process1.Execute;
  Process1.free;

  //ShowMessage('Finished!');

end;

end.

