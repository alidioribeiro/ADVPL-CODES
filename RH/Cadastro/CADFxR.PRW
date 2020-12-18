/*
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/02/02
#Include "TOPCONN.CH" 



ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTBROWSER ºAutor  ³Jefferson Moreira   º Data ³  31/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Esse programa monta um browser para ser informado os reparosº±±
±±º          ³Ocorridos nos recursos por Op                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8 Estoques/Custos                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß



User Function CADFxR()        // incluido pelo assistente de conversao do AP5 IDE em 21/02/02   

Private cString
Private cCadastro := "Funcionario x Recurso" 
Private aRotina := { {"Pesquisar" ,"AxPesqui"    ,0,1} ,;
                     {"Visualizar","AxVisual"    ,0,2} ,;
                     {"Incluir"   ,"U_CADFUN"    ,0,3} ,;
                     {"Alterar"   ,"AxAltera"    ,0,4} ,;
                     {"Excluir"   ,"AxDeleta"    ,0,5} ,;
                     {"Imprimir"  ,"U_RelFXR"    ,0,6}  }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZJ"

dbSelectArea("SZJ")
dbSetOrder(1)
dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return

USER Function CADFUN()

xRecurso   := Space(25)
xDesc      := Space(80)


@ 96,42  TO 323,505 DIALOG oDlg5 TITLE "Informe o Recurso a ser cadastrado"
@ 08,10  TO 84,222
@ 15,20  SAY "Recurso     " 
@ 30,20  SAY "Descrição   " 

@ 15,50  Get xRecurso  PICTURE "@!   "             VALID xRecurso <> Space(25).and. Coleta() F3 "SH1"
@ 30,50  Get xDesc     PICTURE "@!   "             VALID xDesc   

@ 91,168 BMPBUTTON TYPE 1 ACTION Close(oDlg5)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)

ACTIVATE DIALOG oDlg5

if !Empty(xRecurso)
   BrowInc()
Endif   

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function BrowInc()


SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,CTITULO,AC,AR,ACGD") 
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,xQuant,N_SOMA")

//+--------------------------------------------------------------+
//¦ Opcao de acesso para o Modelo 2                              ¦
//+--------------------------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza 

//OP     := M->CCAMPO
//Coleta()

nOpcx  := 3
n_Soma := 0
cAlias := Alias()
cRecno := Recno()

//+--------------------------------------------------------------+
//¦ Montando aHeader                                             ¦
//+--------------------------------------------------------------+
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SZJ")
nUsado  := 0
aHeader := {}
While !Eof() .and. (x3_arquivo == "SZJ")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>=2
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
dbSeek("SZJ")
nUsado := 0
While !Eof() .and. (X3_ARQUIVO == "SZJ")
	IF X3USO(X3_USADO) .and. cNivel >= X3_NIVEL .and. Val(X3_ORDEM)>=2
		nUsado++
		IF nOpcx == 3
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
	Endif
	dbSkip()
End
aCols[1][nUsado+1] := .F.
//+--------------------------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2                           ¦
//+--------------------------------------------------------------+
//cData    := ddatabase
cRecurso := Alltrim (xRecurso)
cDesc    := Alltrim (xDesc)
//cRecurso := Alltrim (xRecur)
//cQuant   := Alltrim (zQuant) 

//+--------------------------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2                              ¦
//+--------------------------------------------------------------+
nLinGetD := 0
//+--------------------------------------------------------------+
//¦ Titulo da Janela                                             ¦
//+--------------------------------------------------------------+
cTitulo  := "Funcionario x Recurso"
//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho do Modelo 2      ¦
//+--------------------------------------------------------------+
aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.
AADD(aC,{"cRecurso", {15,010} ,"Recurso     " ,"@e " ,,,.f.})
AADD(aC,{"cDesc"   , {15,180} ,"Descrição   " ,"@e " ,,,.f.})
//AADD(aC,{"cRecurso", {15,280} ,"Recurso--->"  ,"@e " ,,,.f.})
//AADD(aC,{"cQuant"  , {15,380} ,"Quant      "  ,"@e " ,,,.f.})
//AADD(aC,{"cProduto", {30,010} ,"Produto--->"  ,"@e " ,,,.f.})
//AADD(aC,{"cDesc"   , {30,180} ,"Descrição->"  ,"@e " ,,,.f.})


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


//aAdd(aR,{"N_SOMA",{105,420},"QUANTIDADE TOTAL: ","@E 999,999" ,,,.F.})

//+--------------------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2                 ¦
//+--------------------------------------------------------------+
aCGD := {60,5,100,315}
//aCGD := {40,5,118,315}
//+--------------------------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2                           ¦
//+--------------------------------------------------------------+
//cLinhaOk := "ExecBlock('BrowLinOK',.f.,.f.)"
//cTudoOk  := "ExecBlock('BrowTudOk',.f.,.f.)"

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
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

If lRetMod2
	//a_Perd := aCols
	
	For X:=1 to len(aCols)
	
	dbSelectArea("SZJ") 
	RecLock("SZJ",.T.)
    ZJ_FILIAL      := xFilial()
    ZJ_MAT         := aCols[X][1] 
    ZJ_NOME        := aCols[X][2]
    ZJ_RECURSO     := cRecurso
  
	MsUnlock()
Next
	
Else
//	Close(oDlg5)
	Sai := .f.
Endif

dbSelectArea(cAlias)
dbGoto(cRecno)

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Validação de Confirmação no Cadastro dos Fun x Recurso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù


Static Function BrowTudOk



RestArea(a_Area)
Return(lRet) 
 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fim da Validação de Confirmação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function BrowLinOK 


Return .T.
   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Coletor de informações quando OP foi informada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Static Function Coleta 
 
DbSelectArea("SH1")
DbSetOrder(1)
    IF dbSeek(xFilial("SH1")+xRecurso)
       xDesc  := H1_DESCRI
       cRe := .t.
    ELSE
       Alert(" Recurso não Cadastrado... ")
       cRe := .f.
    Endif

Return cRe


User Function RelFXR() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
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
±±³Fun‡ao    ³ RelFXR   ³ Autor ³ JEFFERSON MOREIRA     ³ Data ³ 13/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Relatorio de Funcionario x Recurso                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("Funcionario x Recurso",74)
cDesc1    := PADC("Este programa tem como objetivp emitir o relatorio de Funcionario x Recurso,",74)
cDesc2    := PADC("conforme especificados em Parametros.",74)
cDesc3    := ""
aORD      := {"Matricula","Recurso"}
tamanho   := "P"
limite    := 80  // P=80 - M=130 - G=220 
cString   := "SZJ"
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Contabilidade", 2, 2, 1, "",1 }
nomeprog  := "RelFXR"
nLastKey  := 0
cPerg     := "RelFXR"
m_pag     := 01


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                           ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³   mv_par01  - Da Matricula ?                                                   ³
//³   mv_par02  - Ate a Matricula ?                                                ³
//³   mv_par03  - Do Recurso ?                                                     ³
//³   mv_par04  - Ate o Recurso ?                                                  ³                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "RelFXR"

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
li     := 80  
 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do case
   Case nOrdem == 1  
   titulo := "Funcionario x Recurso  ( "+aOrd[nOrdem]+" )"
   cabec1 := "Mat       Nome                                      Recurso "  
   cabec2 := ""  
   //         XXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXX
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
   Case nOrdem == 2
                                                                                                
   titulo := "Funcionario x Recurso ( "+aOrd[nOrdem]+" )"
   cabec1 := "Mat       Nome"  
   cabec2 := ""
   //         XXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20
                                                                                             
EndCase 

If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

 dbSelectArea("SZJ")
 dbGoTop()
 IF nOrdem == 1 
    dbSetOrder(1)
 Else
    dbSetOrder(2)
 Endif        
 
 IF nOrdem == 1 // Por MAtricula
    While !EOF ()    
          
      If ZJ_MAT  < mv_par01 .or. ZJ_MAT > mv_par02
         dbSkip()
         Loop
      End 
    
      If ZJ_RECURSO  < mv_par03 .or. ZJ_RECURSO > mv_par04
         dbSkip()
         Loop
      End
       xNome := Posicione("SRA",1,xFilial("SRA")+ ZJ_MAT,"RA_NOME")
       
       @ li,000      PSAY ZJ_MAT  
       @ li,PCOL()+4 PSAY xNome
       @ li,PCOL()+2 PSAY ZJ_RECURSO
       
       If li > 65
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
       EndIF
    li++
    dbSkip()
    Enddo   
      
 Elseif nOrdem = 2  // Por Recurso
       
      While !EOF ()     
          
        If ZJ_RECURSO  < mv_par03 .or. ZJ_RECURSO > mv_par04
           dbSkip()
           Loop
        End
        xRecu := ZJ_RECURSO
        @ li,000      PSAY "Recurso: "+ ZJ_RECURSO  
        Li++
        While !Eof() .and. xRecu == ZJ_RECURSO
            If ZJ_MAT  < mv_par01 .or. ZJ_MAT > mv_par02
               dbSkip()
               Loop
            End 
            
            xNome := Posicione("SRA",1,xFilial("SRA")+ ZJ_MAT,"RA_NOME")
            @ li,000      PSAY ZJ_MAT
            @ li,PCOL()+4 PSAY xNome
            If li > 65
               cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
            EndIF
        dbSkip()
        li++
        Enddo
      
       @ LI,000 PSAY Replicate("-",Limite)
       li++
      Enddo     
    
 
 Endif 

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

*/