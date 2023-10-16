unit uProduct;

interface

type
  TProduct = class(TObject)
  private
    FCode: Integer;
    FCategoryCode: Integer;
    FName: string;
    FDescription: string;
    FPrice: Integer;
    FQuantity: Integer;

  public
    constructor Create(ACode: Integer; ACategoryCode: Integer; AName: string; ADescription: string; APrice: Integer; AQuantity: Integer);
    property Code: Integer read FCode;
    property CategoryCode: Integer read FCategoryCode;
    property Name: string read FName;
    property Description: string read FDescription;
    property Price: Integer read FPrice;
    property Quantity: Integer read FQuantity;
  end;

implementation

constructor TProduct.Create(ACode: Integer; ACategoryCode: Integer; AName: string; ADescription: string; APrice: Integer; AQuantity: Integer);
begin
  inherited Create;
  FCode := ACode;
  FCategoryCode := ACategoryCode;
  FName := AName;
  FDescription := ADescription;
  FPrice := APrice;
  FQuantity := AQuantity;
end;

end.
