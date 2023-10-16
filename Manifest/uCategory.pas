unit uCategory;

interface

type
  TCategory = class(TObject)
  private
    FCategoryCode: Integer;
    FName: string;
    FParentCategory: Integer;
  public
    constructor Create(ACategoryCode: Integer; AName: string; AParentCategory: Integer);
    property CategoryCode: Integer read FCategoryCode;
    property Name: string read FName;
    property ParentCategory: Integer read FParentCategory;
  end;



implementation
  constructor TCategory.Create(ACategoryCode: Integer; AName: string; AParentCategory: Integer);
    begin
      inherited Create;
      FCategoryCode := ACategoryCode;
      FName := AName;
      FParentCategory := AParentCategory;
    end;
end.

