object EditProductForm: TEditProductForm
  Left = 0
  Top = 0
  Caption = 'Edit Product Form'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 352
    Top = 117
    Width = 117
    Height = 15
    Caption = 'Select parent category'
  end
  object Label2: TLabel
    Left = 352
    Top = 138
    Width = 151
    Height = 15
    Caption = 'If not selected default parent'
  end
  object DefaultLabel: TLabel
    Left = 352
    Top = 159
    Width = 37
    Height = 15
    Caption = 'will be '
  end
  object StatusLabel: TLabel
    Left = 44
    Top = 80
    Width = 60
    Height = 15
    Caption = 'StatusLabel'
  end
  object Label3: TLabel
    Left = 44
    Top = 117
    Width = 71
    Height = 15
    Caption = 'Product code'
  end
  object Label4: TLabel
    Left = 44
    Top = 149
    Width = 75
    Height = 15
    Caption = 'Product name'
  end
  object Label5: TLabel
    Left = 44
    Top = 178
    Width = 104
    Height = 15
    Caption = 'Product description'
  end
  object Label6: TLabel
    Left = 44
    Top = 207
    Width = 67
    Height = 15
    Caption = 'Product cost'
  end
  object Label7: TLabel
    Left = 44
    Top = 236
    Width = 87
    Height = 15
    Caption = 'Product amount'
  end
  object EditProductCode: TEdit
    Left = 168
    Top = 117
    Width = 145
    Height = 23
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextHint = 'Edit Product Code'
  end
  object EditProductName: TEdit
    Left = 168
    Top = 146
    Width = 145
    Height = 23
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextHint = 'Edit Product Name'
  end
  object EditProductDescription: TEdit
    Left = 168
    Top = 175
    Width = 145
    Height = 23
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TextHint = 'Edit Product Description'
  end
  object EditProductCost: TEdit
    Left = 168
    Top = 204
    Width = 145
    Height = 23
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    TextHint = 'Edit Product Cost'
  end
  object EditProductAmount: TEdit
    Left = 168
    Top = 233
    Width = 145
    Height = 23
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    TextHint = 'Edit Product Amount'
  end
  object Button1: TButton
    Left = 168
    Top = 270
    Width = 145
    Height = 25
    Caption = 'Confirm Product'
    TabOrder = 5
    OnClick = Button1Click
  end
  object ParentListBox: TListBox
    Left = 352
    Top = 190
    Width = 121
    Height = 97
    Hint = 'Choose Parent Category'
    ItemHeight = 15
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 6
  end
end
