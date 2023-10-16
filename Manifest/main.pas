unit main;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCategory, uProduct, uEditCategoryForm, uEditProductForm, Vcl.ComCtrls,
    Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
    TForm2 = class(TForm)
        CategoryTreeView: TTreeView;
        AddCategoryButton: TButton;
        AddProduct: TButton;
        DBGrid2: TDBGrid;
        ProductList: TListView;
        Edit1: TEdit;
        AllButton: TButton;
        Test1: TButton;
        QuantityFilterEdit: TEdit;
        QuantityFilterButton: TButton;
        FindProductButton: TButton;
        EditButton: TButton;
        DeleteButton: TButton;
        Label1: TLabel;
        Label2: TLabel;
        Label3: TLabel;
        procedure AddCategoryButtonClick(Sender: TObject);
        procedure AddProductButtonClick(Sender: TObject);
        procedure CategoryTreeViewChange(Sender: TObject; Node: TTreeNode);
        procedure ProductListColumnClick(Sender: TObject; Column: TListColumn);
        procedure FormCreate(Sender: TObject);
        procedure AllButtonClick(Sender: TObject);
        procedure Test1Click(Sender: TObject);
        procedure QuantityFilterButtonClick(Sender: TObject);
        procedure FindProductButtonClick(Sender: TObject);
        procedure ProductListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
        procedure DeleteButtonClick(Sender: TObject);
        procedure EditButtonClick(Sender: TObject);

type
    TSortTrait = (Code, Category, Title, Description, Cost, Amount);
    TSortType = (Increase, Decrease);
    TProductArray = array of TProduct;

    private
        FCategories: array of TCategory;
        FProducts: TProductArray;
        FFilteredProducts: TProductArray;

        SelectedCategory: TCategory;
        SelectedProduct: Tproduct;
        IsCategorySelected: Boolean;
        CurrentSortTrait: TSortTrait;
        CurrentSortType: TSortType;


        procedure BuildCategoryTree(ParentNode: TTreeNode; ParentCategoryCode: Integer);
        procedure AddProductToListView(Product: TProduct);
        procedure AddCategoryToTree(Category: TCategory);
        procedure SortAndShow(CurrentProducts: TProductArray);
        function MergeSort(CurrentProductArr: TProductArray): TProductArray;
        function Merge(LeftProductArr: TProductArray; RightProductArr: TProductArray): TProductArray;
    public
        destructor Destroy; override;
end;

var
    Form2: TForm2;
implementation
{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
    SelectedCategory := nil;
end;

procedure TForm2.AddCategoryButtonClick(Sender: TObject);
var
    ModalForm: TEditCategoryForm;
    NewCategory: TCategory;
    NewParent: Integer;
    I: Integer;

begin
    ModalForm := TEditCategoryForm.Create(Self);
    try
        ModalForm.IsRefuseEmpty := true;
        ModalForm.StatusLabel.Caption := 'Creating new category';
        ModalForm.ParentListBox.Items.Add('0');
        for I := 0 to High(FCategories) do
            ModalForm.ParentListBox.Items.Add(IntToStr(FCategories[I].CategoryCode));

        if SelectedCategory <> nil then
            ModalForm.ParentSelected := SelectedCategory.CategoryCode
        else
            ModalForm.ParentSelected := 0;
        ModalForm.DefaultLabel.Caption := 'will be ' + IntToStr(ModalForm.ParentSelected);

        if ModalForm.ShowModal = mrOk then
        begin
            NewCategory := TCategory.Create(
                StrToInt(ModalForm.EditCategoryCode.Text),
                ModalForm.EditCategoryName.Text,
                ModalForm.ParentSelected
            );
            NewParent := StrToInt(ModalForm.EditCategoryCode.Text);
            SetLength(FCategories, Length(FCategories) + 1);
            FCategories[High(FCategories)] := NewCategory;
            AddCategoryToTree(NewCategory);
        end;
    finally
        ModalForm.Free;
    end;
end;

procedure TForm2.AddProductButtonClick(Sender: TObject);
var
    ModalForm: TEditProductForm;
    NewProduct: TProduct;
    I: Integer;

begin
    ModalForm := TEditProductForm.Create(Self);
    ModalForm.IsRefuseEmpty := true;
    ModalForm.StatusLabel.Caption := 'Creating new product';
    for I := 0 to High(FCategories) do
        ModalForm.ParentListBox.Items.Add(IntToStr(FCategories[I].CategoryCode));

    if SelectedCategory <> nil then
        ModalForm.ParentSelected := SelectedCategory.CategoryCode
    else
        ModalForm.ParentSelected := 0;
    ModalForm.DefaultLabel.Caption := 'will be ' + IntToStr(ModalForm.ParentSelected);

    try
        if ModalForm.ShowModal = mrOk then
        begin
            NewProduct := TProduct.Create(
                StrToInt(ModalForm.EditProductCode.Text),
                ModalForm.ParentSelected,
                ModalForm.EditProductName.Text,
                ModalForm.EditProductDescription.Text,
                StrToInt(ModalForm.EditProductCost.Text),
                StrToInt(ModalForm.EditProductAmount.Text)
            );

            SetLength(FProducts, Length(FProducts) + 1);
            FProducts[High(FProducts)] := NewProduct;

            if SelectedCategory <> nil then
                if SelectedCategory.CategoryCode = NewProduct.CategoryCode then
                    AddProductToListView(NewProduct);
        end;
    finally
        ModalForm.Free;
    end;
end;

procedure TForm2.FindProductButtonClick(Sender: TObject);
var
    ModalForm: TEditProductForm;
    I: Integer;
    SeekCode: Boolean;
    SeekCategory: Boolean;
    SeekName: Boolean;
    SeekDescription: Boolean;
    SeekPrice: Boolean;
    SeekQuantity: Boolean;
begin
    ModalForm := TEditProductForm.Create(Self);
    SeekCode := false;
    SeekCategory := false;
    SeekName := false;
    SeekDescription := false;
    SeekPrice := false;
    SeekQuantity := false;
    ModalForm.StatusLabel.Caption := 'Searching for product';

    for I := 0 to High(FCategories) do
        ModalForm.ParentListBox.Items.Add(IntToStr(FCategories[I].CategoryCode));

    ModalForm.ParentSelected := 0;
    ModalForm.DefaultLabel.Caption := 'will not be relevant';

    try
        if ModalForm.ShowModal = mrOk then
        begin
            SetLength(FFilteredProducts, 0);
            for I := 0 to High(FProducts) do
            begin
                SeekCode := (ModalForm.EditProductCode.Text = '') or (StrToInt(ModalForm.EditProductCode.Text) = FProducts[i].Code);
                SeekCategory := (ModalForm.ParentSelected = 0) or (ModalForm.ParentSelected = FProducts[i].CategoryCode);
                SeekName := (ModalForm.EditProductName.Text = '') or (ModalForm.EditProductName.Text = FProducts[i].Name);
                SeekDescription := (ModalForm.EditProductDescription.Text = '') or (ModalForm.EditProductDescription.Text = FProducts[i].Description);
                SeekPrice := (ModalForm.EditProductCost.Text = '')or (StrToInt(ModalForm.EditProductCost.Text) = FProducts[i].Price);
                SeekQuantity := (ModalForm.EditProductAmount.Text = '') or (StrToInt(ModalForm.EditProductAmount.Text) = FProducts[i].Quantity);

                if SeekCode and SeekCategory and SeekName and SeekDescription and SeekPrice and SeekQuantity then
                begin
                    SetLength(FFilteredProducts, Length(FFilteredProducts) + 1);
                    FFilteredProducts[High(FFilteredProducts)] := FProducts[I];
                end;
            end;
            SortAndShow(FFilteredProducts);
        end;
    finally
        ModalForm.Free;
    end;
end;

procedure TForm2.Test1Click(Sender: TObject);          ////////////////////Delete on release
var
  ModalForm: TEditProductForm;
  NewProduct: TProduct;
  NewCategory: TCategory;
  I: Integer;

begin
  //SetLength(ParentArr, 3);
  //ParentArr[0] := 0;
  //ParentArr[1] := 25;
  //ParentArr[2] := 26;
      NewCategory := TCategory.Create(25, 'gergfd', 0);
      SetLength(FCategories, 2);
      FCategories[0] := NewCategory;
      //ParentArr[High(ParentArr)] := 25;
      AddCategoryToTree(NewCategory);

      NewCategory := TCategory.Create(26, 'fgsgfd', 25);
      FCategories[High(FCategories)] := NewCategory;
      //ParentArr[High(ParentArr)] := 25;
      AddCategoryToTree(NewCategory);

  NewProduct := TProduct.Create(12, 25, 'qwer', 'gsdrg', 2, 2);
  SetLength(FProducts, Length(FProducts) + 1);
  FProducts[High(FProducts)] := NewProduct;

  NewProduct := TProduct.Create(13, 25, 'adgra', 'tyjty', 2, 3);
  SetLength(FProducts, Length(FProducts) + 1);
  FProducts[High(FProducts)] := NewProduct;

  NewProduct := TProduct.Create(14, 25, 'sdf', 'fgbf', 2, 5);
  SetLength(FProducts, Length(FProducts) + 1);
  FProducts[High(FProducts)] := NewProduct;

  NewProduct := TProduct.Create(15, 26, 'ethge', 'gsdrg', 2, 4);
  SetLength(FProducts, Length(FProducts) + 1);
  FProducts[High(FProducts)] := NewProduct;

  NewProduct := TProduct.Create(16, 26, 'sfser', 'tyjty', 2, 7);
  SetLength(FProducts, Length(FProducts) + 1);
  FProducts[High(FProducts)] := NewProduct;

  NewProduct := TProduct.Create(17, 26, 'drtr', 'fgbf', 2, 1);
  SetLength(FProducts, Length(FProducts) + 1);
  FProducts[High(FProducts)] := NewProduct;


end;

procedure TForm2.CategoryTreeViewChange(Sender: TObject; Node: TTreeNode);
var
    I: Integer;
    ListItem: TListItem;
begin
    if Assigned(CategoryTreeView.Selected) and Assigned(CategoryTreeView.Selected.Data) then
    begin
        SelectedCategory := TCategory(CategoryTreeView.Selected.Data);

        for I := 0 to High(FFilteredProducts) do
            FFilteredProducts[I] := nil ;
        SetLength(FFilteredProducts, 0);

        for I := 0 to High(FProducts) do
        begin
            if FProducts[I].CategoryCode = SelectedCategory.CategoryCode then
            begin
                SetLength(FFilteredProducts, Length(FFilteredProducts) + 1);
                FFilteredProducts[High(FFilteredProducts)] := FProducts[I];
            end;
        end;
        Edit1.Text := IntToStr(Length(FFilteredProducts));
        IsCategorySelected := true;
        SortAndShow(FFilteredProducts);
    end;
end;

procedure TForm2.BuildCategoryTree(ParentNode: TTreeNode; ParentCategoryCode: Integer);
var
    I: Integer;
    NewNode: TTreeNode;
begin
    for I := 0 to High(FCategories) do
    begin
        if FCategories[I].ParentCategory = ParentCategoryCode then
        begin
            NewNode := CategoryTreeView.Items.AddChild(ParentNode, Format('%s (%d)', [FCategories[I].Name, FCategories[I].CategoryCode]));
            NewNode.Data := FCategories[I];
            BuildCategoryTree(NewNode, FCategories[I].CategoryCode);
        end;
    end;
end;

procedure TForm2.AddCategoryToTree(Category: TCategory);
var
    ParentNode: TTreeNode;
    NewNode: TTreeNode;
    I: Integer;
begin
    ParentNode := nil;

    if Category.ParentCategory <> 0 then  // 0 - no parent
    begin
        for I := 0 to CategoryTreeView.Items.Count - 1 do
        begin
            if TCategory(CategoryTreeView.Items[I].Data).CategoryCode = Category.ParentCategory then
            begin
                ParentNode := CategoryTreeView.Items[I];
                Break;
            end;
        end;
    end;

    NewNode := CategoryTreeView.Items.AddChild(ParentNode, Format('%s (%d)', [Category.Name, Category.CategoryCode]));
    NewNode.Data := Category;
end;

procedure TForm2.ProductListColumnClick(Sender: TObject; Column: TListColumn);
var
    NewSortTrait: TSortTrait;

begin
    Case Column.Tag of
        0: NewSortTrait := Code;
        1: NewSortTrait := Category;
        2: NewSortTrait := Title;
        3: NewSortTrait := Description;
        4: NewSortTrait := Cost;
        5: NewSortTrait := Amount;
    End;

    if NewSortTrait <> CurrentSortTrait then
    begin
        CurrentSortTrait := NewSortTrait;
        CurrentSortType := Increase;
    end
    else
        if CurrentSortType = Increase then
            CurrentSortType := Decrease
        else
            CurrentSortType := Increase;

    if CurrentSortType = Increase then
        Edit1.Text := '1'
    else
        Edit1.Text := '-1';
    SortAndShow(FFilteredProducts);
end;

procedure TForm2.ProductListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
    I: Integer;
begin
    for I := 0 to High(FProducts) do
        if Item.Caption = IntToStr(FProducts[I].Code) then
        begin
            SelectedProduct := FProducts[I];
            isCategorySelected := false;
        end;
end;

procedure TForm2.EditButtonClick(Sender: TObject);
var
    I: Integer;
    J: Integer;
    ModalProductForm: TEditProductForm;
    ModalCategoryForm: TEditCategoryForm;
    EditedProduct: TProduct;
    EditedCategory: TCategory;
begin
    if IsCategorySelected then
    begin
        for I := 0 to High(FCategories) do
            if FCategories[I] = SelectedCategory then
            begin
                ModalCategoryForm := TEditCategoryForm.Create(Self);
                try
                    ModalCategoryForm := TEditCategoryForm.Create(Self);
                    ModalCategoryForm.EditCategoryCode.Text := IntToStr(FCategories[I].CategoryCode);
                    ModalCategoryForm.ParentListBox.Items.Add('0');
                    ModalCategoryForm.StatusLabel.Caption := 'Editing category';

                    for J := 0 to High(FCategories) do
                        ModalCategoryForm.ParentListBox.Items.Add(IntToStr(FCategories[J].CategoryCode));

                    if SelectedCategory <> nil then
                        ModalCategoryForm.ParentSelected := SelectedCategory.CategoryCode
                    else
                        ModalCategoryForm.ParentSelected := 0;

                    ModalCategoryForm.ParentSelected := FCategories[I].ParentCategory;
                    ModalCategoryForm.EditCategoryName.Text := FCategories[I].Name;
                    ModalCategoryForm.DefaultLabel.Caption := 'will be ' + IntToStr(ModalCategoryForm.ParentSelected);

                    if ModalCategoryForm.ShowModal = mrOk then
                    begin
                        EditedCategory := TCategory.Create(
                            StrToInt(ModalCategoryForm.EditCategoryCode.Text),
                            ModalCategoryForm.EditCategoryName.Text,
                            ModalCategoryForm.ParentSelected
                        );
                        FCategories[I] := EditedCategory;
                        CategoryTreeView.Items.Clear;
                        BuildCategoryTree(nil, 0);
                    end;
                finally
                    ModalCategoryForm.Free;
                end;
                break;
            end;
        CategoryTreeView.Items.Clear;
        BuildCategoryTree(nil, 0);
    end
    else
    begin
        for I := 0 to High(FProducts) do
            if FProducts[I] = SelectedProduct then
            begin
                ModalProductForm := TEditProductForm.Create(Self);
                ModalProductForm.EditProductCode.Text := IntToStr(FProducts[I].Code);
                ModalProductForm.StatusLabel.Caption := 'Editing product';

                for J := 0 to High(FCategories) do
                    ModalProductForm.ParentListBox.Items.Add(IntToStr(FCategories[J].CategoryCode));

                if SelectedCategory <> nil then
                    ModalProductForm.ParentSelected := SelectedCategory.CategoryCode
                else
                    ModalProductForm.ParentSelected := 0;

                ModalProductForm.ParentSelected := FProducts[I].CategoryCode;
                ModalProductForm.EditProductName.Text := FProducts[I].Name;
                ModalProductForm.EditProductDescription.Text := FProducts[I].Description;
                ModalProductForm.EditProductCost.Text := IntToStr(FProducts[I].Price);
                ModalProductForm.EditProductAmount.Text := IntToStr(FProducts[I].Quantity);
                ModalProductForm.DefaultLabel.Caption := 'will be ' + IntToStr(ModalProductForm.ParentSelected);
                try
                    if ModalProductForm.ShowModal = mrOk then
                    begin
                        EditedProduct := TProduct.Create(
                            StrToInt(ModalProductForm.EditProductCode.Text),
                            ModalProductForm.ParentSelected,
                            ModalProductForm.EditProductName.Text,
                            ModalProductForm.EditProductDescription.Text,
                            StrToInt(ModalProductForm.EditProductCost.Text),
                            StrToInt(ModalProductForm.EditProductAmount.Text)
                        );
                        for J := 0 to High(FFilteredProducts) do
                            if SelectedProduct = FFilteredProducts[J] then
                            begin
                                FFilteredProducts[J] := FFilteredProducts[High(FFilteredProducts)];
                                SetLength(FFilteredProducts, Length(FFilteredProducts) - 1);
                                break;
                            end;
                        FProducts[I] := EditedProduct;

                        if (SelectedCategory <> nil) or (Length(FFilteredProducts) = Length(FProducts)) then
                            if (SelectedCategory.CategoryCode = EditedProduct.CategoryCode) or (Length(FFilteredProducts) + 1 = Length(FProducts)) then
                            begin
                                SetLength(FFilteredProducts, Length(FFilteredProducts) + 1);
                                FFilteredProducts[High(FFilteredProducts)] := EditedProduct;
                            end;
                    end;
                finally
                    ModalProductForm.Free;
                end;
                break;
            end;
        SortAndShow(FFilteredProducts);
    end;
end;

procedure TForm2.DeleteButtonClick(Sender: TObject);
var
    I: Integer;
begin
    if IsCategorySelected then    //defining whether category or product was selected
    begin
        for I := 0 to High(FCategories) do
            if FCategories[I] = SelectedCategory then
            begin
                FCategories[I] := FCategories[High(FCategories)];
                SetLength(FCategories, Length(FCategories) - 1);
                break;
            end;
            CategoryTreeView.Items.Clear;
            BuildCategoryTree(nil, 0);
    end
    else
    begin
        for I := 0 to High(FProducts) do
            if FProducts[I] = SelectedProduct then
            begin
                FProducts[I] := FProducts[High(FProducts)];
                SetLength(FProducts, Length(FProducts) - 1);
                break;
            end;
        for I := 0 to High(FFilteredProducts) do
            if FFilteredProducts[I] = SelectedProduct then
            begin
                FFilteredProducts[I] := FFilteredProducts[High(FFilteredProducts)];
                SetLength(FFilteredProducts, Length(FFilteredProducts) - 1);
                break;
            end;
        SortAndShow(FFilteredProducts);
    end;
end;

procedure TForm2.QuantityFilterButtonClick(Sender: TObject);
var
    I: Integer;
begin
    if QuantityFilterEdit.Text <> '' then
    begin
        SetLength(FFilteredProducts, 0);
        for I := 0 to High(FProducts) do
        begin
            if FProducts[I].Quantity <= StrToInt(QuantityFilterEdit.Text) then
            begin
                SetLength(FFilteredProducts, Length(FFilteredProducts) + 1);
                FFilteredProducts[High(FFilteredProducts)] := FProducts[I];
            end;
        end;
        SortAndShow(FFilteredProducts);
    end;
end;

procedure TForm2.AddProductToListView(Product: TProduct);
var
    ListItem: TListItem;
begin
    ListItem := ProductList.Items.Add;
    ListItem.Caption := IntToStr(Product.Code);  // Product code
    ListItem.SubItems.Add(IntToStr(Product.CategoryCode));  // Product category
    ListItem.SubItems.Add(Product.Name);  // Product name
    ListItem.SubItems.Add(Product.Description); // description
    ListItem.SubItems.Add(IntToStr(Product.Price));  // price
    ListItem.SubItems.Add(IntToStr(Product.Quantity));  //quantity
end;

procedure TForm2.AllButtonClick(Sender: TObject);
var
    I: Integer;
begin
    SetLength(FFilteredProducts, Length(FProducts));
    for I := 0 to High(FProducts) do
    begin
        FFilteredProducts[I] := FProducts[I];
    end;
    SortAndShow(FProducts);
end;

procedure TForm2.SortAndShow(CurrentProducts: TProductArray);
var
    I: Integer;
    ListItem: TListItem;
begin
    ProductList.Items.Clear;
    if Length(CurrentProducts) > 0 then
    begin
        CurrentProducts := MergeSort(CurrentProducts);
        for I := 0 to High(CurrentProducts) do
            if CurrentSortType = Increase then
                AddProductToListView(CurrentProducts[I])
            else
                AddProductToListView(CurrentProducts[High(CurrentProducts) - I]);
    end
    else
    begin
        ListItem := ProductList.Items.Add;
        ListItem.Caption := 'Not';
        ListItem.SubItems.Add('Found');
    end;
end;

function TForm2.MergeSort(CurrentProductArr: TProductArray): TForm2.TProductArray;
var
    LeftProductArr: TForm2.TProductArray;
    RightProductArr: TForm2.TProductArray;
    I: Integer;
    N: Integer;
begin
    if Length(CurrentProductArr) = 1 then
        Result := CurrentProductArr
    else
    begin
        N:= Length(CurrentProductArr) div 2;
        SetLength(RightProductArr, N);
        N := N +  (Length(CurrentProductArr) mod 2);
        SetLength(LeftProductArr, N);

        for I := 0 to N - 1 do                                        //acquiring left and right part of array
        begin
            LeftProductArr[I] := CurrentProductArr[I];
            if I + N < Length(CurrentProductArr) then
                RightProductArr[I] := CurrentProductArr[I + N];
        end;

        LeftProductArr := MergeSort(LeftProductArr);        //sorting left
        RightProductArr := MergeSort(RightProductArr);      //sorting right

        Result := Merge(LeftProductArr, RightProductArr);    //merging left and right
    end;
end;

function TForm2.Merge(LeftProductArr: TProductArray; RightProductArr: TProductArray): TForm2.TProductArray;
var
    ResultArr: TForm2.TProductArray;
    I: Integer;
    LeftI: Integer;
    RightI: Integer;
    Change: Boolean;
begin
    SetLength(ResultArr, Length(LeftProductArr) + Length(RightProductArr));
    LeftI := 0;
    RightI := 0;

    while (Length(LeftProductArr) > LeftI) and (Length(RightProductArr) > RightI) do
    begin
        case CurrentSortTrait of                                                                      // choosing trait to compare
            Code: Change := (LeftProductArr[LeftI].Code > RightProductArr[RightI].Code);
            Category: Change := LeftProductArr[LeftI].CategoryCode > RightProductArr[RightI].CategoryCode;
            Title: Change := LeftProductArr[LeftI].Name > RightProductArr[RightI].Name;
            Description: Change := LeftProductArr[LeftI].Description > RightProductArr[RightI].Description;
            Cost: Change := LeftProductArr[LeftI].Price > RightProductArr[RightI].Price;
            Amount: Change := LeftProductArr[LeftI].Quantity > RightProductArr[RightI].Quantity;
            else Change := LeftProductArr[LeftI].Code > RightProductArr[RightI].Code;
        end;

        if Change then                                                                              //comparing with chosen trait
        begin
            ResultArr[LeftI + RightI] := RightProductArr[RightI];
            RightI := RightI + 1;
        end
        else
        begin
            ResultArr[LeftI + RightI] := LeftProductArr[LeftI];
            LeftI := LeftI + 1;
        end;
    end;

    while Length(LeftProductArr) > LeftI do
    begin
        ResultArr[LeftI + RightI] := LeftProductArr[LeftI];
        LeftI := LeftI + 1;
    end;

    while Length(RightProductArr) > RightI do
    begin
        ResultArr[LeftI + RightI] := RightProductArr[RightI];
        RightI := RightI + 1;
    end;
    Result := ResultArr;
end;

destructor TForm2.Destroy;                //Deliting everithing after exiting
    var
        I: Integer;
    begin
        for I := 0 to High(FCategories) do
        begin
            FCategories[I].Free;
        end;
        SetLength(FCategories, 0);
        SetLength(FProducts, 0);
        SetLength(FFilteredProducts, 0);

        inherited Destroy;
    end;
end.
