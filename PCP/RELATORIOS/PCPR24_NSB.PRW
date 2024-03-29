#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"   // Problema com a janela inicial
#include "ap5mail.ch"
#include 'fivewin.ch'
#Include "TOPCONN.CH"
#Include "TBICONN.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 07/03/02

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPNS()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� DECLARACAO DE VARIAVEIS UTILIZADAS NO PROGRAMA ATRAVES DA FUNCAO    �
//� SETPRVT, QUE CRIARA SOMENTE AS VARIAVEIS DEFINIDAS PELO USUARIO,    �
//� IDENTIFICANDO AS VARIAVEIS PUBLICAS DO SISTEMA UTILIZADAS NO CODIGO �
//� INCLUIDO PELO ASSISTENTE DE CONVERSAO DO AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,XSAIDA")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
SetPrvt("XCOMP,XDATA,XDATFCH,XMES,XCOMPRA,XDATFIN")
SetPrvt("CDATINI,CDATFIN,XDATINI,XSALPED,CSTRING")
SetPrvt("XMRP,XCOMPRA,APDTS,XGERMES,dValIni,dValFin,xEmpresa")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � PCPR24   � Autor � Remerson Mogi         � Data � 26/09/06 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri꿵  �                                                            낢�
굇�          �                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � PCPR24(void)                                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros�                                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             낢�
굇쳐컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛rogramador � Data   � BOPS �  Motivo da Alteracao                     낢�
굇쳐컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿝mogi       �08/11/07쿦XXXXX쿌dptacao das querys para todas empresas   낢�
굇쿥Correa     �02/12/16쿦XXXXX쿛adronizacao Desenvolvimento              낢�
굇읕컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
*/

/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� DEFINE VARIAVEIS                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/

titulo    := PadC("Produ豫o, Perdas, indice de perda e devolu豫o mes � mes          ",30)
cDesc1    := PadC("Este Programa tem como objetivo, emitir a relacao de produtos    ",64)
cDesc2    := PadC("produzidos, Mes a Mes. Conforme especificacoes em Parametros."    ,58)
cDesc3    := ""
TAMANHO   := "G"
LIMITE    := 220
CSTRING   := "SD3"
AORD      := {} //-- ORDEM
LCONTINUA := .T.
CUM       := ""
LEND      := .F.
ARETURN   := { "ZEBRADO", 1,"ADMINISTRACAO", 2, 2, 1, "",1 }
NOMEPROG  := "PCPN24"
NLASTKEY  := 0
CPERG     := "PCPN24"
CMES      := {}

AMSG      := {}
vLista    := {}
aCliente  := {}
xEmpresa  := SM0->M0_CODIGO
QtdPerE   :=0
QtdParE   :=0

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� VERIFICA AS PERGUNTAS SELECIONADAS                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

PERGUNTE(CPERG,.F.)

aAdd( cMes, {"JAN","31","08"})
If   U_Bissexto()
	aAdd( cMes, {"FEV","29","09"})
Else
	aAdd( cMes, {"FEV","28","09"})
EndIf

aAdd( cMes, {"MAR","31","10"})
aAdd( cMes, {"ABR","30","11"})
aAdd( cMes, {"MAI","31","12"})
aAdd( cMes, {"JUN","30","01"})
aAdd( cMes, {"JUL","31","02"})
aAdd( cMes, {"AGO","31","03"})
aAdd( cMes, {"SET","30","04"})
aAdd( cMes, {"OUT","31","05"})
aAdd( cMes, {"NOV","30","06"})
aAdd( cMes, {"DEZ","31","07"})

AMSGPROD:= {"PP-PLANO          ",;
"PR-PRODU플O       ",;
"PA-PROD. ACEITA   ",;
"QT-QTD TRANSFERIDA",;
"DEV-DEVOLU픈O     ",;
"PER-PERDA         ",;
"RE- RETRABALHO    ",;
"% DEVOL.(DEV/QT)*100",;
"% PERDA (PER/PR)*100",;
"% RETRA (RE/PR)*100 ",;
"PRODU플O-Pc/Hr ",;
"EFICENCIA      ",;
"ATRASO-HRS     " }

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01             // Periodo Incial (mmaaaa)             �
//� mv_par02             // Periodo Final  (mmaaaa)             �
//� mv_par03             // Do Produto                          �
//� mv_par04             // Ate o Produto                       �
//� mv_par05             // Do Tipo                             �
//� mv_par06             // Ate o Tipo                          �
//� mv_par07             // Do Grupo                            �
//� mv_par08             // Ate o Grupo                         �
//� mv_par09             // Impr.Produto S/Mov. (Sim/Nao)       �
//� mv_par10             // Do Fornecedor                       �
//� mv_par11             // Ate o Forncedor                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

WNREL := "PCPR24"
WNREL := SETPRINT(CSTRING,WNREL,CPERG,@TITULO,CDESC1,CDESC2,CDESC3,.F.,,)

If NLASTKEY==27
	Return
EndIf


SetDefault(aReturn,cString)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01

cCabec  := ""
xQuant  := 0

DatIni  := Dtos(mv_par01)
DatFim  := Dtos(mv_par02)
cDiaIni := subs(DatIni,7,2)
cMesIni := Val(substr(DatIni,5,2)) //Val(subs(mv_par01,1,2))
cMesFin := Val(substr(DatFim,5,2)) //Val(subs(mv_par02,1,2))
cAnoIni := Val(subs(DatIni,1,4))
cAnoFin := Val(subs(DatFim,1,4))


If mv_par05=2
	cDiaIni:='01'
	cDiaFin := cMes[cMesFin][02]
Else
	cDiaFin :=subs(DatFim,7,2)
EndIf
cDatIni :=  Ctod(cDiaIni+"/"+StrZero(cMesIni,2)+"/"+StrZero(cAnoIni,4) )
cDatFin := Ctod(cDiaFin+"/"+StrZero(cMesFin,2)+"/"+StrZero(cAnoFin,4) )

If mv_par04 = 1
	xCC :="211"
ElseIf mv_par04 = 2
	xCC :="221"
ElseIf mv_par04 = 3
	xCC :="231"
ElseIf mv_par04 = 4
	xCC :="241"
EndIf

If cMesIni <= cMesFin .And. cAnoIni < cAnoFin
	MsgStop("Periodo Estipulado, Ultrapasa 12 meses...")
	Return
ElseIf cMesIni > cMesFin .And. cAnoIni >= cAnoFin
	MsgStop("Periodo Inicial maior que Periodo Final...")
	Return
ElseIf cMesIni > 12 .or. cMesFin > 12
	MsgStop("Mes Invalido...")
	Return
ElseIf cMesIni == cMesFin .And. cAnoIni == cAnoFin
	xQuant := 1
ElseIf cMesIni < cMesFin .And. cAnoIni <= cAnoFin
	xQuant := cMesFin - cMesIni +1
ElseIf cMesIni > cMesFin .And. cAnoIni < cAnoFin
	xQuant := cMesFin - cMesIni +1
End

// --------------------------------------------
// Monta cabecalho para impressao de relatorio.
// --------------------------------------------

xCOL   := 040
xPOS   := {}
xMESES := {}
xIni := cDatIni
While xIni <= cDatFin
	If Ascan(xMESES,MONTH(xIni)) == 0
		aadd(xMESES,MONTH(xIni) )
		aadd(xPOS   ,xCOL )
		cCabec  := cCabec + cMes[MONTH(xIni)][1]+"/"+StrZero(year(xIni),4)+"     "
		xCOL := xCOL + 13
	Endif
	xIni := xIni + 1
EndDo

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Definicao dos cabecalhos                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

titulo := "Produ豫o x Perdas x Devolu豫o Mes a Mes."
cabec1:=""
If mv_par05=2
	cabec1 := "Descricao                            " + cCabec //+"      Media   Valor Total"
Else
	Cabec1:= "Por periodo "
Endif

cabec2 := "Entre: "+dtoc(cDatIni)+" a "+dtoc(cDatFin)
//         xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxx  999,999,999  999.999.999  9.999.999 99.999.999
//         Ativo,Dispos.,Tela,Equip...          JAN/2006        JAN/2006
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999

If nLastKey == 27
	Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

#IFDEF WINDOWS
	RptStatus({|| Detpcpr24()})
	Return
#ENDIF
/********************************************************************/
/********************************************************************/
/********************************************************************/
Static Function Detpcpr24()
Local Efid:=0
Local N
Local m 
Local z 
Local i 
vLista  := getProdMes()    // Retorna aProd



aSort( vLista ,,,{ |x,y| x[1] + StrZero(x[2],2) > y[1] + StrZero(y[2],2)} )

totProd:={}
//**Monta a tabela de Perdas**/
CriaPerda()
for N:=1 to len(vLista)
	nPos := aScan(AMSG ,{|X| X[1] == vLista[N][1] })
	if nPos == 0
		AAdd(AMSG,{vLista[N][1]})
	end
next

aImp     := ARRAY(XQUANT,13)
QProd  := ARRAY( len(AMSG),13)
xTotal   := Array(xQuant,10)
xTotal2  := Array(xQuant,2)


For N:=1 to Len(AMSG)
	For m:=1 to 13
		QProd[n][m]:=0
	Next
Next


//Zerar vetores
for N:=1 to XQUANT
	for z:=1 to 7
		aImp  [N][z]:=0
		xTotal[N][z]:=0
		if z <=2
			xTotal2[N][z]:=0
		end
	next
next

/*Captura a devolu寤es do mes referente*/
//vDevMes:=getDevMes()
//aVarCod:={}


/*Captura a qtd de pe�as transferidas para o processo*/
aqtdTransf:= getTransMes()
TotGProd:={0,0,0,0,0,0,0,0,0,0}
//QProd:={0,0,0,0,0,0,0,0,0,0}
SetRegua(len(AMSG))
for i:=1 to len(AMSG)
	xProd:=AMSG[i][1]
	IncRegua("Produto: "+xProd )
	xCiclo:=Posicione("SB1",1,xFilial("SB1")+xProd,"B1_CICLO")
	xCav:=Posicione("SB1",1,xFilial("SB1")+xProd,"B1_QTPONEY")
	
	Efid:=3600/xCiclo*xCav
	for m:=1 to xQuant
		nMes := XMESES[m]
		/*Captura a qtd de devolu寤es do produto de um mes referente*/
		devolu:=getDevol(xProd,nMes)
		
		nPos1 := aScan(vLista ,{|X| X[1] == xProd .and. X[2]== nMes })
		/*nProdu豫o e o somatorio de produ豫o + perdas*/
		nProducao :=IIF(nPos1<>0,vLista[nPos1][3],0)
		aIMP[m][1]:=IIF(nPos1<>0,vLista[nPos1][3],0)   // Plano
		aIMP[m][2]:=IIF(nPos1<>0,vLista[nPos1][4],0)   // Procucao Real
		/*Produ豫o Aceita   Produ豫o - Perdas  */
		aIMP[m][3]:=IIF(nPos1<>0,vLista[nPos1][4] -vLista[nPos1][6]  ,0)
		
		/*Qtd transferidas para o processo*/
		nPos2 := aScan(aqtdTransf ,{|X| X[1] == xProd .and. X[2]== nMes })
		aIMP[m][4]:=IIF(nPos2<>0,aqtdTransf[nPos2][3],0) // Qtd Transferida
		
		/*Qtd de devolu寤es para o fornecedor e interna*/
		aIMP[m][5]:=devolu //IIF(aIMP[m][1]==0,0,devolu)  // Devolucao
		
		aIMP[m][6]:=IIF(nPos1<>0,vLista[nPos1][6],0)   // Perda
		aIMP[m][7]:=IIF(nPos1<>0,vLista[nPos1][5],0)   // Retrabalho
		
		aIMP[m][8]:=IIF(nPos1<>0,(aIMP[m][5]/aIMP[m][4])*100,0) // % Devolucao
		aIMP[m][9]:=IIF(nPos1<>0,(aIMP[m][6]/aIMP[m][2])*100,0) // % Perda
		aIMP[m][10]:=IIF(nPos1<>0,(aIMP[m][7]/aIMP[m][2])*100,0) // % Retrabalho
		/*Vetor com a eficiencia e horas trabalhadas*/

		If  Type('VLista[npos1][7]')<>"N"
			VEfic:= CalcEfic(xProd,0,aIMP[m][3],nMes,EFID)
		Else
			VEfic:= CalcEfic(xProd,vLista[npos1][7] ,aIMP[m][3],nMes,EFID)
		Endif
		aIMP[m][11]:=VEfic[3] //Prod. Alcan�ada
		If Efid>0
			aIMP[m][12]:=VEfic[1]
		Endif
		///***Atraso por horas***/
		aImp[m][13]=VEfic[2] //Atraso por quantidade
	next
	
	For  m:=1 to xQuant
		For n:=1 to 13
			If n=8
				QProd[i][n]:=QProd[i][5]/QProd[i][4]*100
			Elseif n=9
				QProd[i][n]:=QProd[i][6]/QProd[i][2]*100
			Elseif n=10
				QProd[i][n]:=QProd[i][7]/QProd[i][2]*100
			ElseIf n=12
				If EfiD>0
					QProd[i][n]:=QProd[i][11]/Efid
				Else
					QProd[i][n]:=0
				Endif
			Else
				QProd[i][n]+=aImp[m][n]
			Endif
		Next
		
	Next
	QProd[i][11]:=QProd[i][11]/xQuant
	QProd[i][12]:=(QProd[i][12]/xQuant)*100
	
	/**Calculos das horas perdidas da inje豫o **/
	xProdDes:=Posicione("SB1",1,xFilial("SB1")+xProd,"B1_DESC")
	@ LI,000 PSAY xProd //+"  "+ xProdDes
	
	For N:=1 to Len(AMSGPROD)  //Len(aImp)
		xTot    :=0
		For M:=1 to xQuant
			If M==1
				@ LI,017      PSAY Alltrim(AMSGPROD[N])+space(20-Len(Alltrim(AMSGPROD[N])))
			EndIf
			
			If N <8
				@ LI,PCOL()+2 PSAY Transform(aImp[M][N],"@E 999,999,999")
			Elseif   n<=13//porcentagem
				@ LI,PCOL()+2 PSAY Transform(aImp[M][N],"@E 999,999.999")
			EndIf
			
		Next
		
		@Li, 208 Psay Transform(QProd[i][n],"@E 999,999,999")
		
		Li += 1
		
		If N==1
			@ LI,000 PSAY subs(xProdDes,1,15)
		ElseIf N==2
			@ LI,000 PSAY subs(xProdDes,16,15)
		ElseIf N==3
			@ LI,000 PSAY subs(xProdDes,31,15)
		ElseIf N==4
			@ LI,000 PSAY subs(xProdDes,46,15)
		ElseIf N==5
			@ LI,000 PSAY "PROD-ESP."
		ElseIf N==6
			@ LI,000 PSAY Transform(Efid,"@E 999.999")+"Pc/Hr"
		EndIf
		
	Next
	li++
	@ LI,000 PSAY Replicate("-",Limite)
	Li += 1
	If Li > 64
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	End
next

/*** Totalizando os gerais dos produtos************************/
For N:=1 to Len(AMSG)
	For m:=1 to 7
		TotGProd[m]+=QProd[n][m]
	Next
Next
TotGProd[8]:=TotGProd[5]/TotGProd[4]*100
TotGProd[9]:=TotGProd[6]/TotGProd[2]*100
TotGProd[10]:=TotGProd[7]/TotGProd[2]*100



/**********************************************************************/

IF     mv_par04 = 1
	@ LI,017 PSAY "T O T A L    M E N S A L    D A    M O N T A G E M    F I N A L "
ELSEIF mv_par04 = 2
	@ LI,017 PSAY "T O T A L    M E N S A L    D A    I M P R E S S � O "
ELSEIF mv_par04 = 3
	@ LI,017 PSAY "T O T A L    M E N S A L    D A    I N J E � � O   P L � S T I C A"
ELSEIF mv_par04 = 4
	@ LI,017 PSAY "T O T A L    M E N S A L    D A    I N S E R � � O   A U T O M A T I CA "
ENDif

Li += 2

For i:=1  to 10
	@ LI,017      PSAY Alltrim(AMSGPROD[i])+space(18-Len(Alltrim(AMSGPROD[i])))
	
	if N<8
		@Li, 120 Psay Transform(TotGProd[i],"@E 999,999,999")
	Else
		@Li, 120 Psay Transform(TotGProd[i],"@E 999,999.999")
	Endif
	Li++
Next


Set Device To Screen

dbSelectArea('SB1')
RetIndex('SB1')

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
DbSelectArea("EI1")
DbCloseAREA()
Return

/***************************************************************************************************************/
Static Function  CriaPerda()
/*
1	Falta de energia
3	Falta der M. Prima - Fornec
5-Falta de programa PCP
6	Reuni�o com Diretoria
9	Refei豫o/Lanche
10	Try-out / Testes
13 -invent�rio
38	gin�stica laboral



1-	1-Falta de Energia
2-	5-Falta de programa PCP
3-	6-reuni�o Diretoria
4-	9-Refei豫o/lanche
5-	10-try-out
6-	13-invent�rio
7-	38- Gin�tica laboral


*/

CQuery:="select Z7_COD,MONTH( Z7_EMISSAO) AS MES, SUM(CONVERT(INT,SUBSTRING(Z7_TDEC,1,2))) AS HORAS,SUM(CONVERT(INT,SUBSTRING(Z7_TDEC,3,2))) AS MIN   "
CQuery+=" FROM SZ7010  WHERE Z7_EMISSAO>='"+Dtos(CDatIni)+"' and Z7_EMISSAO<='"+DTos(CDatFin)+"'  "
CQuery+=" AND D_E_L_E_T_='' AND   Z7_ESTORNO<>'S' AND Z7_CODMOT IN('01','03','05','06','09','10','13','38') "
CQuery+=" GROUP BY Z7_COD,MONTH( Z7_EMISSAO) "
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias EI1 New


Return

/****************************************************************************************************************/
/*****************************************************************************************************************/
/**Calculo da Eficiencia ************************************************************************************/
/****************************************************************************************************************/
Static Function CalcEfic(Prod,Horas,QtdProdA,nMes,EFID)
Local QHrsE,DiasTrab,HorasT

HorasT:=0
QhrsE:=0
VEfic:={0,0,0}

DbSelectArea("EI1")
DbGotop()
While !Eof()
	If Prod=EI1->Z7_COD .and. NMes=EI1->MES
		QHrsE:=EI1->HORAS
		QHrsE:=QHrsE+(EI1->MIN/60)
		Exit
	Endif
	DbSkip()
EndDo
HorasT:=Horas-QHrsE
ProdIdeal:=Efid*HorasT

//   Efic:=QtdProdA/HorasT
Efic:=QtdProdA/ProdIdeal
VEfic[1]:=Efic
VEfic[2]:=(QtdProdA/ProdIdeal)/Efid
VEfic[3]:=QtdProdA/HorasT
Return VEfic

/*****************************************************************************************************************/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Retorna os valores gastos com materiais mes a mes            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸


Static Function getProdMes()
Local aProd:={}
//aProd  :={}
aTemp1 :={}
aTemp2 :={}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01             // Periodo Incial (mmaaaa)             �
//� mv_par02             // Periodo Final  (mmaaaa)             �
//� mv_par03             // Do Tipo                             �
//� mv_par04             // Ate o Tipo                          �
//� mv_par05             // CCusto                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
IF     mv_par04 = 1
	Xcc:="211"
ELSEIF mv_par04 = 2
	Xcc:="221"
ELSEIF mv_par04 = 3
	Xcc:="231"
ELSEIF mv_par04 = 4
	Xcc:="241"
END
/*
cQuery := ""
cQuery := " SELECT D3_COD, MONTH(D3_EMISSAO) AS MES, (SELECT SUM (C2_QUANT)"
cQuery += " FROM SC2010 "
cQuery += " WHERE "
cQuery += " C2_PRODUTO = D3_COD AND "
cQuery += " C2_DATPRI >= '"+ DTOS(cDatIni)+"'"
cQuery += " C2_DATPRI <= '"+ DTOS(cDatFin)+"'"
cQuery += " C2_TPOP = 'F' AND "
cQuery += " C2_CC = '"+ Xcc +"'"
cQuery += " AND SC2010. D_E_L_E_T_ <> '*') AS PLANO,  SUM(D3_PERDA) AS PERDA, SUM(D3_CUSTO1) AS CUSTO, SUM(D3_QUANT) AS QUANT "
cQuery += " FROM DADOSAP10..SD3010"
cQuery += " WHERE D3_TM ='400'"
cQuery += " AND D3_EMISSAO >= '"+ DTOS(cDatIni)+"'"
cQuery += " AND D3_EMISSAO <= '"+ DTOS(cDatFin)+"'"
cQuery += " AND (D3_TIPO='"+ mv_par03 +"' OR D3_TIPO='"+mv_par04+"')"
cQuery += " AND D3_CC ='"+ Xcc +"'"
cQuery += " AND D3_ESTORNO <> 'S'"
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY D3_COD, MONTH(D3_EMISSAO)"
*/


cQuery := " SELECT C2_PRODUTO, MONTH(C2_DATPRI) AS MES, SUM(C2_QUANT)AS PLANO,SUM(DATEDIFF(MINUTE,CONVERT(DATETIME,C2_DATPRI+' '+C2_HRPRI,120),CONVERT(DATETIME,C2_DATPRF+' '+C2_HRPRF)) )AS HORAS  "
cQuery += " FROM SC2"+xEmpresa+"0"
cQuery += " INNER JOIN SB1"+xEmpresa+"0 ON C2_PRODUTO = B1_COD "
cQuery += " WHERE "
cQuery += "     C2_DATPRI>= '"+ DTOS(cDatIni)+"'"
cQuery += " AND C2_DATPRI <= '"+ DTOS(cDatFin)+"'"
cQuery += " AND SB1010.D_E_L_E_T_='' "
if     mv_par03 == 1
	cQuery += " AND B1_TIPO='PA' "
elseif mv_par03 == 2
	cQuery += " AND B1_TIPO='PI' "
else
	cQuery += " AND B1_TIPO in ('PA','PI') "
endif
cQuery += " AND C2_CC = '"+ Xcc +"'"
cQuery += " AND C2_TPOP = 'F' "
cQuery += " AND SC2"+xEmpresa+"0. D_E_L_E_T_ <> '*' "
//incluido no dia 04/10/2010 para atender a necessidade do carlos RECURSO
cQuery += " AND C2_RECURSO>='"+mv_par06+"' AND C2_RECURSO<='"+mv_par07+"' "
cQuery += " GROUP BY C2_PRODUTO, MONTH(C2_DATPRI) "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TD3 New      //

cQuery := " SELECT D3_COD, MONTH(D3_EMISSAO) AS MES, SUM(D3_QUANT+D3_PERDA) AS QUANT, SUM(D3_PERDA) AS PERDA "
cQuery += " FROM SD3"+xEmpresa+"0 "
cQuery += " WHERE D3_TM ='400' "
cQuery += " AND D3_EMISSAO >= '"+ DTOS(cDatIni)+"'"
cQuery += " AND D3_EMISSAO <= '"+ DTOS(cDatFin)+"'"
if     mv_par03 == 1
	cQuery += " AND D3_TIPO='PA' "
elseif mv_par03 == 2
	cQuery += " AND D3_TIPO='PI' "
else
	cQuery += " AND D3_TIPO in ('PA','PI') "
endif
cQuery += " AND D3_CC = '"+ Xcc +"'"
cQuery += " AND D3_ESTORNO <> 'S' "
cQuery += " AND D3_RECURSO>='"+mv_par06+"' AND D3_RECURSO<='"+mv_par07+"' "
cQuery += " AND SD3"+xEmpresa+"0.D_E_L_E_T_ <> '*' "

cQuery += " GROUP BY D3_COD, MONTH(D3_EMISSAO) "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TD4 New

cQuery := " SELECT C2_PRODUTO, MONTH(C2_DATPRI) AS MES, SUM(C2_QUANT)AS RETRAB "
cQuery += " FROM SC2"+xEmpresa+"0 "
cQuery += " INNER JOIN SB1"+xEmpresa+"0 ON C2_PRODUTO = B1_COD "
cQuery += " WHERE "
cQuery += "     C2_DATPRI >= '"+ DTOS(cDatIni)+"'"
cQuery += " AND C2_DATPRI <= '"+ DTOS(cDatFin)+"'"
if     mv_par03 == 1
	cQuery += " AND B1_TIPO='PA' "
elseif mv_par03 == 2
	cQuery += " AND B1_TIPO='PI' "
else
	cQuery += " AND B1_TIPO in ('PA','PI') "
endif
cQuery += " AND C2_CC = '"+ Xcc +"'"
cQuery += " AND C2_TPOP = 'R' "
cQuery += " AND C2_RECURSO>='"+mv_par06+"' AND C2_RECURSO<='"+mv_par07+"' "
cQuery += " AND SB1010.D_E_L_E_T_='' "
cQuery += " AND SC2010.D_E_L_E_T_='' "
cQuery += " AND SC2"+xEmpresa+"0. D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY C2_PRODUTO, MONTH(C2_DATPRI) "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TD5 New

DbSElectArea("TD4")    // Producao Real e Perdas
DbGotop()
While !TD4->(Eof())
	
	AAdd(aTemp1,{D3_COD,;    //[1] Cod Produto
	MES,;    //[2] Mes
	QUANT,;    //[3] Producao
	PERDA})    //[4] Perda
	
	
	TD4->(DBSKIP())
Enddo

dbClearFil(NIL)
dbCloseArea("TD4")
dbCloseArea()

DbSElectArea("TD5")        // Retrabalhos
DbGotop()
While !TD5->(Eof())
	
	AAdd(aTemp2,{C2_PRODUTO,;    //[1] Cod Produto
	MES,;    //[2] Mes
	RETRAB})    //[3] Retrabalhos
	
	
	
	TD5->(DBSKIP())
Enddo
dbClearFil(NIL)
dbCloseArea("TD4")
dbCloseArea()

DbSElectArea("TD3")       // Plano de Producao
DbGotop()


DbSElectArea("TD3")       // Plano de Producao
DbGotop()
While !TD3->(Eof())
	
	//  xGrupo:=Posicione("SB1",1,xFilial("SB1")+D3_COD,"B1_GRUPO")
	//  xTipo :=Posicione("SB1",1,xFilial("SB1")+D3_COD,"B1_TIPO" )
	
	xCod:= C2_PRODUTO
	nPos  := aScan(aTemp1 ,{|X| X[1] == xCod .and. X[2]== MES })
	nPost := aScan(aTemp2 ,{|X| X[1] == xCod .and. X[2]== MES })
	xHoras:=Horas/60
	IF nPos == 0 .and. nPost == 0
		
		AAdd(aProd,{  xCod,;    //[1] Cod Produto
		MES,;    //[2] Mes
		PLANO,;    //[3] Plano de Producao
		0,;    //[4] Producao Real
		0,;    //[5] Retrabalho
		0,;  //[6] Perda
		0})    //[7]Horas
		
	ELSEIF nPos <> 0 .and. nPost == 0
		AAdd(aProd,{  xCod,;    //[1] Cod Produto
		MES,;    //[2] Mes
		PLANO,;    //[3] Plano de Producao
		aTemp1[nPos][3],;    //[4] Producao Real
		0,;    //[5] Retrabalho
		aTemp1[nPos][4],; //[6] Perda
		xHORAS})    //[7]  Horas
		
	ELSEIF nPos == 0 .and. nPost <> 0
		AAdd(aProd,{  xCod,;    //[1] Cod Produto
		MES,;    //[2] Mes
		PLANO,;    //[3] Plano de Producao
		0,;    //[4] Producao Real
		aTemp2[nPost][3],;    //[5] Retrabalho
		0,;//[6] Perda
		0})   //[7] Horas
		
	ELSEIF nPos <> 0 .and. nPost <> 0
		IF aTemp1[nPos][4] >= aTemp2[nPost][3]
			xPerda := aTemp1[nPos][4]  - aTemp2[nPost][3]
		ELSE
			xPerda := aTemp2[nPost][3] - aTemp1[nPos][4]
		ENDIF
		AAdd(aProd,{  xCod,;    //[1] Cod Produto
		MES,;    //[2] Mes
		PLANO,;    //[3] Plano de Producao
		aTemp1[nPos][3],;    //[4] Producao Real
		aTemp2[nPost][3],;    //[5] Retrabalho
		xPerda,;  //[6] Perda
		xHORAS})    //[7] horas
		
	Endif
	TD3->(DBSKIP())
	
ENDDO




dbSelectArea("TD3")
dbClearFil(NIL)
dbCloseArea("TD3")
dbCloseArea()
Return aProd




//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Retorna a quantidade de pe�as devolvidas no mes              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Static Function getDevMes()
IF     mv_par04 = 1
	Xcc:="211"
ELSEIF mv_par04 = 2
	Xcc:="221"
ELSEIF mv_par04 = 3
	Xcc:="231"
ELSEif mv_par04 = 4
	Xcc:="241"
END
aProdDev:={}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01             // Periodo Incial (mmaaaa)             �
//� mv_par02             // Periodo Final  (mmaaaa)             �
//� mv_par03             // Do Tipo                             �
//� mv_par04             // Ate o Tipo                          �
//� mv_par05             // CCusto                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cQuery := ""
cQuery := " SELECT BC_PRODUTO, MONTH(BC_DTRM) AS MES, SUM(BC_QUANT) AS QUANT"
cQuery += " FROM DADOSAP10..SBC"+xEmpresa+"0"
cQuery += " WHERE  BC_APLIC='"+ Xcc +"'"
cQuery += " AND BC_DTRM  >= '"+ DTOS(cDatIni)+"'"
cQuery += " AND BC_DTRM  <= '"+ DTOS(cDatFin)+"'"
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " GROUP BY BC_PRODUTO, MONTH(BC_DTRM )"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TD3 New      // Tabela de Funcionario Temporarios

DbSElectArea("TD3")
DbGotop()
While !TD3->(Eof())
	
	xTipo :=Posicione("SB1",1,xFilial("SB1")+BC_PRODUTO,"B1_TIPO" )
	
	xCod:=BC_PRODUTO
	nPos := aScan(aProdDev ,{|X| X[1] == xCod .and. X[2]== MES })
	
	IF nPos == 0
		AAdd(aProdDev,{  xCod,;    //[1]
		MES,;    //[2]
		QUANT})    //[3]
	ELSE
		aProdDev[nPos][3]+= QUANT
	end
	TD3->(DBSKIP())
	
ENDDO
dbSelectArea("TD3")
dbClearFil(NIL)
dbCloseArea("TD3")
dbCloseArea()
Return aProdDev

******************************
//Retorna as devolu�oes
******************************
Static Function GetDevol(cProd,nMesRef)
Local nDevo:=0
cDatInif := Ctod( cDiaIni         +"/"+StrZero(nMesRef,2)+"/"+StrZero(cAnoIni,4) )
cDatFinf := Ctod( CMES[nMesRef][2]+"/"+StrZero(nMesRef,2)+"/"+StrZero(cAnoFin,4) )
cQuery:=" select sum(BC_QUANT) QTD from "+ RetSqlName("SBC")
cQuery+=" where BC_PRODUTO='"+cProd+"' "
cQuery+=" and D_E_L_E_T_='' "
cQuery+=" and BC_APLIC='" + xCC+ "' "
cQuery+=" and BC_DTRM>='"+Dtos(cDatInif)+"' and BC_DTRM<='"+Dtos(cDatFinf)+"' "
Tcquery cQuery alias TRB
DbSelectArea("TRB")
DbGotop()
if !Eof()
	nDevo:=TRB->QTD
EndIf
DbSelectArea("TRB")
DbCloseArea()



Return nDevo

******************************
//Retorna as devolu�oes
******************************
Static Function getVarCod(cComp)
Local fi 

aCompf:={}
aVarProdf:={}
IF     mv_par04 = 1
	Xcc:="211"
ELSEIF mv_par04 = 2
	Xcc:="221"
ELSEIF mv_par04 = 3
	Xcc:="231"
ELSEIF mv_par04 = 4
	Xcc:="241"
END
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01             // Periodo Incial (mmaaaa)             �
//� mv_par02             // Periodo Final  (mmaaaa)             �
//� mv_par03             // Do Tipo                             �
//� mv_par04             // Ate o Tipo                          �
//� mv_par05             // CCusto                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cQuery := ""
cQuery := " SELECT G1_COD"
cQuery += " FROM DADOSAP10..SG1"+xEmpresa+"0"
cQuery += " WHERE  D_E_L_E_T_ <> '*'"
cQuery += " AND G1_INI >= '"+ DTOS(cDatIni)+"'"
cQuery += " AND G1_FIM <= '"+ DTOS(cDatFin)+"'"
cQuery += " AND G1_COMP <= '"+ cComp +"'"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TD1 New      // Tabela de Funcionario Temporarios

DbSElectArea("TD1")
DbGotop()
While !TD1->(Eof())
	
	xCod := G1_COD
	
	nPos := aScan(aCompf ,{|X| X[1] == xCod })
	
	if nPos == 0
		AAdd(aCompf,{xCod})
	end
	
	TD1->(DBSKIP())
	
ENDDO
dbSelectArea("TD1")
dbClearFil(NIL)
dbCloseArea("TD1")
dbCloseArea()

cQuery := ""
cQuery := " SELECT MONTH(BC_DTRM ) AS MES, SUM(BC_QUANT) AS QUANT"
cQuery += " FROM DADOSAP10..SBC"+xEmpresa+"0"
cQuery += " WHERE  BC_APLIC='"+ Xcc +"'"
cQuery += " AND BC_DTRM  >= '"+ DTOS(cDatIni)+"'"
cQuery += " AND BC_DTRM  <= '"+ DTOS(cDatFin)+"'"
cQuery += " AND D_E_L_E_T_ <> '*'"
if len(aCompf)<>0
	cQuery += " AND ( "
	for fi:=1 to len(aCompf)
		if fi > 1
			cQuery +=" OR "
		end
		cQuery += " BC_PRODUTO ='"+ aCompf[fi][1] +"'"
	next
	cQuery += " )"
end
cQuery += " GROUP BY MONTH(BC_DTRM )"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TD2 New      // Tabela de Funcionario Temporarios

DbSElectArea("TD2")
DbGotop()
While !TD2->(Eof())
	
	//xTipo :=Posicione("SB1",1,xFilial("SB1")+BC_PRODUTO,"B1_TIPO" )
	
	//xCod:=BC_PRODUTO
	nPos := aScan(aVarProdf ,{|X| X[1] == xCod .and. X[2]== MES })
	
	IF nPos == 0
		AAdd(aVarProdf,{ cComp,;   //[1]
		MES,;    //[2]
		QUANT})    //[3]
	ELSE
		aVarProdf[nPos][3]+= QUANT
	end
	TD2->(DBSKIP())
	
ENDDO
dbSelectArea("TD2")
dbClearFil(NIL)
dbCloseArea("TD2")
dbCloseArea()

Return aVarProdf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Retorna a quantidade de pe豫s Transferidas no mes              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Static Function getTransMes()
If mv_par04 = 1
	xCC:="211"
ElseIf mv_par04 = 2
	xCC:="221"
ElseIf mv_par04 = 3
	xCC:="231"
ElseIf mv_par04 = 4
	xCC:="241"
EndIf

aProdTrans:={}

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Variaveis utilizadas para parametros                        �
//� mv_par01             // Periodo Incial (mmaaaa)             �
//� mv_par02             // Periodo Final  (mmaaaa)             �
//� mv_par03             // Do Tipo                             �
//� mv_par04             // Ate o Tipo                          �
//� mv_par05             // CCusto                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cQuery := " "
cQuery := " SELECT D3_COD, MONTH(D3_EMISSAO) AS MES, SUM(D3_QUANT) AS QUANT,SUM(D3_CUSTO1) AS CUSTO"
cQuery += " FROM " + RetSqlName("SD3") + " "
cQuery += " WHERE D_E_L_E_T_='' "
cQuery += " AND D3_EMISSAO BETWEEN '" + DTOS(cDatIni)+"' AND '"+ DTOS(cDatFin)+"' "
cQuery += " AND D3_ESTORNO = '' "
cQuery += " AND D3_TM ='600' "
cQuery += " GROUP BY D3_COD, MONTH(D3_EMISSAO)"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TD3 New      // Tabela de Funcionario Temporarios

dbSelectArea("TD3")
dbGotop()
While !TD3->(Eof())
	
	xCod:=D3_COD
	nPos := aScan(aProdTrans ,{|X| X[1] == xCod .and. X[2]== MES })
	
	IF nPos == 0
		AAdd(aProdTrans,{xCod,;    //[1]
		MES,;    //[2]
		QUANT,;    //[3]
		CUSTO})    //[4]
	end
	TD3->(DBSKIP())
	
End

dbSelectArea("TD3")
dbClearFil(NIL)
dbCloseArea("TD3")
dbCloseArea()

Return aProdTrans
