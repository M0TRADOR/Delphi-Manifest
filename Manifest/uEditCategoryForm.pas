unit uEditCategoryForm;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst;

type
    TEditCategoryForm = class(TForm)
        EditCategoryName: TEdit;
        EditCategoryCode: TEdit;
        Button1: TButton;
        ParentListBox: TListBox;
        Label2: TLabel;
        Label3: TLabel;
        DefaultLabel: TLabel;
        StatusLabel: TLabel;
        Label1: TLabel;
        Label4: TLabel;
        procedure addCat(Sender: TObject);
    public
        ParentSelected: Integer;
        IsRefuseEmpty: Boolean
    end;

var
    EditCategoryForm: TEditCategoryForm;

implementation

  {$R *.dfm}

procedure TEditCategoryForm.addCat(Sender: TObject);
begin
    if ParentListBox.ItemIndex > -1 then
      ParentSelected := StrToInt(ParentListBox.Items[ParentListBox.ItemIndex]);

    if IsRefuseEmpty then
    begin
        if (EditCategoryName.Text = '') or (EditCategoryCode.Text = '') then
            StatusLabel.Caption := 'Fill all fields to continue'
        else
            ModalResult := mrOk;
    end
    else
        ModalResult := mrOk;
end;

end.
