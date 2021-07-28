unit UtPowerPDF_TEST_TR;

interface
Uses
  UtType,
  PdfDoc,
  PReport,
  VCL.Forms,
  UtPowerPDF,
  PRJpegImage,
  System.Classes,
  Generics.Collections;

Type
  THEAD_TEST_TR = Class(TBASE)
    Private
      FCUADRO                 : TPRRect ;
      FTERCERO_LABEL          : TPRLabel;
      FTERCERO_DATO           : TPRLabel;
      FFECHA_MOVIMIENTO_LABEL : TPRLabel;
      FFECHA_MOVIMIENTO_DATO  : TPRLabel;
      FHORA_MOVIMIENTO_LABEL  : TPRLabel;
      FHORA_MOVIMIENTO_DATO   : TPRLabel;
      FDESCRIPCION_LABEL      : TPRLabel;
      FDESCRIPCION_DATO       : TPRLabel;
      FOBSERVACION_LABEL      : TPRLabel;
      FOBSERVACION_DATO       : TPRLabel;
      FFECHA_REGISTRO_LABEL   : TPRLabel;
      FFECHA_REGISTRO_DATO    : TPRLabel;
      FHORA_REGISTRO_LABEL    : TPRLabel;
      FHORA_REGISTRO_DATO     : TPRLabel;
      FESTADO_LABEL           : TPRLabel;
      FESTADO_DATO            : TPRLabel;
      FREGISTRADO_POR_LABEL   : TPRLabel;
      FREGISTRADO_POR_DATO    : TPRLabel;
      FGENERADO_POR_LABEL     : TPRLabel;
      FGENERADO_POR_DATO      : TPRLabel;
      Procedure SetComponents;
    Public
      Property TERCERO_DATO           : TPRLabel  Read FTERCERO_DATO          Write FTERCERO_DATO         ;
      Property FECHA_MOVIMIENTO_DATO  : TPRLabel  Read FFECHA_MOVIMIENTO_DATO Write FFECHA_MOVIMIENTO_DATO;
      Property HORA_MOVIMIENTO_DATO   : TPRLabel  Read FHORA_MOVIMIENTO_DATO  Write FHORA_MOVIMIENTO_DATO ;
      Property DESCRIPCION_DATO       : TPRLabel  Read FDESCRIPCION_DATO      Write FDESCRIPCION_DATO     ;
      Property OBSERVACION_DATO       : TPRLabel  Read FOBSERVACION_DATO      Write FOBSERVACION_DATO     ;
      Property FECHA_REGISTRO_DATO    : TPRLabel  Read FFECHA_REGISTRO_DATO   Write FFECHA_REGISTRO_DATO  ;
      Property HORA_REGISTRO_DATO     : TPRLabel  Read FHORA_REGISTRO_DATO    Write FHORA_REGISTRO_DATO   ;
      Property ESTADO_DATO            : TPRLabel  Read FESTADO_DATO           Write FESTADO_DATO          ;
      Property REGISTRADO_POR_DATO    : TPRLabel  Read FREGISTRADO_POR_DATO   Write FREGISTRADO_POR_DATO  ;
      Property GENERADO_POR_DATO      : TPRLabel  Read FGENERADO_POR_DATO     Write FGENERADO_POR_DATO    ;
      Constructor Create(AOwner: TComponent); Override;
      Destructor Destroy; Override;
  End;

  TDETAIL_TEST_TR = Class(TBASE)
    Private
    Public
      Constructor Create(AOwner: TComponent); Override;
      Destructor Destroy; Override;
      procedure SetLine(Const pContenido : String; Const pBold : Boolean); Overload;
      Procedure SetLine(Const pItem, pDescripcion, pFabricacion, pVencimiento, pCantidad : String; Const pBold : Boolean); Overload;
  End;



implementation
Uses
  VCL.Controls,
  System.SysUtils;


{ THEAD_TEST_TR }
constructor THEAD_TEST_TR.Create(AOwner: TComponent);
begin
  inherited;
  Self.Height := 115;
  FCUADRO                 := Create_Rect (Self);
  FTERCERO_LABEL          := Create_Label(Self);
  FTERCERO_DATO           := Create_Label(Self);
  FFECHA_MOVIMIENTO_LABEL := Create_Label(Self);
  FFECHA_MOVIMIENTO_DATO  := Create_Label(Self);
  FHORA_MOVIMIENTO_LABEL  := Create_Label(Self);
  FHORA_MOVIMIENTO_DATO   := Create_Label(Self);
  FDESCRIPCION_LABEL      := Create_Label(Self);
  FDESCRIPCION_DATO       := Create_Label(Self);
  FOBSERVACION_LABEL      := Create_Label(Self);
  FOBSERVACION_DATO       := Create_Label(Self);
  FFECHA_REGISTRO_LABEL   := Create_Label(Self);
  FFECHA_REGISTRO_DATO    := Create_Label(Self);
  FHORA_REGISTRO_LABEL    := Create_Label(Self);
  FHORA_REGISTRO_DATO     := Create_Label(Self);
  FESTADO_LABEL           := Create_Label(Self);
  FESTADO_DATO            := Create_Label(Self);
  FREGISTRADO_POR_LABEL   := Create_Label(Self);
  FREGISTRADO_POR_DATO    := Create_Label(Self);
  FGENERADO_POR_LABEL     := Create_Label(Self);
  FGENERADO_POR_DATO      := Create_Label(Self);
  SetComponents;
end;

procedure THEAD_TEST_TR.SetComponents;
begin
  SetRect(FCUADRO, 001, 003, 576, 110);

  SetLabel(FTERCERO_LABEL         , TAlignment.taLeftJustify, 003, 006, 050, 014, 'TERCERO'               , True );
  SetLabel(FTERCERO_DATO          , TAlignment.taLeftJustify, 003, 060, 400, 014, 'FTERCERO_DATO'         , False);

  SetLabel(FFECHA_MOVIMIENTO_LABEL, TAlignment.taLeftJustify, 021, 006, 050, 014, 'FECHA DE MOVIMIENTO'   , True );
  SetLabel(FFECHA_MOVIMIENTO_DATO , TAlignment.taLeftJustify, 021, 125, 100, 014, '2020-12-31'            , False);

  SetLabel(FHORA_MOVIMIENTO_LABEL , TAlignment.taLeftJustify, 021, 190, 050, 014, 'HORA DE MOVIMIENTO'    , True );
  SetLabel(FHORA_MOVIMIENTO_DATO  , TAlignment.taLeftJustify, 021, 295, 100, 014, '23:59;59'              , False);

  SetLabel(FDESCRIPCION_LABEL     , TAlignment.taLeftJustify, 041, 006, 050, 014, 'DESCRIPCION'           , True );
  SetLabel(FDESCRIPCION_DATO      , TAlignment.taLeftJustify, 041, 080, 515, 014, 'FDESCRIPCION_DATO'     , False);

  SetLabel(FOBSERVACION_LABEL     , TAlignment.taLeftJustify, 060, 006, 050, 014, 'OBSERVACION'           , True );
  SetLabel(FOBSERVACION_DATO      , TAlignment.taLeftJustify, 060, 080, 100, 014, 'FOBSERVACION_DATO'     , False);

  SetLabel(FFECHA_REGISTRO_LABEL  , TAlignment.taLeftJustify, 079, 006, 050, 014, 'FECHA DE REGISTRO'     , True );
  SetLabel(FFECHA_REGISTRO_DATO   , TAlignment.taLeftJustify, 079, 125, 100, 014, '2020-12-31'            , False);

  SetLabel(FHORA_REGISTRO_LABEL   , TAlignment.taLeftJustify, 079, 190, 050, 014, 'HORA DE REGISTRO'      , True );
  SetLabel(FHORA_REGISTRO_DATO    , TAlignment.taLeftJustify, 079, 295, 100, 014, '23:59;59'              , False);

  SetLabel(FESTADO_LABEL          , TAlignment.taLeftJustify, 079, 350, 050, 014, 'ESTADO'                , True );
  SetLabel(FESTADO_DATO           , TAlignment.taLeftJustify, 079, 400, 565, 014, 'FESTADO_DATO'          , False);

  SetLabel(FREGISTRADO_POR_LABEL  , TAlignment.taLeftJustify, 098, 006, 050, 014, 'REGISTRADO POR'        , True );
  SetLabel(FREGISTRADO_POR_DATO   , TAlignment.taLeftJustify, 098, 100, 200, 014, 'FREGISTRADO_POR_DATO'  , False);

  SetLabel(FGENERADO_POR_LABEL    , TAlignment.taLeftJustify, 098, 300, 050, 014, 'GENERADO POR '         , True );
  SetLabel(FGENERADO_POR_DATO     , TAlignment.taLeftJustify, 098, 380, 565, 014, 'FGENERADO_POR_DATO'    , False);
end;

destructor THEAD_TEST_TR.Destroy;
begin
  Release_Component(FCUADRO                );
  Release_Component(FTERCERO_LABEL         );
  Release_Component(FTERCERO_DATO          );
  Release_Component(FFECHA_MOVIMIENTO_LABEL);
  Release_Component(FFECHA_MOVIMIENTO_DATO );
  Release_Component(FHORA_MOVIMIENTO_LABEL );
  Release_Component(FHORA_MOVIMIENTO_DATO  );
  Release_Component(FDESCRIPCION_LABEL     );
  Release_Component(FDESCRIPCION_DATO      );
  Release_Component(FOBSERVACION_LABEL     );
  Release_Component(FOBSERVACION_DATO      );
  Release_Component(FFECHA_REGISTRO_LABEL  );
  Release_Component(FFECHA_REGISTRO_DATO   );
  Release_Component(FHORA_REGISTRO_LABEL   );
  Release_Component(FHORA_REGISTRO_DATO    );
  Release_Component(FESTADO_LABEL          );
  Release_Component(FESTADO_DATO           );
  Release_Component(FREGISTRADO_POR_LABEL  );
  Release_Component(FREGISTRADO_POR_DATO   );
  Release_Component(FGENERADO_POR_LABEL    );
  Release_Component(FGENERADO_POR_DATO     );
  inherited;
end;

{ TDETAIL_TEST_TR }
constructor TDETAIL_TEST_TR.Create(AOwner: TComponent);
begin
  inherited;
  CURRENT_TOP := 3;
end;

procedure TDETAIL_TEST_TR.SetLine(Const pContenido : String; Const pBold : Boolean);
Var
  FCONTENIDO : TPRLabel;
begin
  FCONTENIDO := Create_Label(Self);
  SetLabel(FCONTENIDO, TAlignment.taLeftJustify, CURRENT_TOP, 001, Self.Width - 12, 008, Copy(pContenido  , 01, 124), pBold);
  FCONTENIDO.FontName := TPRFontName.fnFixedWidth;
  FCONTENIDO.FontSize := 7;
  LAST_HEIGHT := FCONTENIDO.Height;
  CURRENT_TOP := CURRENT_TOP + FCONTENIDO.Height;
  Self.Height := CURRENT_TOP + 1;
end;

procedure TDETAIL_TEST_TR.SetLine(Const pItem, pDescripcion, pFabricacion, pVencimiento, pCantidad : String; Const pBold : Boolean);
Var
  FCUADRO      : TPRRect ;
  FITEM        : TPRLabel;
  FDESCRIPCION : TPRLabel;
  FFABRICACION : TPRLabel;
  FVENCIMIENTO : TPRLabel;
  FCANTIDAD    : TPRLabel;
begin
  FCUADRO      := Create_Rect (Self);
  FITEM        := Create_Label(Self);
  FDESCRIPCION := Create_Label(Self);
  FFABRICACION := Create_Label(Self);
  FVENCIMIENTO := Create_Label(Self);
  FCANTIDAD    := Create_Label(Self);

  SetLabel(FITEM       , TAlignment.taRightJustify, CURRENT_TOP, 006, 030, 014, Copy(pItem       , 01, 04), pBold);
  SetLabel(FDESCRIPCION, TAlignment.taLeftJustify , CURRENT_TOP, 045, 320, 014, Copy(pDescripcion, 01, 63), pBold);
  SetLabel(FFABRICACION, TAlignment.taLeftJustify , CURRENT_TOP, 368, 070, 014, Copy(pFabricacion, 01, 12), pBold);
  SetLabel(FVENCIMIENTO, TAlignment.taLeftJustify , CURRENT_TOP, 443, 070, 014, Copy(pVencimiento, 01, 12), pBold);
  SetLabel(FCANTIDAD   , TAlignment.taRightJustify, CURRENT_TOP, 505, 070, 014, Copy(pCantidad   , 01, 12), pBold);
  SetRect(FCUADRO, CURRENT_TOP - 2, 003, FCANTIDAD.Left + FCANTIDAD.Width + 1, FCANTIDAD.Height + 1);
  LAST_HEIGHT := FITEM.Height;
  CURRENT_TOP := CURRENT_TOP + FITEM.Height;
  Self.Height := CURRENT_TOP + 1;
end;

destructor TDETAIL_TEST_TR.Destroy;
begin

  inherited;
end;

end.
