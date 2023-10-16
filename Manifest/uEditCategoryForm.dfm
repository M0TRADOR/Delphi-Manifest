object EditCategoryForm: TEditCategoryForm
  Left = 0
  Top = 0
  Caption = 'Edit Category'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label2: TLabel
    Left = 336
    Top = 104
    Width = 117
    Height = 15
    Caption = 'Select parent category'
  end
  object Label3: TLabel
    Left = 336
    Top = 125
    Width = 151
    Height = 15
    Caption = 'If not selected default parent'
  end
  object DefaultLabel: TLabel
    Left = 336
    Top = 146
    Width = 37
    Height = 15
    Caption = 'will be '
  end
  object StatusLabel: TLabel
    Left = 56
    Top = 72
    Width = 60
    Height = 15
    Caption = 'StatusLabel'
  end
  object Label1: TLabel
    Left = 56
    Top = 107
    Width = 77
    Height = 15
    Caption = 'Category code'
  end
  object Label4: TLabel
    Left = 56
    Top = 146
    Width = 81
    Height = 15
    Caption = 'Category name'
  end
  object EditCategoryName: TEdit
    Left = 160
    Top = 143
    Width = 121
    Height = 23
    TabOrder = 0
    TextHint = 'Edit Category Name'
  end
  object EditCategoryCode: TEdit
    Left = 160
    Top = 104
    Width = 121
    Height = 23
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TextHint = 'Edit Category Code'
  end
  object Button1: TButton
    Left = 160
    Top = 256
    Width = 121
    Height = 25
    Caption = 'Confirm Category'
    TabOrder = 2
    OnClick = addCat
  end
  object ParentListBox: TListBox
    Left = 336
    Top = 184
    Width = 121
    Height = 97
    Hint = 'Choose Parent Category'
    ItemHeight = 15
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 3
  end
end
