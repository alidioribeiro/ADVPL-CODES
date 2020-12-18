#INCLUDE "Protheus.ch"
#include "rwmake.ch"
#INCLUDE "Colors.ch"
#INCLUDE "RPTDEF.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBiCONN.ch"


/*/{Protheus.doc}TAFATR02 
	@description
	Impressao nota fiscal de serviço de comunicaçao (Modelo 21)
	 
	@author	Bruno Garcia
	@version	1.0
	@since		03/06/2015
	@return	Nao possui,Nao Possui,Nao possui
	@param 		Nao possui,Nao Possui,Nao possui										
/*/
User Function TAFATR02()
//Referente ao objeto de impressao
Local lAdjustToLegacy	:= .T.	//Habilita a compatibilidade com a classe TMSPrinter
Local lDisableSetup  	:= .T.	//Desabilita o setup de impressao
Local cFilePrint 			:= "FAT_"+Dtos(MSDate())+StrTran(Time(),":","") //Nome do arquivo PDF a ser gerado
Local cPerg := PadR("TAFATR02",Len(SX1->X1_GRUPO))          

Local cCodEmp	:= SM0->M0_CODIGO //Codigo da empresa logada

Private oPrinter 	:= Nil	//Objeto de impressao
//Referente ao controle de linhas e colunas
Private nPadding	:= 10
Private nLinMin  	:= 40
Private nColMin  	:= 35
Private nLin		:= 0		//para controlar o incremento da linha 
Private nLinMaxPg	:= 0		//oPrinter:nVertRes() - nLinMin
Private nColMax 	:= 0		//oPrinter:nHorzRes() - nColMin
Private nPag		:= 0

Private cPixel	:= "-6" 	//Expessura da linha do BOX em pixels
Private nAltBox	:= 6		//Altura dos box
Private MINRODAPE := 1800
Private MAXMENLIN := 14
Private MAXMENOBS := 120
Private MAXDESCOD := 44
Private MAXITENS  := 0  //valor maximo para quebra de pagina na impressao dos itens
Private fItem  := Nil

Private nColTot	:= 0
//********************************//

//Referente a impressao dos dados
Private cCfop 	:= ""
Private cTextCf	:= ""
Private nPerIcm	:= 0
Private cResFisco	:= ""
Private cCliente	:= ""
Private cLoja	:= ""
Private cCliCob	:= ""
Private cLojCob	:= ""
Private cLogo		:= ""
Private cLogOrig	:= ""

Private cDoc		:= ""
Private nTotalDoc	:= 0
Private nBaseICMS	:= 0
Private nValICMS	:= 0 

Private aTit		:= {}
Private aTitImp	:= {} //Titulos de impostos
Private lCliGov	:= .F. //Valida se o cliente é governo federal
       
//Variaveis da tela
Private mInfObs		:= Space(1000)
Private cMens1		:= Space(40)
Private cMens2		:= Space(40)
Private cMens3		:= Space(40)
Private cMens4		:= Space(40)
Private cSelo		:= Space(09)   
 
ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
EndIf

//Seta o nome da logo
If cCodEmp == "01"
	cLogOrig := cLogo := "\Logo\TVA.PNG"
ElseIf cCodEmp == "02"
	cLogOrig := cLogo:= "\Logo\RAC.PNG"		
ElseIf cCodEmp == "03"	            
	cLogOrig := cLogo:= "\Logo\JP.PNG"		
ElseIf cCodEmp == "04"	            
	cLogOrig := cLogo:= "\Logo\REDETV.PNG"		
EndIf

oPrinter := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, , lDisableSetup, , , , , , .F., )
oPrinter:SetResolution(72)
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4) 
oPrinter:SetMargin(0,0,0,0)
oPrinter:cPathPDF := "C:\TEMP\"


nLinMaxPg 	:= oPrinter:nVertRes() - (nPadding * 20)
nColMax 	:= oPrinter:nHorzRes() -  nColMin
                                                            
     
//Valida os parametros
SF2->(dbSetOrder(1))
If SF2->(dbSeek(xFilial("SF2") + mv_par01 + mv_par03))
	fImpNota()
Else
	Alert("Nenhum registro foi encontrado com base nos parâmetros informados.")
	Return
EndIf

fRename(cLogo, cLogOrig)
Return

Static Function fImpNota()
Local aItens := {} //Vetor para imprimir os totais dos itens
Local nI := 0
Local nTotDescAg := 0
Local nX :=0

//Definição das Fontes
DEFINE FONT oFont08  NAME "Arial" SIZE 0,08      OF oPrinter 
DEFINE FONT oFont08b NAME "Arial" SIZE 0,08 Bold OF oPrinter 
DEFINE FONT oFont10  NAME "Arial" SIZE 0,10      OF oPrinter 
DEFINE FONT oFont10b NAME "Arial" SIZE 0,10 Bold OF oPrinter 
DEFINE FONT oFont12  NAME "Arial" SIZE 0,12      OF oPrinter 
DEFINE FONT oFont12b NAME "Arial" SIZE 0,12 Bold OF oPrinter 
DEFINE FONT oFont14  NAME "Arial" SIZE 0,14      OF oPrinter 
DEFINE FONT oFont14b NAME "Arial" SIZE 0,14 Bold OF oPrinter 
DEFINE FONT oFont16  NAME "Arial" SIZE 0,16      OF oPrinter 
DEFINE FONT oFont16b NAME "Arial" SIZE 0,16 Bold OF oPrinter


//altura da fonte
nFont08bH := oPrinter:GetTextheight( "T", oFont08b)
nFont08H  := oPrinter:GetTextheight( "T", oFont08)
nFont10bH := oPrinter:GetTextheight( "T", oFont10b)
nFont10H  := oPrinter:GetTextheight( "T", oFont10)
nFont12bH := oPrinter:GetTextheight( "T", oFont12b)
nFont12H  := oPrinter:GetTextheight( "T", oFont12)
nFont14bH := oPrinter:GetTextheight( "T", oFont14b)
nFont16bH := oPrinter:GetTextheight( "T", oFont16b)

//fonte de impressao dos itens
fItem := oFont10 
 
MAXITENS := MINRODAPE - (nFont10H * 3) // Seta o limite de impressao dos itens

nCodigoL   := oPrinter:GetTextWidth(Replicate("T", TamSx3('B1_COD')[1]), fItem, oPrinter)
nDescriL   := oPrinter:GetTextWidth(Replicate("T", MAXDESCOD), fItem, oPrinter)
nVlrTotalL := oPrinter:GetTextWidth(Replicate("T", TamSx3('C7_TOTAL')[1]), fItem, oPrinter)

nLin := nLinMaxPg

//Indices das tabelas
SD2->(dbSetOrder(3)) //- Item nota fiscal
SB1->(dbSetOrder(1)) //- Produto
SF4->(dbSetOrder(1)) //- TES
SE1->(dbSetOrder(1)) //- Contas a receber
SC5->(dbSetOrder(1)) //- Cabeçalho do Pedido
SA1->(dbSetOrder(1)) // Cadastro de clientes
SX5->(dbSetOrder(1))	//Tabelas genericas

//Percorre a(s) nota(s) informadas
While !SF2->(Eof()) .and. SF2->F2_FILIAL == xFilial("SF2");
	.and. SF2->F2_DOC   <= mv_par02;//.And. SF2->F2_DOC   >= mv_par01 .And. SF2->F2_DOC   <= mv_par02;
	.And. SF2->F2_SERIE == mv_par03                  
	SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))
	
	nPag := 0
	    
	//Chama a tela 	
	MostraTela()
	
	nTotDescAg := 0
	
	//Busca o valor do campo "Reservado ao fisco" F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT
	cResFisco := Posicione("SF3",5,SF2->(F2_FILIAL+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA),"F3_MDCAT79")

	cCfop 		:= Posicione("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,"D2_CF")
	cTextCf		:= Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_TEXTO")	
	nPerIcm		:= SD2->D2_PICM
	
	cDoc		:= SF2->F2_DOC
	nTotalDoc	:= SF2->F2_VALBRUT
	nValICMS	:= SF2->F2_VALICM 
	
	SE1->(dbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC))	
	cCliente:= SF2->F2_CLIENTE//SC5->C5_CLIENTE
	cLoja	:= SF2->F2_LOJA//SC5->C5_LOJACLI

	If SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO))
		cCliCob	:= SC5->C5_XCLICOB
		cLojCob	:= SC5->C5_XLOJCOB
	EndIf	

	aTit 	:= {}
	aTitImp:= {}
	cMens4	:= ""
	
	lCliGov	:= .F.
	//Valida se é GOV FEDERAL e se houve renteçao dos impostos
	If SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))
		If AllTrim(SA1->A1_NATUREZ) == "100.008" 	
			lCliGov	:= .T.
			cMens4 := "Conforme Instrução Normativa IN SRF Nº 475/2014 Art 2º (Retenção da CSLL, da Cofins e da Contribuição para o Pis/Pasep retido na Fonte) e IN RFB /2012."
		EndIf
	EndIf
			
	//Verifica as parcelas do titulo 
	While !SE1->(Eof()) .And. SE1->E1_PREFIXO == SF2->F2_SERIE .And. SE1->E1_NUM == SF2->F2_DOC
		
		//Verifca se o titulo é de imposto e o cliente e gov federal com A1_NATUREZ = 100.008 
		If SE1->E1_TIPO $ "CF-,CS-,IR-,PI-" .And. lCliGov 
			AAdd(aTitImp,{SE1->E1_NUM,SE1->E1_VALOR,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_TIPO})
		Else	
			AAdd(aTit,{SE1->E1_NUM,SE1->E1_VALOR,SE1->E1_EMISSAO,SE1->E1_VENCREA,SE1->E1_TIPO})
		EndIf
					
		SE1->(dbSkip())
	EndDo

	nLin := fCabecalho() + nPadding
	aItens := {}
	
	//Percorre itens da nota
	If SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
		While !SD2->(Eof()) .and. SD2->D2_FILIAL == SF2->F2_FILIAL ;
							.and. SD2->D2_DOC == SF2->F2_DOC ;
							.and. SD2->D2_SERIE == SF2->F2_SERIE
	
	    	SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD))
	    	SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
	
	    	lBonif := (SF4->F4_XBONIF == 'S') //Possui item de bonificação?

	    	nValItem := If(!lBonif,SD2->D2_VALBRUT+SD2->D2_XDESCAG,0)
	    	nTotDescAg += SD2->D2_XDESCAG
	    	
	    	aadd(aItens,{SB1->B1_COD,;			// Código do produto
	    				Left(SB1->B1_DESC,44),;	// Descrição do produto
	    				lBonif,;				// É bonificado?
	    				nValItem})				// Valor do item
	    	
	    	SD2->(dbSkip())
	    EndDo
	EndIf    
	
	If Len(aTitImp) > 0
	
		//Adicionna uma linha em branco para separar os itens dos impostos
		AAdd(aItens,{	"",;	// Código do produto
    					"",;	// Descrição do produto
    					.F.,;	// É bonificado?
    					0})		// Valor do item
    					
		For nI := 1 To Len(aTitImp)
		    	AAdd(aItens,{aTitImp[nI][1],;			// Código do produto
    				Left(Posicione("SX5",1,xFilial("SX5") + "05" + aTitImp[nI][5],"X5_DESCRI"),44),;	// Descrição do produto
    				lBonif,;				// É bonificado?
    				aTitImp[nI][2]})				// Valor do item	
		Next nI
	EndIf
	    
	If nTotDescAg > 0
		cMensAg := "(-) DESCONTO PADRÃO AGÊNCIA"
		aadd(aItens,{"",cMensAg,.F.,nTotDescAg})
	Endif     
	
	//Imprimi os itens 
	For nI := 1 To Len(aItens)
		fImpItem(aItens[nI]) 
	Next nI
	
	fRodape()		
	
	SF2->(dbSkip())
	

EndDo



oPrinter:EndPage()
oPrinter:Preview()  
FreeObj(oPrinter)
oPrinter := Nil



Return

Static Function fCabecalho()
Local nLinTmp 	:= 0
Local nLinAux		:= 0
Local cStrAux 	:= ""
Local nWidthAux	:= 0
Local nLinMaxCab	:= nFont16bH + nFont14bH + (nFont10H * 5) + (nPadding * 2) //linha max do box do cabecalho 
Local nRet		:= 0 //Ultima linha utilizada no cabeçalho
Local nLinObs	:= 0
Local cBitMap	:= "\system\Logo\"//GetSrvProfString("Startpath","") + ""
Local cDescLogo	:= ""                     

Local nColEmp	:= nPadding * 50
Local cMens		:= ""
Local nx := 0
		              

//Inicia uma nova pagina
oPrinter:StartPage()
nPag++ //Incrementa o valor da pagina

//Box principal do relatorio
aBox := {nLinMin, nColMin, nLinMaxPg,nColMax}
oPrinter:Box(aBox[1], aBox[2], aBox[3], aBox[4],cPixel)

//Box logo - Dados da Empresa
aBox1 := {nLinMin + (nPadding * 2), nColMin + (nPadding * 2), nLinMin + nLinMaxCab,nPadding * 130}
oPrinter:Box(aBox1[1], aBox1[2], aBox1[3], aBox1[4])

//Imprimi logo
fRename(cLogo, cLogo+cValToChar(nPag))  
cLogo := cLogo+cValToChar(nPag)

oPrinter:SayBitmap(aBox1[1] + nPadding*3, aBox1[2] + nPadding*2,cLogo,300,166)  //Logo da empresa

nLinTmp := aBox1[1] + nPadding*3

nLinAux := nLinTmp := aBox1[1]
oPrinter:Say(nLinAux += nFont08bH, aBox1[2] + nColEmp   ,Alltrim(SM0->M0_NOMECOM), oFont10b)
oPrinter:Say(nLinAux += nFont08bH, aBox1[2] + nColEmp   ,Alltrim(SM0->M0_ENDCOB) + " - " + Alltrim(SM0->M0_BAIRCOB), oFont10b)
oPrinter:Say(nLinAux += nFont08bH, aBox1[2] + nColEmp   ,"CEP: " + Transform(Alltrim(SM0->M0_CEPENT),"@R 99999-999") + " - " + Alltrim(SM0->M0_CIDENT) + " - " + Alltrim(SM0->M0_ESTENT) , oFont10b)
oPrinter:Say(nLinAux += nFont08bH, aBox1[2] + nColEmp   ,"FONE: " + Alltrim(SM0->M0_TEL) /*+ " - FAX: " + Alltrim(SM0->M0_FAX)*/, oFont10b)
oPrinter:Say(nLinAux += nFont08bH, aBox1[2] + nColEmp   ,"INSC. C.N.P.J.: " + Transform(SM0->M0_CGC, "@R 99.999.999/9999-99"), oFont10b)
oPrinter:Say(nLinAux += nFont08bH, aBox1[2] + nColEmp   ,"INSC. EST.: " + Transform(SM0->M0_INSC, "@R 99.999.999-99"), oFont10b)
//********/

//Box informaçoes da nota
aBox2 := {aBox1[1], aBox1[4], aBox1[3] , aBox[4] - (nPadding * 2)}
oPrinter:Box(aBox2[1], aBox2[2], aBox2[3], aBox2[4])

nLinAux:= nLinTmp := aBox1[1]

oPrinter:Say( nLinAux += (nPadding*3), aBox2[2]+(nPadding*15)   ,"NOTA FISCAL FATURA DE SERVIÇO DE COMUNICAÇÃO", oFont12b)
oPrinter:Say( nLinAux += nFont10bH * 2, aBox2[2]+(nPadding*15)  ,"1ª Via", oFont10b)
oPrinter:Say( nLinAux += nFont08bH, aBox2[2]+(nPadding*7)  ,"SÉRIE ÚNICA", oFont10b)

oPrinter:Say( nLinAux += nFont10bH * 3, aBox2[2]+(nPadding*7)   ,"Nº", oFont12b)
oPrinter:Say( nLinAux, aBox2[2] +(nPadding*12),SF2->F2_DOC, oFont16b)           

oPrinter:Say( nLinAux, aBox2[2] +(nPadding*70),"Pag.: " + StrZero(nPag,3), oFont12b)
//*******/

//Box informaçoes da nota
aBox3 := {aBox2[1], aBox1[4] + (nPadding*70), aBox2[1] + (nPadding*11), aBox[4] - (nPadding * 2)}
//oPrinter:Box(aBox3[1], aBox3[2], aBox3[3], aBox3[4])

nLinTmp := aBox3[1]
//oPrinter:Say( nLinTmp += (nPadding*4), aBox3[2]+(nPadding*3)   ,"Nº", oFont12b)
//oPrinter:Say( nLinTmp + (nPadding*4), aBox3[2] +(nPadding*20),SF2->F2_DOC, oFont16b)

//Box serie
aBox4 := {aBox3[3], aBox3[2], aBox2[3], aBox3[4]}
//oPrinter:Box(aBox4[1], aBox4[2], aBox4[3], aBox4[4])

nLinTmp := aBox4[1]
//oPrinter:Say( nLinTmp += (nPadding*4), aBox4[2]+(nPadding*23)   ,"1ª Via", oFont12b)
//oPrinter:Say( nLinTmp += (nFont10bH), aBox4[2]+(nPadding*19)   ,"SÉRIE ÚNICA", oFont12b)

//Box natureza
aBox5 := {aBox1[3] + (nPadding * 4), aBox1[2], aBox1[3] + (nPadding * 10), aBox4[2]}
oPrinter:Box(aBox5[1], aBox5[2], aBox5[3], aBox5[4])

nLinTmp := aBox5[1]
oPrinter:Say( nLinTmp += (nPadding*2), aBox5[2] + nPadding,"NATUREZA DA PRESTAÇÃO", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox5[2] + nPadding,cTextCf, oFont10)

//Box CFOP
oPrinter:Box(aBox5[1], aBox3[2], aBox5[3], aBox4[4])
oPrinter:Say( nLinTmp , aBox5[4]+(nPadding*18)   ,"C.F.O.P", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox3[2] + nPadding,cCfop, oFont10)

//Box destinatario/remetente
aBox6 := {aBox5[3] + (nPadding * 4), aBox1[2], aBox5[3] + (nPadding * 10), aBox1[2] + (nPadding * 130) }
oPrinter:Box(aBox6[1], aBox6[2], aBox6[3], aBox6[4])


//Pesquisa o os dados do cliente
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1") + SF2->(F2_CLIENTE + F2_LOJA)))  
 
nLinTmp := aBox6[1]
oPrinter:Say( nLinTmp - nPadding, aBox5[2] + nPadding,"CLIENTE", oFont08b)
oPrinter:Say( nLinTmp += (nPadding*2), aBox5[2] + nPadding,"NOME/RAZÃO SOCIAL", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox5[2] + nPadding,AllTrim(SA1->A1_NOME), oFont10)

//Box CNPJ
oPrinter:Box(aBox6[1], aBox6[4] , aBox6[3], aBox3[2])
oPrinter:Say( nLinTmp, aBox6[4] + nPadding,"C.N.P.J. / C.P.F.", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox6[4] + nPadding,Transform(AllTrim(SA1->A1_CGC),"@R 99.999.999/9999-99"), oFont10)

//Box data emissao
oPrinter:Box(aBox6[1], aBox3[2], aBox6[3], aBox4[4])
oPrinter:Say( nLinTmp, aBox3[2] + nPadding,"DATA DA EMISSÃO", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox3[2] + nPadding,DToC(SF2->F2_EMISSAO), oFont10)

//Box endereço
aBox7 := {aBox6[3], aBox6[2], aBox6[3] + (nPadding * 6), aBox6[4]}
oPrinter:Box(aBox7[1], aBox7[2], aBox7[3], aBox7[4])

nLinTmp := aBox7[1]
oPrinter:Say( nLinTmp += (nPadding*2), aBox7[2] + nPadding,"ENDEREÇO", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox7[2] + nPadding,Alltrim(SA1->A1_END), oFont10)

//Box bairro
oPrinter:Box(aBox7[1], aBox7[4] , aBox7[3], aBox3[2])
oPrinter:Say( nLinTmp, aBox7[4] + nPadding,"BAIRRO/DISTRITO", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox7[4] + nPadding,Alltrim(SA1->A1_BAIRRO), oFont10)

//Box CEP
oPrinter:Box(aBox7[1], aBox3[2], aBox7[3], aBox4[4])
oPrinter:Say( nLinTmp, aBox3[2] + nPadding,"CEP", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox3[2] + nPadding,Transform(Alltrim(SA1->A1_CEP),"@R 99999-999"), oFont10)

//Box municipio
aBox8 := {aBox7[3], aBox1[2], aBox7[3] + (nPadding * 6), aBox1[2] + (nPadding * 80)}
oPrinter:Box(aBox8[1], aBox8[2], aBox8[3], aBox8[4])

nLinTmp := aBox8[1]
oPrinter:Say( nLinTmp += (nPadding*2), aBox8[2] + nPadding,"MUNICIPIO", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox8[2] + nPadding,Alltrim(SA1->A1_MUN), oFont10)

//Box fone
oPrinter:Box(aBox8[1], aBox8[4], aBox8[3], aBox7[4])
oPrinter:Say( nLinTmp, aBox8[4] + nPadding,"FONE/FAX", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox8[4] + nPadding,"(" + Alltrim(SA1->A1_DDD) + ") " + Alltrim(SA1->A1_TEL), oFont10)

//Box UF
oPrinter:Box(aBox8[1],aBox7[4],aBox8[3],aBox7[4] + (nPadding * 14))
oPrinter:Say( nLinTmp, aBox7[4] + nPadding,"U.F", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox7[4] + nPadding,Alltrim(SA1->A1_EST), oFont10)

//Box Inscriçao estadual
oPrinter:Box(aBox8[1], aBox7[4] + (nPadding * 14),aBox8[3], aBox4[4] + 2)
oPrinter:Say( nLinTmp, aBox7[4] + (nPadding * 14) + nPadding,"INSCRIÇÃO ESTADUAL", oFont08b)
oPrinter:Say( nLinTmp + (nPadding*3), aBox7[4] + (nPadding * 15),Alltrim(SA1->A1_INSCR), oFont10)


//Box discriminação serviço
aBox9 := {aBox8[3], aBox1[2], aBox8[3] + (nPadding * 6),aBox1[2] + (nPadding * 190)}
oPrinter:Box(aBox9[1], aBox9[2], aBox9[3], aBox9[4])

nLinTmp := aBox9[1]
oPrinter:Say(nLinTmp += (nPadding*2), aBox9[2] + (nPadding * 75),"DISCRIMINAÇÃO DO SERVIÇO", oFont08b)
oPrinter:Say(nLinTmp + (nPadding*2), aBox9[2] + (nPadding * 80),"ESPECIFICAÇÕES", oFont08b)

//Box TOTAL
oPrinter:Box(aBox9[1], aBox9[4], aBox9[3], aBox3[4])
oPrinter:Say(nLinTmp, aBox9[4] + (nPadding * 15),"TOTAL", oFont08b)

//Seta a coluna de impressao dos totais
nColTot := aBox9[4] + (nPadding * 7)

//Box ITENS
aBox10 := {aBox9[3], aBox1[2], MINRODAPE,aBox9[4]}
oPrinter:Box(aBox10[1], aBox10[2],aBox10[3], aBox10[4])

//Informaçoes ISS/Carga tributaria/ICMS
nLinAux		:= aBox10[3] - nPadding * 8

cMens := cMens4
oPrinter:Say(nLinAux,aBox10[2] + nPadding * 2 ,cMens, oFont08)

cMens := "Não incidência do ISS por ausência de expressa previsão no rol taxativo de serviços previstos no parágrafo único do art. 21 da Lei 1.697/1983" 
oPrinter:Say(nLinAux += nPadding * 2.5,aBox10[2] + nPadding * 2 ,cMens, oFont08)

cMens := "Carga tributária, conforme art 1o. da Lei 12.741/2012"	
oPrinter:Say(nLinAux += nPadding * 2.5,aBox10[2] + nPadding * 2 ,cMens, oFont08)

cMens := "Não incide ICMS, conforme artigo 4°, inciso XVII, do Decreto Estadual n. 20.686/99 (RICMS/AM)"
oPrinter:Say(nLinAux += nPadding * 2.5,aBox10[2] + nPadding * 2 ,cMens, oFont08)
	
//Remove a quebra de linha 
cAux := StrTran(mInfObs,Chr(13) + Chr(10)," ")

aMensagem:={}
//quebra de linha
While !Empty(cAux)
	aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENOBS) > 1, EspacoAt(cAux, MAXMENOBS) - 1, MAXMENOBS)))
	cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENOBS) > 1, EspacoAt(cAux, MAXMENOBS), MAXMENOBS) + 1)
EndDo

nLinTmp += (nPadding * 4)


For nX := 1 to MAXMENLIN

	nLinTmp += nFont10H

	If nX > Len(aMensagem)
		oPrinter:Say(nLinTmp, aBox10[2] + (nPadding * 2), "", fItem) //linha em branco
	Else
		oPrinter:Say(nLinTmp, aBox10[2] + (nPadding * 2), aMensagem[nX], fItem) //Observação
	EndIf
Next

//Retorno da linha apos a impressao da observaçao da nota
nRet := nLinTmp + nFont10H

//Box TOTAIS
oPrinter:Box(aBox10[1], aBox10[4],aBox10[3], aBox4[4])

//Box TOTAL Serviço
oPrinter:Box(aBox10[3] - (nPadding * 8), aBox10[4],aBox10[3], aBox4[4])
nLinTmp := aBox10[3] - (nPadding * 8)
oPrinter:Say(nLinTmp += (nPadding*2), aBox10[4] + (nPadding * 8),"VALOR TOTAL DO SERVIÇO", oFont08b)
oPrinter:SayAlign(nLinTmp += (nPadding*2), nColTot,Transform(nTotalDoc,X3Picture("F2_VALBRUT")), oFont10,300, 10,, 1,0)


Return nRet

Static Function fImpItem(aItem)
Local nColItem := nColMin + (nPadding * 4)

	If nLin >= MAXITENS
		nLin := fCabecalho() + nPadding
	EndIf

	If aItem[4] != 0 
		oPrinter:SayAlign(nLin, nColItem, aItem[1], fItem,600, 10,, 0,0) //Codigo do item
		
		oPrinter:SayAlign(nLin, nColItem += nCodigoL, aItem[2] + IIf(aItem[3]," - BONIFICACAO",""), fItem,1000, 10,, 0,0) //Descricao
		
		oPrinter:SayAlign(nLin, nColTot,Transform(aItem[4],"@E 999,999,999.99"), fItem,300, 10,, 1,0) //Total do item
		
		nLin += nFont10H
	Else
		//Deve pular 2 linhas quando hover impressao dos impostos
		nLin += nFont10H * 2	
	EndIf	
	
	If nLin >= MAXITENS
		nLin := MINRODAPE
		fRodape()
	EndIf	
	
Return

Static Function fRodape()
Local nAltBoxCli := nFont08bH * 3
Local nLinTmp := 0

Local nColCli01 := nPadding * 2 	// Coluna 01 para formatar o quadro com os dados do cliente
Local nColCli02 := nPadding * 160 	// Coluna 02 para formatar o quadro com os dados do cliente

Local nPadCol1  := 4   
Local nPadCol2  := nPadding * 19
Local lImpCob	  := .T.	

Local nTotTrib	:= 0
Local nTotNota 	:= 0
Local nPercTrib	:= 0
Local cMensTrib	:= ""  

Local nLimTit	:= 10 //limites de linhas na impressao das parcelas dos titulos
Local nColTit1	:= 0 //Valor da coluna na impressao das parcelas dos titulos
Local nColTit2	:= 0 //Valor da coluna na impressao das parcelas dos titulos
Local nX := 0 

SA1->(dbSetOrder(1)) //- Cadastro de Clientes
SA6->(dbSetOrder(1)) //- Bancos
 
//imprimir no final da pagina
If nLin < MINRODAPE
	nLin := MINRODAPE + (nPadding * 3)
EndIf

//Box BASE ICMS
aBoxR1 := {nLin, nColMin + (nPadding * 2), nLin + (nPadding * nAltBox),nColMax - (nPadding * 2)}
oPrinter:Box(aBoxR1[1], aBoxR1[2],aBoxR1[3], aBoxR1[4])
oPrinter:Line(aBoxR1[1], aBoxR1[2] + (nPadding * 80),aBoxR1[3], aBoxR1[2] + (nPadding * 80))
oPrinter:Line(aBoxR1[1], aBoxR1[2] + (nPadding * 160),aBoxR1[3], aBoxR1[2] + (nPadding * 160))

nLinTmp := aBoxR1[1]
oPrinter:Say(nLinTmp += (nPadding*2), aBoxR1[2] + (nPadding * 20),"BASE DE CALCULO DO ICMS", oFont08b)
oPrinter:Say(nLinTmp, aBoxR1[2] + (nPadding * 110),"ALIQUOTAS", oFont08b)
oPrinter:Say(nLinTmp, aBoxR1[2] + (nPadding * 190),"VALOR DO ICMS", oFont08b)

oPrinter:Say(nLinTmp += (nPadding*3), aBoxR1[2] + (nPadding * 30),Transform(nTotalDoc,X3Picture("F2_VALBRUT")), oFont12) //BASE DE CALCULO DO ICMS
oPrinter:Say(nLinTmp, aBoxR1[2] + (nPadding * 113),Transform(nPerIcm,X3Picture("D2_PICM")), oFont12) //ALIQUOTAS
oPrinter:Say(nLinTmp, aBoxR1[2] + (nPadding * 195),Transform(nValICMS,X3Picture("F2_VALICM")), oFont12)//VALOR DO ICMS

//Box CABEÇALHO DADOS DO TITULO
nLinTmp := aBoxR1[3] + nPadding * 3 
oPrinter:Say(nLinTmp, aBoxR1[2] + (nPadding * 2),"ESTA NOTA FISCAL FOI DESDOBRADA NAS SEGUINTES PARCELAS", oFont08b)

aBoxR2 := {aBoxR1[3] + nPadding * 4,aBoxR1[2],aBoxR1[3] + (nPadding * nAltBox * 2),aBoxR1[4]}
oPrinter:Box(aBoxR2[1], aBoxR2[2],aBoxR2[3], aBoxR2[4])
oPrinter:Line(aBoxR2[1], aBoxR2[2] + (nPadding * 60),aBoxR2[3], aBoxR2[2] + (nPadding * 60))
oPrinter:Line(aBoxR2[1], aBoxR2[2] + (nPadding * 120),aBoxR2[3], aBoxR2[2] + (nPadding * 120))
oPrinter:Line(aBoxR2[1], aBoxR2[2] + (nPadding * 180),aBoxR2[3], aBoxR2[2] + (nPadding * 180))

nLinTmp := aBoxR2[1]
//oPrinter:Say(nLinTmp += (nPadding*2), aBoxR2[2] + (nPadding * 20),"NOTA FISCAL DE", oFont08b)
oPrinter:Say(nLinTmp += (nPadding*2), aBoxR2[2] + (nPadding * 20),"VALOR DA PARCELA", oFont08b)
oPrinter:Say(nLinTmp, aBoxR2[2] + (nPadding * 75),"VENCIMENTO", oFont08b)
oPrinter:Say(nLinTmp, aBoxR2[2] + (nPadding * 135),"VALOR DA PARCELA", oFont08b)
oPrinter:Say(nLinTmp, aBoxR2[2] + (nPadding * 197),"VENCIMENTO", oFont08b)

//Box NUMERO/VALOR/ORDEM/VENCIMENTO
aBoxR3 := {aBoxR2[3],aBoxR2[2],aBoxR2[3] + (nPadding * (nAltBox * 6)),aBoxR2[4]}
oPrinter:Box(aBoxR3[1], aBoxR3[2],aBoxR3[3], aBoxR3[4])	
oPrinter:Line(aBoxR3[1], aBoxR3[2] + (nPadding * 60),aBoxR3[3], aBoxR3[2] + (nPadding * 60))
oPrinter:Line(aBoxR3[1], aBoxR3[2] + (nPadding * 120),aBoxR3[3], aBoxR3[2] + (nPadding * 120))
oPrinter:Line(aBoxR3[1], aBoxR3[2] + (nPadding * 180),aBoxR3[3], aBoxR3[2] + (nPadding * 180))

nLinTmp := aBoxR3[1]

nLinAux := nLinTmp + (nPadding*3)
If Len(aTit) > 0
	For nX := 1 To Len(aTit)
		If nX <= nLimTit                                                  
		   nColTit1 := aBoxR3[2] + (nPadding * 25) 
		   nColTit2 := aBoxR3[2] + (nPadding * 80)
		Else 
			nColTit1 := aBoxR3[2] + (nPadding * 25) 
		   	nColTit2 := aBoxR3[2] + (nPadding * 80)		
		EndIf	
		
		oPrinter:Say(nLinAux, nColTit1,Transform(aTit[nX][2],X3Picture("F2_VALBRUT")), oFont10)                                      
		oPrinter:Say(nLinAux, nColTit2,DToC(aTit[nX][4]), oFont10)

		nLinAux += nPadding*3 
	Next nX	
EndIf

//Box DADOS DOS CLIENTES
aBoxR4 := {aBoxR3[3],aBoxR3[2],aBoxR3[3] + nAltBoxCli,aBoxR3[4]}
oPrinter:Box(aBoxR4[1], aBoxR4[2],aBoxR4[3], aBoxR4[4])

//Pesquisa o os dados do cliente
SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))

nLinTmp := aBoxR4[1]

//Verifica o dados de cobrança
lImpCob := IIf(cCliente+cLoja == cCliCob+cLojCob,.T.,.F.)

If lImpCob
	SA6->(dbSeek(xFilial("SA6")+SC5->C5_BANCO+SC5->C5_XAGENCI+SC5->C5_XCONTA))
Else
	SA1->(dbSeek(xFilial("SA1")+cCliCob+cLojCob))
EndIf

oPrinter:Say(nLinTmp += (nPadding*3), aBoxR4[2] + nColCli01,"COBRANÇA A/C DE:", oFont08b)
oPrinter:Say(nLinTmp, (aBoxR4[2] + nColCli01) * nPadCol1,IIf(lImpCob,AllTrim(SA6->A6_NOME),AllTrim(SA1->A1_NOME)), oFont10)
oPrinter:Say(nLinTmp, aBoxR4[2] + nColCli02,"CIDADE/ESTADO:", oFont08b)
oPrinter:Say(nLinTmp, (aBoxR4[2] + nColCli02) + nPadCol2,IIf(lImpCob,AllTrim(SA6->A6_MUN),AllTrim(SA1->A1_MUN)) + " / " + IIf(lImpCob,AllTrim(SA6->A6_EST),AllTrim(SA1->A1_EST)), oFont10)

oPrinter:Say(nLinTmp += (nPadding*3), aBoxR4[2] + nColCli01,"ENDEREÇO:", oFont08b)
oPrinter:Say(nLinTmp, (aBoxR4[2] + nColCli01) * nPadCol1,IIf(lImpCob,AllTrim(SA6->A6_END),AllTrim(SA1->A1_END)), oFont10)
oPrinter:Say(nLinTmp, aBoxR4[2] + nColCli02,"C.E.P.:", oFont08b)
oPrinter:Say(nLinTmp, (aBoxR4[2] + nColCli02) + nPadCol2,Transform(IIf(lImpCob,AllTrim(SA6->A6_CEP),AllTrim(SA1->A1_CEP)),"@R 99999-999"), oFont10)

oPrinter:Say(nLinTmp += (nPadding*3), aBoxR4[2] + nColCli01,"CNPJ:", oFont08b)
oPrinter:Say(nLinTmp, (aBoxR4[2] + nColCli01) * nPadCol1,Transform(IIf(lImpCob,AllTrim(SA6->A6_CGC),AllTrim(SA1->A1_CGC)),"@R 99.999.999/9999-99"), oFont10)
oPrinter:Say(nLinTmp, aBoxR4[2] + nColCli02,"I.E.:", oFont08b)
oPrinter:Say(nLinTmp, (aBoxR4[2] + nColCli02) + nPadCol2,IIf(lImpCob,AllTrim(SA6->A6_INSCRIC),AllTrim(SA1->A1_INSCR)), oFont10)

//Box Valor por extenso
aBoxR5 := {aBoxR4[3],aBoxR4[2],aBoxR4[3] + (nPadding * nAltBox),aBoxR4[4]}
oPrinter:Box(aBoxR5[1], aBoxR5[2],aBoxR5[3], aBoxR5[4])	

nLinTmp := aBoxR5[1]
oPrinter:Say(nLinTmp += (nPadding*1.5), aBoxR5[2] + (nPadding * 7),"VALOR", oFont08b)
oPrinter:Say(nLinTmp += (nPadding*2), aBoxR5[2] + (nPadding * 8),"POR", oFont08b)
oPrinter:Say(nLinTmp += (nPadding*2), aBoxR5[2] + (nPadding * 6),"EXTENSO", oFont08b)

nLinTmp := aBoxR5[1]
oPrinter:Line(aBoxR5[1], aBoxR5[2] + (nPadding * 20),aBoxR5[3], aBoxR5[2] + (nPadding * 20))
oPrinter:Say(nLinTmp + (nPadding*3), aBoxR5[2] + (nPadding * 25),Extenso(SF2->F2_VALBRUT), oFont10) //Valor por extenso

//Box mensagem 
aBoxR6 := {aBoxR5[3],aBoxR5[2],aBoxR5[3] + (nPadding * nAltBox),aBoxR5[4]}
oPrinter:Box(aBoxR6[1], aBoxR6[2],aBoxR6[3], aBoxR6[4])

nLinTmp := aBoxR6[1]
oPrinter:Say(nLinTmp += (nPadding*2), aBoxR6[2] + (nPadding * 5),"DEVE(M) A " + Alltrim(SM0->M0_NOMECOM) + ;
", A IMPORTANCIA PELA PRESTAÇÃO DE SERVIÇOS CONSTANTES DESTA NOTA FISCAL DE SERVIÇOS DE COMUNICAÇÃO. PARA", oFont08)

oPrinter:Say(nLinTmp += (nPadding*2), aBoxR6[2] + (nPadding * 5),"CUJA COBERTURA EMITIMOS PARCELAS PARA PAGAMENTO NO(S) VENCIMENTO(S) E PRAÇA(S) INDICADOS", oFont08)
//Box OBS.: 
aBoxR7 := {aBoxR6[3],aBoxR6[2],nLinMaxPg - (nPadding * 2),aBoxR6[2] + (nPadding * 140)}
oPrinter:Box(aBoxR7[1], aBoxR7[2],aBoxR7[3], aBoxR7[4])

nLinTmp := aBoxR7[1]//Contatos Financeiros 
oPrinter:Say(nLinTmp += (nPadding*2), aBoxR7[2] + (nPadding * 2),"OBS.:", oFont08b)
oPrinter:Say(nLinTmp + nFont08H, aBoxR7[2] + (nPadding * 2),"Contatos Financeiros", oFont10)
oPrinter:Say(nLinTmp + nFont08H * 2 , aBoxR7[2] + (nPadding * 2),cMens1/*PadR("TV/Era Faturamento/Cobrança :",26) + " 2123-1048"*/, oFont10)
oPrinter:Say(nLinTmp + nFont08H * 3, aBoxR7[2] + (nPadding * 2),cMens2/*PadR("RD Jovem Pam/Acrítica Faturamento/Cobrança:",24) + " 2123-1069"*/, oFont10)
oPrinter:Say(nLinTmp + nFont08H * 4, aBoxR7[2] + (nPadding * 2),cMens3/*PadR("Gerência Financeira:",20) + " 2123-1026"*/, oFont10)

nTotTrib := GetAliqImp() 
If nTotTrib > 0
	nTotNota 	:= SF2->F2_VALBRUT
	nPercTrib	:= (nTotTrib / nTotNota) * 100
	cMensTrib := "Valor Aproximado dos Tributos: R$ " + AllTrim(Transform(nTotTrib,"@e 999,999,999.99")) + " (" + AllTrim(Transform(nPercTrib,"99.99")) + "%) "
	oPrinter:Say(nLinTmp + nFont08H * 6, aBoxR7[2] + (nPadding * 2),cMensTrib, oFont10)	
EndIf 

//Box Reservado ao fisco 
aBoxR8 := {aBoxR7[1],aBoxR7[4],aBoxR7[3],aBoxR4[4]}
oPrinter:Box(aBoxR8[1], aBoxR8[2],aBoxR8[3], aBoxR8[4])

nLinTmp := aBoxR8[1]
oPrinter:Say(nLinTmp += (nPadding*2), aBoxR8[2] + (nPadding * 2),"RESERVADO AO FISCO:", oFont08b)
oPrinter:Say(nLinTmp + (nPadding*5), aBoxR8[2] + (nPadding * 10),cResFisco, oFont14)
//cResFisco
Return

/*/{Protheus.doc}ValidPerg 
	@description
	Cria as perguntas para o filtro da consulta de dados
	 
	@author	Bruno Garcia
	@version	1.0
	@since		03/06/2015
	@return	Nao possui,Nao Possui,Nao possui
	@param 		cPerg,Caracter,Grupo de perguntas SX1										
/*/
Static Function ValidPerg(cPerg)
	PutSX1(cPerg,"01"," Da Nota   :","","","mv_ch1","C",09,0,0,"G","","","","","mv_par01")
	PutSX1(cPerg,"02"," Ate a Nota:","","","mv_ch2","C",09,0,0,"G","","","","","mv_par02")
	PutSX1(cPerg,"03"," Serie     :","","","mv_ch3","C",03,0,0,"G","","","","","mv_par03")
Return

/*/{Protheus.doc} EspacoAt
Pega uma posição (nTam) na string cString, e retorna o caractere de espaço anterior.
@param cString Texto para procura do caracter de espaço
@return nRetorno Posicao do caracter de espaço
@author Nelio Castro Jorio
@owner Wn Hospitalar
@project MIT044 Especificacao de Personalizacao Nota Fiscal Simbólica.doc
/*/
//----------------------------------------------------------
Static Function EspacoAt(cString, nTam)
Local nRetorno := 0
Local nX       := 0

If nTam > Len(cString) .Or. nTam < 1
	nRetorno := 0
	Return nRetorno
EndIf

nX := nTam
While nX > 1
	If Substr(cString, nX, 1) == " "
		nRetorno := nX
		Return nRetorno
	EndIf
	
	nX--
EndDo

nRetorno := 0
Return nRetorno

Static Function GetAliqImp()
Local nAliqImp := 0  
Local aArea := GetArea()

//Adequação NT2013/003 - Verifica 
cQuery    := " SELECT SUM(CD2_VLTRIB) VALORZ FROM " + RetSqlName("CD2") + " CD2 " "
cQuery    += " WHERE CD2_DOC = '"+SF2->F2_DOC+"' "
cQuery    += " AND CD2_SERIE = '"+SF2->F2_SERIE+"' "
cQuery    += " AND D_E_L_E_T_ = '' "
cQuery    += " AND CD2_IMP IN ('CF2','PS2') "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),"TMP",.T.,.T.)

TMP->(DbGotop())
If !TMP->(Eof())
	NaLIQIMP += TMP->VALORZ
EndIf

DbSelectArea("TMP")
DbCloseArea("TMP")  
RestArea(aArea)  

Return nAliqImp

Static Function MostraTela()
	
cMens1 := PadR("Cobrança:",26) + " 2123-1048"
cMens2 := PadR("Faturamento:",24) + " 2123-1069"
cMens3 := PadR("Gerência Financeira:",20) + " 2123-1026"

	cCliente:= SF2->F2_CLIENTE//SC5->C5_CLIENTE
	cLoja	:= SF2->F2_LOJA//SC5->C5_LOJACLI
	
If !Empty(SF2->F2_XSELOFI)
	cSelo	:= Alltrim(SF2->F2_XSELOFI)
Else
	cSelo := Alltrim(SX5->X5_DESCRI)
EndIf

If !Empty(SF2->F2_XOBSNF)
	mInfObs	:= SF2->F2_XOBSNF
Else
	mInfObs	:= SC5->C5_XDESCNF
EndIf
DEFINE MSDIALOG oDlg TITLE "Mensagens da Nota Fiscal... " + SF2->F2_DOC FROM 0,0 TO 450,500 PIXEL OF oMainWnd
   
	oDlg:lMaximized := .F.
	oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT    		   	
	
	@ 005,005	Say "Obs." OF oPanel	PIXEL
	@ 015,005	Get mInfObs Memo Size 180, 90 OF oPanel	PIXEL 

	@ 115,005	Say "Contatos no setor financeiro" OF oPanel	PIXEL
	@ 130,005	Get cMens1 OF oPanel	PIXEL
	@ 145,005	Get cMens2 OF oPanel	PIXEL
	@ 160,005	Get cMens3 OF oPanel	PIXEL
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| FRSalva(),oDlg:End() },{|| oDlg:End()}) CENTERED
Return

Static Function FRSalva()
RecLock("SF2",.F.)
	SF2->F2_XOBSNF	:= mInfObs
	SF2->F2_XSELOFI := cSelo
SF2->(MsUnlock())
Return  