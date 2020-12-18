#INCLUDE "QPPR150.CH"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � QPPR150  � Autor � Robson Ramiro A. Olive� Data � 27.02.02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Diagrama de Fluxo                                          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � QPPR150(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � PPAP                                                       ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Robson Ramiro�15.10.02�      � Inclusao de legenda, impressao das     ���
���              �        �      � observacoes e impressao na mBrowse     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User QPPR1501(lBrow,cPecaAuto,cJPEG)

Local oPrint
Local lPergunte	:= .F.
Local cFiltro	:= ""
Local aArea		:= GetArea()
Local cStartPath 	:= GetSrvProfString("Startpath","")

Private cPecaRev 	:= ""
Private axTex 	 := {}
Private	cTextRet := ""

Default lBrow 		:= .F.
Default cPecaAuto	:= ""
Default cJPEG       := ""        

If Right(cStartPath,1) <> "\"
	cStartPath += "\"
Endif

If !Empty(cPecaAuto)
	cPecaRev := cPecaAuto
Endif

oPrint	:= TMSPrinter():New(STR0001) //"Diagrama de Fluxo"
If ! oPrint:IsPrinterActive()
	oPrint:Setup()  // Escolhe a impressora
Endif 
oPrint:SetPortrait()

//�����������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros							�
//� mv_par01				// Peca       							�
//� mv_par02				// Revisao        						�
//� mv_par03				// Impressora / Tela          			�
//�������������������������������������������������������������������

If Empty(cPecaAuto)
	If AllTrim(FunName()) == "QPPA150"
		cPecaRev := Iif(!lBrow, M->QKN_PECA + M->QKN_REV, QKN->QKN_PECA + QKN->QKN_REV)
	Else
		lPergunte := Pergunte("PPR180",.T.)

		If lPergunte
			cPecaRev := mv_par01 + mv_par02	
		Else
			Return Nil
		Endif
	Endif
Endif
	
PPAPBMP("A3.BMP", cStartPath)
PPAPBMP("F1.BMP", cStartPath)
PPAPBMP("B4.BMP", cStartPath)
PPAPBMP("C7.BMP", cStartPath)
PPAPBMP("E8.BMP", cStartPath)
PPAPBMP("D9.BMP", cStartPath)

PPAPBMP("B8.BMP", cStartPath)
PPAPBMP("D7.BMP", cStartPath)
PPAPBMP("F7.BMP", cStartPath)
PPAPBMP("E5.BMP", cStartPath)
PPAPBMP("E7.BMP", cStartPath)
PPAPBMP("F8.BMP", cStartPath)
PPAPBMP("E9.BMP", cStartPath)
PPAPBMP("F2.BMP", cStartPath)
PPAPBMP("F3.BMP", cStartPath)
PPAPBMP("F4.BMP", cStartPath)
PPAPBMP("F5.BMP", cStartPath)
PPAPBMP("F6.BMP", cStartPath)

DbSelectArea("QK1")
DbSetOrder(1)
DbSeek(xFilial()+cPecaRev)

DbSelectArea("QKN")

cFiltro := DbFilter()

If !Empty(cFiltro)
	Set Filter To
Endif

DbSetOrder(1)
If DbSeek(xFilial()+cPecaRev)

	If Empty(cPecaAuto)
		MsgRun(STR0002,"",{|| CursorWait(), MontaRel(oPrint) ,CursorArrow()}) //"Gerando Visualizacao, Aguarde..."
	Else
		MontaRel(oPrint)
	Endif

	If lPergunte .and. mv_par03 == 1 .or. !Empty(cPecaAuto)
		If !Empty(cJPEG)
			oPrint:SaveAllAsJPEG(cStartPath+cJPEG,865,1110,140)
		Else 
			oPrint:Print()
		EndIF
	Else
		oPrint:Preview()  		// Visualiza antes de imprimir
	Endif
Endif

If !Empty(cFiltro)
	Set Filter To &cFiltro
Endif

If !lPergunte
	RestArea(aArea)
Endif

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � MontaRel � Autor � Robson Ramiro A. Olive� Data � 21.06.01 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Digrama de Fluxo                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MontaRel(ExpO1)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oPrint                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � QPPR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MontaRel(oPrint)

Local i 			:= 1
Local lin 			:= 500
Local nx 			:=1
Private oFont16, oFont08, oFont10, oFontCou08, oFont07

oFont16		:= TFont():New("Arial" ,16,16,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial" ,08,08,,.F.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial" ,10,10,,.F.,,,,.T.,.F.)
oFontCou08	:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
oFont07		:= TFont():New("Arial" ,07,07,,.F.,,,,.T.,.F.)
oFont06		:= TFont():New("Arial" ,06,06,,.F.,,,,.T.,.F.)

Cabecalho(oPrint,i)  			// Funcao que monta o cabecalho

DbSelectArea("QKN")

Do While !Eof() .and. QKN->QKN_PECA+QKN->QKN_REV == cPecaRev

	If lin > 2720
		i++
		oPrint:EndPage() 		// Finaliza a pagina
		Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
		lin := 500
	Endif
	
	lin += 90
	oPrint:SayBitmap(lin,050, QKN->QKN_SIMB1+".BMP",80,80)
	If !Empty(QKN->QKN_SIMB2)
		oPrint:SayBitmap(lin,150, QKN->QKN_SIMB2+".BMP",80,80)
	Endif

	oPrint:Say(lin,0260,QKN->QKN_NOPE,oFont10)
	oPrint:Say(lin,0390,Subs(QKN->QKN_DESC,1,30),oFont10)

	If Len(QKN->QKN_DESC) > 30
		oPrint:Say(lin+40,0390,Subs(QKN->QKN_DESC,31,30),oFont10)
	Endif

	axTex := {}
	cTextRet := ""
	cTextRet := QO_Rectxt(QKN->QKN_CHAVE,"QPPA150 ",1,TamSX3("QKO_TEXTO")[1],"QKO")
	axTex := Q_MemoArray(cTextRet,axTex,TamSX3("QKO_TEXTO")[1])

	For nx :=1 To Len(axTex)
		If !Empty(axTex[nx])
			oPrint:Say(lin,1050,axTex[nx],oFontCou08)
			lin += 40
			If lin > 2720
				i++
				oPrint:EndPage() 		// Finaliza a pagina
				Cabecalho(oPrint,i)  	// Funcao que monta o cabecalho
				lin := 550
			Endif
		Endif
	Next nx

	DbSelectArea("QKN")

	DbSkip()

Enddo

Return Nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � Cabecalho� Autor � Robson Ramiro A. Olive� Data � 27.02.02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Cabecalho do relatorio                                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Cabecalho(ExpO1)                                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oPrint                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � QPPR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Cabecalho(oPrint,i)

Local cFileLogo  := "LGRL"+SM0->M0_CODIGO+FWCodFil()+".BMP" // Empresa+Filial

If !File(cFileLogo)
	cFileLogo := "LGRL" + SM0->M0_CODIGO+".BMP" // Empresa
Endif

oPrint:StartPage() 		// Inicia uma nova pagina

oPrint:SayBitmap(05,0005, cFileLogo,328,82)             // Tem que estar abaixo do RootPath
oPrint:SayBitmap(05,2100, "Logo.bmp",237,58)

oPrint:Say(040,700,STR0003,oFont16) //"DIAGRAMA DE FLUXO DO PROCESSO"

oPrint:Say(101,160,STR0014,oFont08 )  //"PPAP No."
oPrint:Say(101,290,QK1->QK1_PPAP,oFont08)

oPrint:Say(101,1800,STR0004,oFont08 )  //"Pagina :"
oPrint:Say(101,1950,StrZero(i,3),oFont08)

//Box Cabecalho
oPrint:Box( 150, 30, 310, 2350 )

//Box Itens
oPrint:Box( 330, 30, 2890, 2350 )

// Construcao da Grade cabecalho
oPrint:Line( 230, 0030, 230, 2350 )   	// horizontal

oPrint:Line( 150, 1400, 310, 1400 )   	// vertical
                                                 
oPrint:Line( 150, 1875, 230, 1875 )   	// vertical

oPrint:Line( 230, 662, 310, 662 )   	// vertical  

// Construcao da Grade itens
oPrint:Line( 430, 0030, 430, 2350 )    // horizontal

oPrint:Line( 530, 0030, 530, 2350 )    // horizontal

// Descricao do Cabecalho
oPrint:Say(160,0040,STR0005,oFont08 )  //"Fornecedor"
oPrint:Say(200,0040,SM0->M0_NOMECOM,oFontCou08)

oPrint:Say(160,1410,STR0006,oFont08 )  //"Numero da Peca(Cliente)"
oPrint:Say(200,1410,Subs(QK1->QK1_PCCLI,1,27),oFontCou08)

oPrint:Say(160,1885,STR0007,oFont08 )  //"Revisao/Data Desenho"
oPrint:Say(200,1885,AllTrim(QK1->QK1_REVDES)+" / "+DtoC(QK1->QK1_DTRDES),oFontCou08)
                                                     
oPrint:Say(240,0040,STR0008,oFont08 ) //"Aprovado Por / Data"
oPrint:Say(280,0045,AllTrim(QKN->QKN_APRPOR) +" / "+ DtoC(QKN->QKN_DTAPR),oFontCou08)

oPrint:Say(240,0667,STR0009,oFont08 ) //"Numero/Rev Peca(Fornecedor)"
oPrint:Say(280,0667,AllTrim(QK1->QK1_PECA)+"/"+ QK1->QK1_REV,oFontCou08)

oPrint:Say(240,1410,STR0010,oFont08 ) //"Nome da Peca"
oPrint:Say(280,1410,Subs(QK1->QK1_DESC,1,50),oFontCou08)

// Legenda
oPrint:SayBitmap(360,0040,"A3.BMP",60,60)
oPrint:SayBitmap(360,0425,"F1.BMP",60,60)
oPrint:SayBitmap(360,0810,"B4.BMP",60,60)
oPrint:SayBitmap(360,1195,"C7.BMP",60,60)
oPrint:SayBitmap(360,1580,"E8.BMP",60,60)
oPrint:SayBitmap(360,1965,"D9.BMP",60,60)

oPrint:Say(375,0110,STR0015,oFont08) //"Operacao"
oPrint:Say(375,0495,STR0016,oFont08) //"Operacao c/ Inspecao"
oPrint:Say(375,0880,STR0017,oFont08) //"Inspecao"
oPrint:Say(375,1265,STR0018,oFont08) //"Estocagem"
oPrint:Say(375,1650,STR0019,oFont08) //"Transporte"
oPrint:Say(375,2035,STR0020,oFont08) //"Decisao"

// Descricao dos itens
oPrint:Say(470,0050,STR0011,oFont10) //"Fluxo"
oPrint:Say(470,0260,STR0012,oFont10) //"No."
oPrint:Say(470,0450,STR0013,oFont10) //"Descricao da Operacao"
oPrint:Say(470,1500,STR0021,oFont10) //"Observacoes"

Return Nil
