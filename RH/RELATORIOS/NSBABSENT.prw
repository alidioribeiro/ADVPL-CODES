#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

	/*
	TABELAS UTILIZADAS
	-------------------
	CTT -> CENTRO DE CUSTOS
	SRA -> FUNCIONARIOS
	SPJ -> HORARIO PADRAO
	SPC -> APONTAMENTOS
	SP9 -> EVENTOS DO PONTO
	SR6 -> TURNO DE TRABALHO
	*/                                       

User Function NSBABSENT
Local oReport

Private cPerg := "NSBABSENT"
Private oTable as object


oReport := ReportDef()
oReport:PrintDialog()

if !Empty(oTable)
   oTable:Delete()
Endif

Return

***********************************************************************************************************************
Static Function ReportDef()
Local oReport
Local oSection1

Private cAlias as char

oReport := TReport():New("NSBABSENT","Relacao de Absenteísmo",cPerg,{|oReport| ReportPrint(oReport)},"Relacao de Absenteísmo")

oReport:SetLandScape(.T.)                                 
oReport:SetTotalInLine(.F.)		//Imprime o total em linha        

oreport:nfontbody	:=9
oreport:cfontbody	:="Calibri"
oreport:nlineheight	:=50

pergunte(cperg,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿                   
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, "Relatório de Movimentação de Materia-Prima")

TRCell():New(oSection1,"CC"	      ,,"CC"	    ,,9	,.F.,)
TRCell():New(oSection1,"DEPTO"	  ,,"DEPTO"		,,40,.F.,)
TRCell():New(oSection1,"MAT"  	  ,,"MAT"	    ,,06,.F.,)
TRCell():New(oSection1,"NOME"	  ,,"NOME"	    ,,40,.F.,)
TRCell():New(oSection1,"DATAINI"  ,,"DATAINI"   ,,10,.F.,)
TRCell():New(oSection1,"DATAFIM"  ,,"DATAFIM"   ,,10,.F.,)
TRCell():New(oSection1,"CODEV"	  ,,"CODEV"     ,,03,.F.,)
TRCell():New(oSection1,"EVENTO"	  ,,"EVENTO"    ,,60,.F.,)
TRCell():New(oSection1,"HORAS"	  ,,"HORAS"     ,,12,.F.,)
TRCell():New(oSection1,"CODABONO" ,,"CODABONO"	,,03,.F.,)
TRCell():New(oSection1,"ABONO"	  ,,"ABONO"     ,,30,.F.,)
TRCell():New(oSection1,"HRABONO"  ,,"HRABONO"   ,,12,.F.,)
TRCell():New(oSection1,"TURNO"	  ,,"TURNO"     ,,03,.F.,)
TRCell():New(oSection1,"DESCTURN" ,,"DESCTURN"  ,,40,.F.,)
TRCell():New(oSection1,"DIA"	  ,,"DIA"       ,,02,.F.,)
TRCell():New(oSection1,"MES"	  ,,"MES"       ,,02,.F.,)
TRCell():New(oSection1,"ANO"	  ,,"ANO"       ,,04,.F.,)
TRCell():New(oSection1,"SITUACAO" ,,"SITUACAO"  ,,01,.F.,)

oSection1:Cell("CC"		  		):SetHeaderAlign("CENTER")
oSection1:Cell("DEPTO"			):SetHeaderAlign("CENTER")
oSection1:Cell("MAT"			):SetHeaderAlign("CENTER")
oSection1:Cell("NOME"			):SetHeaderAlign("CENTER")
oSection1:Cell("DATAINI"		):SetHeaderAlign("CENTER")
oSection1:Cell("DATAFIM"		):SetHeaderAlign("CENTER")
oSection1:Cell("CODEV"			):SetHeaderAlign("CENTER")
oSection1:Cell("EVENTO"			):SetHeaderAlign("CENTER")
oSection1:Cell("HORAS"		    ):SetHeaderAlign("CENTER")
oSection1:Cell("CODABONO"		):SetHeaderAlign("CENTER")
oSection1:Cell("ABONO"			):SetHeaderAlign("CENTER")
oSection1:Cell("HRABONO"		):SetHeaderAlign("CENTER")
oSection1:Cell("TURNO"			):SetHeaderAlign("CENTER")
oSection1:Cell("DESCTURN"		):SetHeaderAlign("CENTER")
oSection1:Cell("DIA"			):SetHeaderAlign("CENTER")
oSection1:Cell("MES"			):SetHeaderAlign("CENTER")
oSection1:Cell("ANO"			):SetHeaderAlign("CENTER")
oSection1:Cell("SITUACAO"		):SetHeaderAlign("CENTER")

oSection1:SetLineBreak(.F.)		//Quebra de linha automatica

Return oReport                                                                       

***********************************************************************************************************************

Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local nOrdem 	   := oSection1:GetOrder()
Local aDados[18]
Local aCampos
Private TRX
Private cTitulo := ""

aCampos:={} 

AADD(aCampos, {"CC"         ,"C",09,0 })
AADD(aCampos, {"DEPTO  "    ,"C",40,0 })
AADD(aCampos, {"MAT"        ,"C",06,0 })
AADD(aCampos, {"NOME"       ,"C",40,0 })
AADD(aCampos, {"DATAINI"    ,"C",10,0 })
AADD(aCampos, {"DATAFIM"    ,"C",10,0 })
AADD(aCampos, {"CODEV"      ,"C",03,0 })
AADD(aCampos, {"EVENTO"     ,"C",60,0 })
AADD(aCampos, {"HORAS"      ,"N",12,2 })
AADD(aCampos, {"CODABONO"   ,"C",03,0 })
AADD(aCampos, {"ABONO"      ,"C",30,0 })
AADD(aCampos, {"HRABONO"    ,"N",12,2 })
AADD(aCampos, {"TURNO"      ,"C",03,0 })
AADD(aCampos, {"DESCTURN"   ,"C",40,0 }) 
AADD(aCampos, {"DIA"        ,"C",02,0 })
AADD(aCampos, {"MES"        ,"C",02,0 })
AADD(aCampos, {"ANO"        ,"C",04,0 })
AADD(aCampos, {"SITUACAO"   ,"C",01,0 })

oTable := FWTemporaryTable():New("TRX")
oTable:SetFields(aCampos)
oTable:AddIndex("01", {"CC"} )
oTable:Create()

//FAZ A CRIACAO DA TABELA TEMPORARIAR PARA TRABALHO TRX
PesqReg()

DbSelectArea(TRX)
TRX->(Dbgotop())

oSection1:Cell("CC"		  		):SetBlock( { || aDados[1 ]	})
oSection1:Cell("DEPTO"			):SetBlock( { || aDados[2 ]	})
oSection1:Cell("MAT"			):SetBlock( { || aDados[3 ]	})
oSection1:Cell("NOME"			):SetBlock( { || aDados[4 ]	})
oSection1:Cell("DATAINI"		):SetBlock( { || aDados[5 ]	})
oSection1:Cell("DATAFIM"		):SetBlock( { || aDados[6 ]	})
oSection1:Cell("CODEV"			):SetBlock( { || aDados[7 ]	})
oSection1:Cell("EVENTO"			):SetBlock( { || aDados[8 ]	})
oSection1:Cell("HORAS"		    ):SetBlock( { || aDados[9 ]	})
oSection1:Cell("CODABONO"		):SetBlock( { || aDados[10] })
oSection1:Cell("ABONO"			):SetBlock( { || aDados[11] })
oSection1:Cell("HRABONO"		):SetBlock( { || aDados[12] })
oSection1:Cell("TURNO"			):SetBlock( { || aDados[13] })
oSection1:Cell("DESCTURN"		):SetBlock( { || aDados[14] })
oSection1:Cell("DIA"			):SetBlock( { || aDados[15] })
oSection1:Cell("MES"			):SetBlock( { || aDados[16] })
oSection1:Cell("ANO"			):SetBlock( { || aDados[17] })
oSection1:Cell("SITUACAO"		):SetBlock( { || aDados[18] })

oReport:NoUserFilter()
oSection1:Init()
oReport:SetMeter(TRX->(RecCount()))

cTitulo := "Relacao de Absenteísmo"
oReport:SetTitle(cTitulo) 

While TRX->(!EOF())
   oReport:IncMeter()	

	aDados[1 ] := TRX->CC
	aDados[2 ] := TRX->DEPTO
	aDados[3 ] := TRX->MAT
	aDados[4 ] := TRX->NOME
	aDados[5 ] := TRX->DATAINI
	aDados[6 ] := TRX->DATAFIM
	aDados[7 ] := TRX->CODEV
	aDados[8 ] := TRX->EVENTO
	aDados[9 ] := TRX->HORAS
	aDados[10] := TRX->CODABONO
	aDados[11] := TRX->ABONO
	aDados[12] := TRX->HRABONO
	aDados[13] := TRX->TURNO
	aDados[14] := TRX->DESCTURN
	aDados[15] := TRX->DIA
	aDados[16] := TRX->MES
	aDados[17] := TRX->ANO
	aDados[18] := TRX->SITUACAO

	oSection1:PrintLine()

	TRX->(DbSelectArea(TRX))		
	TRX->(DbSkip())

EndDo

oSection1:Finish()  

TRX->(DbSelectArea(TRX))
TRX->(dbCloseArea())

Return

***********************************************************************************************************************
//Faz o processament e criacao da tabela para impressao
Static Function PesqReg()
Local cFiltro:="",cQuery:=""
Local DataI, cData, DataI, DatInv, Ender, FiltroBc,i

	datai:=dtos(mv_par07)
	dataf:=dtos(mv_par08)

	cQuery := " SELECT CTT.CTT_CUSTO AS CC,CTT.CTT_DESC01 AS DEPTO, "
	cQuery += " SRA.RA_MAT AS MAT,SRA.RA_NOME AS NOME, "
	cQuery += " DATEPART(DAY,SPC.PC_DATA) AS DIA,DATEPART(MONTH,SPC.PC_DATA) AS MES, DATEPART(YEAR,SPC.PC_DATA) AS ANO, "
	cQuery +="  RIGHT(SPC.PC_DATA,2)+'/'+SUBSTRING(SPC.PC_DATA,5,2)+'/'+LEFT(SPC.PC_DATA,4) AS DATAINI, "
	cQuery +=" '        '   AS DATAFIM, "
	cQuery += " SPC.PC_PD AS CODEV, SP9.P9_DESC AS EVENTO,SPC.PC_QUANTC AS HORAS, SPC.PC_QTABONO AS HRABONO,"
	cQuery += " SPC.PC_ABONO AS CODABONO, ISNULL(SP6.P6_DESC,'') AS ABONO , "
	cQuery += " SR6.R6_TURNO AS TURNO,SR6.R6_DESC AS DESCTURN, SRA.RA_SITFOLH AS SITUACAO "
	cQuery += " FROM " + RetSqlName("SPC") + " SPC "
	cQuery += " LEFT JOIN (SELECT P6_CODIGO,P6_DESC FROM " + RetSqlName("SP6") + " WHERE D_E_L_E_T_ <>'*') SP6 ON SPC.PC_ABONO  = SP6.P6_CODIGO "
	cQuery += "              LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT.CTT_CUSTO = SPC.PC_CC "
	cQuery += "              LEFT JOIN " + RetSqlName("SR6") + " SR6 ON SR6.R6_TURNO = SPC.PC_TURNO "                       
	cQuery += "              LEFT JOIN (SELECT * FROM " + RetSqlName("SP9") + " WHERE D_E_L_E_T_<>'*' )  SP9 ON SP9.P9_CODIGO = SPC.PC_PD "
	cQuery += "              LEFT JOIN " + RetSqlName("SRA") + " SRA ON SRA.RA_MAT = SPC.PC_MAT AND SRA.RA_FILIAL = SPC.PC_FILIAL "
	cQuery += "  WHERE "
	cQuery += " CTT.D_E_L_E_T_<>'*' AND " 
	//cQuery += " SRA.RA_SITFOLH<>'D' AND "
	cQuery += " SPC.D_E_L_E_T_<>'*' AND
	cQuery += " SP9.D_E_L_E_T_<>'*' AND
	cQuery += " SR6.D_E_L_E_T_<>'*' AND
	cQuery += " SRA.D_E_L_E_T_<>'*' AND SRA.RA_FILIAL='01' AND
	cQuery += " SPC.PC_PD IN ('414','470','413','472') AND 
	CQuery += " 		SPC.PC_DATA>='"+datai+"' AND SPC.PC_DATA<='"+dataf+"' AND  "
	CQuery += " 		SRA.RA_FILIAL >= '"+mv_par01+"' AND SRA.RA_FILIAL<= '"+mv_par02+"' AND  "
	CQuery += " 		SRA.RA_MAT >= '"+mv_par05+"' AND SRA.RA_MAT<= '"+mv_par06+"' AND  "
	CQuery += " 		SRA.RA_CC  >= '"+mv_par03+"' AND SRA.RA_CC<= '"+mv_par04+"' "
	cQuery += " UNION ALL "
	cQuery += " SELECT CTT.CTT_CUSTO AS CC,CTT.CTT_DESC01 AS DEPTO, "
	cQuery += " SRA.RA_MAT AS MAT,SRA.RA_NOME AS NOME, "
	cQuery += " DATEPART(DAY,SPC.PH_DATA) AS DIA,DATEPART(MONTH,SPC.PH_DATA) AS MES,DATEPART(YEAR,SPC.PH_DATA) AS ANO, "
	cQuery += " RIGHT(SPC.PH_DATA,2)+'/'+SUBSTRING(SPC.PH_DATA,5,2)+'/'+LEFT(SPC.PH_DATA,4)  AS DATAINI ," 
	cQuery += " '        '   AS DATAFIM ," 
	cQuery += " SPC.PH_PD AS CODEV, SP9.P9_DESC AS EVENTO,SPC.PH_QUANTC AS HORAS, SPC.PH_QTABONO AS HRABONO,"
	cQuery += " SPC.PH_ABONO AS CODABONO, ISNULL(SP6.P6_DESC,'') AS ABONO , "
	cQuery += " SR6.R6_TURNO AS TURNO,SR6.R6_DESC AS DESCTURN, SRA.RA_SITFOLH AS SITUACAO "
	cQuery += " FROM " + RetSqlName("SPH") + " SPC "
	cQuery += " LEFT JOIN (SELECT P6_CODIGO,P6_DESC FROM " + RetSqlName("SP6") + " WHERE D_E_L_E_T_ <>'*') SP6 ON SPC.PH_ABONO  = SP6.P6_CODIGO   "
	cQuery += "              LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT.CTT_CUSTO = SPC.PH_CC "
	cQuery += "                         LEFT JOIN " + RetSqlName("SR6")+ " SR6 ON SR6.R6_TURNO = SPC.PH_TURNO "                       
	cQuery += "                         LEFT JOIN (SELECT * FROM " + RetSqlName("SP9")+ " WHERE D_E_L_E_T_<>'*' )  SP9 ON SP9.P9_CODIGO = SPC.PH_PD "
	cQuery += "                         LEFT JOIN " + RetSqlName("SRA") + " SRA ON SRA.RA_MAT = SPC.PH_MAT AND SRA.RA_FILIAL = SPC.PH_FILIAL "
	cQuery += "  WHERE "
	cQuery += " CTT.D_E_L_E_T_<>'*' AND " 
	//cQuery += " SRA.RA_SITFOLH<>'D' AND "
	cQuery += " SPC.D_E_L_E_T_<>'*' AND
	cQuery += " SP9.D_E_L_E_T_<>'*' AND
	cQuery += " SR6.D_E_L_E_T_<>'*' AND
	cQuery += " SRA.D_E_L_E_T_<>'*' AND SRA.RA_FILIAL='01' AND
	cQuery += " SPC.PH_PD IN ('414','470','413','472') AND 
	CQuery += " 		SPC.PH_DATA>= '"+datai+"' AND SPC.PH_DATA<='"+dataf+"' AND  "
	CQuery += " 		SRA.RA_FILIAL >= '"+mv_par01+"'AND SRA.RA_FILIAL<= '"+mv_par02+"' AND  "
	CQuery += " 		SRA.RA_MAT >= '"+mv_par05+"' AND SRA.RA_MAT<= '"+mv_par06+"' AND  "
	CQuery += " 		SRA.RA_CC  >= '"+mv_par03+"' AND SRA.RA_CC<= '"+mv_par04+"' "
	cQuery += " UNION ALL "
	cQuery += " SELECT "
	cQuery += " 		CTT.CTT_CUSTO AS CC,"
	cQuery += " 		CTT.CTT_DESC01 AS DEPTO, "
	cQuery += " 		SRA.RA_MAT AS MAT,"
	cQuery += " 		SRA.RA_NOME AS NOME, "
	cQuery += " 		DATEPART( DAY, SPC.R8_DATAINI) AS DIA,DATEPART( MONTH, SPC.R8_DATAINI) AS MES, DATEPART( YEAR, SPC.R8_DATAINI) AS ANO, 		"
	cQuery += " 		RIGHT(SPC.R8_DATAINI,2)+'/'+SUBSTRING(SPC.R8_DATAINI,5,2)+'/'+LEFT(SPC.R8_DATAINI,4) AS DATAINI, 		"
	cQuery += " 		RIGHT(SPC.R8_DATAFIM,2)+'/'+SUBSTRING(SPC.R8_DATAFIM,5,2)+'/'+LEFT(SPC.R8_DATAFIM,4) AS DATAFIM, 		"
	cQuery += " 		SPC.R8_TIPO AS CODEV, "
	cQuery += "         EVENTO = CASE WHEN R8_TIPO='F'    THEN 'FERIAS' "
	cQuery += "                       WHEN R8_AFARAIS<>'' THEN 'RAIS('+R8_AFARAIS+') - '+SX5.X5_DESCRI "
	cQuery += " 				 END, "
	//cQuery += " 		'RAIS('+SPC.R8_AFARAIS+') - '+SX5.X5_DESCRI  AS EVENTO,"
	cQuery += " 		0  AS HORAS, "
	cQuery += " 		0 AS HRABONO,"
	cQuery += " 		'' AS CODABONO, "
	cQuery += " 		'' AS ABONO , "
	cQuery += " 		SR6.R6_TURNO AS TURNO,"
	cQuery += " 		SR6.R6_DESC AS DESCTURN, SRA.RA_SITFOLH AS SITUACAO "
	cQuery += "   FROM " + RetSqlName("SR8") + " SPC "
	cQuery += "         LEFT JOIN " + RetSqlName("SRA") + " SRA ON SRA.RA_MAT = SPC.R8_MAT AND SRA.RA_FILIAL = SPC.R8_FILIAL "
	cQuery += "         LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT.CTT_CUSTO = SRA.RA_CC "
	cQuery += "         LEFT JOIN " + RetSqlName("SR6") + " SR6 ON SR6.R6_TURNO = SRA.RA_TNOTRAB     "
	cQuery += "         LEFT JOIN " + RetSqlName("SX5") + " SX5 ON X5_CHAVE = SPC.R8_TIPO AND SX5.X5_TABELA='30' AND SX5.D_E_L_E_T_<>'*'"
	cQuery += "    WHERE "
	cQuery += "         CTT.D_E_L_E_T_<>'*' AND "
	//cQuery += "         SRA.RA_SITFOLH<>'D' AND "
	cQuery += "         SPC.D_E_L_E_T_<>'*' AND "
	CQuery += "         SPC.R8_DATAINI>= '"+datai+"' AND SPC.R8_DATAFIM<= '"+dataf+"' AND  "
	CQuery += "         SRA.RA_MAT >= '"+mv_par05+"' AND SRA.RA_MAT<= '"+mv_par06+"'  AND  "
	CQuery += "         SRA.RA_CC  >= '"+mv_par03+"' AND SRA.RA_CC<= '"+mv_par04+"' "
	cQuery += "   ORDER BY CC,MAT,ANO,MES,DIA"

	TCQUERY cQuery New Alias "TMOV"  

	DbSElectArea("TMOV")                                                      
	DbGotop()      
	While !TMOV->(Eof())      

		DbselectArea("TMOV")

		RecLock("TRX",.T.)

		TRX->CC        	:= TMOV->CC
		TRX->DEPTO 	   	:= TMOV->DEPTO 	   	
		TRX->MAT    	:= TMOV->MAT
		TRX->NOME      	:= TMOV->NOME               
		TRX->DATAINI    := TMOV->DATAINI
		TRX->DATAFIM    := TMOV->DATAFIM	
		TRX->DIA        := STR(TMOV->DIA,2)
		TRX->MES        := STR(TMOV->MES,2)
		TRX->ANO        := STR(TMOV->ANO,4)
		TRX->CODEV     	:= TMOV->CODEV
		TRX->EVENTO    	:= TMOV->EVENTO
		TRX->HORAS     	:= TMOV->HORAS
		TRX->HRABONO   	:= TMOV->HRABONO	
		TRX->CODABONO	:= TMOV->CODABONO
		TRX->ABONO		:= TMOV->ABONO
		TRX->TURNO		:= TMOV->TURNO
		TRX->DESCTURN	:= TMOV->DESCTURN
		TRX->SITUACAO   := TMOV->SITUACAO

		Msunlock()                                                               

		DbselectArea("TMOV")
		DbsKip()    

	Enddo

	DbSelectArea("TMOV")
	DbcloseArea("TMOV")

Return
