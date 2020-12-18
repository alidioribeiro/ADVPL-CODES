/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ NSESTR08   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 19/09/2011 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Relatório de obsolescência  1                                 ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
//  .--------------------------------------.
// |  Inclusao de Bibliotecas e Constantes  |
//  '--------------------------------------'
#INCLUDE "rwmake.ch"

//  .--------------------------------------.
// |  Inicio da Rotina Principal            |
//  '--------------------------------------'
User Function NSGPER01()

//  .--------------------------------------.
// |  Declaracao de variaveis Locais        |
//  '--------------------------------------'
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Relacao de dependentes"
Local cPict         := ""
Local titulo        := "Relacao de dependentes"
Local nLin          := 180
Local Cabec1        := ""
Local Cabec2        := ""
Local imprime       := .T.
Local aOrd 		 := {}
Local cPerg         := PADR("NSGPER01", Len(SX1->X1_GRUPO))

//  .----------------------------------.
// |  Declaracao de variaveis Privadas  |
//  '----------------------------------'
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "NSGPER01"
Private nTipo       := 10
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "NSGPER01"
Private cString     := "SRA"

// .-----------------------------------.
//|  Cricao das Perguntas do relatótio  |
//'-----------------------------------'
CriaSx1(cPerg)
Pergunte(cPerg,.F.)

//  .-----------------------------------------------.
// |  Cricação da tela de configuração da Impressão  |
//  '-----------------------------------------------'
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//  .-----------------------------------.
// |  Verifica se foi usada a Tecla Esc  |
//  '-----------------------------------'
If nLastKey == 27
	Return Nil
Endif

//  .-----------------------------------.
// |  Seta as Configuracoes escolhidas   |
//  '-----------------------------------'
SetDefault(aReturn,cString)

//  .-----------------------------------.
// |  Verifica se foi usada a Tecla Esc  |
//  '-----------------------------------'
If nLastKey == 27
	Return Nil
Endif

//  .-----------------------------------.
// |  Verifica Tipo de impressao         |
// |  15 - Retrato                       |
// |  18 - Paisagem                      |
//  '-----------------------------------'
nTipo := If(aReturn[4]==1,15,18)

//  .-------------------------------------.
// |  Tira espacos do Titulo do Relatorio  |
//  '-------------------------------------'
Titulo := AllTrim(Titulo)

//  .-------------------------------------.
// |  Montagem do Cabecalho de Impressao   |
//  '-------------------------------------'

//         123456 123456789012345678901234567890 12345678 123456789012345678901234 1234567890123456789012345 1234567890 12 1234 12345678901    9,999,999,999    9,999,999,999.99
//         000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111                                                                    200
//         000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233        4         5         6         7         8         9         0         1         2
//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Cabec1 := " MAT   NOME                           ADMISSAO SETOR                    DEPENDENTES               NASC       SX GRAU CPF
Cabec2 := " "
	


//  .------------------------------------------.
// |  Chamada da rotina de Logica de Impressao  |
//  '------------------------------------------'
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//  .------------------------------------------.
// |  Retorno da rotina Principal               |
//  '------------------------------------------'
Return Nil

//  .--------------------------------.
// |  Rotina de Logica de Impressao   |
//  '--------------------------------'
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//  .--------------------------------.
// |  Declaracao de variaveis Locais  |
//  '--------------------------------'
Local   _nLin   := 60
Local   nTotal  := 0

//  .----------------------------------.
// |  Declaracao de variaveis Privadas  |
//  '----------------------------------'
Private aLinha  := {}
Private aExport := {}

//  .-------------------------------------------------------.
// |  Funcao que monta a tabela temporaria para a impressao  |
//  '-------------------------------------------------------'
nwReg := MontaQry()

//  .-------------------------------------------------------.
// |  Setando Regua de processamento                         |
//  '-------------------------------------------------------'
SetRegua( nwReg )

//  .---------------------------------------------------------------.
// |  Laço de repetição con a finalidade de percorrer Toda a tabela  |
// |  de movimentações do MRP.                                       |
//  '---------------------------------------------------------------'
While !TMP01->(EOF())
	
	//  .---------------------------------------------------------------.
	// |  Incrementando a regua do processamento da rotina               |
	//  '---------------------------------------------------------------'
	IncRegua()
	
	//  .---------------------------------------------------------------.
	// |  Criação de uma nova página no relatório                        |
	//  '---------------------------------------------------------------'
	If _nLin > 57
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		_nLin := 9
	Endif
	
	//  .---------------------------------------------------------------.
	// |  Impressão do código e da descricao do Centro de custo          |
	//  '---------------------------------------------------------------'
	@ _nLin, 000 PSAY AllTrim(TMP01->RA_MAT)
	aAdd(aLinha,AllTrim(TMP01->RA_MAT))
	                              
	@ _nLin, 007 PSAY AllTrim(Substr(TMP01->RA_NOME,1,30) )
	aAdd(aLinha,AllTrim(TMP01->RA_NOME))
	
	@ _nLin, 038 PSAY AllTrim(TMP01->RA_ADMISSA)
	aAdd(aLinha,AllTrim(TMP01->RA_ADMISSA))
	
	//@ _nLin, 072 PSAY AllTrim(TMP01->RJ_DESC)
	aAdd(aLinha,AllTrim(TMP01->RJ_DESC))
	
	@ _nLin, 047 PSAY AllTrim(AllTrim(TMP01->CTT_DESC01))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->CTT_DESC01)))
	
	
	//@ _nLin, 112 PSAY AllTrim(AllTrim(TMP01->RB_COD))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_COD)))
	
	
	@ _nLin, 072 PSAY AllTrim(SUBSTR(TMP01->RB_NOME,1,25))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_NOME)))
	
	
	@ _nLin, 098 PSAY AllTrim(AllTrim(TMP01->RB_DTNASC))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_DTNASC)))
	
	
	@ _nLin, 109 PSAY AllTrim(AllTrim(TMP01->RB_SEXO))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_SEXO)))
	
	
	@ _nLin, 112 PSAY AllTrim(AllTrim(TMP01->RB_GRAUPAR))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_GRAUPAR)))
	
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_DTENTRA))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_DTENTRA)))
	
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_DTBAIXA))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_DTBAIXA)))
	
	
	@ _nLin, 117 PSAY AllTrim(AllTrim(TMP01->RB_CIC ))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_CIC )))
	
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_VBDESAM ))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_VBDESAM )))
	
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_NOMEMAE))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_NOMEMAE)))
	
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_CNS))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_CNS)))
	
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_XCNVMED))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_XCNVMED)))
	
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->CTT_DESC01))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_XCNVODO))) 
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_TIPIR))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_TIPIR)))
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->RB_TIPSF))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_TIPSF)))
	
	//@ _nLin, 060 PSAY AllTrim(AllTrim(TMP01->REGNAS))
	aAdd(aLinha,AllTrim(AllTrim(TMP01->RB_REGNAS)))
	
	//  .---------------------------------------------------------------.
	// |  Incrementando Linha de Impressao do relatorio                  |
	//  '---------------------------------------------------------------'
	_nLin++
	
	//  .---------------------------------------------------------------.
	// |  Pulando registro da tabela temporaria                          |
	//  '---------------------------------------------------------------'
	TMP01->(dbSkip())
	
	//  .----------------------------------------------------------------.
	// |  Incrementando a variavel de controle da linha do vetor de dados |
	// |  que está sendo processada na impressão do relatório             |
	//  '----------------------------------------------------------------'
	aAdd(aExport,Array(Len(aLinha)))
	aExport[Len(aExport)] := aClone(aLinha)
	aLinha := {}
	
End

TMP01->(dbCloseArea())

//  .---------------------------------------------------------------.
// |  Implementa a Impressão de uma linha continua                   |
//  '---------------------------------------------------------------'
_nLin++
@ _nLin, 000 PSAY __PrtThinLine()
_nLin++

//  .---------------------------------------------------------------.
// |  Implementa a Impressão de uma linha continua                   |
//  '---------------------------------------------------------------'
_nLin++
@ _nLin, 000 PSAY __PrtThinLine()
_nLin++

MsgRun("Exportando Dados, Aguarde...",,{|| Exporta()})

//  .---------------------------------------------------------------.
// |  Setando configurações da impressora default                    |
//  '---------------------------------------------------------------'
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

//  .---------------------------------------------------------------.
// |  Flush na impressao do relatório                                |
//  '---------------------------------------------------------------'
MS_FLUSH()

Return

/*----------------------------------------.
|     Cria grupo de perguntas no SX1     |
'----------------------------------------*/

Static Function CriaSx1(cPerg)

PutSX1(cPerg, "01", "Admissao           :", "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "   ", "", "", "mv_par01")
PutSX1(cPerg, "02", "Tipo Impressao ?", "", "", "mv_ch2", "N", 01, 0, 0, "C", "", "   ", "", "", "mv_par02", "Protheus"   , "", "", "", "Excel"    , "", "", "Ambos"    , "", "")
PutSX1(cPerg, "03", "Matricula       :", "", "", "mv_ch3", "C", 06, 0, 0, "G", "", "AL ", "", "", "mv_par03")
PutSX1(cPerg, "04", "Setor      :", "", "", "mv_ch4", "C", 30, 0, 0, "G", "", "AL ", "", "", "mv_par04")


Return Nil

/*-----------------------------------------------.
|     Rotina de geração do arquivo em Excel     |
'-----------------------------------------------*/

Static Function Exporta()
Local cArqTxt    := GetTempPath() + "Dependentes.xls"
Local nHdl       :=  Nil
Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)

If File(cArqTxt)
	FErase(cArqTxt)
Endif

nHdl := fCreate(cArqTxt)

If !File(cArqTXT)
	MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado!")
	Return nil
EndIf

cLinha += "MATRICULA" + Chr(9) + "NOME"     + Chr(9) + "ADMISSAO"  +Chr(9) + "DESCRICAO DA FUNCAO" +Chr(9) + "SETOR"  +Chr(9)
cLinha += "CODIGO" + Chr(9) + "DEPENDENTES"  + Chr(9) + "DATA DE NASCIMENTO"  + Chr(9) + "SEXO"  + Chr(9)+ "GRAU DE PARANDESCO"  +Chr(9)
cLinha += "ENTRADA" + Chr(9) + "BAIXA"  + Chr(9) + "CPF"  + Chr(9) + "VERBA"  + Chr(9)+ "MAE"  + Chr(9)+ "CART.NAS.SAUDE"  + Chr(9)
cLINHA += "PLA.MEDICO" + Chr(9) + "PLA.ODONTO" + Chr(9) + "TIPO.DEP.IR"  +Chr(9) + "TIPO.DER.SF"  +Chr(9) + "N.NASC.VIVO" +chr(13)+chr(10)


If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
EndIf

For i:=1 to Len(aExport)
	cLinha := ""
	IncRegua()
	
	If ValType(aExport[i])<>"A"
		cLinha += aExport[i]
	Else
		For j := 1 to Len(aExport[i])
			cLinha += aExport[i][j]+Chr(9)
		Next
	Endif
	
	cLinha += chr(13)+chr(10)
	
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	EndIf
Next
fClose(nHdl)
RunExcel(cArqTxt)
Return Nil

//*****************************************************************************************************************************

Static Function RunExcel(cwArq)
Local oExcelApp
Local aNome := {}

If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' )
	Return
EndIf

oExcelApp := MsExcel():New()                    	  // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open(cwArq)
oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
oExcelApp:Destroy()
Return


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ MontaQry   ¦ Autor ¦ Anderson Gadelha     ¦ Data ¦ 01/12/2016 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Atraves de umaIsntrucao em Sql monta uma Tabela Temporaria c/ ¦¦¦
¦¦¦  (Cont)   ¦ as informcacoes da tabela SRA e SRB                           ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function MontaQry()
Local cQuery := ""
Local nRegis := 0
Local cwEnter:= chr(13)+chr(10)

cQuery := "SELECT RA_MAT, RA_NOME  , RA_ADMISSA , SRJ.RJ_DESC   , CTT.CTT_DESC01 , "
cQuery +=        "ISNULL(RB_COD,'') RB_COD, ISNULL(RB_NOME,'SEM DEPENDENDES') RB_NOME, "
cQuery +=        "ISNULL(SUBSTRING(RB_DTNASC,7,2)+'/'+SUBSTRING(RB_DTNASC,5,2)+'/'+SUBSTRING(RB_DTNASC,1,4) ,'') AS RB_DTNASC , "
cQuery +=        "ISNULL(RB_SEXO,'') RB_SEXO,"
cQuery +=        "(CASE RB_TIPIR               "
cQuery +=	     "WHEN '1' THEN 'S/Lim.Idade'  "
cQuery +=	     "WHEN '2' THEN 'Ate 21 Anos'  "
cQuery +=	     "WHEN '3' THEN 'Ate 24 Anos'  "
cQuery +=	     "WHEN '4' THEN 'Nao é dep.'END)RB_TIPIR, "
cQuery +=	     "(CASE RB_TIPSF  "
cQuery +=	     "WHEN '0' THEN 'S/Lim.Idade'"
cQuery +=	     "WHEN '1' THEN 'Ate 14 Anos'"
cQuery +=	     "WHEN '2' THEN 'Nao é dep.'END)RB_TIPSF, RB_REGNAS, RB_GRAUPAR, RB_DTENTRA, RB_DTBAIXA, RB_CIC, "
cQuery +=        "RB_VBDESAM, RB_NOMEMAE, RB_CNS, RB_XCNVMED, RB_XCNVODO  "
cQuery +=    "FROM " + RetSqlName("SRA") + " SRA (NOLOCK) "
cQuery += "LEFT OUTER JOIN " + RetSqlName("SRB") + " SRB ON SRB.D_E_L_E_T_='' AND RA_MAT = RB_MAT "
cQuery += "LEFT OUTER JOIN " + RetSqlName("SRJ") + " SRJ ON SRJ.D_E_L_E_T_='' AND RA_CODFUNC = RJ_FUNCAO "
cQuery += "LEFT OUTER JOIN " + RetSqlName("CTT") + " CTT ON CTT.D_E_L_E_T_='' AND RA_CC = CTT_CUSTO "
cQuery += "WHERE SRA. D_E_L_E_T_='' "
cQuery +=        "AND RA_DEMISSA='' "
cQuery += "ORDER BY RA_NOME, RB_COD "


memowrit('NSGPER01.sql',cQuery)
dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP01", .T., .F. )

Return nRegis

/***************************************************      
*   DDDDDDDD             AA           OOOOOOOOO    *
*   D       DD          AAAA         OO       OO   *
*   D         DD       AA  AA        OO       OO   *
*   D          D      AA    AA       OO       OO   *
*   D         DD     AAAAAAAAAA      OO       OO   *
*   D       DD      AA        AA     OO       OO   *
*   DDDDDDDD       AA          AA     OOOOOOOOO    *
*****************************************************
*         NEVER IS LATE 'JJ'                        *
***************************************************** 
