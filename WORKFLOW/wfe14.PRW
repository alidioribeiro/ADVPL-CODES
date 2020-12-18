#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณWFE14     บAutor  ณJefferson Moreira   บ Data ณ  29/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ INFORMA OS PRODUTOS QUE O ESTOQUE ATUAL ESTA MENOR QUE     บฑฑ
ฑฑบ          ณ O ESTOQUE DE SEGUNRACA.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PROTHEUS 8.11                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็ใo ณ 05/12/16 ณ Wagner Corr๊a ณ Ajuste Multi Empresa            บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WFE14()

Private AEnvia:={}
Private EstPa:={}

Prepare Environment Empresa "01" Filial "01" //Tables "SB1"  // Usado apenas quando o uso for por agendamento

cQuery := " SELECT "
cQuery +=    " B1_COD,B1_DESC,B1_UM,B1_TIPO,B1_GRUPO,B2_LOCAL,B1_MODELO,B1_ESTSEG,B2_QATU,C7_NUM,C7_DATPRF,C7_QUANT-C7_QUJE AS SALDO, "
cQuery +=    " ( SELECT B2_QEMP "
cQuery +=         "FROM " + RetSqlName("SB2") + " SB2 "
cQuery +=      "WHERE B1_COD = B2_COD AND B2_LOCAL = '10' AND SB2.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '') AS B2_QEMP "
cQuery += " FROM " + RetSqlName("SB1") + " SB1 "
cQuery += " LEFT JOIN " + RetSqlName("SC7") + " SC7 ON B1_COD = C7_PRODUTO AND C7_ENCER <> 'E' AND C7_RESIDUO <> 'S' AND SC7.D_E_L_E_T_ = '' "
cQuery += " INNER JOIN " + RetSqlName("SB2") + " SB2 ON B1_COD = B2_COD AND B2_LOCAL IN('01','02')"
cQuery += " WHERE B1_TIPO = 'MP' "
cQuery +=       " AND  (B2_QATU+B2_QEMP) <= B1_ESTSEG "
cQuery +=       " AND B1_MSBLQL <> '1' "
cQuery +=       " AND B1_ESTSEG > 0 "
cQuery +=       " AND SB1.D_E_L_E_T_ = '' "
cQuery +=       " AND SB2.D_E_L_E_T_ = '' "
cQuery +=  " ORDER BY B1_COD,C7_DATPRF "

//cQuery := ChangeQuery(cQuery)

TCQUERY cQuery Alias TB1 New

dbSelectArea("TB1")
dbGotop()
While !TB1->(Eof())
	
	If !Empty(C7_DATPRF)
		xData  := Subs(C7_DATPRF,7,2) + "/" + Subs(C7_DATPRF,5,2)+ "/" + Subs(C7_DATPRF,3,2)
		xSaldo := Saldo
	Else
		xData  := ''
		xSaldo := 0
	Endif
	DISP := B2_QATU-B2_QEMP
	aAdd(aEnvia,{B1_COD,;	//[01] Codigo do produto
	B1_DESC,;				//[02] Descricao4 do produto
	B1_UM,;  				//[03] Unidade de Medida
	B1_TIPO,;				//[04] Tipo do Produto
	B1_GRUPO,;				//[05] Grupo do Produto
	B2_LOCAL,;				//[06]
	B1_MODELO,;				//[07] Modelo Usado
	B2_QATU,;				//[08] Quantidade Atual
	B2_QEMP,;				//[09] Quantidade Empenhada
	DISP,;					//[10] Quantidade Disponivel
	B1_ESTSEG,;				//[11] Quantidade Est Seguranca
	C7_NUM,;				//[12] Numero do pedido
	xData,;					//[13] Previsao de chegada
	xSaldo,;				//[14] Saldo do pedido
	0,;						//[15] Consumo M้dia
	0 })					//[16] Dia de Cobertura
	
	TB1->(DbSkip())
End

// --------------------------------------------------
// Verifica as qtd utilzadas no MRP saldos para o MRP
// --------------------------------------------------
aEnvia :=U_MConsumo()
aEnvia :=VerEstSeg()

dbSelectArea("TB1")
dbCloseArea()

U_WFE14Envia(aEnvia)

Return
//
//
//
Static Function VerEstSeg()
Local i 

Local ADados:={},ADadosT:={}, VTotSalPComp:={}

cProd:=""
TotCPed:=0
i:=1

While i <= Len(aEnvia)
	
	Pos:=AScan(VTotSalPComp, {|x| x[1]=aEnvia[i][1]})
	
	If pos=0
		If Ctod(aEnvia[i][13]) < dDatabase + Int(aEnvia[i][16])
			
			aAdd( vTotSalPComp,{aEnvia[i][01],;	// 1 -Produto
			aEnvia[i][10],;						// 2 -Saldo Atual- Estoque Disponivel
			aEnvia[i][11],;						// 3 -Estoque de Seguran็a
			Ddatabase+Int(aEnvia[i][16]),;		// 4-Dias de cobertura + data base
			0})									// 5- Saldo do Pedidio
		Else
			i++
			Loop
		EndIf
		Pos:=Len(VTotSalPComp)
	EndIF

	If Pos#0 .and. Ctod(aEnvia[i][13])<VTotSalPComp[Pos][4] .and. aEnvia[i][14] #0
		VTotSalPComp[Pos][5]+= aEnvia[i][14]
	EndIf
	i++
End

For i:=1 to len(aEnvia)
	
	Pos := aScan(VTotSalPComp, {|x| x[1]=aEnvia[i][1] .and. x[3]>x[5]+x[2]})

	If Pos#0 .or. aEnvia[i][16]<0
		aAdd(aDados,aEnvia[i])
		aDados[Len(aDados)][08] := Transform( aDados[Len(aDados)][08],"@E 99,999,999.99 ")
		aDados[Len(aDados)][09] := Transform( aDados[Len(aDados)][09],"@E 99,999,999.99 ")
		aDados[Len(aDados)][10] := Transform( aDados[Len(aDados)][10],"@E 99,999,999.99 ")
		aDados[Len(aDados)][11] := Transform( aDados[Len(aDados)][11],"@E 99,999,999.99 ")
		aDados[Len(aDados)][14] := Transform( aDados[Len(aDados)][14],"@E 99,999,999.99 ")
		aDados[Len(aDados)][15] := Transform( aDados[Len(aDados)][15],"@E 99,999,999.99 ")
		aDados[Len(aDados)][16] := Transform( aDados[Len(aDados)][16],"@E 99,999,999.99 ")
		
	EndIf
	
Next

Return aDados
//
//
//

User Function MConsumo()

Local CQuery:=""
Local i 

//
// Verica os PAS a serem produzidos pelo plano mestre
//

DataA  := ddataBase
DataDe := ddatabase-30
CFiltro:=" "

For i:=1 to Len(aEnvia)
	cFiltro  = "'" + aEnvia[i][1] + "',"
Next
cFiltro := " WHERE  D3_COD IN('+Substr(CFiltro,1,Len(CFiltro)-1)+') AND D3_LOCAL='10' "
cFiltro += " AND D3_CF IN('RE2','RE4','RE5') and D3_EMISSAO BETWEEN '" + Dtos(DataDe) + "' AND '" + Dtos(DataA) + "'"
cFiltro += " AND D3_GRUPO <> 'GGF' " //Nao pega o rateio das despesas
cFiltro += " AND D3_ESTORNO<>'S' AND D_E_L_E_T_=''  "
cFiltro += " GROUP BY D3_COD "
//
cQuery += " SELECT D3_COD,SUM(D3_QUANT) TOT FROM " +RetSqlName("SD3") + " " + cFiltro
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TB3 New
//
dbSelectArea("TB3")
dbGoTop()

While !Eof()
	//
	PProd:=Ascan(aEnvia,{|x|x[1]=Alltrim(TB3->D3_COD)})
	ConsMed:=TB3->TOT/30
	//    QtdD:=StrTran(aEnvia[PPRod][10],'.','') Alt pela Aglair
	QtdD:=aEnvia[PPRod][10]
	DiasCob:=QtdD/ConsMed
	For i:=1 to len (aEnvia)
		If Alltrim(aEnvia[i][1])==AlLtrim(TB3->D3_COD)
			aEnvia[i][15]:=ConsMed
			aEnvia[i][16]:=DiasCob
		EndIf
	Next
	dbSkip()
End

dbSelectArea("TB3")
dbCloseArea()

Return aEnvia

//
//
//
User Function WFE14Envia()
Local cMen
Local x 

If Len(aEnvia) > 0
	
	oProcess := TWFProcess():New( "000001", "Estoque de Seguranca" )
	oProcess :NewTask( "100001", "\WORKFLOW\ESTSEGV2.HTM" )
	oProcess :cSubject := "WFE14 - Estoque de Seguran็a Alcan็ado"
	oHTML    := oProcess:oHTML
	
	Prod:=""
	
	oHtml:ValByName("it.cod",      {})
	oHtml:ValByName("it.desc",     {})
	oHtml:ValByName("it.un",       {})
	oHtml:ValByName("it.tipo",     {})
	oHtml:ValByName("it.grupo",    {})
	OHtml:ValByName("it.local",    {})
	oHtml:ValByName("it.modelo",   {})
	oHtml:ValByName("it.estatu",   {})
	oHtml:ValByName("it.estemp",   {})
	oHtml:ValByName("it.estdis",   {})
	oHtml:ValByName("it.estseg",   {})
	oHtml:ValByName("it.nrped",    {})
	oHtml:ValByName("it.datap",    {})
	oHtml:ValByName("it.saldoped", {})
	oHtml:ValByName("it.consmed",  {})
	oHtml:ValByName("it.diascob",  {})
	CColor:=""
	
	For x:= 1 to Len(aEnvia)
		
		If Alltrim(Prod)=Alltrim(aEnvia[x][1])
			aadd(oHtml:ValByName("it.cod"),     "")
			aadd(oHtml:ValByName("it.desc"),    "")
			aadd(oHtml:ValByName("it.un"),      "")
			aadd(oHtml:ValByName("it.tipo"),    "")
			aadd(oHtml:ValByName("it.grupo"),   "")
			aadd(oHtml:ValByName("it.local"),   "")
			aadd(oHtml:ValByName("it.modelo"),  "")
			aadd(oHtml:ValByName("it.estatu"),  "")
			aadd(oHtml:ValByName("it.estemp"),  "")
			aadd(oHtml:ValByName("it.estdis"),  "")
			aadd(oHtml:ValByName("it.estseg"),  "")
			aadd(oHtml:ValByName("it.consmed"), "")
			aadd(oHtml:ValByName("it.diascob"), "")
		Else
			Prod:=aEnvia[x][1]
			aadd(oHtml:ValByName("it.cod"),     aEnvia[x][01])
			aadd(oHtml:ValByName("it.desc"),    aEnvia[x][02])
			aadd(oHtml:ValByName("it.un"),      aEnvia[x][03])
			aadd(oHtml:ValByName("it.tipo"),    aEnvia[x][04])
			aadd(oHtml:ValByName("it.grupo"),   aEnvia[x][05])
			aadd(oHtml:ValByName("it.local"),   aEnvia[x][06])
			aadd(oHtml:ValByName("it.modelo"),  aEnvia[x][07])
			aadd(oHtml:ValByName("it.estatu"),  aEnvia[x][08])
			aadd(oHtml:ValByName("it.estemp"),  aEnvia[x][09])
			aadd(oHtml:ValByName("it.estdis"),  aEnvia[x][10])
			aadd(oHtml:ValByName("it.estseg"),  aEnvia[x][11])
			aadd(oHtml:ValByName("it.consmed"), aEnvia[x][15])
			aadd(oHtml:ValByName("it.diascob"), aEnvia[x][16])
		EndIf
		aadd(oHtml:ValByName("it.nrped"), aEnvia[x][12])
		aadd(oHtml:ValByName("it.datap"), aEnvia[x][13])
		aadd(oHtml:ValByName("it.saldoped"), aEnvia[x][14])
	Next
	
	CodRot:="WFE14"
	cUser := Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	Mto:= u_MontaRec(CodRot)
	oProcess:cTo  :=Mto
	
	cMailId := oProcess:Start()
	
EndIf

Return
