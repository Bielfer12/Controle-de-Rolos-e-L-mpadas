#INCLUDE "Totvs.ch"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TopConn.ch"

User Function CLRLLP23()
    
    Local aArea       := FWGetArea()
    Private oBrowse  
    
	Private aRotina   := {}
    Private cCadastro := "Controle de rolos e Lampadas CCL"
 
    DbSelectArea('ZCA')

    aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZCA")
    oBrowse:SetDescription(cCadastro)
	oBrowse:addLegend("ZCA_TIPO == 'I'","BR_VERDE"   ,'IMPRESSORA')
	oBrowse:addLegend("ZCA_TIPO == 'E'","BR_AZUL"    ,'ESTAÇÃO')
	oBrowse:addLegend("ZCA_TIPO == 'R'","BR_AMARELO" ,'ROLO')
	oBrowse:addLegend("ZCA_TIPO == 'L'","BR_VERMELHO",'LAMPADA')
    oBrowse:DisableDetails()

    oBrowse:Activate()
 
    ZCA->(DbCloseArea())

    FWRestArea(aArea)

Return

User function MRL23()

    Local aArea       := FWGetArea()
    Local oBrowseM

	Private aRotina   := {}
    Private cCadastro := "MANUTENÇÃO DE ROLOS"

    DbSelectArea('ZM1')

    aRotina := MenuDef()

    oBrowseM := FWMBrowse():New()
    oBrowseM:SetAlias("ZM1")
    oBrowseM:SetDescription(cCadastro)
    oBrowseM:DisableDetails()

    oBrowseM:Activate()

    ZM1->(DbCloseArea())

    FWRestArea(aArea)

return 

User function MLP23()

    Local aArea       := FWGetArea()
    Local oBrowseML

	Private aRotina   := {}
    Private cCadastro := "MANUTENÇÃO DE LAMPADAS"

    DbSelectArea('ZM2')

    aRotina := MenuDef()

    oBrowseML := FWMBrowse():New()
    oBrowseML:SetAlias("ZM2")
    oBrowseML:SetDescription(cCadastro)
    oBrowseML:DisableDetails()

    oBrowseML:Activate()

    ZM2->(DbCloseArea())

    FWRestArea(aArea)

return

Static Function MenuDef()
    Private aRotina  := {}
    Private aSubMenu := {}
    Private aSubRela := {}
    Private aSubRelaRl := {}
    Private aSubRelaLp := {}
 
    if SELECT('ZM1') > 0 
        AADD(aRotina,    {"Visualizar"              , "AXVISUAL"        , 0, 2})
        AADD(aRotina,    {"Incluir"                 , "U_incMRl"        , 0, 3})
        AADD(aRotina,    {"Alterar"                 , "U_altMRL"        , 0, 4})
        AADD(aRotina,    {"Excluir"                 , "U_excMRL"        , 0, 5})
    elseif SELECT('ZM2') > 0     
        AADD(aRotina,    {"Visualizar"              , "AXVISUAL"        , 0, 2})
        AADD(aRotina,    {"Incluir"                 , "U_incMLP"        , 0, 3})
        AADD(aRotina,    {"Alterar"                 , "U_altMLP"        , 0, 4})
        AADD(aRotina,    {"Excluir"                 , "U_excMLP"        , 0, 5})
    else      
        AADD(aRotina,    {"Visualizar"              , "AXVISUAL"        , 0, 2})
        AADD(aRotina,    {"Incluir"                 , "U_RLLP23INC"     , 0, 3})
        AADD(aRotina,    {"Alterar"                 , "U_RLLP23ALT"     , 0, 4})
        AADD(aRotina,    {"Excluir"                 , "U_RLLP23EXC"     , 0, 5})
        AADD(aRotina,    {"Manutenção"              , aSubMenu          , 0, 3})
        AADD(aSubMenu,   {"Manutenção de Rolos"     , "U_MRL23"         , 0, 3})
        AADD(aSubMenu,   {"Manutenção de Lampadas"  , "U_MLP23"         , 0, 3})
        AADD(aRotina,    {"Relatorios"              , aSubRela          , 0, 3})
   
        AADD(aSubRela,   {"Relat. Manu. Rolos"     , aSubRelaRl         , 0, 3})
        AADD(aSubRelaRl, {"Período"                ,'U_SelecioZM1()'    , 0, 3})
        AADD(aSubRelaRL, {"Impres/Est/Rolos"       ,'U_R2SelecioZM1()'  , 0, 3})
        AADD(aSubRelaRl, {"Resumo(Status)"         ,'U_R3SelecioZM1()'       , 0, 3})

        AADD(aSubRela,   {"Relat. Manu. Lamp."     , aSubRelaLp         , 0, 3})
        AADD(aSubRelaLp, {"Período"                ,'U_ZM2Selecio()'    , 0, 3})
        AADD(aSubRelaLp, {"Impres/Lamp"            , 'U_R2ZM2Selecio()' , 0, 3})

        AADD(aRotina,    {"Legenda"                , "U_Legend"         , 0, 3})
    endif
Return aRotina

User Function RLLP23INC()
    Local aArea          := FWGetArea()
    
    Local nObjLarg       := 0
    Local nObjAltu       := 0
    Local nObjColu       := 0
    Local nObjLinh       := 0
    Local nJanAltu       := 0                             
    Local nJanLarg       := 0                             
    Local cJanTitulo     := 'Escolha cadastro itens'       
    Local lCentraliz     := .T.                            

    Local cFont          := 'Tahoma'
    Local oFontPadrao    := TFont():New(cFont, , -12)
    Local lDimPixels     := .T.
    
    // OBJETO 1: TGROUP
    Local oGrp1

    // Objeto2
    Local oSay2 
    Local cSay2T         := 'TIPO DE CADASTRO'
    
    // // objeto3
    Private oCombo3
    Private aCombA3      := {'XX = Nenhum Item','I = Impressora','E = Estação', 'R = Rolo', 'L = Lâmpada'}

    // Objeto4
    Private oBtn4
    Private cBtn4T       := 'Cadastrar'
    Private bBtn4B       := {|| U_CadBtnTipo()}

    // Objeto5
    Private oBtn5
    Private cBtn5T       := 'Fechar'

    //Objeto 06
    Private oGrp6

    Private oDlg 

// -------------------------------------------------------------------------------
// 
//              TELA ESCOLHA DE TIPO INCLUSÃO - GABRIEL
// 
// -------------------------------------------------------------------------------

    //CORPO 
    nJanAltu := 160                             
    nJanLarg := 300   
    oDlg := TDialog():New(0, 0, nJanAltu, nJanLarg, cJanTitulo, , , , , , , , ,lDimpixels)

    nObjLinh := 002
    nObjColu := 002 
    nObjLarg := (nJanLarg / 2) 
    nObjAltu := (nJanAltu / 2) - 002 - 030 
    oGrp1 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, 'Tipagem: ', oDlg, , , lDimPixels)
    oGrp1:SetCSS("TGroup {Font: bold;}")

    nObjLinh := 012
    nObjColu := 50
    nObjLarg := 100
    nObjAltu := 10
    oSay2 := TSay():New(nObjLinh, nObjColu, {|| cSay2T}, oDlg,,oFontPadrao,,,,lDimpixels,,,nObjLarg,nObjAltu)    

    nObjLinh := 25
    nObjColu := 40
    nObjLarg := 80
    nObjAltu := 23
    oCombo3 := TComboBox():New(nObjLinh, nObjColu,, aCombA3, nObjLarg, nObjAltu,oDlg,,{||},,,,lDimPixels,oFontPadrao)  

    nObjLinh := 050
    nObjColu := 002 
    nObjLarg := (nJanLarg / 2) 
    nObjAltu := (nJanAltu / 2) - 002
    oGrp6 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,, oDlg, , , lDimPixels)

    nObjLinh := 55
    nObjColu := 23
    nObjLarg := 50
    nObjAltu := 17
    oBtn4 := TButton():New(nObjLinh, nObjColu, cBtn4T, oDlg, bBtn4B, nObjLarg, nObjAltu, , oFontPadrao,,lDimPixels)    

    nObjLinh := 55
    nObjColu := 83
    nObjLarg := 50
    nObjAltu := 17
    oBtn5 := TButton():New(nObjLinh, nObjColu, cBtn5T, oDlg,{|| oDlg:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels) 

    oDlg:Activate(,,,lCentraliz,,,)
     
    FWRestArea(aArea)

Return
  
// -------------------------------------------------------------------------------
// 
//              FUNÇÃO APRESENTAR LEGENDA - GABRIEL
// 
// -------------------------------------------------------------------------------

User Function Legend()
	Local ALegenda := {}

	AADD(aLegenda,{"BR_VERDE" ,"Impressora" })
	AADD(aLegenda,{"BR_AZUL" ,"Estação" })
    AADD(aLegenda,{"BR_AMARELO" ,"Rolo" })
    AADD(aLegenda,{"BR_VERMELHO" ,"Lampada" })

	BrwLegenda(cCadastro, "Legenda", aLegenda)
Return Nil

User Function CadBtnTipo(cAlias,nReg,nOpc)

    Local aArea         := FWGetArea()


    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0

    Local cFont          := 'Tahoma'
    Local oFontPadrao  

    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0

    Local cJanTitulo    := ''

    Private aHeader     := {}
    Private aCols       := {}

    Private oDlgCad

    Private oSay1T
    Private cSay1TT     := "CADASTRO DE IMPRESSORA - INCLUSÃO"
    Private oBtn1T
    Private cBtn1TT     := 'Fechar'
    Private oBtn2T
    Private cBtn2TT     := 'Salvar'

    Private oSay2T
    Private cSay2TT     := 'Código'
    Private oGet2T
    Private cGet2TT     := ''

    Private oSay3T
    Private cSay3TT     := 'Descrição'
    Private oGet3T
    Private xGet3TT     := SPACE(100)

    Private oSay4T
    Private cSay4TT     := 'Tipo'
    Private oGet4T
    Private xGet4TT     := SPACE(10)

    Private oSay5T
    Private cSay5TT     := 'Ativo'
    Private oCombo5T
    Private aCombo5TT   := {'ESCOLHA OPÇÃO','S=SIM','N=NAO'}

    Private oSay6T
    Private cSay6TT     := 'Data'
    Private oGet6T
    Private xGet6TT     := DATE()

    Private oGrp7
    Private oGrp8

    Private oSay9T
    Private cSay9TT     := 'Nome Rolo'
    Private oGet9T
    Private xGet9TT     := SPACE(50)

    Private oSay10T
    Private cSay10TT    := 'Diametro Rolo'
    Private oGet10T
    Private xGet10TT    := SPACE(8)

    Private oSay11T
    Private cSay11TT    := 'Comp.Rolo'
    Private oGet11T
    Private xGet11TT    := SPACE(4)

    Private oSay12T
    Private cSay12TT    := 'Material Rolo'
    Private oGet12T
    Private xGet12TT    := SPACE(50)

    Private oSay13T
    Private cSay13TT    := 'Dureza Rolo'
    Private oGet13T
    Private xGet13TT    := SPACE(50)

    Private oSay14T
    Private cSay14TT    := 'Nome Lampada'
    Private oGet14T
    Private xGet14TT    := Space(TamSX3('ZCA_NOMELP')[1])

    Private oSay15T
    Private cSay15TT    := 'Impressoras'
    Private oGet15T
    Private cGet15TT    := ''

    Private oSay16T
    Private cSay16TT    := 'Modelo Lampada'
    Private oGet16T
    Private xGet16TT    := Space(TamSX3('ZCA_MODLP')[1])

    Private oSay17T
    Private cSay17TT    := 'Tensão'
    Private oGet17T
    Private xGet17TT    := Space(TamSX3('ZCA_TENSLP')[1])

    Private oSay18T
    Private cSay18TT    := 'Corrente'
    Private oGet18T
    Private xGet18TT    := Space(TamSX3('ZCA_CORRLP')[1])

    Private oSay19T
    Private cSay19TT    := 'Potencia'
    Private oGet19T
    Private xGet19TT    := Space(TamSX3('ZCA_POTLP')[1])

    Private oSay20T
    Private cSay20TT    := 'Modelo Refletor'
    Private oGet20T
    Private xGet20TT    := Space(TamSX3('ZCA_MODREF')[1])

    Private oMsGetZCA
    Private lRefresh := .T.

    Private nEsc
    Private nEscBD

    nEscBD := 1

    if oCombo3:Nat == 2 

    nEsc := 3

    oDlg:End()
// -------------------------------------------------------------------------------
// 
//              TELA CADASTRO DE IMPRESSORA - GABRIEL
// 
// -------------------------------------------------------------------------------

        AADD(aHeader,{"Codigo",;       
                      "ZCA_COD",;     
                      "",;             
                       6,;             
                       0,;             
                      "AlwaysTrue()",; 
                      "",;
                      "C",;            
                      ""})

        AADD(aHeader,{"Descrição",;
                      "ZCA_DESC",;
                      "@!",;
                       100,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Tipo",;
                      "ZCA_TIPO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "I=Impressora;E=Estacao;R=Rolo;L=Lampada;"})

        AADD(aHeader,{"Ativo",;
                      "ZCA_ATIVO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "S=SIM;N=NAO;"})

        AADD(aHeader,{"Data",;
                      "ZCA_DATA",;
                      "",;
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "D",;
                      ""})

        Processa({|| fCarAcols()}, "Processando")

        cJanTitulo := 'Cadastro de Impressora'
        oDlgCad := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,,,lDimpixels)

        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgCad, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1TT  := "CADASTRO DE IMPRESSORA - INCLUSÃO"
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1T   := TSay():New(nObjLinh, nObjColu, {|| cSay1TT}, oDlgCad,,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1T   := TButton():New(nObjLinh, nObjColu, cBtn1TT, oDlgCad,{|| oDlgCad:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2T := TButton():New(nObjLinh, nObjColu, cBtn2TT, oDlgCad,{|| CadBtnSalv()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       
        
        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgCad, , , lDimPixels)
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2T   := TSay():New(nObjLinh, nObjColu, {|| cSay2TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2T:SetCss(" TSay {Font: Semi-Bold}")

        geraCod()
        
        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2T   := TGet():New(nObjLinh, nObjColu, {||cGet2TT}, oDlgCad, nObjLarg, nObjAltu,,,,, oFontPadrao,,, lDimPixels,,,,,,,,,,,,,,.T.)

        oGet2T:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3T   := TSay():New(nObjLinh, nObjColu, {|| cSay3TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3TT := u, xGet3TT)} , oDlgCad, nObjLarg, nObjAltu,,,,, oFontPadrao,,, lDimPixels,,,,,,,,,,,,,, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4T   := TSay():New(nObjLinh, nObjColu, {|| cSay4TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4T   := TGet():New(nObjLinh, nObjColu,{|| 'I = IMPRESSORA'} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4T:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5T := TSay():New(nObjLinh, nObjColu, {|| cSay5TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5t := TComboBox():New(nObjLinh, nObjColu,, aCombo5TT, nObjLarg, nObjAltu,oDlgCad,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6T := TSay():New(nObjLinh, nObjColu, {|| cSay6TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6TT := u, xGet6TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
        
        oGet6T:lActive := .F.

        oMsGetZCA := MsNewGetDados():New(    130,;                
                                             005,;                
                                             443,;                
                                             950,;                
                                             ,;                    
                                             "AllwaysTrue()",;    
                                             ,;                   
                                             "",;                 
                                             {},;                 
                                             ,;                   
                                             999,;                
                                             ,;                   
                                             ,;                   
                                             ,;                   
                                             oDlgCad,;            
                                             aHeader,;            
                                             aCols) 

            oMsGetZCA:lActive := .F. 

           oMsGetZCA:oBrowse:Refresh()
        
        oDlgCad:Activate()

// -------------------------------------------------------------------------------
// 
//              TELA CADASTRO DE ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------
 
    elseif oCombo3:Nat == 3

    nEsc := 3

    oDlg:End()

     AADD(aHeader,{"Codigo",;       
                      "ZCA_COD",;   
                      "",;          
                       6,;          
                       0,;          
                      "AlwaysTrue()",; 
                      "",;
                      "C",;           
                      ""})

        AADD(aHeader,{"Nome Estação",;
                      "ZCA_DESC",;
                      "@!",;
                       100,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Tipo",;
                      "ZCA_TIPO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "I=Impressora;E=Estacao;R=Rolo;L=Lampada;"})

        AADD(aHeader,{"Ativo",;
                      "ZCA_ATIVO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "S=SIM;N=NAO;"})

        AADD(aHeader,{"Data",;
                      "ZCA_DATA",;
                      "",; 
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "D",;
                      ""})

        Processa({|| fCarAcols()}, "Processando")

        cJanTitulo := 'Cadastro de Estação'
        oDlgCad := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgCad, , , lDimPixels)

        // Criação objetos 01
        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1TT := 'Cadastro de Item - ESTAÇÃO'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1T := TSay():New(nObjLinh, nObjColu, {|| cSay1TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1T := TButton():New(nObjLinh, nObjColu, cBtn1TT, oDlgCad,{|| oDlgCad:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2T := TButton():New(nObjLinh, nObjColu, cBtn2TT, oDlgCad,{|| CadBtnSalv()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       
        // oBtn2T:SetCss("TButton {background-color: blue;  font:semi-bold; font-color:white;}")
        
        //Criação do Objetos 08
        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgCad, , , lDimPixels)
        
        //Criação objetos 02
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2T := TSay():New(nObjLinh, nObjColu, {|| cSay2TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2T:SetCss(" TSay {Font: Semi-Bold}")

        geraCod()

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2T := TGet():New(nObjLinh, nObjColu, {||cGet2TT}, oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2T:lActive := .F.

        //CRIAÇÃO DO OBJETO 3
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 80
        nObjAltu := 20
        oSay3T := TSay():New(nObjLinh, nObjColu, {|| cSay3TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3T:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        cSay3TT := 'Nome Estação'
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3T := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3TT := u, xGet3TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        // CRIAÇÃO DO OBJETO 4
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4T := TSay():New(nObjLinh, nObjColu, {|| cSay4TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4T := TGet():New(nObjLinh, nObjColu,{|| 'E = ESTACAO'} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4T:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5T := TSay():New(nObjLinh, nObjColu, {|| cSay5TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5t := TComboBox():New(nObjLinh, nObjColu,, aCombo5TT, nObjLarg, nObjAltu,oDlgCad,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6T := TSay():New(nObjLinh, nObjColu, {|| cSay6TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6TT := u, xGet6TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
        
        oGet6t:lActive := .F.

        oMsGetZCA := MsNewGetDados():New(    130,;                
                                             005,;                
                                             443,;                
                                             950,;                
                                             ,;                
                                             "AllwaysTrue()",;    
                                             ,;                   
                                             "",;                 
                                             {},;                 
                                             ,;                   
                                             999,;                
                                             ,;                   
                                             ,;                   
                                             ,;                   
                                             oDlgCad,;            
                                             aHeader,;            
                                             aCols) 
            
            oMsGetZCA:lActive := .F. 

        oDlgCad:Activate()

// -------------------------------------------------------------------------------
// 
//              TELA CADASTRO DE ROLOS - GABRIEL
// 
// -------------------------------------------------------------------------------

  elseif oCombo3:Nat == 4

    nEsc := 3

  oDlg:End()

     AADD(aHeader,{"Codigo",;          
                      "ZCA_COD",;      
                      "",;             
                       6,;             
                       0,;             
                      "AlwaysTrue()",; 
                      "",;
                      "C",;            
                      ""})

        AADD(aHeader,{"Descrição",;
                      "ZCA_DESC",;
                      "@!",;
                       100,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Tipo",;
                      "ZCA_TIPO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "I=Impressora;E=Estacao;R=Rolo;L=Lampada;"})

        AADD(aHeader,{"Ativo",;
                      "ZCA_ATIVO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "S=SIM;N=NAO;"})

        AADD(aHeader,{"Data",;
                      "ZCA_DATA",;
                      "",;
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "D",;
                      ""})
        
        AADD(aHeader,{"Nome Rolo",;
                      "ZCA_NOMERL",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})
        
        AADD(aHeader,{"Diametro Rolo",;
                      "ZCA_DIAMRL",;
                      "",;
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Comprimento Rolo",;
                      "ZCA_COMPRL",;
                      "",;
                       4,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Material Rolo",;
                      "ZCA_MATRL",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "N",;
                      ""})

        AADD(aHeader,{"Dureza Rolo",;
                      "ZCA_DURERL",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        Processa({|| fCarAcols()}, "Processando") 

        cJanTitulo := 'Cadastro de Rolos'
        oDlgCad := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgCad, , , lDimPixels)

        // Criação objetos 01
        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1TT  := 'Cadastro de Item - ROLOS'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1T := TSay():New(nObjLinh, nObjColu, {|| cSay1TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1T   := TButton():New(nObjLinh, nObjColu, cBtn1TT, oDlgCad,{|| oDlgCad:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2T   := TButton():New(nObjLinh, nObjColu, cBtn2TT, oDlgCad,{|| CadBtnSalv()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgCad, , , lDimPixels)
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2T   := TSay():New(nObjLinh, nObjColu, {|| cSay2TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2T:SetCss(" TSay {Font: Semi-Bold}")

        geraCod()

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2T   := TGet():New(nObjLinh, nObjColu, {||cGet2TT}, oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2T:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3T   := TSay():New(nObjLinh, nObjColu, {|| cSay3TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3T:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3TT := u, xGet3TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4T   := TSay():New(nObjLinh, nObjColu, {|| cSay4TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4T   := TGet():New(nObjLinh, nObjColu,{|| 'R = ROLO'} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4T:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5T   := TSay():New(nObjLinh, nObjColu, {|| cSay5TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5t := TComboBox():New(nObjLinh, nObjColu,, aCombo5TT, nObjLarg, nObjAltu,oDlgCad,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)


        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6T   := TSay():New(nObjLinh, nObjColu, {|| cSay6TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6TT := u, xGet6TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet6t:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay9T   := TSay():New(nObjLinh, nObjColu, {|| cSay9TT}, oDlgCad,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet9T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet9TT := u, xGet9TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 30
        nObjAltu := 20
        oSay10T   := TSay():New(nObjLinh, nObjColu, {|| cSay10TT}, oDlgCad,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 30
        nObjAltu := 15
        oGet10T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet10TT := u, xGet10TT)} , oDlgCad, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 190
        nObjLarg := 50
        nObjAltu := 20
        oSay11T   := TSay():New(nObjLinh, nObjColu, {|| cSay11TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 190
        nObjLarg := 50
        nObjAltu := 15
        oGet11T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet11TT := u, xGet11TT)} , oDlgCad, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 255
        nObjLarg := 80
        nObjAltu := 20
        oSay12T   := TSay():New(nObjLinh, nObjColu, {|| cSay12TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 255
        nObjLarg := 80
        nObjAltu := 15
        oGet12T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet12TT := u, xGet12TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 350
        nObjLarg := 80
        nObjAltu := 20
        oSay13T   := TSay():New(nObjLinh, nObjColu, {|| cSay13TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay13T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 350
        nObjLarg := 80
        nObjAltu := 15
        oGet13T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet13TT := u, xGet13TT)} , oDlgCad, nObjLarg, nObjAltu, "@!", /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oMsGetZCA := MsNewGetDados():New(    155,;                
                                             005,;                
                                             443,;                
                                             950,;                
                                             ,;                 
                                             "AllwaysTrue()",;    
                                             ,;                   
                                             "",;                 
                                             {},;                 
                                             ,;                   
                                             999,;                
                                             ,;                   
                                             ,;                   
                                             ,;                   
                                             oDlgCad,;            
                                             aHeader,;            
                                             aCols) 
            
            oMsGetZCA:lActive := .F. 

        oDlgCad:Activate()

// -------------------------------------------------------------------------------
// 
//              TELA CADASTRO DE LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseif oCombo3:Nat == 5

    nEsc := 3

    oDlg:End()

    AADD(aHeader,{"Codigo",;       
                      "ZCA_COD",;      
                      "",;             
                       6,;             
                       0,;             
                      "AlwaysTrue()",; 
                      "",;
                      "C",;            
                      ""})

        AADD(aHeader,{"Descrição",;
                      "ZCA_DESC",;
                      "@!",;
                       100,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Tipo",;
                      "ZCA_TIPO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "I=Impressora;E=Estacao;R=Rolo;L=Lampada;"})

        AADD(aHeader,{"Ativo",;
                      "ZCA_ATIVO",;
                      "@!",;
                       1,;
                       0,;
                      "NAOVAZIO()",;
                      "",;
                      "C",;
                      "S=SIM;N=NAO;"})

        AADD(aHeader,{"Data",;
                      "ZCA_DATA",;
                      "",;
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "D",;
                      ""})

        AADD(aHeader,{"Nome Lampada",;
                      "ZCA_NOMELP",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})
        
        AADD(aHeader,{"Impressora",;
                      "ZCA_IMPLP",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Modelo Lampada",;
                      "ZCA_MODLP",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Tensão Lampada",;
                      "ZCA_TENSLP",;
                      "",;
                       6,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeader,{"Corrente Lampada",;
                      "ZCA_CORRLP",;
                      "",;
                       7,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})
        
        AADD(aHeader,{"Potencia Lampada",;
                      "ZCA_POTLP",;
                      "",;
                       4,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})
        
        AADD(aHeader,{"Modelo Refletor",;
                      "ZCA_MODREF",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})


        Processa({|| fCarAcols()}, "Processando") 
        cJanTitulo := 'Cadastro de Rolos'
        oDlgCad := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgCad, , , lDimPixels)

        // Criação objetos 01
        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1TT  := 'Cadastro de Item - ROLOS'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1T := TSay():New(nObjLinh, nObjColu, {|| cSay1TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1T   := TButton():New(nObjLinh, nObjColu, cBtn1TT, oDlgCad,{|| oDlgCad:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2T   := TButton():New(nObjLinh, nObjColu, cBtn2TT, oDlgCad,{|| CadBtnSalv()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgCad, , , lDimPixels)
        
        //Criação objetos 02
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2T   := TSay():New(nObjLinh, nObjColu, {|| cSay2TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2T:SetCss(" TSay {Font: Semi-Bold}")

        geraCod()

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2T   := TGet():New(nObjLinh, nObjColu, {||cGet2TT}, oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet2T:lActive := .F.

        //CRIAÇÃO DO OBJETO 3
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3T   := TSay():New(nObjLinh, nObjColu, {|| cSay3TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3T:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3TT := u, xGet3TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        // CRIAÇÃO DO OBJETO 4
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4T   := TSay():New(nObjLinh, nObjColu, {|| cSay4TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4T   := TGet():New(nObjLinh, nObjColu,{|| 'L = LAMPADA'} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)
    
        oGet4T:lActive := .F.

        // CRIAÇÃO DO OBJETO 5
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5T   := TSay():New(nObjLinh, nObjColu, {|| cSay5TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5t := TComboBox():New(nObjLinh, nObjColu,, aCombo5TT, nObjLarg, nObjAltu,oDlgCad,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        // CRIAÇÃO DO OBJETO 6
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6T   := TSay():New(nObjLinh, nObjColu, {|| cSay6TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6TT := u, xGet6TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,.T.)

        oGet6t:lActive := .F.

        // CRIAÇÃO OBJETO 09
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay14T   := TSay():New(nObjLinh, nObjColu, {|| cSay14TT}, oDlgCad,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay14T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet14T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet14TT := u, xGet14TT)} , oDlgCad, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu:= 20
        oSay15T   := TSay():New(nObjLinh, nObjColu, {|| cSay15TT}, oDlgCad,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay15T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T. 
        oGet15T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet15TT := u, cGet15TT)} , oDlgCad, nObjLarg, nObjAltu,,, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet15T:cF3 := 'U_zConsImp()' 
        oGet15T:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay16T   := TSay():New(nObjLinh, nObjColu, {|| cSay16TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay16T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet16T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet16TT := u, xGet16TT)} , oDlgCad, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 50
        nObjAltu := 20
        oSay17T   := TSay():New(nObjLinh, nObjColu, {|| cSay17TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay17T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 30
        nObjAltu := 15
        oGet17T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet17TT := u, xGet17TT)} , oDlgCad, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 380
        nObjLarg := 50
        nObjAltu := 20
        oSay18T   := TSay():New(nObjLinh, nObjColu, {|| cSay18TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay18T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 380
        nObjLarg := 30
        nObjAltu := 15
        oGet18T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet18TT := u, xGet18TT)} , oDlgCad, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oSay19T   := TSay():New(nObjLinh, nObjColu, {|| cSay19TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay19T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 30
        nObjAltu := 15
        oGet19T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet19TT := u, xGet19TT)} , oDlgCad, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

         oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 485
        nObjLarg := 50
        nObjAltu := 20
        oSay20T   := TSay():New(nObjLinh, nObjColu, {|| cSay20TT}, oDlgCad,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay20T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 485
        nObjLarg := 80
        nObjAltu := 15
        oGet20T   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet20TT := u, xGet20TT)} , oDlgCad, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oMsGetZCA := MsNewGetDados():New(    155,;                
                                             005,;                
                                             443,;                
                                             950,;                
                                             ,;                   
                                             "AllwaysTrue()",;    
                                             ,;                   
                                             "",;                 
                                             {},;                 
                                             ,;                   
                                             999,;                
                                             ,;                   
                                             ,;                   
                                             ,;                   
                                             oDlgCad,;            
                                             aHeader,;           
                                             aCols) 
            
            oMsGetZCA:lActive := .F. 

        oDlgCad:Activate()

    elseif oCombo3:Nat == 0 .OR. oCombo3:Nat == 1
        Alert('!!COLOQUE UM ITEM VALIDO PARA O CADASTRO!!')
    endif

    FWRestArea(aArea)
return()

Static Function fCarAcols()

    Local aArea := FWGetArea()
    Local cQry := ''
    Local nTotal := 0
    Local nAtual := 0

// -------------------------------------------------------------------------------
// 
//              SQL/ACOLS MSNEWGETDADOS IMPRESSORA - GABRIEL
// 
// -------------------------------------------------------------------------------

    if oCombo3:Nat == 2
        cQry := "SELECT ZCA_COD,ZCA_DESC,ZCA_TIPO,ZCA_ATIVO,ZCA_DATA FROM ZCA990 WHERE ZCA_TIPO LIKE '%I%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aCols)

        aSize(aCols, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aCols,{QRY_ZCA->ZCA_COD,;
                        QRY_ZCA->ZCA_DESC,;
                        QRY_ZCA->ZCA_TIPO,;
                        QRY_ZCA->ZCA_ATIVO,;
                        QRY_ZCA->ZCA_DATA,;
                        })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

// -------------------------------------------------------------------------------
// 
//              SQL/ACOLS MSNEWGETDADOS ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseif oCombo3:Nat == 3
    
        cQry := "SELECT ZCA_COD,ZCA_DESC,ZCA_TIPO,ZCA_ATIVO,ZCA_DATA FROM ZCA990 WHERE ZCA_TIPO LIKE '%E%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aCols)

        aSize(aCols, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aCols,{QRY_ZCA->ZCA_COD,;
                        QRY_ZCA->ZCA_DESC,;
                        QRY_ZCA->ZCA_TIPO,;
                        QRY_ZCA->ZCA_ATIVO,;
                        QRY_ZCA->ZCA_DATA,;
                        .F.;
                        })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

// -------------------------------------------------------------------------------
// 
//              SQL/ACOLS MSNEWGETDADOS ROLO - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseif oCombo3:Nat == 4

     cQry := "SELECT ZCA_COD,ZCA_DESC,ZCA_TIPO,ZCA_ATIVO,ZCA_DATA,ZCA_NOMERL,ZCA_DIAMRL,ZCA_COMPRL,ZCA_DURERL FROM ZCA990 WHERE ZCA_TIPO LIKE '%R%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aCols)

        aSize(aCols, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aCols,{QRY_ZCA->ZCA_COD,;
                        QRY_ZCA->ZCA_DESC,;
                        QRY_ZCA->ZCA_TIPO,;
                        QRY_ZCA->ZCA_ATIVO,;
                        QRY_ZCA->ZCA_DATA,;
                        QRY_ZCA->ZCA_NOMERL,;
                        QRY_ZCA->ZCA_DIAMRL,;
                        QRY_ZCA->ZCA_COMPRL,;
                        QRY_ZCA->ZCA_DURERL,;
                        .F.;
                        })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

// -------------------------------------------------------------------------------
// 
//              SQL/ACOLS MSNEWGETDADOS LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseif oCombo3:Nat == 5

     cQry := "SELECT ZCA_COD,ZCA_DESC,ZCA_TIPO,ZCA_ATIVO,ZCA_DATA,ZCA_NOMELP,ZCA_IMPLP,ZCA_MODLP,ZCA_TENSLP,ZCA_CORRLP,ZCA_POTLP,ZCA_MODREF FROM ZCA990 WHERE ZCA_TIPO LIKE '%L%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aCols)

        aSize(aCols, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aCols,{QRY_ZCA->ZCA_COD,;
                        QRY_ZCA->ZCA_DESC,;
                        QRY_ZCA->ZCA_TIPO,;
                        QRY_ZCA->ZCA_ATIVO,;
                        QRY_ZCA->ZCA_DATA,;
                        QRY_ZCA->ZCA_NOMELP,;
                        QRY_ZCA->ZCA_IMPLP,;
                        QRY_ZCA->ZCA_MODLP,;
                        QRY_ZCA->ZCA_TENSLP,;
                        QRY_ZCA->ZCA_CORRLP,;
                        QRY_ZCA->ZCA_POTLP,;
                        QRY_ZCA->ZCA_MODREF,;
                        .F.;
                        })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

    endif
    FWRestArea(aArea)
return

Static function CadBtnSalv()

    Local aArea := FWGetArea()
    Local cAlias := 'ZCA'
    Local lEscolha := .F.

// -------------------------------------------------------------------------------
// 
//              BOTÃO CADASTRO IMPRESSORA/ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------

    if oCombo3:Nat == 2 .OR. oCombo3:Nat == 3
    lEscolha := MsgYesNo('DESEJA CONFIRMAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            if Empty(oGet2T:BUFFER) .OR. Empty(oGet3T:BUFFER)  
                MSGALERT('HÁ ALGUM CAMPO SEM DIGITAÇÃO','ATENÇÃO')
            elseif  oCombo5T:Nat == 0
                MsgAlert('CAMPO ATIVO SEM ESCOLHA','ATENÇÃO')    
                else
                begin transaction 
                RecLock(cAlias, .T.)
                    ZCA->ZCA_COD   := Alltrim(oGet2T:BUFFER)
                    ZCA->ZCA_DESC  := LTrim(oGet3T:BUFFER)
                    ZCA->ZCA_TIPO  := Alltrim(oGet4T:BUFFER)
                    if oCombo5T:NAT == 2
                        ZCA->ZCA_ATIVO := oCombo5T:AITEMS[2]
                    elseif oCombo5T:NAT == 3
                        ZCA->ZCA_ATIVO := oCombo5T:AITEMS[3]
                    elseif oCombo5T:nat == 1 
                        MsgAlert('POR FAVOR ESCOLHA UMA OPÇÃO VALIDA NO CAMPO ATIVO!!(SIM/NAO)','ATENÇÃO')
                        DisarmTransaction()
                        return
                    ENDIF
                    ZCA->ZCA_DATA  := CTOD(oGet6T:BUFFER)
                ZCA -> (MSUNLOCK())
                end transaction
                MsgInfo('CADASTRO FEITO COM SUCESSO!!')

                lEsc := MsgYesNo('CONTINUAR COM AS MESMAS INFORMAÇÕES?','ATENÇÃO')
                
                if lEsc == .F.
                    oGet3T:BUFFER   := SPACE(100)
                    oCombo5T:Nat    := 3
                endif
            
            endif
        else
            MsgInfo('NENHUM CADASTRO EFETUADO')
        ENDIF
// -------------------------------------------------------------------------------
// 
//              BOTÃO CADASTRO ROLOS - GABRIEL
// 
// -------------------------------------------------------------------------------
    elseif oCombo3:Nat == 4
    lEscolha := MsgYesNo('DESEJA CONFIRMAR O CADASTRO?','ATENÇÃO')
    
    if lEscolha = .T.

            if Empty(oGet2T:BUFFER) .OR. Empty(oGet3T:BUFFER) .OR. Empty(oGet9T:BUFFER)  .OR. Empty(oGet10T:BUFFER) .OR. Empty(oGet11T:BUFFER)  .OR. Empty(oGet12T:BUFFER) .OR. Empty(oGet13T:BUFFER) 
                MSGALERT('HÁ ALGUM CAMPO SEM DIGITAÇÃO','ATENÇÃO')
            ELSEIF IsAlpha(oGet10T:BUFFER) .OR. IsAlpha(oGet11T:BUFFER)
                MsgAlert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS','ATENÇÃO')
            elseif  oCombo5T:Nat == 0
                MsgAlert('CAMPO ATIVO SEM ESCOLHA','ATENÇÃO')      
            else
                begin transaction 
                RecLock(cAlias, .T.)
                    ZCA->ZCA_COD   := Alltrim(oGet2T:BUFFER)
                    ZCA->ZCA_DESC  := Alltrim(oGet3T:BUFFER)
                    ZCA->ZCA_TIPO  := Alltrim(oGet4T:BUFFER)
                    if oCombo5T:NAT == 2
                        ZCA->ZCA_ATIVO := oCombo5T:AITEMS[2]
                    elseif oCombo5T:NAT == 3
                        ZCA->ZCA_ATIVO := oCombo5T:AITEMS[3]
                    elseif oCombo5T:nat == 1 
                        MsgAlert('POR FAVOR ESCOLHA UMA OPÇÃO VALIDA NO CAMPO ATIVO!!(SIM/NAO)','ATENÇÃO')
                        DisarmTransaction()
                        Return
                    ENDIF
                    ZCA->ZCA_DATA    := CTOD(oGet6T:BUFFER)
                    ZCA->ZCA_NOMERL  := Alltrim(oGet9T:BUFFER)
                    ZCA->ZCA_DIAMRL  := AllTrim(oGet10T:BUFFER)
                    ZCA->ZCA_COMPRL  := AllTrim(oGet11T:BUFFER)
                    ZCA->ZCA_MATRL   := Alltrim(oGet12T:BUFFER)
                    ZCA->ZCA_DURERL  := AllTrim(oGet13T:BUFFER)
                ZCA -> (MSUNLOCK())
                end transaction
                MsgInfo('CADASTRO FEITO COM SUCESSO!!')

                lEsc := MsgYesNo('CONTINUAR COM AS MESMAS INFORMAÇÕES?','ATENÇÃO')

                if lEsc == .F.
                    oGet3T:BUFFER    := SPACE(100)
                    oGet9T:BUFFER    := SPACE(50)
                    oGet10T:BUFFER   := SPACE(8)
                    oGet11T:BUFFER   := SPACE(4)
                    oGet12T:BUFFER   := SPACE(50)
                    oGet13T:BUFFER   := SPACE(50)
                endif
            endif
        else
            MsgInfo('NENHUM CADASTRO EFETUADO')
    ENDIF

// -------------------------------------------------------------------------------
// 
//              BOTÃO CADASTRO LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------
    elseif oCombo3:Nat == 5
    lEscolha := MsgYesNo('DESEJA CONFIRMAR O CADASTRO?','ATENÇÃO')
    
    if lEscolha = .T.

            if Empty(oGet2T:BUFFER) .OR. Empty(oGet3T:BUFFER) .OR. Empty(oGet14T:BUFFER) .OR. Empty(oGet15T:BUFFER) .OR. Empty(oGet16T:BUFFER)  .OR. Empty(oGet17T:BUFFER) .OR. Empty(oGet18T:BUFFER) .OR. Empty(oGet19T:BUFFER)  .OR. Empty(oGet20T:BUFFER) 
                MSGALERT('HÁ ALGUM CAMPO SEM DIGITAÇÃO','ATENÇÃO')
            ELSEIF IsAlpha(oGet17T:BUFFER) .OR. IsAlpha(oGet18T:BUFFER) .OR. IsAlpha(oGet19T:BUFFER)
                MsgAlert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS','ATENÇÃO')
            elseif  oCombo5T:Nat == 0
                mSGAlert('CAMPO ATIVO SEM ESCOLHA','ATENÇÃO')   
            else
                begin transaction 
                RecLock(cAlias, .T.)
                    ZCA->ZCA_COD   := Alltrim(oGet2T:BUFFER)
                    ZCA->ZCA_DESC  := Alltrim(oGet3T:BUFFER)
                    ZCA->ZCA_TIPO  := Alltrim(oGet4T:BUFFER)
                    if oCombo5T:NAT == 2
                        ZCA->ZCA_ATIVO := oCombo5T:AITEMS[2]
                    elseif oCombo5T:NAT == 3
                        ZCA->ZCA_ATIVO := oCombo5T:AITEMS[3]
                    elseif oCombo5T:nat == 1 .OR. oCombo5T:nat == 0
                        MsgAlert('POR FAVOR ESCOLHA UMA OPÇÃO VALIDA NO CAMPO ATIVO!!(SIM/NAO)', 'ATENÇÃO')
                        DisarmTransaction()
                        return
                    ENDIF
                    ZCA->ZCA_DATA    := CTOD(oGet6T:BUFFER)
                    ZCA->ZCA_NOMELP  := Alltrim(oGet14T:BUFFER)
                    ZCA->ZCA_IMPLP   := Alltrim(oGet15T:BUFFER)
                    ZCA->ZCA_MODLP   := Alltrim(oGet16T:BUFFER)
                    ZCA->ZCA_TENSLP  := Alltrim(oGet17T:BUFFER)
                    ZCA->ZCA_CORRLP  := Alltrim(oGet18T:BUFFER)
                    ZCA->ZCA_POTLP   := Alltrim(oGet19T:BUFFER)
                    ZCA->ZCA_MODREF  := Alltrim(oGet20T:BUFFER)
                ZCA -> (MSUNLOCK())
                end transaction
                MsgInfo('CADASTRO FEITO COM SUCESSO!!')
                
                lEsc := MsgYesNo('CONTINUAR COM AS MESMAS INFORMAÇÕES?','ATENÇÃO')

                if lEsc == .F.
                    oGet3T:BUFFER    := SPACE(100)
                    oGet14T:BUFFER   := SPACE(50)
                    oGet15T:BUFFER   := SPACE(50)
                    oGet16T:BUFFER   := SPACE(50)
                    oGet17T:BUFFER   := SPACE(6)
                    oGet18T:BUFFER   := SPACE(7)
                    oGet19T:BUFFER   := SPACE(4)
                    oGet20T:BUFFER   := SPACE(50)
                ENDIF   
            endif
        else
            MsgInfo('NENHUM CADASTRO EFETUADO')
    ENDIF
    endif

    geraCod()

    fCarAcols()
    oMsGetZCA:ACOLS := aCols
    oMsGetZCA:oBrowse:Refresh()

FWRestArea(aArea)
return

Static function geraCod()

    Local aArea := FWGetArea()
    Local oTempTable 
    Local aFields := {}
    Local cQry 
    Local cNumG := ""
    Local cTira := ''
    Local cAliasTemp := GetNextAlias()
    Local cTableName := ''

    oTempTable := FWTemporaryTable():NEW(cAliasTemp)
   
    AADD(aFields,{'COD_GR', "C", 6, 0})
    AADD(aFields,{'COD_I' , "C", 6, 0})
    AADD(aFields,{'COD_E' , "C", 6, 0})
    AADD(aFields,{'COD_R' , "C", 6, 0})
    AADD(aFields,{'COD_L' , "C", 6, 0})

    oTempTable:SetFields(aFields)

    oTempTable:AddIndex('1',{"COD_GR", "COD_I"})
    // oTempTable:SetPrimaryKey({'COD_GR'})

    oTempTable:Create()

    cTableName := oTempTable:GetRealName()

// -------------------------------------------------------------------------------
// 
//              CODIGO GERACODIGO ITENS GERAL - GABRIEL
// 
// -------------------------------------------------------------------------------

    DbSelectArea('ZCA')
    ZCA -> (DbGoTop())

            while ZCA->(!EoF())
                if ZCA -> (ZCA_TIPO) == 'I'
                    if Empty(ZCA->(ZCA_COD)) 
                        RecLock(cAliasTemp,.T.)
                            (cAliasTemp)->COD_I := '000001'
                        (cAliasTemp)->(MSUNLOCK())
                    else
                    RecLock(cAliasTemp,.T.)
                        (cAliasTemp)->COD_I := ZCA->ZCA_COD
                    (cAliasTemp)->(MSUNLOCK())
                    endif
                ELSEIF ZCA -> (ZCA_TIPO) == 'E'
                    if Empty(ZCA->(ZCA_COD)) 
                        RecLock(cAliasTemp,.T.)
                            (cAliasTemp)->COD_E := '000001'
                        (cAliasTemp)->(MSUNLOCK())
                    else
                    RecLock(cAliasTemp,.T.)
                        (cAliasTemp)->COD_E := ZCA -> ZCA_COD
                    (cAliasTemp)->(MSUNLOCK())
                    endif
                ELSEIF ZCA -> (ZCA_TIPO) == 'R'
                    if Empty(ZCA->(ZCA_COD)) 
                        RecLock(cAliasTemp,.T.)
                            (cAliasTemp)->COD_R := '000001'
                        (cAliasTemp)->(MSUNLOCK())
                    else
                    RecLock(cAliasTemp,.T.)
                        (cAliasTemp)->COD_R := ZCA -> ZCA_COD
                    (cAliasTemp)->(MSUNLOCK())
                    endif
                ELSEIF ZCA -> (ZCA_TIPO) == 'L'
                    if Empty(ZCA->(ZCA_COD)) 
                        RecLock(cAliasTemp,.T.)
                            (cAliasTemp)->COD_L := '000001'
                        (cAliasTemp)->(MSUNLOCK())
                    else
                    RecLock(cAliasTemp,.T.)
                        (cAliasTemp)->COD_L := ZCA -> ZCA_COD
                    (cAliasTemp)->(MSUNLOCK())
                    endif
                ENDIF
                ZCA->(DbSkip())
            EndDo
    ZCA -> (DbCloseArea())

// -------------------------------------------------------------------------------
// 
//              SQL GERACODIGO IMPRESSORA - GABRIEL
// 
// -------------------------------------------------------------------------------

            if oCombo3:Nat == 2
                DbSelectArea(cAliasTemp)

                cQry := 'SELECT MAX(COD_I) AS CCOD FROM ' + cTableName 

                    TCQUERY cQry NEW ALIAS "QRYG_ZCA"

                    cNumG := SOMA1(QRYG_ZCA -> CCOD) 
                    cTira := strTran(cNumg, '', "0")

                    QRYG_ZCA -> (DbCloseArea())
                (cAliasTemp) -> (DbCloseArea())   

// -------------------------------------------------------------------------------
// 
//              SQL GERACODIGO ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------

            elseif oCombo3:Nat == 3
                DbSelectArea(cAliasTemp)

                cQry := 'SELECT MAX(COD_E) AS CCOD FROM ' + cTableName

                    TCQUERY cQry NEW ALIAS "QRYG_ZCA"

                    cNumG := SOMA1(QRYG_ZCA -> CCOD) 
                    cTira := strTran(cNumg, '', "0")

                    QRYG_ZCA -> (DbCloseArea())
                (cAliasTemp) -> (DbCloseArea())


// -------------------------------------------------------------------------------
// 
//              SQL GERACODIGO ROLO - GABRIEL
// 
// -------------------------------------------------------------------------------
            elseif oCombo3:Nat == 4
                DbSelectArea(cAliasTemp)

                cQry := 'SELECT MAX(COD_R) AS CCOD FROM ' + cTableName

                    TCQUERY cQry NEW ALIAS "QRYG_ZCA"

                    cNumG := SOMA1(QRYG_ZCA -> CCOD)    
                    cTira := strTran(cNumg, '', "0")

                    QRYG_ZCA -> (DbCloseArea())
                (cAliasTemp) -> (DbCloseArea())   

// -------------------------------------------------------------------------------
// 
//              BOTÃO CADASTRO LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------
            elseif oCombo3:Nat == 5
                DbSelectArea(cAliasTemp)

                cQry := 'SELECT MAX(COD_L) AS CCOD FROM ' + cTableName

                    TCQUERY cQry NEW ALIAS "QRYG_ZCA"

                    cNumG := SOMA1(QRYG_ZCA -> CCOD) 
                    cTira := strTran(cNumg, '', "0")

                    QRYG_ZCA -> (DbCloseArea())
                (cAliasTemp) -> (DbCloseArea())   

            endif 

    oTempTable:Delete()

    cGet2TT := cTira

    FWRestArea(aArea)
return 

// -------------------------------------------------------------------------------
// 
//              ALTERAÇÃO GERAL - GABRIEL
// 
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------


User Function RLLP23ALT()

    Local aArea         := FWGetArea()
    Local aFields       := {}
    // Local nReg          := 0
    Local oTableTempAlt 
    Local cAliasTempAlt := GetNextAlias()
    Local cNameTable    := ''
    Private aDados      := {}

    Private aCombo5AA   := {'S=SIM','N=NAO'}

// -------------------------------------------------------------------------------
// 
//              ALTERAÇÃO DE IMPRESSORAS/ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------

    If ZCA -> (ZCA_TIPO) == 'I' .OR. ZCA -> (ZCA_TIPO) ==  'E'
    
        oTableTempAlt  := FWTemporaryTable():New(cAliasTempAlt)

        AADD(aFields,{'COD_ALL'    , "C", 6, 0})
        AADD(aFields,{'COD_ALT'    , "C", 6, 0})
        AADD(aFields,{'DESC_ALT'   , "C", 50, 0})
        AADD(aFields,{'ATIVO_ALT'  , "C", 1, 0})
        AADD(aFields,{'TIPO_ALT'   , "C", 1, 0})
        AADD(aFields,{'DATA_ALT'   , "D", 8, 0})
        AADD(aFields,{'ATIVO_NAT'  , "C", 1, 0})

        oTableTempAlt:SetFields(aFields)
        oTableTempAlt:AddIndex('1',{'COD_ALL','COD_ALT'})

        oTableTempAlt:Create()

        cNameTable := oTableTempAlt:GetRealName()

        DbSelectArea('ZCA')

            RecLock(cAliasTempAlt, .T.)
                (cAliasTempAlt) -> (COD_ALT)   := ZCA -> (ZCA_COD)
                (cAliasTempAlt) -> (DESC_ALT)  := ZCA -> (ZCA_DESC)
                (cAliasTempAlt) -> (TIPO_ALT)  := ZCA -> (ZCA_TIPO)
                (cAliasTempAlt) -> (ATIVO_ALT) := ZCA -> (ZCA_ATIVO)
                (cAliasTempAlt) -> (DATA_ALT)  := ZCA -> (ZCA_DATA)

                if (cAliasTempAlt) -> (ATIVO_ALT) == 'S'
                    (cAliasTempAlt) -> (ATIVO_NAT)  := "1"
                    aCombo5AA := {'S=SIM','N=NAO'}
                elseif (cAliasTempAlt) -> (ATIVO_ALT) == 'N'
                    (cAliasTempAlt) -> (ATIVO_NAT)  := "1"
                    aCombo5AA := {'N=NAO','S=SIM'}
                endif

            (cAliasTempAlt) -> (MSUNLOCK())

        
        AADD(aDados,{(cAliasTempAlt) -> (COD_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DESC_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (TIPO_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (ATIVO_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DTOC(DATA_ALT))})
        AADD(aDados,{(cAliasTempAlt) -> (ATIVO_NAT)})

        oTableTempAlt:Delete()

        dialogAlt(aDados)

// -------------------------------------------------------------------------------
// 
//              ALTERAÇÃO DE ROLOS - GABRIEL
// 
// -------------------------------------------------------------------------------
    
    ELSEIF ZCA->(ZCA_TIPO) == 'R'

    oTableTempAlt  := FWTemporaryTable():New(cAliasTempAlt)

        AADD(aFields,{'COD_ALL'   , "C", 6 , 0})
        AADD(aFields,{'COD_ALT'   , "C", 6 , 0})
        AADD(aFields,{'DESC_ALT'  , "C", 50, 0})
        AADD(aFields,{'ATIVO_alt' , "C", 1 , 0})
        AADD(aFields,{'TIPO_ALT'  , "C", 1 , 0})
        AADD(aFields,{'DATA_ALT'  , "D", 8 , 0})
        AADD(aFields,{'ATIVO_NAT' , "C", 1 , 0})
        AADD(aFields,{'NOMERL_ALT', "C", 50, 0})
        AADD(aFields,{'DIAMRL_ALT', "C", 8 , 0})
        AADD(aFields,{'COMPRL_ALT', "C", 4 , 0})
        AADD(aFields,{'MATRL_ALT' , "C", 50, 0})
        AADD(aFields,{'DURERL_ALT', "C", 50, 0})

        oTableTempAlt:SetFields(aFields)
        oTableTempAlt:AddIndex('1',{'COD_ALL','COD_ALT'})

        oTableTempAlt:Create()

        cNameTable := oTableTempAlt:GetRealName()

        DbSelectArea('ZCA')

            RecLock(cAliasTempAlt, .T.)
                (cAliasTempAlt) -> (COD_ALT)   := ZCA -> (ZCA_COD)
                (cAliasTempAlt) -> (DESC_ALT)  := ZCA -> (ZCA_DESC)
                (cAliasTempAlt) -> (TIPO_ALT)  := ZCA -> (ZCA_TIPO)
                (cAliasTempAlt) -> (ATIVO_ALT) := ZCA -> (ZCA_ATIVO)
                (cAliasTempAlt) -> (DATA_ALT)  := ZCA -> (ZCA_DATA)
                if (cAliasTempAlt) -> (ATIVO_ALT) == 'S'
                    (cAliasTempAlt) -> (ATIVO_NAT)  := "1"
                    aCombo5AA := {'S=SIM','N=NAO'}
                elseif (cAliasTempAlt) -> (ATIVO_ALT) == 'N'
                    (cAliasTempAlt) -> (ATIVO_NAT)  := "1"
                    aCombo5AA := {'N=NAO','S=SIM'}
                endif
                (cAliasTempAlt) -> (NOMERL_ALT)  := ZCA -> (ZCA_NOMERL)
                (cAliasTempAlt) -> (DIAMRL_ALT)  := ZCA -> (ZCA_DIAMRL)
                (cAliasTempAlt) -> (COMPRL_ALT)  := ZCA -> (ZCA_COMPRL)
                (cAliasTempAlt) -> (MATRL_ALT)  := ZCA -> (ZCA_MATRL)
                (cAliasTempAlt) -> (DURERL_ALT)  := ZCA -> (ZCA_DURERL)
                
            (cAliasTempAlt) -> (MSUNLOCK())


        AADD(aDados,{(cAliasTempAlt) -> (COD_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DESC_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (TIPO_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (ATIVO_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DTOC(DATA_ALT))})
        AADD(aDados,{(cAliasTempAlt) -> (Alltrim(ATIVO_NAT))})
        AADD(aDados,{(cAliasTempAlt) -> (NOMERL_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DIAMRL_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (COMPRL_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (MATRL_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DURERL_ALT)})

        oTableTempAlt:Delete()

        dialogAlt(aDados)

// -------------------------------------------------------------------------------
// 
//              ALTERAÇÃO DE LAMPADAS- GABRIEL
// 
// -------------------------------------------------------------------------------

    ELSEIF ZCA->(ZCA_TIPO) == 'L'

    oTableTempAlt  := FWTemporaryTable():New(cAliasTempAlt)

        AADD(aFields,{'COD_ALL'   , "C", 6 , 0})
        AADD(aFields,{'COD_ALT'   , "C", 6 , 0})
        AADD(aFields,{'DESC_ALT'  , "C", 50, 0})
        AADD(aFields,{'ATIVO_ALT' , "C", 1 , 0})
        AADD(aFields,{'TIPO_ALT'  , "C", 1 , 0})
        AADD(aFields,{'DATA_ALT'  , "D", 8 , 0})
        AADD(aFields,{'ATIVO_NAT' , "C", 1 , 0})
        AADD(aFields,{'NOMELP_ALT', "C", 50, 0})
        AADD(aFields,{'IMPRES_ALT', "C", 8 , 0})
        AADD(aFields,{'MODLP_ALT' , "C", 50 , 0})
        AADD(aFields,{'TENS_ALT'  , "C", 6 , 0})
        AADD(aFields,{'CORR_ALT'  , "C", 7 , 0})
        AADD(aFields,{'POT_ALT'   , "C", 4 , 0})
        AADD(aFields,{'MODREF_ALT', "C", 50, 0})
        oTableTempAlt:SetFields(aFields)
        oTableTempAlt:AddIndex('1',{'COD_ALL','COD_ALT'})

        oTableTempAlt:Create()

        cNameTable := oTableTempAlt:GetRealName()

        DbSelectArea('ZCA')

            RecLock(cAliasTempAlt, .T.)
                (cAliasTempAlt) -> (COD_ALT)   := ZCA -> (ZCA_COD)
                (cAliasTempAlt) -> (DESC_ALT)  := ZCA -> (ZCA_DESC)
                (cAliasTempAlt) -> (TIPO_ALT)  := ZCA -> (ZCA_TIPO)
                (cAliasTempAlt) -> (ATIVO_ALT) := ZCA -> (ZCA_ATIVO)
                (cAliasTempAlt) -> (DATA_ALT)  := ZCA -> (ZCA_DATA)
                if (cAliasTempAlt) -> (ATIVO_ALT) == 'S'
                    (cAliasTempAlt) -> (ATIVO_NAT)  := "1"
                    aCombo5AA := {'S=SIM','N=NAO'}
                elseif (cAliasTempAlt) -> (ATIVO_ALT) == 'N'
                    (cAliasTempAlt) -> (ATIVO_NAT)  := "1"
                    aCombo5AA := {'N=NAO','S=SIM'}
                endif
                (cAliasTempAlt) -> (NOMELP_ALT)  := ZCA -> (ZCA_NOMELP)
                (cAliasTempAlt) -> (IMPRES_ALT)  := ZCA -> (ZCA_IMPLP)
                (cAliasTempAlt) -> (MODLP_ALT)   := ZCA -> (ZCA_MODLP)
                (cAliasTempAlt) -> (TENS_ALT)    := ZCA -> (ZCA_TENSLP)
                (cAliasTempAlt) -> (CORR_ALT)    := ZCA -> (ZCA_CORRLP)
                (cAliasTempAlt) -> (POT_ALT)     := ZCA -> (ZCA_POTLP)
                (cAliasTempAlt) -> (MODREF_ALT)  := ZCA -> (ZCA_MODREF)
                
            (cAliasTempAlt) -> (MSUNLOCK())


        AADD(aDados,{(cAliasTempAlt) -> (COD_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DESC_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (TIPO_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (ATIVO_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (DTOC(DATA_ALT))})
        AADD(aDados,{(cAliasTempAlt) -> (Alltrim(ATIVO_NAT))})
        AADD(aDados,{(cAliasTempAlt) -> (NOMELP_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (IMPRES_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (MODLP_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (TENS_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (CORR_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (POT_ALT)})
        AADD(aDados,{(cAliasTempAlt) -> (MODREF_ALT)})

        oTableTempAlt:Delete()

        dialogAlt(aDados)
    
    ENDIF

    FWRestArea(aArea)

return (aDados)

static Function dialogAlt(aDados)

    Local aArea := FwGetArea()
    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''


    Private oDlgAlt

    Private oSay1A
    Private cSay1AA     := "CADASTRO DE IMPRESSORA - INCLUSÃO"
    Private oBtn1A
    Private cBtn1AA     := 'Fechar'
    Private oBtn2A
    Private cBtn2AA     := 'Alterar'

    Private oSay2A
    Private cSay2AA     := 'Código'
    Private oGet2A
    Private xGet2AA     

    Private oSay3A
    Private cSay3AA     := 'Descrição'
    Private oGet3A
    Private xGet3AA     

    Private oSay4A
    Private cSay4AA     := 'Tipo' 
    Private cEscolha 
    Private oGet4A
    Private xGet4AA     

    Private oSay5A
    Private cSay5AA     := 'Ativo'
    Private oCombo5A
    Private cCombo5AAA 

    Private oSay6A
    Private cSay6AA     := 'Data'
    Private oGet6A
    Private xGet6AA     

    Private oGrp7A
    Private oGrp8A

    Private oSay9A
    Private cSay9AA     := 'Nome Rolo'
    Private oGet9A
    Private xGet9AA     

    Private oSay10A
    Private cSay10AA    := 'Diametro Rolo'
    Private oGet10A
    Private xGet10AA   

    Private oSay11A
    Private cSay11AA    := 'Comp.Rolo'
    Private oGet11A
    Private xGet11AA   

    Private oSay12A
    Private cSay12AA    := 'Material Rolo'
    Private oGet12A
    Private xGet12AA   

    Private oSay13A
    Private cSay13AA    := 'Dureza Rolo'
    Private oGet13A
    Private xGet13AA  

    Private oSay14A
    Private cSay14AA    := 'Nome Lampada'
    Private oGet14A
    Private xGet14AA    

    Private oSay15A
    Private cSay15AA    := 'Impressoras'
    Private oGet15A
    Private cGet15AA         

    Private oSay16A
    Private cSay16AA    := 'Modelo Lampada'
    Private oGet16A
    Private xGet16AA    

    Private oSay17A
    Private cSay17AA    := 'Tensão'
    Private oGet17A
    Private xGet17AA    

    Private oSay18A
    Private cSay18AA    := 'Corrente'
    Private oGet18A
    Private xGet18AA   

    Private oSay19A
    Private cSay19AA    := 'Potencia'
    Private oGet19A
    Private xGet19AA    

    Private oSay20A
    Private cSay20AA    := 'Modelo Refletor'
    Private oGet20A
    Private xGet20AA    

    nEscBD := 1

// -------------------------------------------------------------------------------
// 
//           TELA ATERAÇÃO IMPRESSORA/ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------
        
    If ZCA -> (ZCA_TIPO) == 'I' .OR. ZCA -> (ZCA_TIPO) ==  'E'

    nEsc := 4

        cJanTitulo := 'Alteração de Impressora'
        oDlgAlt := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 270 
        oGrp7A := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgAlt, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
        If ZCA -> (ZCA_TIPO) == 'I'
            cSay1AA  := "ALTERAÇÃO DE ITEM - IMPRESSORAS"
        ELSEIF  ZCA -> (ZCA_TIPO) ==  'E'
            cSay1AA  := "ALTERAÇÃO DE ITEM - ESTAÇÃO"
        ENDIF
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1A   := TSay():New(nObjLinh, nObjColu, {|| cSay1AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1A   := TButton():New(nObjLinh, nObjColu, cBtn1AA, oDlgAlt,{|| oDlgAlt:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2A := TButton():New(nObjLinh, nObjColu, cBtn2AA, oDlgAlt,{|| altBtn()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2A   := TSay():New(nObjLinh, nObjColu, {|| cSay2AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2AA := aDados[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2A   := TGet():New(nObjLinh, nObjColu, {|| xGet2AA}, oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 80
        nObjAltu := 20
        oSay3A   := TSay():New(nObjLinh, nObjColu, {|| cSay3AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3A:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        If ZCA -> (ZCA_TIPO) == 'I'
            cSay3AA  := "Descrição"
        ELSEIF  ZCA -> (ZCA_TIPO) ==  'E'
            cSay3AA  := "Nome Estação"
        ENDIF
        xGet3AA := aDados[2][1]
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3AA := u, xGet3AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4A   := TSay():New(nObjLinh, nObjColu, {|| cSay4AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4AA := aDados[3][1]
        if ZCA->(ZCA_TIPO) == 'I'
            cEscolha := 'I = IMPRESSORA'
        elseif ZCA -> (ZCA_TIPO) == 'E'
            cEscolha := 'E = ESTACAO'
        endif
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4A   := TGet():New(nObjLinh, nObjColu,{|| cEscolha} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5A := TSay():New(nObjLinh, nObjColu, {|| cSay5AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo5AAA  := aDados[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5A := TComboBox():New(nObjLinh, nObjColu,, aCombo5AA, nObjLarg, nObjAltu,oDlgAlt,,{||cCombo5AAA},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao,,,,,,,,,)
        
        // CRIAÇÃO DO OBJETO 6
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6A := TSay():New(nObjLinh, nObjColu, {|| cSay6AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6AA  := aDados[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6A := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6AA := u, xGet6AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet6A:lActive := .F.

        //Criação do Objetos 08
        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 325  
        oGrp8A := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,, oDlgAlt, , , lDimPixels)

        oDlgAlt:Activate()

// -------------------------------------------------------------------------------
// 
//           TELA ALTERAÇÃO ROLOS - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseif ZCA->(ZCA_TIPO) == 'R'

    nEsc := 4

    oDlgAlt := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7A := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgAlt, , , lDimPixels)

        //Criação do Objetos 07
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1A   := TSay():New(nObjLinh, nObjColu, {|| cSay1AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1A   := TButton():New(nObjLinh, nObjColu, cBtn1AA, oDlgAlt,{|| oDlgAlt:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2A := TButton():New(nObjLinh, nObjColu, cBtn2AA, oDlgAlt,{|| altBtn()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2A   := TSay():New(nObjLinh, nObjColu, {|| cSay2AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2AA := aDados[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2A   := TGet():New(nObjLinh, nObjColu, {|| xGet2AA}, oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3A   := TSay():New(nObjLinh, nObjColu, {|| cSay3AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3A:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        xGet3AA := aDados[2][1]
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3AA := u, xGet3AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4A   := TSay():New(nObjLinh, nObjColu, {|| cSay4AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4AA := aDados[3][1]
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4A   := TGet():New(nObjLinh, nObjColu,{|| 'R = ROLO'} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5A := TSay():New(nObjLinh, nObjColu, {|| cSay5AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo5AAA  := aDados[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5A := TComboBox():New(nObjLinh, nObjColu,, aCombo5AA, nObjLarg, nObjAltu,oDlgAlt,,{||cCombo5AAA},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels, oFontPadrao,,,,,,,,,)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6A := TSay():New(nObjLinh, nObjColu, {|| cSay6AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6AA  := aDados[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6A := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6AA := u, xGet6AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet6A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay9T   := TSay():New(nObjLinh, nObjColu, {|| cSay9AA}, oDlgAlt,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet9AA := aDados[7][1]
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet9A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet9AA := u, xGet9AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 30
        nObjAltu := 20
        oSay10A  := TSay():New(nObjLinh, nObjColu, {|| cSay10AA}, oDlgAlt,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet10AA := aDados[8][1]
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 30
        nObjAltu := 15
        oGet10A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet10AA := u, xGet10AA)} , oDlgAlt, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 190
        nObjLarg := 50
        nObjAltu := 20
        oSay11A   := TSay():New(nObjLinh, nObjColu, {|| cSay11AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet11AA := aDados[9][1]
        nObjLinh := 125
        nObjColu := 190
        nObjLarg := 50
        nObjAltu := 15
        oGet11A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet11AA := u, xGet11AA)} , oDlgAlt, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 255
        nObjLarg := 80
        nObjAltu := 20
        oSay12A   := TSay():New(nObjLinh, nObjColu, {|| cSay12AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet12AA := aDados[10][1]
        nObjLinh := 125
        nObjColu := 255
        nObjLarg := 80
        nObjAltu := 15
        oGet12A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet12AA := u, xGet12AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 350
        nObjLarg := 80
        nObjAltu := 20
        oSay13A   := TSay():New(nObjLinh, nObjColu, {|| cSay13AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay13A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet13AA := aDados[11][1]
        nObjLinh := 125
        nObjColu := 350
        nObjLarg := 80
        nObjAltu := 15
        oGet13A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet13AA := u, xGet13AA)} , oDlgAlt, nObjLarg, nObjAltu, '@!', /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 270  
        oGrp8A := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,, oDlgAlt, , , lDimPixels)

        oDlgAlt:Activate()

// -------------------------------------------------------------------------------
// 
//           TELA ALTERAÇÃO LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseif ZCA->(ZCA_TIPO) == 'L'

        nEsc := 4

        cJanTitulo := 'Cadastro de Lampadas'
        oDlgAlt := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7A := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgAlt, , , lDimPixels)

        // Criação objetos 01
        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1TT  := 'Cadastro de Item - LAMPADAS'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1A := TSay():New(nObjLinh, nObjColu, {|| cSay1AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1A   := TButton():New(nObjLinh, nObjColu, cBtn1AA, oDlgAlt,{|| oDlgAlt:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2A   := TButton():New(nObjLinh, nObjColu, cBtn2AA, oDlgAlt,{|| altBtn()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8A    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgAlt, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2T   := TSay():New(nObjLinh, nObjColu, {|| cSay2AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2T:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2AA := aDados[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2A   := TGet():New(nObjLinh, nObjColu, {|| xGet2AA}, oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3A   := TSay():New(nObjLinh, nObjColu, {|| cSay3AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3A:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        xGet3AA := aDados[2][1]
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3AA := u, xGet3AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4A   := TSay():New(nObjLinh, nObjColu, {|| cSay4AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4AA := aDados[3][1]
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4A   := TGet():New(nObjLinh, nObjColu,{|| 'L = LAMPADA'} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)
    
        oGet4A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5A := TSay():New(nObjLinh, nObjColu, {|| cSay5AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo5AAA  := aDados[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5A := TComboBox():New(nObjLinh, nObjColu,, aCombo5AA, nObjLarg, nObjAltu,oDlgAlt,,{||cCombo5AAA},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao,,,,,,,,,)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6A := TSay():New(nObjLinh, nObjColu, {|| cSay6AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6AA  := aDados[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6A := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6AA := u, xGet6AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet6A:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay14A   := TSay():New(nObjLinh, nObjColu, {|| cSay14AA}, oDlgAlt,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay14A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet14AA  := aDados[7][1]
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet14A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet14AA := u, xGet14AA)} , oDlgAlt, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu := 20
        oSay15A   := TSay():New(nObjLinh, nObjColu, {|| cSay15AA}, oDlgAlt,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu)  
        oSay15A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cGet15AA  := aDados[8][1]
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        lHasButton := .T. 
        oGet15A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet15AA := u, cGet15AA)} , oDlgAlt, nObjLarg, nObjAltu,,, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet15A:cF3 := 'U_zConsImp()' //puxar função que ira fazer a consulta especifica
        oGet15A:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay16A   := TSay():New(nObjLinh, nObjColu, {|| cSay16AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay16A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet16AA  := aDados[9][1]
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet16A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet16AA := u, xGet16AA)} , oDlgAlt, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 50
        nObjAltu := 20
        oSay17A   := TSay():New(nObjLinh, nObjColu, {|| cSay17AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay17A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet17AA  := aDados[10][1]
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 30
        nObjAltu := 15
        oGet17A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet17AA := u, xGet17AA)} , oDlgAlt, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 380
        nObjLarg := 50
        nObjAltu := 20
        oSay18A   := TSay():New(nObjLinh, nObjColu, {|| cSay18AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay18A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet18AA  := aDados[11][1]
        nObjLinh := 125
        nObjColu := 380
        nObjLarg := 30
        nObjAltu := 15
        oGet18A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet18AA := u, xGet18AA)} , oDlgAlt, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oSay19A   := TSay():New(nObjLinh, nObjColu, {|| cSay19AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay19A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet19AA  := aDados[12][1]
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 30
        nObjAltu := 15
        oGet19A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet19AA := u, xGet19AA)} , oDlgAlt, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

         oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 485
        nObjLarg := 50
        nObjAltu := 20
        oSay20A   := TSay():New(nObjLinh, nObjColu, {|| cSay20AA}, oDlgAlt,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay20A:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet20AA  := aDados[13][1]
        nObjLinh := 125
        nObjColu := 485
        nObjLarg := 80
        nObjAltu := 15
        oGet20A   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet20AA := u, xGet20AA)} , oDlgAlt, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oDlgAlt:Activate()
        
        ENDIF

   FWRestArea(aArea)
Return

static function altBtn()

    Local aArea := FWGetArea()
    Local cAlias := 'ZCA'

// -------------------------------------------------------------------------------
// 
//           BOTÃO DE ALTERAÇÃO IMPRESSORA/ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------   
    

     if ZCA ->(ZCA_TIPO) == 'I' .OR. ZCA ->(ZCA_TIPO) == 'E'
    lEscolha := MsgYesNo('DESEJA ALTERAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            DbSelectArea(cAlias)

            if (oGet3A:BUFFER == aDados[2][1]) .AND. (oCombo5A:Nat == 0 .OR. oCombo5A:Nat == Val(aDados[6][1])) 
                ALERT('VOCE NÃO MUDOU NADA NOS CAMPOS!!','ATENÇÃO')
                elseif Empty(oGet3A:BUFFER)
                ALERT('HÁ CAMPOS SEM NADA ESCRITO!!','ATENÇÃO')
                else
                begin transaction 
                RecLock(cAlias, .F.)
                    ZCA->ZCA_COD   := Alltrim(oGet2A:BUFFER)
                    ZCA->ZCA_DESC  := Alltrim(oGet3A:BUFFER)
                    ZCA->ZCA_TIPO  := Alltrim(oGet4A:BUFFER)
                    if oCombo5A:NAT == 1 .OR. oCombo5A:NAT == 0
                        ZCA->ZCA_ATIVO := oCombo5A:AITEMS[1]
                    elseif oCombo5A:NAT == 2
                        ZCA->ZCA_ATIVO := oCombo5A:AITEMS[2]
                    ENDIF
                    ZCA->ZCA_DATA  := CTOD(oGet6A:BUFFER)
                ZCA -> (MSUNLOCK())
                end transaction
                MsgInfo('ALTERAÇÃO FEITA COM SUCESSO!!','ATENÇÃO')
                lEsc := MsgYesNo('Deseja Ir para o Menu Principal?(YES/NO)')
                if lEsc == .T.
                    oDlgAlt:End()
                else
                    oGet3A:lActive   := .F.
                    oCombo5A:lActive := .F.
                    oBtn2A:lActive   := .F.

                endif
            endif
        else
            MsgInfo('NENHUMA ALTERAÇÃO EFETUADA')
        ENDIF

// -------------------------------------------------------------------------------
// 
//           BOTÃO DE ALTERAÇÃO ROLOS - GABRIEL
// 
// -------------------------------------------------------------------------------  
    DbSelectArea(cAlias)

    ELSEIF ZCA->(ZCA_TIPO) == 'R' 
    lEscolha := MsgYesNo('DESEJA  ALTERAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            DbSelectArea(cAlias)

            if (oGet3A:BUFFER == aDados[2][1]) .AND. (oCombo5A:Nat == 0 .OR. oCombo5A:Nat == Val(aDados[6][1])) .AND. (oGet9A:BUFFER == aDados[7][1]) .AND. (oGet10A:BUFFER == aDados[8][1]) .AND. (oGet11A:BUFFER == aDados[9][1]) .AND. (oGet12A:BUFFER == aDados[10][1]) .AND. (oGet13A:BUFFER == aDados[11][1])
                ALERT('VOCE NÃO MUDOU NADA NOS CAMPOS!!','ATENÇÃO')
            ELSEIF Empty(oGet3A:BUFFER) .OR. Empty(oGet9A:BUFFER) .OR. Empty(oGet10A:BUFFER) .OR. Empty(oGet11A:BUFFER) .OR. Empty(oGet12A:BUFFER) .OR. Empty(oGet13A:BUFFER)
                Alert('HÁ CAMPOS SEM NADA ESCRITO!!')
            ELSEIF IsAlpha(oGet10A:BUFFER) .OR. IsAlpha(oGet11A:BUFFER)
                Alert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS!!')
            else
            begin transaction 
            RecLock(cAlias, .F.)
                ZCA->ZCA_COD   := Alltrim(oGet2A:BUFFER)
                ZCA->ZCA_DESC  := Alltrim(oGet3A:BUFFER)
                ZCA->ZCA_TIPO  := Alltrim(oGet4A:BUFFER)
                if oCombo5A:NAT == 1 .OR. oCombo5A:NAT == 0
                    ZCA->ZCA_ATIVO := oCombo5A:AITEMS[1]
                elseif oCombo5A:NAT == 2
                    ZCA->ZCA_ATIVO := oCombo5A:AITEMS[2]
                ENDIF
                ZCA->ZCA_DATA    := CTOD(oGet6A:BUFFER)
                ZCA->ZCA_NOMERL  := Alltrim(oGet9A:BUFFER)
                ZCA->ZCA_DIAMRL  := Alltrim(oGet10A:BUFFER)
                ZCA->ZCA_COMPRL  := Alltrim(oGet11A:BUFFER)
                ZCA->ZCA_MATRL   := Alltrim(oGet12A:BUFFER)
                ZCA->ZCA_DURERL  := Alltrim(oGet13A:BUFFER)
            ZCA -> (MSUNLOCK())
            end transaction
            MsgInfo('CADASTRO FEITO COM SUCESSO!!','ATENÇÃO')
            lEsc := MsgYesNo('Deseja Ir para o Menu Principal?(YES/NO)')
                if lEsc == .T.
                    oDlgAlt:End()
                else
                    oGet3A:lActive    := .F.
                    oCombo5A:lActive  := .F.
                    oBtn2A:lActive    := .F.
                    oGet9A:lActive    := .F.
                    oGet10A:lActive   := .F.
                    oGet11A:lActive   := .F.
                    oGet12A:lActive   := .F.
                    oGet13A:lActive   := .F.
            endif
            endif
        else
            MsgInfo('NENHUMA ALTERAÇÃO EFETUADA')
        ENDIF

// -------------------------------------------------------------------------------
// 
//           BOTÃO DE ALTERAÇÃO LAMPADAS - GABRIEL
// 
// ------------------------------------------------------------------------------- 

    DbSelectArea(cAlias)

    ELSEIF ZCA->(ZCA_TIPO) == 'L' 

     lEscolha := MsgYesNo('DESEJA  ALTERAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            DbSelectArea(cAlias)

            if (oGet3A:BUFFER == aDados[2][1]) .AND. (oCombo5A:Nat == 0 .OR. oCombo5A:Nat == Val(aDados[6][1])) .AND. (oGet14A:BUFFER == aDados[7][1]) .AND. (oGet15A:BUFFER == aDados[8][1]) .AND. (oGet16A:BUFFER == aDados[9][1]) .AND. (oGet17A:BUFFER == aDados[10][1]) .AND. (oGet18A:BUFFER == aDados[11][1]) .AND. (oGet19A:BUFFER == aDados[12][1]) .AND. (oGet20A:BUFFER == aDados[13][1])
                ALERT('VOCE NÃO MUDOU NADA NOS CAMPOS!!','ATENÇÃO')
            ELSEIF Empty(oGet3A:BUFFER) .OR. Empty(oGet14A:BUFFER) .OR. Empty(oGet15A:BUFFER) .OR. Empty(oGet16A:BUFFER) .OR. Empty(oGet17A:BUFFER) .OR. Empty(oGet18A:BUFFER) .OR. Empty(oGet19A:BUFFER) .OR. Empty(oGet20A:BUFFER)
                Alert('HÁ CAMPOS SEM NADA ESCRITO!!')
            ELSEIF IsAlpha(oGet17A:BUFFER) .OR. IsAlpha(oGet18A:BUFFER) .OR. IsAlpha(oGet19A:BUFFER)
                Alert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS!!')
            else
            begin transaction 
            RecLock(cAlias, .F.)
                ZCA->ZCA_COD   := Alltrim(oGet2A:BUFFER)
                ZCA->ZCA_DESC  := Alltrim(oGet3A:BUFFER)
                ZCA->ZCA_TIPO  := Alltrim(oGet4A:BUFFER)
                if oCombo5A:NAT == 1 .OR. oCombo5A:NAT == 0
                    ZCA->ZCA_ATIVO := oCombo5A:AITEMS[1]
                elseif oCombo5A:NAT == 2
                    ZCA->ZCA_ATIVO := oCombo5A:AITEMS[2]
                ENDIF
                ZCA->ZCA_DATA    := CTOD(oGet6A:BUFFER)
                ZCA->ZCA_NOMELP  := Alltrim(oGet14A:BUFFER)
                ZCA->ZCA_IMPLP   := Alltrim(oGet15A:BUFFER)
                ZCA->ZCA_MODLP   := Alltrim(oGet16A:BUFFER)
                ZCA->ZCA_TENSLP  := Alltrim(oGet17A:BUFFER)
                ZCA->ZCA_CORRLP  := Alltrim(oGet18A:BUFFER)
                ZCA->ZCA_POTLP   := Alltrim(oGet19A:BUFFER)
                ZCA->ZCA_MODREF  := Alltrim(oGet20A:BUFFER)
            ZCA -> (MSUNLOCK())
            end transaction
            MsgInfo('CADASTRO FEITO COM SUCESSO!!','ATENÇÃO')
            lEsc := MsgYesNo('Deseja Ir para o Menu Principal?(YES/NO)')
                if lEsc == .T.
                    oDlgAlt:End()
                else
                    oGet3A:lActive    := .F.
                    oCombo5A:lActive  := .F.
                    oBtn2A:lActive   := .F.
                    oGet14A:lActive   := .F.
                    oGet15A:lActive   := .F.
                    oGet16A:lActive   := .F.
                    oGet17A:lActive   := .F.
                    oGet18A:lActive   := .F.
                    oGet19A:lActive   := .F.
                    oGet20A:lActive   := .F.
            endif
            endif
        else
            MsgInfo('NENHUMA ALTERAÇÃO EFETUADA')
        ENDIF
        
    ENDIF

FWRestArea(aArea)
return

// -------------------------------------------------------------------------------
// 
//              PARTE DE EXCLUSÃO DE ITENS
// 
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
//------------------------------------------------------------------------------- 


User Function RLLP23EXC()
    Local aArea         := FWGetArea()
    Local aFields       := {}
    // Local nReg          := 0
    Local oTableTempExc 
    Local cAliasTempExc := GetNextAlias()
    Local cNameTableExc    := ''
    Private aDadosExc      := {}

    Private aCombo5EE   := {'S=SIM','N=NAO'}

// -------------------------------------------------------------------------------
// 
//              EXCLUSÃO DE IMPRESSORAS/ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------

    If ZCA -> (ZCA_TIPO) == 'I' .OR. ZCA -> (ZCA_TIPO) ==  'E'
    
        oTableTempExc   := FWTemporaryTable():New(cAliasTempExc)

        AADD(aFields,{'COD_ALL'    , "C", 6, 0})
        AADD(aFields,{'COD_EXC'    , "C", 6, 0})
        AADD(aFields,{'DESC_EXC'   , "C", 50, 0})
        AADD(aFields,{'ATIVO_EXC'  , "C", 1, 0})
        AADD(aFields,{'TIPO_EXC'   , "C", 1, 0})
        AADD(aFields,{'DATA_EXC'   , "D", 8, 0})
        AADD(aFields,{'ATIVO_NAT'  , "C", 1, 0})

        oTableTempExc:SetFields(aFields)
        oTableTempExc:AddIndex('1',{'COD_ALL','COD_EXC'})

        oTableTempExc:Create()

        cNameTableExc := oTableTempExc:GetRealName()

        DbSelectArea('ZCA')

            RecLock(cAliasTempAlt, .T.)
                (cAliasTempExc) -> (COD_EXC)   := ZCA -> (ZCA_COD)
                (cAliasTempExc) -> (DESC_EXC)  := ZCA -> (ZCA_DESC)
                (cAliasTempExc) -> (TIPO_EXC)  := ZCA -> (ZCA_TIPO)
                (cAliasTempExc) -> (ATIVO_EXC) := ZCA -> (ZCA_ATIVO)
                (cAliasTempExc) -> (DATA_EXC)  := ZCA -> (ZCA_DATA)

                if (cAliasTempExc) -> (ATIVO_EXC) == 'S'
                    (cAliasTempExc) -> (ATIVO_NAT)  := "1"
                    aCombo5EE := {'S=SIM','N=NAO'}
                elseif (cAliasTempExc) -> (ATIVO_EXC) == 'N'
                    (cAliasTempExc) -> (ATIVO_NAT)  := "1"
                    aCombo5EE := {'N=NAO','S=SIM'}
                endif

            (cAliasTempAlt) -> (MSUNLOCK())

        
        AADD(aDadosExc,{(cAliasTempExc) -> (COD_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DESC_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (TIPO_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (ATIVO_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DTOC(DATA_EXC))})
        AADD(aDadosExc,{(cAliasTempExc) -> (ATIVO_NAT)})

        oTableTempExc:Delete()

        dialogEXC(aDadosExc)

// -------------------------------------------------------------------------------
// 
//              EXCLUSÃO DE ROLO - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseIf ZCA -> (ZCA_TIPO) == 'R' 
    
        oTableTempExc  := FWTemporaryTable():New(cAliasTempExc)

        AADD(aFields,{'COD_ALL'    , "C", 6, 0})
        AADD(aFields,{'COD_EXC'    , "C", 6, 0})
        AADD(aFields,{'DESC_EXC'   , "C", 50, 0})
        AADD(aFields,{'ATIVO_EXC'  , "C", 1, 0})
        AADD(aFields,{'TIPO_EXC'   , "C", 1, 0})
        AADD(aFields,{'DATA_EXC'   , "D", 8, 0})
        AADD(aFields,{'ATIVO_NAT'  , "C", 1, 0})
        AADD(aFields,{'NOMERL_EXC', "C", 50, 0})
        AADD(aFields,{'DIAMRL_EXC', "C", 8 , 0})
        AADD(aFields,{'COMPRL_EXC', "C", 4 , 0})
        AADD(aFields,{'MATRL_EXC' , "C", 50, 0})
        AADD(aFields,{'DURERL_EXC', "C", 50, 0})

        oTableTempExc:SetFields(aFields)
        oTableTempExc:AddIndex('1',{'COD_ALL','COD_EXC'})

        oTableTempExc:Create()

        cNameTableExc := oTableTempExc:GetRealName()

        DbSelectArea('ZCA')

            RecLock(cAliasTempAlt, .T.)
                (cAliasTempExc) -> (COD_EXC)   := ZCA -> (ZCA_COD)
                (cAliasTempExc) -> (DESC_EXC)  := ZCA -> (ZCA_DESC)
                (cAliasTempExc) -> (TIPO_EXC)  := ZCA -> (ZCA_TIPO)
                (cAliasTempExc) -> (ATIVO_EXC) := ZCA -> (ZCA_ATIVO)
                (cAliasTempExc) -> (DATA_EXC)  := ZCA -> (ZCA_DATA)

                if (cAliasTempExc) -> (ATIVO_EXC) == 'S'
                    (cAliasTempExc) -> (ATIVO_NAT)  := "1"
                    aCombo5EE := {'S=SIM','N=NAO'}
                elseif (cAliasTempExc) -> (ATIVO_EXC) == 'N'
                    (cAliasTempExc) -> (ATIVO_NAT)  := "1"
                    aCombo5EE := {'N=NAO','S=SIM'}
                endif
                (cAliasTempExc) -> (NOMERL_EXC)  := ZCA -> (ZCA_NOMERL)
                (cAliasTempExc) -> (DIAMRL_EXC)  := ZCA -> (ZCA_DIAMRL)
                (cAliasTempExc) -> (COMPRL_EXC)  := ZCA -> (ZCA_COMPRL)
                (cAliasTempExc) -> (MATRL_EXC)  := ZCA -> (ZCA_MATRL)
                (cAliasTempExc) -> (DURERL_EXC)  := ZCA -> (ZCA_DURERL)

            (cAliasTempExc) -> (MSUNLOCK())

        
        AADD(aDadosExc,{(cAliasTempExc) -> (COD_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DESC_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (TIPO_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (ATIVO_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DTOC(DATA_EXC))})
        AADD(aDadosExc,{(cAliasTempExc) -> (ATIVO_NAT)})
        AADD(aDadosExc,{(cAliasTempExc) -> (NOMERL_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DIAMRL_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (COMPRL_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (MATRL_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DURERL_EXC)})

        oTableTempExc:Delete()

        dialogEXC(aDadosExc)

// -------------------------------------------------------------------------------
// 
//              EXCLUSÃO DE LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------

     elseIf ZCA -> (ZCA_TIPO) == 'L' 
    
        oTableTempExc  := FWTemporaryTable():New(cAliasTempExc)

        AADD(aFields,{'COD_ALL'    , "C", 6, 0})
        AADD(aFields,{'COD_EXC'    , "C", 6, 0})
        AADD(aFields,{'DESC_EXC'   , "C", 50, 0})
        AADD(aFields,{'ATIVO_EXC'  , "C", 1, 0})
        AADD(aFields,{'TIPO_EXC'   , "C", 1, 0})
        AADD(aFields,{'DATA_EXC'   , "D", 8, 0})
        AADD(aFields,{'ATIVO_NAT'  , "C", 1, 0})
        AADD(aFields,{'NOMELP_EXC', "C", 50, 0})
        AADD(aFields,{'IMPRES_EXC', "C", 8 , 0})
        AADD(aFields,{'MODLP_EXC' , "C", 50 , 0})
        AADD(aFields,{'TENS_EXC'  , "C", 6 , 0})
        AADD(aFields,{'CORR_EXC'  , "C", 7 , 0})
        AADD(aFields,{'POT_EXC'   , "C", 4 , 0})
        AADD(aFields,{'MODREF_EXC', "C", 50, 0})

        oTableTempExc:SetFields(aFields)
        oTableTempExc:AddIndex('1',{'COD_ALL','COD_EXC'})

        oTableTempExc:Create()

        cNameTableExc := oTableTempExc:GetRealName()

        DbSelectArea('ZCA')

            RecLock(cAliasTempExc, .T.)
                (cAliasTempExc) -> (COD_EXC)   := ZCA -> (ZCA_COD)
                (cAliasTempExc) -> (DESC_EXC)  := ZCA -> (ZCA_DESC)
                (cAliasTempExc) -> (TIPO_EXC)  := ZCA -> (ZCA_TIPO)
                (cAliasTempExc) -> (ATIVO_EXC) := ZCA -> (ZCA_ATIVO)
                (cAliasTempExc) -> (DATA_EXC)  := ZCA -> (ZCA_DATA)

                if (cAliasTempExc) -> (ATIVO_EXC) == 'S'
                    (cAliasTempExc) -> (ATIVO_NAT)  := "1"
                    aCombo5EE := {'S=SIM','N=NAO'}
                elseif (cAliasTempExc) -> (ATIVO_EXC) == 'N'
                    (cAliasTempExc) -> (ATIVO_NAT)  := "1"
                    aCombo5EE := {'N=NAO','S=SIM'}
                endif
                (cAliasTempExc) -> (NOMELP_EXC)  := ZCA -> (ZCA_NOMELP)
                (cAliasTempExc) -> (IMPRES_EXC)  := ZCA -> (ZCA_IMPLP)
                (cAliasTempExc) -> (MODLP_EXC)   := ZCA -> (ZCA_MODLP)
                (cAliasTempExc) -> (TENS_EXC)    := ZCA -> (ZCA_TENSLP)
                (cAliasTempExc) -> (CORR_EXC)    := ZCA -> (ZCA_CORRLP)
                (cAliasTempExc) -> (POT_EXC)     := ZCA -> (ZCA_POTLP)
                (cAliasTempExc) -> (MODREF_EXC)  := ZCA -> (ZCA_MODREF)

            (cAliasTempExc) -> (MSUNLOCK())

        
        AADD(aDadosExc,{(cAliasTempExc) -> (COD_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DESC_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (TIPO_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (ATIVO_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (DTOC(DATA_EXC))})
        AADD(aDadosExc,{(cAliasTempExc) -> (ATIVO_NAT)})
        AADD(aDadosExc,{(cAliasTempExc) -> (NOMELP_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (IMPRES_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (MODLP_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (TENS_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (CORR_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (POT_EXC)})
        AADD(aDadosExc,{(cAliasTempExc) -> (MODREF_EXC)})

        oTableTempExc:Delete()

        dialogEXC(aDadosExc)

    endif
    FWRestArea(aArea)
return

static function dialogEXC(aDadosExc)

    Local aArea := FwGetArea()

    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''


    Private oDlgExc

    Private oSay1E
    Private cSay1EE     := ""
    Private oBtn1E
    Private cBtn1EE     := 'FECHAR'
    Private oBtn2E
    Private cBtn2EE     := 'EXCLUIR'

    Private oSay2E
    Private cSay2EE     := 'Código'
    Private oGet2E
    Private xGet2EE     

    Private oSay3E
    Private cSay3EE     := 'Descrição'
    Private oGet3E
    Private xGet3EE     

    Private oSay4E
    Private cSay4EE     := 'Tipo' 
    Private cEscolha 
    Private oGet4E
    Private xGet4EE     

    Private oSay5E
    Private cSay5EE     := 'Ativo'
    Private oCombo5E
    Private cCombo5EEE 

    Private oSay6E
    Private cSay6EE     := 'Data'
    Private oGet6E
    Private xGet6EE     

    Private oGrp7E
    Private oGrp8E

    Private oSay9E
    Private cSay9EE     := 'Nome Rolo'
    Private oGet9E
    Private xGet9EE     

    Private oSay10E
    Private cSay10EE    := 'Diametro Rolo'
    Private oGet10E
    Private xGet10EE   

    Private oSay11E
    Private cSay11EE    := 'Comp.Rolo'
    Private oGet11E
    Private xGet11EE   

    Private oSay12E
    Private cSay12EE    := 'Material Rolo'
    Private oGet12E
    Private xGet12EE   

    Private oSay13E
    Private cSay13EE    := 'Dureza Rolo'
    Private oGet13E
    Private xGet13EE  

    Private oSay14E
    Private cSay14EE    := 'Nome Lampada'
    Private oGet14E
    Private xGet14EE    

    Private oSay15E
    Private cSay15EE    := 'Impressoras'
    Private oGet15E
    Private xGet15EE        

    Private oSay16E
    Private cSay16EE    := 'Modelo Lampada'
    Private oGet16E
    Private xGet16EE    

    Private oSay17E
    Private cSay17EE    := 'Tensão'
    Private oGet17E
    Private xGet17EE    

    Private oSay18E
    Private cSay18EE    := 'Corrente'
    Private oGet18E
    Private xGet18EE   

    Private oSay19E
    Private cSay19EE    := 'Potencia'
    Private oGet19E
    Private xGet19EE    

    Private oSay20E
    Private cSay20EE    := 'Modelo Refletor'
    Private oGet20E
    Private xGet20EE    


// -------------------------------------------------------------------------------
// 
//              TELA DE EXCLUSÃO DE IMPRESSORAS/ESTAÇÃO - GABRIEL
// 
// -------------------------------------------------------------------------------

    IF ZCA->(ZCA_TIPO) == 'I' .OR. ZCA->(ZCA_TIPO) == 'E'

    cJanTitulo := 'EXCLUSÃO DE IMPRESSORA'
        oDlgExc := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 270 
        oGrp7E := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgExc, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
        If ZCA -> (ZCA_TIPO) == 'I'
            cSay1EE  := "EXCLUSÃO DE ITEM - IMPRESSORAS"
        ELSEIF  ZCA -> (ZCA_TIPO) ==  'E'
            cSay1EE  := "EXCLUSÃO DE ITEM - ESTAÇÃO"
        ENDIF
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1E   := TSay():New(nObjLinh, nObjColu, {|| cSay1EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1E   := TButton():New(nObjLinh, nObjColu, cBtn1EE, oDlgExc,{|| oDlgExc:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2E := TButton():New(nObjLinh, nObjColu, cBtn2EE, oDlgExc,{|| excBtn()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2E   := TSay():New(nObjLinh, nObjColu, {|| cSay2EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2EE := aDadosExc[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2E   := TGet():New(nObjLinh, nObjColu, {|| xGet2EE}, oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 80
        nObjAltu := 20
        oSay3E   := TSay():New(nObjLinh, nObjColu, {|| cSay3EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3E:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        xGet3EE := aDadosExc[2][1]
        If ZCA -> (ZCA_TIPO) == 'I'
            cSay3EE  := "Descrição"
        ELSEIF  ZCA -> (ZCA_TIPO) ==  'E'
            cSay3EE  := "Nome Estação"
        ENDIF
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3EE := u, xGet3EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet3E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4E   := TSay():New(nObjLinh, nObjColu, {|| cSay4EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4EE := aDadosExc[3][1]
        if ZCA->(ZCA_TIPO) == 'I'
            cEscolha := 'I = IMPRESSORA'
        elseif ZCA -> (ZCA_TIPO) == 'E'
            cEscolha := 'E = ESTACAO'
        endif
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4E   := TGet():New(nObjLinh, nObjColu,{|| cEscolha} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5E := TSay():New(nObjLinh, nObjColu, {|| cSay5EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo5EEE  := aDadosExc[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5E := TComboBox():New(nObjLinh, nObjColu,, aCombo5EE, nObjLarg, nObjAltu,oDlgExc,,{||cCombo5EEE},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao,,,,,,,,,)
        
        oCombo5E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6E := TSay():New(nObjLinh, nObjColu, {|| cSay6EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6EE  := aDadosExc[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6E := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6EE := u, xGet6EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet6E:lActive := .F.

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 325  
        oGrp8E := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,, oDlgExc, , , lDimPixels)

        oDlgExc:Activate()

// -------------------------------------------------------------------------------
// 
//              TELA DE EXCLUSÃO DE ROLOS - GABRIEL
// 
// -------------------------------------------------------------------------------

    elseif ZCA->(ZCA_TIPO) == 'R'

   cJanTitulo := 'EXCLUSÃO DE ROLOS'
        oDlgExc := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 270 
        oGrp7E := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgExc, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
            cSay1EE  := "EXCLUSÃO DE ITEM - ROLOS"
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1E   := TSay():New(nObjLinh, nObjColu, {|| cSay1EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1E   := TButton():New(nObjLinh, nObjColu, cBtn1EE, oDlgExc,{|| oDlgExc:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2E := TButton():New(nObjLinh, nObjColu, cBtn2EE, oDlgExc,{|| excBtn()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2E   := TSay():New(nObjLinh, nObjColu, {|| cSay2EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2EE := aDadosExc[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2E   := TGet():New(nObjLinh, nObjColu, {|| xGet2EE}, oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3E   := TSay():New(nObjLinh, nObjColu, {|| cSay3EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3E:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        xGet3EE := aDadosExc[2][1]
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3EE := u, xGet3EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet3E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4E   := TSay():New(nObjLinh, nObjColu, {|| cSay4EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4EE := aDadosExc[3][1]
            cEscolha := 'R = ROLO'
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4E   := TGet():New(nObjLinh, nObjColu,{|| cEscolha} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5E := TSay():New(nObjLinh, nObjColu, {|| cSay5EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo5EEE  := aDadosExc[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5E := TComboBox():New(nObjLinh, nObjColu,, aCombo5EE, nObjLarg, nObjAltu,oDlgExc,,{||cCombo5EEE},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao,,,,,,,,,)
        
        oCombo5E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6E := TSay():New(nObjLinh, nObjColu, {|| cSay6EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6EE  := aDadosExc[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6E := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6EE := u, xGet6EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet6E:lActive := .F.

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 325  
        oGrp8E := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,, oDlgExc, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay9E   := TSay():New(nObjLinh, nObjColu, {|| cSay9EE}, oDlgExc,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet9EE := aDadosExc[7][1]
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet9E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet9EE := u, xGet9EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet9E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 30
        nObjAltu := 20
        oSay10E  := TSay():New(nObjLinh, nObjColu, {|| cSay10EE}, oDlgExc,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10E:SetCss(" TSay {Font: Semi-Bold}")
    
        oFontPadrao  := TFont():New(cFont, , -16)
        xGet10EE := aDadosExc[8][1]
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 30
        nObjAltu := 15
        oGet10E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet10EE := u, xGet10EE)} , oDlgExc, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet10E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 190
        nObjLarg := 50
        nObjAltu := 20
        oSay11E   := TSay():New(nObjLinh, nObjColu, {|| cSay11EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet11EE := aDadosExc[9][1]
        nObjLinh := 125
        nObjColu := 190
        nObjLarg := 50
        nObjAltu := 15
        oGet11E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet11EE := u, xGet11EE)} , oDlgExc, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet11E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 255
        nObjLarg := 80
        nObjAltu := 20
        oSay12E   := TSay():New(nObjLinh, nObjColu, {|| cSay12EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet12EE := aDadosExc[10][1]
        nObjLinh := 125
        nObjColu := 255
        nObjLarg := 80
        nObjAltu := 15
        oGet12E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet12EE := u, xGet12EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet12E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 350
        nObjLarg := 80
        nObjAltu := 20
        oSay13E   := TSay():New(nObjLinh, nObjColu, {|| cSay13EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay13E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet13EE := aDadosExc[11][1]
        nObjLinh := 125
        nObjColu := 350
        nObjLarg := 80
        nObjAltu := 15
        oGet13E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet13EE := u, xGet13EE)} , oDlgExc, nObjLarg, nObjAltu, '@!', /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet13E:lActive := .F.

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 270  
        oGrp8E := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,, oDlgExc, , , lDimPixels)

        oDlgExc:Activate()

// -------------------------------------------------------------------------------
// 
//              TELA DE EXCLUSÃO DE LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------
    Elseif ZCA->(ZCA_TIPO) ==  'L'

    cJanTitulo := 'EXCLUSÃO DE LAMPADAS'
        oDlgExc := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 270 
        oGrp7E := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgExc, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1EE  := "EXCLUSÃO DE ITEM - LAMPADAS"
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1E   := TSay():New(nObjLinh, nObjColu, {|| cSay1EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1E   := TButton():New(nObjLinh, nObjColu, cBtn1EE, oDlgExc,{|| oDlgExc:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2E := TButton():New(nObjLinh, nObjColu, cBtn2EE, oDlgExc,{|| excBtn()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2E   := TSay():New(nObjLinh, nObjColu, {|| cSay2EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2EE := aDadosExc[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2E   := TGet():New(nObjLinh, nObjColu, {|| xGet2EE}, oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet2E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3E   := TSay():New(nObjLinh, nObjColu, {|| cSay3EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3E:SetCss(" TSay {Font: Semi-Bold}")

        
        oFontPadrao  := TFont():New(cFont, , -16)
        xGet3EE := aDadosExc[2][1]
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet3EE := u, xGet3EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet3E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4E   := TSay():New(nObjLinh, nObjColu, {|| cSay4EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4EE := aDadosExc[3][1]
            cEscolha := 'R = ROLO'
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4E   := TGet():New(nObjLinh, nObjColu,{|| cEscolha} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
    
        oGet4E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5E := TSay():New(nObjLinh, nObjColu, {|| cSay5EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo5AAA  := aDadosExc[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 24
        oCombo5E := TComboBox():New(nObjLinh, nObjColu,, aCombo5EE, nObjLarg, nObjAltu,oDlgExc,,{||cCombo5EEE},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao,,,,,,,,,)
        
        oCombo5E:lActive := .F.

        // CRIAÇÃO DO OBJETO 6
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6E := TSay():New(nObjLinh, nObjColu, {|| cSay6EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6EE  := aDadosExc[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6E := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet6EE := u, xGet6EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet6E:lActive := .F.

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 325  
        oGrp8E := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,, oDlgExc, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay14E   := TSay():New(nObjLinh, nObjColu, {|| cSay14EE}, oDlgExc,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay14E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet14EE  := aDadosExc[7][1]
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet14E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet14EE := u, xGet14EE)} , oDlgExc, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet14E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu := 20
        oSay15E   := TSay():New(nObjLinh, nObjColu, {|| cSay15EE}, oDlgExc,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay15E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet15EE  := aDadosExc[8][1]
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        oGet15E   := TGet():New(nObjLinh, nObjColu,{||xGet15EE} , oDlgExc, nObjLarg, nObjAltu,,, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet15E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay16E   := TSay():New(nObjLinh, nObjColu, {|| cSay16EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay16E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet16EE  := aDadosExc[9][1]
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet16E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet16EE := u, xGet16EE)} , oDlgExc, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet16E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 50
        nObjAltu := 20
        oSay17E   := TSay():New(nObjLinh, nObjColu, {|| cSay17EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay17E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet17EE  := aDadosExc[10][1]
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 30
        nObjAltu := 15
        oGet17E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet17EE := u, xGet17EE)} , oDlgExc, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet17E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 380
        nObjLarg := 50
        nObjAltu := 20
        oSay18E   := TSay():New(nObjLinh, nObjColu, {|| cSay18EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay18E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet18EE  := aDadosExc[11][1]
        nObjLinh := 125
        nObjColu := 380
        nObjLarg := 30
        nObjAltu := 15
        oGet18E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet18EE := u, xGet18EE)} , oDlgExc, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet18E:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oSay19E   := TSay():New(nObjLinh, nObjColu, {|| cSay19EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay19E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet19EE  := aDadosExc[12][1]
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 30
        nObjAltu := 15
        oGet19E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet19EE := u, xGet19EE)} , oDlgExc, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet19E:lActive := .F.

         oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 485
        nObjLarg := 50
        nObjAltu := 20
        oSay20E   := TSay():New(nObjLinh, nObjColu, {|| cSay20EE}, oDlgExc,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay20E:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet20EE  := aDadosExc[13][1]
        nObjLinh := 125
        nObjColu := 485
        nObjLarg := 80
        nObjAltu := 15
        oGet20E   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet20EE := u, xGet20EE)} , oDlgExc, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet20E:lActive := .F.

        oDlgExc:Activate()
        
    ENDIF
    FWRestArea(aArea)
return 

static function excBtn()

    Local aArea := FWGetArea()

    DbSelectArea('ZCA')
    ZCA->(DbSetOrder(1))

        Begin Transaction
        RecLock('ZCA', .F.)
        if ZCA->(ZCA_TIPO) == 'I'
            ZCA -> (DbSeek(xFilial() + Alltrim(oGet2E:BUFFER) + 'I'))
        ELSEif ZCA->(ZCA_TIPO) == 'E'
            ZCA -> (DbSeek(xFilial() + Alltrim(oGet2E:BUFFER) + 'E'))
        ELSEif ZCA->(ZCA_TIPO) == 'R'
            ZCA -> (DbSeek(xFilial() + Alltrim(oGet2E:BUFFER) + 'R'))
        ELSEif ZCA->(ZCA_TIPO) == 'L'
            ZCA -> (DbSeek(xFilial() + Alltrim(oGet2E:BUFFER) + 'L'))
        ENDIF
            ZCA -> (DbDelete())
        ZCA -> (MsUnlock())  
        lEsc := MsgYesNo('Deseja remover mesmo?')
        if lEsc == .F.
            DisarmTransaction()
        else
            MsgInfo('REGISTRO REMOVIDO!!')
        endif
        end Transaction

        oDlgExc:End()

    FWRestArea(aArea)
return

// ============================================================
// 
//               PARTE DE MANUTENÇÃO DE ROLOS 
// 
// ============================================================
// ============================================================
// ============================================================
// ============================================================

Static function fCarAcolsMRL()
    
    Local aArea := FWGetArea()
    Local cQry := ''
    Local nTotal := 0
    Local nAtual := 0 

    cQry := "SELECT * FROM ZM1990 WHERE D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZM1"

        Count To nTotal
        ProcRegua(nTotal)

        nTam := Len(aColsM)

        aSize(aColsM, - nTam)

        QRY_ZM1 -> (DbGoTop())
        while ! QRY_ZM1->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsM,{QRY_ZM1->ZM1_COD,;
                         QRY_ZM1->ZM1_EST,;
                         QRY_ZM1->ZM1_IMPRES,;
                         QRY_ZM1->ZM1_USU,;
                         QRY_ZM1->ZM1_ROLO,;
                         QRY_ZM1->ZM1_FAB,;
                         QRY_ZM1->ZM1_DATAIN,;
                         QRY_ZM1->ZM1_OBS,;
                         QRY_ZM1->ZM1_DATACAD,;
                         QRY_ZM1->ZM1_ATIVO,;
                         QRY_ZM1->ZM1_METRA,;
                        .F.;
                        })

            QRY_ZM1 ->(DbSkip())
        enddo
        QRY_ZM1->(DbCloseArea())

        FWRestArea(aArea) 
return

User function incMRl()

    Local aArea := FwGetArea()
    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''

    Private oDlgCadM

    Private aHeaderM    := {}
    Private aColsM      := {}

    Private oSay1M
    Private cSay1MM     := "CADASTRO MANUTENÇAÕ DE ROLOS"
    Private oBtn1M
    Private cBtn1MM     := 'Fechar'
    Private oBtn2M
    Private cBtn2MM     := 'Salvar'

    Private oSay2M
    Private cSay2MM     := 'Código'
    Private oGet2M
    Private cGet2MM     := Space(TamSX3('ZM1_COD')[1])
    

    Private oSay3M
    Private cSay3MM     := 'Impressora'
    Private oGet3M
    Private cGet3MM     := ''

    Private oSay4M
    Private cSay4MM     := 'Estação'
    Private oGet4M
    Private cGet4MM     := ''

    Private oSay5M
    Private cSay5MM     := 'Usuario'
    Private oGet5M
    Private cCod        := RetCodUsr()
    Private cNome       := ''
    Private xGet5MM     := ''

    Private oSay6M
    Private cSay6MM     := 'Rolo'
    Private oGet6M
    Private cGet6MM     := ''

    Private oSay7M
    Private cSay7MM    := 'Fabricador'
    Private oGet7M
    Private xGet7MM    := Space(TamSX3('ZM1_FAB')[1])

    Private oSay8M
    Private cSay8MM    := 'Data instalação'
    Private oGet8M
    Private xGet8MM    := Stod('')

    Private oSay9M
    Private cSay9MM    := 'Observação'
    Private oGet9M
    Private xGet9MM    := Space(TamSX3('ZM1_OBS')[1])

    Private oSay10M
    Private cSay10MM    := 'Data Cadastramento'
    Private oGet10M
    Private xGet10MM    := DATE()

    Private oSay11M
    Private cSay11MM     := 'Ativo'
    Private oCombo11M
    Private aCombo11M   := {'ESCOLHA OPÇÃO','S=SIM','N=NAO'}

    Private oSay12M
    Private cSay12MM    := 'Metragem'
    Private oGet12M
    Private xGet12MM    := Space(TamSX3('ZM1_METRA')[1])

    Private nEscM 

    nEscBD := 2

     AADD(aHeaderM,{"Codigo",;      
                      "ZM1_COD",;      
                      "",;             
                       6,;             
                       0,;             
                      "AlwaysTrue()",; 
                      "",;
                      "C",;            
                      ""})

        AADD(aHeaderM,{"Impressora",;
                      "ZM1_IMPRES",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderM,{"Estação Rl",;
                      "ZM1_EST",;
                      "@!",;
                       50,;
                       0,;
                      "",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderM,{"Usuario",;
                      "ZM1_USU",;
                      "@!",;
                       50,;
                       0,;
                      "",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderM,{"Rolo",;
                      "ZM1_ROLO",;
                      "",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderM,{"Fabricante do Rolo",;
                      "ZM1_FAB",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})
        
        AADD(aHeaderM,{"Data Inscrição",;
                      "ZCA_DATAIN",;
                      "@!",;
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "D",;
                      ""})

        AADD(aHeaderM,{"Observação",;
                      "ZM1_OBS",;
                      "@!",;
                       100,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderM,{"Data Cadastro",;
                      "ZM1_DATACA",;
                      "",;
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "D",;
                      ""})

        AADD(aHeaderM,{"ATIVO",;
                      "ZM1_ATIVO",;
                      "",;
                       1,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      "S=SIM;N=NÃO"})

        AADD(aHeaderM,{"Metragem Rolo",;
                      "ZM1_METRA",;
                      "",;
                       7,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        Processa({|| fCarAcolsMRL()}, "Processando")

        nEscM := 5

        cJanTitulo := 'MANUTENÇÃO DE ROLOS - CADASTRO'
        oDlgCadM := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgCadM, , , lDimPixels)

        // Criação objetos 01
        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1TT  := 'MANUTENÇÃO DE ROLOS - CADASTRO'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1M := TSay():New(nObjLinh, nObjColu, {|| cSay1MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1M   := TButton():New(nObjLinh, nObjColu, cBtn1MM, oDlgCadM,{|| oDlgCadM:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2M   := TButton():New(nObjLinh, nObjColu, cBtn2MM, oDlgCadM,{|| CadBtnM()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       
        // oBtn2T:SetCss("TButton {background-color: blue;  font:semi-bold; font-color:white;}")
        
        //Criação do Objetos 08
        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgCadM, , , lDimPixels)
        
        //Criação objetos 02
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2M   := TSay():New(nObjLinh, nObjColu, {|| cSay2MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2M:SetCss(" TSay {Font: Semi-Bold}")

        DbSelectArea('ZM1')

        geraCodM()

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2M   := TGet():New(nObjLinh, nObjColu, {||cGet2MM}, oDlgCadM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        ZM1->(DbCloseArea())

        oGet2M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3M   := TSay():New(nObjLinh, nObjColu, {|| cSay3MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        lHasButton := .T.
        oGet3M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet3MM := u, cGet3MM)} , oDlgCadM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet3M:cF3 := 'U_zConsImp()' //puxar função que ira fazer a consulta especifica
        oGet3M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")


        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4M   := TSay():New(nObjLinh, nObjColu, {|| cSay4MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        oGet4M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet4MM := u, cGet4MM)} , oDlgCadM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet4M:cF3 := 'U_zConsEst()' //puxar função que ira fazer a consulta especifica
        oGet4M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5M   := TSay():New(nObjLinh, nObjColu, {|| cSay5MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 15
        cNome := Alltrim(UsrRetName(cCod))
        xGet5MM := Alltrim(cNome)
        oGet5M := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet5MM := u, xGet5MM)} , oDlgCadM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,.T.)

        oGet5M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6M   := TSay():New(nObjLinh, nObjColu, {|| cSay6MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        lHasButton := .T.
        oGet6M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet6MM := u, cGet6MM)} , oDlgCadM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet6M:cF3 := 'U_zConsRl()' //puxar função que ira fazer a consulta especifica
        oGet6M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay7M   := TSay():New(nObjLinh, nObjColu, {|| cSay7MM}, oDlgCadM,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay7M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet7M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet7MM := u, xGet7MM)} , oDlgCadM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu:= 20
        oSay8M   := TSay():New(nObjLinh, nObjColu, {|| cSay8MM}, oDlgCadM,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay8M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        oGet8M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet8MM := u, xGet8MM)} , oDlgCadM, nObjLarg, nObjAltu,'@R 99/99/99', /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet8M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay9M   := TSay():New(nObjLinh, nObjColu, {|| cSay9MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet9M  := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet9MM := u, xGet9MM)} , oDlgCadM, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 50
        nObjAltu := 20
        oSay10M   := TSay():New(nObjLinh, nObjColu, {|| cSay10MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 15
        oGet10M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet10MM := u, xGet10MM)} , oDlgCadM, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet10M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oSay11M   := TSay():New(nObjLinh, nObjColu, {|| cSay11MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oCombo11M   := TComboBox():New(nObjLinh, nObjColu,, aCombo11M, nObjLarg, nObjAltu,oDlgCadM,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 500
        nObjLarg := 50
        nObjAltu := 20
        oSay12M   := TSay():New(nObjLinh, nObjColu, {|| cSay12MM}, oDlgCadM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 500
        nObjLarg := 30
        nObjAltu := 15
        oGet12M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet12MM := u, xGet12MM)} , oDlgCadM, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
        
        oMsGetZCA := MsNewGetDados():New(155,005,443,950,,,,,,,999,,,,oDlgCadM,aHeaderM,aColsM) 

            oMsGetZCA:lActive := .F. 

        oDlgCadM:Activate()

    FWRestArea(aArea)

return

static function cadBtnM()
    Local aArea := FWGetArea()
    Local cAlias := 'ZM1'
    Local lEscolha := .F.

// -------------------------------------------------------------------------------
// 
//              BOTÃO CADASTRO MANUTENÇÃO ROLOS - GABRIEL
// 
// -------------------------------------------------------------------------------

        lEscolha := MsgYesNo('DESEJA CONFIRMAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            if Empty(oGet2M:BUFFER) .OR. Empty(oGet3M:BUFFER) .OR. Empty(oGet4M:BUFFER) .OR. Empty(oGet6M:BUFFER) .OR. Empty(oGet7M:BUFFER)  .OR. Empty(oGet8M:BUFFER) .OR. Empty(oGet9M:BUFFER)  .OR. Empty(oGet12M:BUFFER) 
                MSGALERT('HÁ ALGUM CAMPO SEM DIGITAÇÃO','ATENÇÃO')
            ELSEIF  IsAlpha(oGet12M:BUFFER)
                MsgAlert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS','ATENÇÃO')
            elseif  oCombo11M:Nat == 0
                MsgAlert('CAMPO ATIVO SEM ESCOLHA','ATENÇÃO') 
            else
            begin transaction 
            RecLock(cAlias, .T.)
                ZM1->ZM1_COD     := Alltrim(oGet2M:BUFFER)
                ZM1->ZM1_IMPRES  := Alltrim(oGet3M:BUFFER)
                ZM1->ZM1_EST     := Alltrim(oGet4M:BUFFER)
                ZM1->ZM1_USU     := AllTrim(oGet5M:BUFFER)
                ZM1->ZM1_ROLO    := Alltrim(oGet6M:BUFFER)
                ZM1->ZM1_FAB     := Alltrim(oGet7M:BUFFER)
                ZM1->ZM1_DATAIN  :=    CTOD(oGet8M:BUFFER)
                ZM1->ZM1_OBS     := Alltrim(oGet9M:BUFFER)
                ZM1->ZM1_DATACA  :=    CTOD(oGet10M:BUFFER)
                if oCombo11M:NAT == 2
                        ZM1->ZM1_ATIVO := oCombo11M:AITEMS[2]
                    elseif oCombo11M:NAT == 3
                        ZM1->ZM1_ATIVO := oCombo11M:AITEMS[3]
                    elseif oCombo11M:nat == 1 .OR. oCombo11M:nat == 0
                        MsgAlert('POR FAVOR ESCOLHA UMA OPÇÃO VALIDA NO CAMPO ATIVO!!(SIM/NAO)', 'ATENÇÃO')
                        DisarmTransaction()
                        return
                ENDIF
                ZM1->ZM1_METRA   := Alltrim(oGet12M:BUFFER)
            ZM1 -> (MSUNLOCK())
            end transaction
                MsgInfo('CADASTRO FEITO COM SUCESSO!!','ATENÇÃO')

            lEsc := MsgYesNo('CONTINUAR COM AS MESMAS INFORMAÇÕES?','ATENÇÃO')

            if lEsc == .F.
                geraCodM()
                oGet2M:BUFFER := Space(TamSX3('ZM1_COD')[1])
                oGet3M:BUFFER := Space(TamSX3('ZM1_IMPRES')[1])
                oGet4M:BUFFER := Space(TamSX3('ZM1_EST')[1])
                oGet5M:BUFFER := Space(TamSX3('ZM1_USU')[1]) 
                oGet6M:BUFFER := Space(TamSX3('ZM1_ROLO')[1])
                oGet7M:BUFFER := Space(TamSX3('ZM1_FAB')[1])
                oGet9M:BUFFER := Space(TamSX3('ZM1_OBS')[1])
                oGet10M:BUFFER:= Space(TamSX3('ZM1_DATACA')[1])
                oCombo11M:Nat := 0
                oGet12M:BUFFER := Space(TamSX3('ZM1_METRA')[1])
            ENDIF
            endif
        else
            MsgInfo('NENHUMA ALTERAÇÃO EFETUADA')
        ENDIF

        fCarAcolsMRL()
        oMsGetZCA:ACOLS := aColsM
        oMsGetZCA:oBrowse:Refresh()
        geraCodM()

    FWRestArea(aArea)

Return 

Static function geraCodM()

    Local aArea := FWGetArea()
    Local oTempTable 
    Local aFields := {}
    Local cQry 
    Local cNumG := ""
    Local cTira := ''
    Local cAliasTemp := GetNextAlias()
    Local cTableName := ''

    oTempTable := FWTemporaryTable():NEW(cAliasTemp)
   
    AADD(aFields,{'COD_GR'  , "C", 6, 0})
    AADD(aFields,{'COD_MRL' , "C", 6, 0})
    AADD(aFields,{'COD_MLP' , "C", 6, 0})
    
    oTempTable:SetFields(aFields)

    oTempTable:AddIndex('1',{"COD_GR", "COD_MRL", "COD_MLP"})
    // oTempTable:SetPrimaryKey({'COD_GR'})

    oTempTable:Create()

    cTableName := oTempTable:GetRealName()

    IF SELECT('ZM1') > 0

    DbSelectArea('ZM1')
    ZM1 -> (DbGoTop())

            while ZM1->(!EoF())
                    if Empty(ZM1->(ZM1_COD)) 
                        RecLock(cAliasTemp,.T.)
                            (cAliasTemp)->COD_MRL := '000001'
                        (cAliasTemp)->(MSUNLOCK())
                    else
                    RecLock(cAliasTemp,.T.)
                        (cAliasTemp)->COD_MRL := ZM1->ZM1_COD
                    (cAliasTemp)->(MSUNLOCK())
                    endif
                
                ZM1->(DbSkip())
            EndDo
    ZM1 -> (DbCloseArea())

                DbSelectArea(cAliasTemp)

                cQry := 'SELECT MAX(COD_MRL) AS CCOD FROM ' + cTableName 

                    TCQUERY cQry NEW ALIAS "QRYG_ZM1"

                    cNumG := SOMA1(QRYG_ZM1 -> CCOD) 
                    cTira := strTran(cNumg, '', "0")

                    QRYG_ZM1 -> (DbCloseArea())
                (cAliasTemp) -> (DbCloseArea())   

    oTempTable:Delete()

    cGet2MM := cTira

    ELSEIF SELECT('ZM2') > 0

    DbSelectArea('ZM2')
    ZM2 -> (DbGoTop())

            while ZM2->(!EoF())
                    if Empty(ZM2->(ZM2_COD)) 
                        RecLock(cAliasTemp,.T.)
                            (cAliasTemp)->COD_MLP := '000001'
                        (cAliasTemp)->(MSUNLOCK())
                    else
                    RecLock(cAliasTemp,.T.)
                        (cAliasTemp)->COD_MLP := ZM2->ZM2_COD
                    (cAliasTemp)->(MSUNLOCK())
                    endif
                
                ZM2->(DbSkip())
            EndDo
    ZM2 -> (DbCloseArea())

                DbSelectArea(cAliasTemp)

                cQry := 'SELECT MAX(COD_MLP) AS CCOD FROM ' + cTableName 

                    TCQUERY cQry NEW ALIAS "QRYG_ZM2"

                    cNumG := SOMA1(QRYG_ZM2 -> CCOD) 
                    cTira := strTran(cNumg, '', "0")

                    QRYG_ZM2 -> (DbCloseArea())
                (cAliasTemp) -> (DbCloseArea())   


    oTempTable:Delete()

    xGet2LL := cTira

    ENDIF

    FWRestArea(aArea)

Return 

User function altMRL()

    Local aArea         := FWGetArea()
    Local aFieldsM       := {}
    Local oTableTempAltM 
    Local cAliasTempAltM := GetNextAlias()
    Local cNameTableM    := ''
    Private aDadosAltM      := {}

    Private aCombo11M   := {'S=SIM','N=NAO'}   

        oTableTempAltM  := FWTemporaryTable():New(cAliasTempAltM)

        AADD(aFieldsM,{'COD_ALL'       , "C", 6, 0})
        AADD(aFieldsM,{'COD_ALTM'      , "C", 6, 0})
        AADD(aFieldsM,{'IMP_ALTM'      , "C",50, 0})
        AADD(aFieldsM,{'EST_ALTM'      , "C",50, 0})
        AADD(aFieldsM,{'USU_ALTM'      , "C",50, 0})
        AADD(aFieldsM,{'ROLO_ALTM'     , "C",50, 0})
        AADD(aFieldsM,{'FAB_ALTM'      , "C",50, 0})
        AADD(aFieldsM,{'DAIN_ALTM'     , "D", 8, 0})
        AADD(aFieldsM,{'OBS_ALTM'      , "C",50, 0})
        AADD(aFieldsM,{'DACA_ALTM'     , "D", 8, 0})
        AADD(aFieldsM,{'ATIVO_ALTM'    , "C", 1, 0})
        AADD(aFieldsM,{'ATIVO_NAT'     , "C", 1, 0})
        AADD(aFieldsM,{'MET_ALTM'      , "C",50, 0})
        
        oTableTempAltM:SetFields(aFieldsM)
        oTableTempExcM:AddIndex('1',{'COD_ALL','COD_ALTM'})

        oTableTempAltM:Create()

        cNameTableM := oTableTempAltM:GetRealName()

        DbSelectArea('ZCA')

            RecLock(cAliasTempAltM, .T.)
                (cAliasTempAltM) -> (COD_EXCM)     := ZM1 -> (ZM1_COD)
                (cAliasTempAltM) -> (IMP_EXCM)     := ZM1 -> (ZM1_IMPRES)
                (cAliasTempAltM) -> (EST_EXCM)     := ZM1 -> (ZM1_EST)
                (cAliasTempAltM) -> (USU_EXCM)     := ZM1 -> (ZM1_USU)
                (cAliasTempAltM) -> (ROLO_EXCM)    := ZM1 -> (ZM1_ROLO)
                (cAliasTempAltM) -> (FAB_EXCM)     := ZM1 -> (ZM1_FAB)
                (cAliasTempAltM) -> (DAIN_EXCM)    := ZM1 -> (ZM1_DATAIN)
                (cAliasTempAltM) -> (OBS_EXCM)     := ZM1 -> (ZM1_OBS)
                (cAliasTempAltM) -> (DACA_EXCM)    := ZM1 -> (ZM1_DATACA)
                (cAliasTempAltM) -> (ATIVO_EXCM)    := ZM1 -> (ZM1_ATIVO)
                if (cAliasTempAltM) -> (ATIVO_EXCM) == 'S'
                    (cAliasTempAltM) -> (ATIVO_NAT):= "1"
                    aCombo11M := {'S=SIM','N=NAO'}
                elseif (cAliasTempAltM) -> (ATIVO_EXCM) == 'N'
                    (cAliasTempAltM) -> (ATIVO_NAT):= "1"
                    aCombo11M := {'N=NAO','S=SIM'}
                endif
                (cAliasTempAltM) -> (MET_EXCM)     := ZM1 -> (ZM1_METRA)
            (cAliasTempAltM) -> (MSUNLOCK())


        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(COD_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(IMP_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(EST_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(USU_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(ROLO_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(FAB_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (DTOC(DAIN_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(OBS_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (DTOC(DACA_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(ATIVO_EXCM))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(ATIVO_NAT))})
        AADD(aDadosAltM,{(cAliasTempAltM) -> (AllTrim(MET_EXCM))})

        oTableTempAlt:Delete()

        dialogAltM(aDadosAltM)

    FWRestArea(aArea)

return 

static function dialogAltM(aDadosAltM)

Local aArea := FWGetArea()

    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''

    Private oSay1M
    Private cSay1MM     := "MANUTENÇÃO DE ROLOS - ALTERAÇÃO"
    Private oBtn1M
    Private cBtn1MM     := 'FECHAR'
    Private oBtn2M
    Private cBtn2MM     := 'ALTERAR'

    Private oSay2M
    Private cSay2MM     := 'Código'
    Private oGet2M
    Private xGet2MM     

    Private oSay3M
    Private cSay3MM     := 'Impressora'
    Private oGet3M
    Private cGet3MM     := ''  

    Private oSay4M
    Private cSay4MM     := 'Estação'
    Private oGet4M
    Private cGet4MM     := ''

    Private oSay5M
    Private cSay5MM     := 'Usuario'
    Private oGet5M
    Private cCod        := RetCodUsr()
    Private cNome       := ''
    Private xGet5MM     := ''

    Private oSay6M
    Private cSay6MM     := 'Rolo'
    Private oGet6M
    Private cGet6MM     := ''

    Private oSay7M
    Private cSay7MM    := 'Fabricador'
    Private oGet7M
    Private xGet7MM     

    Private oSay8M
    Private cSay8MM    := 'Data instalação'
    Private oGet8M
    Private xGet8MM     

    Private oSay9M
    Private cSay9MM    := 'Observação'
    Private oGet9M
    Private xGet9MM    

    Private oSay10M
    Private cSay10MM    := 'Data Cadastramento'
    Private oGet10M
    Private xGet10MM    

    Private oSay11M
    Private cSay11MM     := 'Ativo'
    Private cCombo11M    
    Private oCombo11M

    Private oSay12M
    Private cSay12MM    := 'Metragem'
    Private oGet12M
    Private xGet12MM    

    Private oDlgAltM

        nEscM := 6

        nEscBD := 2

        cJanTitulo := 'MANUTENÇÃO DE ROLOS - ALTERAÇÃO'
        oDlgAltM := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgAltM, , , lDimPixels)

        // Criação objetos 01
        oFontPadrao  := TFont():New(cFont, , -20)
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1M := TSay():New(nObjLinh, nObjColu, {|| cSay1MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1M   := TButton():New(nObjLinh, nObjColu, cBtn1MM,oDlgAltM ,{|| oDlgAltM:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2M   := TButton():New(nObjLinh, nObjColu, cBtn2MM, oDlgAltM,{|| btnAltM()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       
        
        //Criação do Objetos 08
        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgAltM, , , lDimPixels)
        
        //Criação objetos 02
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2M   := TSay():New(nObjLinh, nObjColu, {|| cSay2MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2MM := aDadosAltM[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2M   := TGet():New(nObjLinh, nObjColu, {||xGet2MM}, oDlgAltM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet2M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3M   := TSay():New(nObjLinh, nObjColu, {|| cSay3MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cGet3MM := Alltrim(aDadosAltM[2][1])
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        lHasButton := .T.
        oGet3M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet3MM := u, cGet3MM)} , oDlgAltM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet3M:cF3 := 'U_zConsImp()' //puxar função que ira fazer a consulta especifica
        oGet3M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4M   := TSay():New(nObjLinh, nObjColu, {|| cSay4MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cGet4MM := aDadosAltM[3][1]
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        oGet4M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet4MM := u, cGet4MM)} , oDlgAltM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet4M:cF3 := 'U_zConsEst()' //puxar função que ira fazer a consulta especifica
        oGet4M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5M   := TSay():New(nObjLinh, nObjColu, {|| cSay5MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet5MM := aDadosAltM[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 15
        cNome := Alltrim(UsrRetName(cCod))
        xGet5MM := Alltrim(cNome)
        oGet5M := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet5MM := u, xGet5MM)} , oDlgAltM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,.T.)

        oGet5M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6M   := TSay():New(nObjLinh, nObjColu, {|| cSay6MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cGet6MM := AllTrim(aDadosAltM[5][1])
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        lHasButton := .T.
        oGet6M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet6MM := u, cGet6MM)} , oDlgAltM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet6M:cF3 := 'U_zConsRl()' //puxar função que ira fazer a consulta especifica
        oGet6M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay7M   := TSay():New(nObjLinh, nObjColu, {|| cSay7MM}, oDlgAltM,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay7M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet7MM := aDadosAltM[6][1]
        nObjLinh := 125 
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet7M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet7MM := u, xGet7MM)} , oDlgAltM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu:= 20
        oSay8M   := TSay():New(nObjLinh, nObjColu, {|| cSay8MM}, oDlgAltM,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay8M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet8MM := CTOD(aDadosAltM[7][1])
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        oGet8M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet8MM := u, xGet8MM)} , oDlgAltM, nObjLarg, nObjAltu,'@R 99/99/99', /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet8M:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay9M   := TSay():New(nObjLinh, nObjColu, {|| cSay9MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet9MM := aDadosAltM[8][1]
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet9M  := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet9MM := u, xGet9MM)} , oDlgAltM, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 50
        nObjAltu := 20
        oSay10M   := TSay():New(nObjLinh, nObjColu, {|| cSay10MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet10MM := aDadosAltM[9][1]
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 15
        oGet10M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet10MM := u, xGet10MM)} , oDlgAltM, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet10M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oSay11M   := TSay():New(nObjLinh, nObjColu, {|| cSay11MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo11MM  := aDadosAltM[10][1]
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oCombo11M   := TComboBox():New(nObjLinh, nObjColu,,aCombo11M, nObjLarg, nObjAltu, oDlgAltM,,{||cCombo11MM},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 500
        nObjLarg := 50
        nObjAltu := 20
        oSay12M   := TSay():New(nObjLinh, nObjColu, {|| cSay12MM}, oDlgAltM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet12MM := aDadosAltM[12][1]
        nObjLinh := 125
        nObjColu := 500
        nObjLarg := 30
        nObjAltu := 15
        oGet12M   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet12MM := u, xGet12MM)} , oDlgAltM, nObjLarg, nObjAltu,,,,/*nClrBack*/, oFontPadrao,,, lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oDlgAltM:Activate()

        FWRestArea(aArea)

return

Static function btnAltM()

    Local aArea := FWGetArea()
    Local cAlias := 'ZM1'

    lEscolha := MsgYesNo('DESEJA  ALTERAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            DbSelectArea(cAlias)

            if (oGet2M:BUFFER == aDadosAltM[1][1]) .AND. (oGet3M:BUFFER == aDadosAltM[2][1]) .AND. (oGet4M:BUFFER == aDadosAltM[3][1]) .AND. (oGet6M:BUFFER == aDadosAltM[5][1]) .AND. (oGet7M:BUFFER == aDadosAltM[6][1]) .AND. (oGet8M:BUFFER == aDadosAltM[7][1]) .AND. (oGet9M:BUFFER == aDadosAltM[8][1]) .AND.(oCombo11M:Nat == 0 .OR. oCombo11M:Nat == Val(aDadosAltM[10][1])) .AND. (oGet12M:BUFFER == aDadosAltM[12][1])
                ALERT('VOCE NÃO MUDOU NADA NOS CAMPOS!!','ATENÇÃO')
            ELSEIF Empty(oGet3M:BUFFER) .OR. Empty(oGet4M:BUFFER) .OR. Empty(oGet6M:BUFFER) .OR. Empty(oGet7M:BUFFER) .OR. Empty(oGet8M:BUFFER) .OR. Empty(oGet9M:BUFFER) .OR. Empty(oGet12M:BUFFER)
                Alert('HÁ CAMPOS SEM NADA ESCRITO!!')
            ELSEIF IsAlpha(oGet12M:BUFFER) 
                Alert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS!!')
            else
            begin transaction 
            RecLock(cAlias, .F.)
                ZM1->ZM1_COD       := Alltrim(oGet2M:BUFFER)
                ZM1->ZM1_IMPRES    := Alltrim(oGet3M:BUFFER)
                ZM1->ZM1_EST       := Alltrim(oGet4M:BUFFER)
                ZM1->ZM1_USU       := Alltrim(oGet5M:BUFFER)
                ZM1->ZM1_ROLO      := Alltrim(oGet6M:BUFFER)
                ZM1->ZM1_FAB       := Alltrim(oGet7M:BUFFER)
                ZM1->ZM1_DATAIN    := CTOD(oGet8M:BUFFER)
                ZM1->ZM1_OBS       := Alltrim(oGet9M:BUFFER)
                ZM1->ZM1_DATACA    := CTOD(oGet10M:BUFFER)
                if oCombo11M:NAT == 1 .OR. oCombo11M:NAT == 0
                    ZM1->ZM1_ATIVO := oCombo11m:AITEMS[1]
                elseif oCombo11M:NAT == 2
                    ZM1->ZM1_ATIVO := oCombo11M:AITEMS[2]
                ENDIF
                ZM1->ZM1_METRA     := Alltrim(oGet12M:BUFFER)
            ZM1 -> (MSUNLOCK())
            end transaction
            MsgInfo('ALTERAÇÃO FEITA COM SUCESSO!!','ATENÇÃO')
            lEsc := MsgYesNo('Deseja Ir para o Menu Principal?(YES/NO)')
                if lEsc == .T.
                    oDlgAltM:End()
                else
                    oGet3M:lActive   := .F.
                    oGet4M:lActive   := .F.
                    oGet5M:lActive   := .F.
                    oGet6M:lActive   := .F.
                    oGet7M:lActive   := .F.
                    oGet8M:lActive   := .F.
                    oGet9M:lActive   := .F.
                    oGet10M:lActive   := .F.
                    oCombo11M:lActive := .F.
                    oGet12M:lActive   := .F.
                    oBtn2M:lActive   := .F.
            endif
            endif
        else
            MsgInfo('NENHUMA ALTERAÇÃO EFETUADA')
        ENDIF
    
    FwRestArea(aArea)

return

User function excMRL()

    Local aArea         := FWGetArea()
    Local aFieldsM       := {}
    Local oTableTempExcM 
    Local cAliasTempExc := GetNextAlias()
    Local cNameTableExc    := ''
    Private aDadosExcM      := {}

    Private aCombo11M   := {'S=SIM','N=NAO'}
    
        oTableTempExcM  := FWTemporaryTable():New(cAliasTempExc)

        AADD(aFieldsM,{'COD_ALL'       , "C", 6, 0})
        AADD(aFieldsM,{'COD_EXCM'      , "C", 6, 0})
        AADD(aFieldsM,{'IMP_EXCM'      , "C",50, 0})
        AADD(aFieldsM,{'EST_EXCM'      , "C",50, 0})
        AADD(aFieldsM,{'USU_EXCM'      , "C",50, 0})
        AADD(aFieldsM,{'ROLO_EXCM'     , "C",50, 0})
        AADD(aFieldsM,{'FAB_EXCM'      , "C",50, 0})
        AADD(aFieldsM,{'DAIN_EXCM'     , "D", 8, 0})
        AADD(aFieldsM,{'OBS_EXCM'      , "C",50, 0})
        AADD(aFieldsM,{'DACA_EXCM'     , "D", 8, 0})
        AADD(aFieldsM,{'ATIVO_EXCM'    , "C", 1, 0})
        AADD(aFieldsM,{'ATIVO_NAT'     , "C", 1, 0})
        AADD(aFieldsM,{'MET_EXCM'      , "C",50, 0})

        oTableTempExcM:SetFields(aFieldsM)
        oTableTempExcM:AddIndex('1',{'COD_ALL','COD_EXCM'})

        oTableTempExcM:Create()

        cNameTableExc := oTableTempExcM:GetRealName()

        DbSelectArea('ZM1')

            RecLock(cAliasTempExc, .T.)
                (cAliasTempExc) -> (COD_EXCM)     := ZM1 -> (ZM1_COD)
                (cAliasTempExc) -> (IMP_EXCM)     := ZM1 -> (ZM1_IMPRES)
                (cAliasTempExc) -> (EST_EXCM)     := ZM1 -> (ZM1_EST)
                (cAliasTempExc) -> (USU_EXCM)     := ZM1 -> (ZM1_USU)
                (cAliasTempExc) -> (ROLO_EXCM)    := ZM1 -> (ZM1_ROLO)
                (cAliasTempExc) -> (FAB_EXCM)     := ZM1 -> (ZM1_FAB)
                (cAliasTempExc) -> (DAIN_EXCM)    := ZM1 -> (ZM1_DATAIN)
                (cAliasTempExc) -> (OBS_EXCM)     := ZM1 -> (ZM1_OBS)
                (cAliasTempExc) -> (DACA_EXCM)    := ZM1 -> (ZM1_DATACA)
                (cAliasTempExc) -> (ATIVO_EXCM)    := ZM1 -> (ZM1_ATIVO)
                if (cAliasTempExc) -> (ATIVO_EXCM) == 'S'
                    (cAliasTempExc) -> (ATIVO_NAT):= "1"
                    aCombo11M := {'S=SIM','N=NAO'}
                elseif (cAliasTempExc) -> (ATIVO_EXCM) == 'N'
                    (cAliasTempExc) -> (ATIVO_NAT):= "1"
                    aCombo11M := {'N=NAO','S=SIM'}
                endif
                (cAliasTempExc) -> (MET_EXCM)     := ZM1 -> (ZM1_METRA)
            (cAliasTempExc) -> (MSUNLOCK())

        
        AADD(aDadosExcM,{(cAliasTempExc) -> (COD_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (IMP_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (EST_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (USU_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (ROLO_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (FAB_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (DTOC(DAIN_EXCM))})
        AADD(aDadosExcM,{(cAliasTempExc) -> (OBS_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (DTOC(DACA_EXCM))})
        AADD(aDadosExcM,{(cAliasTempExc) -> (ATIVO_EXCM)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (ATIVO_NAT)})
        AADD(aDadosExcM,{(cAliasTempExc) -> (AllTrim(MET_EXCM))})

        oTableTempExcM:Delete()


        dialogExcM(aDadosExcM)

    FwRestArea(aArea)

return

Static Function dialogExcM(aDadosExcM)

    Local aArea := FWGetArea()

    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''

    Private oSay1M
    Private cSay1MM     := ""
    Private oBtn1M
    Private cBtn1MM     := 'FECHAR'
    Private oBtn2M
    Private cBtn2MM     := 'DELETAR'

    Private oSay2M
    Private cSay2MM     := 'Código'
    Private oGet2M
    Private xGet2MM     

    Private oSay3M
    Private cSay3MM     := 'Impressora'
    Private oGet3M
    Private cGet3MM  

    Private oSay4M
    Private cSay4MM     := 'Estação'
    Private oGet4M
    Private xGet4MM     

    Private oSay5M
    Private cSay5MM     := 'Usuario'
    Private oGet5M
    Private cCod        := RetCodUsr()
    Private cNome       := ''
    Private xGet5MM     := ''

    Private oSay6M
    Private cSay6MM     := 'Rolo'
    Private oGet6M
    Private xGet6MM     

    Private oSay7M
    Private cSay7MM    := 'Fabricador'
    Private oGet7M
    Private xGet7MM     

    Private oSay8M
    Private cSay8MM    := 'Data instalação'
    Private oGet8M
    Private xGet8MM     

    Private oSay9M
    Private cSay9MM    := 'Observação'
    Private oGet9M
    Private xGet9MM    

    Private oSay10M
    Private cSay10MM    := 'Data Cadastramento'
    Private oGet10M
    Private xGet10MM    

    Private oSay11M
    Private cSay11MM     := 'Ativo'
    Private cCombo11M    
    Private oCombo11M

    Private oSay12M
    Private cSay12MM    := 'Metragem'
    Private oGet12M
    Private xGet12MM    

    Private oDlgExcM

        cJanTitulo := 'MANUTENÇÃO DE ROLOS - EXCLUSÃO'
        oDlgExcM := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        //Criação do Objetos 07
        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgExcM, , , lDimPixels)

        // Criação objetos 01
        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1MM  := 'MANUTENÇÃO DE ROLOS - EXCLUSÃO'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1M := TSay():New(nObjLinh, nObjColu, {|| cSay1MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1M   := TButton():New(nObjLinh, nObjColu, cBtn1MM,oDlgExcM ,{|| oDlgExcM:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2M   := TButton():New(nObjLinh, nObjColu, cBtn2MM, oDlgExcM,{|| excBtnM()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       
        // oBtn2T:SetCss("TButton {background-color: blue;  font:semi-bold; font-color:white;}")
        
        //Criação do Objetos 08
        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgExcM, , , lDimPixels)
        
        //Criação objetos 02
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2M   := TSay():New(nObjLinh, nObjColu, {|| cSay2MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2MM := aDadosExcM[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2M   := TGet():New(nObjLinh, nObjColu, {||xGet2MM}, oDlgExcM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet2M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 30
        nObjAltu := 20
        oSay3M   := TSay():New(nObjLinh, nObjColu, {|| cSay3MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet3MM := Alltrim(aDadosExcM[2][1])
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3M   := TGet():New(nObjLinh, nObjColu,{||xGet3MM} , oDlgExcM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet3M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4M   := TSay():New(nObjLinh, nObjColu, {|| cSay4MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4MM := aDadosExcM[3][1]
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        oGet4M   := TGet():New(nObjLinh, nObjColu,{||xGet4MM} , oDlgExcM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet4M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5M   := TSay():New(nObjLinh, nObjColu, {|| cSay5MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet5MM := aDadosExcM[4][1]
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 15
        cNome := Alltrim(UsrRetName(cCod))
        xGet5MM := Alltrim(cNome)
        oGet5M := TGet():New(nObjLinh, nObjColu,{||xGet5MM} , oDlgExcM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,.T.)

        oGet5M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6M   := TSay():New(nObjLinh, nObjColu, {|| cSay6MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6MM := AllTrim(aDadosExcM[5][1])
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6M   := TGet():New(nObjLinh, nObjColu,{|| xGet6MM} , oDlgExcM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,.T.)

        oGet6M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay7M   := TSay():New(nObjLinh, nObjColu, {|| cSay7MM}, oDlgExcM,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay7M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet7MM := aDadosExcM[6][1]
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oGet7M   := TGet():New(nObjLinh, nObjColu,{||xGet7MM} , oDlgExcM, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet7M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu:= 20
        oSay8M   := TSay():New(nObjLinh, nObjColu, {|| cSay8MM}, oDlgExcM,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay8M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet8MM := aDadosExcM[7][1]
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        oGet8M   := TGet():New(nObjLinh, nObjColu,{|| xGet8MM} , oDlgExcM, nObjLarg, nObjAltu,'@R 99/99/99', /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,.T.)
    
        oGet8M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay9M   := TSay():New(nObjLinh, nObjColu, {|| cSay9MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet9MM := aDadosExcM[8][1]
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet9M  := TGet():New(nObjLinh, nObjColu,{|| xGet9MM} , oDlgExcM, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet9M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 50
        nObjAltu := 20
        oSay10M   := TSay():New(nObjLinh, nObjColu, {|| cSay10MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet10MM := aDadosExcM[9][1]
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 15
        oGet10M   := TGet():New(nObjLinh, nObjColu,{|| xGet10MM} , oDlgExcM, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet10M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oSay11M   := TSay():New(nObjLinh, nObjColu, {|| cSay11MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo11MM  := aDadosExcM[10][1]
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 20
        oCombo11M   := TComboBox():New(nObjLinh, nObjColu,,aCombo11M, nObjLarg, nObjAltu, oDlgExcM,,{||cCombo11MM},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oCombo11M:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 500
        nObjLarg := 50
        nObjAltu := 20
        oSay12M   := TSay():New(nObjLinh, nObjColu, {|| cSay12MM}, oDlgExcM,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12M:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet12MM := aDadosExcM[12][1]
        nObjLinh := 125
        nObjColu := 500
        nObjLarg := 30
        nObjAltu := 15
        oGet12M   := TGet():New(nObjLinh, nObjColu,{||xGet12MM} , oDlgExcM, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet12M:lActive := .F.

        oDlgExcM:Activate()

        FWRestArea(aArea)
return

Static function excBtnM()

    Local aArea := FWGetArea()

    DbSelectArea('ZM1')
    ZM1->(DbSetOrder(2))

        Begin Transaction
        RecLock('ZM1', .F.)
            ZM1 -> (DbDelete())
        ZM1 -> (MsUnlock())  
        lEsc := MsgYesNo('Deseja remover mesmo?')
        if lEsc == .F.
            DisarmTransaction()
        else
            MsgInfo('REGISTRO REMOVIDO!!')
        endif
        end Transaction

        oDlgExcM:End()

    ZM1->(DbCloseArea())

    FWRestArea(aArea)
return

// ----------------------------------------------------------------------------- 
// 
//                       PARTE DE MANUTENÇÃO DE LAMPADA
// 
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------

Static function MLPfCarAcols()
    
    Local aArea := FWGetArea()
    Local cQry := ''
    Local nTotal := 0
    Local nAtual := 0 

    cQry := "SELECT * FROM ZM2990 WHERE D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZM2"

        Count To nTotal
        ProcRegua(nTotal)

        nTam := Len(aColsL)

        aSize(aColsL, - nTam)

        QRY_ZM2 -> (DbGoTop())
        while ! QRY_ZM2->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsL,{QRY_ZM2->ZM2_COD,;
                         QRY_ZM2->ZM2_IMPRES,;
                         QRY_ZM2->ZM2_USU,;
                         QRY_ZM2->ZM2_DATAM,;
                         QRY_ZM2->ZM2_LAMP,;
                         QRY_ZM2->ZM2_TROCRL,;
                         QRY_ZM2->ZM2_MATER,;
                         QRY_ZM2->ZM2_TEMPM,;
                         QRY_ZM2->ZM2_UMIDAD,;
                         QRY_ZM2->ZM2_TEMPA,;
                         QRY_ZM2->ZM2_TEMPD,;
                         QRY_ZM2->ZM2_TEMPR,;
                         QRY_ZM2->ZM2_TENS,;
                         QRY_ZM2->ZM2_HORIME,;
                         QRY_ZM2->ZM2_START,;
                         QRY_ZM2->ZM2_CORR,;
                         QRY_ZM2->ZM2_TEMPT,;
                         QRY_ZM2->ZM2_SETP,;
                         QRY_ZM2->ZM2_POT,;
                         QRY_ZM2->ZM2_OBS,;
                         QRY_ZM2->ZM2_ATIVO,;
                         QRY_ZM2->ZM2_DATAC,;
                        .F.;
                        })

            QRY_ZM2 ->(DbSkip())
        enddo
        QRY_ZM2->(DbCloseArea())

        FWRestArea(aArea) 
return

User function incMLP()

Local aArea := FWGetArea()

    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''

    Private aHeaderL    := {}
    Private aColsL      := {}

    Private oSay1L
    Private cSay1LL     := "MANUTENÇÃO DE LAMPADAS - CADASTRAMENTO"
    Private oBtn1L
    Private cBtn1LL     := 'FECHAR'
    Private oBtn2L
    Private cBtn2LL     := 'CADASTRAR'

    Private oSay2L
    Private cSay2LL     := 'Código'
    Private oGet2L
    Private xGet2LL     

    Private oSay3L
    Private cSay3LL     := 'Impressora'
    Private oGet3L
    Private cGet3LL     := ''

    Private oSay4L
    Private cCod        := RetCodUsr()
    Private cNome       := ''
    Private cSay4LL     := 'Usuario'
    Private oGet4L
    Private xGet4LL     := Space(TamSX3('ZM2_USU')[1])

    Private oSay5L
    Private cSay5LL     := 'Data Manutenção'
    Private oGet5L
    Private xGet5LL     := CTOD('')

    Private oSay6L
    Private cSay6LL     := 'Lâmpada'
    Private oGet6L
    Private cGet6LL     := ''

    Private oSay7L
    Private cSay7LL    := 'Troca Lâmpada'
    Private cCombo7L    
    Private oCombo7L 
    Private aCombo7L   := {'ESCOLHA OPÇÃO','S=SIM','N=NAO'}    

    Private oSay8L
    Private cSay8LL    := 'Troca Refletor'
    Private cCombo8L    
    Private oCombo8L   
    Private aCombo8L   := {'ESCOLHA OPÇÃO','S=SIM','N=NAO'}   

    Private oSay9L
    Private cSay9LL    := 'Material'
    Private oGet9L
    Private xGet9LL    := Space(TamSX3('ZM2_MATER')[1])

    Private oSay10L
    Private cSay10LL    := 'Temp. Ambiente'
    Private oGet10L
    Private xGet10LL    :=Space(TamSX3('ZM2_TEMPM')[1])

    Private oSay11L
    Private cSay11LL     := 'Umidade Relativa(%)'
    Private oGet11L
    Private xGeT11LL     := Space(TamSX3('ZM2_UMIDAD')[1])

    Private oSay12L
    Private cSay12LL    := 'Temp. Antes Lâmpada'
    Private oGet12L
    Private xGet12LL     := Space(TamSX3('ZM2_TEMPA')[1])

    Private oSay13L
    Private cSay13LL    := 'Temp. Depois Lâmpada'
    Private oGet13L
    Private xGet13LL     := Space(TamSX3('ZM2_TEMPD')[1])

    Private oSay14L
    Private cSay14LL    := 'Temp. Refrigeração IST'
    Private oGet14L
    Private xGet14LL     := Space(TamSX3('ZM2_TEMPR')[1])

    Private oSay15L
    Private cSay15LL    := 'Tensão Principal'
    Private oGet15L
    Private xGet15LL     := Space(TamSX3('ZM2_TENS')[1])

    Private oSay16L
    Private cSay16LL    := 'Horimetro (Horas)'
    Private oGet16L
    Private xGet16LL     := Space(TamSX3('ZM2_HORIME')[1])

    Private oSay17L
    Private cSay17LL    := 'Inicio (StartUps)'
    Private oGet17L
    Private xGet17LL     := Space(TamSX3('ZM2_START')[1])

    Private oSay18L
    Private cSay18LL    := 'Corrente (A)'
    Private oGet18L
    Private xGet18LL     := Space(TamSX3('ZM2_CORR')[1])

    Private oSay19L
    Private cSay19LL    := 'Temp. Trabalho(°C)'
    Private oGet19L
    Private xGet19LL     := Space(TamSX3('ZM2_TEMPT')[1])

    Private oSay20L
    Private cSay20LL    := 'Set Point (%)'
    Private oGet20L
    Private xGet20LL     := Space(TamSX3('ZM2_SETP')[1])

    Private oSay21L
    Private cSay21LL    := 'Potencia (mWcm2)'
    Private oGet21L
    Private xGet21LL     := Space(TamSX3('ZM2_POT')[1])
    
    Private oSay22L
    Private cSay22LL    := 'Observação'
    Private oGet22L
    Private xGet22LL     := Space(TamSX3('ZM2_OBS')[1])

    Private oSay23L
    Private cSay23LL    := 'Ativo'
    Private oCombo23L   
    Private aCombo23L   := {'ESCOLHA OPÇÃO','S=SIM','N=NAO'}  

    Private oSay24L
    Private cSay24LL    := 'Data'
    Private oGet24L
    Private xGet24LL     := DATE()

    Private oDlgCadL

    Private nEscL

    nEscL := 7 

    nEscBD := 3

        AADD(aHeaderL,{"Codigo",;      
                      "ZM2_COD",;      
                      "",;             
                       6,;             
                       0,;             
                      "AlwaysTrue()",; 
                      "",;
                      "C",;            
                      ""})

        AADD(aHeaderL,{"Impressora",;
                      "ZM2_IMPRES",;
                      "",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Usuario",;
                      "ZM2_USU",;
                      "",;
                       50,;
                       0,;
                      "",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Data Manu.",;
                      "ZM2_DATAM",;
                      "",;
                       8,;
                       0,;
                      "",;
                      "",;
                      "D",;
                      ""})

        AADD(aHeaderL,{"Lampadas",;
                      "ZM2_LAMP",;
                      "",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Troca Lamp",;
                      "ZM2_TROCLP",;
                      "",;
                       1,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      "S=SIM;N=NÃO"})
        
        AADD(aHeaderL,{"Troca Refletor",;
                      "ZM2_TROCRL",;
                      "",;
                       1,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      "S=SIM;N=NÃO"})

        AADD(aHeaderL,{"Material",;
                      "ZM2_MATER",;
                      "",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Temp. Lamp.",;
                      "ZM2_TEMPM",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Umidade",;
                      "ZM2_UMIDAD",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Temp. Antes",;
                      "ZM2_TEMPA",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Temp. Depois",;      
                      "ZM2_TEMPD",;      
                      "",;             
                       10,;             
                       0,;             
                      "AlwaysTrue()",; 
                      "",;
                      "C",;            
                      ""})

        AADD(aHeaderL,{"Temp. Refrigeração IST",;
                      "ZM2_TEMPR",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Tensão",;
                      "ZM2_TENS",;
                      "",;
                       10,;
                       0,;
                      "",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Horimetro",;
                      "ZM2_HORIME",;
                      "",;
                       10,;
                       0,;
                      "",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"StartUps",;
                      "ZM2_START",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Corrente",;
                      "ZM2_CORR",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})
        
        AADD(aHeaderL,{"Temp. Trabalho",;
                      "ZM2_TEMPT",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"SetP",;
                      "ZM2_SETP",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        AADD(aHeaderL,{"Potencia (mWcm2)",;
                      "ZM2_POT",;
                      "",;
                       10,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "c",;
                      ""})

        AADD(aHeaderL,{"Observação",;
                      "ZM2_OBS",;
                      "",;
                       100,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "c",;
                      ""})

        AADD(aHeaderL,{"ATIVO",;
                      "ZM1_ATIVO",;
                      "",;
                       1,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      "S=SIM;N=NÃO"})

        AADD(aHeaderL,{"Data Cad.",;
                      "ZM2-DATAC",;
                      "",;
                       8,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

        Processa({|| MLPfCarAcols()}, "Processando")

        cJanTitulo := 'MANUTENÇÃO DE LAMPADAS - CADASTRAMENTO'
        oDlgCadL := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgCadL, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1MM  := 'MANUTENÇÃO DE ROLOS - EXCLUSÃO'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1M := TSay():New(nObjLinh, nObjColu, {|| cSay1LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1L   := TButton():New(nObjLinh, nObjColu, cBtn1LL,oDlgCadL ,{|| oDlgCadL:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2L   := TButton():New(nObjLinh, nObjColu, cBtn2LL, oDlgCadL,{|| incBtnMLP()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgCadL, , , lDimPixels)
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2L   := TSay():New(nObjLinh, nObjColu, {|| cSay2LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2L:SetCss(" TSay {Font: Semi-Bold}")

        DbSelectArea('ZM2')

        geraCodM()
        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2L   := TGet():New(nObjLinh, nObjColu, {||xGet2LL}, oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        ZM2->(DbCloseArea())

        oGet2L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 80
        nObjAltu := 20
        oSay3L   := TSay():New(nObjLinh, nObjColu, {|| cSay3LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        lHasButton := .T.
        oGet3L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet3LL := u, cGet3LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet3L:cF3 := 'U_zConsImp()' //puxar função que ira fazer a consulta especifica
        oGet3L:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4L   := TSay():New(nObjLinh, nObjColu, {|| cSay4LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        cNome := Alltrim(UsrRetName(cCod))
        xGet4LL := Alltrim(cNome)
        oGet4L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet4LL := u, xGet4LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet4L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5L   := TSay():New(nObjLinh, nObjColu, {|| cSay5LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        oGet5L := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet5LL := u, xGet5LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet5L:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6L   := TSay():New(nObjLinh, nObjColu, {|| cSay6LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        lHasButton := .T.
        oGet6L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet6LL := u, cGet6LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet6L:cF3 := 'U_zConsLp()' //puxar função que ira fazer a consulta especifica
        oGet6L:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay7L   := TSay():New(nObjLinh, nObjColu, {|| cSay7LL}, oDlgCadL,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay7L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oCombo7L   := TComboBox():New(nObjLinh, nObjColu,,aCombo7L, nObjLarg, nObjAltu, oDlgCadL,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu:= 20
        oSay8L   := TSay():New(nObjLinh, nObjColu, {|| cSay8LL}, oDlgCadL,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay8L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        oCombo8L   := TComboBox():New(nObjLinh, nObjColu,,aCombo8L, nObjLarg, nObjAltu, oDlgCadL,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay9L   := TSay():New(nObjLinh, nObjColu, {|| cSay9LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet9L  := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet9LL := u, xGet9LL)} , oDlgCadL, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 20
        oSay10L   := TSay():New(nObjLinh, nObjColu, {|| cSay10LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 15
        oGet10L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet10LL := u, xGet10LL)} , oDlgCadL, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 80
        nObjAltu := 20
        oSay11L   := TSay():New(nObjLinh, nObjColu, {|| cSay11LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 15
        oGet11L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet11LL := u, xGet11LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 500
        nObjLarg := 80
        nObjAltu := 20
        oSay12L  := TSay():New(nObjLinh, nObjColu, {|| cSay12LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 500
        nObjLarg := 80
        nObjAltu := 15
        oGet12L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet12LL := u, xGet12LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 595
        nObjLarg := 80
        nObjAltu := 20
        oSay13L  := TSay():New(nObjLinh, nObjColu, {|| cSay13LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay13L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 595
        nObjLarg := 80
        nObjAltu := 15
        oGet13L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet13LL := u, xGet13LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 685
        nObjLarg := 80
        nObjAltu := 20
        oSay14L  := TSay():New(nObjLinh, nObjColu, {|| cSay14LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay14L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 125
        nObjColu := 685
        nObjLarg := 50
        nObjAltu := 15
        oGet14L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet14LL := u, xGet14LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 25
        nObjLarg := 80
        nObjAltu := 20
        oSay15L  := TSay():New(nObjLinh, nObjColu, {|| cSay15LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay15L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 25
        nObjLarg := 50
        nObjAltu := 15
        oGet15L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet15LL := u, xGet15LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 90
        nObjLarg := 80
        nObjAltu := 20
        oSay16L  := TSay():New(nObjLinh, nObjColu, {|| cSay16LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay16L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 90
        nObjLarg := 50
        nObjAltu := 15
        oGet16L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet16LL := u, xGet16LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 150
        nObjLarg := 80
        nObjAltu := 20
        oSay17L  := TSay():New(nObjLinh, nObjColu, {|| cSay17LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay17L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 150
        nObjLarg := 50
        nObjAltu := 15
        oGet17L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet17LL := u, xGet17LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 210
        nObjLarg := 80
        nObjAltu := 20
        oSay18L  := TSay():New(nObjLinh, nObjColu, {|| cSay18LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay18L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 210
        nObjLarg := 50
        nObjAltu := 15
        oGet18L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet18LL := u, xGet18LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 270
        nObjLarg := 80
        nObjAltu := 20
        oSay19L  := TSay():New(nObjLinh, nObjColu, {|| cSay19LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay19L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 270
        nObjLarg := 50
        nObjAltu := 15
        oGet19L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet19LL := u, xGet19LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 330
        nObjLarg := 80
        nObjAltu := 20
        oSay20L  := TSay():New(nObjLinh, nObjColu, {|| cSay20LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay20L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 330
        nObjLarg := 50
        nObjAltu := 15
        oGet20L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet20LL := u, xGet20LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 390
        nObjLarg := 80
        nObjAltu := 20
        oSay21L  := TSay():New(nObjLinh, nObjColu, {|| cSay21LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay21L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 390
        nObjLarg := 50
        nObjAltu := 15
        oGet21L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet21LL := u, xGet21LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

         oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 450
        nObjLarg := 80
        nObjAltu := 20
        oSay22L  := TSay():New(nObjLinh, nObjColu, {|| cSay22LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay22L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 450
        nObjLarg := 50
        nObjAltu := 15
        oGet22L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet22LL := u, xGet22LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 510
        nObjLarg := 80
        nObjAltu := 20
        oSay23L  := TSay():New(nObjLinh, nObjColu, {|| cSay23LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay23L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 510
        nObjLarg := 50
        nObjAltu := 15
        oCombo23L   := TComboBox():New(nObjLinh, nObjColu,,aCombo23L, nObjLarg, nObjAltu, oDlgCadL,,{||},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 570
        nObjLarg := 80
        nObjAltu := 20
        oSay24L  := TSay():New(nObjLinh, nObjColu, {|| cSay24LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay24L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 155
        nObjColu := 570
        nObjLarg := 80
        nObjAltu := 15
        oGet24L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet24LL := u, xGet24LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet24L:lActive := .F.

        oMsGetZCA := MsNewGetDados():New(180,005,443,950,,,,,,,999,,,,oDlgCadL,aHeaderL,aColsL)

        oDlgCadL:Activate()

FwRestArea(aArea)

return 

Static function incBtnMLP()

 Local aArea := FWGetArea()
    Local cAlias := 'ZM2'
    Local lEscolha := .F.

// -------------------------------------------------------------------------------
// 
//              BOTÃO CADASTRO MANUTENÇÃO LAMPADAS - GABRIEL
// 
// -------------------------------------------------------------------------------

        lEscolha := MsgYesNo('DESEJA CONFIRMAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            if Empty(oGet3L:BUFFER) .OR. Empty(oGet5L:BUFFER) .OR. Empty(oGet6L:BUFFER) .OR. Empty(oGet9L:BUFFER) .OR. Empty(oGet10L:BUFFER) ;
          .OR. Empty(oGet11L:BUFFER) .OR. Empty(oGet12L:BUFFER)  .OR. Empty(oGet13L:BUFFER) .OR. Empty(oGet14L:BUFFER) .OR. Empty(oGet15L:BUFFER) ;
          .OR. Empty(oGet16L:BUFFER) .OR. Empty(oGet17L:BUFFER) .OR. Empty(oGet18L:BUFFER) .OR. Empty(oGet19L:BUFFER) .OR. Empty(oGet20L:BUFFER) ;
          .OR. Empty(oGet21L:BUFFER) .OR. Empty(oGet22L:BUFFER)
                MSGALERT('HÁ ALGUM CAMPO SEM DIGITAÇÃO','ATENÇÃO')
            ELSEIF  IsAlpha(oGet10L:BUFFER) .OR. IsAlpha(oGet11L:BUFFER) .OR. IsAlpha(oGet12L:BUFFER) .OR. IsAlpha(oGet13L:BUFFER) .OR. IsAlpha(oGet14L:BUFFER);
               .OR. IsAlpha(oGet15L:BUFFER) .OR. IsAlpha(oGet16L:BUFFER) .OR. IsAlpha(oGet17L:BUFFER) .OR. IsAlpha(oGet18L:BUFFER) .OR. IsAlpha(oGet19L:BUFFER);
               .OR. IsAlpha(oGet20L:BUFFER) .OR. IsAlpha(oGet21L:BUFFER)
                MsgAlert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS','ATENÇÃO')
            elseif  oCombo7L:Nat == 0 .OR. oCombo8L:Nat == 0
                MsgAlert('CAMPO ATIVO SEM ESCOLHA','ATENÇÃO') 
            else
            begin transaction 
            RecLock(cAlias, .T.)
                ZM2->ZM2_COD       := Alltrim(oGet2L:BUFFER)
                ZM2->ZM2_IMPRES    := Alltrim(oGet3L:BUFFER)
                ZM2->ZM2_USU       := Alltrim(oGet4L:BUFFER)
                ZM2->ZM2_DATAM     :=    CTOD(oGet5L:BUFFER)
                ZM2->ZM2_LAMP      := AllTrim(oGet6L:BUFFER)
                if oCombo7L:NAT == 2
                        ZM2->ZM2_TROCLP := oCombo7L:AITEMS[2]
                    elseif oCombo7L:NAT == 3
                        ZM2->ZM2_TROCLP := oCombo7L:AITEMS[3]
                    elseif oCombo7L:nat == 1 .OR. oCombo7L:nat == 0
                        MsgAlert('POR FAVOR ESCOLHA UMA OPÇÃO VALIDA NO CAMPO ATIVO!!(SIM/NAO)', 'ATENÇÃO')
                        DisarmTransaction()
                        return
                ENDIF
                if oCombo8L:NAT == 2
                        ZM2->ZM2_TROCRL := oCombo8L:AITEMS[2]
                    elseif oCombo8L:NAT == 3
                        ZM2->ZM2_TROCRL := oCombo8L:AITEMS[3]
                    elseif oCombo8L:nat == 1 .OR. oCombo8L:nat == 0
                        MsgAlert('POR FAVOR ESCOLHA UMA OPÇÃO VALIDA NO CAMPO ATIVO!!(SIM/NAO)', 'ATENÇÃO')
                        DisarmTransaction()
                        return
                ENDIF
                ZM2->ZM2_MATER     := Alltrim(oGet9L:BUFFER)
                ZM2->ZM2_TEMPM     := Alltrim(oGet10L:BUFFER)
                ZM2->ZM2_UMIDAD    := AllTrim(oGet11L:BUFFER)
                ZM2->ZM2_TEMPA     := AllTrim(oGet12L:BUFFER)
                ZM2->ZM2_TEMPD     := AllTrim(oGet13L:BUFFER)
                ZM2->ZM2_TEMPR     := Alltrim(oGet14L:BUFFER)
                ZM2->ZM2_TENS      := Alltrim(oGet15L:BUFFER)
                ZM2->ZM2_HORIME    := Alltrim(oGet16L:BUFFER)
                ZM2->ZM2_START     := Alltrim(oGet17L:BUFFER)
                ZM2->ZM2_CORR      := Alltrim(oGet18L:BUFFER)
                ZM2->ZM2_TEMPT     := Alltrim(oGet19L:BUFFER)
                ZM2->ZM2_SETP      := Alltrim(oGet20L:BUFFER)
                ZM2->ZM2_POT       := Alltrim(oGet21L:BUFFER)
                ZM2->ZM2_OBS       := Alltrim(oGet22L:BUFFER)
                if oCombo23L:NAT == 2
                        ZM2->ZM2_ATIVO := oCombo23L:AITEMS[2]
                    elseif oCombo23L:NAT == 3
                        ZM2->ZM2_ATIVO := oCombo23L:AITEMS[3]
                    elseif oCombo23L:nat == 1 .OR. oCombo23L:nat == 0
                        MsgAlert('POR FAVOR ESCOLHA UMA OPÇÃO VALIDA NO CAMPO ATIVO!!(SIM/NAO)', 'ATENÇÃO')
                        DisarmTransaction()
                        return
                ENDIF
                ZM2->ZM2_DATAC     := CTOD(oGet24L:BUFFER)
            ZM2 -> (MSUNLOCK())
            end transaction
                MsgInfo('CADASTRO FEITO COM SUCESSO!!','ATENÇÃO')

            lEsc := MsgYesNo('CONTINUAR COM AS MESMAS INFORMAÇÕES?','ATENÇÃO')

            if lEsc == .F.
                geraCodM()
                oGet2L:BUFFER   := Space(TamSX3('ZM2_COD')[1])
                oGet3L:BUFFER   := Space(TamSX3('ZM2_IMPRES')[1])
                oGet6L:BUFFER   := Space(TamSX3('ZM2_LAMP')[1])
                oGet9L:BUFFER   := Space(TamSX3('ZM2_MATER')[1])
                oGet10L:BUFFER  := Space(TamSX3('ZM2_TEMPM')[1])
                oGet11L:BUFFER  := Space(TamSX3('ZM2_UMIDAD')[1])
                oGet12L:BUFFER  := Space(TamSX3('ZM2_TEMPA')[1])
                oGet13L:BUFFER  := Space(TamSX3('ZM2_TEMPD')[1])
                oGet14L:BUFFER  := Space(TamSX3('ZM2_TEMPR')[1])
                oGet15L:BUFFER  := Space(TamSX3('ZM2_TENS')[1])
                oGet16L:BUFFER  := Space(TamSX3('ZM2_HORIME')[1])
                oGet17L:BUFFER  := Space(TamSX3('ZM2_START')[1])
                oGet18L:BUFFER  := Space(TamSX3('ZM2_CORR')[1])
                oGet19L:BUFFER  := Space(TamSX3('ZM2_TEMPT')[1])
                oGet20L:BUFFER  := Space(TamSX3('ZM2_SETP')[1])
                oGet21L:BUFFER  := Space(TamSX3('ZM2_POT')[1])
                oGet22L:BUFFER  := Space(TamSX3('ZM2_OBS')[1])

            
            ENDIF
            
            MLPfCarAcols()
            oMsGetZCA:ACOLS := aColsL
            oMsGetZCA:oBrowse:Refresh()
            geraCodM()
            
            endif
        else
            MsgInfo('NENHUMA ALTERAÇÃO EFETUADA')
        ENDIF

    FWRestArea(aArea)
return 

User Function altMLP()

    Local aArea         := FWGetArea()
    Local aFieldsL       := {}
    Local oTableTempAltL 
    Local cAliasTempAltL := GetNextAlias()
    Local cNameTableL    := ''
    Private aDadosAltL   := {}

    Private aCombo7L     := {'S=SIM','N=NAO'}   
    Private aCombo8L     := {'S=SIM','N=NAO'}  
    Private aCombo23L    := {'S=SIM','N=NAO'}  

        oTableTempAltL  := FWTemporaryTable():New(cAliasTempAltL)

        AADD(aFieldsL,{'COD_ALL'       , "C", 6, 0})
        AADD(aFieldsL,{'COD_ALTL'      , "C", 6, 0})
        AADD(aFieldsL,{'IMP_ALTL'      , "C",50, 0})
        AADD(aFieldsL,{'USU_ALTL'      , "C",50, 0})
        AADD(aFieldsL,{'DATAM_ALTL'    , "D", 8, 0})
        AADD(aFieldsL,{'LAMP_ALTL'     , "C",50, 0})
        AADD(aFieldsL,{'TROLP_ALTL'   , "C", 1, 0})
        AADD(aFieldsL,{'TROLP_NAT'    , "C", 1, 0})
        AADD(aFieldsL,{'TRORL_ALTL'   , "C", 1, 0})
        AADD(aFieldsL,{'TRORL_NAT'    , "C", 1, 0})
        AADD(aFieldsL,{'MATER_ALTL'    , "C",50, 0})
        AADD(aFieldsL,{'TEMPM_ALTL'    , "C", 10, 0})
        AADD(aFieldsL,{'UMIDA_ALTL'   , "C", 10, 0})
        AADD(aFieldsL,{'TEMPA_ALTL'    , "C", 10, 0})
        AADD(aFieldsL,{'TEMPD_ALTL'    , "C", 10, 0})
        AADD(aFieldsL,{'TEMPR_ALTL'    , "C", 10, 0})
        AADD(aFieldsL,{'TENS_ALTL'     , "C", 10, 0})
        AADD(aFieldsL,{'HORIM_ALTL'   , "C", 10, 0})
        AADD(aFieldsL,{'START_ALTL'    , "C", 10, 0})
        AADD(aFieldsL,{'CORR_ALTL'     , "C", 10, 0})
        AADD(aFieldsL,{'TEMPT_ALTL'    , "C", 10, 0})
        AADD(aFieldsL,{'SETP_ALTL'     , "C", 10, 0})
        AADD(aFieldsL,{'POT_ALTL'      , "C", 10, 0})
        AADD(aFieldsL,{'OBS_ALTL'      , "C",100, 0})
        AADD(aFieldsL,{'ATIVO_ALTL'    , "C",  1, 0})
        AADD(aFieldsL,{'ATIVO_NAT'     , "C",  1, 0})
        AADD(aFieldsL,{'DATAC_ALTL'    , "D",  8, 0})
        
        oTableTempAltL:SetFields(aFieldsL)
        oTableTempExcL:AddIndex('1',{'COD_ALL','COD_ALTL'})

        oTableTempAltL:Create()

        cNameTableL := oTableTempAltL:GetRealName()

        DbSelectArea('ZM2')

            RecLock(cAliasTempAltL, .T.)
                (cAliasTempAltL) -> (COD_ALTL)     := ZM2 -> (ZM2_COD)
                (cAliasTempAltL) -> (IMP_ALTL)     := ZM2 -> (ZM2_IMPRES)
                (cAliasTempAltL) -> (USU_ALTL)     := ZM2 -> (ZM2_USU)
                (cAliasTempAltL) -> (DATAM_ALTL)   := ZM2 -> (ZM2_DATAM)
                (cAliasTempAltL) -> (LAMP_ALTL)    := ZM2 -> (ZM2_LAMP)
                (cAliasTempAltL) -> (TROLP_ALTL)    := ZM2 -> (ZM2_TROCLP)
                if (cAliasTempAltL) -> (TROLP_ALTL) == 'S'
                    (cAliasTempAltL) -> (TROLP_NAT):= "1"
                    aCombo7L := {'S=SIM','N=NAO'}
                elseif (cAliasTempAltL) -> (TROLP_ALTL) == 'N'
                    (cAliasTempAltL) -> (TROLP_NAT):= "1"
                    aCombo7L := {'N=NAO','S=SIM'}
                endif
                (cAliasTempAltL) -> (TRORL_ALTL)    := ZM2 -> (ZM2_TROCRL)
                if (cAliasTempAltL) -> (TRORL_ALTL) == 'S'
                    (cAliasTempAltL) -> (TRORL_NAT):= "1"
                    aCombo8L := {'S=SIM','N=NAO'}
                elseif (cAliasTempAltL) -> (TRORL_ALTL) == 'N'
                    (cAliasTempAltL) -> (TRORL_NAT):= "1"
                    aCombo8L := {'N=NAO','S=SIM'}
                endif
                (cAliasTempAltL) -> (MATER_ALTL)     := ZM2 -> (ZM2_MATER)
                (cAliasTempAltL) -> (TEMPM_ALTL)     := ZM2 -> (ZM2_TEMPM)
                (cAliasTempAltL) -> (UMIDA_ALTL)    := ZM2 -> (ZM2_UMIDAD)
                (cAliasTempAltL) -> (TEMPA_ALTL)     := ZM2 -> (ZM2_TEMPA)
                (cAliasTempAltL) -> (TEMPD_ALTL)     := ZM2 -> (ZM2_TEMPD)
                (cAliasTempAltL) -> (TEMPR_ALTL)     := ZM2 -> (ZM2_TEMPR)
                (cAliasTempAltL) -> (TENS_ALTL)      := ZM2 -> (ZM2_TENS)
                (cAliasTempAltL) -> (HORIM_ALTL)    := ZM2 -> (ZM2_HORIME)
                (cAliasTempAltL) -> (START_ALTL)     := ZM2 -> (ZM2_START)
                (cAliasTempAltL) -> (CORR_ALTL)      := ZM2 -> (ZM2_CORR)
                (cAliasTempAltL) -> (TEMPT_ALTL)     := ZM2 -> (ZM2_TEMPT)
                (cAliasTempAltL) -> (SETP_ALTL)      := ZM2 -> (ZM2_SETP)
                (cAliasTempAltL) -> (POT_ALTL)       := ZM2 -> (ZM2_POT)
                (cAliasTempAltL) -> (OBS_ALTL)       := ZM2 -> (ZM2_OBS)
                (cAliasTempAltL) -> (ATIVO_ALTL)    := ZM2 -> (ZM2_ATIVO)
                if (cAliasTempAltL) -> (ATIVO_ALTL) == 'S'
                    (cAliasTempAltL) -> (ATIVO_NAT):= "1"
                    aCombo24L := {'S=SIM','N=NAO'}
                elseif (cAliasTempAltL) -> (ATIVO_ALTL) == 'N'
                    (cAliasTempAltL) -> (ATIVO_NAT):= "1"
                    aCombo24L := {'N=NAO','S=SIM'}
                endif
                (cAliasTempAltL) -> (DATAC_ALTL)     := ZM2 -> (ZM2_DATAC)
            (cAliasTempAltL) -> (MSUNLOCK())

        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(COD_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(IMP_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(USU_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) ->    (DTOC(DATAM_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(LAMP_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TROLP_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TROLP_NAT))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TRORL_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TRORL_NAT))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(MATER_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TEMPM_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(UMIDA_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TEMPA_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TEMPD_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TEMPR_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TENS_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(HORIM_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(START_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(CORR_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(TEMPT_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(SETP_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(POT_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(OBS_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(ATIVO_ALTL))})
        AADD(aDadosAltL,{(cAliasTempAltL) -> (AllTrim(ATIVO_NAT))})
        AADD(aDadosAltL,{(cAliasTempAltL) ->    (DTOC(DATAC_ALTL))})

        oTableTempAlt:Delete()

        dialogAltL(aDadosAltL)
        
    FWRestArea(aArea)

return

Static function dialogAltL(aDadosAltL)

    Local aArea         := FwGetArea()
    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''

    Private aHeaderL    := {}
    Private aColsL      := {}

    Private oSay1L
    Private cSay1LL     := "MANUTENÇÃO DE LAMPADAS - CADASTRAMENTO"
    Private oBtn1L
    Private cBtn1LL     := 'FECHAR'
    Private oBtn2L
    Private cBtn2LL     := 'ALTERAR'

    Private oSay2L
    Private cSay2LL     := 'Código'
    Private oGet2L
    Private xGet2LL     

    Private oSay3L
    Private cSay3LL     := 'Impressora'
    Private oGet3L
    Private cGet3LL     := ''

    Private oSay4L
    Private cCod        := RetCodUsr()
    Private cNome       := ''
    Private cSay4LL     := 'Usuario'
    Private oGet4L
    Private xGet4LL     

    Private oSay5L
    Private cSay5LL     := 'Data Manutenção'
    Private oGet5L
    Private xGet5LL    

    Private oSay6L
    Private cSay6LL     := 'Lâmpada'
    Private oGet6L
    Private cGet6LL     := ''

    Private oSay7L
    Private cSay7LL    := 'Troca Lâmpada'
    Private cCombo7L    
    Private oCombo7L 

    Private oSay8L
    Private cSay8LL    := 'Troca Refletor'
    Private cCombo8L    
    Private oCombo8L    

    Private oSay9L
    Private cSay9LL    := 'Material'
    Private oGet9L
    Private xGet9LL    

    Private oSay10L
    Private cSay10LL    := 'Temp. Ambiente'
    Private oGet10L
    Private xGet10LL    

    Private oSay11L
    Private cSay11LL     := 'Umidade Relativa(%)'
    Private oGet11L
    Private xGeT11LL     

    Private oSay12L
    Private cSay12LL    := 'Temp. Antes Lâmpada'
    Private oGet12L
    Private xGet12LL     

    Private oSay13L
    Private cSay13LL    := 'Temp. Depois Lâmpada'
    Private oGet13L
    Private xGet13LL    

    Private oSay14L
    Private cSay14LL    := 'Temp. Refrigeração IST'
    Private oGet14L
    Private xGet14LL     

    Private oSay15L
    Private cSay15LL    := 'Tensão Principal'
    Private oGet15L
    Private xGet15LL     

    Private oSay16L
    Private cSay16LL    := 'Horimetro (Horas)'
    Private oGet16L
    Private xGet16LL     

    Private oSay17L
    Private cSay17LL    := 'Inicio (StartUps)'
    Private oGet17L
    Private xGet17LL     

    Private oSay18L
    Private cSay18LL    := 'Corrente (A)'
    Private oGet18L
    Private xGet18LL    

    Private oSay19L
    Private cSay19LL    := 'Temp. Trabalho(°C)'
    Private oGet19L
    Private xGet19LL     

    Private oSay20L
    Private cSay20LL    := 'Set Point (%)'
    Private oGet20L
    Private xGet20LL     

    Private oSay21L
    Private cSay21LL    := 'Potencia (mWcm2)'
    Private oGet21L
    Private xGet21LL     
    
    Private oSay22L
    Private cSay22LL    := 'Observação'
    Private oGet22L
    Private xGet22LL     

    Private oSay23L
    Private cSay23LL    := 'Ativo'
    Private oCombo23L   

    Private oSay24L
    Private cSay24LL    := 'Data'
    Private oGet24L
    Private xGet24LL     

    Private oDlgAltL

    nEscL := 8 

    nEscBD := 3

        cJanTitulo := 'MANUTENÇÃO DE LAMPADAS - ALTERAÇÃO'
        oDlgCadL := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgCadL, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1MM  := 'MANUTENÇÃO DE LAMPADAS - ALTERÇÃO'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1M := TSay():New(nObjLinh, nObjColu, {|| cSay1LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1L   := TButton():New(nObjLinh, nObjColu, cBtn1LL,oDlgCadL ,{|| oDlgCadL:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    
                
        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2L   := TButton():New(nObjLinh, nObjColu, cBtn2LL, oDlgCadL,{|| altbtnMLP()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgCadL, , , lDimPixels)
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2L   := TSay():New(nObjLinh, nObjColu, {|| cSay2LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2L:SetCss(" TSay {Font: Semi-Bold}")

        DbSelectArea('ZM2')

        geraCodM()

        oFontPadrao  := TFont():New(cFont, , -16)
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2L   := TGet():New(nObjLinh, nObjColu, {||xGet2LL}, oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        ZM2->(DbCloseArea())

        oGet2L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 80
        nObjAltu := 20
        oSay3L   := TSay():New(nObjLinh, nObjColu, {|| cSay3LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cGet3LL := aDadosAltL[2][1]
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        lHasButton := .T.
        oGet3L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet3LL := u, cGet3LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet3L:cF3 := 'U_zConsImp()' //puxar função que ira fazer a consulta especifica
        oGet3L:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4L   := TSay():New(nObjLinh, nObjColu, {|| cSay4LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4LL := aDadosAltL[3][1]
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        cNome := Alltrim(UsrRetName(cCod))
        xGet4LL := Alltrim(cNome)
        oGet4L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet4LL := u, xGet4LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet4L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5L   := TSay():New(nObjLinh, nObjColu, {|| cSay5LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet5LL := CTOD(aDadosAltL[4][1])
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        oGet5L := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet5LL := u, xGet5LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet5L:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6L   := TSay():New(nObjLinh, nObjColu, {|| cSay6LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cGet6LL := aDadosAltL[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        lHasButton := .T.
        oGet6L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , cGet6LL := u, cGet6LL)} , oDlgCadL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet6L:cF3 := 'U_zConsLp()' //puxar função que ira fazer a consulta especifica
        oGet6L:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay7L   := TSay():New(nObjLinh, nObjColu, {|| cSay7LL}, oDlgCadL,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay7L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo7LL := aDadosAltL[6][1]
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oCombo7L   := TComboBox():New(nObjLinh, nObjColu,,aCombo7L, nObjLarg, nObjAltu, oDlgCadL,,{||cCombo7LL},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu:= 20
        oSay8L   := TSay():New(nObjLinh, nObjColu, {|| cSay8LL}, oDlgCadL,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay8L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo8LL := aDadosAltL[8][1]
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        oCombo8L   := TComboBox():New(nObjLinh, nObjColu,,aCombo8L, nObjLarg, nObjAltu, oDlgCadL,,{||cCombo8LL},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay9L   := TSay():New(nObjLinh, nObjColu, {|| cSay9LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet9LL := aDadosAltL[10][1]
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet9L  := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet9LL := u, xGet9LL)} , oDlgCadL, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 20
        oSay10L   := TSay():New(nObjLinh, nObjColu, {|| cSay10LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet10LL := aDadosAltL[11][1]
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 15
        oGet10L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet10LL := u, xGet10LL)} , oDlgCadL, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 80
        nObjAltu := 20
        oSay11L   := TSay():New(nObjLinh, nObjColu, {|| cSay11LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet11LL := aDadosAltL[12][1]
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 15
        oGet11L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet11LL := u, xGet11LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 500
        nObjLarg := 80
        nObjAltu := 20
        oSay12L  := TSay():New(nObjLinh, nObjColu, {|| cSay12LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet12LL := aDadosAltL[13][1]
        nObjLinh := 125
        nObjColu := 500
        nObjLarg := 80
        nObjAltu := 15
        oGet12L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet12LL := u, xGet12LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 595
        nObjLarg := 80
        nObjAltu := 20
        oSay13L  := TSay():New(nObjLinh, nObjColu, {|| cSay13LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay13L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet13LL := aDadosAltL[14][1]
        nObjLinh := 125
        nObjColu := 595
        nObjLarg := 80
        nObjAltu := 15
        oGet13L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet13LL := u, xGet13LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 685
        nObjLarg := 80
        nObjAltu := 20
        oSay14L  := TSay():New(nObjLinh, nObjColu, {|| cSay14LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay14L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet14LL := aDadosAltL[15][1]
        nObjLinh := 125
        nObjColu := 685
        nObjLarg := 50
        nObjAltu := 15
        oGet14L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet14LL := u, xGet14LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 25
        nObjLarg := 80
        nObjAltu := 20
        oSay15L  := TSay():New(nObjLinh, nObjColu, {|| cSay15LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay15L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet15LL := aDadosAltL[16][1]
        nObjLinh := 155
        nObjColu := 25
        nObjLarg := 50
        nObjAltu := 15
        oGet15L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet15LL := u, xGet15LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 90
        nObjLarg := 80
        nObjAltu := 20
        oSay16L  := TSay():New(nObjLinh, nObjColu, {|| cSay16LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay16L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet16LL := aDadosAltL[17][1]
        nObjLinh := 155
        nObjColu := 90
        nObjLarg := 50
        nObjAltu := 15
        oGet16L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet16LL := u, xGet16LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 150
        nObjLarg := 80
        nObjAltu := 20
        oSay17L  := TSay():New(nObjLinh, nObjColu, {|| cSay17LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay17L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet17LL := aDadosAltL[18][1]
        nObjLinh := 155
        nObjColu := 150
        nObjLarg := 50
        nObjAltu := 15
        oGet17L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet17LL := u, xGet17LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 210
        nObjLarg := 80
        nObjAltu := 20
        oSay18L  := TSay():New(nObjLinh, nObjColu, {|| cSay18LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay18L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet18LL := aDadosAltL[19][1]
        nObjLinh := 155
        nObjColu := 210
        nObjLarg := 50
        nObjAltu := 15
        oGet18L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet18LL := u, xGet18LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 270
        nObjLarg := 80
        nObjAltu := 20
        oSay19L  := TSay():New(nObjLinh, nObjColu, {|| cSay19LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay19L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet19LL := aDadosAltL[20][1]
        nObjLinh := 155
        nObjColu := 270
        nObjLarg := 50
        nObjAltu := 15
        oGet19L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet19LL := u, xGet19LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 330
        nObjLarg := 80
        nObjAltu := 20
        oSay20L  := TSay():New(nObjLinh, nObjColu, {|| cSay20LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay20L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet20LL := aDadosAltL[21][1]
        nObjLinh := 155
        nObjColu := 330
        nObjLarg := 50
        nObjAltu := 15
        oGet20L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet20LL := u, xGet20LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 390
        nObjLarg := 80
        nObjAltu := 20
        oSay21L  := TSay():New(nObjLinh, nObjColu, {|| cSay21LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay21L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet21LL := aDadosAltL[22][1]
        nObjLinh := 155
        nObjColu := 390
        nObjLarg := 50
        nObjAltu := 15
        oGet21L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet21LL := u, xGet21LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

         oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 450
        nObjLarg := 80
        nObjAltu := 20
        oSay22L  := TSay():New(nObjLinh, nObjColu, {|| cSay22LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay22L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet22LL := aDadosAltL[23][1]
        nObjLinh := 155
        nObjColu := 450
        nObjLarg := 50
        nObjAltu := 15
        oGet22L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet22LL := u, xGet22LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 510
        nObjLarg := 80
        nObjAltu := 20
        oSay23L  := TSay():New(nObjLinh, nObjColu, {|| cSay23LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay23L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo23LL := aDadosAltL[24][1]
        nObjLinh := 155
        nObjColu := 510
        nObjLarg := 50
        nObjAltu := 15
        oCombo23L   := TComboBox():New(nObjLinh, nObjColu,,aCombo23L, nObjLarg, nObjAltu, oDlgCadL,,{||cCombo23LL},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 570
        nObjLarg := 80
        nObjAltu := 20
        oSay24L  := TSay():New(nObjLinh, nObjColu, {|| cSay24LL}, oDlgCadL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay24L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet24LL := aDadosAltL[26][1]
        nObjLinh := 155
        nObjColu := 570
        nObjLarg := 80
        nObjAltu := 15
        oGet24L   := TGet():New(nObjLinh, nObjColu,{|u| Iif(PCount() > 0 , xGet24LL := u, xGet24LL)} , oDlgCadL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet24L:lActive := .F.

        oDlgCadL:Activate()

FwRestArea(aArea)

return

Static function altbtnMLP()

    Local aArea := FWGetArea()
    Local cAlias := 'ZM2'

    lEscolha := MsgYesNo('DESEJA  ALTERAR O CADASTRO?','ATENÇÃO')
    
        if lEscolha = .T.

            DbSelectArea(cAlias)

            // REFAZER 
            // if (oGet2M:BUFFER == aDadosAltM[1][1]) .AND. (oGet3M:BUFFER == aDadosAltM[2][1]) .AND. (oGet4M:BUFFER == aDadosAltM[3][1]) .AND. (oGet6M:BUFFER == aDadosAltM[5][1]) .AND. (oGet7M:BUFFER == aDadosAltM[6][1]) .AND. (oGet8M:BUFFER == aDadosAltM[7][1]) .AND. (oGet9M:BUFFER == aDadosAltM[8][1]) .AND.(oCombo11M:Nat == 0 .OR. oCombo11M:Nat == Val(aDadosAltM[10][1])) .AND. (oGet12M:BUFFER == aDadosAltM[12][1])
            //     ALERT('VOCE NÃO MUDOU NADA NOS CAMPOS!!','ATENÇÃO')
            If Empty(oGet3L:BUFFER) .OR. Empty(oGet5L:BUFFER) .OR. Empty(oGet6L:BUFFER) .OR. Empty(oGet9L:BUFFER) .OR. Empty(oGet10L:BUFFER) ;
          .OR. Empty(oGet11L:BUFFER) .OR. Empty(oGet12L:BUFFER)  .OR. Empty(oGet13L:BUFFER) .OR. Empty(oGet14L:BUFFER) .OR. Empty(oGet15L:BUFFER) ;
          .OR. Empty(oGet16L:BUFFER) .OR. Empty(oGet17L:BUFFER) .OR. Empty(oGet18L:BUFFER) .OR. Empty(oGet19L:BUFFER) .OR. Empty(oGet20L:BUFFER) ;
          .OR. Empty(oGet21L:BUFFER) .OR. Empty(oGet22L:BUFFER)
                MSGALERT('HÁ ALGUM CAMPO SEM DIGITAÇÃO','ATENÇÃO')
            ELSEIF  IsAlpha(oGet10L:BUFFER) .OR. IsAlpha(oGet11L:BUFFER) .OR. IsAlpha(oGet12L:BUFFER) .OR. IsAlpha(oGet13L:BUFFER) .OR. IsAlpha(oGet14L:BUFFER);
               .OR. IsAlpha(oGet15L:BUFFER) .OR. IsAlpha(oGet16L:BUFFER) .OR. IsAlpha(oGet17L:BUFFER) .OR. IsAlpha(oGet18L:BUFFER) .OR. IsAlpha(oGet19L:BUFFER);
               .OR. IsAlpha(oGet20L:BUFFER) .OR. IsAlpha(oGet21L:BUFFER)
                MsgAlert('HÁ LETRAS EM CAMPOS QUE PRECISAM SER PREENCHIDOS POR NUMEROS','ATENÇÃO')
            else
            begin transaction 
            RecLock(cAlias, .F.)
                ZM2->ZM2_COD       := Alltrim(oGet2L:BUFFER)
                ZM2->ZM2_IMPRES    := Alltrim(oGet3L:BUFFER)
                ZM2->ZM2_USU       := Alltrim(oGet4L:BUFFER)
                ZM2->ZM2_DATAM     :=    CTOD(oGet5L:BUFFER)
                ZM2->ZM2_LAMP      := AllTrim(oGet6L:BUFFER)
                if oCombo7L:NAT == 1 .OR. oCombo7L:NAT == 0
                    ZM2->ZM2_TROCLP := oCombo7L:AITEMS[1]
                elseif oCombo7L:NAT == 2
                    ZM2->ZM2_TROCLP := oCombo7L:AITEMS[2]
                ENDIF
                if oCombo8L:NAT == 1 .OR. oCombo8L:NAT == 0
                    ZM2->ZM2_TROCRL := oCombo8L:AITEMS[1]
                elseif oCombo8L:NAT == 2
                    ZM2->ZM2_TROCRL := oCombo8L:AITEMS[2]
                ENDIF
                ZM2->ZM2_MATER     := Alltrim(oGet9L:BUFFER)
                ZM2->ZM2_TEMPM     := Alltrim(oGet10L:BUFFER)
                ZM2->ZM2_UMIDAD    := AllTrim(oGet11L:BUFFER)
                ZM2->ZM2_TEMPA     := AllTrim(oGet12L:BUFFER)
                ZM2->ZM2_TEMPD     := AllTrim(oGet13L:BUFFER)
                ZM2->ZM2_TEMPR     := Alltrim(oGet14L:BUFFER)
                ZM2->ZM2_TENS      := Alltrim(oGet15L:BUFFER)
                ZM2->ZM2_HORIME    := Alltrim(oGet16L:BUFFER)
                ZM2->ZM2_START     := Alltrim(oGet17L:BUFFER)
                ZM2->ZM2_CORR      := Alltrim(oGet18L:BUFFER)
                ZM2->ZM2_TEMPT     := Alltrim(oGet19L:BUFFER)
                ZM2->ZM2_SETP      := Alltrim(oGet20L:BUFFER)
                ZM2->ZM2_POT       := Alltrim(oGet21L:BUFFER)
                ZM2->ZM2_OBS       := Alltrim(oGet22L:BUFFER)
                if oCombo23L:NAT == 1 .OR. oCombo23L:NAT == 0
                    ZM2->ZM2_ATIVO := oCombo23L:AITEMS[1]
                elseif oCombo23L:NAT == 2
                    ZM2->ZM2_ATIVO := oCombo23L:AITEMS[2]
                ENDIF
                ZM2->ZM2_DATAC     := CTOD(oGet24L:BUFFER)
            ZM2 -> (MSUNLOCK())
            end transaction
            MsgInfo('CADASTRO FEITO COM SUCESSO!!','ATENÇÃO')

            lEsc := MsgYesNo('Deseja Ir para o Menu Principal?(YES/NO)')
                if lEsc == .T.
                    oDlgAltL:End()
                else
                    oGet3L:lActive    := .F.
                    oGet4L:lActive    := .F.
                    oGet5L:lActive    := .F.
                    oGet6L:lActive    := .F.
                    oCombo7L:lActive  := .F.
                    oCombo8L:lActive  := .F.
                    oGet9L:lActive    := .F.
                    oGet10L:lActive   := .F.
                    oGet11L:lActive   := .F.
                    oGet12L:lActive   := .F.
                    oGet13L:lActive   := .F.
                    oGet14L:lActive   := .F.
                    oGet15L:lActive   := .F.
                    oGet16L:lActive   := .F.
                    oGet17L:lActive   := .F.
                    oGet18L:lActive   := .F.
                    oGet19L:lActive   := .F.
                    oGet20L:lActive   := .F.
                    oGet21L:lActive   := .F.
                    oGet22L:lActive   := .F.
                    oCombo23L:lActive := .F.
                    oGet24L:lActive   := .F.
                    oBtn2L:lActive    := .F.
            endif
            endif
        else
            MsgInfo('NENHUMA ALTERAÇÃO EFETUADA')
        ENDIF

    FwRestArea(aArea)

return

User function excMLP()
    Local aArea         := FWGetArea()
    Local aFieldsL       := {}
    Local oTableTempMLP 
    Local cAliasTempExcL := GetNextAlias()
    Local cNameTableL    := ''
    Private aDadosExcL   := {}

    Private aCombo7L     := {'S=SIM','N=NAO'}   
    Private aCombo8L     := {'S=SIM','N=NAO'}  
    Private aCombo23L    := {'S=SIM','N=NAO'}  

        oTableTempMLP  := FWTemporaryTable():New(cAliasTempExcL)

        AADD(aFieldsL,{'COD_ALL'    , "C",  6, 0})
        AADD(aFieldsL,{'COD_L'      , "C",  6, 0})
        AADD(aFieldsL,{'IMP_L'      , "C", 50, 0})
        AADD(aFieldsL,{'USU_L'      , "C", 50, 0})
        AADD(aFieldsL,{'DATAM_L'    , "D",  8, 0})
        AADD(aFieldsL,{'LAMP_L'     , "C", 50, 0})
        AADD(aFieldsL,{'TROLP_L'    , "C",  1, 0})
        AADD(aFieldsL,{'TROLP_NAT'  , "C",  1, 0})
        AADD(aFieldsL,{'TRORL_L'    , "C",  1, 0})
        AADD(aFieldsL,{'TRORL_NAT'  , "C",  1, 0})
        AADD(aFieldsL,{'MATER_L'    , "C", 50, 0})
        AADD(aFieldsL,{'TEMPM_L'    , "C", 10, 0})
        AADD(aFieldsL,{'UMIDA_L'    , "C", 10, 0})
        AADD(aFieldsL,{'TEMPA_L'    , "C", 10, 0})
        AADD(aFieldsL,{'TEMPD_L'    , "C", 10, 0})
        AADD(aFieldsL,{'TEMPR_L'    , "C", 10, 0})
        AADD(aFieldsL,{'TENS_L'     , "C", 10, 0})
        AADD(aFieldsL,{'HORIM_L'    , "C", 10, 0})
        AADD(aFieldsL,{'STAT_L'     , "C", 10, 0})
        AADD(aFieldsL,{'CORR_L'     , "C", 10, 0})
        AADD(aFieldsL,{'TEMPT_L'    , "C", 10, 0})
        AADD(aFieldsL,{'SETP_L'     , "C", 10, 0})
        AADD(aFieldsL,{'POT_L'      , "C", 10, 0})
        AADD(aFieldsL,{'OBS_L'      , "C",100, 0})
        AADD(aFieldsL,{'ATIVO_L'    , "C",  1, 0})
        AADD(aFieldsL,{'ATIVO_NAT'  , "C",  1, 0})
        AADD(aFieldsL,{'DATAC_L'    , "D",  8, 0})
        
        oTableTempMLP:SetFields(aFieldsL)
        oTableTempMLP:AddIndex('1',{'COD_ALL','COD_L'})

        oTableTempMLP:Create()

        cNameTableL := oTableTempMLP:GetRealName()

        DbSelectArea('ZM2')

            RecLock(cAliasTempExcL, .T.)
                (cAliasTempExcL) -> (COD_L)     := ZM2 -> (ZM2_COD)
                (cAliasTempExcL) -> (IMP_L)     := ZM2 -> (ZM2_IMPRES)
                (cAliasTempExcL) -> (USU_L)     := ZM2 -> (ZM2_USU)
                (cAliasTempExcL) -> (DATAM_L)   := ZM2 -> (ZM2_DATAM)
                (cAliasTempExcL) -> (LAMP_L)    := ZM2 -> (ZM2_LAMP)
                (cAliasTempExcL) -> (TROLP_L)    := ZM2 -> (ZM2_TROCLP)
                if (cAliasTempExcL) -> (TROLP_L) == 'S'
                    (cAliasTempExcL) -> (TROLP_NAT):= "1"
                    aCombo7L := {'S=SIM','N=NAO'}
                elseif (cAliasTempExcL) -> (TROLP_L) == 'N'
                    (cAliasTempExcL) -> (TROLP_NAT):= "1"
                    aCombo7L := {'N=NAO','S=SIM'}
                endif
                (cAliasTempExcL) -> (TRORL_L)    := ZM2 -> (ZM2_TROCRL)
                if (cAliasTempExcL) -> (TRORL_L) == 'S'
                    (cAliasTempExcL) -> (TRORL_NAT):= "1"
                    aCombo8L := {'S=SIM','N=NAO'}
                elseif (cAliasTempExcL) -> (TRORL_L) == 'N'
                    (cAliasTempExcL) -> (TRORL_NAT):= "1"
                    aCombo8L := {'N=NAO','S=SIM'}
                endif
                (cAliasTempAltL) -> (MATER_L)     := ZM2 -> (ZM2_MATER)
                (cAliasTempAltL) -> (TEMPM_L)     := ZM2 -> (ZM2_TEMPM)
                (cAliasTempAltL) -> (UMIDA_L)     := ZM2 -> (ZM2_UMIDAD)
                (cAliasTempAltL) -> (TEMPA_L)     := ZM2 -> (ZM2_TEMPA)
                (cAliasTempAltL) -> (TEMPD_L)     := ZM2 -> (ZM2_TEMPD)
                (cAliasTempAltL) -> (TEMPR_L)     := ZM2 -> (ZM2_TEMPR)
                (cAliasTempAltL) -> (TENS_L)      := ZM2 -> (ZM2_TENS)
                (cAliasTempAltL) -> (HORIM_L)     := ZM2 -> (ZM2_HORIME)
                (cAliasTempAltL) -> (START_L)     := ZM2 -> (ZM2_START)
                (cAliasTempAltL) -> (CORR_L)      := ZM2 -> (ZM2_CORR)
                (cAliasTempAltL) -> (TEMPT_L)     := ZM2 -> (ZM2_TEMPT)
                (cAliasTempAltL) -> (SETP_L)      := ZM2 -> (ZM2_SETP)
                (cAliasTempAltL) -> (POT_L)       := ZM2 -> (ZM2_POT)
                (cAliasTempAltL) -> (OBS_L)       := ZM2 -> (ZM2_OBS)
                (cAliasTempAltL) -> (ATIVO_L)     := ZM2 -> (ZM2_ATIVO)
                if (cAliasTempExcL) -> (ATIVO_L) == 'S'
                    (cAliasTempExcL) -> (ATIVO_NAT):= "1"
                    aCombo24L := {'S=SIM','N=NAO'}
                elseif (cAliasTempExcL) -> (ATIVO_L) == 'N'
                    (cAliasTempExcL) -> (ATIVO_NAT):= "1"
                    aCombo24L := {'N=NAO','S=SIM'}
                endif
                (cAliasTempExcL) -> (DATAC_EXCL)     := ZM2 -> (ZM2_DATAC)
            (cAliasTempExcL) -> (MSUNLOCK())

        AADD(aDadosExcL,{(cAliasTempExcL) -> (Alltrim(COD_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(IMP_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(USU_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) ->    (DTOC(DATAM_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(LAMP_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TROLP_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TROLP_NAT))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TRORL_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TRORL_NAT))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(MATER_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TEMPM_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(UMIDA_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TEMPA_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TEMPD_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TEMPR_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TENS_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(HORIM_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(START_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(CORR_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(TEMPT_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(SETP_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(POT_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(OBS_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(ATIVO_L))})
        AADD(aDadosExcL,{(cAliasTempExcL) -> (AllTrim(ATIVO_NAT))})
        AADD(aDadosExcL,{(cAliasTempExcL) ->    (DTOC(DATAC_L))})

        oTableTempMLP:Delete()

        dialogExcL(aDadosExcL)

    FWRestArea(aArea)

return

Static function dialogExcL(aDadosExcL)

    Local aArea         := FwGetArea()
    Local aTamanho      := MsAdvSize()
    Local nJanLarg      := aTamanho[5]
    Local nJanAltu      := aTamanho[6] 
    Local lDimPixels    := .T.
    Local nPosTop       := 0
    Local nPosLeft      := 0
    Local cFont          := 'Tahoma'
    Local oFontPadrao  
    Local nObjLarg      := 0
    Local nObjAltu      := 0
    Local nObjColu      := 0
    Local nObjLinh      := 0
    Local cJanTitulo    := ''

    Private aHeaderL    := {}
    Private aColsL      := {}

    Private oSay1L
    Private cSay1LL     := "MANUTENÇÃO DE LAMPADAS - EXCLUSÃO"
    Private oBtn1L
    Private cBtn1LL     := 'FECHAR'
    Private oBtn2L
    Private cBtn2LL     := 'EXCLUIR'

    Private oSay2L
    Private cSay2LL     := 'Código'
    Private oGet2L
    Private xGet2LL     

    Private oSay3L
    Private cSay3LL     := 'Impressora'
    Private oGet3L
    Private xGet3LL     

    Private oSay4L
    Private cCod        := RetCodUsr()
    Private cNome       := ''
    Private cSay4LL     := 'Usuario'
    Private oGet4L
    Private xGet4LL     

    Private oSay5L
    Private cSay5LL     := 'Data Manutenção'
    Private oGet5L
    Private xGet5LL    

    Private oSay6L
    Private cSay6LL     := 'Lâmpada'
    Private oGet6L
    Private xGet6LL    

    Private oSay7L
    Private cSay7LL    := 'Troca Lâmpada'
    Private cCombo7L    
    Private oCombo7L 

    Private oSay8L
    Private cSay8LL    := 'Troca Refletor'
    Private cCombo8L    
    Private oCombo8L    

    Private oSay9L
    Private cSay9LL    := 'Material'
    Private oGet9L
    Private xGet9LL    

    Private oSay10L
    Private cSay10LL    := 'Temp. Ambiente'
    Private oGet10L
    Private xGet10LL    

    Private oSay11L
    Private cSay11LL     := 'Umidade Relativa(%)'
    Private oGet11L
    Private xGeT11LL     

    Private oSay12L
    Private cSay12LL    := 'Temp. Antes Lâmpada'
    Private oGet12L
    Private xGet12LL     

    Private oSay13L
    Private cSay13LL    := 'Temp. Depois Lâmpada'
    Private oGet13L
    Private xGet13LL    

    Private oSay14L
    Private cSay14LL    := 'Temp. Refrigeração IST'
    Private oGet14L
    Private xGet14LL     

    Private oSay15L
    Private cSay15LL    := 'Tensão Principal'
    Private oGet15L
    Private xGet15LL     

    Private oSay16L
    Private cSay16LL    := 'Horimetro (Horas)'
    Private oGet16L
    Private xGet16LL     

    Private oSay17L
    Private cSay17LL    := 'Inicio (StartUps)'
    Private oGet17L
    Private xGet17LL     

    Private oSay18L
    Private cSay18LL    := 'Corrente (A)'
    Private oGet18L
    Private xGet18LL    

    Private oSay19L
    Private cSay19LL    := 'Temp. Trabalho(°C)'
    Private oGet19L
    Private xGet19LL     

    Private oSay20L
    Private cSay20LL    := 'Set Point (%)'
    Private oGet20L
    Private xGet20LL     

    Private oSay21L
    Private cSay21LL    := 'Potencia (mWcm2)'
    Private oGet21L
    Private xGet21LL     
    
    Private oSay22L
    Private cSay22LL    := 'Observação'
    Private oGet22L
    Private xGet22LL     

    Private oSay23L
    Private cSay23LL    := 'Ativo'
    Private oCombo23L   

    Private oSay24L
    Private cSay24LL    := 'Data'
    Private oGet24L
    Private xGet24LL     

    Private oDlgExcL

        cJanTitulo := 'MANUTENÇÃO DE LAMPADAS - EXCLUSÃO'
        oDlgExcL := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,/*nCor*/,,lDimpixels)

        nObjLinh := 002
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002 - 386 
        oGrp7 := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg, , oDlgExcL, , , lDimPixels)

        oFontPadrao  := TFont():New(cFont, , -20)
        cSay1MM  := 'MANUTENÇÃO DE LAMPADAS - EXCLUSÃO'
        nObjLinh := 25
        nObjColu := 25 
        nObjLarg := 250
        nObjAltu := 20
        oSay1M := TSay():New(nObjLinh, nObjColu, {|| cSay1LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLUE,,nObjLarg,nObjAltu) 

        nObjLinh := 20
        nObjColu := 750
        nObjLarg := 65
        nObjAltu := 20
        oBtn1L   := TButton():New(nObjLinh, nObjColu, cBtn1LL,oDlgExcL ,{|| oDlgExcL:End()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)    

        ObjLinh  := 20
        nObjColu := 830
        nObjLarg := 65
        nObjAltu := 20
        oBtn2L   := TButton():New(nObjLinh, nObjColu, cBtn2LL, oDlgExcL,{|| excBtnMLP()}, nObjLarg, nObjAltu,,oFontPadrao,,lDimPixels)       

        nObjLinh := 065
        nObjColu := 002 
        nObjLarg := (nJanLarg / 2) 
        nObjAltu := (nJanAltu / 2) - 002  
        oGrp8    := TGroup():New(nObjLinh, nObjColu, nObjAltu, nObjLarg,'Cadastros e Grid' , oDlgExcL, , , lDimPixels)
        
        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 25 
        nObjLarg := 25
        nObjAltu := 10
        oSay2L   := TSay():New(nObjLinh, nObjColu, {|| cSay2LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay2L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet2LL := aDadosExcL[1][1]
        nObjLinh := 90
        nObjColu := 25
        nObjLarg := 60
        nObjAltu := 15
        oGet2L   := TGet():New(nObjLinh, nObjColu, {||xGet2LL}, oDlgExcL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet2L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 100 
        nObjLarg := 80
        nObjAltu := 20
        oSay3L   := TSay():New(nObjLinh, nObjColu, {|| cSay3LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay3L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet3LL := aDadosExcL[2][1]
        nObjLinh := 90
        nObjColu := 100
        nObjLarg := 170
        nObjAltu := 15
        oGet3L   := TGet():New(nObjLinh, nObjColu,{||XGet3LL} , oDlgExcL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet3L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 285 
        nObjLarg := 60
        nObjAltu := 20
        oSay4L   := TSay():New(nObjLinh, nObjColu, {|| cSay4LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay4L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet4LL := aDadosExcL[3][1]
        nObjLinh := 90
        nObjColu := 285
        nObjLarg := 80
        nObjAltu := 15
        cNome := UsrRetName(cCod)
        xGet4LL := Alltrim(cNome)
        oGet4L   := TGet():New(nObjLinh, nObjColu,{|| Alltrim(xGet4LL)} , oDlgExcL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/)

        oGet4L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 375 
        nObjLarg := 30
        nObjAltu := 20
        oSay5L   := TSay():New(nObjLinh, nObjColu, {|| cSay5LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay5L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet5LL := CTOD(aDadosExcL[4][1])
        nObjLinh := 90
        nObjColu := 375
        nObjLarg := 80
        nObjAltu := 15
        lHasButton := .T.
        oGet5L := TGet():New(nObjLinh, nObjColu,{||xGet5LL} , oDlgExcL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,lHasButton)
        oGet5L:SetCSS("TGet{ color: #000000; selection-background-color: #369CB5;    background-color: #FFFFFF;     padding-left: 3px;     padding-right: 3px;     border-top-left-radius:3px;    border-bottom-left-radius:3px;    border: 1px solid #C5C9CA;    border-right: 0px; }QPushButton{ border: 1px solid #C5C9CA;   background-color: #FFFFFF;    border-left: 0px;   border-top-right-radius:3px;   border-bottom-right-radius:3px;    outline: none; }TGet:disabled { color: #000000;     border: 1px solid #E8EBF21;    border-right: 0px;    border-top-right-radius: 0px;    border-bottom-right-radius: 0px;    background-color: #E8EBF1;}QPushButton:disabled{ background-color: #E8EBF1; }tLabel{color: #000000;}")

        oGet5L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 80
        nObjColu := 465 
        nObjLarg := 30
        nObjAltu := 20
        oSay6L   := TSay():New(nObjLinh, nObjColu, {|| cSay6LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay6L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet6LL := aDadosExcL[5][1]
        nObjLinh := 90
        nObjColu := 465
        nObjLarg := 100
        nObjAltu := 15
        oGet6L   := TGet():New(nObjLinh, nObjColu,{||xGet6LL} , oDlgExcL, nObjLarg, nObjAltu, /*cPict*/, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/,.T.)
        
        oGet6L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 25 
        nObjLarg := 50
        nObjAltu := 20
        oSay7L   := TSay():New(nObjLinh, nObjColu, {|| cSay7LL}, oDlgExcL,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay7L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo7LL := aDadosExcL[6][1]
        nObjLinh := 125
        nObjColu := 25
        nObjLarg := 100
        nObjAltu := 15
        oCombo7L   := TComboBox():New(nObjLinh, nObjColu,,aCombo7L, nObjLarg, nObjAltu, oDlgExcL,,{||cCombo7LL},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oCombo7L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 140 
        nObjLarg := 50
        nObjAltu:= 20
        oSay8L   := TSay():New(nObjLinh, nObjColu, {|| cSay8LL}, oDlgExcL,,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay8L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo8LL := aDadosExcL[8][1]
        nObjLinh := 125
        nObjColu := 140
        nObjLarg := 80
        nObjAltu := 15
        oCombo8L   := TComboBox():New(nObjLinh, nObjColu,,aCombo8L, nObjLarg, nObjAltu, oDlgExcL,,{||cCombo8LL},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oCombo8L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 20
        oSay9L   := TSay():New(nObjLinh, nObjColu, {|| cSay9LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay9L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet9LL := aDadosExcL[10][1]
        nObjLinh := 125
        nObjColu := 237
        nObjLarg := 80
        nObjAltu := 15
        oGet9L  := TGet():New(nObjLinh, nObjColu,{|| xGet9LL} , oDlgExcL, nObjLarg, nObjAltu,, /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet9L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 20
        oSay10L   := TSay():New(nObjLinh, nObjColu, {|| cSay10LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay10L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet10LL := aDadosExcL[11][1]
        nObjLinh := 125
        nObjColu := 333
        nObjLarg := 80
        nObjAltu := 15
        oGet10L   := TGet():New(nObjLinh, nObjColu,{|| xGet10LL} , oDlgExcL, nObjLarg, nObjAltu, , /*bValid*/, /*nClrFore*/, /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet10L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 435
        nObjLarg := 80
        nObjAltu := 20
        oSay11L   := TSay():New(nObjLinh, nObjColu, {|| cSay11LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay11L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet11LL := aDadosExcL[12][1]
        nObjLinh := 125
        nObjColu := 435
        nObjLarg := 50
        nObjAltu := 15
        oGet11L   := TGet():New(nObjLinh, nObjColu,{|| xGet11LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet11L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 500
        nObjLarg := 80
        nObjAltu := 20
        oSay12L  := TSay():New(nObjLinh, nObjColu, {|| cSay12LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay12L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet12LL := aDadosExcL[13][1]
        nObjLinh := 125
        nObjColu := 500
        nObjLarg := 80
        nObjAltu := 15
        oGet12L   := TGet():New(nObjLinh, nObjColu,{|| xGet12LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet12L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 595
        nObjLarg := 80
        nObjAltu := 20
        oSay13L  := TSay():New(nObjLinh, nObjColu, {|| cSay13LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay13L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet13LL := aDadosExcL[14][1]
        nObjLinh := 125
        nObjColu := 595
        nObjLarg := 80
        nObjAltu := 15
        oGet13L   := TGet():New(nObjLinh, nObjColu,{||xGet13LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet13L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 115
        nObjColu := 685
        nObjLarg := 80
        nObjAltu := 20
        oSay14L  := TSay():New(nObjLinh, nObjColu, {|| cSay14LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay14L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet14LL := aDadosExcL[15][1]
        nObjLinh := 125
        nObjColu := 685
        nObjLarg := 50
        nObjAltu := 15
        oGet14L   := TGet():New(nObjLinh, nObjColu,{|| xGet14LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet14L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 25
        nObjLarg := 80
        nObjAltu := 20
        oSay15L  := TSay():New(nObjLinh, nObjColu, {|| cSay15LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay15L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet15LL := aDadosExcL[16][1]
        nObjLinh := 155
        nObjColu := 25
        nObjLarg := 50
        nObjAltu := 15
        oGet15L   := TGet():New(nObjLinh, nObjColu,{||xGet15LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet15L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 90
        nObjLarg := 80
        nObjAltu := 20
        oSay16L  := TSay():New(nObjLinh, nObjColu, {|| cSay16LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay16L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet16LL := aDadosExcL[17][1]
        nObjLinh := 155
        nObjColu := 90
        nObjLarg := 50
        nObjAltu := 15
        oGet16L   := TGet():New(nObjLinh, nObjColu,{||xGet16LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet16L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 150
        nObjLarg := 80
        nObjAltu := 20
        oSay17L  := TSay():New(nObjLinh, nObjColu, {|| cSay17LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay17L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet17LL := aDadosExcL[18][1]
        nObjLinh := 155
        nObjColu := 150
        nObjLarg := 50
        nObjAltu := 15
        oGet17L   := TGet():New(nObjLinh, nObjColu,{||xGet17LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet17L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 210
        nObjLarg := 80
        nObjAltu := 20
        oSay18L  := TSay():New(nObjLinh, nObjColu, {|| cSay18LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay18L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet18LL := aDadosExcL[19][1]
        nObjLinh := 155
        nObjColu := 210
        nObjLarg := 50
        nObjAltu := 15
        oGet18L   := TGet():New(nObjLinh, nObjColu,{||xGet18LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet18L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 270
        nObjLarg := 80
        nObjAltu := 20
        oSay19L  := TSay():New(nObjLinh, nObjColu, {|| cSay19LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay19L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet19LL := aDadosExcL[20][1]
        nObjLinh := 155
        nObjColu := 270
        nObjLarg := 50
        nObjAltu := 15
        oGet19L   := TGet():New(nObjLinh, nObjColu,{||xGet19LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet19L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 330
        nObjLarg := 80
        nObjAltu := 20
        oSay20L  := TSay():New(nObjLinh, nObjColu, {|| cSay20LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay20L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet20LL := aDadosExcL[21][1]
        nObjLinh := 155
        nObjColu := 330
        nObjLarg := 50
        nObjAltu := 15
        oGet20L   := TGet():New(nObjLinh, nObjColu,{|| xGet20LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet20L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 390
        nObjLarg := 80
        nObjAltu := 20
        oSay21L  := TSay():New(nObjLinh, nObjColu, {|| cSay21LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay21L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet21LL := aDadosExcL[22][1]
        nObjLinh := 155
        nObjColu := 390
        nObjLarg := 50
        nObjAltu := 15
        oGet21L   := TGet():New(nObjLinh, nObjColu,{|| xGet21LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)
        
        oGet21L:lActive := .F.

         oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 450
        nObjLarg := 80
        nObjAltu := 20
        oSay22L  := TSay():New(nObjLinh, nObjColu, {|| cSay22LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay22L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet22LL := aDadosExcL[23][1]
        nObjLinh := 155
        nObjColu := 450
        nObjLarg := 50
        nObjAltu := 15
        oGet22L   := TGet():New(nObjLinh, nObjColu,{|| xGet22LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet22L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 510
        nObjLarg := 80
        nObjAltu := 20
        oSay23L  := TSay():New(nObjLinh, nObjColu, {|| cSay23LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay23L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        cCombo23LL := aDadosExcL[24][1]
        nObjLinh := 155
        nObjColu := 510
        nObjLarg := 50
        nObjAltu := 15
        oCombo23L   := TComboBox():New(nObjLinh, nObjColu,,aCombo23L, nObjLarg, nObjAltu, oDlgExcL,,{||cCombo23LL},/*bValid*/, /*nClrText*/, /*nClrBack*/,lDimPixels,oFontPadrao)

        oCombo23L:lActive := .F.

        oFontPadrao  := TFont():New(cFont, , -14)
        nObjLinh := 145
        nObjColu := 570

        nObjLarg := 80
        nObjAltu := 20
        oSay24L  := TSay():New(nObjLinh, nObjColu, {|| cSay24LL}, oDlgExcL,/*Picture*/,oFontPadrao,,,,lDimpixels,CLR_BLACK,,nObjLarg,nObjAltu) 
        oSay24L:SetCss(" TSay {Font: Semi-Bold}")

        oFontPadrao  := TFont():New(cFont, , -16)
        xGet24LL := aDadosExcL[26][1]
        nObjLinh := 155
        nObjColu := 570
        nObjLarg := 80
        nObjAltu := 15
        oGet24L   := TGet():New(nObjLinh, nObjColu,{||xGet24LL} , oDlgExcL, nObjLarg, nObjAltu, , , , /*nClrBack*/, oFontPadrao, , , lDimPixels, /*uParam15*/, /*uParam16*/, /*bWhen*/, /*uParam18*/, /*uParam19*/, /*bChange*/, /*lReadOnly*/, /*lPassword*/, /*uParam23*/, /*cReadVar*/, /*uParam25*/, /*uParam26*/, /*uParam27*/, .T.)

        oGet24L:lActive := .F.

        oDlgExcL:Activate()

FwRestArea(aArea)

return

Static function excBtnMLP()

    Local aArea := FWGetArea()

    DbSelectArea('ZM2')
    ZM2->(DbSetOrder(1))

        Begin Transaction
        RecLock('ZM2', .F.)
            ZM2 -> (DbDelete())
            lEsc := MsgYesNo('Deseja remover mesmo?')
        if lEsc == .F.
            DisarmTransaction()
        else
            MsgInfo('REGISTRO REMOVIDO!!')
        ENDIF
        ZM2 -> (MsUnlock())  
        end Transaction

        oDlgExcL:End()

    ZM2->(DbCloseArea())

    FWRestArea(aArea)
return

// -------------------------------------------------------------------------
// 
//                         CONSULTA DE IMPRESSORA EM LAMPADAS
// 
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
// ------------------------------------------------------------------------- 


User function zConsImp()

    Local aArea := FWGetArea()
    Local nPosTop := 0
    Local nPosLeft := 0
    Local nJanAltu := 0500
    Local nJanLarg := 0800
    Local cJanTitulo := ''
    Local lDimPixels := .T.
    Local lCentraliz := .T.
    Local nTamBtn := 050

    //MsNewGetDados
    Private oGrp2
    Private oMsNew
    Private aHeadAux := {}
    Private aColsAux := {}

    //PESQUISA
    Private oGrp1
    Private oGetP
    Private xGetP := SPACE(100)
    Private oPesq

    //BOTOES EM GERAL
    Private oGrp3
    Private oConf
    Private oClr
    Private oCanc

    Private oDlgCE

    Private lTF := .F.

    AADD(aHeadAux,{"Codigo",;       
                  "ZCA_COD",;   
                  "",;          
                   6,;          
                   0,;          
                  "AlwaysTrue()",; 
                  "",;
                  "C",;           
                  ""})

    AADD(aHeadAux,{"Descrição",;
                  "ZCA_DESC",;
                  "@!",;
                   100,;
                   0,;
                  "AlwaysTrue()",;
                  "",;
                  "C",;
                  ""})

    //Cria os objetos
    nJanTitulo := 'CONSULTA DE ITENS '
    oDlgCE := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,,,lDimpixels)

    oGrp1  := TGroup():New(003, 003, 025, (nJanLarg/2)-30,'PESQUISAR', oDlgCE,,, lDimPixels)

    oGetP  := TGet():New(010, 006,{|u| Iif(PCount() > 0 , xGetP := u, xGetP)} , oDlgCE, (nJanLarg/2)-39, 010,,,,,,,, lDimPixels,,,,,,,,,,,,,, .T.)

    oPesq  := TButton():New(003, (nJanLarg/2)-((nTamBtn*1)+06),'BLA', oDlgCE,{||fPesqImp()}, 075, 040,,,,lDimPixels,,,,,,)  

    oGrp2  := TGroup():New(028, 003, (nJanAltu/2)-28, (nJanLarg/2)-3,'GRID', oDlgCE,,, lDimPixels)

    fPopulaImp()

    oMsNew := MsNewGetDados():New(    035,;                                        
                                      006,;                                        
                                      (nJanAltu/2)-31,;                            
                                      (nJanLarg/2)-6,;                             
                                      GD_INSERT+GD_DELETE+GD_UPDATE,;              
                                      "AllwaysTrue()",;                            
                                      ,;                                           
                                      "",;                                         
                                      ,;                                           
                                      ,;                                           
                                      999,;                                        
                                      ,;                                           
                                      ,;                                           
                                      ,;                                           
                                      oDlgCE,;                                     
                                      aHeadAux,;                                   
                                      aColsAux)                                                                    
    
    oMsNew:lActive := .F.
    oMsNew:oBrowse:blDblClick := {|| fConfImp()}

    oGrp3   := TGroup():New((nJanAltu/2)-25, 003, (nJanAltu/2)-3, (nJanLarg/2)-3,'BOTÕES', oDlgCE,,, lDimPixels)

    oConf   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06), 'Confirmar', oDlgCE,{|| fConfImp()}, nTamBtn, 013,,,,lDimPixels)       
    oCanc   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09), 'Cancelar', oDlgCE,{|| oDlgCE:End()}, nTamBtn, 013,,,,lDimPixels)  

    oMsNew:oBrowse:SetFocus()

    oDlgCE:Activate(,,,lCentraliz,,,)

    FwRestArea(aArea)

return 

static function fPopulaImp()

    Local aArea := FWGetArea()
    Local cQry := ''
    Local nTotal := 0
    Local nAtual := 0 

    if lTF == .F.

    cQry := "SELECT ZCA_COD,ZCA_DESC FROM ZCA990 WHERE ZCA_TIPO = 'I' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{QRY_ZCA->ZCA_COD,;
                           QRY_ZCA->ZCA_DESC,;
                           .F.;
                           })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

    elseIF lTF == .T.
        
        cQry := "SELECT ZCA_COD,ZCA_DESC FROM ZCA990 WHERE ZCA_TIPO = 'I' AND ZCA_DESC LIKE '%"+ Alltrim(oGetp:BUFFER) +"%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        Count To nTotal
        ProcRegua(nTotal)

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)
        
        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{AllTrim(QRY_ZCA->ZCA_COD),;
                           AllTrim(QRY_ZCA->ZCA_DESC),;
                           .F.;
                          })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())
        
    endif

    lTF := .F.

        FwRestArea(aArea)

return

Static Function fPesqImp()

    lTF := .T.

    fPopulaImp()
    oMsNew:ACOLS := aColsAux
    oMsNew:oBrowse:Refresh()

return

Static Function fConfImp()

    Local aArea := FwGetArea()

        if nEscBD == 1
            if nEsc == 3
                oGet15T:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2])
            elseif nEsc == 4
                oGet15A:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            endif
        elseif nEscBD == 2
            if nEscM == 5
                oGet3M:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif nEscM == 6
                oGet3M:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif nEscM == 9
                cImp := Alltrim(aColsAux[oMsNew:Nat][2]) 
            endif
        elseif nEscBD == 3
            if nEscL == 7
                oGet3L:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif nEscL == 8
                oGet3L:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2])
            endif 
        endif
    oDlgCE:End()

    FwRestArea(aArea)

return 

User function zConsEst()

    Local aArea := FWGetArea()
    Local nPosTop := 0
    Local nPosLeft := 0
    Local nJanAltu := 0500
    Local nJanLarg := 0800
    Local cJanTitulo := ''
    Local lDimPixels := .T.
    Local lCentraliz := .T.
    Local nTamBtn := 050

    //MsNewGetDados
    Private oGrp2
    Private oMsNew
    Private aHeadAux := {}
    Private aColsAux := {}

    //PESQUISA
    Private oGrp1
    Private oGetP
    Private xGetP := SPACE(100)
    Private oPesq

    //BOTOES EM GERAL
    Private oGrp3
    Private oConf
    Private oClr
    Private oCanc

    Private oDlgCE

    Private lTF := .F.

    AADD(aHeadAux,{"Codigo",;       
                  "ZCA_COD",;   
                  "",;          
                   6,;          
                   0,;          
                  "AlwaysTrue()",; 
                  "",;
                  "C",;           
                  ""})

    AADD(aHeadAux,{"Descrição",;
                  "ZCA_DESC",;
                  "@!",;
                   100,;
                   0,;
                  "AlwaysTrue()",;
                  "",;
                  "C",;
                  ""})

    //Cria os objetos
    nJanTitulo := 'CONSULTA DE ITENS '
    oDlgCE := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,,,lDimpixels)

    oGrp1  := TGroup():New(003, 003, 025, (nJanLarg/2)-30,'PESQUISAR', oDlgCE,,, lDimPixels)

    oGetP  := TGet():New(010, 006,{|u| Iif(PCount() > 0 , xGetP := u, xGetP)} , oDlgCE, (nJanLarg/2)-39, 010,,,,,,,, lDimPixels,,,,,,,,,,,,,, .T.)

    oPesq  := TButton():New(003, (nJanLarg/2)-((nTamBtn*1)+06),'BLA', oDlgCE,{||fPesqEst()}, 075, 040,,,,lDimPixels,,,,,,)  

    oGrp2  := TGroup():New(028, 003, (nJanAltu/2)-28, (nJanLarg/2)-3,'GRID', oDlgCE,,, lDimPixels)

    fPopulaEst()

    oMsNew := MsNewGetDados():New(    035,;                                        
                                      006,;                                        
                                      (nJanAltu/2)-31,;                            
                                      (nJanLarg/2)-6,;                             
                                      GD_INSERT+GD_DELETE+GD_UPDATE,;              
                                      "AllwaysTrue()",;                            
                                      ,;                                           
                                      "",;                                         
                                      ,;                                           
                                      ,;                                           
                                      999,;                                        
                                      ,;                                           
                                      ,;                                           
                                      ,;                                           
                                      oDlgCE,;                                     
                                      aHeadAux,;                                   
                                      aColsAux)                                                                    
    
    oMsNew:lActive := .F.
    oMsNew:oBrowse:blDblClick := {|| fConfEst()}

    oGrp3   := TGroup():New((nJanAltu/2)-25, 003, (nJanAltu/2)-3, (nJanLarg/2)-3,'BOTÕES', oDlgCE,,, lDimPixels)

    oConf   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06), 'Confirmar', oDlgCE,{|| fConfEst()}, nTamBtn, 013,,,,lDimPixels)       
    oCanc   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09), 'Cancelar', oDlgCE,{|| oDlgCE:End()}, nTamBtn, 013,,,,lDimPixels)  

    oMsNew:oBrowse:SetFocus()

    oDlgCE:Activate(,,,lCentraliz,,,)

    FwRestArea(aArea)

return 

static function fPopulaEst()

    Local aArea := FWGetArea()
    Local cQry := ''
    Local nTotal := 0
    Local nAtual := 0 

    if lTF == .F.

    cQry := "SELECT ZCA_COD,ZCA_DESC FROM ZCA990 WHERE ZCA_TIPO = 'E' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{QRY_ZCA->ZCA_COD,;
                           QRY_ZCA->ZCA_DESC,;
                           .F.;
                           })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

    elseIF lTF == .T.
        
        cQry := "SELECT ZCA_COD,ZCA_DESC FROM ZCA990 WHERE ZCA_TIPO = 'E' AND ZCA_DESC LIKE '%"+ Alltrim(oGetp:BUFFER) +"%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        Count To nTotal
        ProcRegua(nTotal)

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)
        
        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{AllTrim(QRY_ZCA->ZCA_COD),;
                           AllTrim(QRY_ZCA->ZCA_DESC),;
                           .F.;
                          })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())
        
    endif

    lTF := .F.

        FwRestArea(aArea)

return

Static Function fPesqEst()

    lTF := .T.

    fPopulaEst()
    oMsNew:ACOLS := aColsAux
    oMsNew:oBrowse:Refresh()

return

Static Function fConfEst()

    Local aArea := FwGetArea()

            if nEscM == 5
                oGet4M:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif nEscM == 6
                oGet4M:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif cEscM == 9
                cEst := Alltrim(aColsAux[oMsNew:Nat][2]) 
            endif

    oDlgCE:End()

    FwRestArea(aArea)

return 

User function zConsRl()

    Local aArea := FWGetArea()
    Local nPosTop := 0
    Local nPosLeft := 0
    Local nJanAltu := 0500
    Local nJanLarg := 0800
    Local cJanTitulo := ''
    Local lDimPixels := .T.
    Local lCentraliz := .T.
    Local nTamBtn := 050

    //MsNewGetDados
    Private oGrp2
    Private oMsNew
    Private aHeadAux := {}
    Private aColsAux := {}

    //PESQUISA
    Private oGrp1
    Private oGetP
    Private xGetP := SPACE(100)
    Private oPesq

    //BOTOES EM GERAL
    Private oGrp3
    Private oConf
    Private oClr
    Private oCanc

    Private oDlgCE

    Private lTF := .F.

    AADD(aHeadAux,{"Codigo",;       
                  "ZCA_COD",;   
                  "",;          
                   6,;          
                   0,;          
                  "AlwaysTrue()",; 
                  "",;
                  "C",;           
                  ""})

     AADD(aHeadAux,{"Nome Rolo",;
                      "ZCA_NOMERL",;
                      "@!",;
                       50,;
                       0,;
                      "AlwaysTrue()",;
                      "",;
                      "C",;
                      ""})

    //Cria os objetos
    nJanTitulo := 'CONSULTA DE ITENS '
    oDlgCE := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,,,lDimpixels)

    oGrp1  := TGroup():New(003, 003, 025, (nJanLarg/2)-30,'PESQUISAR', oDlgCE,,, lDimPixels)

    oGetP  := TGet():New(010, 006,{|u| Iif(PCount() > 0 , xGetP := u, xGetP)} , oDlgCE, (nJanLarg/2)-39, 010,,,,,,,, lDimPixels,,,,,,,,,,,,,, .T.)

    oPesq  := TButton():New(003, (nJanLarg/2)-((nTamBtn*1)+06),'BLA', oDlgCE,{||fPesqRl()}, 075, 040,,,,lDimPixels,,,,,,)  

    oGrp2  := TGroup():New(028, 003, (nJanAltu/2)-28, (nJanLarg/2)-3,'GRID', oDlgCE,,, lDimPixels)

    fPopulaRl()

    oMsNew := MsNewGetDados():New(    035,;                                        
                                      006,;                                        
                                      (nJanAltu/2)-31,;                            
                                      (nJanLarg/2)-6,;                             
                                      GD_INSERT+GD_DELETE+GD_UPDATE,;              
                                      "AllwaysTrue()",;                            
                                      ,;                                           
                                      "",;                                         
                                      ,;                                           
                                      ,;                                           
                                      999,;                                        
                                      ,;                                           
                                      ,;                                           
                                      ,;                                           
                                      oDlgCE,;                                     
                                      aHeadAux,;                                   
                                      aColsAux)                                                                    
    
    oMsNew:lActive := .F.
    oMsNew:oBrowse:blDblClick := {|| fConfRl()}

    oGrp3   := TGroup():New((nJanAltu/2)-25, 003, (nJanAltu/2)-3, (nJanLarg/2)-3,'BOTÕES', oDlgCE,,, lDimPixels)

    oConf   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06), 'Confirmar', oDlgCE,{|| fConfRl()}, nTamBtn, 013,,,,lDimPixels)       
    oCanc   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09), 'Cancelar', oDlgCE,{|| oDlgCE:End()}, nTamBtn, 013,,,,lDimPixels)  

    oMsNew:oBrowse:SetFocus()

    oDlgCE:Activate(,,,lCentraliz,,,)

    FwRestArea(aArea)

return 

static function fPopulaRl()

    Local aArea := FWGetArea()
    Local cQry := ''
    Local nTotal := 0
    Local nAtual := 0 

    if lTF == .F.

    cQry := "SELECT ZCA_COD,ZCA_NOMERL FROM ZCA990 WHERE ZCA_TIPO = 'R' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{QRY_ZCA->ZCA_COD,;
                           QRY_ZCA->ZCA_NOMERL,;
                           .F.;
                           })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

    elseIF lTF == .T.
        
        cQry := "SELECT ZCA_COD,ZCA_NOMERL FROM ZCA990 WHERE ZCA_TIPO = 'R' AND ZCA_DESC LIKE '%"+ Alltrim(oGetp:BUFFER) +"%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        Count To nTotal
        ProcRegua(nTotal)

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)
        
        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{AllTrim(QRY_ZCA->ZCA_COD),;
                           AllTrim(QRY_ZCA->ZCA_NOMERL),;
                           .F.;
                          })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())
        
    endif

    lTF := .F.

        FwRestArea(aArea)

return

Static Function fPesqRl()

    lTF := .T.

    fPopulaRl()
    oMsNew:ACOLS := aColsAux
    oMsNew:oBrowse:Refresh()

return

Static Function fConfRl()

    Local aArea := FwGetArea()

            if nEscM == 5
                oGet6M:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif nEscM == 6
                oGet6M:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif nEscM == 9
                nRolo := Alltrim(aColsAux[oMsNew:Nat][2]) 
            endif

    oDlgCE:End()

    FwRestArea(aArea)

return 

User function zConsLp()

    Local aArea := FWGetArea()
    Local nPosTop := 0
    Local nPosLeft := 0
    Local nJanAltu := 0500
    Local nJanLarg := 0800
    Local cJanTitulo := ''
    Local lDimPixels := .T.
    Local lCentraliz := .T.
    Local nTamBtn := 050

    //MsNewGetDados
    Private oGrp2
    Private oMsNew
    Private aHeadAux := {}
    Private aColsAux := {}

    //PESQUISA
    Private oGrp1
    Private oGetP
    Private xGetP := SPACE(100)
    Private oPesq

    //BOTOES EM GERAL
    Private oGrp3
    Private oConf
    Private oClr
    Private oCanc

    Private oDlgCE

    Private lTF := .F.

    AADD(aHeadAux,{"Codigo",;       
                  "ZCA_COD",;   
                  "",;          
                   6,;          
                   0,;          
                  "AlwaysTrue()",; 
                  "",;
                  "C",;           
                  ""})

    AADD(aHeadAux,{"Nome Lampada",;
                 "ZCA_NOMELP",;
                 "@!",;
                  50,;
                  0,;
                 "AlwaysTrue()",;
                 "",;
                 "C",;
                 ""})

    //Cria os objetos
    cJanTitulo := 'CONSULTA DE ITENS '
    oDlgCE := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cJanTitulo,,,,,,,,,lDimpixels)

    oGrp1  := TGroup():New(003, 003, 025, (nJanLarg/2)-30,'PESQUISAR', oDlgCE,,, lDimPixels)

    oGetP  := TGet():New(010, 006,{|u| Iif(PCount() > 0 , xGetP := u, xGetP)} , oDlgCE, (nJanLarg/2)-39, 010,,,,,,,, lDimPixels,,,,,,,,,,,,,, .T.)

    oPesq  := TButton():New(003, (nJanLarg/2)-((nTamBtn*1)+06),'BLA', oDlgCE,{||fPesqLp()}, 075, 040,,,,lDimPixels,,,,,,)  

    oGrp2  := TGroup():New(028, 003, (nJanAltu/2)-28, (nJanLarg/2)-3,'GRID', oDlgCE,,, lDimPixels)

    fPopulaLp()

    oMsNew := MsNewGetDados():New(    035,;                                        
                                      006,;                                        
                                      (nJanAltu/2)-31,;                            
                                      (nJanLarg/2)-6,;                             
                                      GD_INSERT+GD_DELETE+GD_UPDATE,;              
                                      "AllwaysTrue()",;                            
                                      ,;                                           
                                      "",;                                         
                                      ,;                                           
                                      ,;                                           
                                      999,;                                        
                                      ,;                                           
                                      ,;                                           
                                      ,;                                           
                                      oDlgCE,;                                     
                                      aHeadAux,;                                   
                                      aColsAux)                                                                    
    
    oMsNew:lActive := .F.
    oMsNew:oBrowse:blDblClick := {|| fConfLp()}

    oGrp3   := TGroup():New((nJanAltu/2)-25, 003, (nJanAltu/2)-3, (nJanLarg/2)-3,'BOTÕES', oDlgCE,,, lDimPixels)

    oConf   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06), 'Confirmar', oDlgCE,{|| fConfLp()}, nTamBtn, 013,,,,lDimPixels)       
    oCanc   := TButton():New((nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09), 'Cancelar', oDlgCE,{|| oDlgCE:End()}, nTamBtn, 013,,,,lDimPixels)  

    oMsNew:oBrowse:SetFocus()

    oDlgCE:Activate(,,,lCentraliz,,,)

    FwRestArea(aArea)

return 

static function fPopulaLp()

    Local aArea := FWGetArea()
    Local cQry := ''
    Local nTotal := 0
    Local nAtual := 0 

    if lTF == .F.

    cQry := "SELECT ZCA_COD,ZCA_NOMELP FROM ZCA990 WHERE ZCA_TIPO = 'L' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)

        Count To nTotal
        ProcRegua(nTotal)

        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{QRY_ZCA->ZCA_COD,;
                           QRY_ZCA->ZCA_NOMELP,;
                           .F.;
                           })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())

    elseIF lTF == .T.
        
        cQry := "SELECT ZCA_COD,ZCA_NOMELP FROM ZCA990 WHERE ZCA_TIPO = 'L' AND ZCA_DESC LIKE '%"+ Alltrim(oGetp:BUFFER) +"%' AND D_E_L_E_T_ = ''"

        TCQUERY cQry New Alias "QRY_ZCA"

        Count To nTotal
        ProcRegua(nTotal)

        nTam := Len(aColsAux)

        aSize(aColsAux, - nTam)
        
        QRY_ZCA -> (DbGoTop())
        while ! QRY_ZCA->(Eof())

            nAtual++
            IncProc("Adicionando")

            AAdd(aColsAux,{AllTrim(QRY_ZCA->ZCA_COD),;
                           AllTrim(QRY_ZCA->ZCA_NOMELP),;
                           .F.;
                          })

            QRY_ZCA ->(DbSkip())
        enddo
        QRY_ZCA->(DbCloseArea())
        
    endif

    lTF := .F.

        FwRestArea(aArea)

return

Static Function fPesqLp()

    lTF := .T.

    fPopulaLp()
    oMsNew:ACOLS := aColsAux
    oMsNew:oBrowse:Refresh()

return

Static Function fConfLp()

    Local aArea := FwGetArea()

            if nEscL == 7
                oGet6L:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            elseif nEscL == 8
                oGet6L:BUFFER := Alltrim(aColsAux[oMsNew:Nat][2]) 
            endif

    oDlgCE:End()

    FwRestArea(aArea)

return 

User Function SelecioZM1()

    Local aArea := FwGetArea()

    DbSelectArea('ZM1')

    menuEscP()

    ZM1->(DbCloseArea())

    FwRestArea(aArea)

return

User Function ZM2Selecio()

    Local aArea := FwGetArea()

    DbSelectArea('ZM2')

    menuEscP()

    ZM2->(DbCloseArea())

    FwRestArea(aArea)

return


Static function menuEscP() 

    Local aArea := FwGetArea()

    Private cData1 := CTOD('')
    Private cData2 := CTOD('')
    Private lRet := .T.

    getParam()

    if lRet == .T.
        if Select('ZM1') > 0
            FWMsgRun(,{|oSay| proq()}, 'Buscando informações da tabela ZM1990', 'Gerando Excell')
        ELSEIF SELECT('ZM2') > 0 
            FWMsgRun(,{|oSay| proq()}, 'Buscando informações da tabela ZM2990', 'Gerando Excell')
        endif
    endif
    FwRestArea(aArea)

Return

Static Function proq()

    Local aArea := FwGetArea()
    Local cQry  := ''
    Local cAlias := ""
    Local aDados := {}

    If SELECT('ZM1') > 0 

    cQry := "SELECT * FROM " + RetSqlName('ZM1') + " WHERE D_E_L_E_T_ = '' AND ZM1_DATACA BETWEEN '"  + cData1 + "' AND '" + cData2 +"' "  

    cAlias := 'QZC_ZM1'

    TCQUERY cQry NEW ALIAS (cAlias)

    (cAlias)->(DbGoTop())

    Do While !(cAlias)->(Eof())
    
    AaDd(aDados,{(cAlias)->ZM1_COD,;
                 (cAlias)->ZM1_IMPRES,;
                 (cAlias)->ZM1_EST,;
                 (cAlias)->ZM1_USU,;
                 (cAlias)->ZM1_ROLO,;
                 (cAlias)->ZM1_FAB,;
                 (cAlias)->ZM1_DATAIN,;
                 (cAlias)->ZM1_OBS,;
                 (cAlias)->ZM1_DATACA,;
                 (cAlias)->ZM1_ATIVO,;
                 (cAlias)->ZM1_METRA,;
                 .F.})

    (cAlias)->(DbSkip())
    enddo

    (cAlias)->(DbCloseArea())

    geraExcell(aDados)

//-------------------------------------

    ELSEIF SELECT('ZM2') > 0 

    cQry := "SELECT * FROM " + RetSqlName('ZM2') + " WHERE D_E_L_E_T_ = '' AND ZM2_DATAC BETWEEN '"  + cData1 + "' AND '" + cData2 +"' "  

    cAlias := 'QZC_ZM2'

    TCQUERY cQry NEW ALIAS (cAlias)

    (cAlias)->(DbGoTop())

    Do While !(cAlias)->(Eof())
    
    AaDd(aDados,{(cAlias)->ZM2_COD,;
                 (cAlias)->ZM2_IMPRES,;
                 (cAlias)->ZM2_USU,;
                 (cAlias)->ZM2_DATAM,;
                 (cAlias)->ZM2_TROCLP,;
                 (cAlias)->ZM2_TROCRL,;
                 (cAlias)->ZM2_LAMP,;
                 (cAlias)->ZM2_MATER,;
                 (cAlias)->ZM2_TEMPM,;
                 (cAlias)->ZM2_UMIDAD,;
                 (cAlias)->ZM2_TEMPA,;
                 (cAlias)->ZM2_TEMPD,;
                 (cAlias)->ZM2_TEMPR,;
                 (cAlias)->ZM2_TENS,;
                 (cAlias)->ZM2_HORIME,;
                 (cAlias)->ZM2_START,;
                 (cAlias)->ZM2_CORR,;
                 (cAlias)->ZM2_TEMPT,;
                 (cAlias)->ZM2_SETP,;
                 (cAlias)->ZM2_POT,;
                 (cAlias)->ZM2_ATIVO,;
                 (cAlias)->ZM2_DATAC,;
                 .F.})

    (cAlias)->(DbSkip())
    enddo

    (cAlias)->(DbCloseArea())

    geraExcell(aDados)

    ENDIF

    FwRestArea(aArea)

return

Static Function geraExcell(aDados)

    Local aArea        := FwGetArea()
    Local oExcel     := FWMSExcel():New()
    Local oExcelApp  := Nil
    Local cAba       := ""
    Local cTabela    := ""
    Local cArquivo   := ""
    Local cPath      := "C:\Windows\Temp\"
    Local cDefPath   := GetSrvProfString("StartPath","\system\")
    Local i

    If len(aDados) > 0 

        IF SELECT('ZM1') > 0

            cAba   := "Manuteçaõd e Rolos"
            cTabela    := "Manutenção de Rolos"
            cArquivo   := "Manutenção-Rolos_" + StrTran(cData1,'/','-') + "_A_" + StrTran(cData2,'/','-') + ".xls"  

            if !ApOleClient("MSExcel") 
                MsAlert("Microsoft excel não esta instalado")
                return
            endif   
            oExcel:AddWorkSheet(cAba)
            oExcel:AddTable(cAba,cTabela)   
            //Adicionando as colunas
            oExcel:AddColumn(cAba,cTabela,"Codigo"         ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Impressora"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Estação"        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Usuario"        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Rolo"           ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Fabricação"      ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Instalação",1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Observação"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Cadastro"  ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Ativo"          ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Metragem"       ,1,1,.F.)    
            for i := 1 to len(aDados)   
                oExcel:AddRow(cAba,;
                              cTabela,;
                                 {aDados[i][1],;
                                  aDados[i][2],;
                                  aDados[i][3],;
                                  aDados[i][4],;
                                  aDados[i][5],;
                                  aDados[i][6],;
                                  aDados[i][7],;
                                  aDados[i][8],;
                                  aDados[i][9],;
                                  aDados[i][10],;
                                  aDados[i][11]})   
            next i      
            if !Empty(oExcel:aWorkSheet)    
                oExcel:Activate()
                oExcel:GetXMLFile(cArquivo) 
                cRecive := cPyS2T(cDefPath+cArquivo,cPath)  
                oExcelApp := MsExcel():New()
                oExcelApp:WorkBooks:Open(cPath+cArquivo)
                oExcelApp:SetVisible(.T.)
                MsgAlert('Arquivo Excell mandado para o endereço c:/Windows/Temp/','Atenção')
            endif

        ELSEIF SELECT('ZM2') > 0 

            cAba   := "Manuteçaõ de Lampadas"
            cTabela    := "Manutenção de Lampadas"
            cArquivo   := "Manutenção-Lampadas_" + StrTran(cData1,'/','-') + "_A_" + StrTran(cData2,'/','-') + ".xls"

            if !ApOleClient("MSExcel")
                MsAlert("Microsoft excel não esta instalado")
                return
            endif
            oExcel:AddWorkSheet(cAba)
            oExcel:AddTable(cAba,cTabela)
            //Adicionando as colunas
            oExcel:AddColumn(cAba,cTabela,"Codigo"         ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Impressora"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Usuario"        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Manu."        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Troca Lamp."           ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Troca Refletor"      ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Lampada",1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Material"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp Manu. Lp."  ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Umidade"          ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. Antes"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. Depois"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. R."       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Tensão"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Horimetro"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"StartUp"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Corrente"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. T."       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Set Point"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Potencia"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Observação"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Cadastro"       ,1,1,.F.)
            for i := 1 to len(aDados)
                oExcel:AddRow(cAba,;
                              cTabela,;
                                 {aDados[i][1],;
                                  aDados[i][2],;
                                  aDados[i][3],;
                                  aDados[i][4],;
                                  aDados[i][5],;
                                  aDados[i][6],;
                                  aDados[i][7],;
                                  aDados[i][8],;
                                  aDados[i][9],;
                                  aDados[i][10],;
                                  aDados[i][11],;
                                  aDados[i][12],;
                                  aDados[i][13],;
                                  aDados[i][14],;
                                  aDados[i][15],;
                                  aDados[i][16],;
                                  aDados[i][17],;
                                  aDados[i][18],;
                                  aDados[i][19],;
                                  aDados[i][20],;
                                  aDados[i][21],;
                                  aDados[i][22]})
            next i     
            if !Empty(oExcel:aWorkSheet)
                oExcel:Activate()
                oExcel:GetXMLFile(cArquivo)
                cRecive := cPyS2T(cDefPath+cArquivo,cPath)
                oExcelApp := MsExcel():New()
                oExcelApp:WorkBooks:Open(cPath+cArquivo)
                oExcelApp:SetVisible(.T.)
                oExcellApp:Destroy()
                MsgAlert('Arquivo Excell mandado para o endereço c:/Windows/Temp/','Atenção')
            endif
        endif
    else
        Msgalert("Não há nenhum cadastro para puxar no relatorio","ATENÇÃO")
    endif
    RestArea(aArea)
return 

Static function getParam()

    Local aParamBox   := {}
    Local cTitulo := 'RELATORIO - PERÍODO'
    Local nPosX     := 200
    Local nPosY     := 200
    Local aParams   := {}

    aAdd(aParamBox, {1, "Data De",  CTOD(''),  "", ".T.", "", ".T.", 80,  .T.})
    aAdd(aParamBox, {1, "Data Até", CTOD(''),  "", ".T.", "", ".T.", 80,  .T.})

    lRet := ParamBox(aParamBox,cTitulo,aParams,,,,nPosX,nPosY,,.T.,.T.)

    if (lRet)
        cData1 := DTOC(aParams[1])
        cData2 := DTOC(aParams[2])
    else
        Sleep(10)
    endif

return

User Function R2SelecioZM1()

    Local aArea := FwGetArea()

    DbSelectArea('ZM1')

    menuEscR2()

    ZM1->(DbCloseArea())

    FwRestArea(aArea)

return

User Function R2ZM2Selecio()

    Local aArea := FwGetArea()

    DbSelectArea('ZM2')

    menuEscR2()

    ZM2->(DbCloseArea())

    FwRestArea(aArea)

return


Static function menuEscR2() 

    Local aArea := FwGetArea()

    Private cData1 := CTOD('')
    Private cData2 := CTOD('')
    Private cRef
    Private cLamp
    Private cImp   
    Private cEst   
    Private cRolo  
    Private lRet := .T.

    getParamR2()

    if lRet == .T.
        if Select('ZM1') > 0
            FWMsgRun(,{|oSay| proqR2()}, 'Buscando informações da tabela ZM1990', 'Gerando Excell')
        ELSEIF SELECT('ZM2') > 0 
            FWMsgRun(,{|oSay| proqR2()}, 'Buscando informações da tabela ZM2990', 'Gerando Excell')
        endif
    endif

    FwRestArea(aArea)

Return

Static Function proqR2()

    Local aArea := FwGetArea()
    Local cQry  := ''
    Local cAlias := ""
    Local aDados := {}

    If SELECT('ZM1') > 0 

    cQry := "SELECT * FROM " + RetSqlName('ZM1') + " WHERE D_E_L_E_T_ = '' AND ZM1_IMPRES = '"+ cImp +"' AND ZM1_EST = '"+ cEst+"' AND ZM1_ROLO = '"+cRolo +"' AND ZM1_DATACA BETWEEN '"  + cData1 + "' AND '" + cData2 +"' "  

    cAlias := 'QZC_ZM1'

    TCQUERY cQry NEW ALIAS (cAlias)

    (cAlias)->(DbGoTop())

    Do While !(cAlias)->(Eof())
    
    AaDd(aDados,{(cAlias)->ZM1_COD,;
                 (cAlias)->ZM1_IMPRES,;
                 (cAlias)->ZM1_EST,;
                 (cAlias)->ZM1_USU,;
                 (cAlias)->ZM1_ROLO,;
                 (cAlias)->ZM1_FAB,;
                 (cAlias)->ZM1_DATAIN,;
                 (cAlias)->ZM1_OBS,;
                 (cAlias)->ZM1_DATACA,;
                 (cAlias)->ZM1_ATIVO,;
                 (cAlias)->ZM1_METRA,;
                 .F.})

    (cAlias)->(DbSkip())
    enddo

    (cAlias)->(DbCloseArea())

    R2geraExcell(aDados)

//-------------------------------------

    ELSEIF SELECT('ZM2') > 0 

    cQry := "SELECT * FROM " + RetSqlName('ZM2') + " WHERE D_E_L_E_T_ = '' AND ZM2_IMPRES = '"+ cImp +"' AND ZM2_TROCLP = '"+ cLamp+"' AND ZM2_TROCRL = '"+cRef +"' AND ZM2_DATAC BETWEEN '"  + cData1 + "' AND '" + cData2 +"' "  

    cAlias := 'QZC_ZM2'

    TCQUERY cQry NEW ALIAS (cAlias)

    (cAlias)->(DbGoTop())

    Do While !(cAlias)->(Eof())
    
    AaDd(aDados,{(cAlias)->ZM2_COD,;
                 (cAlias)->ZM2_IMPRES,;
                 (cAlias)->ZM2_USU,;
                 (cAlias)->ZM2_DATAM,;
                 (cAlias)->ZM2_TROCLP,;
                 (cAlias)->ZM2_TROCRL,;
                 (cAlias)->ZM2_LAMP,;
                 (cAlias)->ZM2_MATER,;
                 (cAlias)->ZM2_TEMPM,;
                 (cAlias)->ZM2_UMIDAD,;
                 (cAlias)->ZM2_TEMPA,;
                 (cAlias)->ZM2_TEMPD,;
                 (cAlias)->ZM2_TEMPR,;
                 (cAlias)->ZM2_TENS,;
                 (cAlias)->ZM2_HORIME,;
                 (cAlias)->ZM2_START,;
                 (cAlias)->ZM2_CORR,;
                 (cAlias)->ZM2_TEMPT,;
                 (cAlias)->ZM2_SETP,;
                 (cAlias)->ZM2_POT,;
                 (cAlias)->ZM2_ATIVO,;
                 (cAlias)->ZM2_DATAC,;
                 .F.})

    (cAlias)->(DbSkip())
    enddo

    (cAlias)->(DbCloseArea())

    R2geraExcell(aDados)

    ENDIF

    FwRestArea(aArea)

return

Static Function R2geraExcell(aDados)

    Local aArea        := FwGetArea()
    Local oExcel     := FWMSExcel():New()
    Local oExcelApp  := Nil
    Local cAba       := ""
    Local cTabela    := ""
    Local cArquivo   := ""
    Local cPath      := "C:\Windows\Temp\"
    Local cDefPath   := GetSrvProfString("StartPath","\system\")
    Local i

    If len(aDados) > 0 

        IF SELECT('ZM1') > 0

            cAba   := "Manuteçaõd e Rolos"
            cTabela    := "Manutenção de Rolos"
            cArquivo   := "Manutenção-Rolos_" + StrTran(cData1,'/','-') + "_A_" + StrTran(cData2,'/','-') + ".xls"  

            if !ApOleClient("MSExcel") 
                MsAlert("Microsoft excel não esta instalado")
                return
            endif   
            oExcel:AddWorkSheet(cAba)
            oExcel:AddTable(cAba,cTabela)   
            //Adicionando as colunas
            oExcel:AddColumn(cAba,cTabela,"Codigo"         ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Impressora"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Estação"        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Usuario"        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Rolo"           ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Fabricação"      ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Instalação",1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Observação"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Cadastro"  ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Ativo"          ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Metragem"       ,1,1,.F.)    
            for i := 1 to len(aDados)   
                oExcel:AddRow(cAba,;
                              cTabela,;
                                 {aDados[i][1],;
                                  aDados[i][2],;
                                  aDados[i][3],;
                                  aDados[i][4],;
                                  aDados[i][5],;
                                  aDados[i][6],;
                                  aDados[i][7],;
                                  aDados[i][8],;
                                  aDados[i][9],;
                                  aDados[i][10],;
                                  aDados[i][11]})   
            next i      
            if !Empty(oExcel:aWorkSheet)    
                oExcel:Activate()
                oExcel:GetXMLFile(cArquivo) 
                cRecive := cPyS2T(cDefPath+cArquivo,cPath)  
                oExcelApp := MsExcel():New()
                oExcelApp:WorkBooks:Open(cPath+cArquivo)
                oExcelApp:SetVisible(.T.)
                MsgAlert('Arquivo Excell mandado para o endereço c:/Windows/Temp/','Atenção')
            endif

        ELSEIF SELECT('ZM2') > 0 

            cAba   := "Manuteçaõ de Lampadas"
            cTabela    := "Manutenção de Lampadas"
            cArquivo   := "Manutenção-Lampadas_" + StrTran(cData1,'/','-') + "_A_" + StrTran(cData2,'/','-') + ".xls"

            if !ApOleClient("MSExcel") 
                MsAlert("Microsoft excel não esta instalado")
                return
            endif
            oExcel:AddWorkSheet(cAba)
            oExcel:AddTable(cAba,cTabela)
            //Adicionando as colunas
            oExcel:AddColumn(cAba,cTabela,"Codigo"         ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Impressora"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Usuario"        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Manu."        ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Troca Lamp."           ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Troca Refletor"      ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Lampada",1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Material"     ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp Manu. Lp."  ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Umidade"          ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. Antes"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. Depois"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. R."       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Tensão"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Horimetro"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"StartUp"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Corrente"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Temp. T."       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Set Point"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Potencia"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Observação"       ,1,1,.F.)
            oExcel:AddColumn(cAba,cTabela,"Data Cadastro"       ,1,1,.F.)
            for i := 1 to len(aDados)
                oExcel:AddRow(cAba,;
                              cTabela,;
                                 {aDados[i][1],;
                                  aDados[i][2],;
                                  aDados[i][3],;
                                  aDados[i][4],;
                                  aDados[i][5],;
                                  aDados[i][6],;
                                  aDados[i][7],;
                                  aDados[i][8],;
                                  aDados[i][9],;
                                  aDados[i][10],;
                                  aDados[i][11],;
                                  aDados[i][12],;
                                  aDados[i][13],;
                                  aDados[i][14],;
                                  aDados[i][15],;
                                  aDados[i][16],;
                                  aDados[i][17],;
                                  aDados[i][18],;
                                  aDados[i][19],;
                                  aDados[i][20],;
                                  aDados[i][21],;
                                  aDados[i][22]})
            next i     
            if !Empty(oExcel:aWorkSheet)
                oExcel:Activate()
                oExcel:GetXMLFile(cArquivo)
                cRecive := cPyS2T(cDefPath+cArquivo,cPath)
                oExcelApp := MsExcel():New()
                oExcelApp:WorkBooks:Open(cPath+cArquivo)
                oExcelApp:SetVisible(.T.)
                oExcellApp:Destroy()
                MsgAlert('Arquivo Excell mandado para o endereço c:/Windows/Temp/','Atenção')
            endif
        endif
    else
        Msgalert("Não há nenhum cadastro para puxar no relatorio","ATENÇÃO")
    endif
    RestArea(aArea)
return 

Static function getParamR2()

    Local aParamBox     := {}
    Local cTitulo       := 'RELATORIO'
    Local nPosX         := 200
    Local nPosY         := 300
    Local aParams       := {}
    Local nI 
    Private aColsRef          := {'S=SIM','N=NÃO'}
    Private aColsLP           := {'S=SIM','N=NÃO'}
    Private aColsAux    := {}
    Private aColsImp    := {}
    Private aColsEst    := {}
    Private aColsRl     := {}
    Private lTf         := .F.

    If SELECT('ZM1') > 0

        fPopulaImp()

        for nI := 1 to len(aColsAux)

            AADD(aColsImp,aColsAux[nI][2])

        next

        aAdd(aParamBox, {2, "Impressora", 0 ,  aColsImp, 80, ".T.",.T.})

        fPopulaEst()

        for nI := 1 to len(aColsAux)

            AADD(aColsEst,aColsAux[nI][2])

        next
        aAdd(aParamBox, {2, "Estação"   , 0 ,  aColsEst, 80, ".T.",.T.})

        fPopulaRl()

        for nI := 1 to len(aColsAux)

            AADD(aColsRl,aColsAux[nI][2])

        next
        aAdd(aParamBox, {2, "Rolo"     , 0 ,  aColsRl , 80, ".T.",.T.})
        aAdd(aParamBox, {1, "Data De"   , CTOD('') ,  "", ".T.", "", ".T.", 80,  .T.})
        aAdd(aParamBox, {1, "Data Até"  , CTOD('') ,  "", ".T.", "", ".T.", 80,  .T.})

        lRet := ParamBox(aParamBox,cTitulo,aParams,,,,nPosX,nPosY,,.T.,.T.)

        if (lRet)
            //Lugar que ira citar uma variavel para receber o que foi escolhido no combobox a cima. Como faço isso ?
            cImp   := aParams[1]
            cEst   := aParams[2]
            cRolo  := aParams[3]
            cData1 := DTOC(aParams[4])
            cData2 := DTOC(aParams[5])
        else
            Sleep(10)
        endif

        ELSEIF SELECT('ZM2') > 0 

        fPopulaImp()

        for nI := 1 to len(aColsAux)

            AADD(aColsImp,aColsAux[nI][2])

        next

        aAdd(aParamBox, {2, "Impressora", 0 ,  aColsImp, 80, ".T.",.T.})
        aAdd(aParamBox, {2, "Troca lampada"   , 0 ,  aColsLP, 80, ".T.",.T.})
        aAdd(aParamBox, {2, "Troca Refletor"     , 0 ,  aColsRef , 80, ".T.",.T.})
        aAdd(aParamBox, {1, "Data De"   , CTOD('') ,  "", ".T.", "", ".T.", 80,  .T.})
        aAdd(aParamBox, {1, "Data Até"  , CTOD('') ,  "", ".T.", "", ".T.", 80,  .T.})

        lRet := ParamBox(aParamBox,cTitulo,aParams,,,,nPosX,nPosY,,.T.,.T.)

        if (lRet)
            cImp   := aParams[1]
            cRef   := aParams[2]
            cLamp  := aParams[3]
            cData1 := DTOC(aParams[4])
            cData2 := DTOC(aParams[5])
        else
            Sleep(10)
        endif

    ENDIF

return

User Function R3SelecioZM1()

    Local aArea := FwGetArea()

    DbSelectArea('ZM1')

    menuEscR3()

    ZM1->(DbCloseArea())

    FwRestArea(aArea)

return


Static function menuEscR3() 

    Local aArea := FwGetArea()

    Private cData1 := CTOD('')
    Private cData2 := CTOD('')
    Private cImp  
    Private lRet := .T. 

    getParamR3()

    if lRet == .T.
        if Select('ZM1') > 0
            FWMsgRun(,{|oSay| proqR3()}, 'Buscando informações da tabela ZM1990', 'Gerando Excell')
        endif
    endif

    FwRestArea(aArea)

Return

Static Function proqR3()

    Local aArea := FwGetArea()
    Local cQry  := ''
    Local cAlias := ""
    Local aDados := {}

    If SELECT('ZM1') > 0 

        cQry := "SELECT * FROM " + RetSqlName('ZM1') + " WHERE D_E_L_E_T_ = '' AND ZM1_IMPRES = '"+ cImp +"' AND ZM1_DATACA BETWEEN '"  + cData1 + "' AND '" + cData2 +"' "  

        cAlias := 'QZC_ZM1'

        TCQUERY cQry NEW ALIAS (cAlias)

        (cAlias)->(DbGoTop())

        Do While !(cAlias)->(Eof())

        AaDd(aDados,{(cAlias)->ZM1_COD,;
                     (cAlias)->ZM1_IMPRES,;
                     (cAlias)->ZM1_EST,;
                     (cAlias)->ZM1_USU,;
                     (cAlias)->ZM1_ROLO,;
                     (cAlias)->ZM1_FAB,;
                     (cAlias)->ZM1_DATAIN,;
                     (cAlias)->ZM1_OBS,;
                     (cAlias)->ZM1_DATACA,;
                     (cAlias)->ZM1_ATIVO,;
                     (cAlias)->ZM1_METRA,;
                     .F.})

        (cAlias)->(DbSkip())
        enddo

        (cAlias)->(DbCloseArea())

        R2geraExcell(aDados)
    endif

    FwRestArea(aArea)
return

Static function getParamR3()

    Local aParamBox     := {}
    Local cTitulo       := 'RELATORIO'
    Local nPosX         := 200
    Local nPosY         := 300
    Local aParams       := {}
    Local nI 
    Private aColsAux    := {}
    Private aColsImp    := {}
    Private lTf         := .F.

    If SELECT('ZM1') > 0

        fPopulaImp()

        for nI := 1 to len(aColsAux)

            AADD(aColsImp,aColsAux[nI][2])

        next

        aAdd(aParamBox, {2, "Impressora", 0 ,  aColsImp, 80, ".T.",.T.})

        aAdd(aParamBox, {1, "Data De"   , CTOD('') ,  "", ".T.", "", ".T.", 80,  .T.})
        aAdd(aParamBox, {1, "Data Até"  , CTOD('') ,  "", ".T.", "", ".T.", 80,  .T.})

        lRet := ParamBox(aParamBox,cTitulo,aParams,,,,nPosX,nPosY,,.T.,.T.)

        if (lRet)
            cImp   := aParams[1]
            cData1 := DTOC(aParams[2])
            cData2 := DTOC(aParams[3])
        else
            Sleep(100)
        endif

    endif

return
