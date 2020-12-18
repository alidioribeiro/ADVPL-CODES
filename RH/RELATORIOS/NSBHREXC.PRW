#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO5     บ Autor ณ AP6 IDE            บ Data ณ  02/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE HORAS EXCEDIDAS                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function NSBHREXC
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80
     
      
Local Cabec1       := "Relat๓rio de Hora Extra Excedida"
Local Cabec2       := "Produto           Descri็ใo                                            Fechamento     Transferido            Perdas           Consumo " 
Local imprime      := .T.
Local aOrd := {}                                                                                    
Local  titulo    := "Relat๓rio de Horas Extras Excedidas"
Local ctitulo    := "Relat๓rio de Horas Extras Excedidas"

Private Programa:="NSBHREXC"
Private cDesc1    := "Este programa tem com objetivo, imprimir a relacao de horas extras "
Private cDesc2    := "excedidas."                                     
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private  tamanho   := "M"
Private limite    := 220
Private nomeprog:="NSBHREXC"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "NSBHREXC" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString:=""                                                   
Private cPerg     := "NSBHREXC"
Private aLinha    := {}

/*
pergunte(cperg,.F.)
PERGUNTA				PARAMETRO
Filial De ?				MV_CH1
Filial Ate ?			MV_CH2
Centro de Custo De ?	MV_CH3
Centro de Custo Ate ?	MV_CH4
Matricula De ?			MV_CH5
Matricula Ate ?			MV_CH6
Data Inicial ?			MV_CH7
Data Final ?			MV_CH8
*/ 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

PERGUNTE(CPERG, .t.)
/*
	wnrel := SetPrint(cString,NomeProg,cperg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
*/                                                

RunReport(Cabec1,Cabec2,Titulo,nLin)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  02/07/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local CQuery:=""                                                         
LOCAL cDirDocs  := MsDocPath() //Path para arquivo TMPorario. Se nao existir,
Local cPath	    := AllTrim(GetTempPath()) 
Local oExcelApp
Local cFiltro:="",cQuery:=""

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rela็ใo de Horas Extras Excedidas"
Local cPict          := ""
Local titulo       := "Relacao de Horas Extras Excedidas"
Local nLin         := 80  

//datai:=right(dtoc(mv_par07),4)+substr(dtoc(mv_par07),4,2)+left(dtoc(mv_par07),2)
//dataf:=right(dtoc(mv_par08),4)+substr(dtoc(mv_par08),4,2)+left(dtoc(mv_par08),2)

datai:=dtos(mv_par07)
dataf:=dtos(mv_par08)

CQuery:= " SELECT CTT.CTT_CUSTO AS CC,CTT.CTT_DESC01 AS DEPTO, "
CQuery+= " SRA.RA_MAT AS MAT, SRA.RA_NOME AS NOME,"
CQuery+= " TIPODIA =CASE WHEN SPJ.PJ_TPDIA ='S' THEN 'TRABALHADO' "
CQuery+= "               WHEN SPJ.PJ_TPDIA ='N' THEN 'NAO TRABALH'"
CQuery+= "               WHEN SPJ.PJ_TPDIA ='C' THEN 'COMPENSADO' "
CQuery+= "               WHEN SPJ.PJ_TPDIA ='D' THEN 'DSR'        "                                                                                                  
CQuery+= "          END, "
CQuery+= " SPJ.PJ_TPDIA AS TPDIA, "
CQuery+= " SPC.PC_DATA AS DATAREF,"
CQuery+= " SPC.PC_PD AS CODEV,SP9.P9_DESC AS EVENTO,"
CQuery+= " HTRAB =CASE WHEN SPC.PC_QUANTI>0  THEN SPC.PC_QUANTI "
CQuery+= "               ELSE SPC.PC_QUANTC "
CQuery+= "          END, "
CQuery+= " SPJ.PJ_HRTOTAL AS HJORN, "
CQuery+= " SPC.PC_ABONO AS CODABONO ,ISNULL(SP6.P6_DESC,'') AS ABONO , SR6.R6_TURNO AS TURNO,SR6.R6_DESC AS DESCTURN, "
CQuery+= " SPJ.PJ_DIA , DATEPART(DW,SPC.PC_DATA) "
CQuery+= " FROM SPC010 SPC "
CQuery+= "      LEFT JOIN (SELECT P6_CODIGO,P6_DESC FROM SP6010 WHERE D_E_L_E_T_ <>'*') SP6 ON SPC.PC_ABONO  = SP6.P6_CODIGO   "
CQuery+= "      LEFT JOIN (SELECT * FROM CTT010 WHERE D_E_L_E_T_ <>'*' ) CTT ON CTT.CTT_CUSTO = SPC.PC_CC "
CQuery+= "      LEFT JOIN (SELECT * FROM SR6010 WHERE D_E_L_E_T_ <>'*' ) SR6 ON SR6.R6_TURNO = SPC.PC_TURNO "
CQuery+= "      LEFT JOIN (SELECT * FROM SP9010 WHERE D_E_L_E_T_ <>'*' ) SP9 ON SP9.P9_CODIGO = SPC.PC_PD "
CQuery+= "      INNER JOIN SRA010 SRA ON SRA.RA_MAT = SPC.PC_MAT AND SRA.RA_FILIAL = SPC.PC_FILIAL "
CQuery+= "      LEFT JOIN (SELECT * FROM SRV010 WHERE D_E_L_E_T_ <>'*' ) SRV ON SRV.RV_COD = SP9.P9_CODFOL "
CQuery+= "      LEFT JOIN (SELECT * FROM SPJ010 WHERE D_E_L_E_T_ <>'*' ) SPJ ON SPJ.PJ_TURNO = SPC.PC_TURNO AND SPJ.PJ_SEMANA = SPC.PC_SEMANA   AND SPJ.PJ_DIA = DATEPART(DW,SPC.PC_DATA) "
CQuery+= " WHERE "
CQuery+= " 		SRA.RA_SITFOLH<>'D' AND "
CQuery+= " 		SPC.D_E_L_E_T_<>'*' AND "
CQuery+= " 		SRA.D_E_L_E_T_<>'*' AND "
CQuery+= " 		SPC.PC_DATA BETWEEN '"+ datai +"' AND '"+dataf+"' AND  "
CQuery+= " 		SRA.RA_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' AND  "
CQuery+= " 		SRA.RA_MAT BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' AND  "
CQuery+= " 		SRA.RA_CC  BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' AND  "
CQuery+= " 		SRV.RV_HE='S' "
CQuery+= " UNION ALL  "
CQuery+= " SELECT CTT.CTT_CUSTO AS CC,CTT.CTT_DESC01 AS DEPTO, "
CQuery+= " SRA.RA_MAT AS MAT, SRA.RA_NOME AS NOME,"
CQuery+= " TIPODIA =CASE WHEN SPJ.PJ_TPDIA ='S' THEN 'TRABALHADO' "
CQuery+= "               WHEN SPJ.PJ_TPDIA ='N' THEN 'NAO TRABALH'"
CQuery+= "               WHEN SPJ.PJ_TPDIA ='C' THEN 'COMPENSADO' "
CQuery+= "               WHEN SPJ.PJ_TPDIA ='D' THEN 'DSR'        "                                                                                                  
CQuery+= "          END, "
CQuery+= " SPJ.PJ_TPDIA AS TPDIA, "
CQuery+= " SPC.PH_DATA AS DATAREF,"
CQuery+= " SPC.PH_PD AS CODEV,SP9.P9_DESC AS EVENTO,"
CQuery+= " HTRAB =CASE WHEN SPC.PH_QUANTI>0  THEN SPC.PH_QUANTI "
CQuery+= "               ELSE SPC.PH_QUANTC "
CQuery+= "          END, "	
CQuery+= " SPJ.PJ_HRTOTAL AS HJORN, "
CQuery+= " SPC.PH_ABONO AS CODABONO ,ISNULL(SP6.P6_DESC,'') AS ABONO , SR6.R6_TURNO AS TURNO,SR6.R6_DESC AS DESCTURN, "
CQuery+= " SPJ.PJ_DIA , DATEPART(DW,SPC.PH_DATA) "
CQuery+= " FROM SPH010 SPC "
CQuery+= "      LEFT JOIN (SELECT P6_CODIGO,P6_DESC FROM SP6010 WHERE D_E_L_E_T_ <>'*') SP6 ON SPC.PH_ABONO  = SP6.P6_CODIGO   "
CQuery+= "      LEFT JOIN (SELECT * FROM CTT010 WHERE D_E_L_E_T_ <>'*') CTT ON CTT.CTT_CUSTO = SPC.PH_CC "
CQuery+= "      LEFT JOIN (SELECT * FROM SR6010 WHERE D_E_L_E_T_ <>'*') SR6 ON SR6.R6_TURNO = SPC.PH_TURNO "
CQuery+= "      LEFT JOIN (SELECT * FROM SP9010 WHERE D_E_L_E_T_ <>'*') SP9 ON SP9.P9_CODIGO = SPC.PH_PD "
CQuery+= "      INNER JOIN SRA010 SRA ON SRA.RA_MAT = SPC.PH_MAT AND SRA.RA_FILIAL = SPC.PH_FILIAL "
CQuery+= "      LEFT JOIN (SELECT * FROM SRV010 WHERE D_E_L_E_T_ <>'*') SRV ON SRV.RV_COD = SP9.P9_CODFOL "
CQuery+= "      LEFT JOIN (SELECT * FROM SPJ010 WHERE D_E_L_E_T_ <>'*') SPJ ON SPJ.PJ_TURNO = SPC.PH_TURNO AND SPJ.PJ_SEMANA = SPC.PH_SEMANA   AND SPJ.PJ_DIA = DATEPART(DW,SPC.PH_DATA) "
CQuery+= " WHERE "
CQuery+= " 		SRA.RA_SITFOLH<>'D' AND "
CQuery+= " 		SRA.D_E_L_E_T_<>'*' AND "
CQuery+= " 		SPC.PH_DATA BETWEEN '"+ datai +"' AND '"+dataf+"' AND  "
CQuery+= " 		SRA.RA_FILIAL BETWEEN '"+ mv_par01 +"' AND '"+ mv_par02 +"' AND  "
CQuery+= " 		SRA.RA_MAT BETWEEN '"+ mv_par05 +"' AND '"+ mv_par06 +"' AND  "
CQuery+= " 		SRA.RA_CC  BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' AND  "
CQuery+= " 		SRV.RV_HE='S' "
CQuery+= " 		ORDER BY CC,MAT "

TCQUERY cQuery New Alias "TMOV"  
  		
 
aCampos:={} 

AADD(aCampos, {"CC"         ,"C",09,0 })
AADD(aCampos, {"DEPTO  "    ,"C",40,0 })
AADD(aCampos, {"MAT"        ,"C",06,0 })
AADD(aCampos, {"NOME"       ,"C",40,0 })
AADD(aCampos, {"TIPODIA"    ,"C",20,0 })
//AADD(aCampos, {"TPDIA"      ,"C",01,0 })
AADD(aCampos, {"DATAREF"    ,"D",08,0 })
//AADD(aCampos, {"CODEV"      ,"C",03,0 })
AADD(aCampos, {"EVENTO"     ,"C",30,0 })
AADD(aCampos, {"HE_REALIZ"  ,"N",12,2 })
AADD(aCampos, {"CARGA_HDIA","N",12,2 })
AADD(aCampos, {"HE_EXCED"   ,"N",12,2 })
//AADD(aCampos, {"CODABONO"   ,"C",03,0 })
//AADD(aCampos, {"ABONO"      ,"C",30,0 })
AADD(aCampos, {"TURNO"      ,"C",03,0 })
AADD(aCampos, {"DESCTURN"   ,"C",40,0 })

cArq := Criatrab( ,.F.)
dbCreate(cDirDocs+"\"+cArq,aCampos)             //Cria o arquivo no caminho especificado
dbUseArea(.T.,,cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.

 
DbSElectArea("TMOV")                                                      
DbGotop()      
While !TMOV->(Eof())      
                 
	DbselectArea("TMOV")
	RecLock("TRX",.T.)
	TRX->CC        	:= TMOV->CC
	TRX->DEPTO 	   	:= TMOV->DEPTO 	   	
	TRX->MAT    	:= TMOV->MAT
	TRX->NOME      	:= TMOV->NOME               
	TRX->TIPODIA   	:= TMOV->TIPODIA 
//	TRX->TPDIA     	:= TMOV->TPDIA   
	TRX->DATAREF    := CTOD(SUBSTRING(TMOV->DATAREF,7,2)+'/'+SUBSTRING(TMOV->DATAREF,5,2)+'/'+SUBSTRING(TMOV->DATAREF,1,4))
//	TRX->CODEV     	:= TMOV->CODEV
	TRX->EVENTO    	:= TMOV->EVENTO

	TRX->HE_REALIZ	:= TMOV->HTRAB
	TRX->CARGA_HDIA:= TMOV->HJORN   
	IF TMOV->TPDIA="S" .AND. (TRX->HE_REALIZ-2)>0 
   	   TRX->HE_EXCED := TRX->HE_REALIZ-2 //TRX->CARGA_HDIA
    ENDIF	
//	TRX->CODABONO	:= TMOV->CODABONO
//	TRX->ABONO		:= TMOV->ABONO
  	TRX->TURNO		:= TMOV->TURNO
	TRX->DESCTURN	:= TMOV->DESCTURN
	Msunlock()
    If lAbortPrint
     @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
    Exit
   Endif

/*   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do cabecalho do relatorio. . .                            ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10
   Endif

   @nLin,00       PSAY TMOV->COD
   @nLin,PCOL()+2 PSAY TRX->DESC
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDINV,"@E 99,999,999.99") 
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDTRANS,"@E 99,999,999.99")    
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDPERDAS,"@E 99,999,999.99")    
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDCONS,"@E 99,999,999.99")    

   nLin := nLin + 1 // Avanca a linha de impressao
   
*/
   DbselectArea("TMOV")
   DbsKip()    
       
 Enddo
 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DbSelectArea("TMOV")
//SetRegua(RecCount())
SExcel:=Msgbox("Confirma gera็ใo dos dados em Excel","Planilha","YESNO")
If  SExcel
      cDirDocs  :="\RELATO\"
      cPath="C:\RELATORIO_SIGA\"
	  cNome := "hExtraExced-"+Strtran(Dtoc(Date()),"/","")+"-"+Strtran(Time(),":","")+".xls"
//	  cNome := "HEXCED"+Dtos(mv_par07)+"a"+Dtos(mv_par08)+".xls
	  
  	  dbSelectArea("TRX")
	  COPY TO &(cDirDocs+cNome)
      CpyS2T( cDirDocs+cNome , cPath , .T. ) //cDirDocs+"\"+cArq+".DBF"  
      fErase(cDirDocs+cNome)
       If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
           MsgStop( 'MsExcel nao instalado' ) 
           DbSelectArea("TMOV")
	  	   DbcloseArea("TMOV")
		   DbSelectArea("TRX")
		   DbcloseArea("TRX")
	       Return
        EndIf

        oExcelApp := MsExcel():New()     // Cria um objeto para o uso do Excel
        oExcelApp:WorkBooks:Open(cPath+cNome) // Atribui เ propriedade WorkBooks do Excel
  												    // o Arquivo criado com as informacoes acumuladas do SRC 
        oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
   
        MSGBOX("Foi gerado o Arquivo "+cNome,"Informacao","INFO")
        

	   

Endif  
 DbSelectArea("TMOV")
 DbcloseArea("TMOV")
 DbSelectArea("TRX")
 DbcloseArea("TRX")



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
