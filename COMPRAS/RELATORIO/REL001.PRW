/*
Função     : REL001()  
Autor      : Wilson R. Postal
Data       : 09/07/09
Descrição  : Imprime Solicitação de Compra em modo grafico
Uso espec. : SAKURA EXHAUST DO BRASIL
*/

#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#Include "rwmake.ch"
#Include "Protheus.ch"
                                                                                                      
User Function REL001
	
	Private cNumSol:=space(6), cObs1:=space(40), cObs2:=space(40), cObs3:=space(40)
	
	nOpcao := 0
	
	DEFINE MSDIALOG oDlg TITLE "Solicitação de Compra" FROM 8, 0 TO  30,50
	
	@ 0,0 MSPANEL oPanelT PROMPT "" SIZE 050,150 OF oDlg CENTERED LOWERED //"Botoes"
	oPanelT:Align := CONTROL_ALIGN_BOTTOM
	
	@ 50,10  SAY "No. Solicitação : " PIXEL OF oPanelT
	@ 50,60  MSGET cNumSol PICTURE "@!" SIZE 35,08 F3 "SC1" PIXEL OF oPanelT
	@ 70,10  SAY "Obs :" PIXEL OF oPanelT
	@ 70,25  MSGET cObs1 PICTURE "@!" SIZE 170,08 PIXEL OF oPanelT
	@ 80,25  MSGET cObs2 PICTURE "@!" SIZE 170,08 PIXEL OF oPanelT
	@ 90,25  MSGET cObs3 PICTURE "@!" SIZE 170,08 PIXEL OF oPanelT
	
	bOk:={||nOpcao:=1,oDlg:END()}
	bCancel:={||nOpcao:=0,oDlg:END()}
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED
	
	If nOpcao == 1
		Processa({|| RReport(),"Processando Dados"})
	EndIf
	
Return

//////////////////////////

Static FUNCTION RReport()

  AVPRINT oPrn NAME "  SOLICITAÇÃO DE COMPRA"

    DEFINE FONT oFont1  NAME "Courier New" SIZE 0,12 OF oPrn
    DEFINE FONT oFont2  NAME "Courier New" SIZE 0,14 Bold OF oPrn
    DEFINE FONT oFont3  NAME "Courier New" SIZE 0,08 Bold OF oPrn
    DEFINE FONT oFont4  NAME "Courier New" SIZE 0,10 Bold OF oPrn
    DEFINE FONT oFont5  NAME "Courier New" SIZE 0,12 Bold OF oPrn
    oPrn:SETLANDSCAPE()
    aFontes:={oFont1,oFont2,oFont3,oFont4,oFont5}

  AVPAGE

     Processa({|X| lEnd := X, RPrint() })

  AVENDPAGE
   
  AVENDPRINT 
                                   
  oPrn:SETLANDSCAPE()
  oFont1:End()
  oFont2:End()
  oFont3:End()
  oFont4:End()                                   
  oFont5:End()
  DbSelectArea("SC1")
  aMarcados:={}

Return .T.
      
/////////////////////////

Static Function RPrint()

Local nCurrentLine := 0 

Private nCurrentLine, cNome, cFornece, cDoc, cDtDigit, cValUnit, cQuant, cArmaz, cFone
Private nLines := 0, nLines0 := 0, nLines1 := 0
Private nPage:=0,nLinha:=0,nColFim:=3100
//Private lImpr := "N"
Private lImpr := "S"

Public  SaltPage := .F.

nItem:=0
nCol1:=25      
nCol2:=190  
nCol3:=540 
nCol4:=1360 
nCol5:=1445 
nCol6:=1960
nCol7:=2430
nCol8:=2630    
nLinFim:=3000

dbSelectArea("SC1")
dbSetorder(1)
ProcRegua(Lastrec())                
dbSeek(xFilial("SC1")+cNumSol)
//dbSeek("01"+cNumSol)

cSolicit := SC1->C1_SOLICIT
cProduto := SC1->C1_PRODUTO

If !Found()

	cNumSol := '000001'
	
EndIf

RCabec()                   

While !Eof() .And. SC1->C1_NUM == cNumSol

  dbSelectArea("SD1")  
  dbSetOrder(22)      // ANTES ERA 2 
  dbOrderNickName("PRODTDIGIT")
  //dbSeek(xFilial("SD1")+cProduto)
 
  If Found()
  
  	lImpr := "S"
  	
  Else
  
  	lImpr := "N"
  	
  EndIf

  While SD1->D1_COD == cProduto .And. lImpr == "S"
  
   	If SD1->D1_TIPO == "N"
   
		cFornece := SD1->D1_FORNECE + "-"
		cNome	 := Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE,"A2_NOME")
		cFone	 := "(" + Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE,"A2_DDD") + ")" + Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE,"A2_TEL")
		cDoc	 := SD1->D1_DOC
		cDtDigit := SD1->D1_DTDIGIT
		cValUnit := SD1->D1_VUNIT
		cQuant   := SD1->D1_QUANT
		cArmaz   := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"SB1->B1_LOCPAD")

	//EndIf
	  ELSEIF SD1->D1_TIPO == "B"   
	 //JULIO CESAR RIBEIRO
	  	  
	  	cFornece := SD1->D1_FORNECE + "-"
		cNome	 := Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE,"A1_NOME")
		cFone	 := "(" + Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE,"A1_DDD") + ")" + Posicione("SA1",1,xFilial("SA1")+SD1->D1_FORNECE,"A1_TEL")
		cDoc	 := SD1->D1_DOC
	 	cDtDigit := SD1->D1_DTDIGIT
		cValUnit := SD1->D1_VUNIT
		cQuant   := SD1->D1_QUANT
		cArmaz   := Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"SB1->B1_LOCPAD")
	  
	  ELSE  
	 
	 // cFornece := ""
	 //	cNome	 := ""
	 //	cFone	 := ""
	 //	cDoc	 := ""
	 //	cDtDigit := ""
	 //	cValUnit := ""
	//	cQuant   := ""
	//	cArmaz   := ""

	  
	  ENDIF
	

	dbSkip()
	
  EndDo

  If lImpr == "S"

		oPrn:Say(nLinha,nCol1,"ULT. COMPRA: " + LEFT(cFornece + AllTrim(cNome) + " - " + AllTrim(cFone),65),oFont3,,,,3)
		oPrn:Say(nLinha,nCol4,"NF. " + Alltrim(cDoc),oFont3,,,,3)
		oPrn:Say(nLinha,nCol5+160,"Data Rec. " + Transform(cDtDigit,"@E 99/99/99"),oFont3,,,,3)
		//oPrn:Say(nLinha,nCol5+580,"Vlr Unit." + Transform(cValUnit,"@E 999,999.99"),oFont3,,,,3)
		oPrn:Say(nLinha,nCol5+580,"Vlr Unit." + Transform(cValUnit,"@E 999,999.99999"),oFont3,,,,3)
		//oPrn:Say(nLinha,nCol7,"Quant. " + Transform(cQuant,"@E 999,999.99"),oFont3,,,,3)
		oPrn:Say(nLinha,nCol7,"Quant. " + Transform(cQuant,"@E 999,999.999"),oFont3,,,,3)
		//oPrn:Say(nLinha,nCol7+320,"Est. Atual " + Transform(Posicione("SB2",1,xFilial("SB2")+SC1->C1_PRODUTO+cArmaz,"SB2->B2_QATU"),"@E 999,999.99"),oFont3,,,,3)
		oPrn:Say(nLinha,nCol7+320,"Est. Atual " + Transform(Posicione("SB2",1,xFilial("SB2")+SC1->C1_PRODUTO+cArmaz,"SB2->B2_QATU"),"@E 999,999.999"),oFont3,,,,3)
		nLinha += 40
		
  Else
	
	//	oPrn:Say(nLinha,nCol1,"É a primeira compra/solicitação desse material/serviço.",oFont4,,,,3)
		nLinha += 40
		
  EndIf
   	
  dbSelectArea("SC1")

  nCurrentLine := 1
  oPrn:Say(nLinha,nCol1,SC1->C1_ITEM,oFont3,,,,3)   
  oPrn:Say(nLinha,nCol2,Alltrim(SC1->C1_PRODUTO),oFont3,,,,3)
  oPrn:Say(nLinha,nCol4,Alltrim(SC1->C1_UM),oFont3,,,,3)  
  oPrn:Say(nLinha,nCol5-50,Transform(SC1->C1_QUANT,"@E 99,999.999"),oFont3,,,,3)  
  oPrn:Say(nLinha,nCol5+160,Transform(SC1->C1_EMISSAO,"@E 99/99/99"),oFont3,,,,3)  //160
  oPrn:Say(nLinha,nCol5+360,DTOC(SC1->C1_DATPRF),oFont3,,,,3)
  oPrn:Say(nLinha,nCol5+580,SC1->C1_CC,oFont3,,,,3)
  oPrn:Say(nLinha,nCol8+150,SC1->C1_CONTA,oFont3,,,,3) //  Conta Contabil 
  cString  := ALLTRIM(SC1->C1_DESCRI)
  cString1 := ALLTRIM(SC1->C1_OBS)

  IF MEMOWRITE("Texto.txt", cString)
		conout("Erro gravando Texto")
  EndIf

  cTexto  := MEMOREAD( "Texto.txt" )
  nLines0 := MLCOUNT(cTexto, 40, 0, .T.)

  IF MEMOWRITE("Texto1.txt", cString1)
		conout("Erro gravando Texto")
  EndIf

  cTexto1 := MEMOREAD( "Texto1.txt" )
  nLines1 := MLCOUNT(cTexto1, 40, 0, .T.)
   
  nLines := Iif(nLines0 >= nLines1, nLines0, nLines1)
  nLines++

  FOR nCurrentLine := 1 TO nLines
 
  		If MEMOLINE(cTexto, 45, nCurrentLine, 0, .T.) != " "

			oPrn:Say(nLinha,nCol3,MEMOLINE(cTexto,40,nCurrentLine,0, .T.),oFont3,,,,3)

   		EndIf
   		
   		If MEMOLINE(cTexto1, 40, nCurrentLine, 0, .T.) != " "

			oPrn:Say(nLinha, nCol5+770, MEMOLINE(cTexto1, 40, nCurrentLine, 0, .T.),oFont3,,,,3)			

   		EndIf 

		nLinha += 20
		

  NEXT

  If nLinha >= (nLinFim-940)

	RRodape()
	AvNewPage // Salta Pagina
	RCabec() 

  EndIf         		

  nLinha += 20   
  dbSkip()
  cProduto := SC1->C1_PRODUTO

Enddo


RRodape()

nLinha+= 130


Return()
      
////////////////////////

Static Function RCabec()
  
   Local nLine
   Local nLinFim
   Local nLarg:=480,nAlt:=200

   nPage += 1  

   nLine:=40
   oPrn:SayBitmap(nLine+010,100,"\SYSTEM\NIPPON.JPG",nLarg,nAlt) 
   nLine+=40
                                             
   oPrn:Say(nLine,620,"SOLICITAÇÃO DE COMPRA",aFontes[2],,,,3)
   oPrn:Say(nLine,2500,"Nº." + SC1->C1_NUM ,aFontes[2],,,,3)   
   nLine+=80
   
   oPrn:Say(nLine,620,"NIPPON SEIKI DO BRASIL LTDA",aFontes[5],,,,3)
   oPrn:Say(nLine,2500,"PAGINA: " + STRZERO(nPage,3) ,aFontes[3],,,,3)   
         
   nLine+=40
   
   oPrn:Say(nLine,620,"RUA PALMEIRA DO MIRITI Nr.   121",aFontes[3],,,,3)      
   nLine+=40
   
   oPrn:Say(nLine,620,"Fone:55-92-21218900  Fax: 55-92-21218912   Cep: 69006373         Manaus - Amazonas",aFontes[3],,,,3)
   oPrn:Say(nLine,2500,"Versão 3.21",aFontes[3],,,,3)      
   nLine+=40
   
   oPrn:Say(nLine,620,"C.N.P.J 05.213.262/0001-58    I.E. 063000156",aFontes[3],,,,3)
   oPrn:Say(nLine,2500,"Emissão: " + Transform(SC1->C1_EMISSAO,"@E 99/99/99") ,aFontes[3],,,,3)
   nLine+=40 
   oPrn:Say(nLine,2500,"Hora   : " + Time() ,aFontes[3],,,,3)
   nLine+=100
   oPrn:Line(nLine,nCol1,nLine,nColFim)
   
   nLine+=30   
   oPrn:Say(nLine,nCol1,"ITEM",oFont4,,,,4)
   oPrn:Say(nLine,nCol2,"CÓDIGO",oFont4,,,,4)
   oPrn:Say(nLine,nCol3,"DESCRIÇÃO",oFont4,,,,4)
   oPrn:Say(nLine,nCol4,"UN",oFont4,,,,4)
   oPrn:Say(nLine,nCol5+50,"QTD",oFont4,,,,4) 
   oPrn:Say(nLine,nCol5+160,"EMISSÃO",oFont4,,,,4)
   oPrn:Say(nLine,nCol5+360,"NECESSID.",oFont4,,,,4)
   oPrn:Say(nLine,nCol5+580,"C.CUSTO",oFont4,,,,4)
   //oPrn:Say(nLine,nCol5+580,"C.CUSTO",oFont4,,,,4)
   //oPrn:Say(nLine,nCol5+770,"APLICADO",oFont4,,,,4)   
   oPrn:Say(nLine,nCol5+770,"APLICAÇÃO ",oFont4,,,,4)
   oPrn:Say(nLine,nCol8+150,"C.CONTAB",oFont4,,,,4)
   nLine+=40              
   oPrn:Line(nLine ,nCol1 ,nLine ,nColFim)
   nLinha:=nLine+40

Return

//////////////////////////////////////////////////////////////////////

Static Function RRodape()

nLinha += 20
oPrn:Line(nLinha,nCol1,If(nLinFim-940<=nLinha,nLinha,nLinFim-940),nColFim)
nLinha=If(nLinFim-940<=nLinha,nLinha,nLinFim-940)
oPrn:Line(nLinha,nCol1,nLinha,nColFim)
nLinha += 20                   
oPrn:Say(nLinha,nCol1,"Obs  : " + cObs1,oFont4,,,,3)
//oPrn:Say(nLinha,nCol5+160,"LEGENDA:		A = INSUMOS		B = CONSUMO		C = BENS ATIVO		D = SERVIÇO",oFont5,,,,3)
nLinha+=50
oPrn:Say(nLinha,nCol1+150, cObs2,oFont4,,,,3)
nLinha+=40
oPrn:Say(nLinha,nCol1+150, cObs3,oFont4,,,,3)
nLinha+=100
oPrn:Line(nLinha,nCol2,nlinha,nCol2+600)
oPrn:Say(nLinha,nCol3+150,"Solicitante: "+cSolicit , oFont4,,,,1)
oPrn:Line(nLinha,nCol4-100,nLinha,nCol4+500)
oPrn:Say(nLinha,nCol4+300,Padl("Comprador",22) , oFont4,,,,1)
oPrn:Line(nLinha,nCol7,nlinha,nCol7+600)
oPrn:Say(nLinha,nCol7+525,Padr("Responsável pelo setor",22), oFont4,,,,1)
oPrn:Say(nLinha,nCol7+500,Padr("",22), oFont4,,,,1)
Return