object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Products in storage'
  ClientHeight = 533
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 13
    Top = 19
    Width = 92
    Height = 15
    Caption = 'Tree of categories'
  end
  object Label2: TLabel
    Left = 287
    Top = 19
    Width = 128
    Height = 15
    Caption = 'List of selected products'
  end
  object Label3: TLabel
    Left = 521
    Top = 19
    Width = 205
    Height = 15
    Caption = 'Click column headers to toggle sorting'
  end
  object CategoryTreeView: TTreeView
    Left = 8
    Top = 40
    Width = 241
    Height = 248
    HideSelection = False
    Indent = 19
    TabOrder = 0
    OnChange = CategoryTreeViewChange
  end
  object AddCategoryButton: TButton
    Left = 8
    Top = 312
    Width = 107
    Height = 25
    Hint = 'Click to open a window for editing a new category'
    Caption = 'Add Category'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = AddCategoryButtonClick
  end
  object AddProduct: TButton
    Left = 8
    Top = 359
    Width = 107
    Height = 25
    Hint = 'Click to open a window for editing a new product'
    Caption = 'Add product'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = AddProductButtonClick
  end
  object DBGrid2: TDBGrid
    Left = 485
    Top = 208
    Width = 25
    Height = 1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object ProductList: TListView
    Left = 287
    Top = 40
    Width = 439
    Height = 248
    Hint = 'Click column headers to toggle sorting'
    Columns = <
      item
        AutoSize = True
        Caption = 'Code'
      end
      item
        AutoSize = True
        Caption = 'Category'
        Tag = 1
      end
      item
        AutoSize = True
        Caption = 'Name'
        Tag = 2
      end
      item
        AutoSize = True
        Caption = 'Description'
        Tag = 3
      end
      item
        AutoSize = True
        Caption = 'Cost'
        Tag = 4
      end
      item
        AutoSize = True
        Caption = 'Amount'
        Tag = 5
      end>
    FlatScrollBars = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    ViewStyle = vsReport
    OnColumnClick = ProductListColumnClick
    OnSelectItem = ProductListSelectItem
  end
  object Edit1: TEdit
    Left = 400
    Top = 481
    Width = 121
    Height = 23
    TabOrder = 5
    Text = 'Edit1'
  end
  object AllButton: TButton
    Left = 287
    Top = 312
    Width = 75
    Height = 25
    Hint = 'Click to show all products'
    Caption = 'Show All'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = AllButtonClick
  end
  object Test1: TButton
    Left = 560
    Top = 480
    Width = 75
    Height = 25
    Caption = 'Test1'
    TabOrder = 7
    OnClick = Test1Click
  end
  object QuantityFilterEdit: TEdit
    Left = 565
    Top = 313
    Width = 81
    Height = 23
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    TextHint = 'Quantity'
  end
  object QuantityFilterButton: TButton
    Left = 471
    Top = 312
    Width = 81
    Height = 25
    Hint = 'Click to show products with quantity equal or lower than entered'
    Caption = 'Less than...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = QuantityFilterButtonClick
  end
  object FindProductButton: TButton
    Left = 287
    Top = 359
    Width = 107
    Height = 25
    Hint = 'Click to open a window to search for entered product'
    Caption = 'Find Product'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = FindProductButtonClick
  end
  object EditButton: TButton
    Left = 147
    Top = 312
    Width = 107
    Height = 25
    Hint = 'Click to open a window to edit selected item'
    Caption = 'Edit entry'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = EditButtonClick
  end
  object DeleteButton: TButton
    Left = 147
    Top = 360
    Width = 107
    Height = 25
    Hint = 'Click to delete selected item'
    Caption = 'Delete'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 12
    OnClick = DeleteButtonClick
  end
end
