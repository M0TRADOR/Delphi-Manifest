unit uEditProductForm;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
    TEditProductForm = class(TForm)
        EditProductCode: TEdit;
        EditProductName: TEdit;
        EditProductDescription: TEdit;
        EditProductCost: TEdit;
        EditProductAmount: TEdit;
        Button1: TButton;
        ParentListBox: TListBox;
        Label1: TLabel;
        Label2: TLabel;
        DefaultLabel: TLabel;
        StatusLabel: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Label7: TLabel;
        procedure Button1Click(Sender: TObject);
    public
        ParentSelected: Integer;
        IsRefuseEmpty: Boolean
    end;

var
    EditProductForm: TEditProductForm;
    CategoryId: Integer;

implementation

{$R *.dfm}

procedure TEditProductForm.Button1Click(Sender: TObject);
begin
     if ParentListBox.ItemIndex > -1 then
      ParentSelected := StrToInt(ParentListBox.Items[ParentListBox.ItemIndex]);

    if IsRefuseEmpty then
    begin
        if (EditProductName.Text = '') or (EditProductCode.Text = '') or (EditProductDescription.Text = '') or (EditProductCost.Text = '') or (EditProductAmount.Text = '') then
            StatusLabel.Caption := 'Fill all fields to continue'
        else
            ModalResult := mrOk;
    end
    else
        ModalResult := mrOk;
end;

end.
