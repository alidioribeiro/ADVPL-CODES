#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02
#IFNDEF WINDOWS
		#DEFINE PSAY SAY
#ENDIF

User Function CASS()        // incluido pelo assistente de conversao do AP5 IDE em 08/03/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,NLIN,CCABEC1")
SetPrvt("CCABEC2,WNREL,CTAMANHO,CCARACTER,CALIAS,LCONTINUA")
SetPrvt("ARETURN,NOMEPROG,NLASTKEY,CBCONT,CPERG,A")
SetPrvt("CPAR_MAT1,CPAR_MAT2,CPAR_CC1,CPAR_CC2,CPAR_FIL1,CPAR_FIL2")
SetPrvt("CPAR_SIT,NPAR_PERC,CPAR_PD,NPAR_LIM,NVAL,CFLAG")


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/03/02 ==> 		#DEFINE PSAY SAY
#ENDIF

*
cTitulo   := "Contribuicao Assistencial"
#IFDEF WINDOWS
   cDesc1 := OemToAnsi(" ")
   cDesc2 := OemToAnsi(" ")
   cDesc3 := OemToAnsi(" ")
#ENDIF
nlin:=0
cCabec1   := " "
cCabec2   := " "
wNrel     := "CASS"
cTamanho  := "G"
cCaracter := 15
cAlias    := "SRA"
lContinua := .T.
aReturn   := { "Normal", 1, "PONTO", 1, 2, 1, "", 1 }
nomeprog  := "CASS"
nLastKey  := 0
cBcont    := 0
cPerg     := "CASS"

//IF pergunte(cPerg,.T.)   //alt
//  A:=" A"
//  ELSE
//   MSGBOX(" Saindo do Calculo "," NISSIN ")
//   RETURN
//ENDIF

/*
  mv_par01  de Filial
  mv_par02  Ate Filial
  mv_par03  de Centro de custo
  mv_par04  Ate Centro de Custo
  mv_par05  de Matricula
  mv_par06  Ate Matricula
  mv_par07  Situacoes
  mv_par08  Verbas
  mv_par09  Percentual
  mv_par10  Limite


cPar_Mat1 :=  Mv_Par05
cPar_Mat2 :=  Mv_Par06
cPar_CC1  :=  Mv_Par03
cPar_CC2  :=  Mv_Par04
cPar_Fil1 :=  Mv_Par01
cPar_Fil2 :=  Mv_Par02
cPar_Sit  :=  Mv_Par07
nPar_Perc :=  Mv_Par09
cPar_Pd   :=  Mv_Par08
nPar_Lim  :=  Mv_Par10
*/
CassPar()

Sele Sra
Sra->(DbSetOrder(01))
Sra->(DbGoTop())
While Sra->(!Eof())

    if Sra->ra_Mat < cPar_Mat1.or.Sra->ra_Mat > cPar_Mat2.or.       ;
       Sra->ra_CC < cPar_CC1.or.Sra->ra_CC > cPar_CC2.or.           ;
       Sra->ra_Filial < cPar_Fil1.or.Sra->ra_Filial > cPar_Fil2.or. ;
       !Sra->ra_SitFolh $ cPar_Sit

       Sra->(DbSkip())
       Loop
    Endif

    nVal:=Sra->Ra_Salario * nPar_Perc/100
   // msgbox(Sra->ra_Mat+" "+Sra->ra_Nome +" - "+Str(Sra->ra_Salario)+" - " +str(if(nVal>nPar_Lim,nPar_lim,nVal) ) )

    Src->(DbSetOrder(01))
    if ! Src->(DbSeek(Sra->ra_Filial+Sra->ra_Mat+cPar_PD))
       RECLOCK("SRC",.T.)
       Src->rc_Filial:=Sra->ra_Filial
       Src->rc_Mat   :=Sra->ra_Mat
       Src->rc_Data  :=dDataBase
       Src->rc_cc    :=Sra->Ra_CC
       Src->rc_Pd    := cPar_Pd
       Src->rc_Tipo1 :="V"
       Src->rc_Tipo2 :="I"
       Src->rc_Valor :=if(nVal>nPar_Lim,nPar_lim,nVal)
      Else
       RECLOCK("SRC",.F.)
       Src->rc_Data  :=dDataBase
       Src->rc_cc    :=Sra->Ra_CC
       Src->rc_Tipo1 :="V"
       Src->rc_Tipo2 :="I"
       Src->rc_Valor :=if(nVal>nPar_Lim,nPar_lim,nVal)
    EndIf
    SRC->(MsUnlock())
Sra->(DbSkip())
End
*********************************************************************
// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> Function CassPar
Static Function CassPar()
*********************************************************************
cPar_Fil1:=Space(02)
cPar_Fil2:=Space(02)
cPar_CC1 :=Space(09)
cPar_CC2 :=Space(09)
cPar_Mat1:=Space(06)
cPar_Mat2:=Space(06)
cPar_Sit :=" AFT" //Space(10)
nPar_Perc:=000.00
cPar_Pd  :=Space(03)
nPar_Lim :=000.00

@ 96,42 TO 323,505 DIALOG oDlg6 TITLE "Rotina de Refresh"
@ 8,10 TO 84,222
@ 91,139 BUTTON "_OK" Size 70,20  ACTION CassOk()// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> @ 91,139 BUTTON "_OK" Size 70,20  ACTION Execute(CassOk)
@ 23,14  SAY "Filial de   " //Get cPar_Fil1
@ 23,120 SAY "Filial Ate  " //Get cPar_Fil2
@ 33,14  SAY "C.Custo De  " //Get cPar_CC1
@ 33,120 SAY "C.Custo Ate " //Get cPar_CC2
@ 43,14  SAY "Matricu. de " //Get cPar_Mat1
@ 43,120 SAY "Matricu.Ate " //Get cPar_Mat2
@ 53,14  SAY "Situacao    " //Get cPar_Sit
@ 53,120 SAY "Percentual  " //Get nPar_Perc
@ 63,14  SAY "Verbas      " //Get cPar_Pd
@ 63,120 SAY "Limite      " //Get nPar_Lim

@ 23,060 Get cPar_Fil1 PICTURE "99"        VALID cPar_Fil1<>Space(02)
@ 23,160 Get cPar_Fil2 PICTURE "99"        VALID cPar_Fil2<>Space(02)
@ 33,060 Get cPar_CC1  PICTURE "99999999"  VALID cPar_CC1 <>Space(09).and..t. F3 "SI1"
@ 33,160 Get cPar_CC2  PICTURE "99999999"  VALID cPar_CC2 <>Space(09).and..t. F3 "SI1"
@ 43,060 Get cPar_Mat1 PICTURE "999999"    VALID cPar_Mat1<>Space(06).and..t. F3 "SRA"
@ 43,160 Get cPar_Mat2 PICTURE "999999"    VALID cPar_Mat2<>Space(06).and..t. F3 "SRA"
@ 53,060 Get cPar_Sit  PICTURE "@!"        VALID cPar_Sit <>Space(10)
@ 53,160 Get nPar_Perc PICTURE "999.99"    VALID nPar_Perc<>0
@ 63,060 Get cPar_Pd   PICTURE "999"       VALID cPar_Pd  <>Space(03).and..t. F3 "SRV"
@ 63,160 Get nPar_Lim  PICTURE "999.99"    VALID nPar_Lim <>0

ACTIVATE DIALOG oDlg6 CENTERED
Return
*********************************************************************
// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> Function CassOk
Static Function CassOk()
*********************************************************************
Close(oDlg6)
Return
*********************************************************************
// Substituido pelo assistente de conversao do AP5 IDE em 08/03/02 ==> Function CassCa
Static Function CassCa()
*********************************************************************
cflag:=.F.
Return
