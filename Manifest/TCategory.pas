type
  TCategory = class(TObject)
  private
    FCategoryCode: Integer;
    FName: string;
    FParentCategory: TCategory;
  public
    constructor Create(ACategoryCode: Integer; AName: string; AParentCategory: TCategory = nil);
    property CategoryCode: Integer read FCategoryCode;
    property Name: string read FName;
    property ParentCategory: TCategory read FParentCategory;
  end;

constructor TCategory.Create(ACategoryCode: Integer; AName: string; AParentCategory: TCategory = nil);
begin
  inherited Create;
  FCategoryCode := ACategoryCode;
  FName := AName;
  FParentCategory := AParentCategory;
end;
