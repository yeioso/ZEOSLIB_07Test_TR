object FrIWPerfil: TFrIWPerfil
  Left = 0
  Top = 0
  Width = 1341
  Height = 593
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
    Height = 535
    RenderInvisibleControls = True
    Align = alClient
    object PAGINAS: TIWTabControl
      Left = 1
      Top = 1
      Width = 1339
      Height = 533
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
        533)
      object PAG_01: TIWTabPage
        Left = 0
        Top = 30
        Width = 1339
        Height = 503
        RenderInvisibleControls = True
        TabOrder = 1
        Title = '[          Datos B'#225'sicos          ]'
        BorderOptions.NumericWidth = 0
        BorderOptions.Style = cbsNone
        Color = clWebWHITE
        object IWLabel1: TIWLabel
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
          FriendlyName = 'IWLabel1'
          Caption = 'C'#243'digo'
        end
        object IWLabel8: TIWLabel
          Left = 10
          Top = 35
          Width = 49
          Height = 16
          RenderSize = False
          StyleRenderOptions.RenderSize = False
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          HasTabOrder = False
          FriendlyName = 'IWLabel1'
          Caption = 'Nombre'
        end
        object BTNCODIGO: TIWImage
          Left = 58
          Top = 8
          Width = 22
          Height = 21
          Cursor = crHandPoint
          Hint = 'Buscar'
          ParentShowHint = True
          BorderOptions.Width = 0
          UseSize = True
          OnAsyncClick = BTNCODIGOAsyncClick
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
            00200806000000737A7AF4000007314944415478DABD9679701BD51DC7BFABFB
            B01CD9B26339C63589727592389EC2781A3AD016264C61889B10AE36500E1372
            90321D086EE2B8769ACE3464B8FE683A4D81429952A09D929218738414CAB40D
            B14D54CB69E2A8894FC9B6245BB2A49576B55AADB6EFAD8F119222FB8F0E9A79
            B3ABDDF7F6FBF95DEFFD187C45BFDE2D0D7B8578A2CD545E7E3A150EEF5BDFD1
            E1A6CF99CC4945454566BD5E5F4AC6FF4D58C58878F466F1D6078A6F78891D84
            2AD1D303D96289317AFDDDDFECEDFD90C99ABF2E2108BD49412068CC345DF635
            CF7D8E2519EFF8893390FBEE874A52E3DC2F6CB8662C0C0F7D3539192797FAEC
            75B5D168D4158BC7C95A26EF98FE6EC67D16E49C361949F60AE40B5B61364868
            7B15E8F8971EBBA7A650170C226030C008BC930BC0B2AE789C530454AA19E159
            916C883CE2B31F4C099348F634A0D8C0E2A5762D8E1E2740C92402BE51FC7E8D
            9C0EBBA08A6B341D39006C2CE6E238AEA0E57943931196B4C48373DE05AB7604
            EF7515A3F91807494A637C7C1C4FDEC5A7EFDFC848DD7F565D7EF23DE97B3900
            310AC0F3B9EECFF442BEFBB94FC8607B1AB18871E15C7F09763E338584904290
            B87DF386089A7E805452D2FA37EF17B70CF9E4BE5C8078DCC55F0540F1C43C5E
            602FB6A258FC18C3C172FCA8CD8FA9080F9665515713C00B7B34D06955D17B0F
            8ADB9CEE74175911CD018853804462410073FF6716C7875E8531F23AD8541511
            1FC7E0481002A9A80AF3385E6902CA4A8D78E497DC81535DD29B647A988C582E
            00C7B9120500324533EF13FE53D08C3F8BB4AE1ABB8F04D1E91C207197A04B8F
            E3B57D29D4D8758896EEC5D7BF7D683399DE350390C801E02800A12E04900D91
            24292D0FB5406BAE42EBCB02DE7DBF1BB22C43229570EC2771AC7568C19AEF03
            6BDD85FAFAFADBC9B2B364B0B458720178DE252C0060B63224DE03F172130C66
            1B8E9DD4E3E8EF3E529E2713511C690CE1C63A2D78E377306A684269A90DB5B5
            B5B790D767A8F5F936B05A9E02907A9D4F9C8EB41846C2FD53984C469C38BB08
            2D878F239D4E434C0A787AAB1F9B6F522365580B37D38A45D672D86C36AC58B1
            E206F2B94E5AADF901120957329F07B2869C4E82771F80C9C8E0F34B56EC69FE
            0B68E868DC1FF8AE1FDBEF90A13656C329B4C2BCA88A585F8A8A8A0A5455557D
            83CCF977E68EF9250092808A075405C469AD73970FC3A4E370C96B4663D30984
            C3AC12F75BEB26D1BC4D5042F279743F34E66528292941656525162F5E0C8BC5
            5247005C050192A238BD155F05801BFA2D8CCC18C6427A3CF4F487181D9B54C4
            AF7344F1EC632C8A8B8BF08FC92720EAD7CC892F59B2849EB6D0E974EB0940EF
            D50104C125D21C50A9F24224C6DE814E70229AB0A071FFDFD0F7DF5165A1C3CE
            E3578F87602FD3E19FFE071142BD226EB7DB51535303ABD54ACE1615B45A6D61
            008102CC786076D0854A66073F837AEA244475251E6F3D8DB34E8FF27CB155C4
            6F7E3C81654BD4E80A6CC2207FB3224863EE7038505656068D46A3CC5D18402A
            9563792A7A1E69EF0B505BD662DFE18FF0FE67D3961791A3F6E89E09AC7730B8
            10DA806E0240C569BC972F5F4E938EBA7D4E6041002902A00813CB2988C84F22
            D5F7200CB6EB71E4D79FE00F1D2165B2462DE3B9ED93B8697D1A23EC6A7CD04F
            4E406BA9526ED4F2A54B97C240CE7D64EC9A06BD7E1E80645201C8F44070B40F
            08BC82BFB67F8C17FF24CD4C95D1F2C329DC79A388A05085B77AEE81D96253CA
            8D0A53EB4D2693929C74D030326A0DACC596C200C91980590FD009DE4B9F9233
            74026FBCDD8EB74E389589DB6F8B6257030F3E5D8297CF6C85C658A1245D7575
            3556AE5C09B3D94C0EA2A4D284C8721A6A9203A1682CB8E1FAEB364852EAF2BC
            00AA992A48F2110C9D3F4EC2E0432C3C8093A77AC18801B46C63C168CC38FAF7
            3B485256CF95DBAC7834CA2AC730DD9CB4445C6F34728D8F3CFC90D7E37997F4
            1C624100BA9BCDBA3F30D8858991D3884786C0B323A4DB11515AACC29A0A37FE
            E8DC045EBD4EA9F1F2F2E9AD962419C67D3E4C91DECF6C3293779550AB55D28E
            1D3B765FBCD8F71A694CC44CC179018EBFF13CBE661D4082F391ED9784466303
            070718F32AD8AF59A508538BE9DC582CAEB45D1EAF07776ED982544A84C7E391
            9FDAFBD481735F389FF37ABD62965E6100968DA2A1E1FB58732D70DFED6433A9
            FC162C6494D96B60341A156B69A868C84823039FCF8FE1911148E4FFC68DB750
            71B41D6C7BA6F36C67EB952BFD39E20501E887DBDB4FE2D0CF0F6153C326ECDA
            B91315F6CA9CE39866384D34D2CE13412F868687E158B694ECF94532113FF245
            F7B956B7DB9D573C3F8028BAA49924ECEEEAC4AAD5AB496D977CA933CEBC5200
            DA3F84C3110C13719FDF4F1271B9D4DCBCBFE53FE72F3CDFDFDF7F55F17901B2
            5BF24200914844717F9C4FF0077F76E0898181C1D74747470B8AE70358473709
            DA54CC0A648A65DFCF018829B02401CF5F7287F63CFAF0638140E04428144ACD
            279E0340ACB611F1AA852CCCFB3186E18C26D310178F2F483C9F07BEF2DFFF00
            30C0A0559A0E464D0000000049454E44AE426082}
          FriendlyName = 'BTNCODIGO'
          TransparentColor = clNone
          JpegOptions.CompressionQuality = 90
          JpegOptions.Performance = jpBestSpeed
          JpegOptions.ProgressiveEncoding = False
          JpegOptions.Smoothing = True
        end
        object CODIGO_PERFIL: TIWDBLabel
          Left = 89
          Top = 9
          Width = 104
          Height = 21
          Alignment = taRightJustify
          BGColor = cl3DLight
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          NoWrap = True
          HasTabOrder = False
          AutoSize = False
          DataField = 'CODIGO_PERFIL'
          FriendlyName = 'CODIGO_PERFIL'
        end
        object BTNNOMBRE: TIWImage
          Left = 59
          Top = 34
          Width = 22
          Height = 21
          Cursor = crHandPoint
          ParentShowHint = True
          BorderOptions.Width = 0
          UseSize = True
          OnAsyncClick = BTNNOMBREAsyncClick
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
            00200806000000737A7AF4000007314944415478DABD9679701BD51DC7BFABFB
            B01CD9B26339C63589727592389EC2781A3AD016264C61889B10AE36500E1372
            90321D086EE2B8769ACE3464B8FE683A4D81429952A09D929218738414CAB40D
            B14D54CB69E2A8894FC9B6245BB2A49576B55AADB6EFAD8F119222FB8F0E9A79
            B3ABDDF7F6FBF95DEFFD187C45BFDE2D0D7B8578A2CD545E7E3A150EEF5BDFD1
            E1A6CF99CC4945454566BD5E5F4AC6FF4D58C58878F466F1D6078A6F78891D84
            2AD1D303D96289317AFDDDDFECEDFD90C99ABF2E2108BD49412068CC345DF635
            CF7D8E2519EFF8893390FBEE874A52E3DC2F6CB8662C0C0F7D3539192797FAEC
            75B5D168D4158BC7C95A26EF98FE6EC67D16E49C361949F60AE40B5B61364868
            7B15E8F8971EBBA7A650170C226030C008BC930BC0B2AE789C530454AA19E159
            916C883CE2B31F4C099348F634A0D8C0E2A5762D8E1E2740C92402BE51FC7E8D
            9C0EBBA08A6B341D39006C2CE6E238AEA0E57943931196B4C48373DE05AB7604
            EF7515A3F91807494A637C7C1C4FDEC5A7EFDFC848DD7F565D7EF23DE97B3900
            310AC0F3B9EECFF442BEFBB94FC8607B1AB18871E15C7F09763E338584904290
            B87DF386089A7E805452D2FA37EF17B70CF9E4BE5C8078DCC55F0540F1C43C5E
            602FB6A258FC18C3C172FCA8CD8FA9080F9665515713C00B7B34D06955D17B0F
            8ADB9CEE74175911CD018853804462410073FF6716C7875E8531F23AD8541511
            1FC7E0481002A9A80AF3385E6902CA4A8D78E497DC81535DD29B647A988C582E
            00C7B9120500324533EF13FE53D08C3F8BB4AE1ABB8F04D1E91C207197A04B8F
            E3B57D29D4D8758896EEC5D7BF7D683399DE350390C801E02800A12E04900D91
            24292D0FB5406BAE42EBCB02DE7DBF1BB22C43229570EC2771AC7568C19AEF03
            6BDD85FAFAFADBC9B2B364B0B458720178DE252C0060B63224DE03F172130C66
            1B8E9DD4E3E8EF3E529E2713511C690CE1C63A2D78E377306A684269A90DB5B5
            B5B790D767A8F5F936B05A9E02907A9D4F9C8EB41846C2FD53984C469C38BB08
            2D878F239D4E434C0A787AAB1F9B6F522365580B37D38A45D672D86C36AC58B1
            E206F2B94E5AADF901120957329F07B2869C4E82771F80C9C8E0F34B56EC69FE
            0B68E868DC1FF8AE1FDBEF90A13656C329B4C2BCA88A585F8A8A8A0A5455557D
            83CCF977E68EF9250092808A075405C469AD73970FC3A4E370C96B4663D30984
            C3AC12F75BEB26D1BC4D5042F279743F34E66528292941656525162F5E0C8BC5
            5247005C050192A238BD155F05801BFA2D8CCC18C6427A3CF4F487181D9B54C4
            AF7344F1EC632C8A8B8BF08FC92720EAD7CC892F59B2849EB6D0E974EB0940EF
            D50104C125D21C50A9F24224C6DE814E70229AB0A071FFDFD0F7DF5165A1C3CE
            E3578F87602FD3E19FFE071142BD226EB7DB51535303ABD54ACE1615B45A6D61
            008102CC786076D0854A66073F837AEA244475251E6F3D8DB34E8FF27CB155C4
            6F7E3C81654BD4E80A6CC2207FB3224863EE7038505656068D46A3CC5D18402A
            9563792A7A1E69EF0B505BD662DFE18FF0FE67D3961791A3F6E89E09AC7730B8
            10DA806E0240C569BC972F5F4E938EBA7D4E6041002902A00813CB2988C84F22
            D5F7200CB6EB71E4D79FE00F1D2165B2462DE3B9ED93B8697D1A23EC6A7CD04F
            4E406BA9526ED4F2A54B97C240CE7D64EC9A06BD7E1E80645201C8F44070B40F
            08BC82BFB67F8C17FF24CD4C95D1F2C329DC79A388A05085B77AEE81D96253CA
            8D0A53EB4D2693929C74D030326A0DACC596C200C91980590FD009DE4B9F9233
            74026FBCDD8EB74E389589DB6F8B6257030F3E5D8297CF6C85C658A1245D7575
            3556AE5C09B3D94C0EA2A4D284C8721A6A9203A1682CB8E1FAEB364852EAF2BC
            00AA992A48F2110C9D3F4EC2E0432C3C8093A77AC18801B46C63C168CC38FAF7
            3B485256CF95DBAC7834CA2AC730DD9CB4445C6F34728D8F3CFC90D7E37997F4
            1C624100BA9BCDBA3F30D8858991D3884786C0B323A4DB11515AACC29A0A37FE
            E8DC045EBD4EA9F1F2F2E9AD962419C67D3E4C91DECF6C3293779550AB55D28E
            1D3B765FBCD8F71A694CC44CC179018EBFF13CBE661D4082F391ED9784466303
            070718F32AD8AF59A508538BE9DC582CAEB45D1EAF07776ED982544A84C7E391
            9FDAFBD481735F389FF37ABD62965E6100968DA2A1E1FB58732D70DFED6433A9
            FC162C6494D96B60341A156B69A868C84823039FCF8FE1911148E4FFC68DB750
            71B41D6C7BA6F36C67EB952BFD39E20501E887DBDB4FE2D0CF0F6153C326ECDA
            B91315F6CA9CE39866384D34D2CE13412F868687E158B694ECF94532113FF245
            F7B956B7DB9D573C3F8028BAA49924ECEEEAC4AAD5AB496D977CA933CEBC5200
            DA3F84C3110C13719FDF4F1271B9D4DCBCBFE53FE72F3CDFDFDF7F55F17901B2
            5BF24200914844717F9C4FF0077F76E0898181C1D74747470B8AE70358473709
            DA54CC0A648A65DFCF018829B02401CF5F7287F63CFAF0638140E04428144ACD
            279E0340ACB611F1AA852CCCFB3186E18C26D310178F2F483C9F07BEF2DFFF00
            30C0A0559A0E464D0000000049454E44AE426082}
          FriendlyName = 'BTNNOMBRE'
          TransparentColor = clNone
          JpegOptions.CompressionQuality = 90
          JpegOptions.Performance = jpBestSpeed
          JpegOptions.ProgressiveEncoding = False
          JpegOptions.Smoothing = True
        end
        object NOMBRE: TIWDBLabel
          Left = 89
          Top = 34
          Width = 445
          Height = 21
          BGColor = cl3DLight
          Font.Color = clNone
          Font.Size = 10
          Font.Style = []
          NoWrap = True
          HasTabOrder = False
          AutoSize = False
          DataField = 'NOMBRE'
          FriendlyName = 'NOMBRE'
        end
        object IWRDETALLE: TIWRegion
          Left = 10
          Top = 61
          Width = 524
          Height = 228
          HorzScrollBar.Visible = False
          VertScrollBar.Visible = False
          RenderInvisibleControls = True
          object DETALLE_PERFIL: TIWListbox
            Left = 1
            Top = 1
            Width = 464
            Height = 226
            Align = alLeft
            Font.Color = clNone
            Font.Size = 10
            Font.Style = []
            FriendlyName = 'DETALLE_PERFIL'
            NoSelectionText = '-- No Selection --'
          end
          object IWRBOTONDETALLE: TIWRegion
            Left = 483
            Top = 1
            Width = 40
            Height = 226
            RenderInvisibleControls = True
            Align = alRight
            object BtnGrid: TIWImage
              Left = 7
              Top = 97
              Width = 24
              Height = 24
              Cursor = crHandPoint
              RenderSize = False
              StyleRenderOptions.RenderSize = False
              BorderOptions.Width = 0
              UseSize = False
              OnAsyncClick = BtnGridAsyncClick
              Picture.Data = {
                0954506E67496D61676589504E470D0A1A0A0000000D49484452000000180000
                00180806000000E0773DF8000004154944415478DA9D550D4CD465187F9EE3FE
                DCF7417C2425AC31294C27444D57237094CD2B191F170DB4D2D50CE6A5C6CA0F
                96A08202614DD111B842998251AB1D0BB059169BB39AD46C4B57E9CA61E65C0C
                0F0CC1FBBEA7E7FFBFFFC17990F3DFB3DBEDD973F7BEBFF7F77B9EF7F7626B4D
                C59244E7E5CFF43109C940012400FE00207F22F3F05AA88EAA281ABBFA3BC4A5
                A4235120F87F8E89B191BF1C105382E973F4F91FB735F53EB8B4187C5E27F236
                24AFE61C6ECFC36B529D506388A3937BCAC1B2ED303AFEBC401323C370DF824C
                FCF5CB6E5A5D595780E9F7EA8ABADB9A7A1E58B20CBCCE71207939F2F122F3F0
                5AA86E889B0B03FB364276452D9CFDF4105CF9F10CE4BEFE260C5F380BE5D52D
                C5CC4057F4514B833D393307DCCE715E72F712893F991292E9F4C12A48CDC9C7
                F3FD3DE4F77820362505754681D6371EB54A005DFB77D9E7CCCF02F7C43FD300
                2C07D1ED79782D1884E6A4541A3C520F82D98814F093741CFE728E8ED0B623A7
                AD5312CD7B321FBCAE49501AFA9844F8FA3D1B3C56B68967C407DC748650C1A5
                EF7B616DCDFEE210803D2DA7107CAE496E9B8229E2B66BCD09F4D59EB5F06C75
                274E38AE52B4CE0C5A53029EEBFB8056D9AA82121DDDBBC33E77D113E0B9352E
                EF119A4288CCC36B924486F8FBE9DB0FAB61C5F62E9C1CBD460203E8CC22403B
                036C0D021C3BB0BB27F5710B78DD93F21E771B246E0603CD1BC1F27607DCBA31
                0C1203733C9CEF6B8795B6ADD3123D9457023E8F73B653DF8101F03D88A5130D
                AFC0335B0EA2FBE6A8CC203E8C810C307F5919F8BD2E85371951D099E844FD1A
                78FAADF7D1337963160096E870E3667BD2C38BF9A24D286480A88F4DA4C163EF
                C0F2AA76E4F50C609A09D0DDDAD4B3D0B206FC3EB7C2214510347A385EF722E4
                BDB1579418A2B5A6D97BB070F9CB0CE0E18B445386159987D74275416B201160
                E9FA7731E0F3FE3783452B5E05BFDFAB50208428410BFDB56590BBAE51322A41
                6B9CC9A07D77257B512EF83D2E653DE02EF358720F1A21AFB21955A822194066
                50254F516B933DA3A01C0201EF0CFF09CF23BD4894284A1D4DFD3B4B21675D03
                E71A49228D3E167FFEBC8D564E8D294B9451C8002C9132BB6689D4D170BC7615
                8FB853E2267951941ADC37C760FB273F0425EA6CDE695F60590DE4F7291E5355
                945AF6A22EBC3E7491C81F008DD188577E3A492F6DA80E32E868DA624FCBB532
                807F9673DF99834A2DD0A9D64D90FD5A1D7EB36F075DBF7C091E292A65600FF1
                83336DD759D60D0AEFC074F4D63C0F59A536181A3C057FFFF60B641695C0B573
                67C0B6EB90F8A2E90BC5299A975D80D2ABABD08BC4577AB0B31E92321663407C
                702492808EA18BAECD2D7D2F608231FAD1ECB4D80AD65FC3EC9558694824A9A9
                187E04CE7C011CF9EE0F47075A9F7BCA60FF62E01E2E0AFF5BA3992142790A73
                33C7FE0588483847F735FFAE0000000049454E44AE426082}
              FriendlyName = 'BtnGrid'
              TransparentColor = clNone
              JpegOptions.CompressionQuality = 90
              JpegOptions.Performance = jpBestSpeed
              JpegOptions.ProgressiveEncoding = False
              JpegOptions.Smoothing = True
            end
          end
        end
      end
      object PAG_00: TIWTabPage
        Left = 0
        Top = 30
        Width = 1339
        Height = 503
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
      Width = 164
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
      TabOrder = 2
      ExplicitLeft = 301
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
