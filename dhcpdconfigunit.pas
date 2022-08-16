unit dhcpdconfigunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Grids, StdCtrls, ValEdit;

type

  { Tdhcpconfigform }

  Tdhcpconfigform = class(TForm)
    host_fixedaddress_edit: TLabeledEdit;
    host_mac_edit1: TLabeledEdit;
    host_filename_edit: TLabeledEdit;
    host_servername_edit: TLabeledEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    subnetlist_combobox: TComboBox;
    StatusBar1: TStatusBar;
    host_comment_edit: TLabeledEdit;
    host_hardware_edit: TLabeledEdit;
    host_grid: TStringGrid;
    subnet_addupdate_button1: TButton;
    subnet_routers_edit: TEdit;
    Label3: TLabel;
    subnet_domainnameservers_edit: TEdit;
    Label2: TLabel;
    subnet_addupdate_button: TButton;
    Label1: TLabel;
    PageControl2: TPageControl;
    subnet_domainnameservers_grid: TStringGrid;
    subnet_routers_grid: TStringGrid;
    subnet_range_bootpa_edit: TLabeledEdit;
    subnet_broadcast_edit: TLabeledEdit;
    subnet_defaultleasetime_edit: TLabeledEdit;
    subnet_maxleasetime_edit: TLabeledEdit;
    subnet_comment_edit: TLabeledEdit;
    subnet_range_bootpb_edit: TEdit;
    subnet_domainname_edit: TLabeledEdit;
    subnet_rangeb_edit: TEdit;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    subnet_subnet_edit: TLabeledEdit;
    subnet_netmask_edit: TLabeledEdit;
    subnet_rangea_edit: TLabeledEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    subnet_grid: TStringGrid;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure host_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure subnet_addupdate_buttonClick(Sender: TObject);
    procedure subnet_domainnameservers_editKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure subnet_domainnameservers_gridClick(Sender: TObject);
    procedure subnet_domainnameservers_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure subnet_gridClick(Sender: TObject);
    procedure subnet_gridColRowInserted(Sender: TObject; IsColumn: boolean; sIndex, tIndex: integer);
    procedure subnet_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure subnet_routers_editKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure subnet_routers_gridClick(Sender: TObject);
    procedure subnet_routers_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure loadSubnets;
    procedure saveTemp;
  private

  public

  end;

var
  dhcpconfigform: Tdhcpconfigform;

implementation

uses DataTypeUnit, SGUnit, LCLType;

{$R *.lfm}

{ Tdhcpconfigform }

procedure Tdhcpconfigform.subnet_domainnameservers_editKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    if (subnet_domainnameservers_edit.Text <> '') and (DTValidIP(subnet_domainnameservers_edit.Text) or
      DTValidIP6(subnet_domainnameservers_edit.Text) or DTValidURI(subnet_domainnameservers_edit.Text)) then
    begin
      if sgFindItemRowInColumn(subnet_domainnameservers_grid, 0, subnet_domainnameservers_edit.Text) < 0 then
      begin
        subnet_domainnameservers_grid.InsertRowWithValues(subnet_domainnameservers_grid.RowCount, subnet_domainnameservers_edit.Text);
        saveTemp;
      end;
    end;
  end;
end;

procedure Tdhcpconfigform.subnet_domainnameservers_gridClick(Sender: TObject);
begin
  if subnet_domainnameservers_grid.Row > 0 then
    subnet_domainnameservers_edit.Text := subnet_domainnameservers_grid.Cells[0, subnet_domainnameservers_grid.Row];
end;

procedure Tdhcpconfigform.subnet_domainnameservers_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_DELETE then
    if subnet_domainnameservers_grid.Row > 0 then
      subnet_domainnameservers_grid.DeleteRow(subnet_domainnameservers_grid.Row);
end;

procedure Tdhcpconfigform.subnet_gridClick(Sender: TObject);
begin
  if subnet_grid.Row > 0 then
  begin
    subnet_comment_edit.Text := subnet_grid.Cells[0, subnet_grid.Row];
    subnet_subnet_edit.Text := subnet_grid.Cells[1, subnet_grid.Row];
    subnet_netmask_edit.Text := subnet_grid.Cells[2, subnet_grid.Row];
    subnet_broadcast_edit.Text := subnet_grid.Cells[3, subnet_grid.Row];
    subnet_defaultleasetime_edit.Text := subnet_grid.Cells[4, subnet_grid.Row];
    subnet_maxleasetime_edit.Text := subnet_grid.Cells[5, subnet_grid.Row];
    subnet_rangea_edit.Text := subnet_grid.Cells[6, subnet_grid.Row];
    subnet_rangeb_edit.Text := subnet_grid.Cells[7, subnet_grid.Row];
    subnet_range_bootpa_edit.Text := subnet_grid.Cells[8, subnet_grid.Row];
    subnet_range_bootpb_edit.Text := subnet_grid.Cells[9, subnet_grid.Row];
    subnet_domainname_edit.Text := subnet_grid.Cells[10, subnet_grid.Row];
  end;
end;

procedure Tdhcpconfigform.loadSubnets;
var
  i: integer;
begin
  subnetlist_combobox.Clear;
  for i := 0 to subnet_grid.RowCount - 1 do
  begin
    subnetlist_combobox.AddItem(subnet_grid.Cells[1, i], nil);
    //ShowMessage(subnet_grid.Cells[1, i]);
  end;
end;

procedure Tdhcpconfigform.subnet_gridColRowInserted(Sender: TObject; IsColumn: boolean; sIndex, tIndex: integer);
begin
  loadSubnets;
end;

procedure Tdhcpconfigform.subnet_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_DELETE then
    if subnet_grid.Row > 0 then
      subnet_grid.DeleteRow(subnet_grid.Row);
end;

procedure Tdhcpconfigform.subnet_routers_editKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = vk_return then
  begin
    if (subnet_routers_edit.Text <> '') and (DTValidIP(subnet_routers_edit.Text) or DTValidIP6(subnet_routers_edit.Text)) then
      if sgFindItemRowInColumn(subnet_routers_grid, 0, subnet_routers_edit.Text) < 0 then
      begin
        subnet_routers_grid.InsertRowWithValues(subnet_routers_grid.RowCount, subnet_routers_edit.Text);
        saveTemp;
      end;
  end;
end;

procedure Tdhcpconfigform.subnet_routers_gridClick(Sender: TObject);
begin
  if subnet_routers_grid.Row > 0 then
    subnet_routers_edit.Text := subnet_routers_grid.Cells[0, subnet_routers_grid.Row];
end;

procedure Tdhcpconfigform.subnet_routers_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_DELETE then
    if subnet_routers_grid.Row > 0 then
      subnet_routers_grid.DeleteRow(subnet_routers_grid.Row);
end;


procedure Tdhcpconfigform.subnet_addupdate_buttonClick(Sender: TObject);
var
  subnettoadd: array of string;
begin
  SetLength(subnettoadd, 11);

  subnettoadd[0] := subnet_comment_edit.Text;
  subnettoadd[1] := subnet_subnet_edit.Text;
  subnettoadd[2] := subnet_netmask_edit.Text;
  subnettoadd[3] := subnet_broadcast_edit.Text;
  subnettoadd[4] := subnet_defaultleasetime_edit.Text;
  subnettoadd[5] := subnet_maxleasetime_edit.Text;
  subnettoadd[6] := subnet_rangea_edit.Text;
  subnettoadd[7] := subnet_rangeb_edit.Text;
  subnettoadd[8] := subnet_range_bootpa_edit.Text;
  subnettoadd[9] := subnet_range_bootpb_edit.Text;
  subnettoadd[10] := subnet_domainname_edit.Text;

  if (subnettoadd[1] <> '') and (subnettoadd[2] <> '') then
  begin
    subnet_grid.InsertRowWithValues(subnet_grid.RowCount, subnettoadd);
    loadSubnets;
    saveTemp;
  end;
end;

procedure Tdhcpconfigform.FormCreate(Sender: TObject);
begin
  if FileExists('tempdns.csv') then
    subnet_domainnameservers_grid.LoadFromCSVFile('tempdns.csv', ',', False, 0, True);
  if FileExists('temprouters.csv') then
    subnet_routers_grid.LoadFromCSVFile('temprouters.csv', ',', False, 0, True);
  if FileExists('tempsubnets.csv') then
  begin
    subnet_grid.LoadFromCSVFile('tempsubnets.csv', ',', False, 0, True);
    loadSubnets;
  end;
end;

procedure Tdhcpconfigform.host_gridKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if key = VK_DELETE then
    if host_grid.Row > 0 then
      host_grid.DeleteRow(host_grid.Row);
end;

procedure Tdhcpconfigform.saveTemp;
begin
  subnet_domainnameservers_grid.SaveToCSVFile('tempdns.csv', ',', False, False);
  subnet_routers_grid.SaveToCSVFile('temprouters.csv', ',', False, False);
  subnet_grid.SaveToCSVFile('tempsubnets.csv', ',', False, False);
end;

end.
