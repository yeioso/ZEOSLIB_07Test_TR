object FrIWAyuda: TFrIWAyuda
  Left = 0
  Top = 0
  Width = 1341
  Height = 745
  RenderInvisibleControls = True
  AllowPageAccess = True
  ConnectionMode = cmAny
  OnCreate = IWAppFormCreate
  OnDestroy = IWAppFormDestroy
  Background.Fixed = False
  HandleTabs = False
  LeftToRight = True
  LockUntilLoaded = True
  LockOnSubmit = True
  ShowHint = True
  DesignLeft = 2
  DesignTop = 2
  object RINFO: TIWRegion
    Left = 0
    Top = 0
    Width = 1341
    Height = 26
    RenderInvisibleControls = True
    Align = alTop
    Color = clWebMEDIUMBLUE
    object lbInfo: TIWLabel
      Left = 1
      Top = 1
      Width = 1339
      Height = 24
      Align = alClient
      Alignment = taCenter
      Font.Color = clWebWHITE
      Font.Size = 12
      Font.Style = [fsBold]
      NoWrap = True
      HasTabOrder = False
      FriendlyName = 'lbInfo'
      Caption = 'lbInfo'
      ExplicitLeft = 2
      ExplicitTop = 4
    end
  end
  object IWRegion1: TIWRegion
    Left = 0
    Top = 58
    Width = 1341
    Height = 687
    RenderInvisibleControls = True
    Align = alClient
    object PAGINAS: TIWTabControl
      Left = 1
      Top = 1
      Width = 1339
      Height = 685
      RenderInvisibleControls = True
      ActiveTabFont.Color = clWebWHITE
      ActiveTabFont.FontFamily = 'Arial, Sans-Serif, Verdana'
      ActiveTabFont.Size = 10
      ActiveTabFont.Style = [fsBold]
      InactiveTabFont.Color = clWebBLACK
      InactiveTabFont.FontFamily = 'Arial, Sans-Serif, Verdana'
      InactiveTabFont.Size = 10
      InactiveTabFont.Style = []
      ActiveTabColor = clWebDARKGRAY
      InactiveTabColor = clWebLIGHTGRAY
      ActivePage = 0
      Align = alClient
      BorderOptions.NumericWidth = 0
      BorderOptions.Style = cbsNone
      Color = clWebSILVER
      ClipRegion = False
      TabPadding = 10
      TabRowHeight = 30
      TabHeight = 40
      TabBorderRadius = 10
      ActiveTabBorder.Color = clWebBLACK
      ActiveTabBorder.Width = 0
      InactiveTabBorder.Color = clWebBLACK
      InactiveTabBorder.Width = 0
      DesignSize = (
        1339
        685)
      object PAG_01: TIWTabPage
        Left = 0
        Top = 30
        Width = 1339
        Height = 655
        RenderInvisibleControls = True
        TabOrder = 1
        Title = '[          Datos B'#225'sicos          ]'
        BorderOptions.NumericWidth = 0
        BorderOptions.Style = cbsNone
        Color = clWebWHITE
        object lbCodigo: TIWLabel
          Left = 10
          Top = 11
          Width = 42
          Height = 16
          RenderSize = False
          StyleRenderOptions.RenderSize = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          HasTabOrder = False
          FriendlyName = 'lbCodigo'
          Caption = 'C'#243'digo'
        end
        object IWLabel8: TIWLabel
          Left = 10
          Top = 34
          Width = 49
          Height = 16
          RenderSize = False
          StyleRenderOptions.RenderSize = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          HasTabOrder = False
          FriendlyName = 'IWLabel8'
          Caption = 'Nombre'
        end
        object NOMBRE: TIWDBEdit
          Left = 84
          Top = 34
          Width = 361
          Height = 21
          StyleRenderOptions.RenderBorder = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'NOMBRE'
          SubmitOnAsyncEvent = True
          TabOrder = 3
          OnAsyncExit = NOMBREAsyncExit
          AutoEditable = False
          DataField = 'NOMBRE'
          PasswordPrompt = False
        end
        object CODIGO_AYUDA: TIWDBEdit
          Left = 84
          Top = 9
          Width = 157
          Height = 21
          StyleRenderOptions.RenderBorder = False
          Alignment = taRightJustify
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'CODIGO_AYUDA'
          SubmitOnAsyncEvent = True
          TabOrder = 2
          AutoEditable = False
          DataField = 'CODIGO_AYUDA'
          PasswordPrompt = False
        end
        object lbModulo: TIWLabel
          Left = 10
          Top = 59
          Width = 45
          Height = 16
          RenderSize = False
          StyleRenderOptions.RenderSize = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          HasTabOrder = False
          FriendlyName = 'lbModulo'
          Caption = 'Modulo'
        end
        object MODULO: TIWDBEdit
          Left = 84
          Top = 59
          Width = 361
          Height = 21
          StyleRenderOptions.RenderBorder = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          FriendlyName = 'MODULO'
          SubmitOnAsyncEvent = True
          TabOrder = 4
          OnAsyncExit = MODULOAsyncExit
          AutoEditable = False
          DataField = 'MODULO'
          PasswordPrompt = False
        end
        object IWLabel3: TIWLabel
          Left = 10
          Top = 87
          Width = 71
          Height = 16
          RenderSize = False
          StyleRenderOptions.RenderSize = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          HasTabOrder = False
          FriendlyName = 'IWLabel3'
          Caption = 'Descripci'#243'n'
        end
        object DESCRIPCION: TIWDBMemo
          Left = 84
          Top = 87
          Width = 728
          Height = 121
          StyleRenderOptions.RenderBorder = False
          BGColor = clNone
          Editable = True
          Font.Color = clNone
          Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Font.Size = 10
          Font.Style = []
          InvisibleBorder = False
          HorizScrollBar = False
          VertScrollBar = True
          Required = False
          TabOrder = 5
          SubmitOnAsyncEvent = True
          AutoEditable = False
          DataField = 'DESCRIPCION'
          FriendlyName = 'DESCRIPCION'
        end
        object lbActualizado: TIWLabel
          Left = 451
          Top = 11
          Width = 71
          Height = 16
          RenderSize = False
          StyleRenderOptions.RenderSize = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          HasTabOrder = False
          FriendlyName = 'lbActualizado'
          Caption = 'Actualizado'
        end
        object ACTUALIZACION: TIWDBMemo
          Left = 451
          Top = 32
          Width = 361
          Height = 46
          StyleRenderOptions.RenderBorder = False
          BGColor = clNone
          Editable = True
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          InvisibleBorder = False
          HorizScrollBar = False
          VertScrollBar = True
          Required = False
          TabOrder = 6
          SubmitOnAsyncEvent = True
          AutoEditable = False
          DataField = 'ACTUALIZACION'
          FriendlyName = 'ACTUALIZACION'
        end
        object IMAGEN: TIWDBImage
          Left = 84
          Top = 248
          Width = 728
          Height = 321
          BorderOptions.Width = 0
          UseSize = True
          FriendlyName = 'IMAGEN'
          DataField = 'IMAGEN'
        end
        object IWFileUploader1: TIWFileUploader
          Left = 10
          Top = 214
          Width = 142
          Height = 28
          TabOrder = 7
          TextStrings.DragText = 'Drop files here to upload'
          TextStrings.UploadButtonText = 'Subir archivo'
          TextStrings.CancelButtonText = 'Cancelar'
          TextStrings.UploadErrorText = 'Upload failed'
          TextStrings.MultipleFileDropNotAllowedText = 'You may only drop a single file'
          TextStrings.OfTotalText = 'of'
          TextStrings.RemoveButtonText = 'Remove'
          TextStrings.TypeErrorText = 
            '{file} has an invalid extension. Only {extensions} files are all' +
            'owed.'
          TextStrings.SizeErrorText = '{file} is too large, maximum file size is {sizeLimit}.'
          TextStrings.MinSizeErrorText = '{file} is too small, minimum file size is {minSizeLimit}.'
          TextStrings.EmptyErrorText = '{file} is empty, please select files again without it.'
          TextStrings.NoFilesErrorText = 'No files to upload.'
          TextStrings.OnLeaveWarningText = 
            'The files are being uploaded, if you leave now the upload will b' +
            'e cancelled.'
          Style.ButtonOptions.Alignment = taCenter
          Style.ButtonOptions.Font.Color = clWebWHITE
          Style.ButtonOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Style.ButtonOptions.Font.Size = 10
          Style.ButtonOptions.Font.Style = []
          Style.ButtonOptions.FromColor = clWebMAROON
          Style.ButtonOptions.ToColor = clWebMAROON
          Style.ButtonOptions.Height = 30
          Style.ButtonOptions.Width = 200
          Style.ButtonHoverOptions.Alignment = taCenter
          Style.ButtonHoverOptions.Font.Color = clWebWHITE
          Style.ButtonHoverOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Style.ButtonHoverOptions.Font.Size = 10
          Style.ButtonHoverOptions.Font.Style = []
          Style.ButtonHoverOptions.FromColor = 214
          Style.ButtonHoverOptions.ToColor = 214
          Style.ListOptions.Alignment = taLeftJustify
          Style.ListOptions.Font.Color = clWebBLACK
          Style.ListOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Style.ListOptions.Font.Size = 10
          Style.ListOptions.Font.Style = []
          Style.ListOptions.FromColor = clWebGOLD
          Style.ListOptions.ToColor = clWebGOLD
          Style.ListOptions.Height = 30
          Style.ListOptions.Width = 0
          Style.ListSuccessOptions.Alignment = taLeftJustify
          Style.ListSuccessOptions.Font.Color = clWebWHITE
          Style.ListSuccessOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Style.ListSuccessOptions.Font.Size = 10
          Style.ListSuccessOptions.Font.Style = []
          Style.ListSuccessOptions.FromColor = clWebFORESTGREEN
          Style.ListSuccessOptions.ToColor = clWebFORESTGREEN
          Style.ListErrorOptions.Alignment = taLeftJustify
          Style.ListErrorOptions.Font.Color = clWebWHITE
          Style.ListErrorOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Style.ListErrorOptions.Font.Size = 10
          Style.ListErrorOptions.Font.Style = []
          Style.ListErrorOptions.FromColor = clWebRED
          Style.ListErrorOptions.ToColor = clWebRED
          Style.DropAreaOptions.Alignment = taCenter
          Style.DropAreaOptions.Font.Color = clWebWHITE
          Style.DropAreaOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Style.DropAreaOptions.Font.Size = 10
          Style.DropAreaOptions.Font.Style = []
          Style.DropAreaOptions.FromColor = clWebDARKORANGE
          Style.DropAreaOptions.ToColor = clWebDARKORANGE
          Style.DropAreaOptions.Height = 60
          Style.DropAreaOptions.Width = 0
          Style.DropAreaActiveOptions.Alignment = taCenter
          Style.DropAreaActiveOptions.Font.Color = clWebWHITE
          Style.DropAreaActiveOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
          Style.DropAreaActiveOptions.Font.Size = 10
          Style.DropAreaActiveOptions.Font.Style = []
          Style.DropAreaActiveOptions.FromColor = clWebLIMEGREEN
          Style.DropAreaActiveOptions.ToColor = clWebLIMEGREEN
          Style.DropAreaActiveOptions.Height = 60
          Style.DropAreaActiveOptions.Width = 0
          CssClasses.Strings = (
            'button='
            'button-hover='
            'drop-area='
            'drop-area-active='
            'drop-area-disabled='
            'list='
            'upload-spinner='
            'progress-bar='
            'upload-file='
            'upload-size='
            'upload-listItem='
            'upload-cancel='
            'upload-success='
            'upload-fail='
            'success-icon='
            'fail-icon=')
          OnAsyncUploadCompleted = IWFileUploader1AsyncUploadCompleted
          OnAsyncUploadSuccess = IWFileUploader1AsyncUploadSuccess
          FriendlyName = 'IWFileUploader1'
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
        end
      end
      object PAG_00: TIWTabPage
        Left = 0
        Top = 30
        Width = 1339
        Height = 655
        RenderInvisibleControls = True
        Title = '[          Registros          ]'
        BorderOptions.NumericWidth = 0
        BorderOptions.Style = cbsNone
        Color = clWebWHITE
      end
    end
  end
  object RNAVEGADOR: TIWRegion
    Left = 0
    Top = 26
    Width = 1341
    Height = 32
    VertScrollBar.Visible = False
    RenderInvisibleControls = True
    Align = alTop
    Color = clWebMEDIUMBLUE
    object DATO: TIWEdit
      Left = 401
      Top = 1
      Width = 121
      Height = 30
      Hint = 'Busqueda del dato'
      Align = alLeft
      ParentShowHint = True
      StyleRenderOptions.RenderBorder = False
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'DATO'
      SubmitOnAsyncEvent = True
      TabOrder = 8
      ExplicitLeft = 513
      ExplicitTop = 6
      ExplicitHeight = 21
    end
    object IWRegion_Navegador: TIWRegion
      Left = 1
      Top = 1
      Width = 400
      Height = 30
      HorzScrollBar.Visible = False
      VertScrollBar.Visible = False
      RenderInvisibleControls = True
      Align = alLeft
      BorderOptions.NumericWidth = 0
      Color = clWebMEDIUMBLUE
    end
  end
end
