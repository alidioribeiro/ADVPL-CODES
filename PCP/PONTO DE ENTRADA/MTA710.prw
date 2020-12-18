//-------------------------------------------------------.
// Declaração das bibliotecas utilizadas no programa      |
//-------------------------------------------------------'
#INCLUDE "PROTHEUS.CH"

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ HLPCPP01   ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/04/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Ponto de entrada no MRP com a finalidade de gravar as tabelas ¦¦¦
¦¦¦  (Cont.)  ¦ do MRP no Banco de Dados antecipando parte da demanda.        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
User Function MTA710()
Local cArea := GetArea()

//-------------------------------------------------------.
// Chamada da rotina de processamento do MRP - Compras    |
//-------------------------------------------------------'
//fwProcessa()

//-------------------------------------------------------.
// Restaura as areas selecionadas anteriormente           |
//-------------------------------------------------------'
RestArea(cArea)

Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fwProcessa ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 04/04/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rotina de processamento com a finalidade de gravar as tabelas ¦¦¦
¦¦¦  (Cont.)  ¦ do MRP no Banco de Dados antecipando parte da demanda.        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fwProcessa()

//-------------------------------------------------------.
// Declaração das variaveis locais                        |
//-------------------------------------------------------'
Local cSH5      := "SH5" + SM0->M0_CODIGO + "0"
Local cSHA      := "SHA" + SM0->M0_CODIGO + "0"
Local nPeriodos := 0
Local cCamposHA := ""
Local cValores  := ""
Local nwRecno   := 0

//-------------------------------------------------------.
// Verificando a existencia dos arquivos em SQL           |
//-------------------------------------------------------'
//	If !File("\DATA\01\"+cSH5+".dtc") .Or. !File("\DATA\01\"+cSHA+".dtc")
//		Alert("Arquivos SHA OU SH5 nao encontrado!")
//		Return Nil
//	EndIf

//  .----------------------------------------------------.
// |  Dropando as tabelas do MRP do banco de dados        |
//  '----------------------------------------------------'
TCSQLEXEC("DROP TABLE " + cSH5)
TCSQLEXEC("DROP TABLE " + cSHA)

//  .----------------------------------------------------.
// |  Montagem estrturas temporarias com os dados SH5     |
//  '----------------------------------------------------'

//dbUseArea( .T.,"CTREECDX", "\DATA\01\" + cSH5, "YYY", .T., .F. )
//Use &(Alltrim("\DATA\01\" + cSH5)) VIA "CTREECDX" Alias YYY new
dbSelectArea("SH5")
__dbCopy("SH5010",,,,,,,"TOPCONN")

dbSelectArea("SHA")
__dbCopy("SHA010",,,,,,,"TOPCONN")


//  .----------------------------------------------------.
// |  Montagem da regua de processamento                  |
//  '----------------------------------------------------'
// ProcRegua(  SHA->( Reccount() ) /6 ) // Numero de registros a processar
nwRecno := SHA->( LastRec () )


//  .----------------------------------------------------.
// | Verificando a quantidade de periodos do MRP          |
//  '----------------------------------------------------'
nPeriodos := fPeriodos()


//  .----------------------------------------------------.
// |  Verifica se encontrou periodos para o MRP           |
//  '----------------------------------------------------'
If nPeriodos > 0
	
	//  .----------------------------------------------------.
	// |  Monta tabela temporaria com as necessidades         |
	//  '----------------------------------------------------'
	fTabTmp()
	
	//  .----------------------------------------------------.
	// |  Inicializacao das variaveis auxiliares              |
	//  '----------------------------------------------------'
	cCamposHA := ""
	
	//  .----------------------------------------------------.
	// |  Montagem dos campos referentes aos periodos do MRP  |
	//  '----------------------------------------------------'
	For nX:= 1 to (nPeriodos)
		cCamposHA += ", HA_PER" + StrZero(nX,3)
	Next nX
	
	
	//  .----------------------------------------------------.
	// |  Repeticao para percorrer a tabela temporaria        |
	//  '----------------------------------------------------'
	While  !( TMP1->(Eof()) )
		
		//  .----------------------------------------------------.
		// |  Posionando no cadastro de produtos                  |
		//  '----------------------------------------------------'
		SB1->(dbSetOrder(1))
		SB1->(dbSeek ( xFilial("SB1") + TMP1->HA_PRODUTO ) )
		
		IF ALLTRIM(TMP1->HA_PRODUTO) == "21U005-1"
			Alert("te")
		ENDIF 
		
		//  .----------------------------------------------------.
		// |  Inicializacao das variaveis auxiliares              |
		//  '----------------------------------------------------'
		cValores  := ""
		cEstSeg   := ""
		nMesAnt   := 0
		dAuxData  := sTod( SubStr(dTos(Date()),1,6)+"01" )
		dLeedTime := Date() + SB1->B1_PE
		
		//  .----------------------------------------------------.
		// |  Incluindo barras de processamento por produto       |
		//  '----------------------------------------------------'
		IncProc("Produto: " + TMP1->HA_PRODUTO ) //"Pedido"
		
		//  .----------------------------------------------------.
		// |  Inicializacao das variaveis de adiatamento          |
		//  '----------------------------------------------------'
		nwAnt := 0
		
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		nwSaldo := {}
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		nwSaldo := TMP1->HA_PER001
		
		//  .----------------------------------------------------.
		// |  pula para o proximo registro                        |
		//  '----------------------------------------------------'
		TMP1->(dbSkip())
		
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		nwEnt := {}
		
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		For nX:= 1 to (nPeriodos)
			aAdd(nwEnt, &("TMP1->HA_PER" + StrZero(nX, 3)))
		Next nX
		
		//  .----------------------------------------------------.
		// |  pula para o proximo registro                        |
		//  '----------------------------------------------------'
		TMP1->(dbSkip())
		
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		nwSai1 := {}
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		For nX:= 1 to (nPeriodos)
			aAdd(nwSai1, &("TMP1->HA_PER" + StrZero(nX, 3)))
		Next nX
		
		//  .----------------------------------------------------.
		// |  pula para o proximo registro                        |
		//  '----------------------------------------------------'
		TMP1->(dbSkip())
		
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		nwSai2 := {}
		
		//  .----------------------------------------------------.
		// |  Percorrendo todos os periodos do MRP                |
		//  '----------------------------------------------------'
		For nX:= 1 to (nPeriodos)
			aAdd(nwSai2, &("TMP1->HA_PER" + StrZero(nX, 3)))
		Next nX
		
		For nX := 1 to (nPeriodos)
			//  .----------------------------------------------------.
			// |  Inicializacao das variaveis de adiatamento          |
			//  '----------------------------------------------------'
			nValor    := 0
			
			//  .----------------------------------------------------.
			// |  Montagem tabela temporaria com os dados MRP         |
			//  '----------------------------------------------------'
			//fTabMRP(TMP1->HA_PRODUTO, StrZero(nX,3))
			
			//  .----------------------------------------------------.
			// |  Montagem Saldo Acumulado                            |
			//  '----------------------------------------------------'
			If nX == 1
				nValor := nwSaldo + nwEnt[nX] - nwSai1[nX] - nwSai2[nX]
			Else
				nValor := nwAnt + nwEnt[nX] - nwSai1[nX] - nwSai2[nX]
			EndIf
			
			//  .----------------------------------------------------.
			// |  Arredonda valor encontrado para apresentacao MRP    |
			//  '----------------------------------------------------'
			nValor := Round(nValor,4)
			nwAnt  := nValor
			
			//  .----------------------------------------------------.
			// |  fechamento da area                                  |
			//  '----------------------------------------------------'
			//TMP2->(dbCloseArea())
			
			//  .----------------------------------------------------.
			// |  Atualizando valores para inclusao no MRP            |
			//  '----------------------------------------------------'
			cValores += ", " + StrTran( AllTrim(Str(nValor)), ",", "." )
			
		Next nX
		
		//  .----------------------------------------------------.
		// |  Incrementa variavel para controle do R_E_C_N_O_     |
		//  '----------------------------------------------------'
		nwRecno++
		
		//  .----------------------------------------------------.
		// |  Instrucao SQL para inclusao da Linha COMPRA HLB     |
		//  '----------------------------------------------------'
		cQry := "Insert Into SHA" + SM0->M0_CODIGO + "0"
		cQry += "       ( HA_NUMMRP, HA_NIVEL, HA_PRODUTO, HA_PRODSHW, HA_OPC, HA_OPCSHW, HA_REVISAO, HA_REVSHW, HA_TIPO, HA_TEXTO, R_E_C_N_O_" +cCamposHA+ "  ) "
		cQry += " Values('" + TMP1->HA_NUMMRP  + "', "
		cQry +=        " '" + TMP1->HA_NIVEL   + "', "
		cQry +=        " '" + TMP1->HA_PRODUTO + "', "
		cQry +=        " '" + TMP1->HA_PRODSHW + "', "
		cQry +=        " '" + TMP1->HA_OPC     + "', "
		cQry +=        " '" + TMP1->HA_OPCSHW  + "', "
		cQry +=        " '" + TMP1->HA_REVISAO + "', "
		cQry +=        " '" + TMP1->HA_REVSHW  + "', "
		cQry +=        " 7, 'Saldo Acumulado', " + AllTrim(Str(nwRecno)) + cValores
		cQry +=        ")
		
		//  .----------------------------------------------------.
		// |  Execucao da Instrucao SQL descrita acima            |
		//  '----------------------------------------------------'
		TCSQLExec(cQry)
		
		//  .----------------------------------------------------.
		// |  pula para o proximo registro                        |
		//  '----------------------------------------------------'
		TMP1->(dbSkip())
	End
	
	//  .----------------------------------------------------.
	// |  Fecha a tabela temporaria TMP1                      |
	//  '----------------------------------------------------'
	TMP1->(dbCloseArea())
	
EndIf

Return Nil

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fPeriodos  ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 09/04/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Rorina para verificar a quantidade de periodos do MRP.        ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fPeriodos()
Local cQuery    := ""
Local nPeriodos := 0

cQuery += " SELECT H5_QUANT "
cQuery +=   " FROM SH5" + SM0->M0_CODIGO + "0 SH5 (NOLOCK) "
cQuery +=  " WHERE SH5.D_E_L_E_T_ = '' "
cQuery +=    " AND SH5.H5_ALIAS = 'PAR' "

memowrit('mrp01.sql',cQuery)  

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP01", .T., .F. )

nPeriodos := TMP01->H5_QUANT

TMP01->(dbCloseArea())


Return nPeriodos

/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fTabTmp    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 09/04/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tabela tempor'aria com as demandas dos produtos               ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fTabTmp()
Local cQuery    := ""
Local nPeriodos := 0

cQuery += " SELECT * "
cQuery +=   " FROM SHA" + SM0->M0_CODIGO + "0 SHA (NOLOCK) "
cQuery +=  " WHERE SHA.D_E_L_E_T_ = '' "
cQuery +=    " AND SHA.HA_TIPO IN (1, 2, 3, 4) "
//  cQuery +=    " AND SHA.HA_TIPO = 4 "
cQuery +=  " ORDER BY SHA.HA_PRODUTO, HA_OPC,  SHA.HA_TIPO"



memowrit('mrp02.sql',cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP1", .T., .F. )


Return Nil


/*_______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Função    ¦ fTabMRP    ¦ Autor ¦ Wermeson Gadelha     ¦ Data ¦ 30/04/2013 ¦¦¦
¦¦+-----------+------------+-------+----------------------+------+------------+¦¦
¦¦¦ Descriçäo ¦ Tabela tempor'aria com o mrp por produto                      ¦¦¦
¦¦+-----------+---------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
Static Function fTabMRP(cwProd, cwPer)
Local cQuery    := ""
Local nPeriodos := 0

cQuery += " SELECT HA_PRODUTO, HA_PER" + cwPer + " AS INICIAL,
cQuery += "       ( SELECT HA_PER" + cwPer
cQuery += "		   FROM SHA" + SM0->M0_CODIGO + "0 AS B (NOLOCK)
cQuery += "          WHERE B.D_E_L_E_T_ = ''
cQuery += "            AND HA_PRODUTO =  '" + cwProd + "' "
cQuery += "            AND HA_TIPO    = '2'
cQuery += "       ) AS ENTRADAS,
cQuery += "       ( SELECT SUM(HA_PER" + cwPer + ")"
cQuery += "		   FROM SHA" + SM0->M0_CODIGO + "0 AS C (NOLOCK)
cQuery += "          WHERE C.D_E_L_E_T_ = ''
cQuery += "            AND C.HA_PRODUTO =  '" + cwProd + "' "
cQuery += "            AND C.HA_TIPO    IN ('3', '4')
cQuery += "       ) AS SAIDAS,
cQuery += "       ( SELECT D.HA_PER" + cwPer
cQuery += "		   FROM SHA" + SM0->M0_CODIGO + "0 AS D (NOLOCK)
cQuery += "          WHERE D.D_E_L_E_T_ = ''
cQuery += "            AND D.HA_PRODUTO =  '" + cwProd + "' "
cQuery += "            AND D.HA_TIPO    = '5'
cQuery += "       ) AS SALDO,
cQuery += "       ( SELECT D.HA_PER" + cwPer
cQuery += "		   FROM SHA" + SM0->M0_CODIGO + "0 AS D (NOLOCK)
cQuery += "          WHERE D.D_E_L_E_T_ = ''
cQuery += "            AND D.HA_PRODUTO =  '" + cwProd + "' "
cQuery += "            AND D.HA_TIPO    = '6'
cQuery += "       ) AS NECESSIDADE
cQuery += "  FROM SHA" + SM0->M0_CODIGO + "0 A (NOLOCK) "
cQuery += " WHERE A.D_E_L_E_T_ = ''
cQuery += "   AND A.HA_PRODUTO = '" + cwProd + "' "
cQuery += "   AND A.HA_TIPO    = '1'

memowrit('mrp03.sql',cQuery)

dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "TMP2", .T., .F. )


Return Nil


/***********************************************************************************
*       AA        LL         LL         EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
*      AAAA       LL         LL         EE         CC        KK    KK   SS         *
*     AA  AA      LL         LL         EE        CC         KK  KK     SS         *
*    AA    AA     LL         LL         EEEEEEEE  CC         KKKK        SSSSSSS   *
*   AAAAAAAAAA    LL         LL         EE        CC         KK  KK            SS  *
*  AA        AA   LL         LL         EE         CC        KK    KK          SS  *
* AA          AA  LLLLLLLLL  LLLLLLLLL  EEEEEEEE    CCCCCCC  KK      KK  SSSSSSS   *
************************************************************************************
*         I want to change the world, but nobody gives me the source code!         *
***********************************************************************************/
