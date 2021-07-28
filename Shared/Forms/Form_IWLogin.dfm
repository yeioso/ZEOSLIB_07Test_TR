object FrIWLogin: TFrIWLogin
  Left = 0
  Top = 0
  Width = 1014
  Height = 436
  RenderInvisibleControls = True
  AllowPageAccess = True
  ConnectionMode = cmAny
  OnCreate = IWAppFormCreate
  Background.Fixed = False
  HandleTabs = False
  LeftToRight = True
  LockUntilLoaded = True
  LockOnSubmit = True
  ShowHint = True
  DesignLeft = 2
  DesignTop = 2
  object IWURL1: TIWURL
    Left = 223
    Top = 33
    Width = 391
    Height = 17
    Hint = 'http://www.asoftwaree.com/'
    Alignment = taCenter
    Color = clNone
    Font.Color = clNone
    Font.Size = 10
    Font.Style = [fsUnderline]
    HasTabOrder = True
    TargetOptions.AddressBar = False
    TerminateApp = False
    URL = 'http://www.asoftwaree.com/'
    UseTarget = False
    FriendlyName = 'IWURL1'
    TabOrder = 6
    RawText = False
    Caption = 'www.asoftwaree.com, (+57)  312 870 6774'
  end
  object IWLabel43: TIWLabel
    Left = 223
    Top = 11
    Width = 391
    Height = 16
    Font.Color = clNone
    Font.Size = 10
    Font.Style = []
    NoWrap = True
    HasTabOrder = False
    FriendlyName = 'IWLabel43'
    Caption = 'Implementado por Antioque'#241'a de Software Especifico (A.S.E.)'
  end
  object IWLOGIN: TIWRegion
    Left = 0
    Top = 0
    Width = 209
    Height = 436
    RenderInvisibleControls = True
    Align = alLeft
    BorderOptions.NumericWidth = 2
    Color = clWebMEDIUMBLUE
    object IWLabel1: TIWLabel
      Left = 10
      Top = 8
      Width = 52
      Height = 16
      Font.Color = clWebWHITE
      Font.Size = 10
      Font.Style = [fsBold]
      HasTabOrder = False
      FriendlyName = 'IWLabel1'
      Caption = 'Usuario'
    end
    object IWLabel2: TIWLabel
      Left = 10
      Top = 59
      Width = 82
      Height = 16
      Font.Color = clWebWHITE
      Font.Size = 10
      Font.Style = [fsBold]
      HasTabOrder = False
      FriendlyName = 'IWLabel1'
      Caption = 'Contrase'#241'a'
    end
    object USUARIO: TIWEdit
      Left = 10
      Top = 24
      Width = 188
      Height = 21
      StyleRenderOptions.RenderBorder = False
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'USUARIO'
      SubmitOnAsyncEvent = True
    end
    object PASSWORD: TIWEdit
      Left = 10
      Top = 77
      Width = 188
      Height = 21
      StyleRenderOptions.RenderBorder = False
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'IWEdit1'
      SubmitOnAsyncEvent = True
      TabOrder = 1
      PasswordPrompt = True
      DataType = stPassword
    end
    object BtnOK: TIWButton
      Left = 10
      Top = 307
      Width = 91
      Height = 30
      Cursor = crHandPoint
      Caption = 'Aceptar'
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'BtnOK'
      TabOrder = 3
      OnAsyncClick = BtnOKAsyncClick
    end
    object IWLabel3: TIWLabel
      Left = 10
      Top = 111
      Width = 58
      Height = 16
      Font.Color = clWebWHITE
      Font.Size = 10
      Font.Style = [fsBold]
      HasTabOrder = False
      FriendlyName = 'IWLabel1'
      Caption = 'Captcha'
    end
    object CAPTCHA: TIWEdit
      Left = 10
      Top = 128
      Width = 188
      Height = 21
      StyleRenderOptions.RenderBorder = False
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'USUARIO'
      SubmitOnAsyncEvent = True
      TabOrder = 2
    end
    object BTNRECUPERAR: TIWButton
      Left = 10
      Top = 344
      Width = 186
      Height = 30
      Cursor = crHandPoint
      Caption = 'Recuperar Contrase'#241'a'
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'BTNRECUPERAR'
      TabOrder = 4
      OnAsyncClick = BTNRECUPERARAsyncClick
    end
    object BtnCancel: TIWButton
      Left = 114
      Top = 307
      Width = 82
      Height = 30
      Cursor = crHandPoint
      Caption = 'Cancelar'
      Color = clBtnFace
      Font.Color = clNone
      Font.Size = 10
      Font.Style = []
      FriendlyName = 'BtnOK'
      TabOrder = 5
      OnAsyncClick = BtnCancelAsyncClick
    end
    object BTNAYUDA: TIWImage
      Left = 87
      Top = 386
      Width = 28
      Height = 29
      Cursor = crHandPoint
      Hint = 'Ayuda'
      BorderOptions.Width = 0
      UseSize = True
      OnAsyncClick = BTNAYUDAAsyncClick
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000300000
        003008060000005702F98700000E044944415478DAD55A699054D5153EA7F76D
        7AA67BF69986D9980D865D5211B4A4A231A8D18AFB820B1164734563D42A8349
        CAFCB02C9360D424881A5C414050A40C6AE256316ADC88104516112D1866987D
        EBE9EEF76ECEB96FEF194CF7CFBC9ADBEFF67DEFDD3EDF3DDFD9EE1B84FFF303
        4F74A1A4A464B6AAAA0BFC7EBF70B95C191ACA0821321E5F205D37759EA86A98
        EE72FB82AA2A842AE487A0DB85AA9FF9E0B3A20AA03F6E2ED5EBF5A9050117F5
        6950BB07F48740950FE88DC633F4E470322D8653EAD10F37DCBD2B2F00213A68
        BE6F162E5C180B0683407DBE8F7F10F9A3A07C121454B502D24153087E46C82F
        74599B960785F645EBF34FF1078DC961AB8F724EA1DFC4E8848408D83B3022DE
        FBBC4355927D977DBE71D5E69C01D0AA4FABAFAFDFB56EDD3A16124803B219FD
        ECB3D1375AF6F7ECA6C13A71DF387AFA06E19C3BB782A7A0FCBEFD4F2FBA3367
        005EAF773AB54F57AD5A25264C9820579A84928B4C87A02FB4E21E1A77D30514
        52687989EE71A1763FDF871288BCC7258574D9FAC6B87C9268AACF41BF635E27
        A5DCB6F67D18F694DEBBF7A945AB7306408F4EA7D3A7A5A5A5C2761FF7A5BA15
        558545773C04EEC25AF4B88488F8118EF62AA8EA5C605E587D615284F88D9100
        8A91940AA98C36AEEAD7411A8A71AFF55C2AADC2D060FF5B197FFC076F3F708E
        C809001D1280DBED666D803E216432199D226E38EDA6E761EE9CE9F0E1A1142C
        680BC2475FA7E048AFE29875CCE4F46C3C849088B961F7918C3406B45D730865
        5D008F8BC08D74D7EF58FDBDAFF202E0F178840E00D95B10004DDD046CF6B2CD
        D0D0D48A15856E71B82B03731BFCF8D73D496158B1AE31DDD041D8C414138BDD
        904C03760CA8EC1DACEBA8F5D182A0CFC11E40D4ECB8A3F170AE00A651DB45C2
        0B326809405114914AA5A42DB8DD1E98BD620B44CA26614DB187380B100BBBB0
        674815878E670C4B14FA0F687DD4E150DF4D2BDA58EEC17DC714763863001AF7
        6A604C28552FFFBCA13D2F002C7C2010605F0D04004647478169C56DF68AAD10
        2AAD9713B45478602029A0A5D2036FEE4D49C73FE607D05A623E8A23E4BDE8CB
        F141D52146367D6C02166FBFBDBE3B2F00140304C7010220353032328224BCF0
        78BC308B0114D7982BD656ED259F04A27F44C0A12EC55C75F627B4E2C2EF9502
        E32885C38C2224B526C65DE2DB1E1535B76F6848B70C934EA60AA22FFDAC7E30
        570053A9FD3B1C0E0B8A69BCFA48FC17C3C3C3A8D9854F0208C6276A00E82037
        886D551E514846FAEEFE34C6231E31AF290CAD890056157985D78D92CB197235
        BD430A1C3896C23DDF8E88AF3A46B17B48E8B401733E836E3609FD2FDE5697CE
        0B404141011008E97D9842838383D22B7918C0F26D108A271C0FB190F32679A1
        25118199756170D392B3B0EFEE1B827DEDA3309854A134EA8193EA4230A326C0
        A0E148770AD6BED103ED7D992C61D04E27B1EDD65AD778827E2780C2C2421189
        44209D4E4B0D0C0C0CA0CFE7135E1F6BE045081655D90C1031E84371D3825298
        52ED27AA80D8FD4D12D6BDD1852329A1D3C932D8B609015C3C3F2E423E1752CA
        231E7AAD0B0EB4A750CB38B2B48198DABA8A10E701A08D14F859515191602DB0
        F761007D7D7D48462D293473E54B108C56383CCCD5A7C68836215E79EC1D56C4
        EA4DC7C85DAABAD01A85EC8067D505C492F9710A86207A8755B8775B270E2615
        43681B9D60F0855535D1BC01C4E3718846A3D2FB9016800048AFE4F305248040
        4199394B2CEC867B2FAE008F5B9BF258EF28FCEE952EE81BB1823962F68F23DC
        795E094C2CF6C96BAFEC1A80ED1F0F98EB6FBBFDF8965B2696E603600A01D84D
        29B5D001200110BDBDBD52033E7F1066ADDC0EFE48B1B9BA5389122B7F586C06
        1E0EDEAF7CD20DAFED494A3AD982B3D08593FD0BE644F1F42961194BBEEA4CE3
        FD3BBAC68B094737DF3CA13A2F0014B076532EE4D040777737A7DA6000F085E3
        E603CD957EB8E52CE722ED3F3A0C9B3FE8A31443386283CE10795E303D023F9E
        512025E91E54E09E2D9D4EC134008736DD94A8CB1B40454585D440329944B203
        4100904B057F2044005E066FA8C8E4B4DF83F8CB0BCB456150CB403911DBFA61
        3F19E6300EA740740EDA346031445C736A11CE265BE0B1831D695CB3B35BD808
        67A418FB9EBF31D19C0F80C914B0F65456564A001CC09842C78F1F478E0D8110
        B9C915042010652D9B9468AAF48BCBBE5F08E48DF05F074704F33916024C299C
        3E20F40CDB00D05F24E012AB2F2841022FC7367FD08FEFED4F8A8C6AF75852C4
        DD1B6FAC9E9633005AC0C9A4813D894402D80B1100F644400080DDAA06600778
        FC6193ADC644CC65A6872AB33A6D3C1103E824DBF479000646C11CBFECE4289C
        DC1894CF1D3E9E86353B7B2896008CA6C748F6D1861BAA4FCA07402B69E03F54
        CC081D80A4506767271200110C47A506DCBED0184AE8C2D9D48F18F109E121C1
        520A4AE326A38659B501BCEA94A82C92064614F1E0CE5ECA8B1424005417736D
        8036170DEF3D777DD5DCBC01D4D6D64A00434343124047470712A54430520833
        96BD6402707A9831FC95DEA42C02D045140A52765E56E885E5A7C7D0E796FE1F
        1F7DA34F1CE55A42BF97B5905650A3A736F8F6332B2BE7E703A085729ECFA92E
        969421009242C78E1D038ACE102200D3963280804907FB8C59B9A5948AA95542
        8C4B2A6EB8FDEC222808BAE1484F061E7BAB1F7A86144B143AC90246B51709E2
        D5A75756FE286700C47F09A0A1A141E800905CA92000C8E945381A83694BB681
        CB1B90B35B6266D3495F0EBD1FF6032E9C1B15ADD57E38443EFFD137FBC5485A
        D823AEA651FAA46A1B15611AFC8EA756549C9B0F80664ADABE686C6C94D9A81D
        00A717E1681CA62E79015C9E803D63B4A7BF363A59606A4BBD78F39945A2BD4F
        813FBCD64B25BF10C36967C566CC412938014003C0D62797975F983300E2BF04
        D0D4D4045C0F7016CA146A6F6F87582C0691C262685BBC850164051CB06131D6
        DF9AF78AB9053073A21FD6BFD30B7B8E2892567EF24CC9B47523DA9EB3FC186C
        58BFACECF2BC0050D6C900840E406A800020E547A2A08832CE6B371100BF237F
        37D40F600F58DA389791BFBA208E5FB6A7C573FF1C0032661C1845C16582D72D
        C833A17EB359EADB1DC4937F5956B6286700C4FF2602B0B7B9B959D6C40C80BD
        9001201A2B83293FDD04E8F18DCB5F873DE8E389B8076E5E508464B462EF9134
        04BCDA3809CEDB43820D97DDECB83531C0BA2796962ECD0B0009BEB7A5A58532
        4F1F501D605288123C88C6CB61F2351B01DDBE71324C276F8CDECC5A3F5C3427
        0CBFDED603A98C3616F2097697905179534BC80228633A2487777BF8F1EB4A6E
        C81900F1BF91007CD9DADA2AB755B8903134C0196A617125B45EFD1CB8DC5E47
        3D00DF11134E690A5025E6C335AFF63BBC1381C06406797742D6CCD48422CC09
        0DEDFEFEB12525B7E60580D2E62F274F9E2C78078201702E6400282AA98296AB
        9EB500E80B8656EE62DF1291FD539B03D050E6C5F5EF0C3AEB5FC211F40891CC
        5842BB884E8AEAA889EF5BB7B8F8AE9C01106D2611807D53A64C911BB5068538
        90318562A5D5D07CE533B45C1EDB0602D88298ED130DBAB8649ED36F1438B67B
        79FFDACF399092E5BDAC6DAF5F3FBA387E4FCE00883E0600B9716B50885309D6
        40AC6C02345EF12403B0D5AD9606D0900AACA08616B16D34E30D60EDBA4B8BC0
        4815E8D89A18E0176BAF8DFF26670024BC04D0D6D626276000EC461940595999
        04507FE91312804515470D2B4B0273A1D109C00269ACB1762FDB00EF21292A66
        5152DC4100EECF07400345E0FDAC01FEDEDFDF6F6A8001C4CB2742CD458F1100
        B733FA228C119A0BFCB3A787C4F41A1F10B5712FC581173F1E664F6470DCD29C
        4D1B021C11FA16B28107730640C14B02200DC86D4502206D80D2692000505C59
        0B899FFC9996CCED98C0FE72428F07308FBCCFF9B3238E5FFBFB9E11D8F9D9B0
        652B26A7D0446F456279AC242FF4C79C0190F0F554791D600AF18696A101AE07
        CACBCB4571651D549CFBB07CC1E15875C031B5C115271750C9E837A3326FD41F
        EACCC023AFF7493B31CCD41E00D152A9E185963E715DE9BA9C0190F0F5948532
        0059CC1B1AE08A8C004049553D949CFD20BF7101D307D957D14204E7CC88C019
        6D21C7FC9F7C3D0A4FFF63C011F4D0F681B6E7F5CF45940BADCF1900095F47ED
        206B40072035C0353117FA25550D103BF3B720C30E66EDE7A3531B452137AE3A
        2B268A422EA98291942AFEF4B73EF8A62B633362F98ED09CC3700A561FAE7C6A
        79C5B37901A04AEC201B31AFBC01A0ABAB4B0350DD0085673CA001C80A58760F
        A30F63D8EFA21AC0476E12F18BA329D137ACDADCAB0ED606DC9E10A236D92554
        D0E4FE96D2D000A7D3BC27C4818C37787B7A7A80F78A5803F1056B6CD68759C6
        EC9CFA7FD0636C00B4A7E6DA0BC4F39EBDBE6A7B3E000AC91375534DCC2984CC
        46F9FD006B82B3D178653D949111837CAF38B61871A83F3B0E8CCD58CD39704C
        2184C6D6FD991B6F4CBC9E33003E48D0FD8944A29E29C4EF05F81D1903E18A2C
        56510755E7AFB58470545ED99BB8E3D0C20972DCCD007DAB49F653433DF35FBE
        7BC6DB79018846A39BC9E35CC81A482693F22D25EF0F718D5C545E07132F797C
        8CCAC7AFC46CF4CAAEDA10B2A8E714C7880B87DFDF70DA27CFDFF59D00282B03
        9FDEFCD4029491DE40006E63EEF3FB01D6006FF2F2D662B4AC161A2E5F6FC6F9
        13153136F94FE0A9740A59FE3E2BB25396DA7B74F4DD472E3D2BD9DFC1AF5893
        D4786B2CA53799C3A20EC06F6BBC5F524285CDC5B42A217E47C6EF9CA9B9293B
        75797C412CAC991310A678CE85D4F6731C34B29FE5BF51D04515B4FF9B50B507
        84AA5FE7EFBC21A1501A901AE838F069B2AF7DB72EB801C06899F1286480E228
        E5D6CF1EBDEFCEEA1BD7ED0D6DCD7E085B53B39A420B4EC9B48BEB317ED7A450
        ADA108A166E4FFAFA8AAA2EDD799CF9BC77F01295BC98CCEF688200000000049
        454E44AE426082}
      FriendlyName = 'BTNAYUDA'
      TransparentColor = clNone
      JpegOptions.CompressionQuality = 90
      JpegOptions.Performance = jpBestSpeed
      JpegOptions.ProgressiveEncoding = False
      JpegOptions.Smoothing = True
    end
    object IWRegion1: TIWRegion
      Left = 10
      Top = 157
      Width = 188
      Height = 56
      RenderInvisibleControls = True
      object IWImageCaptcha: TIWImage
        Left = 1
        Top = 1
        Width = 186
        Height = 54
        Align = alClient
        RenderSize = False
        StyleRenderOptions.RenderSize = False
        BorderOptions.Width = 0
        UseSize = False
        FriendlyName = 'IWImageCaptcha'
        TransparentColor = clNone
        JpegOptions.CompressionQuality = 90
        JpegOptions.Performance = jpBestSpeed
        JpegOptions.ProgressiveEncoding = False
        JpegOptions.Smoothing = True
        ExplicitWidth = 208
      end
    end
    object IWRegion2: TIWRegion
      Left = 75
      Top = 229
      Width = 68
      Height = 56
      RenderInvisibleControls = True
      BorderOptions.NumericWidth = 0
      BorderOptions.Style = cbsNone
      Color = clWebMEDIUMBLUE
      object IWImage3: TIWImage
        Left = 17
        Top = 4
        Width = 34
        Height = 32
        RenderSize = False
        StyleRenderOptions.RenderSize = False
        BorderOptions.Width = 0
        UseSize = False
        OnAsyncClick = IWImage3AsyncClick
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
          00200806000000737A7AF4000005744944415478DA9D570B50546514FE76C165
          D9E521203A0A26223820E060882328F9221257124C1E8E96D38440696945A5E5
          0496268DD6689313A44D619A8022583980092864A8A3498BC8980FCA7CA488CA
          7B177697CE7FDDA565DD7BF7E29939F3EFECBDF73FDF797DE7FF251029293B8A
          46D2F23CE93CD2C9A4BEA472E3630DE93552356925E98F056B92EE8AD95722C2
          70282DEB4913488789C4DB475A42BA8580D43F110032EC42CB56D25452A9D848
          5988817437E93B04A45D3400321E424B291E85F93171533A62AC870BD4D7EF88
          05C2D2134F201A6C0220E333683942EACAB7DBAA98699819300E47FFB88CFC9A
          7A18FA4581682355118893BC008C9ED70A1967E2E3391CEFC6CD849B9323EA9B
          6F617B591DB43A83581051E691180060CCF979BEB05BCAC4D11EC85C3803CE8E
          0EB8DEF2005B4A6AF050D32B361D534C35610E208F9634A12F3DC8E3D8291311
          E13F16EEF4DB5C8E9CBD88DC8AD3503A292191D86CAEAF0940FA000063AB9D83
          40B5ABC87052443064F676D0E90DB87CAB052E0A39BC3C5CD1DEADC1DADD8771
          B3B50D52A9144ECE4AD8DBDB0B0160F90A632D6A0250484B12DFDB19D1E19835
          C907DDDA5E14D6D693B74D183FCA1D9B96C7721EACDB73048D661D1119E083D5
          0B6762E7D13368BAD9C2B76D110148961819EE06784826717A10164F9B841BF7
          1E62C3DE72DC7ED08E91AE4EC85BB50472D9306C3950899AC66B83BE9915EC8B
          F713A3F1A0B307997B2BD0DDDB676D6BF6A73703C0886697B53758B56F4E8E46
          1B857875DE21DC6BEFE2FE77775620E72515CACE35A1E4D405ABEEAD5B321773
          42FC5074528D03A71BF952B29201D8CFB260EDE95BAA48844FF042CEC14A5437
          5CC550C48340E6AF5DCAA56DE9B67D903BCAE12077B07CAD800168A41F932C9F
          38C965C84D8DC3DDB64EBCBCA300FDE2C8669064A5C42032D0076F52815EFCE7
          0E6432197589C2BC4B2E32003DF87FAA0D48D8F831C88C9B8143750DC82BAF1B
          BA759284881064CC8FC0173FD57285CBC4A24B340C8055DF164CF1C78B51A1F8
          ACF4388E9EFFF38900CC0E9E80F589F3F0EDB13328A81D3C14954A0597125E00
          8BA60620253284ABF2E31786967F93C41077BC1D3F9B8B208BA4A5B094F0A620
          3AC417AFCC09432E7D5C62E56331924EE15F4C69C8FEA1027597FE7EEC399582
          96B70819D76F4C9C8B934DCDF8A8E097211B6775F6DD9A1478BA382179EBF7E8
          E8D15A7BA789B70DA5F4F42BEA02C761F658B17D3F5A3BBA870460EE643FBCF7
          82B003D40D858244944CDC1F1F1E886AF515E4145759DD24617A3062C302B19E
          E8D80472848B123B33167393F2F5BC125CFDB7950F409A20152B886AB72D7F8E
          9BFB9B8B8E3D46B9CF04F97255AE21AA4DDF7990E38CD1EE2ED8B46C3EBC470C
          C7BE13BF634FD559BE20F5514B7ADB1C46815E9E78EDD9707CF9F3AF830A29E8
          A951C859A1E2086AC3DE3234DFB90FD5D4402453EB2A1C64D4BA97F079E909F0
          F117797FA062635A92A871ACD3E9D0D9D10983F1ECC546F0F6D445DC38662398
          8D63FF319EB0B79342DBA7433E795DFC9B5AA8440C7676D2B0B2AC95F5A20F24
          0683011D0442AFD3E30D3A8EA9A60E6E1C36A86A882F0E9D6A404B5B97907148
          A4925D15D9699CAD211DC9FA29DE5D9D5D705338E0E365B11837D28DF33E8BFA
          9C71BD18A1D03793869667AF1C7C243382B0792865207A7A34B0A3887C90148D
          303F6FAAFE2E7CB8AF1C576EB7C286B453E14591F181FC3CD1B19C8956AB8586
          BC7F35360271D38250A5BE8C4F8BAB058D93E70BA8F0F88FE51691E0BD9898A4
          AFEF51713EEDEB85BFEEDEE7252B63D8E3CD3D1704600421EA6AA6D7EBB9E234
          E8ADDE0B0C52A9E41B329369CAB9680066406C5E4E5987745271EA2822A6E090
          C7A564FC13D66A42FBDB04600644F07A4EC5798D3A444D69A922E387C96351D7
          F3FF00B73E35DD315911450000000049454E44AE426082}
        FriendlyName = 'IWImage3'
        TransparentColor = clNone
        JpegOptions.CompressionQuality = 90
        JpegOptions.Performance = jpBestSpeed
        JpegOptions.ProgressiveEncoding = False
        JpegOptions.Smoothing = True
      end
      object IWLabel4: TIWLabel
        Left = 0
        Top = 40
        Width = 68
        Height = 16
        Align = alBottom
        Alignment = taCenter
        Font.Color = clWebWHITE
        Font.Size = 8
        Font.Style = [fsBold]
        HasTabOrder = False
        FriendlyName = 'IWLabel4'
        Caption = 'RECAPTCHA'
        ExplicitTop = 39
        ExplicitWidth = 66
      end
    end
  end
end
