#include "rwmake.ch"

User Function GGF005()

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
SetPrvt("LI,M_PAG,NTIPO,XQUANT,CQUANT,XOP,ACM,MSEQUENCIA")
SetPrvt("a_Prod,a_Sum,a_PA,n_PA,nProd")
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GGF005   ³ Autor ³ Marcelo i. Silveira   ³ Data ³ 01.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Custo dos produtos industrializados...                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake GGF005 -X                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterado ³ 01/09/07 - Por: Jorge Silveira                             ³±±
±±³          ³ Inclusao do Setor de Insercao Automatica no custo.         ³±±
±±³          ³ 08/01/08 - Por: Jorge Silveira                             ³±±
±±³          ³ Ajustes para utilizacao na NSSP.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

titulo    := PADC("Custo de Fabricacão.",20)
cDesc1    := PADC("Este programa tem com objetivo, imprimir o Custo de Fabricao dos Produtos",74)
cDesc2    := PADC("Industrializados, por Localizacao do Processo.",74)
cDesc3    := ""
tamanho   := "G"
limite    := 220
cString   := "SZ4"
aOrd      := {} //-- Ordem
lContinua := .T.
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "GGF005"
nLastKey  := 0
cPerg     := "GGF003"
xCPI      := {}
gQuant    := 0
nQtdPa    := 0

n_251     := 5   // Insercao Automatica
n_241     := 1   // Insercao Automatica
n_231     := 2   // Injecao Plastica
n_221     := 3   // Impressao
n_211     := 4   // Montagem

n_PA      := 0
n_Prd     := 0

a_PA   := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0}}           
a_Prod := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0}}           
a_Sum  := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;           
           {0,0,0,0,0,0,0,0,0,0,0,0,0,0}}

a_Campos  :=   {"Z4_QUANT",;       // 01
				"Z4_MPN",;         // 02
				"Z4_MPI",;         // 03
				"Z4_MSN",;         // 04
				"Z4_MSI",;         // 05
				"Z4_MODSAL",;      // 06
				"Z4_MODENC",;      // 07
				"Z4_MODBEN",;      // 08
				"Z4_MODGGF",;      // 09
				"Z4_MOISAL",;      // 10
				"Z4_MOIENC",;      // 11
				"Z4_MOIBEN",;      // 12
				"Z4_MOIGGF",;      // 13
				"Z4_PI" }          // 14

a_Msg   := {"M.P. Nacional ",;
            "M.P. Importada",;
            "Total M.P. -->",;
            "Mat.Improd.Nac",;
            "Mat.Improd.Imp",;
            "M.O.D.Salarios",;
            "      Enc.Soc.",;
            "      Ben.Soc.",;
            "      G.G.F.  ",;
            "M.O.I.Salarios",;
            "      Enc.Soc.",;
            "      Ben.Soc.",;
            "      G.G.F.  ",;
            "Custo Total-->"}


Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01     // Produto inicial                              ³
//³ MV_PAR02     // Produto final                                ³
//³ MV_PAR03     // Data de emissao inicial                      ³
//³ MV_PAR04     // Data de emissao final                        ³
//³ MV_PAR05     // Impressao (Analitico/Sintetico)              ³
//³ MV_PAR06     // Grava Custos GGF (Sim/Nao)                   ³
//³ MV_PAR07     // C.Medio a Considerar(Fechamento/Final)       ³
//³ MV_PAR08     // Salta Pagina (Sim/Nao)                       ³
//³ MV_PAR09     // Indice de Perda ( % )                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "GGF005"

wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Custo de Fabricacao... De: "+dtoc(mv_par03)+" ate: "+dtoc(mv_par04)
cabec1 := "Codigo          Tp Um      Quant       C.Medio Historico           Insercao       Injecao     Impressao      Montagem        Sensor         Custo"
cabec2 := "                                                                 Automatica      Plastica                       Final   Combustivel         Total"
//         999999999999999 xx xx 99,999,9999 99,999.999999 xxxxxxxxxxxxx 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99 99.999.999,99
//         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//                   10        20        30        40        50        60        70        80        90        100       110      120       130

nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

If nLastKey == 27
	Return
Endif

#IFDEF WINDOWS
	RptStatus({|| RptDetail()})
	Return
	Static Function RptDetail()
#ENDIF
dbSelectArea("SZ3")
dbSetOrder(1)
dbSeek(xFilial("SZ3")+dtos(mv_par04))

dbSelectArea("SZ4")
dbSetOrder(1)
dbSeek(xFilial("SZ4")+dtos(mv_par04))

If Eof()
	MsgStop("Sem Informaçoes para a Data em parâmetros. ")
	Return
End

SetRegua(RecCount())

dbSeek(xFilial("SZ4")+dtos(mv_par04)+MV_PAR01,.T.)

While lContinua .And. !Eof() .And. dtos(Z4_DATA) == dtos(MV_PAR04)

	IncRegua()
	
	#IFNDEF WINDOWS
		If LastKey() == 286
			lEnd := .t.
		End
	#ENDIF
	
	If lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	If Z4_PRODUTO < MV_PAR01 .Or. Z4_PRODUTO > MV_PAR02
		dbSkip()
		Loop
	End
	
	xQuant   := Z4_QUANT
	
	xProduto := Z4_PRODUTO
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+xProduto)
	xDesc := B1_Desc
	xTipo := B1_Tipo
	xUm   := B1_Um
	nProd := 0         
	
	dbSelectArea("SZ4")
	
	a_Prod  := {{0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
	            {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
	            {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
	            {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;
	            {0,0,0,0,0,0,0,0,0,0,0,0,0,0},;	            
	            {0,0,0,0,0,0,0,0,0,0,0,0,0,0}}
	
	For _i:=2 to 14
		c_Campos := a_Campos[_i]
		nCust 	 := &c_Campos
		nProd    += nCust
		If xTipo == "PA"
			n_PA 	 += nCust
		EndIf
	Next
	
	a_cArea := GetArea()
	nPi     := 0
	ACMVET(xProduto,xQuant,"")

	For _i:=1 to 14
		a_Prod[6][_i] := a_Prod[1][_i] + a_Prod[2][_i] + a_Prod[3][_i] + a_Prod[4][_i] + a_Prod[5][_i]
	Next

	For _i:=1 to 14
		a_Sum[1][_i]  += a_Prod[1][_i]
		a_Sum[2][_i]  += a_Prod[2][_i]
		a_Sum[3][_i]  += a_Prod[3][_i]
		a_Sum[4][_i]  += a_Prod[4][_i]
		a_Sum[5][_i]  += a_Prod[5][_i]
		a_Sum[6][_i]  += a_Prod[6][_i]		
	Next
	
	If nPi <> 0
		dbSelectArea("SC2")
		dbSetOrder(2)
		dbSeek(xFilial("SC2")+xProduto+dtos(mv_par03),.T.)
		c_OP     := C2_NUM+C2_ITEM+C2_SEQUEN
		nPi_op   := 0
		a_ConsMp := {}
		a_Pi     := {}
		GetProd(.F.)
		For i:=1 to Len(a_Pi)
			a_Pi[i][08] := (a_Pi[i][08]/nPi_op)*nPi
		Next
		While Len(a_Pi)<>0
			c_Pi := a_Pi[1][1]
			RecalcPi(c_Pi)
			a_Tmp := {}
			For _i:=2 to Len(a_Pi)
				aAdd(a_Tmp,a_Pi[_i])
			Next
			a_Pi := a_Tmp
		EndDo
		For n_i:=1 to Len(a_ConsMp)
			
			n_xMPI:=n_xMPN:=n_MII:=n_MIN:=n_SAL:=n_ENC:=n_BEN:=n_GGF:=n_MIS:=n_MIE:=n_MIO:=n_GGI:=0
			n_Varia:=0
			If     ALLTRIM(a_ConsMp[n_i][9]) == "MPN"
				n_xMPN  := a_ConsMp[n_i][8]
				n_Varia := a_ConsMp[n_i][8]
			ElseIf ALLTRIM(a_ConsMp[n_i][9]) == "MPI"
				n_xMPI  := a_ConsMp[n_i][8]
				n_Varia := a_ConsMp[n_i][8]
			ElseIf ALLTRIM(a_ConsMp[n_i][9]) == "GGF"
				cVar    := "n_"+SubStr(a_ConsMp[n_i][1],1,3)
				&cVar   := a_ConsMp[n_i][8]
				n_Varia := a_ConsMp[n_i][8]
			EndIf
	        
	        If alltrim(a_ConsMp[n_i][6])="241"
				_n := 1
	        ElseIf alltrim(a_ConsMp[n_i][6])="231"
				_n := 2
			ElseIf alltrim(a_ConsMp[n_i][6])="221"
            	_n := 3
			ElseIf alltrim(a_ConsMp[n_i][6])="251"
            	_n := 5           	
            Else //If !(alltrim(a_ConsMp[n_i][6])$"231/221") 
            	_n := 4
            EndIf
            
			a_Prod[_n][2] += n_xMPI
			a_Prod[_n][1] += n_xMPN
			a_Prod[_n][3] += n_xMPN+n_xMPI
			
			a_Prod[_n][5] += n_MII
			a_Prod[_n][4] += n_MIN
			
			a_Prod[_n][6] += n_SAL
			a_Prod[_n][7] += n_ENC
			a_Prod[_n][8] += n_BEN
			a_Prod[_n][9] += n_GGF
		
			a_Prod[_n][10] += n_MIS
			a_Prod[_n][11] += n_MIE
			a_Prod[_n][12] += n_MIO
			a_Prod[_n][13] += n_GGI
			a_Prod[_n][14] += n_Varia
		Next
		
	EndIf
	
	RestArea(a_cArea)
	For _i:=1 to 14
		a_Prod[6][_i] := a_Prod[1][_i] + a_Prod[2][_i] + a_Prod[3][_i] + a_Prod[4][_i] + a_Prod[5][_i]
	Next
	
	If xTipo == "PA"
		nQtdPa += xQuant
	EndIf
	gQuant += xQuant
	
	For _i:=2 to 13
		c_Campos := a_Campos[_i]
		nCust 	 := &c_Campos
		n_Prd    += nCust
	Next
	
	If nProd<>0
		For _i:=1 to 14
			a_Prod[1][_i] := nProd * a_Prod[1][_i] / a_Prod[6][14]
			a_Prod[2][_i] := nProd * a_Prod[2][_i] / a_Prod[6][14]
			a_Prod[3][_i] := nProd * a_Prod[3][_i] / a_Prod[6][14]
			a_Prod[4][_i] := nProd * a_Prod[4][_i] / a_Prod[6][14]
			a_Prod[5][_i] := nProd * a_Prod[5][_i] / a_Prod[6][14]
			a_Prod[6][_i] := nProd * a_Prod[6][_i] / a_Prod[6][14]			
		Next
	EndIf
	tMedio := (a_Prod[6][14] / xQuant)
	
	@ li,000      PSAY xProduto
	@ li,PCOL()+1 PSAY xTipo
	@ li,PCOL()+1 PSAY xUM
	@ li,PCOL()+1 PSAY Transform(xQuant,"@E 99,999,999")
	@ li,PCOL()+1 PSAY Transform(tMedio,"@E 99,999.999999")
	
	For _i:=1 to 14
		@ li,047    PSAY a_Msg[_i]
		@ li,PCOL()+1 PSAY Transform(a_Prod[1][_i],"@E 99,999,999.99")
		@ li,PCOL()+1 PSAY Transform(a_Prod[2][_i],"@E 99,999,999.99")
		@ li,PCOL()+1 PSAY Transform(a_Prod[3][_i],"@E 99,999,999.99")
		@ li,PCOL()+1 PSAY Transform(a_Prod[4][_i],"@E 99,999,999.99")
		@ li,PCOL()+1 PSAY Transform(a_Prod[5][_i],"@E 99,999,999.99")		
		@ li,PCOL()+1 PSAY Transform(a_Prod[6][_i],"@E 99,999,999.99")				
		li++
		If _i==1
			@ li,000      PSAY Subs(xDesc,1,40)
		EndIf
	Next    
	
	@ li,00 PSAY REPL("-",limite)
	
	If li >= 62 // 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	Else
		li ++
	End
	
	dbSkip()
	
Enddo

If li >= 62
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
End

n_Prd -= a_Sum[5][4] := SZ3->Z3_MSNMon
n_Prd -= a_Sum[5][5] := SZ3->Z3_MSIMon
n_Prd -= a_Sum[5][6] := SZ3->Z3_MonSal
n_Prd -= a_Sum[5][7] := SZ3->Z3_MonEnc
n_Prd -= a_Sum[5][8] := SZ3->Z3_MonBen
n_Prd -= a_Sum[5][9] := SZ3->Z3_MonGGF

a_Sum[5][10] := SZ3->Z3_SnsSal * a_Sum[5][10]/a_Sum[6][10]
a_Sum[5][11] := SZ3->Z3_SnsEnc * a_Sum[5][11]/a_Sum[6][11]
a_Sum[5][12] := SZ3->Z3_SnsBen * a_Sum[5][12]/a_Sum[6][12]
a_Sum[5][13] := SZ3->Z3_SnsGGF * a_Sum[5][13]/a_Sum[6][13]

n_Prd -= a_Sum[4][4] := SZ3->Z3_MSNMon
n_Prd -= a_Sum[4][5] := SZ3->Z3_MSIMon
n_Prd -= a_Sum[4][6] := SZ3->Z3_MonSal
n_Prd -= a_Sum[4][7] := SZ3->Z3_MonEnc
n_Prd -= a_Sum[4][8] := SZ3->Z3_MonBen
n_Prd -= a_Sum[4][9] := SZ3->Z3_MonGGF

a_Sum[4][10] := SZ3->Z3_MOISal * a_Sum[4][10]/a_Sum[6][10]
a_Sum[4][11] := SZ3->Z3_MOIEnc * a_Sum[4][11]/a_Sum[6][11]
a_Sum[4][12] := SZ3->Z3_MOIBen * a_Sum[4][12]/a_Sum[6][12]
a_Sum[4][13] := SZ3->Z3_MOIGGF * a_Sum[4][13]/a_Sum[6][13]

n_Prd -= a_Sum[3][4] := SZ3->Z3_MSNImp
n_Prd -= a_Sum[3][5] := SZ3->Z3_MSIImp
n_Prd -= a_Sum[3][6] := SZ3->Z3_ImpSal
n_Prd -= a_Sum[3][7] := SZ3->Z3_ImpEnc
n_Prd -= a_Sum[3][8] := SZ3->Z3_ImpBen
n_Prd -= a_Sum[3][9] := SZ3->Z3_ImpGGF

a_Sum[3][10] := SZ3->Z3_MOISal  * a_Sum[3][10]/a_Sum[6][10]
a_Sum[3][11] := SZ3->Z3_MOIEnc  * a_Sum[3][11]/a_Sum[6][11]
a_Sum[3][12] := SZ3->Z3_MOIBen  * a_Sum[3][12]/a_Sum[6][12]
a_Sum[3][13] := SZ3->Z3_MOIGGF  * a_Sum[3][13]/a_Sum[6][13]

n_Prd -= a_Sum[2][4] := SZ3->Z3_MSNInj
n_Prd -= a_Sum[2][5] := SZ3->Z3_MSIInj
n_Prd -= a_Sum[2][6] := SZ3->Z3_InjSal
n_Prd -= a_Sum[2][7] := SZ3->Z3_InjEnc
n_Prd -= a_Sum[2][8] := SZ3->Z3_InjBen
n_Prd -= a_Sum[2][9] := SZ3->Z3_InjGGF

a_Sum[2][10] := SZ3->Z3_MOISal  * a_Sum[2][10]/a_Sum[6][10]
a_Sum[2][11] := SZ3->Z3_MOIEnc  * a_Sum[2][11]/a_Sum[6][11]
a_Sum[2][12] := SZ3->Z3_MOIBen  * a_Sum[2][12]/a_Sum[6][12]
a_Sum[2][13] := SZ3->Z3_MOIGGF  * a_Sum[2][13]/a_Sum[6][13]

n_Prd -= a_Sum[1][4] := SZ3->Z3_MSNIns
n_Prd -= a_Sum[1][5] := SZ3->Z3_MSIIns
n_Prd -= a_Sum[1][6] := SZ3->Z3_InsSal
n_Prd -= a_Sum[1][7] := SZ3->Z3_InsEnc
n_Prd -= a_Sum[1][8] := SZ3->Z3_InsBen
n_Prd -= a_Sum[1][9] := SZ3->Z3_InsGGF

a_Sum[1][10] := SZ3->Z3_MOISal  * a_Sum[1][10]/a_Sum[6][10]
a_Sum[1][11] := SZ3->Z3_MOIEnc  * a_Sum[1][11]/a_Sum[6][11]
a_Sum[1][12] := SZ3->Z3_MOIBen  * a_Sum[1][12]/a_Sum[6][12]
a_Sum[1][13] := SZ3->Z3_MOIGGF  * a_Sum[1][13]/a_Sum[6][13]

n_Prd -= SZ3->Z3_MOISal
n_Prd -= SZ3->Z3_MOIEnc
n_Prd -= SZ3->Z3_MOIBen
n_Prd -= SZ3->Z3_MOIGGF

For _i:=1 to 3
	a_Sum[1][_i] := n_Prd*a_Sum[1][_i]/a_Sum[6][3]
	a_Sum[2][_i] := n_Prd*a_Sum[2][_i]/a_Sum[6][3]
	a_Sum[3][_i] := n_Prd*a_Sum[3][_i]/a_Sum[6][3]
	a_Sum[4][_i] := n_Prd*a_Sum[4][_i]/a_Sum[6][3]
	a_Sum[5][_i] := n_Prd*a_Sum[5][_i]/a_Sum[6][3]
	a_Sum[6][_i] := n_Prd*a_Sum[6][_i]/a_Sum[6][3]	
Next

a_Sum[1][14] := 0
a_Sum[2][14] := 0
a_Sum[3][14] := 0
a_Sum[4][14] := 0
a_Sum[5][14] := 0
a_Sum[6][14] := 0

@ li,000      PSAY "Custo Total de Fabricacao de "
@ li,PCOL()+1 PSAY AllTrim(Transform(gQUANT,"@E 99,999,999"))+" Pecas."

For _i:=1 to 14
	
	@ li,047      PSAY a_Msg[_i]
	@ li,PCOL()+1 PSAY Transform(a_Sum[1][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_Sum[2][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_Sum[3][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_Sum[4][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_Sum[5][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_Sum[6][_i],"@E 99,999,999.99")	
	li++
	
	If _i>=3 .and. _i<>14
		a_Sum[6][_i+1] := a_Sum[1][_i+1]+a_Sum[2][_i+1]+a_Sum[3][_i+1]+a_Sum[4][_i+1]+a_Sum[5][_i+1]
	EndIf
	
	If _i<>3
		a_Sum[1][14] += a_Sum[1][_i]
		a_Sum[2][14] += a_Sum[2][_i]
		a_Sum[3][14] += a_Sum[3][_i]
		a_Sum[4][14] += a_Sum[4][_i]
		a_Sum[5][14] += a_Sum[5][_i]
		a_Sum[6][14] += a_Sum[6][_i]		
	EndIf
	
Next
@ li,00 PSAY REPL("*",limite)
li+=2
If li >= 62
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
End
@ li,000      PSAY "Total dos Produtos Acabados: "
@ li,PCOL()+1 PSAY AllTrim(Transform(nQtdPa,"@E 99,999,999"))+" Pecas "

n_PA -= a_PA[5][4] := SZ3->Z3_MSNSns
n_PA -= a_PA[5][5] := SZ3->Z3_MSISns
n_PA -= a_PA[5][6] := SZ3->Z3_SnsSal
n_PA -= a_PA[5][7] := SZ3->Z3_SnsEnc
n_PA -= a_PA[5][8] := SZ3->Z3_SnsBen
n_PA -= a_PA[5][9] := SZ3->Z3_SnsGGF

a_PA[5][10] := SZ3->Z3_MOISal * a_Sum[5][10]/a_Sum[6][10]
a_PA[5][11] := SZ3->Z3_MOIEnc * a_Sum[5][11]/a_Sum[6][11]
a_PA[5][12] := SZ3->Z3_MOIBen * a_Sum[5][12]/a_Sum[6][12]
a_PA[5][13] := SZ3->Z3_MOIGGF * a_Sum[5][13]/a_Sum[6][13]

n_PA -= a_PA[4][4] := SZ3->Z3_MSNMon
n_PA -= a_PA[4][5] := SZ3->Z3_MSIMon
n_PA -= a_PA[4][6] := SZ3->Z3_MonSal
n_PA -= a_PA[4][7] := SZ3->Z3_MonEnc
n_PA -= a_PA[4][8] := SZ3->Z3_MonBen
n_PA -= a_PA[4][9] := SZ3->Z3_MonGGF
a_PA[4][10] := SZ3->Z3_MOISal * a_Sum[4][10]/a_Sum[5][10]
a_PA[4][11] := SZ3->Z3_MOIEnc * a_Sum[4][11]/a_Sum[5][11]
a_PA[4][12] := SZ3->Z3_MOIBen * a_Sum[4][12]/a_Sum[5][12]
a_PA[4][13] := SZ3->Z3_MOIGGF * a_Sum[4][13]/a_Sum[5][13]

n_PA -= a_PA[3][4] := SZ3->Z3_MSNImp
n_PA -= a_PA[3][5] := SZ3->Z3_MSIImp
n_PA -= a_PA[3][6] := SZ3->Z3_ImpSal
n_PA -= a_PA[3][7] := SZ3->Z3_ImpEnc
n_PA -= a_PA[3][8] := SZ3->Z3_ImpBen
n_PA -= a_PA[3][9] := SZ3->Z3_ImpGGF
a_PA[3][10] := SZ3->Z3_MOISal  * a_Sum[3][10]/a_Sum[5][10]
a_PA[3][11] := SZ3->Z3_MOIEnc  * a_Sum[3][11]/a_Sum[5][11]
a_PA[3][12] := SZ3->Z3_MOIBen  * a_Sum[3][12]/a_Sum[5][12]
a_PA[3][13] := SZ3->Z3_MOIGGF  * a_Sum[3][13]/a_Sum[5][13]

n_PA -= a_PA[2][4] := SZ3->Z3_MSNInj
n_PA -= a_PA[2][5] := SZ3->Z3_MSIInj
n_PA -= a_PA[2][6] := SZ3->Z3_InjSal
n_PA -= a_PA[2][7] := SZ3->Z3_InjEnc
n_PA -= a_PA[2][8] := SZ3->Z3_InjBen
n_PA -= a_PA[2][9] := SZ3->Z3_InjGGF
a_PA[2][10] := SZ3->Z3_MOISal  * a_Sum[2][10]/a_Sum[5][10]
a_PA[2][11] := SZ3->Z3_MOIEnc  * a_Sum[2][11]/a_Sum[5][11]
a_PA[2][12] := SZ3->Z3_MOIBen  * a_Sum[2][12]/a_Sum[5][12]
a_PA[2][13] := SZ3->Z3_MOIGGF  * a_Sum[2][13]/a_Sum[5][13]

n_PA -= a_PA[1][4] := SZ3->Z3_MSNIns
n_PA -= a_PA[1][5] := SZ3->Z3_MSIIns
n_PA -= a_PA[1][6] := SZ3->Z3_InsSal
n_PA -= a_PA[1][7] := SZ3->Z3_InsEnc
n_PA -= a_PA[1][8] := SZ3->Z3_InsBen
n_PA -= a_PA[1][9] := SZ3->Z3_InsGGF
a_PA[1][10] := SZ3->Z3_MOISal  * a_Sum[1][10]/a_Sum[5][10]
a_PA[1][11] := SZ3->Z3_MOIEnc  * a_Sum[1][11]/a_Sum[5][11]
a_PA[1][12] := SZ3->Z3_MOIBen  * a_Sum[1][12]/a_Sum[5][12]
a_PA[1][13] := SZ3->Z3_MOIGGF  * a_Sum[1][13]/a_Sum[5][13]

n_PA -= SZ3->Z3_MOISal
n_PA -= SZ3->Z3_MOIEnc
n_PA -= SZ3->Z3_MOIBen
n_PA -= SZ3->Z3_MOIGGF

For _i:=1 to 3
	a_PA[1][_i] := n_PA*a_Sum[1][_i]/a_Sum[6][3]
	a_PA[2][_i] := n_PA*a_Sum[2][_i]/a_Sum[6][3]
	a_PA[3][_i] := n_PA*a_Sum[3][_i]/a_Sum[6][3]
	a_PA[4][_i] := n_PA*a_Sum[4][_i]/a_Sum[6][3]
	a_PA[5][_i] := n_PA*a_Sum[5][_i]/a_Sum[6][3]
	a_PA[6][_i] := n_PA*a_Sum[6][_i]/a_Sum[6][3]	
Next

For _i:=1 to 14
	@ li,047    PSAY a_Msg[_i]
	@ li,PCOL()+1 PSAY Transform(a_PA[1][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_PA[2][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_PA[3][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_PA[4][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_PA[5][_i],"@E 99,999,999.99")
	@ li,PCOL()+1 PSAY Transform(a_PA[6][_i],"@E 99,999,999.99")	
	li++
    
	If _i>=3 .and. _i<>14
		a_PA[6][_i+1] := a_PA[1][_i+1]+a_PA[2][_i+1]+a_PA[3][_i+1]+a_PA[4][_i+1]+a_PA[5][_i+1]
	EndIf
	If _i<>3
		a_PA[1][14] += a_PA[1][_i]
		a_PA[2][14] += a_PA[2][_i]
		a_PA[3][14] += a_PA[3][_i]
		a_PA[4][14] += a_PA[4][_i]
		a_PA[5][14] += a_PA[5][_i]
		a_PA[6][14] += a_PA[6][_i]		
	EndIf
	
Next

//@ li,119      PSAY Transform(n_PA,"@E 99,999,999.99")
li+=2
@ li,00 PSAY REPL("*",limite)

Set Device To Screen

If aReturn[5] == 1
	Set Printer to
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return
/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçao    ³  ACMVET  ³ Autor ³ Marcelo Iannuzzi      ³Inicio³ 10.04.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±*/
Static Function ACMVET(c_Prod,nQuant,cPai)
Local	c_Var    := ""
Local	_nPos    := 0
Local	c_CpoQt  := ""
Local	n_Add    := 0
Local	n_PdtSum := 0
Local	a_Uni    := {0,0,0,0,0,0,0,0,0,0,0,0}
Local   n_Qtd    := 0
Local   nCust    := {}

dbSelectArea("SZ4")
dbSetOrder(1)
dbSeek(xFilial("SZ4")+dtos(mv_par04)+c_Prod)

While !Eof() .and. Z4_PRODUTO == c_Prod
	IncRegua()
	c_Var    := "n_"+Alltrim(Z4_CC)
	_nPos    := &c_Var
	n_add    := 0
	c_CpoQt  := a_Campos[1]
	n_Qtd    := &c_CpoQt
	
	For _i:=1 to 12
		c_Campo := a_Campos[_i+1]
		a_Uni   := &c_Campo/n_Qtd
		If _i == 3
			n_Add               := 1
			a_Prod[_nPos][_i]   := a_Prod[_nPos][01] + a_Prod[_nPos][02]
		EndIf
		a_Prod[_nPos][_i+n_Add] += a_Uni*nQuant
		n_PdtSum                += a_Uni*nQuant
		
	Next
	a_Prod[_nPos][14]    += n_pdtSum
	c_Campo := a_Campos[14]
	nPi     += &c_Campo
	dbSkip()
EndDo

Return

Static Function GetProd(lFlat)

Local c_Comp := ""
Local _nPos  := 0
Local cDesc  := ""
Local cTipo  := ""

dbSelectArea("SD3")
dbSetOrder(1)
If !dbSeek(xFilial("SD3")+c_OP)
	Return
EndIf

While !Eof() .And. Alltrim(D3_OP) == c_OP
	
	If dtos(D3_EMISSAO) < dtos(MV_PAR03) .or. dtos(D3_EMISSAO) > dtos(MV_PAR04)
		dbSkip()
		Loop
	End
	
	If D3_ESTORNO == "S" .or. !(D3_CF $ "RE1/RE2/RE3/RE5") .or. !(D3_TIPO $ "MP/PI/GG/RT/BN")
		dbSkip()
		Loop
	End
	
	c_Comp := D3_COD
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+c_Comp)
	cDesc  := B1_Desc
	cTipo  := B1_Tipo
	cGrupo := B1_GRUPO
	dbSelectArea("SD3")
	
	While  !Eof() .and. Alltrim(D3_OP) == c_OP .and. c_Comp == D3_COD
		
		If D3_ESTORNO == "S" .or. !(D3_CF $ "RE1/RE2/RE3/RE5")  .or. !(D3_TIPO $ "MP/PI/GG/RT/BN")
			dbSkip()
			Loop
		End
		
		If D3_TIPO<>"PI" .and. lFlat
			_nPos := Ascan(a_ConsMp,{|X|  X[1]==D3_COD .and. X[2]==D3_CF})
			If _nPos == 0 .or. lFlat
				aAdd(a_ConsMp,{D3_COD,D3_CF,D3_UM,cDesc,cTipo,D3_CC,D3_QUANT,D3_CUSTO1,cGrupo,lFlat})
			Else
				a_ConsMp[_nPos][07] += D3_QUANT
				a_ConsMp[_nPos][08] += D3_CUSTO1
			EndIf
		Else
			_nPos := Ascan(a_Pi,{|X|  X[1]==D3_COD .and. X[2]==D3_CF})
			If _nPos == 0 .or. lFlat
				aAdd(a_Pi  ,{D3_COD,D3_CF,D3_UM,cDesc,cTipo,D3_CC,D3_QUANT,D3_CUSTO1,cGrupo,lFlat})
			Else
				a_Pi[_nPos][07] += D3_QUANT
				a_Pi[_nPos][08] += D3_CUSTO1
			EndIf
			nPi_op += D3_CUSTO1
		EndIf
		dbSkip()
		
	EndDo
	
EndDo
Return


Static Function RecalcPi(c_Pi)

dbSelectArea("SC2")
dbSetOrder(2)
dbSeek(xFilial("SC2")+c_Pi+dtos(mv_par03),.T.)
If C2_PRODUTO <> c_Pi
	dbSkip(-1)
EndIf
If C2_PRODUTO <> c_Pi
	Return
EndIf
nQtdCons := a_Pi[1][7]/C2_QUJE
c_OP     := C2_NUM+C2_ITEM+C2_SEQUEN

GetProd(.T.)
nCstCons := 0
For _i:=1 to Len(a_ConsMp)
	If a_ConsMp[_i][10]
		nCstCons += a_ConsMp[_i][08]
	EndIf
Next
For _i:=1 to Len(a_Pi)
	If a_Pi[_i][10]
		nCstCons += a_Pi[_i][08]
	EndIf
Next

nCstCons := a_Pi[1][8]/nCstCons

For _i:=1 to Len(a_ConsMp)
	If a_ConsMp[_i][10]
		a_ConsMp[_i][07] *= nQtdCons
		a_ConsMp[_i][08] *= nCstCons
		a_ConsMp[_i][10] := .F.
	EndIf
Next
For _i:=1 to Len(a_Pi)
	If a_Pi[_i][10]
		a_Pi[_i][07]   *= nQtdCons
		a_Pi[_i][08]   *= nCstCons
		a_Pi[_i][10]   := .F.
	EndIf
Next

Return
