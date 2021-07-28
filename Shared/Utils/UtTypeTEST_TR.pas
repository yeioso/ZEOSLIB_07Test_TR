unit UtTypeTEST_TR;

interface
Uses
  Variants,
  IWApplication,
  IWCompGradButton;

Const
  Const_MAX_Records = 100;

Type
  TOperacion = (TO_None, TO_Insertar, TO_Editar, TO_Eliminar, TO_Continuar);
  TArrayStrInfo = Array Of Variant ;
  TArrayIntInfo = Array Of Integer;

  TBoton = Class(TIWGradButton)
    Private
      FArrayF : String;
      FArrayV : TArrayStrInfo;
    Public
      Property ArrayF : String        Read FArrayF Write FArrayF;
      Property ArrayV : TArrayStrInfo Read FArrayV Write FArrayV;
  End;

Procedure UtTypeUPL_IWGradButton(pBoton : TBoton; pActive : Boolean);

implementation

Procedure UtTypeUPL_IWGradButton(pBoton : TBoton; pActive : Boolean);
Begin
  pBoton.Height := 20;
  pBoton.Width  := 80;
  If pActive Then
    pBoton.Style.ColorScheme := TGradButtonColorScheme.csRed
  Else
    pBoton.Style.ColorScheme := TGradButtonColorScheme.csBlue;
  pBoton.Style.Button.Font.Size := 8;
End;

end.
