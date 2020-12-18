#include "rwmake.ch"        // inclcSaldoHEuido  asistente de conversao do AP5 IDE em 21/02/02
#Include "TOPCONN.CH" 
#include "ap5mail.ch"
#Include "TBICONN.CH"
#DEFINE LINHAS 700

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³HORAEXTRA ºAutor  ³Jefferson Moreira   º 7 ³  05/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esse programa monta um browser para ser informado as Horas  º±±
±±º          ³Extras ocorridos nos Centros de Custo                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ANALISTA  ³MOTIVO                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º05/08/09  ³Jorge S.  ³Adequacao dos Controle de Horas Extras, a todos  º±±
±±º          ³          ³os setores da Organizacao.                       º±±
±±º17/08/09  ³Jorge S.  ³Ajuste no Cad. de Solicita de Horas Extras, para º±±
±±º          ³          ³que o Sistema repita para os demais colaboradoresº±±
±±º          ³          ³as informacoes fornecidas ao primeiro.           º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//  .----------------------------------------------------------------------------------------------
// |   Alterado por Wagner Corrêa (09/03/2017) - Enviar e-mail para o RH na inclusão e aprovação
// |   Exclusão de comentários inúteis
//  '----------------------------------------------------------------------------------------------
//
User Function HREXTRA()      

Private SomH:= 0 
Private Saldo:=0
Private cString
Private	_bFiltraBrw	:= ''
Private _aIndexSZP 	:= {}
Private	_cFiltro  	:= ''
Private cCadastro := "Horas Extras"
Private aCores 	  := {{ "SZP->ZP_STATUS==' '", 'BR_AZUL' },;     // Aberto
		              { "SZP->ZP_STATUS=='1'", 'ENABLE'  },;     // Aprovado
		              { "SZP->ZP_STATUS=='2'", 'DISABLE' },;     // Realizado
				      { "SZP->ZP_STATUS=='3'", 'BR_PRETO'},;     // Nao Realizado 
				      { "SZP->ZP_STATUS=='4'", 'BR_AMARELO'}}    // Nao houve aprovacao
					 
Private aRotina:={}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZP"
Private cCCSoli
Private CodGer:=""

If (__LANGUAGE = "ENGLISH")
	aRotina := { {"Search" ,"AxPesqui",     0, 1},;
				{"View"      ,"U_VisuaHE",  0, 2},;
				{"Add"       ,"U_HEIncl",   0, 3},;
				{"Edit"      ,"U_HEAltera", 0, 4},;
				{"Delete"    ,"U_ExcHE",    0, 5},;
				{"Apro/Post" ,"U_HEApro",   0, 6},;
				{"Print"     ,"U_HEImp",    0, 7},; 
				{"Report"    ,"U_RHEImp",   0, 8},; 
				{"Caption"   ,"U_HELeng",   0, 9} }
Else
	aRotina := { {"Pesquisar", "AxPesqui",   0, 1} ,;
				{"Visualizar", "U_VisuaHE",  0, 2} ,;
				{"Incluir"   , "U_HEIncl",   0, 3} ,;
				{"Alterar"   , "U_HEAltera", 0, 4} ,;
				{"Excluir"   , "U_ExcHE",    0, 5} ,;
				{"Apro/Post" , "U_HEApro",   0, 6} ,;
				{"Imprimir"  , "U_HEImp",    0, 7} ,; 
				{"Relatorio" , "U_RHEImp",   0, 8} ,; 
				{"Legenda"   , "U_HELeng",   0, 9 } }                       
Endif

CodGer:=LGestor()

xUserVali := __cUserId
PswOrder(1)

If PswSeek(xUserVali,.T. ) 
	aInfoUser := PswRet()
EndIf     

cMatSol  := SubString(aInfoUser[1][22], 5, 6) // Matrícula do Solicitante associado no cadastro de usuários
cCCSoli  := AllTrim( Posicione("SRA", 1, xFilial("SRA") + cMatSol,"RA_CC"))
cDescSol := AllTrim( Posicione("CTT", 1, xFilial("CTT") + cCCSoli,"CTT_DESC01"))
cUser    := __cUserId

if  !( __cUserId $ CodGer .or. AllTrim(cCCSoli)="124")
   _cFiltro  := "(AllTrim(SZP->ZP_CC)='" + cCCSoli + "' .or. SZP->ZP_MAT ='"+ cMatSol + "' "
   _cFiltro  += " .or. AllTrim(SZP->ZP_USER)='" + AllTrim(__cUserId) + "')"
Endif
//       
//  .--------------------------------------------------------------
// |   Setor de RH só visualiza solicitações abertas e aprovadas
//  '--------------------------------------------------------------
//
If AllTrim(cCCSoli) = "124" 
	 aCores:= { {"SZP->ZP_STATUS$' 4'", 'BR_AZUL' },;
	 			{"SZP->ZP_STATUS$'123'", 'ENABLE' }}

EndIf 	

dbSelectArea("SZP")
dbSetOrder(1)
dbSelectArea(cString)

If !Empty(_cFiltro)                
   _bFiltraBrw := {|| FilBrowse("SZP", @_aIndexSZP, @_cFiltro) }
   Eval(_bFiltraBrw)
EndIf

mBrowse(6,1,22,75,'SZP',,,,,,aCores)

//EndFilBrw("SZP",_aIndexSZP)

Return
//
//
//
User Function HEIncl()

Private lPadrao
lPadrao=MsgBox("Você deseja copiar os dados da primeira linha para os demais","Atenção","YesNo")
BrowInc()

Return
//
//
//
Static Function BrowInc()

Local Usuario:=cUser

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
aSHE := {}
cCC := Alltrim(cCCSoli)

//  .---------------------
// ¦   Montando aHeader
//  '---------------------

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZP")

nUsado  := 0
aHeader := {}
While !Eof() .and. (X3_ARQUIVO == "SZP" )
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM) > 2  .and. Val(X3_ORDEM)< 21 .and. Val(X3_ORDEM) # 11   
		nUsado++
		aAdd(aHeader,{TRIM(X3_TITULO),;
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
//  .-------------------
// ¦   Montando aCols   
//  '-------------------
aCols := Array(1,nUsado+1)
dbSelectArea("SX3")
dbSeek("SZP")
nUsado := 0
While !Eof() .and. (X3_ARQUIVO == "SZP")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>2 .and. Val(X3_ORDEM)<21 .and.  Val(X3_ORDEM)#11   
		nUsado++                                                    
		
			IF X3_TIPO == "C"
				aCols[1][nUsado] := Space(X3_TAMANHO)
			Elseif X3_TIPO == "N"
				aCols[1][nUsado] := 0
			Elseif X3_TIPO == "D"
				aCols[1][nUsado] := dDataBase
			Elseif X3_TIPO == "M"
				aCols[1][nUsado] := ""
			Endif
		
	Endif
	dbSkip()
End 

aCols[1][nUsado+1] := .F.
dbSetOrder(1)

cNum     := NextNumero("SZP",1,"ZP_NUM",.T.) //GetSXeNum("SZP")                                                                                                        
cSolici  := cUserName                                                                                                                       
cEmissao := dDataBase
cSaldoHE := Posicione("SZN",1,xFilial("SZN")+ "2008" + cCC,"ZN_SALDO")
cAprova  := Space(15)
//cSaldoHE := Alltrim (Transform(Posicione("SZN",1,xFilial("SZN")+ "2008" + bCCusto,"ZN_SALDO"),"@E 999,999,999.99" ))

//+--------------------------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2                              ¦
//+--------------------------------------------------------------+
nLinGetD := 0
//+--------------------------------------------------------------+
//¦ Titulo da Janela                                             ¦
//+--------------------------------------------------------------+
cTitulo  := "Hora Extra"
//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho do Modelo 2      ¦
//+--------------------------------------------------------------+
aC:={}

aAdd( aC, {"cNum"     , {15, 010} ,"Documento"    ,"@e " ,,,.f.})
aAdd( aC, {"cSolici"  , {15, 100} ,"Solicitante"  ,"@e " ,,,.f.})
aAdd( aC, {"cEmissao" , {15, 300} ,"Emissão"      ,"@e " ,,,.f.})
aAdd( aC, {"cAprova"  , {30, 010} ,"Aprovador"    ,"@e " ,,'ZP ',.t.})
aAdd( aC, {"cSaldoHE" , {30, 150} ,"Saldo Horas"  ,"@e " ,,,.f.})

//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Rodape do Modelo 2         ¦
//+--------------------------------------------------------------+

aR:={}

aAdd(aR,{"N_Horas",{105,100},"Total: ","@E 999,999,999.99" ,,,.F.})
aAdd(aR,{"N_Saldo",{105,250},"Saldo: ","@E 999,999,999.99" ,,,.F.})

//+--------------------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2                 ¦
//+--------------------------------------------------------------+

aCGD := {70,5,100,315}

//+--------------------------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2                           ¦
//+--------------------------------------------------------------+

cLinhaOk := "ExecBlock('SZPLinOK')"
cTudoOk  := "ExecBlock('SZPTudOk')"

//
//Criando arquivo Temporário para inclusão dos percentuais do Fcost **/
//
aStru:={}

ChaveI:="ZX_DOC+ZX_MAT "
aAdd( aStru, { "ZX_FILIAL", "C", 2, 0})
aAdd( aStru, { "ZX_DOC",    "C", 6, 0})
aAdd( aStru, { "ZX_MAT",    "C", 6, 0})
aAdd( aStru, { "ZX_CCUSTO", "C", 9, 0})
aAdd( aStru, { "ZX_PORCH",  "N", 6, 2})
aAdd( aStru, { "ZX_DATA",   "D", 8, 0})

cArqTrab := CriaTrab(aStru, .T.)
USE &cArqTrab ALIAS TRX NEW
INDEX ON &ChaveI TO &cArqTrab

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{40,10,500,800})
                                                   	
If lRetMod2
	ConfirmSX8()
	For X:=1 to len(aCols)
		if !(aCols[x][len(aHeader)+1])

			dbSelectArea("SZP") 
			RecLock("SZP",.T.)
		    ZP_FILIAL  := xFilial()
		    ZP_STATUS  := " "
		    ZP_NUM     := cNum        
	  	    ZP_CC      := Posicione( "SRA", 1, xFilial("SRA") + aCols[X][2], "RA_CC")       
	  	    ZP_ITEM    := aCols[X][01] 
		    ZP_MAT     := aCols[X][02]
  		    ZP_NOME    := aCols[X][03]
		    ZP_HORAINI := aCols[X][04]
		    ZP_HORAFIM := aCols[X][05]
		    ZP_HORA    := aCols[X][06]
		    ZP_DATA    := aCols[X][07]
		   	ZP_FCOST   := aCols[X][08]
		   	ZP_ROTA    := aCols[X][09]
		   	ZP_INV     := aCols[X][10] 
		   	ZP_ATIVID  := aCols[X][11] 
		   	ZP_EMISSAO := dDataBase
		   	ZP_USER    := Usuario
			ZP_CODAPRO := cAprova
		   	MsUnlock()
		    IFcost := {}
		    If Upper(aCols[X][8]) = "S"
			   	dbSelectArea("TRX")
				dbSetOrder(1)     
				
				Chave := cNum + aCols[X][2]
				
				If dbSeek(Chave)  	
					While TRX->ZX_DOC+TRX->ZX_MAT=Chave 
						
						dbSelectArea("SZX")	
						RecLock("SZX",.T.)
					   	
					   	SZX->ZX_DOC    := TRX->ZX_DOC
					   	SZX->ZX_MAT    := TRX->ZX_MAT
				        SZX->ZX_DATA   := TRX->ZX_DATA
				    	SZX->ZX_CCUSTO := TRX->ZX_CCUSTO
				    	SZX->ZX_PORCH  := TRX->ZX_PORCH
						
						MsunLock()

						DescC := AllTrim( TRX->ZX_CCUSTO) + "-" + AllTrim( Posicione("CTT", 1, xFilial("CTT") + TRX->ZX_CCUSTO, "CTT_DESC01"))
					    aAdd( IFcost, {DescC, Transform( StrTran(StrZero(TRX->ZX_PORCH,5,2),".",""),"@R 999.99%" ) })
						DbSelectArea("TRX")
						DbSkip()
					End	
		    	Endif 
		     EndIf

			 dbSelectArea("SZP")
			 
			 xDataHE  := SubStr( Dtos(ZP_DATA),7,2) + "/" + SubStr(Dtos(ZP_DATA),5,2)+ "/" + SubStr( Dtos(ZP_DATA),3,2) 
			 xHoraIni := Transform( StrTran( StrZero(ZP_HORAINI,5,2),".",""),"@R !!:!!" ) 
			 xHoraTer := Transform( StrTran( StrZero(ZP_HORAFIM,5,2),".",""),"@R !!:!!" )
			 xHoraGas := Transform( StrTran( StrZero(ZP_HORA,5,2)   ,".",""),"@R !!:!!" )
		     
		     aAdd( aSHE, {ZP_NUM, ZP_ITEM, xDataHE, ZP_MAT, ZP_NOME, ZP_CC, xHoraIni, xHoraTer, xHoraGas, cSolici, ZP_FCOST})
		     For j:=1 to Len(IFcost)
		     	aAdd(aShe,{"","","","",IFcost[j][1],"","","",IFcost[j][2],"",""})
		     Next 
        EndIf
    Next
    //
    // Obtendo Dados do usuário 
	//
	If !Empty(cAprova)
	
	   cTo := AllTrim( UsrRetMail(alltrim(cAprova)))+';'+ alltrim(UsrRetMail(__cUserId))
	   nOpcao := 1  // inclusao
	   EnviaEmail(nOpcao,cTo)	
	   
       codRot:="HEXTRA"
       cEmUser := u_MontaRec(CodRot)
       If Empty(cEmUser)
          Alert("Não há e-mail do RH cadastrado. Comunique imediatamente ao T.I:  ")
       Else
          EnviaEmail(nOpcao,cEmUser)
       Endif
	Else
	   Alert("Campo Aprovador Invalido!!")
	   cTo := alltrim(UsrRetMail(__cUserId))
	   nOpcao := 4  // problema
	   EnviaEmail(nOpcao,cTo)
	Endif                   
	
Else
    RollBackSx8()
	Sai := .f.
Endif

dbSelectArea(cAlias)
dbGoto(cRecno)
dbSelectArea("TRX")
dbCloseArea()

Return

/***********************************************************************************/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Validação de Confirmação no Cadastro das Hora Extras³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
User Function SZPLinOK 
Local lRet   := .T.
Local a_Area := GetArea()       

if !(aCols[n][len(aHeader)+1])
	
    if lPadrao
    	aCols[n][7]:=aCols[1][7]
    	aCols[n][11]:=aCols[1][11]
      	M->ZP_DATA:=aCols[1][7]
    Endif
	   	 
	  lRet:= ValidaGrid(lPadrao) ///Validação dos dados do Grid do Hora-Extra
	
	   N_Saldo := 0
	   N_Horas := 0
	   
	   For j:=1 to Len (aCols)
	        N_Horas := SomaHoras(N_Horas,aCols[J][6])
	   Next
	
	   N_Saldo := SubHoras(cSaldoHE,N_Horas)
EndIf
	//RestArea(a_Area)
Return(lRet) 
///***********************************************************************************/
Static Function ValidaGrid()
   

     If !U_ValidHorario(aCols[n][2],aCols[N][7],aCols[n][4],aCols[n][5])
		Return .F.	 	
	 EndIf

	 aCols[N][11]:=IIf(Empty(aCols[N][11]),aCols[1][11],aCols[N][11])			
 	 aCols[N][8]:=aCols[1][8]
/*
 	 If aCols[n][8]=='S' .and. n<>1 //1.  Verifica se o primeiro item é referência para o padrão das demais solicitações. 
   	 	RepFcost(aCols[1][6])                     //2.  Copia os dados do F-Cost
     Elseif aCols[n][8]='N'
        ExcluiRateio (cNum,aCols[n][2])	         //3. Exclui caso exista.    
	 EndIf
  */	 

 	 If lPadrao .and. aCols[n][8]=='S' .and. n<>1 //1.  Verifica se o primeiro item é referência para o padrão das demais solicitações. 
   	 	RepFcost(aCols[1][6])                     //2.  Copia os dados do F-Cost
     Elseif aCols[n][8]='N'
        ExcluiRateio (cNum,aCols[n][2])	         //3. Exclui caso exista.    
	 EndIf

     if n=1
	    if !ValidExtra(aCols[N][2],aCols[N][7],aCols[N][4],aCols[N][5],N) .or. ! LimiteHExtra(aCols[N][2],aCols[N][7],aCols[N][6]) //Hora-extra excedeu o limite
			Return .F.	
        EndIf
      
     EndIf

		aCols[N][4]:=IIf(Empty(aCols[N][4]),aCols[1][4],aCols[N][4])			
		aCols[N][5]:=IIf(Empty(aCols[N][5]),aCols[1][5],aCols[N][5])			
		aCols[N][6]:=DifHoras(aCols[N][4],aCols[N][5])							
		aCols[N][7]:=IIf(Empty(aCols[N][7]),aCols[1][7],aCols[N][7])			
	    aCols[N][10]:=aCols[1][10]

		If ! LimiteHExtra(aCols[N][2],aCols[N][7],aCols[N][6]) //Hora-extra excedeu o limite
			Return .F.	
		EndIF 

	    if !ValidExtra(aCols[N][2],aCols[N][7],aCols[N][4],aCols[N][5],N)
			Return .F.	
	    EndIf 

     If Empty(aCols[n][4]) .or. Empty(aCols[n][5])
		Alert("Falta informar a Hora inicio e a Hora Termino...")
        Return .F.
     EndIf 
     If Empty(aCols[n][11])
		Alert("Falta o motivo da Hora-Extra...")
        Return .F.
     EndIf 
     If aCols[n][8]=='S'
	       BkpAHeader:=aHeader
		   BkpPos    :=n
		   BkpACols  :=aCols 
   		   lRet:=Rateio(aCols[n][2],aCols[n][3],100,acols[n][7])
		   aHeader:=BkpAHeader
		   n   :=BkpPos 
		   aCols:=BkpACols   
   	 EndIf

Return .T.
//
//  .------------------------------------------
// |   Função que replica os dados do F-Cost
//  '------------------------------------------
//
Static Function RepFCost(TotHe)
    Temp:={}

	dbSelectArea("TRX")
	dbSetOrder(1)
	
    // Já existem dados cadastrado de Fcost
	If dbSeek(cNum+aCols[n][2])
		Return 
	EndIF 

    dbSelectArea("TRX")
	Chave:=cNum+aCols[1][2]

	dbSeek(Chave)
	While Chave==TRX->ZX_DOC+TRX->ZX_MAT
 		aadd(Temp,{TRX->ZX_DOC,acols[n][2],TRX->ZX_CCUSTO,aCols[n][7] ,TRX->ZX_PORCH})
        DataHe:=TRX->ZX_DATA
        DbSelectArea("TRX")
        DbSkip()
    End

    If acols[n][6]=TotHe  .and. DataHe==acols[n][7] 
    	For i:=1 to len(Temp) 
			RecLock("TRX",.T.)
	    	TRX->ZX_DOC    := Temp[i][1]
	    	TRX->ZX_MAT    := Temp[i][2]
	    	TRX->ZX_CCUSTO := Temp[i][3]
			TRX->ZX_DATA   := Temp[i][4]
	    	TRX->ZX_PORCH  := Temp[i][5]
			MsunLock()
    	Next
    EndIf
	
Return 
/*************************************************************************************/
/*Função que valida os dados  do grid                                                */
/*************************************************************************************/
Static Function ValidExtra(Mat,DatEx,HrIni,HrFim,Pos)
Local lRet:=.T.
	DbSelectArea("SZP")
	DbSetOrder(4)
    /*Valida o horário conforme o turno de trabalho*/
    If ! U_ValidHorario(Mat,DatEx,HrIni,HrFim)
		Return .F.
    EndIf
	//Verifica se no documento de extra já existe a matrícula 
    if LRet
    	For i:=1 to len(aCols)
   			if !(aCols[i][len(aHeader)+1]) 	
                 if n<>i
                     if acols[i][2]=Mat .and. acols[i][7]=DatEx  .and. ( (acols[i][4] >=HrIni .and.  acols[i][5] <=HrFim) .or. (  (acols[i][4] <=HrIni .and.  acols[i][5] >=HrFim) .and. HrFim-Hrini>0 ))
						Alert("Já existe nessa hora-extra a matricula desse funcionário para este horario")
						lRet:=.F.
						Exit
	 				 EndIF
 				Endif 
   			Endif 
    	Next 
    Endif             
Return LRet
/*************************************************************************************/
/* Valida o horário com o Turno de Trabalho
/*************************************************************************************/

User  Function ValidHorario(Mat,DataHe,HrIni,HrFim) ///Valida o horário conforme o turno de trabalho
Local lRet,lDiaUtil
 CodTurno:=Posicione("SRA",1,xFilial("SRA")+MAT,"RA_TNOTRAB") 
 ACusto:=Posicione("SRA",1,xFilial("SRA")+MAT,"RA_CC") //Centro de Custo da Manutenção não entra nas regras.
 DiaN:=DOW(DataHe) 
 lRet:=.T.                 
 lDiaUtil:=DiaUtil(DataHe)
 Chave:=xFilial("SPJ")+CodTurno+'01'+Alltrim(Str(DiaN))//Filial+Turno+(01)SemanaFixo+Dia em Numero

 If lDiaUtil
	 DbSelectArea("SPJ")
	 If DbSeek(Chave) 	
	 	If	(SPJ->PJ_SAIDA2 >= HrIni .and. SPJ->PJ_ENTRA1 < HrIni ) .and.  SPJ->PJ_TPDIA='S'  //Horario de trabalho normal 
        //Analisar e atualizar o bloco de código
	 		Alert("Horário de início pertence ao horário de trabalho do Funcionário" ) 
		    lRet:=.F.	//aglai temporario
	 	EndIf 
     EndIF 
 Else
	//007 Turno da impressao que é no domingo
    //Não valida se for RH ou Manutenção         
  
   If Alltrim(ACusto) #"128" .and. Alltrim(ACusto) #"614" .and. Alltrim(cCCSoli)#'124' .and. Alltrim(CodTurno)#'007' .and. xFilial("SRA")#'02' //C Custos da Manutenção  
      Alert("Pela legislação não é permitida Hora-Extra nos domingos e feriados" )
      lRet:=.F.
   EndIf  
    	
 EndIf

Return  lRet           
/*************************************************************/
Static Function LimiteHExtra(Mat,DataHe,TotHoras)
 Local lRet:=.T.

 If ! DMaxHe(DataHe)  
	lRet:=.F.
	Return lRet    
 EndIf 

 CodTurno:=Posicione("SRA",1,xFilial("SRA")+MAT,"RA_TNOTRAB") 
 aCusto:=Posicione("SRA",1,xFilial("SRA")+MAT,"RA_CC")
 DiaN:=DOW(DataHe) 
 lDiaUtil:=DiaUtil(DataHe)
 SomaHoras:=0

 Chave := xFilial("SPJ")+CodTurno+'01'+Alltrim(Str(DiaN)) // Filial + Turno+(01) SemanaFixo + Dia em Numero
 dbSelectArea("SPJ")
 dbSeek(Chave)
 DifHoras := 24-TotHoras   
 If SPJ->PJ_TPDIA $'CD' .or. !lDiaUtil
   //Manutenção e RH não valida
    If DifHoras<=11 .and. Alltrim(Acusto)#"128".and. Alltrim(Acusto)#"614" .and. Alltrim(cCCSoli)#'124'
	    Alert('O limite de horas de extras é de 13 horas ! ')
		lRet:=.F.
	EndIf	
 Else 
    If aCols[n][10]='S' 
        //Manutenção e RH não valida
    	If DifHoras<=11 .and. Alltrim(Acusto)#"128" .and. Alltrim(Acusto)#"614" .and. Alltrim(cCCSoli)#'124' .and.  (Acusto)#"126" 
	    	Alert('O limite de horas de extras é de 13 horas ! ')
			lRet:=.F.
		EndIf
    EndIf
    //Manutenção e RH não valida
   if TotHoras >2.15 .and. lDiaUtil .and. Alltrim(Acusto)#"128" .and. Alltrim(Acusto)#"614" .and.  Alltrim(cCCSoli)#'124' .and. SPJ->PJ_TPDIA='S' .and. (Acusto)#"126" .and. aCols[n][10]='N'
	    Alert('O limite de horas de extras é de 2:15 horas ! Verifique com a sua gerência ou RH.  ')
    	lRet:=.F.
    EndIF 
 EndIf

Return lRet                 
/***************************************************************************/
//Função de limite máximo pra fazer extras em atraso.
/***************************************************************************/
Static Function DMaxHe(DataHe) 

//Por definição a hora-extra pode ser feita com até 48 horas da realização.

AuxD:=DataHe
lRet:=.T.
If DOW(AuxD)=6
 	AuxD+=4	
Else 
	AuxD+=2
EndIf 

Ano:=Substr(Dtos(AuxD),1,4)
Mes:=Substr(Dtos(AuxD),5,2)


DbSelectArea("RCG")
DbSetOrder(1)
if DbSeek(xFilial("RCG")+Ano+Mes)
	While !Eof()
           //For sábado ou domingo            ou se O dia for feriado//////      
		If (DOW(AuxD)= 1 .or. DOW(AuxD)= 7) .or. ( RCG->RCG_DIAMES=AuxD .and. RCG->RCG_TIPDIA $ '4')     //Sabado ou Domingo 
			AuxD:=AuxD+1
		Else
          If RCG->RCG_DIAMES=AuxD 
			Exit
		  EndIf	
		EndIf 
		DbSelectArea("RCG")
		DbSkip()
	EndDo

EndIf

/*
if Date()>AuxD  .and. CCCSoli#'126'.and. Alltrim(aCols[n][2])#'000153'
  Alert ("Data extrapola o limite de 2 dias úteis para solicitação de hora-extra. Verifique com o Rh!!")
  lRet:=.F.	
End
*/
Return lRet
//
//
//
Static Function DiaUtil(DataHe)

lRet:=.T.
AuxD:=Dtos(DataHe)
Ano := SubStr( DtoS(DataHe), 1, 4)
Mes := SubStr( DtoS(DataHe), 5, 2)

dbSelectArea("RCG")
dbSetOrder(1)

If dbSeek( xFilial("RCG") + Ano + Mes)
	While !Eof()
		If Dtos(RCG->RCG_DIAMES)=AuxD
			If RCG->RCG_TIPDIA $ '34' // NÃO TRABALHADO 2 / DSR 3 OU FERIADO 4
				lRet:=.F.
			EndIf
			Exit
		EndIf
		DbSelectArea("RCG")
		DbSkip()
	EndDo
EndIf

Return lRet
//
//  .------------------------------
// |   Exclui os dados do Rateio
//  '------------------------------
//
Static Function ExcluiRateio (cNum,Matr)
	DbSelectArea("TRX")
	DbSetOrder(1)
	Chave:=cNum+Matr
	DbSeek(Chave)
	While Chave==TRX->ZX_DOC+TRX->ZX_MAT
		RecLock("TRX",.F.)
		dbDelete()
		MsunLock()
		DbSelectArea("TRX")
		DbSkip() 
	End      
Return 
//  .----------------------------------------------------
// |   Função: Tela de Detalhamento da tela de F-Costa
//  '----------------------------------------------------
Static Function Rateio(uMat,uNome,TotHE,DatHe) 
Local RetR:=.F.
Private TotH:=0,SomH:=0

//¦ Opcao de acesso para o Modelo 2                              ¦
//+--------------------------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza 

aSHE   := {}
DataHe := DtoS(DatHe)
Matr   := uMat
Nome   := uNome
TotH   := TotHE
Saldo  := TotHE

//+--------------------------------------------------------------+
//¦ Montando aHeader                                             ¦
//+--------------------------------------------------------------+

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZX")
nUsado  := 0                                        
aHeader := {}    

While !Eof() .and. (x3_arquivo == "SZX")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>2 .and. (X3_CAMPO='ZX_CCUSTO' .or. X3_CAMPO='ZX_PORCH')
		nUsado++
		AADD(aHeader,{TRIM(X3_TITULO),;
		X3_CAMPO,;
		X3_PICTURE,;
		X3_TAMANHO,;
		X3_DECIMAL,;
		.F.,;
		X3_USADO,;
		X3_TIPO,;
		"TRX",;
		X3_CONTEXT})
	Endif
	dbSkip()
End
//+--------------------------------------------------------------+
//¦ Montando aCols                                               ¦
//+--------------------------------------------------------------+
aCols := Array(1,nUsado+1)    // campos
dbSelectArea("SX3")
dbSeek("SZX")
nUsado := 0
While !Eof() .and. (X3_ARQUIVO == "SZX")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>2 .and. (X3_CAMPO='ZX_CCUSTO' .or. X3_CAMPO='ZX_PORCH')
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
	aCols[1][nUsado+1] := .F.
	dbSkip()
End

//+--------------------------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2                           ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2                              ¦
//+--------------------------------------------------------------+

dbSelectArea("TRX")       
dbSetOrder(1)     
dbGotop()        

Chave := cNum + Matr

If DbSeek(Chave)  	
    aCols:={}             
    SomH:=0
	While Chave==TRX->ZX_DOC+TRX->ZX_MAT .and. !Eof()
    	AAdd(aCols,{TRX->ZX_CCUSTO,TRX->ZX_PORCH,.F.})
		SomH+=TRX->ZX_PORCH
		Saldo:= TotHe-SomH		
		DbSelectArea("TRX")
		DbSkip() 
	End
Endif	

@ 10,10 TO 300,400 DIALOG oDlg1 TITLE "Divisão do Fcost"

@ 10,10 SAY "Matricula:"+uMat
@ 20,10 SAY "Nome     :"+uNome

@ 40,10 TO 100,200 MULTILINE MODIFY DELETE VALID LineOkSZX(.F.)   

@ 110,100 SAY "Saldo :" 
@ 110,120 GET Saldo  Size 017, 010 When .F. PICTURE "@R 999.99%" 

@ 110,10 Say "Total :"
@ 110,40 Get SomH  Size 017, 010 When .F.PICTURE "@R 999.99%" 	

@ 120,50 BUTTON "C_onfirma" SIZE 40,15 ACTION ConfRateio()
@ 120,100 BUTTON "_Cancela"  SIZE 40,15 ACTION CancRateio ()
ACTIVATE DIALOG oDlg1 CENTERED

If SomH=TotHe
	RetR:=.T.
Else
	RetR:=.F.//Há diferenças
EndIf 

dbSelectArea(cAlias)
dbGoto(cRecno)
Return RetR
//
//
//
/*************************************************************************************/
/*Função de Confirmação do Cadastro do Rateio
/*************************************************************************************/
Static Function ConfRateio() 
Local lRet:=.T.
//*Localiza as informações já existentes em arquivo e exclui****/
       
TotHe:=100
If SomH<TotHe
	Alert('Total de horas do F-Cost menor que o informado.')
  	lRet:=.F.
Endif

if lRet 
	DbSelectArea("TRX")
	DbSetOrder(1)
	Chave:=cNum+Matr
	DbSeek(Chave)
	While Chave==TRX->ZX_DOC+TRX->ZX_MAT
		RecLock("TRX",.F.)
		dbDelete()
		MsunLock()
		DbSelectArea("TRX")
		DbSkip() 
	End      
	For i:=1 to len(aCols)
		if !(aCols[i][len(aHeader)+1] ) .and. !Empty(aCols[i][1])
			RecLock("TRX",.T.)                                                        
	    	TRX->ZX_DOC:=CNum
	    	TRX->ZX_MAT:=Matr
	    	TRX->ZX_CCUSTO:=aCols[i][1]//CCusto 
			TRX->ZX_DATA:=sTod(DataHe)
//	    	TRX->ZX_HORA:=aCols[i][2] //Horas
			TRX->ZX_PORCH:=aCols[i][2]
			MsunLock()
		EndIf 	
	Next  
	Close(oDlg1)
EndIf
Return lRet
//
//
//
Static Function CancRateio()

lRet:=.T.
If len(aCols)=0 
   Alert("Se FCost='S', deve-se informar ao menos um c.custo") 	
   lRet:=.F.
EndIf 
If lRet 
	Close(oDlg1)
EndIf
Return 
//
//
//
Static Function LineOkSZX(Tipo) 
Ret:=.T.      
SomH:=0

If Empty(aCols[n][1])
	Alert('Centro de Custos obrigatorio')
 	Ret:=.F.
	
EndIf

For i:=1 to Len(aCols)   	
	If !(aCols[i][Len(aHeader)+1])
		SomH+=aCols[i][2]         
	EndIf		
Next 
//If SomH>TotHe
If SomH>TotH
	Alert('Total de horas maior que o informado')
 	Ret:=.F.

Endif                    

Saldo:= TotH-SomH                  

If !(Tipo)
	@ 110,120 Get Saldo  Size 017, 010 When .F. PICTURE "@R 999.99%" 
	@ 110,40 Get SomH  Size 017, 010 When .F. PICTURE "@R 999.99%" 
Else 
    @ 210,100 Say "Saldo :"
	@ 210,120 Get Saldo  Size 017, 010 When .F. PICTURE "@R 999.99%" 
	@ 210,10 Say "Total :"
	@ 210,40 Get SomH  Size 017, 010 When .F.  PICTURE "@R 999.99%" 
EndIf

Return Ret
//
//
//
User Function SZPTudOk

Local Ret   := .T.
Local a_Area := GetArea()

If Empty(cAprova) 
   
   MsgStop('Campo Aprovador em Branco...Informe um aprovador!!')
   Ret   := .f.

Endif

RestArea(a_Area)
Return(Ret) 
 
//  .------------------------------------
// |   Fim da validação de confirmação
//  '------------------------------------
       
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ HrGastas ºAutor ³Jefferson Moreira    º Data ³  06/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo de Horas Gastas da rotina..                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ aCols                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
   
User Function HrGastas 
Local lRet   := .T.
Local a_Area := GetArea()

 If !Empty(aCols[n][4])
    If M->ZP_HORAFIM < aCols[n][4]
       tHora1:= SUBHORAS(24,aCols[n][4]) 
       xHora := SOMAHORAS(M->ZP_HORAFIM,tHora1) 
    Else
       xHora := SUBHORAS(M->ZP_HORAFIM,aCols[n][4])
    Endif
    
    IF xHora > 6 
       aCols[n][6]:= SUBHORAS(xHora,1.00)
    Elseif  xHora > 12 
       aCols[n][6]:= SUBHORAS(xHora,2.00)
    Else   
      aCols[n][6]:= xHora
    Endif
 Endif   

RestArea(a_Area)
Return(lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ HrNome   ºAutor ³Jefferson Moreira    º Data ³  07/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o Nome do Funcionario que fara Hora Extra..        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ aCols                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/      
User Function HrNome 
Local lRet   := .T.
Local a_Area := GetArea() 

//  M->ZP_MAT:=STRZERO(M->ZP_MAT,6)
  cMat:=STRZERO(Val(M->ZP_MAT),6)
  if VAL(cMat) > 008000
     
    cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA FROM SRA020 WHERE D_E_L_E_T_='' AND  RA_MAT = '" +cMat+ "'
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRA New 
    dbSelectArea("TRA")
    If !Empty(RA_DEMISSA)
       Alert(" Funcionario desligado...Informe outra matricula...") 
       lRet   := .F.
    Else
    if Empty(RA_NOME)
       MsgStop("Matricula Invalida!!")
       lRet   := .F.
    Else
    aCols[N][2] := cMat
    aCols[N][3] := RA_NOME
    Endif   
    Endif
  Else
    cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA FROM SRA010 WHERE D_E_L_E_T_=''  AND  RA_MAT = '" +cMat+ "'
    Query := ChangeQuery(cQuery)
    TCQUERY cQuery Alias TRA New 
    dbSelectArea("TRA")
    If !Empty(RA_DEMISSA)
       Alert(" Funcionario desligado...Informe outra matricula...") 
       lRet   := .F.
    Else
    if Empty(RA_NOME)
       Alert("Matricula Invalida!!")
       lRet   := .F.
  //  Elseif alltrim(RA_CC) <> cCCSoli
  //     Alert("funcionario não pertence ao Centro de Custo solicitado...")
  //     lRet   := .F.
    Else
    aCols[N][2] := cMat
    aCols[N][3] := RA_NOME
  //  aCols[N][3] := RA_CC
    Endif   
    Endif
  Endif
dbCloseArea("TRA")
dbCloseArea()
RestArea(a_Area)
Return(lRet)                                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ HEAprov  ºAutor ³Jefferson Moreira    º Data ³  10/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de Aprovracao de Hora Extra..                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Browser                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

User Function HEApro()
                                      

Local _cFiltro   	:= ''
Local aCampos := { {'ZP_STATUS' ,,''}}
Private	_bFiltraBrw	:= ''
Private _aIndexSZP 	:= {}
Private cMarca  := GetMark()

Private cCadastro := "Hora Extra"
Private aRotina := { {"Pesquisar" ,"AxPesqui"    ,0,1} ,;
                     {"Visualizar","U_VisuaHE"    ,0,2} ,;
                     {"Aprovar"   ,"U_HEAprProc" ,0,3} ,;
                     {"Cancelar" ,"U_HEPosProc" ,0,4  }}
Private InfUser:={}
xUserVali := __cUserId

if  !xUserVali $ CodGeR
   Alert("Usuario sem acesso para aprovação...")
   Return 
Endif  

dbSelectArea("SZP")
dbSetOrder(1)   

_cFiltro  := " (Empty(ZP_STATUS) .or. ZP_STATUS='4') .and. ALLTRIM(ZP_CODAPRO)='"+ALLTRIM(xUserVali)+"' "
_bFiltraBrw := {|| FilBrowse("SZP",@_aIndexSZP,@_cFiltro) }

Eval(_bFiltraBrw)

MARKBROW( 'SZP', 'ZP_OK')
EndFilBrw("SZP",_aIndexSZP)

Return
//
//
//
User Function HEAprProc()
   RptStatus( {|lFim| AproProcess( ) }, "Hora Extra" )
Return
//
//
//
User Function HEPosProc()
//   RptStatus( {|lFim| PostProcess( ) }, "Hora Extra" )
Return
//
//  .--------------------------------------
// |   Rotina de Aprovação de Hora-Extra
//  '--------------------------------------
//

Static Function AproProcess

aSHE := {}
nOpcao := 2
Flag := .t. 

dbSelectArea("SZP")
dbSetOrder(1)
dbgotop()

While !Eof()

      If !Empty(ZP_OK) .and. (ZP_STATUS == " "  .or. ZP_STATUS == "4") // ==  cMarca
	    RecLock('SZP',.F.)
	    Replace SZP->ZP_STATUS	With '1' 
	 	Replace SZP->ZP_DTAPROV	With dDataBase
	    Replace SZP->ZP_APROV	With cUserName
		MsUnLock()
		
		xDataHE := Subs( DtoS(ZP_DATA),7,2) + "/" + Subs(Dtos(ZP_DATA),5,2)+ "/" + Subs(Dtos(ZP_DATA),3,2) 
     	xHoraIni:= Transform( StrTran( StrZero(ZP_HORAINI, 5, 2), ".", ""), "@R !!:!!" ) 
	    xHoraTer:= Transform( StrTran( StrZero(ZP_HORAFIM, 5, 2), ".", ""), "@R !!:!!" )
	    xHoraGas:= Transform( StrTran( StrZero(ZP_HORA,    5, 2), ".", ""), "@R !!:!!" )

		PswOrder(1)
        EmailUser:=""

	    If PswSeek( SZP->ZP_USER, .T. ) 
			aInfoUser := pswret()
	        EMailUser:=AllTrim(aInfoUser[1][14])        
	    EndIf     
	    
        aAdd(aSHE, { ZP_NUM, ZP_ITEM, xDataHE, ZP_MAT, ZP_NOME, ZP_CC, xHoraIni, xHoraTer, xHoraGas, ZP_APROV, ZP_FCOST, ZP_ROTA, EmailUser})
		If Flag
		   cWhoAmI := ZP_USER
		   Flag := .f.
		Endif   		
	  EndIf
	
      dbSkip()
      Loop
Enddo

aSort(aShe,,,{|x,y| x[13] < y[13]})

ExtraApro:=aShe

//  .-----------------------------------------------------------------
// |   Rotina que Envia o e-mail de Aprovação para cada solicitante
//  '-----------------------------------------------------------------

If Len(ExtraApro)>0
	EmailUser:=ExtraApro[1][13]
	aShe:={}
	For i:=1 To Len(ExtraApro)
		asort(aShe,,,{|x,y| x[3]+x[6] <  y[3]+y[6] })
		if EmailUser=ExtraApro[i][13]
			AAdd(aShe,{array(12)})
			aShe[len(aShe)]:=ExtraApro[i]//[13]
	    Else
	        EnviaEmail(nOpcao,EmailUser)
			Alert("E-mail enviado para o e-mail:  "+ EmailUser)
	    	EmailUser:=ExtraApro[i][13]
	    	aShe:={}
		Endif
	Next
	EnviaEmail(nOpcao,EmailUser)
EndIf

//  .------------------------------------------
// |   Rotina para enviar o e-mail para o RH
//  '------------------------------------------
aShe   := {}           
CodRot := "HEXTRA"
aShe   := ExtraApro
asort(aShe,,, {|x,y| x[3]+x[6] <  y[3]+y[6] })

cEmUser:=u_MontaRec(CodRot)

If Empty(cEmUser)
   Alert("Não há e-mail do RH cadastrado. Comunique imediatamente ao T.I:  ")
Else
   EnviaEmail(nOpcao,cEmUser)
Endif

CloseBrowse()
Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PostProcessºAutor ³Jefferson Moreira    º Data ³  10/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de nao aprovacao de Hora Extra..                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Browser                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function PostProcess 

aSHE := {}
nOpcao := 3
Flag := .t.
dbSelectArea("SZP")
dbSetOrder(1)
dbgotop()
While !EOF()
//MSGSTOP(ZP_OK +'-'+ cMarca) 
      If !Empty(ZP_OK) .and. ZP_STATUS == " "// ==  cMarca
	    RecLock('SZP',.F.)
	    Replace SZP->ZP_STATUS	With '3' 
	    Replace SZP->ZP_DTAPROV	With dDataBase
	    Replace SZP->ZP_APROV	With cUserName
		MsUnLock()
		
		xDataHE := Subs(Dtos(ZP_DATA),7,2) + "/" + Subs(Dtos(ZP_DATA),5,2)+ "/" + Subs(Dtos(ZP_DATA),3,2) 
     	xHoraIni:= Transform(StrTran(StrZero(ZP_HORAINI,5,2),".",""),"@R !!:!!" ) 
	    xHoraTer:= Transform(StrTran(StrZero(ZP_HORAFIM,5,2),".",""),"@R !!:!!" )
	    xHoraGas:= Transform(StrTran(StrZero(ZP_HORA,5,2)   ,".",""),"@R !!:!!" )
        AAdd(aSHE,{ZP_NUM,ZP_ITEM,xDataHE,ZP_MAT,ZP_NOME,ZP_CC,xHoraIni,xHoraTer,xHoraGas,ZP_APROV,ZP_FCOST,ZP_ROTA})
		if Flag
		   cWhoAmI := ZP_USER
		   Flag := .f.
		Endif  
				
	  EndIf
	
      dbSkip()
      Loop
Enddo

// Obtendo Dados do usuário 
     
PswOrder(1)
If PswSeek(cWhoAmI,.t.)
   _DadUser :=PswRet(1,1)
   cNmUser := _DadUser[1,2] // Nome
   cEmUser := rtrim(_DadUser[1,14])   // email

   IF Empty(cEmUser)
      Alert("Não há e-mail cadastrado para esse usuario:  "+ cNmUser)
   Else 
      EnviaEmail(nOpcao,cEmUser)
   Endif
Else 
   Alert("Solicitante nao encontrado")
Endif
CloseBrowse()

Return  

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Coletor de informações                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function Coleta() 

DbSelectArea("CTT")
DbSetOrder(1)
    IF dbSeek(xFilial("CTT")+cCCusto)    
       cDesc  := CTT_DESC01
    ELSE
       Alert(" Centro de Custo invalido... ")
    Endif

Return 

Static Function ValidaData
 
 If cData < dDataBase
    Alert(" Data da Hora Extra menor que a data de emissão...")
 Endif
 
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ HELeng   ºAutor ³Jefferson Moreira    º Data ³  06/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Lengenda da rotina..                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HELeng()
Local	aLegenda  := {	{'BR_AZUL',    'Aberto'             },;
						{'ENABLE',     'Aprovado'           },;
						{'DISABLE',    'Realizado'          },;
						{'BR_AMARELO', 'Nao houve Aprovacao'},;
						{'BR_PRETO',   'Postergado'}        }
						
BrwLegenda(cCadastro,'Legenda',aLegenda)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  |EnviaEmail ³Jefferson Moreira           ºData ³  03/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ENVIO DE E-MAILs de resposta.                              º±±
±±º          ³ Esta funcao envia um e-mail para o usuario que solicitou.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA  ³  MOTIVO                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³           ³                                                º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//************************************************************/
Static Function  EnviaEmail(_nOpcao,_cTo)
    oProcess := TWFProcess():New( "000001", "Envia Email" )
    oProcess :NewTask( "100001", "\WORKFLOW\SSI.HTM" )
    Do Case
    Case _nOpcao == 1
         oProcess :cSubject := "Solicitação de Hora Extra"
    Case _nOpcao == 2
         oProcess :cSubject := "Aprovado - Solicitação de Hora Extra"
    Case _nOpcao == 3
         oProcess :cSubject := "Postergado - Solicitação de Hora Extra" 
    Case _nOpcao == 4
         oProcess :cSubject := "Problemas SHE - Não enviou o e-mail para aprovacao"    
    EndCase
    oHTML    := oProcess:oHTML 
         
    cMen := " <html>"
    cMen += " <head>"
    cMen += " <title></title>"
    cMen += " </head>"    
    cMen += " <body>"
    cMen += ' <table border="1" width="800">'
    cMen += ' <tr width="600" align="center" >'
    Do Case
    Case _nOpcao == 1 .or. _nOpcao == 4
         cMen += ' <td colspan=10 > Solicitação de Horas Extra - '+ aSHE[1][1] +'</td></tr>' 
    Case _nOpcao == 2 .OR. _nOpcao == 3
         cMen += ' <td colspan=12 > Solicitação de Horas Extra </td></tr>' 
    EndCAse     
    cMen += ' <tr >'
    Do Case
       Case _nOpcao == 2 .OR. _nOpcao == 3
         cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Doc         </font></td>'  //[1]
    EndCAse
   // cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Doc         </font></td>'  //[1]
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">Item        </font></td>'  //[2]
    cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Data        </font></td>'  //[3]
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">Matricula   </font></td>'  //[4]
    cMen += ' <td align="center" width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">Nome        </font></td>'  //[5]
    cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">C.C         </font></td>'  //[6] 
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Inicio      </font></td>'  //[7]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Termino     </font></td>'  //[8]
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Duração     </font></td>'  //[9]
    Do Case
    Case _nOpcao == 1 .or. _nOpcao == 4
         cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Solicitante </font></td>'  //[10]
    Case _nOpcao == 2
         cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Aprovador </font></td>'  //[10]
    Case _nOpcao == 3
         cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Desaprovador </font></td>'  //[10]
    EndCase
    
    cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">Fcost       </font></td>'  //[11]
    If _nOpcao == 2 
         cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">Rota   </font></td>'  //[1]
    Endif
    cMen += ' </tr>'
    For x:= 1 to Len(aSHE) 
      cMen += ' <tr>'
      Do Case
       Case _nOpcao == 2 .OR. _nOpcao == 3
         cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][1]+'</font></td>'  //[1]
    EndCAse
   //   cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][1]+'</font></td>'  //[1]
      cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][2]+'</font></td>'  //[2]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][3]+'</font></td>'  //[3]
      cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][4]+'</font></td>'  //[4]
      cMen += ' <td align="left  " width="20%" bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][5]+'</font></td>'  //[5]
      cMen += ' <td align="center" width="3%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][6]+'</font></td>'  //[6] 
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][7]+'</font></td>'  //[7]
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][8]+'</font></td>'  //[8]
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][9]+'</font></td>'  //[9]
      cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][10]+'</font></td>' //[10]
      cMen += ' <td align="center" width="2%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][11]+'</font></td>' //[11]
      If _nOpcao == 2 
         cMen += ' <td align="center" width="5%"  bgcolor="#FFFFFF"><font size="1" face="Times">'+aSHE[x][12]+'</font></td>'  //[1]
      Endif
      cMen += ' </tr>'
    Next 
    cMen += ' </table>'
    cMen += " </body>"
    cMen += " </html>" 
	
	if Len(aSHE) > 0     // Gerencial
	
		oHtml:ValByName("MENS", cMen)
	  	oProcess:cTo  := _cTo
     //   oProcess:cCC  := "keyla.salim@nippon-seikibr.com.br"
  //      oProcess:cBCC := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
		cMailId := oProcess:Start()
/*	
	else
	   IF Alltrim(aSCC[1][9]) == "211"
		
		  oHtml:ValByName("MENS", cMen)
	  	  oProcess:cTo  := "julio@nippon-seikibr.com.br"
//	    oProcess:cCC  := "jmoreira@nippon-seikibr.com.br"
		  cMailId := oProcess:Start()		
		
	   ElseIF Alltrim(aSCC[1][9]) == "221"
		
		  oHtml:ValByName("MENS", cMen)
	      oProcess:cTo  := "clavis@nippon-seikibr.com.br"
	  //  oProcess:cCC  := "jmoreira@nippon-seikibr.com.br"
		  cMailId := oProcess:Start()
		
       EndIf
	Endif
*/

    IF _nOpcao == 1
       Alert("E-mail enviado para aprovação: "+ _cTo)   
    Endif    

 Endif
Return
/*****************************************************************************************************/
/*****************************************************************************************************/
/*Impressao da Hora-extra para assinatura*************************************************************/
/*****************************************************************************************************/
/*****************************************************************************************************/
User Function HEImp() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,AORD,TAMANHO,LIMITE")
SetPrvt("CSTRING,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,TABMES,XTOTINIQ,XTOTINIV,XTOTENTQ")
SetPrvt("XTOTENTV,XTOTSAIQ,XTOTSAIV,XTOTMEDQ,XTOTMEDV,XTOTFINQ")
SetPrvt("XTOTFINV,CCOUNT,_CFLAG,MV_PAR01,MV_PAR02,MV_PAR03")
SetPrvt("MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,LI,M_PAG")
SetPrvt("CDULMES,CMESPRO,CDATINI,CDATANT,CDATIMA,CDATFIN")
SetPrvt("CMES,CMESANO,ADATREF1,NTIPO,CNOMARQ,CORD")
SetPrvt("CCOND,M->TOTGERAL,M->TOT,M->LINHARELATO,M->CODIGO,M->LOCAL")
SetPrvt("CSDOINIV,CSDOENTV,CSDOSAIV,CSDOINIQ,CSDOENTQ,CSDOSAIQ")
SetPrvt("CDATA,CSDOFINQ,CSDOFINV,MCOD,MDESC,MUM")
SetPrvt("MTIPO,MGRUPO,ACM,M->MEDIO")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RelImHE  ³ Autor ³ JEFFERSON MOREIRA     ³ Data ³ 16/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Solicitacao de horas extras                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


titulo    := PADC("RELATORIO DE SOLICITAÇAO DE HORAS EXTRAS",74)
cDesc1    := PADC("Este programa tem como objetivp emitir o relatorio de solicitaçao ",74)
cDesc2    := PADC("de Horas Extras,conforme especificados em Parametros.",74)
cDesc3    := ""
aORD      := {}//{"OP","PRODUTO","RECURSO"}
tamanho   := "G" // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
//limite    := 132
//limite    := 120
limite    := 220
cString   := "SZP"
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Contabilidade", 2, 2, 1, "",1 }
nomeprog  := "RelImHE"
nLastKey  := 0
cPerg     := "SHEPAR"
m_pag     := 01


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                           ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³   mv_par01  - Da Data ?                                                        ³
//³   mv_par02  - Ate a Data ?                                                     ³
//³   mv_par03  - Do Doc ?                                                         ³
//³   mv_par04  - Ate o Doc ?                                                      ³
//³   mv_par05  - Da Matricula ?                                                   ³
//³   mv_par06  - Ate a Matricula ?                                                ³
//³   mv_par07  - Do CCusto ?                                                      ³
//³   mv_par08  - Ate o CCusto ?                                                   ³
//³                                                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "RelImHE"

wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]
cbtxt  := Space(10)
cbcont := 00
li     := 0
 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   titulo := " SOLICITAÇÃO DE HORAS EXTRAS "
   cabec1 := "IT   Matri   Nome                            Hora   Hora   Duração Data da    Centro FCost Rota         Assinatura do"  
   cabec2 := "                                             Inicio Final          Hr Extra   Custo                      Funcionario"
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20


If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
CondF:="" 
if mv_par09 = 1 
	CondF+=" AND ZP_FCOST in('S','s')
Elseif mv_par09=2 
	CondF+=" AND ZP_FCOST in('N','n')
Endif 



CQuery:="  SELECT ZP_NUM,ZP_ITEM,ZP_STATUS,ZP_MAT ,ZP_NOME,ZP_HORAINI,ZP_HORAFIM,"
CQuery+=" ZP_HORA ,ZP_DATA  ,ZP_CC       ,ZP_FCOST ,ZP_ROTA    ,ZP_OK         ,ZP_HORAE,"
CQuery+=" ZP_DTAPROV,ZP_EMISSAO ,ZP_USER        ,ZP_APROV      ,ZP_HRINI,ZP_DATFIM,ZP_HRFIM,ZP_DATINI,RA_BAIRRO,RA_COMPLEM,RA_TELEFON,RA_ROTA "
CQuery+=" FROM SZP010 AS SZP, SRA010 AS SRA "
CQuery+="  WHERE  SZP.D_E_L_E_T_='' AND SRA.D_E_L_E_T_='' "
cQuery+="  AND ZP_MAT=RA_MAT "
CQuery+="  AND ZP_DATA>='"+Dtos(mv_par01)+"' AND ZP_DATA<='"+Dtos(mv_par02)+"' "
CQuery+="  AND ZP_NUM>='"+mv_par03+"' AND ZP_NUM<='"+mv_par04+"' "
CQuery+="  AND ZP_MAT>='"+mv_par05+"' AND ZP_MAT<='"+mv_par06+"' "
CQuery+="  AND ZP_CC>='"+mv_par07+"' AND ZP_CC<='"+mv_par08+"'"
--cQuery+=" AND ZP_DTAPROV<>'' "                                 
IF  mv_par12 <> '05'
   IF (mv_par12) = '00'
      CQuery+=" AND ZP_STATUS=''"
   else 
      CQuery+=" AND ZP_STATUS = right(mv_par12,1)"
  endif
endif

if mv_par14 <> 1
  CQuery+="AND ZP_INV ='S' "  
ENDIF
cQuery+= CondF
cQuery+=" UNION "
CQuery+="  SELECT ZP_NUM,ZP_ITEM,ZP_STATUS,ZP_MAT ,ZP_NOME,ZP_HORAINI,ZP_HORAFIM,"
CQuery+=" ZP_HORA ,ZP_DATA  ,ZP_CC       ,ZP_FCOST ,ZP_ROTA    ,ZP_OK         ,ZP_HORAE,"
CQuery+=" ZP_DTAPROV,ZP_EMISSAO ,ZP_USER        ,ZP_APROV      ,ZP_HRINI,ZP_DATFIM,ZP_HRFIM,ZP_DATINI,RA_BAIRRO,RA_COMPLEM,RA_TELEFON,RA_ROTA "
CQuery+=" FROM SZP010 AS SZP, SRA020 AS SRA "
CQuery+="  WHERE  SZP.D_E_L_E_T_='' AND SRA.D_E_L_E_T_='' "
cQuery+="  AND ZP_MAT=RA_MAT "
CQuery+="  AND ZP_DATA>='"+Dtos(mv_par01)+"' AND ZP_DATA<='"+Dtos(mv_par02)+"' "
CQuery+="  AND ZP_NUM>='"+mv_par03+"' AND ZP_NUM<='"+mv_par04+"' "
CQuery+="  AND ZP_MAT>='"+mv_par05+"' AND ZP_MAT<='"+mv_par06+"' "
CQuery+="  AND ZP_CC>='"+mv_par07+"' AND ZP_CC<='"+mv_par08+"'"
--cQuery+=" AND ZP_DTAPROV<>'' "

IF  mv_par12 <> '05'
   IF (mv_par12) = '00'
      CQuery+=" AND ZP_STATUS=''"
   else 
      CQuery+=" AND ZP_STATUS = right(mv_par12,1)"
  endif
endif

if mv_par14 <> 1
  CQuery+="AND ZP_INV ='S' "  
ENDIF
cQuery+= CondF

TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
DbGotop()
While !EOF () 
     xDoc := ZP_NUM
     @ li,000        PSAY XDoc
     Li++
     While !Eof() .and.  ZP_NUM == xDoc
		 If (mv_par09=1 .and. ZP_FCOST $'Nn') .or.(mv_par09=2 .and. ZP_FCOST $'Ss')    //Filtra F-Cost estiver com Sim
			DbSelectArea("SZP")		 
			DbSkip()
			Loop
		 EndIF						 	

         @ li,000        PSAY ZP_ITEM
         @ li,PCOL()+2   PSAY ZP_MAT 
         @ li,PCOL()+2   PSAY ZP_NOME
         @ li,PCOL()+2   PSAY Transform(StrTran(StrZero(ZP_HORAINI,5,2),".",""),"@R !!:!!" )
         @ li,PCOL()+2   PSAY Transform(StrTran(StrZero(ZP_HORAFIM,5,2),".",""),"@R !!:!!" )
         @ li,PCOL()+2   PSAY Transform(StrTran(StrZero(ZP_HORA,5,2)   ,".",""),"@R !!:!!" )
//         @ li,PCOL()+3   PSAY Subs(Dtos(ZP_DATA),7,2) + "/" + Subs(Dtos(ZP_DATA),5,2)+ "/" + Subs(Dtos(ZP_DATA),3,2) 
  	     @ li,PCOL()+3   PSAY Stod(ZP_DATA)
//         @ li,PCOL()+3   PSAY ZP_CC Alterado pois o RH pode incluir a extra dos outros departamentos
         @ li,PCOL()+3    PSAY Alltrim(Posicione("SRA",1,xFilial("SRA") + ZP_MAT,"RA_CC"))
         @ li,PCOL()+4   PSAY iif(ZP_FCOST$"S","Sim","Não") PICTURE "@!"
         @ li,PCOL()+3   PSAY iif(ZP_ROTA $"S","Sim","Não")   PICTURE "@!"
         @ li,PCOL()+3   PSAY iif(SZP->ZP_INV $"S","Sim","Não")   PICTURE "@!"

         @ li,PCOL()+3   PSAY Replicate("_",50)
        //Imprime os motivos da hora Extra
        MotivoHE:={}
		Chave:=xFilial("SZP")+TRB->ZP_NUM+TRB->ZP_ITEM
        DbSelectArea("SZP")
        DbSetOrder(1)
        if DbSeek(Chave)
            if mv_par10=1
		        For i:=1 To MlCount(SZP->ZP_ATIVID,56)
					If	! Empty(AllTrim(MemoLine(SZP->ZP_ATIVID,56,i)))
						aAdd(MotivoHE,AllTrim(MemoLine(SZP->ZP_ATIVID,56,i)))
					EndIf
				Next 
			EndIf	
	     Endif     
         Li++

  	     If Li > 69
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	     Endif   
         if Len(MotivoHe)>0
	 	     @ li,001 PSay "-> Atividades a serem efetuadas:"
	 	 EndIF    
         For i:=1 to Len(MotivoHE)
	     	Li++
		    If Li > 69
		         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		    Endif   
			@ li,001 PSay MotivoHE[I]
                
	     Next 
         
         //Imprime os dados do FCost
        if (mv_par11=1 .and. ZP_FCOST $"Ss")
	        DbSelectArea("SZX")       
			DbSetOrder(1)     
			DbGotop()        
			Chave:='  '+TRB->ZP_NUM+TRB->ZP_MAT
			Li++
			If DbSeek(Chave)  	                                                
				@ li,000 PSay "-> Informações do FCost:"
                @ li,Pcol()+4 Psay "Centro de Custo"
                @ li,Pcol()+24 Psay "Duração"
                @ li,Pcol()+5 Psay "Percentual"
                li++
				While Chave==SZX->ZX_FILIAL+SZX->ZX_DOC+SZX->ZX_MAT .and. !Eof()
				   DescC:=Posicione("CTT",1,xFilial("CTT")+SZX->ZX_CCUSTO,"CTT_DESC01")	
             	   Porc :=(SZX->ZX_HORA/TRB->ZP_HORA)*100 	
                   @ li,028 PSay Alltrim(SZX->ZX_CCUSTO)+'-'+Substr(DescC,1,30)
                   @ li,Pcol()+5 PSay Transform(SZX->ZX_HORA,'@E 99.99')
                   @ li,Pcol()+8 PSay Transform(Porc,'@E 999.99%')
  	               Li++
			        If Li > 69
			         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			        Endif   
		                   
				   DbSkip()	
				End
			Endif	

        Endif   
       
         li++
         If Li > 69
 	         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         Endif   
         DbSelectArea("TRB")
         dbSkip()
                                    
     Enddo 
              
     @ li,000      PSAY Replicate("_",limite) 

       li ++
     If Li > 69
 	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     Endif  
Enddo          
DbSelectArea("TRB")
DbCloseArea("TRB") 
IF li != 80
       roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

If aReturn[5] == 1
   Set Printer to
   dbCommitAll()
   OurSpool(wnrel)
End

MS_FLUSH()      
Return 
/*************************************************************/
User Function VisuaHE ()
	aSHE := {}                
	aCols:={}
	aHeader:={}                   
	Msg:="Visualiza Hora-Extra "
	MontaTela(Msg,1)

Return             
/************************************************************/
User Function HEAltera ()
	aCols:={}
	aHeader:={}                   
	Msg:="Altera Hora-Extra "
	DbSelectArea("SZP")
	If Empty(SZP->ZP_STATUS) .or. Alltrim(SZP->ZP_STATUS)='4'
		MontaTela(Msg,2)
	Else
		Alert("Só é possivel alterar hora-extra em aberto")
	EndIf	

Return             

/************************************************************/
User Function ExcHE ()
aSHE := {}                
aCols:={}
aHeader:={}                   
Msg:="Exclui Hora-Extra "
If Empty(SZP->ZP_STATUS)
	MontaTela(Msg,3)
Else
	Alert("Só é possivel excluir hora-extra em aberto")
EndIf	


Return 

/*************************************************************/
Static Function MontaTela (Msg,Tipo) 

Private TotH:=0,TotHE:=0
/*
nOpcao  := 0
nOpcx   := 6   */
Opc:=.F.
If Tipo=2
	Opc:=.T.
EndIF 
 

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZX")
nUsado  := 0
aHeader := {}
While !Eof() .and. (x3_arquivo == "SZX")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>2 .and. ( Alltrim(X3_CAMPO)='ZX_CCUSTO' .OR. Alltrim(X3_CAMPO)='ZX_PORCH')

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
dbSeek("SZX")
nUsado := 0
While !Eof() .and. (X3_ARQUIVO == "SZX")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>2 .and. ( Alltrim(X3_CAMPO)='ZX_CCUSTO' .OR. Alltrim(X3_CAMPO)='ZX_PORCH')
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
DbSelectArea("SZX")       
DbSetOrder(1)     
DbGotop()        
Chave:=SZP->ZP_FILIAL+SZP->ZP_NUM+SZP->ZP_MAT

//**Carrega aCols**/
/******************/
If DbSeek(Chave)  	
    aCols:={}
	While Chave==SZX->ZX_FILIAL+SZX->ZX_DOC+SZX->ZX_MAT .and. !Eof()
//    	AAdd(aCols,{SZX->ZX_CCUSTO,SZX->ZX_HORA,.F.})
    	AAdd(aCols,{SZX->ZX_CCUSTO,SZX->ZX_PORCH,.F.})
		DbSelectArea("SZX")
		DbSkip() 
	End
Endif	


dbSelectArea("SZP")
//**Monta Cabeçalho****/
cDoc:=ZP_NUM
cItem:=ZP_ITEM
cStat:=ZP_STATUS
cMat:=ZP_MAT
cNome:=ZP_NOME
cInv:=ZP_INV

cHoraI:= Alltrim(STRZERO(INT(SZP->ZP_HORAINI),2))+'.'+STRZERO(VAL(SUBSTR(aLLTRIM(STR(SZP->ZP_HORAINI-Int(SZP->ZP_HORAINI))),3,2)),2)
cHoraf:= Alltrim(STRZERO(INT(SZP->ZP_HORAFIM),2))+'.'+STRZERO(VAL(SUBSTR(aLLTRIM(STR(SZP->ZP_HORAFIM-Int(SZP->ZP_HORAFIM))),3,2)),2)
cData:=ZP_DATA //Dtoc(ZP_DATA)
cCusto:=ZP_CC
cMat  :=ZP_MAT 
cFCost:=ZP_FCOST
cFRota:=ZP_ROTA
cAtividade:=ZP_ATIVID
cMemo:=cAtividade
//cOk:=ZP_OK
cDtApro:=Dtoc(ZP_DTAPROV)
cDtEmisao:=DToc(ZP_EMISSAO)
cUSer:=ZP_USER
cAprov:=ZP_APROV
cDatIniE:=Dtoc(ZP_DATINI)
cDatFimE:=Dtoc(ZP_DATFIM)
cHrIniE:=""
cHrFimE:=""
@ 010,010 TO 500,620 DIALOG oDlg TITLE MSG

//@ 008,010 TO 150,350 //350

@ 010,014 Say "Documento: " 
@ 010,045 Get cDoc Size 022, 010 When .F.


@ 025,014 Say "Matricula: " 
@ 025,045 Get cMAT Size 022, 010 When .F.

@ 025,070 Say "Nome: "
@ 025,090 GET cNome  Size 180, 010 When .F.

@ 040,014 Say "Data:"  
//@ 040,045 GET cData   Size 017, 010 When .F. PICTURE "@D"  

@ 040,045 GET cData   Size 017, 010 When Opc PICTURE "@D" 
@ 040,090 Say "Inicio:" 
@ 040,110 GET cHoraI Size 017, 010 When Opc PICTURE "@R 99.99" 
@ 040,140 Say "Fim:" 
@ 040,155 GET cHoraF Size 017, 010 When Opc PICTURE "@R 99.99" // Valid(ValidHoras(cHoraI,cHoraF))
@ 055,014 Say "F.Cost:" 
@ 055,045 GET cFCost Size 017, 010 When Opc PICTURE "@!" VALID (ValidFCost())
@ 055,090 Say "Rota:"  
@ 055,110 Get cFRota Size 017, 010 When Opc PICTURE "@!"  VALID Upper(cFRota) $'SNsn'         
@ 055,130 Say "Inventario:"
@ 055,160 Get cInv Size 017, 010 When Opc PICTURE "@!"  VALID Upper(cInv) $'SNsn'         


@ 070,014 Say "Atividades:" 


if Tipo=2
    TotH:=100
	TotHE:=100
	oMemo:= tMultiget():New(080,014,{|u|if(Pcount()>0,cMemo:=u,cAtividade)};
	,oDlg,220,50,,,,,,.T.,,,,,,.F., , ,)
	@ 130,014 Say "Informações do FCost:"
	@ 140,020 TO 200,200 MULTILINE MODIFY DELETE VALID (LineOkAlt())   	
Else 
	oMemo:= tMultiget():New(06,03,{|u|if(Pcount()>0,cMemo:=u,cAtividade)};
	,oDlg,220,50,,,,,,.F.,,,,,,.T.)
	@ 130,014 Say "Informações do FCost:"
	@ 140,020 TO 200,200 MULTILINE 

	@ 210,014 Say "Data da Entrada:"  
	@ 210,055 GET cDatIniE   Size 017, 010 When Opc PICTURE "@D" 
	@ 210,090 Say "Hora da Entrada:" 
	@ 210,135 GET cHrIniE Size 017, 010 When Opc PICTURE "@R 99.99" 
	@ 220,014 Say "Data da Saida:"  
	@ 220,055 GET cDatFimE  Size 017, 010 When Opc PICTURE "@D" 
	@ 220,090 Say "Hora da  Saida:" 
	@ 220,135 GET cHrFimE Size 017, 010 When Opc PICTURE "@R 99.99" 

Endif 

if Tipo=3 //Exclusão
	@ 230,060 BMPBUTTON TYPE 1 ACTION ExcHExtra() 
ElseIf Tipo=2
	@ 230,060 BMPBUTTON TYPE 1 ACTION AltHExtra() 
//	@ 220,060 BMPBUTTON TYPE 1 ACTION AltHExtra() 
EndIf 
if Tipo=1
	@ 230,100 BMPBUTTON TYPE 2 ACTION Close(oDlg)
Else
	@ 230,100 BMPBUTTON TYPE 2 ACTION Close(oDlg)
End
ACTIVATE DIALOG oDlg CENTERED 

Return 
/***************************************************************/
Static Function ValidFCost()
Local lRet:=.F.
 If cFcost $'SsNN' 
 	// lRet:=LineOkAlt()
 	lRet:=.T.
 Endif 	    

Return lRet
//*************************************************************/
//LineOkSZX(TotHE)   
Static Function LineOkAlt()
Local lRet:=.F.          
TotHE:=100
TotH:=100
	If cFCost$"Ss" 
		lRet:=LineOkSZX(.T.)   
    Else 
    	Alert("Hora extra não é F-Cost.Os detalhes do F-Cost serão excluídos na confirmação.")
      	lRet:=MsgBox("Confirma a alteração","Atenção","YESNO")
	EndIf
Return lRet
//*************************************************************/

Static Function AltHExtra() 
Local lRet:=.F.

lRet:=LineOkAlt()
if Saldo>0 
	Alert('Ainda há saldo a distribuir no Fcost!!')
 	lRet:=.F.
EndIf

if lRet 
	DbSelectArea("SZP")
	RecLock("SZP",.F.)                                      		
	ZP_DATA:=cData
	ZP_CC:=cCusto
	ZP_FCOST:=cFCost
	ZP_ROTA:=cFRota                                   		
	ZP_ATIVID:=cMemo                                                
	ZP_INV:=cInv
	ZP_DTAPROV:=CTod(cDtApro)
	ZP_EMISSAO:=CTod(cDtEmisao)
	ZP_HORAINI:=Val(substr(CHoraI,1,2))+Val(substr(CHoraI,3,2)) /100
	ZP_HORAFIM:=Val(substr(CHoraF,1,2))+Val(substr(CHoraF,3,2)) /100
	ZP_HORA:=DifHoras(ZP_HORAINI,ZP_HORAFIM)

	MsUnlock()
	DbSelectArea("SZX")       
	DbSetOrder(1)     
	DbGotop()        
	DbSeek(Chave)
	While Chave==SZX->ZX_FILIAL+SZX->ZX_DOC+SZX->ZX_MAT
		RecLock("SZX",.F.)
		dbDelete()
		MsunLock()
		DbSelectArea("SZX")
		DbSkip() 
	End      
    If cFCost $'Ss"         
		For i:=1 to len(aCols)
			if !(aCols[i][len(aHeader)+1] ) .and. !Empty(aCols[i][1])
				RecLock("SZX",.T.)
				SZX->ZX_DOC:=cDoc
				SZX->ZX_MAT:=cMat 
		    	SZX->ZX_CCUSTO:=Posicione("SRA",1,xFilial("SRA")+cMat,"RA_CC")   //aCols[i][1]//CCusto 
		    	SZX->ZX_PORCH:=aCols[i][2] //Horas testeh
				MsunLock()		  
			End
		Next	 	                         		
	End	
	Close(oDlg)
Else
	if cFCost $'Ss"         
		Alert('Preenchimento dos dados de Fcost Obrigatorio') 	
	EndIf 	
Endif

Return 
//
//
//
Static Function DifHoras (HoraIni,HoraFim)
Local lRet   := .T.
Local a_Area := GetArea()

 If !Empty(HoraIni)
    If HoraFim < HoraIni
       tHora1:= SUBHORAS(24,HoraIni) 
       xHora := SOMAHORAS(HoraFim,tHora1) 
    Else
       xHora := SUBHORAS(HoraFim,HoraIni)
    Endif
    
    IF xHora > 6 
       HExtra:= SUBHORAS(xHora,1.00)
    Elseif  xHora > 12 
       Hextra:= SUBHORAS(xHora,2.00)
    Else   
      Hextra:= xHora
    Endif
 Endif   

RestArea(a_Area)
Return(HExtra)


/*************************************************************/


Static Function ExcHExtra

aStatus:={'Aprovado','Realizado','Postergado'}


//if MsgBox("Tem certeza que deseja exclui o registro","Atenção","YESNO")
if !Empty(SZP->ZP_STATUS) .or. (SZP->ZP_STATUS <>"4")

	DbSelectArea("SZP")
	Chave:="  "+SZP->ZP_NUM+SZP->ZP_MAT
	RecLock("SZP",.F.)
	dbDelete()
	MsunLock()
	DbSelectArea("SZX")
	While DbSeek(Chave)
		RecLock("SZX",.F.)
		dbDelete()
		MsunLock()
	End 
Else
	PosI:=Val(SZP->ZP_STATUS)
	Alert("Hora-extra está "+aStatus[PosI]+" e não pode ser excluída ")
End 
//Endif	
Close(oDlg)

Return 

/*************************************************************/
/*Função que verifica se a hora extra foi efetuada************/
/*Através do ponto eletrônico********************************/
/*************************************************************/
User Function INTPONHE

Local CodTurno:="",DiaN:=0
Local aMarc:={}
Local IniP:=Stod("//")
Local FimP:=Stod("//")

Prepare Environment Empresa "01" Filial "01" Tables "SZP,SP8,SPH,SPC"  // Usado apenas quando o uso for por agendamento

  
    

//Cuery:="SELECT MIN(P8_DATA) as IniP,MAX(P8_DATA) as FimP FROM SP8010 WHERE P8_HORA<>0 AND D_E_L_E_T_=''"
cQuery:="SELECT MIN(P8_DATA) as IniP,MAX(P8_DATA) as FimP FROM "+RetSqlName("SP8")+" WHERE P8_HORA<>0 AND D_E_L_E_T_='' AND P8_DATA<'"+Dtos(DDATABASE)+"'"


TCQUERY cQuery NEW ALIAS "AP8"                                                       		
DbSelectArea("AP8")
IniP:=SToD(AP8->IniP)
FimP:=STod(AP8->FimP)
DbCloseArea()

DbSelectArea("SZP")
DbGotop()
While !Eof()
    HorasEfet:=0
//	If SZP->ZP_HORAE=0                   
		If SZP->ZP_DATA< IniP //Verifica as Horas-Extra cujo o ponto foi fechado. 
			DbSelectArea("SPH") 
			DbSetOrder(2)
			If DbSeek(xFilial("SPH")+SZP->ZP_MAT+Dtos(SZP->ZP_DATA))
				While !Eof()                        
				    if SZP->ZP_MAT+Dtos(SZP->ZP_DATA)#SPH->PH_MAT+Dtos(SPH->PH_DATA) 
				       Exit
				    EndIf 
				    If  SPH->PH_PD $"111/115/116/121/125/283" //Verbas correspondentes a Hora-Extra
					    HorasEfet+=SPH->PH_QUANTC
					EndIf     
					DbSelectArea("SPH")
					DbSkip()
				EndDo 
			End 
	    Else
	    	DbSelectArea("SPC")
			DbSetOrder(2)
   	        HorasEfet:=0
			If DbSeek(xFilial("SPC")+SZP->ZP_MAT+Dtos(SZP->ZP_DATA))
				While !Eof()
				    if xFilial("SPC")+SZP->ZP_MAT+Dtos(SZP->ZP_DATA)#xFilial("SPC")+ SPC->PC_MAT+Dtos(SPC->PC_DATA) 
				       Exit
				    EndIf 
				    If  SPC->PC_PD $"111/115/116/121/125/283" //Verbas correspondentes a Hora-Extra
					    HorasEfet+=SPC->PC_QUANTC
					EndIf     
					DbSelectArea("SPC")
					DbSkip()
				EndDo 
			End 
   		EndIf    
    If HorasEfet >0
	    RecLock("SZP",.F.)
    	SZP->ZP_HORAE=HorasEfet
		MsUnlock()
	EndIf	

	DbSelectArea("SZP")
	DbSkip()
EndDo 	

Return 
/********************************************************************************/
/********************************************************************************/
/******************************************************************************/
User Function PRINTHE()
Private	cStartPath	:= GetSrvProfString('Startpath',''),;
		cFileLogo	:= cStartPath + 'logoNSB.bmp'//'lgrl' + AllTrim(cEmpAnt) + '.bmp'

Private	oPrint		:= TMSPrinter():New(OemToAnsi('Solicitação de Hora Extra')),;
		oBrush		:= TBrush():New(,4),;
		oFont07		:= TFont():New('Courier New',07,07,,.F.,,,,.T.,.F.),;
		oFont08		:= TFont():New('Courier New',08,08,,.F.,,,,.T.,.F.),;
		oFont08n	:= TFont():New('Courier New',08,08,,.T.,,,,.T.,.F.),;
		oFont10Co   := TFont():New('Courier New',10,10,,.F.,,,,.T.,.F.),;
		oFont09		:= TFont():New('Tahoma',09,09,,.F.,,,,.T.,.F.),;
		oFont10		:= TFont():New('Tahoma',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	:= TFont():New('Courier New',10,10,,.T.,,,,.T.,.F.),;
		oFont11		:= TFont():New('Tahoma',11,11,,.F.,,,,.T.,.F.),;
		oFont12		:= TFont():New('Tahoma',12,12,,.T.,,,,.T.,.F.),;
		oFont14		:= TFont():New('Tahoma',14,14,,.T.,,,,.T.,.F.),;
		oFont14s	:= TFont():New('Arial',14,14,,.T.,,,,.T.,.T.),;
		oFont15		:= TFont():New('Courier New',15,15,,.T.,,,,.T.,.F.),;
		oFont18		:= TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
		oFont18n	:= TFont():New('Arial',18,18,,.T.,,,,.T.,.F.),;
		oFont16		:= TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
		oFont22		:= TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)

Private	aAberOcor	:= {},;
		aComentar	:= {},;
		aSolucao	:= {}

Private	nLin		:= 30	// Linha que o sistema esta imprimindo.
		nPage		:= 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta os dados em array.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

        xDocHe:=SZP->ZP_NUM
	    
		While !Eof() .and. SZP->ZP_NUM=xDocHe
	
			For i:=1 To MlCount(SZP->ZP_ATIVID,56)
				If	! Empty(AllTrim(MemoLine(SZP->ZP_ATIVID,56,i)))
					aAdd(aAberOcor,AllTrim(MemoLine(SZP->ZP_ATIVID,56,i)))
				EndIf
			Next
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Seta a pagina para impressao em Retrato.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:SetPortrait()
	
			xCabecPrint()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³IMPRIME A PARTE DE INFORMACOES DO CHAMADO.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Say(nLin,0050,OemToAnsi('Matricula: '),oFont08n)
			oPrint:Say(nLin,0350,OemToAnsi('Nome: '),oFont08n)
			oPrint:Say(nLin,1600,OemToAnsi('Data Emisão: '),oFont08n)
			//oPrint:Say(nLin,2000,OemToAnsi(: '),oFont08n)
			nLin += 40
			oPrint:Say(nLin,0050,SZP->ZP_MAT,oFont10Co)
			oPrint:Say(nLin,0350,SubStr(SZP->ZP_NOME,1,50),oFont10Co)
			oPrint:Say(nLin,1600,DtoC(SZP->ZP_EMISSAO),oFont10Co)
//			oPrint:Say(nLin,2000,SZH->ZH_EMPCHAM,oFont10Co)
	
			nLin += 60 // Espaco entre os campos
	
			oPrint:Say(nLin,0050,OemToAnsi('Tipo: '),oFont08n)
			oPrint:Say(nLin,1000,OemToAnsi('Prioridade: '),oFont08n)
			oPrint:Say(nLin,1600,OemToAnsi('Solicitante: '),oFont08n)
			nLin += 40
  //			oPrint:Say(nLin,0050,Tabela('ZF',SZH->ZH_TIPO) + ' ' + SZH->ZH_MODULO + ' ' + SZH->ZH_PROGRAM,oFont10Co)
//			oPrint:Say(nLin,1000,Tabela('ZG',SZH->ZH_PRICHAM),oFont10Co)
//			oPrint:Say(nLin,1600,Upper(UsrFullName(SZH->ZH_SOLCHAM)),oFont10Co)
	
			nLin += 60 // Espaco entre os campos
	
			oPrint:Say(nLin,0050,OemToAnsi('Ocorrência:'),oFont08n)
	
			For i:=1 To Len(aAberOcor)
				nLin += 40
				If	( nLin >= 3000 )
					xCabecPrint()
				EndIf
				oPrint:Say(nLin,0050,aAberOcor[i],oFont10Co)
			Next i
	
			nLin += 60 // Espaco entre os campos
	
			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf
	
			oPrint:Line(nLin,0050,nLin,2300) // Linha Separacao
	
			nLin += 30
	
			If	( nLin >= 3000 )
				xCabecPrint()
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³IMPRIME OS DADOS DOS COMENTARIOS³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	( SZH->ZH_STATUS == '1' ) .or. ( SZH->ZH_STATUS == '8' ) .or. ( SZH->ZH_STATUS == '9' )
	
				oPrint:Say(nLin,0050,OemToAnsi('Técnico Alocado:'),oFont08n)
				nLin += 40
				If	( nLin >= 3000 )
					xCabecPrint()
				EndIf
	
				oPrint:Say(nLin,0050,Upper(UsrFullName(SZH->ZH_TECALOC)),oFont10Co)
	
				nLin += 60 // Espaco entre os campos
	
				If	( nLin >= 3000 )
					xCabecPrint()
				EndIf
	
				oPrint:Say(nLin,0050,OemToAnsi('Comentários:'),oFont08n)
	
				nLin += 60 // Espaco entre os campos
	
				If	( nLin >= 3000 )
					xCabecPrint()
				EndIf
	
				oPrint:Line(nLin,0050,nLin,2300) // Linha Separacao
	
				nLin += 30
	
				If	( nLin >= 3000 )
					xCabecPrint()
				EndIf
	
			EndIf	
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³IMPRIME OS DADOS DOS COMENTARIOS³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Fina a impressao do relatorio.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:EndPage()
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Mostra em video a impressao do relatorio. !³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrint:Preview()
			DbSelectArea("SZP")
			DbSeek()
	End
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xCabecPrintºAutor ³Luis Henrique Robustoº Data ³  11/02/05  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para imprimir o cabecalho do relatorio.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Funcao Principal                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDATA      ³ ANALISTA ³  MOTIVO                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³          ³                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCabecPrint()
Local	cStatus	:= ''

		If	( SZH->ZH_STATUS == '0' )
			cStatus	:= 'Aberto'
		ElseIf	( SZH->ZH_STATUS == '2' )
			cStatus	:= 'Aprovado'
		ElseIf	( SZH->ZH_STATUS == '1' )
			cStatus	:= 'Em Andamento'
		ElseIf	( SZH->ZH_STATUS == '8' )
			cStatus	:= 'Cancelado'
		ElseIf	( SZH->ZH_STATUS == '9' )
			cStatus	:= 'Encerrado'
		EndIf

		nLin := 30

		If	( nPage > 0 )
			oPrint:EndPage()
		EndIf
		
		nPage++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicia a impressao da pagina.!³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:StartPage()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o cabecalho da empresa. !³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrint:SayBitmap(nLin+20,040,cFileLogo,560,350)   //230,175) // 560,350)
		oPrint:Say(nLin+20,700,'NIPPON SEIKI DO BRASIL LTDA',oFont16)
		oPrint:Say(nLin+150,915,'Tecnologia da Informação ',oFont11)
		oPrint:Say(nLin+195,990,'Suporte on-line',oFont11)
//		oPrint:Say(nLin+285,700,AllTrim('Manuais: intranet.rechtratores.com.br'),oFont11)

		oPrint:Say(nLin+100,1700,'Ficha de SSI',oFont18n)
		oPrint:Say(nLin+180,1700,SZH->ZH_NUMCHAM + ' - ' + OemToAnsi(cStatus),oFont14s)

		nLin += 450

		oPrint:Line(nLin,0050,nLin,2300) // Linha Separacao

		nLin += 30

Return
/*******************************************************************************/

User Function RHEImp() 

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,AORD,TAMANHO,LIMITE")
SetPrvt("CSTRING,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,TABMES,XTOTINIQ,XTOTINIV,XTOTENTQ")
SetPrvt("XTOTENTV,XTOTSAIQ,XTOTSAIV,XTOTMEDQ,XTOTMEDV,XTOTFINQ")
SetPrvt("XTOTFINV,CCOUNT,_CFLAG,MV_PAR01,MV_PAR02,MV_PAR03")
SetPrvt("MV_PAR04,MV_PAR05,MV_PAR06,MV_PAR07,LI,M_PAG")
SetPrvt("CDULMES,CMESPRO,CDATINI,CDATANT,CDATIMA,CDATFIN")
SetPrvt("CMES,CMESANO,ADATREF1,NTIPO,CNOMARQ,CORD")
SetPrvt("CCOND,M->TOTGERAL,M->TOT,M->LINHARELATO,M->CODIGO,M->LOCAL")
SetPrvt("CSDOINIV,CSDOENTV,CSDOSAIV,CSDOINIQ,CSDOENTQ,CSDOSAIQ")
SetPrvt("CDATA,CSDOFINQ,CSDOFINV,MCOD,MDESC,MUM")
SetPrvt("MTIPO,MGRUPO,ACM,M->MEDIO")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RelImHE  ³ Autor ³ JEFFERSON MOREIRA     ³ Data ³ 16/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Solicitacao de horas extras                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("RELATORIO DE SOLICITAÇAO DE HORAS EXTRAS",74)
cDesc1    := PADC("Este programa tem como objetivp emitir o relatorio de solicitaçao ",74)
cDesc2    := PADC("de Horas Extras,conforme especificados em Parametros.",74)
cDesc3    := ""
aORD      := {}//{"OP","PRODUTO","RECURSO"}
tamanho   := "G" // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
//limite    := 132
limite    := 220
cString   := "SZP"
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Contabilidade", 2, 2, 1, "",1 }
nomeprog  := "RelImHE"
nLastKey  := 0
cPerg     := "SHEPAR"
m_pag     := 01     
Li:=0

/*TESTE DE INTEGRAÇÃO COM O PONTO*/
//U_INTPONHE()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                           ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³   mv_par01  - Da Data ?                                                        ³
//³   mv_par02  - Ate a Data ?                                                     ³
//³   mv_par03  - Do Doc ?                                                         ³
//³   mv_par04  - Ate o Doc ?                                                      ³
//³   mv_par05  - Da Matricula ?                                                   ³
//³   mv_par06  - Ate a Matricula ?                                                ³
//³   mv_par07  - Do CCusto ?                                                      ³
//³   mv_par08  - Ate o CCusto ?                                                   ³
//³                                                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "RelImHE"

wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := aReturn[8]
cbtxt  := Space(10)
cbcont := 00
 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   titulo := " SOLICITAÇÃO DE HORAS EXTRAS "
   cabec1 := "IT   |Matri   |Nome                          |Previsao                            |Centro|FCost  |Rota  |Invent |Efetivo|Status    |Bairro           |Complemento       |Telefone             |Rota|"
   cabec2 := "                                             |Data         |Inicio-Fim    |Duração|Custo |                         |Duracao "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
        	
If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

// --- Vetor com os campos do arquivo temporario

aCpo := {}
AADD(aCpo,{"ITEM"     ,"C",003,0}) 
AADD(aCpo,{"MAT"      ,"C",006,0}) 
AADD(aCpo,{"NOME"     ,"C",030,0}) 
AADD(aCpo,{"DATAMOV"  ,"C",010,0}) 
AADD(aCpo,{"HINI"     ,"C",005,0}) 
AADD(aCpo,{"HFIM"     ,"C",005,0}) 
AADD(aCpo,{"HORAS"    ,"C",005,0}) 
AADD(aCpo,{"CC"       ,"C",003,0}) 
AADD(aCpo,{"FCOST"    ,"C",001,0}) 
AADD(aCpo,{"USAROTA"  ,"C",001,0}) 
AADD(aCpo,{"INV"      ,"C",001,0}) 
AADD(aCpo,{"HORAE"    ,"C",005,0}) 
AADD(aCpo,{"DESCSTS"  ,"C",020,0}) 
AADD(aCpo,{"BAIRRO"   ,"C",015,0}) 
AADD(aCpo,{"COMPLEM"  ,"C",015,0}) 
AADD(aCpo,{"TELEFON"  ,"C",020,0}) 
AADD(aCpo,{"ROTA"     ,"C",002,0}) 

cTRB   := CriaTrab(aCpo,.T.)
dbUseArea(.T.,,cTRB,"XTRB",.T.,.F.)

dbSelectArea("XTRB")
//----------------------------------------------

 
CQuery:="  SELECT ZP_NUM,ZP_ITEM,ZP_STATUS,ZP_MAT ,ZP_INV,ZP_NOME,ZP_HORAINI,ZP_HORAFIM,ZP_INV,ZP_HORAE,"
CQuery+=" ZP_HORA ,ZP_CC       ,ZP_FCOST ,ZP_ROTA    ,ZP_OK         ,"
CQuery+=" ZP_DTAPROV,ZP_EMISSAO ,ZP_USER        ,ZP_APROV      ,ZP_HRINI,ZP_HRFIM,ZP_STATUS, "
Cquery+=" substring(ZP_DATA,7,2)+'/'+substring(ZP_DATA,5,2)+'/'+substring(ZP_DATA,1,4) AS ZP_DATA, "
Cquery+=" substring(ZP_DATINI,7,2)+'/'+substring(ZP_DATINI,5,2)+'/'+substring(ZP_DATINI,1,4) AS ZP_DATINI, "
Cquery+=" substring(ZP_DATFIM,7,2)+'/'+substring(ZP_DATFIM,5,2)+'/'+substring(ZP_DATFIM,1,4) AS ZP_DATFIM, "
CQuery+=" RA_BAIRRO,RA_COMPLEM,RA_TELEFON,RA_ROTA "
CQuery+=" FROM " + RetSqlName("SZP") + " AS SZP , " + RetSqlName("SRA") + " AS SRA "
CQuery+="  WHERE SZP.D_E_L_E_T_=''   AND SRA.D_E_L_E_T_='' "
cQuery+="  AND RA_MAT=ZP_MAT "
CQuery+="  AND ZP_DATA>='"+Dtos(mv_par01)+"' AND ZP_DATA<='"+Dtos(mv_par02)+"' "
CQuery+="  AND ZP_NUM>='"+mv_par03+"' AND ZP_NUM<='"+mv_par04+"' "
CQuery+="  AND ZP_MAT>='"+mv_par05+"' AND ZP_MAT<='"+mv_par06+"' "
CQuery+="AND ZP_CC>='"+mv_par07+"' AND ZP_CC<='"+mv_par08+"'"   

IF  mv_par12 <> '05'
   IF mv_par12 = '00'
      CQuery+=" AND ZP_STATUS=''"
   else 
      CQuery+=" AND ZP_STATUS= right((mv_par12,1)"
  endif
endif

if mv_par14 <> 1
  CQuery+="AND ZP_INV ='S'"  
ENDIF
cQuery+=" UNION "
CQuery+="  SELECT ZP_NUM,ZP_ITEM,ZP_STATUS,ZP_MAT ,ZP_INV,ZP_NOME,ZP_HORAINI,ZP_HORAFIM,ZP_INV,ZP_HORAE,"
CQuery+=" ZP_HORA ,ZP_CC       ,ZP_FCOST ,ZP_ROTA    ,ZP_OK         ,"
CQuery+=" ZP_DTAPROV,ZP_EMISSAO ,ZP_USER        ,ZP_APROV      ,ZP_HRINI,ZP_HRFIM,ZP_STATUS, "
Cquery+=" substring(ZP_DATA,7,2)+'/'+substring(ZP_DATA,5,2)+'/'+substring(ZP_DATA,1,4) AS ZP_DATA, "
Cquery+=" substring(ZP_DATINI,7,2)+'/'+substring(ZP_DATINI,5,2)+'/'+substring(ZP_DATINI,1,4) AS ZP_DATINI, "
Cquery+=" substring(ZP_DATFIM,7,2)+'/'+substring(ZP_DATFIM,5,2)+'/'+substring(ZP_DATFIM,1,4) AS ZP_DATFIM, "
CQuery+=" RA_BAIRRO,RA_COMPLEM,RA_TELEFON,RA_ROTA "
CQuery+=" FROM " + RetSqlName("SZP") + " AS SZP , " + RetSqlName("SRA") + " AS SRA "
CQuery+="  WHERE SZP.D_E_L_E_T_=''   AND SRA.D_E_L_E_T_='' "
cQuery+="  AND RA_MAT=ZP_MAT "
CQuery+="  AND ZP_DATA>='"+Dtos(mv_par01)+"' AND ZP_DATA<='"+Dtos(mv_par02)+"' "
CQuery+="  AND ZP_NUM>='"+mv_par03+"' AND ZP_NUM<='"+mv_par04+"' "
CQuery+="  AND ZP_MAT>='"+mv_par05+"' AND ZP_MAT<='"+mv_par06+"' "
CQuery+="AND ZP_CC>='"+mv_par07+"' AND ZP_CC<='"+mv_par08+"'"   

//	CQuery+="  AND RA_CC>='"+mv_par07+"' AND RA_CC<='"+mv_par08+"'"
//Selecionar extra de inventario - modificado por William      

IF  mv_par12 <> '05'
   IF (mv_par12) = '00'
      CQuery+=" AND ZP_STATUS=''"
   else 
      CQuery+=" AND ZP_STATUS = right(mv_par12,1)"
  endif
endif

if mv_par14 <> 1
  CQuery+="AND ZP_INV ='S'"  
ENDIF

If mv_par13=1
	CQuery+=" order by ZP_NUM,ZP_MAT  "
Else 
	CQuery+=" order by ZP_CC,ZP_DATA "
EndIf 	
 

TCQUERY cQuery NEW ALIAS "TRB"

DescS:={"Aberto","Aprovado","Realizado","Postergado","Não houve Aprovação"}
dbSelectArea("TRB")
DbGotop()
QtdGerTot:=0

While !EOF ()       
	 If (mv_par09=1 .and. TRB->ZP_FCOST $'N') .or.(mv_par09=2 .and. TRB->ZP_FCOST $'S')    //Filtra F-Cost estiver com Sim
		DbSelectArea("TRB")		 
		DbSkip()
		Loop
	 EndIF						 	
	 if(VAL(mv_par12)#5)
	 	If Val(TRB->ZP_STATUS)#Val(mv_par12)
			DbSelectArea("TRB")		 
			DbSkip()
			Loop
	 	EndIf
	 EndIF
     If mv_par13=1
	   TpOrd:=TRB->ZP_NUM
       DescOrd:="TOTAL DE HORAS EXTRAS DO DOCUMENTO: "
     Else 
	   TpOrd:=TRB->ZP_CC	
       DescOrd:="TOTAL DE HORAS EXTRAS POR CENTRO DE CUSTOS: "
     EndIf      

     if mv_par15=1
       @ li,000  PSAY Alltrim(TpOrd)+'-'+Posicione("CTT",1,xFilial("CTT")+TRB->ZP_CC,"CTT_DESC01")	
       li++
     EndIf
     QtdItem:=0
     While !Eof() .and.  IIf(MV_PAR13==1,TpOrd==TRB->ZP_NUM,TpOrd==TRB->ZP_CC)
         QtdItem++
		 If (mv_par09=1 .and. ZP_FCOST $'N') .or.(mv_par09=2 .and. ZP_FCOST $'S')    //Filtra F-Cost estiver com Sim
			//DbSelectArea("SZP")		 
			DbSelectArea("TRB")		 
			DbSkip()
			Loop
		 EndIF						 	
		 if(VAL(mv_par12)#5)
		 	If Val(TRB->ZP_STATUS)#Val(mv_par12)
				DbSelectArea("TRB")		 
				DbSkip()
				Loop
		 	EndIf
		 EndIF
 	     DescStatus:=DescS[val(TRB->ZP_STATUS)+1]         
         DbSelectArea("TRB")
         @ li,000        PSAY ZP_ITEM+"|"
         @ li,PCOL()+2   PSAY ZP_MAT+"|"
         @ li,PCOL()+2   PSAY ZP_NOME+"|"
         @ li,PCOL()+3   PSAY ZP_DATA+"|"
         @ li,PCOL()+2   PSAY "("+Transform(StrTran(StrZero(ZP_HORAINI,5,2),".",""),"@R !!:!!" )+'-'+Transform(StrTran(StrZero(ZP_HORAFIM,5,2),".",""),"@R !!:!!" )+")"+"|"
         @ li,PCOL()+2   PSAY Alltrim(Transform(StrTran(StrZero(ZP_HORA,5,2)   ,".",""),"@R !!:!!" ))+"|"
         @ li,PCOL()+3   PSAY ZP_CC+"|"
         @ li,PCOL()+4   PSAY iif(ZP_FCOST$"S","Sim","Não")+"|"
         @ li,PCOL()+3   PSAY iif(ZP_ROTA $"S","Sim","Não")+"|"
         @ li,PCOL()+3   PSAY iif(ZP_INV $"S","Sim","Não") +"|"
         @ li,PCOL()+3   PSAY Alltrim(Transform(StrTran(StrZero(ZP_HORAE,5,2)   ,".",""),"@R !!:!!" ))+"|"
         @ li,PCOL()+2   PSAY DescStatus+"|"
         @ li,PCOL()+2   PSAY RA_BAIRRO +"|"
         @ li,PCOL()+2   PSAY RA_COMPLEM+"|"
         @ li,PCOL()+2   PSAY RA_TELEFON+"|"
         @ li,PCOL()+2   PSAY RA_ROTA+"|"
         
         // PREENCHE O ARQUIVO TEMPORARIO
         dbSelectArea("XTRB")      	 
	     RecLock("XTRB",.T.) 
		 XTRB->ITEM    := TRB->ZP_ITEM
         XTRB->MAT	   := TRB->ZP_MAT	
		 XTRB->NOME	   := TRB->ZP_NOME
		 XTRB->DATAMOV := TRB->ZP_DATA
		 XTRB->HINI	   := Transform(StrTran(StrZero(TRB->ZP_HORAINI,5,2),".",""),"@R !!:!!" )
		 XTRB->HFIM	   := Transform(StrTran(StrZero(TRB->ZP_HORAFIM,5,2),".",""),"@R !!:!!" )
		 XTRB->HORAS   := Transform(StrTran(StrZero(TRB->ZP_HORA,5,2),".",""),"@R !!:!!" )
		 XTRB->CC	   := TRB->ZP_CC
		 XTRB->FCOST   := TRB->ZP_FCOST
		 XTRB->USAROTA := TRB->ZP_ROTA
		 XTRB->INV	   := TRB->ZP_INV
		 XTRB->HORAE   := Transform(StrTran(StrZero(TRB->ZP_HORAE,5,2),".",""),"@R !!:!!" )
		 XTRB->DESCSTS := DescStatus 
		 XTRB->BAIRRO  := TRB->RA_BAIRRO
		 XTRB->COMPLEM := TRB->RA_COMPLEM
		 XTRB->TELEFON := TRB->RA_TELEFON
		 XTRB->ROTA    := TRB->RA_ROTA
		 MSUNLOCK()
         dbSelectArea("TRB")      	 
         //------------------------------

        //Imprime os motivos da hora Extra
        if MV_PAR10 =1      
	        MotivoHE:={}
			Chave:=xFilial("SZP")+TRB->ZP_NUM+TRB->ZP_ITEM
	        DbSelectArea("SZP")
	        DbSetOrder(1)
	        if DbSeek(Chave)
		        For i:=1 To MlCount(SZP->ZP_ATIVID,56)
					If	! Empty(AllTrim(MemoLine(SZP->ZP_ATIVID,56,i)))
						aAdd(MotivoHE,AllTrim(MemoLine(SZP->ZP_ATIVID,56,i)))
					EndIf
				Next 
		     Endif     
	         Li++
	  	     If Li > 69
	  		    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	  	     Endif   
	 	     @ li,001 PSay "-> Atividades a serem efetuadas:"
	         For i:=1 to Len(MotivoHE)
		     	Li++
			    If Li > 69
			       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			    Endif   
				@ li,001 PSay MotivoHE[I]
	                
		     Next 
	    EndIf     
         //Imprime os dados do FCost
        DbSelectArea("TRB")
        if (ZP_FCOST $"Ss" .and. MV_PAR11=1)//DETALHES DO FCOST
	        DbSelectArea("SZX")       
			DbSetOrder(1)     
			DbGotop()        
			Chave:='  '+TRB->ZP_NUM+TRB->ZP_MAT
			Li++
			If DbSeek(Chave)  	                                                
				@ li,000 PSay "-> Informações do FCost:"
                @ li,Pcol()+4 Psay "Centro de Custo"
                @ li,Pcol()+24 Psay "Duração"
                @ li,Pcol()+5 Psay "Percentual"
                li++
				While Chave==SZX->ZX_FILIAL+SZX->ZX_DOC+SZX->ZX_MAT .and. !Eof()
				   DescC:=Posicione("CTT",1,xFilial("CTT")+SZX->ZX_CCUSTO,"CTT_DESC01")	
             	   Porc :=(SZX->ZX_HORA/TRB->ZP_HORA)*100 	
                   @ li,028 PSay Alltrim(SZX->ZX_CCUSTO)+'-'+Substr(DescC,1,30)
                   @ li,Pcol()+5 PSay Transform(SZX->ZX_HORA,'@E 99.99')
                   @ li,Pcol()+8 PSay Transform(Porc,'@E 999.99%')
  	               Li++
			        If Li > 69
			         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			        Endif   
		                   
				   DbSkip()	
				End
			Endif	

         Endif   
       
         li++
         If Li > 69
 	         Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
         Endif   
        If mv_par13=1
			TpOrd:=TRB->ZP_NUM
     	Else 
   	        TpOrd:=TRB->ZP_CC	
	    EndIf

         DbSelectArea("TRB")
         dbSkip()
                                    
     Enddo 
     QtdGerTot+=QtdItem         
     if mv_par16 = 1
	     @ li,000      PSAY "<"+TpOrd+">"+DescOrd+Alltrim(Str(QtdItem))//+Replicate('_',Limite-Len(Str(QtdGerTot))-Len(DescOrd))+Str(QtdGerTot)
	     li++  
	 EndIf    
     If Li > 69
 	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     Endif  
     If mv_par15=1 .and. mv_par16=1
	     @ li,000      PSAY Replicate("_",limite)
    	 li++
     EndIf	 
     If Li > 69
 	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     Endif  
Enddo          
If QtdGerTot>0
     @ li,000 PSAY "<Geral> Total por periodo:"+Alltrim(Str(QtdGerTot))//+Replicate('_',Limite-Len(Str(QtdGerTot))-Len(DescOrd))+Str(QtdGerTot)
EndIf 

DbSelectArea("TRB")
DbCloseArea("TRB") 
IF li != 80
       roda(cbcont,cbtxt,tamanho)
EndIF

Set Device To Screen

//-----PERGUNTA SE GERA PLANILHA -------------------
SExcel:=Msgbox("Confirma geração dos dados em Excel","Planilha","YESNO")
If  SExcel
      cDirDocs  :="\RELATO\"
      cPath="C:\RELATORIO_SIGA\"
	  cNome := "HORAEXTRA - "+Dtos(mv_par01)+" a "+Dtos(mv_par02)+".xls
	  
  	  dbSelectArea("XTRB")
	  COPY TO &(cDirDocs+cNome) VIA "DBFCDXADS"
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
        oExcelApp:WorkBooks:Open(cPath+cNome) // Atribui à propriedade WorkBooks do Excel
  												    // o Arquivo criado com as informacoes acumuladas do SRC 
        oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
   
        MSGBOX("Foi gerado o Arquivo "+cNOME,"Informacao","INFO")
        
Endif  

dbSelectArea("XTRB")
dbcloseArea("XTRB")

fErase( cTRB )

If aReturn[5] == 1
   Set Printer to
   dbCommitAll()
   OurSpool(wnrel)
End

MS_FLUSH()      
Return 
//
//  .---------------------------
// |  Lê registro de gestores 
//  '---------------------------
//
Static Function LGestor()
Local GAcesso:=""

cQuery:=" SELECT X5_CHAVE,X5_DESCRI "
cQuery+=" FROM " + RetSqlName("SX5") + " WHERE X5_TABELA='ZP' "
cQuery+=" AND D_E_L_E_T_='' "

cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TXX New

dbGotop()
While !Eof()
	GAcesso+= TXX->X5_CHAVE+"/"
	DbSkip()
Enddo

gAcesso:=Substr( gAcesso, 1, len( gAcesso)-1)	
dbSelectArea("TXX")
dbCloseArea()

Return GAcesso
