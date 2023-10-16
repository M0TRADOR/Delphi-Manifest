program StorageManifest;

uses
  Vcl.Forms,
  main in 'main.pas' {Form2},
  uCategory in 'uCategory.pas',
  uEditProductForm in 'uEditProductForm.pas' {EditProductForm},
  uProduct in 'uProduct.pas',
  uEditCategoryForm in 'uEditCategoryForm.pas' {EditCategoryForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TEditProductForm, EditProductForm);
  Application.CreateForm(TEditProductForm, EditProductForm);
  Application.CreateForm(TEditCategoryForm, EditCategoryForm);
  Application.Run;
end.
