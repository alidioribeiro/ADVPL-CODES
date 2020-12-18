#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function Veiculo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := "Cadastro de Veículos"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZZU"

dbSelectArea("ZZU")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return
/*********************************************************************/
/*********************************************************************/

User Function Romaneio


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg   := "ZZR"
Private cCadastro := "Cadastro de Romaneio"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array (tambem deve ser aRotina sempre) com as definicoes das opcoes ³
//³ que apareceram disponiveis para o usuario. Segue o padrao:          ³
//³ aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      ³
//³              . . .                                                  ³
//³              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      ³
//³ Onde: <DESCRICAO> - Descricao da opcao do menu                      ³
//³       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  ³
//³                     duplas e pode ser uma das funcoes pre-definidas ³
//³                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA ³
//³                     e AXDELETA) ou a chamada de um EXECBLOCK.       ³
//³                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-³
//³                     clarar uma variavel chamada CDELFUNC contendo   ³
//³                     uma expressao logica que define se o usuario po-³
//³                     dera ou nao excluir o registro, por exemplo:    ³
//³                     cDelFunc := 'ExecBlock("TESTE")'  ou            ³
//³                     cDelFunc := ".T."                               ³
//³                     Note que ao se utilizar chamada de EXECBLOCKs,  ³
//³                     as aspas simples devem estar SEMPRE por fora da ³
//³                     sintaxe.                                        ³
//³       <TIPO>      - Identifica o tipo de rotina que sera executada. ³
//³                     Por exemplo, 1 identifica que sera uma rotina de³
//³                     pesquisa, portando alteracoes nao podem ser efe-³
//³                     tuadas. 3 indica que a rotina e de inclusao, por³
//³                     tanto, a rotina sera chamada continuamente ao   ³
//³                     final do processamento, ate o pressionamento de ³
//³                     <ESC>. Geralmente ao se usar uma chamada de     ³
//³                     EXECBLOCK, usa-se o tipo 4, de alteracao.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aRotina padrao. Utilizando a declaracao a seguir, a execucao da     ³
//³ MBROWSE sera identica a da AXCADASTRO:                              ³
//³                                                                     ³
//³ cDelFunc  := ".T."                                                  ³
//³ aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               ³
//³                { "Visualizar"   ,"AxVisual" , 0, 2},;               ³
//³                { "Incluir"      ,"AxInclui" , 0, 3},;               ³
//³                { "Alterar"      ,"AxAltera" , 0, 4},;               ³
//³                { "Excluir"      ,"AxDeleta" , 0, 5} }               ³
//³                                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta um aRotina proprio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","U_IncRom",0,3} ,;
             {"Alterar","AxAltera",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZZR"

dbSelectArea("ZZR")
dbSetOrder(1)

cPerg   := "ZZR"

Pergunte(cPerg,.F.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a funcao MBROWSE. Sintaxe:                                  ³
//³                                                                     ³
//³ mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              ³
//³ Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   ³
//³                        exibido. Para seguir o padrao da AXCADASTRO  ³
//³                        use sempre 6,1,22,75 (o que nao impede de    ³
//³                        criar o browse no lugar desejado da tela).   ³
//³                        Obs.: Na versao Windows, o browse sera exibi-³
//³                        do sempre na janela ativa. Caso nenhuma este-³
//³                        ja ativa no momento, o browse sera exibido na³
//³                        janela do proprio SIGAADV.                   ³
//³ Alias                - Alias do arquivo a ser "Browseado".          ³
//³ aCampos              - Array multidimensional com os campos a serem ³
//³                        exibidos no browse. Se nao informado, os cam-³
//³                        pos serao obtidos do dicionario de dados.    ³
//³                        E util para o uso com arquivos de trabalho.  ³
//³                        Segue o padrao:                              ³
//³                        aCampos := { {<CAMPO>,<DESCRICAO>},;         ³
//³                                     {<CAMPO>,<DESCRICAO>},;         ³
//³                                     . . .                           ³
//³                                     {<CAMPO>,<DESCRICAO>} }         ³
//³                        Como por exemplo:                            ³
//³                        aCampos := { {"TRB_DATA","Data  "},;         ³
//³                                     {"TRB_COD" ,"Codigo"} }         ³
//³ cCampo               - Nome de um campo (entre aspas) que sera usado³
//³                        como "flag". Se o campo estiver vazio, o re- ³
//³                        gistro ficara de uma cor no browse, senao fi-³
//³                        cara de outra cor.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros


Return
/*************************************************************************************/
User Function ZZRTudOk             
Local Ret   := .T.
Local a_Area := GetArea()

if Empty(cMotorista) 

   Alert('Nome do Motorista Obrigatorio...Informe o motorista!!')
   Ret   := .f.

Endif

RestArea(a_Area)
Return(Ret) 

/***********************************************************************************/

/***************************************************************************/
User Function IncRom ()      
Local cNum:=""
	BrowInc()
Return	
 
/***************************************************************************/
/***************************************************************************/
/***************************************************************************/
Static Function BrowInc()

Local Usuario:=__cUserId
Private lPadrao:=.F.
SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,CTITULO,AC,AR,ACGD") 
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,N_Saldo,N_Horas")

//+--------------------------------------------------------------+
//¦ Opcao de acesso para o Modelo 2                              ¦
//+--------------------------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza 
nOpcao  := 0
nOpcx   := 3
n_Saldo := 0
N_Horas := 0
cAlias  := Alias()
cRecno  := Recno()
//cCC := Alltrim(cCCSoli)
//¦ Montando aHeader                                             ¦
//+--------------------------------------------------------------+


dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZZR")
nUsado  := 0
aHeader := {}
While !Eof() .and. (x3_arquivo == "ZZR")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>6 // .and. Val(X3_ORDEM)<7
		nUsado++
		AADD(aHeader,{TRIM(X3_TITULO),;
		X3_CAMPO,;
		X3_PICTURE,;
		X3_TAMANHO,;
		X3_DECIMAL,;
		.F.,;
		X3_USADO,;
		X3_TIPO,;
		X3_ARQUIVO,;
		X3_CONTEXT})
	Endif
	dbSkip()
End
//+--------------------------------------------------------------+
//¦ Montando aCols                                               ¦
//+--------------------------------------------------------------+
aCols := Array(1,nUsado+1)    // campos
dbSelectArea("SX3")
dbsetorder(1)
dbSeek("ZZR")
nUsado := 0
While !Eof() .and. (X3_ARQUIVO == "ZZR")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>6
		nUsado++                                                    
		
			IF X3_TIPO == "C"
				aCols[1][nUsado] := Space(X3_TAMANHO)
			Elseif X3_TIPO == "N"
				aCols[1][nUsado] := 0
			Elseif X3_TIPO == "D"
				aCols[1][nUsado] := dDataBase
			Elseif X3_TIPO == "M"
				aCols[1][nUsado] := ""
			Else
				aCols[1][nUsado] := .F.
			Endif
		
	Endif        
	dbSkip()
End
aCols[1][nUsado+1] := .F.
//+--------------------------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2                           ¦
//+--------------------------------------------------------------+
dbSelectArea("ZZR")                 
dbSetOrder(1)
				
cEmissao := dDataBase                                 
cAno:= Alltrim(Str(Year(cEmissao)))
cNum:=ChecaSeq (cAno)
cSolici  := cUserName                                                                                                                       



//cSaldoHE := Alltrim (Transform(Posicione("SZN",1,xFilial("SZN")+ "2008" + bCCusto,"ZN_SALDO"),"@E 999,999,999.99" ))

//+--------------------------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2                              ¦
//+--------------------------------------------------------------+
nLinGetD := 0
//+--------------------------------------------------------------+
//¦ Titulo da Janela                                             ¦
//+--------------------------------------------------------------+
cTitulo  := "Romaneio de Entrega"
//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho do Modelo 2      ¦
//+--------------------------------------------------------------+
aC:={}       
cMotorista:=""
cMotorista:=Space(100)                          
cPlaca:=Space(10)
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"cNum"     , {15,010} ,"Documento"    ,"@e " ,,,.f.})
AADD(aC,{"cSolici"  , {15,100} ,"Solicitante"  ,"@e " ,,,.f.})
//AADD(aC,{"cAno    " , {15,300} ,"Emissão"      ,"@e " ,,,.f.})
AADD(aC,{"cEmissao" , {15,300} ,"Emissão"      ,"@e " ,,,.f.})
AADD(aC,{"cPlaca" , {30,010} ,"Placa "      ,"@e " ,,"ZZU",.T.})
AADD(aC,{"cMotorista" , {30,100} ,"Motorista"  ,"@e " ,,,.T.})


//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Rodape do Modelo 2         ¦
//+--------------------------------------------------------------+

aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//+--------------------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2                 ¦
//+--------------------------------------------------------------+
//aCGD := {60,5,100,315}

//aCGD := {60,5,100,200}

//aCGD := {70,5,100,315}
aCGD := {70,5,100,315}
//+--------------------------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2                           ¦
//+--------------------------------------------------------------+
//cLinhaOk := "ExecBlock('SZPLinOK',.f.,.f.)"
cLinhaOk := "U_ZZRLinOK()"
cTudoOk  := "ExecBlock('ZZRTudOk',.f.,.f.)"
//+--------------------------------------------------------------+
//¦ Chamada da Modelo2                                           ¦
//+--------------------------------------------------------------+
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
If Len(aCols)<>0
	//aCols := a_Perd
//	For _i:=1 to len(a_Perd)
//		aAdd(aCols,a_Perd[_i])
//	Next
EndIf
/*********************************************************************/
//Criando arquivo Temporário para inclusão dos percentuais do Fcost **/
//****************************************************************/                
//+--------------------------------------------------------------+

dbSelectArea("ZZR")                 
dbgotop()
//lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,)

//lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{40,10,500,800})
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{40,10,500,500},,.T.)
                                                   	


If lRetMod2
	ConfirmSX8()
	For X:=1 to len(aCols)
		if !(aCols[x][len(aHeader)+1])
			dbSelectArea("ZZR") 
			RecLock("ZZR",.T.)
    		ZZR_FILIAL:=xFilial()
    		ZZR_DOC:=cNum
    		ZZR_ANO:=CAno
	   		ZZR_PLACA:=CPlaca
    		ZZR_RESP:=cSolici
    		ZZR_MOT:=cMotorista
            ZZR_DATA:=cEmissao
            ZZR_NF:=aCols[x][1]
            ZZR_SERIE:=aCols[x][2]
            MsunLock()
			NrRom:=Val(Substr(cNum,1,6))+1
			Putmv("MV_ROM",NRROM)
         Endif    
    Next			
Else
//	Close(oDlg5)
	Sai := .f.
Endif

Return
/***********************************************************************************/
Static Function ChecaSeq (Ano)
cQuery:=" select max(substring(ZZR_DOC,1,6)) AS NUMERO from "+RetSqlName("ZZR")
cQuery+=" where ZZR_ANO='"+Ano+"' "
cQuery+=" and D_E_L_E_T_='' "
TcQuery cQuery New Alias "TRB"
DbSelectArea("TRB")
DbGotop()
If !Eof()
   if Val(TRB->NUMERO)==0
		cNum:="000001"
   Else
   		cNum:=Strzero(Val(TRB->NUMERO)+1,6)
   EndIF
Else
	lRet:=.F.   
EndIf			
DbCloseArea()
Return cNum
/**********************************************************************************/
User Function ZZRLinOK 
Local lRet   := .T.
Local a_Area := GetArea()       


if !(aCols[n][len(aHeader)+1])
	DbSelectArea("ZZR")
	DbSetOrder(1)
	If (DbSeek(aCols[n][1]+aCols[n][1])) // Verifica se o Produto Esta no Romaneio 
		Alert ("Esse documento já existe no Romaneio "+ZZR->ZR_NUM)
		LRet:=.F.
	EndIf
	If Lret
		Nf:=aCols[n][1]
	 	Serie:=aCols[n][2]
		For i:=1 to len(aCols) 	
			If n<>i
				If Nf+Serie==aCols[i][1]+aCols[i][2]
					Alert ("Esse documento já está no Romaneio ")
					lRet:=.F.
					Exit
				EndIf 
			EndIf 
		Next                 
		DbSelectArea("SF2")		
		DbSetOrder(1)
		If ! DbSeek(xFilial("SF2")+Nf+Serie)
			Alert ("Esse Fatura Inexistente !! ")
			lRet:=.F.
		EndIf 
	EndIf 
EndIf
	RestArea(a_Area)
Return(lRet) 
