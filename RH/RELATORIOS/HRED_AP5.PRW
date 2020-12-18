#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/03/02
#IFNDEF WINDOWS
		#DEFINE PSAY SAY
#ENDIF

User Function hred()        // incluido pelo assistente de conversao do AP5 IDE em 27/03/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CTITULO,CDESC1,CDESC2,CDESC3,NLIN,CCABEC1")
SetPrvt("CCABEC2,WNREL,CTAMANHO,CCARACTER,CALIAS,LCONTINUA")
SetPrvt("ARETURN,NOMEPROG,NLASTKEY,CBCONT,CPERG,CDESCCC")
SetPrvt("V_OBS,V_TOTAL,V_MARCENT,V_MARCSAI,A,DPERINI")
SetPrvt("DPERFIM,CDRIVER,CCOMPAC,CNORMAL,AFASTADO,CVERBAS")
SetPrvt("TURDE,TURATE,MATDE,MATATE,CCDE,CCATE")
SetPrvt("CSITFOL,CPERINI,CPERFIM,CSPCMOV,MRED,C_PD")
SetPrvt("N_VALOR,NINT,NDEC,NINT2,NDEC2,NVALOR33")
SetPrvt("NINT33,NDEC33,NVALEDU,PAGINA,NLINHA,NFUNC")
SetPrvt("VTOTFUN,VTOTAIS,CMATOLD,FLAG,")


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/03/02 ==> 		#DEFINE PSAY SAY
#ENDIF

*
cTitulo   := "Horas Reduzidas"
#IFDEF WINDOWS
   cDesc1 := OemToAnsi("Este Programa Emite a Relacao de Funcionarios")
   cDesc2 := OemToAnsi("com Horas Extras Reduzidas.")
   cDesc3 := OemToAnsi(" ")
#ENDIF
nlin:=0
cCabec1   := " "
cCabec2   := " "
wNrel     := "HRED"
cTamanho  := "G"
cCaracter := 15
cAlias    := "SRA"
lContinua := .T.
aReturn   := { "Normal", 1, "PONTO", 1, 2, 1, "", 1 }
nomeprog  := "HRED"
nLastKey  := 0
cBcont    := 0
cPerg     := "HREDUZ"
cdesccc   := " "
v_obs     := " "
v_TOTAL   := ""
v_marcent := 0
v_marcsai := 0

IF pergunte(cPerg,.T.)   //alt
   A := " A"
ELSE
   MSGBOX(" Saindo do Calculo de Horas Reduzidas"," NIPPON ")
   RETURN
ENDIF 

/*
  mv_par01  de Filial
  mv_par02  Ate Filial
  mv_par03  de Centro de custo
  mv_par04  Ate Centro de Custo
  mv_par05  de Turno
  mv_par06  Ate Turno
  mv_par07  de Matricula
  mv_par08  Ate Matricula
  mv_par09  de Periodo
  mv_par10  Ate Periodo
  mv_par11  Situacoes
  mv_par12  Sobrepor/limpar

*/

dPerIni    := CtoD('  /  /  ')
dPerFim    := CtoD('  /  /  ')
If !PerAponta(@dPerIni,@dPerFim)
  Help(' ',1,'PERNCAD')
  Return (.F.)
Endif

wNrel:="HRED"
//wNrel := SetPrint(cAlias,wNrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.,.F.,.T.,cTamanho)

If nLastKey == 27
   Return
EndIf

//SetDefault(aReturn,cAlias)
#IFDEF WINDOWS
   Processa({|| Reduzido()})// Substituido pelo assistente de conversao do AP5 IDE em 27/03/02 ==>    processa({|| Execute(Reduzido)})
#ENDIF

cDriver  := ReadDriver()
cCompac  := cDriver[1]
cNormal  := cDriver[2]
Afastado := .F.

If !(Type('ArqTrab') == 'U')
	fErase(cArqTrab)
Endif 

If !(Type('Arq') == 'U')
	fErase(cArq)
Endif

return
**************************
Static function Reduzido()
**************************
//variaveis utilizados
ProcRegua(500)
cVerbas := "104|xxx"    //ALT
Turde   := mv_par05
Turate  := mv_par06
MatDe   := mv_par07
MatAte  := mv_par08
CCDe    := mv_par03
CCAte   := mv_par04
cSitFol := mv_par11
cPerIni := mv_par09
cPerFim := mv_par10
cSpcMov := StrZero(mv_par12,1)
mRed:={}

aStru := {}
AADD( aStru, {"Mat"   ,"C",6,0})
AADD( aStru, {"DtLanc","D",8,0})
AADD( aStru, {"Pd"    ,"C",3,0})
AADD( aStru, {"Valor" ,"N",6,2})
AADD( aStru, {"Pd2"   ,"C",3,0})
AADD( aStru, {"Valor2","N",6,2})
AADD( aStru, {"Hred"  ,"N",6,2})
AADD( aStru, {"Total" ,"N",6,2})
cArqTrab := CriaTrab(aStru,.T.)
Use &cArqTrab Alias TRB New 
cArq := CriaTrab(NIL,.F.)
cIndice := "Mat + dtoc(DtLanc)" //+ IndexKey()
Index on &cIndice To &cArq

Sra->(DbSetOrder(01))
Sra->(DbSeek(xFilial("SRA")+MatDe,.T.))
While Sra->(!Eof()) .and. Sra->Ra_Filial >= mv_par01 .and. Sra->Ra_Filial <= mv_par02

   IncProc(SRA->RA_MAT+SRA->RA_NOME)

   If (SRA->RA_TNOTRAB < Turde) .Or. (SRA->RA_TNOTRAB > TurAte) .Or. ;
      (SRA->Ra_MAT < MatDe) .Or. (SRA->RA_MAT > MatAte)  .Or. ;
      (SRA->Ra_CC < CCDe) .Or. (SRA->RA_CC > CCAte)      .or. ;
      (!SRA->Ra_SitFolh $ cSitFol)
	  Sra->(dbSkip())
	  Loop
   Endif
         
   Spc->(DbSetOrder(01)) // filial + mat + pd + DtLanc
   Spc->(DbSeek(xFilial("SPC")+Sra->Ra_Mat+SubStr(cVerbas,1,3),.T.))
   While Spc->(!Eof()) .And. Sra->Ra_Mat==Spc->Pc_mat
   
         If Spc->Pc_Data < cPerIni .or. Spc->Pc_Data > cPerFim .or. !Spc->Pc_Pd $ cVerbas
            Spc->(DbSkip())
            Loop
         EndIf
         
         c_PD   :=if(!Empty(Spc->Pc_Pdi),Spc->pc_Pdi,Spc->Pc_Pd )
         n_valor:=if(Spc->Pc_QuantI > 0,Spc->pc_Quanti,Spc->Pc_QuantC )

         If !TRB->(DbSeek(Sra->Ra_Mat))
            RecLock("TRB",.T.)
            TRB->Mat    := Sra->Ra_Mat
            TRB->DtLanc := Spc->Pc_Data
            msUnlock()
            If c_PD == SubStr(cVerbas,1,3)
               RecLock("TRB",.F.)
               TRB->Pd    := c_PD
               TRB->Valor := n_Valor
               msUnlock()
            Endif
            RecLock("TRB",.F.)
            TRB->Total :=n_Valor
            msUnlock()
         Else
            If c_PD == SubStr(cVerbas,1,3)
               RecLock("TRB",.F.)
               TRB->Pd    :=  c_PD
               TRB->Valor :=  TRB->Valor + n_Valor
               msUnlock()
            Endif
            nInt  := Val(SubStr(StrZero(N_VALOR,5,2),1,At(".",StrZero(N_VALOR,5,2))-1))
            nDec  := Val(SubStr(StrZero(N_VALOR,5,2),  At(".",StrZero(N_VALOR,5,2))+1,2))
            nInt2 := Val(SubStr(StrZero(TRB->TOTAL,7,2),1,At(".",StrZero(TRB->TOTAL,7,2))-1))
            nDec2 := Val("0."+SubStr(StrZero(TRB->TOTAL,7,2),  At(".",StrZero(TRB->TOTAL,7,2))+1,2))
            RecLock("TRB",.F.)
            TRB->TOTAL := (NINT+NINT2)+(NDEC/60+NDEC2)
            msUnlock()
   Endif
   Spc->(DbSkip())
   End //fim do Loop do Spc
   Sra->(DbSkip())
End  //fim do Loop do Sra
LANC()
RETURN

**********************
Static Function LANC()
**********************
TRB->(dbGoTop())
While TRB->(!EOF())

      //   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //   ³ Faz lancamento de horas reduzidas nos apontamentos ³ 
      //   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      SPC->(dbSetOrder(01))
      If Spc->(DbSeek( xFilial("SPC")+TRB->MAT+"109"+DtoS(dPerFim)))
         RecLock("SPC",.F.)
         if cSpcMov == "1"
            Spc->Pc_QuantC := (TRB->TOTAL * 7.5) / 52.5
         Elseif cSpcMov=="2"
            //MSGBOX(SPC->PC_MAT + SPC->PC_PD +"  " +DTOC(SPC->PC_DATA),"DELETE" )
            Spc->(Dbdelete())
         Endif
         MsUnlock()
      Else 
         If cSpcMov $ "1/3"
            RECLOCK("SPC",.T.)  
            Spc->Pc_Filial:= xFilial()
            Spc->Pc_Mat   := TRB->MAT
            Spc->Pc_Data  := dPerFim
            Spc->Pc_Pd    := "109"
            Spc->Pc_QuantC:=(TRB->TOTAL*7.5)/52.5
            MsUnlock()
         Endif
      Endif

      //   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ------Ä¿ 
      //   ³ Faz lancamento de horas reduzidas na Folha de Pagamento  ³
      //   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ------ÄÙ

      nvalor33:= ( TRB->TOTAL * 7.5 ) / 52.5
      nInt33  := Val(SubStr(StrZero(nValor33,5,2),1,At(".",StrZero(nValor33,5,2))-1 ))
      nDec33  := Val(SubStr(StrZero(nValor33,5,2),  At(".",StrZero(nValor33,5,2))+1,2))

      NVALEDU := nInt33 + ( nDec33 / 60 )

      Src->(DbSetOrder(01))
      If Src->(DbSeek( xFilial("SRC")+TRB->MAT+"109"))

         // msgbox(str(nvaledu))
         // msgbox(str(nInt33))
         // msgbox(str(ndec33))

         RecLock("SRC",.F.)
         if cSpcMov == "1"
            //Src->rc_Horas:=( TRB->TOTAL*7.5)/52.5
            Src->rc_Horas := nValEdu
         Elseif cSpcMov=="2"
            SRC->(Dbdelete())
         Endif
         SRC->(MsUnlock())
      Else
         Sra->(DbSetOrder(01))
         Sra->(DbSeek(xFilial("SRA")+TRB->Mat))
         If cSpcMov $ "1|3"
            RECLOCK("SRC",.T.)
            Src->rc_Filial := xFilial()
            Src->rc_Mat    := TRB->MAT
            Src->rc_Data   := dPerFim
            Src->rc_cc     := Sra->Ra_CC
            Src->rc_Pd     := "109"
            Src->rc_Horas  := nValEdu
            Src->rc_Tipo1  := "H"
	        SRC->(MsUnlock())
         Endif
      Endif
      TRB->(DBSKIP())
END

RETURN

*******************
// Substituido pelo assistente de conversao do AP5 IDE em 27/03/02 ==> Function ImpRed
Static Function ImpRed()
*******************
Pagina:=1              //110-115-tal-redtotal-
nLinha:=0
nFunc:=0
vTotFun:={0,0,0,0}
vTotais:={0,0,0,0}
TRB->(DbGoTop())
cMatOld := TRB->Mat
impCab()
While TRB->(!Eof())

 if cMatOld == TRB->Mat
    vTotFun[1]:= vTotFun[1] + TRB->Valor
    vTotFun[2]:= vTotFun[2] + TRB->Valor2
    vTotFun[3]:= vTotFun[3] + TRB->Total
    vTotFun[4]:= vTotFun[4] + TRB->HRed
  Else
    vTotais[1]:= vTotais[1] + vTotFun[1]
    vTotais[2]:= vTotais[2] + vTotFun[2]
    vTotais[3]:= vTotais[3] + vTotFun[3]
    vTotais[4]:= vTotais[4] + vTotFun[4]
    //lanca valores
    if Spc->(DbSeek( xFilial("SPC")+cMatOld+"109"+DtoS(dPerFim)))
        if cSpcMov == "1"
       //    Spc->Pc_QuantC:=vTotFun[4]
          Elseif cSpcMov == "2"
        //   Spc->(Dbdelete)
        Endif
       Else
        if cSpcMov $ "1/3"
       //  Spc->Pc_Filial:= xFilial()
       //  Spc->Pc_Mat    := cMatOld
       //  Spc->Pc_Data   := dPerFim
       //  Spc->Pc_Pd     := "109"
       //  Spc->Pc_QuantC := vTotFun[4]
        Endif
    Endif
     @ nlinha , 000 PSAY "Totais ............"
     @ nlinha , 081 PSAY vTotFun[1]
     @ nlinha , 092 PSAY vTotFun[2]
     @ nlinha , 103 PSAY vTotFun[3]
     @ nlinha , 114 PSAY vTotFun[4]
     nlinha := if(nLinha >=50,0,nlinha+1)
     impCab()
     vTotFun[1]:= TRB->Valor
     vTotFun[2]:= TRB->Valor2
     vTotFun[3]:= TRB->Total
     vTotFun[4]:= TRB->HRed
     cMatOld   := TRB->Mat
 Endif

 if nLinha>56
   impCab()
 Endif
  flag:=.F.
  Sra->(DbSetOrder(01))
  if Sra->(DbSeek(xFilial("SRA")+TRB->Mat))
      flag:=.T.
  Endif

  @ nLinha, 000 PSAY TRB->MAT
  @ nLinha, 011 PSAY if(Flag, Sra->Ra_CC   ,"XXXXXXX")
  @ nLinha, 020 PSAY if(Flag, Sra->Ra_Nome ,"XXXXXXXXXXX")
  Srj->(DbSetOrder(01))
  If Srj->(DbSeek(xFilial("SRJ")+Sra->Ra_CodFunc))
     @ nLinha, 085 PSAY if(Flag,Srj->Rj_Desc,"XXXXXXXXXX")
     else
     @ nLinha, 085 PSAY "XXXXXXXXXX"
  EndIf
  @ nLinha, 072 PSAY TRB->DtLanc
  @ nLinha, 081 PSAY TRB->Valor
  @ nLinha, 092 PSAY TRB->Valor2
  @ nLinha, 103 PSAY TRB->Total
  @ nLinha, 114 PSAY TRB->HRed
  nLinha := nLinha + 1
 TRB->(DbSkip())
End

Return

*************************
Static Function impCab()
*************************
nLinha :=nLinha + 1
@ nLinha,001 PSAY "+----------------------------------------------------------------------------------------------------------------------------+";nLinha:=nLinha+1
@ nLinha,001 PSAY "| NIPPON SEIKI                            Relacao de Horas Reduzidas                            FOLHA: "+StrZero(Pagina,3)+" |";nLinha:=nLinha+1
@ nLinha,001 PSAY "| MICROSIGA/HRED                                                                     Emitido Em: "+DtoC(Date())+"            |";nLinha:=nLinha+1
@ nLinha,001 PSAY "+----------------------------------------------------------------------------------------------------------------------------+";nLinha:=nLinha+1
@ nLinha,001 PSAY "| Matric. Cent.C   NOME                           Desc.Func            Data     Horas Not  Adici.Not  Total      Hor.Rediz.  |";nLinha:=nLinha+1
@ nLinha,001 PSAY "+----------------------------------------------------------------------------------------------------------------------------+"
/*                   999999  99999999 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX 99/99/99 999999999  999999999  999999999  9999999999
                   00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111111111111111111111111111111111111111111111111111111111111111
                   00000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999990000000001111111111222222222233333333334444444444555555555566666666667777777777
                   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 */
nLinha := nLinha + 1
Pagina := Pagina + 1
Return
