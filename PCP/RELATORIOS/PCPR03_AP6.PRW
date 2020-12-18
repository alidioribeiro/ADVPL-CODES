#include "rwmake.ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function PCPR03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,XCPI,GQUANT,GF_MPN,GF_MPI")
SetPrvt("GF_A04,GU_MPN,GU_MPI,GU_A04,GP_MPN,GP_MPI")
SetPrvt("GP_A04,GM_MPN,GM_MPI,GM_A04,GTMPFUN,GMODFUN")
SetPrvt("GMOIFUN,GGGFFUN,GMSNFUN,GMSIFUN,GTOTFUN,GTMPUSI")
SetPrvt("GMODUSI,GMOIUSI,GGGFUSI,GMSNUSI,GMSIUSI,GTOTUSI")
SetPrvt("GTMPPIN,GMODPIN,GMOIPIN,GGGFPIN,GMSNPIN,GMSIPIN")
SetPrvt("GTOTPIN,GTMPMON,GMODMON,GMOIMON,GGGFMON,GMSNMON")
SetPrvt("GMSIMON,GTOTMON,LI,M_PAG,NTIPO,XQUANT")
SetPrvt("NF_MPN,NF_MPI,NF_A04,NU_MPN,NU_MPI,NU_A04")
SetPrvt("NP_MPN,NP_MPI,NP_A04,NM_MPN,NM_MPI,NM_A04")
SetPrvt("NTMPFUN,NMODFUN,NMOIFUN,NGGFFUN,NMSNFUN,NMSIFUN")
SetPrvt("NTOTFUN,NTMPUSI,NMODUSI,NMOIUSI,NGGFUSI,NMSNUSI")
SetPrvt("NMSIUSI,NTOTUSI,NTMPPIN,NMODPIN,NMOIPIN,NGGFPIN")
SetPrvt("NMSNPIN,NMSIPIN,NTOTPIN,NTMPMON,NMODMON,NMOIMON")
SetPrvt("NGGFMON,NMSNMON,NMSIMON,NTOTMON,XDESC,XTIPO")
SetPrvt("XUM,XPRODUTO,CPRD,ASTRU,NESTRU,I")
SetPrvt("TPMPN,TPMPI,TPA04,TPTMP,TPMSN,TPMSI")
SetPrvt("TPMOD,TPMOI,TPGGF,TPTOT,TMEDIO,TGMPN")
SetPrvt("TGA04,TGMPI,TGTMP,TGMSN,TGMSI,TGMOD")
SetPrvt("TGMOI,TGGGF,TGTOT,XF_MPN,XF_MPI,XF_A04")
SetPrvt("XU_MPN,XU_MPI,XU_A04,XP_MPN,XP_MPI,XP_A04")
SetPrvt("XM_MPN,XM_MPI,XM_A04,XTMPFUN,XMODFUN,XMOIFUN")
SetPrvt("XGGFFUN,XMSNFUN,XMSIFUN,XTOTFUN,XTMPUSI,XMODUSI")
SetPrvt("XMOIUSI,XGGFUSI,XMSNUSI,XMSIUSI,XTOTUSI,XTMPPIN")
SetPrvt("XMODPIN,XMOIPIN,XGGFPIN,XMSNPIN,XMSIPIN,XTOTPIN")
SetPrvt("XTMPMON,XMODMON,XMOIMON,XGGFMON,XMSNMON,XMSIMON")
SetPrvt("XTOTMON,CCOMP,CCUSTO,CMEDIO,XPODE,ACM,MSEQUENCIA")
SetPrvt("xComp,xData,xDatFch,xMes,xCompra,xDatFin,xDatIni,xSalPed")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PCPR03   ³ Autor ³ Jorge Silveira        ³ Data ³ 15.07.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Geracao do MRP.                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake PCPR03 -X                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("MRP - Necessidades de Materiais. - Analitico",74)
cDesc1    := PADC("Este programa tem com objetivo, gerar as necessidades das Materias",74)
cDesc2    := PADC("Primas, conforme Plano Mestre de Producao.",74)
cDesc3    := ""
tamanho   := "G"
limite    := 220
cString   := "SHC"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "PCPR03"
nLastKey  := 0
cPerg     := "PCPR03"
cMes    := {}
aadd(cMes,{"Jan","31","08",})
aadd(cMes,{"Fev","28","09"})
aadd(cMes,{"Mar","31","10"})
aadd(cMes,{"Abr","30","11"})
aadd(cMes,{"Mai","31","12"})
aadd(cMes,{"Jun","30","01"})
aadd(cMes,{"Jul","31","02"})
aadd(cMes,{"Ago","31","03"})
aadd(cMes,{"Set","30","04"})
aadd(cMes,{"Out","31","05"})
aadd(cMes,{"Nov","30","06"})
aadd(cMes,{"Dez","31","07"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)

//³ Variaveis utilizadas para parametros  
//³ mv_par01  C  6   // Periodo Incial (mmaaaa)
//³ mv_par02  C  6   // Periodo Final (mmaaaa) 
//³ mv_par03  N 15   // Do Produto             
//³ mv_par04  N 15   // Ate o Produto          
//³ MV_PAR05  N  1   // Origem dos Insumos (Dentro/Fora/Importado
//³ MV_PAR06  N  1   // Grupo de Materiais 
//³ MV_PAR07  N  1   // Ate Grupo de Materiais 
//³ mv_par08  N 15   // Do Componente             
//³ mv_par09  N 15   // Ate o Componente          



//³ MV_PAR06  N  1   // Salta Pagina (Sim/Nao)                   
//³ MV_PAR07  N  1   // Gera Solcitacao Automatica (Sim/Nao) Obs. Somente Nacionais 
//³ MV_PAR08  N  1   // Considera Estoque PA (Sim/Nao)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "PCPR03"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Mv_par05 == 3
   MsgStop("Opção de MRP para Importação, em fase de desenvolvimento pelo CPD.")
   Return
End

cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01
cCabec  := ""
xQuant  := 0
cDiaIni := "01"
cMesIni := Val(subs(mv_par01,1,2))
cMesFin := Val(subs(mv_par02,1,2))
cDiaFin := cMes[cMesFin][02]
cAnoIni := Val(subs(mv_par01,3,4))
cAnoFin := Val(subs(mv_par02,3,4))
cDatIni := Ctod( cDiaIni+"/"+StrZero(cMesIni,2)+"/"+StrZero(cAnoIni,4) )
cDatFin := Ctod( cDiaFin+"/"+StrZero(cMesFin,2)+"/"+StrZero(cAnoFin,4) )

If ((cMesIni-cMesFin) < 7 .And. cAnoIni < cAnoFin) .Or.((cMesFin - cMesIni) >= 6 .And. cAnoIni == cAnoFin) 
   MsgStop("Periodo Estipulado, Ultrapasa 6 meses...")
   Return
ElseIf cMesIni > cMesFin .And. cAnoIni >= cAnoFin
   MsgStop("Periodo Inicial maior que Periodo Final...")
   Return
ElseIf cMesIni > 12 .or. cMesFin > 12
   MsgStop("Mes Invalido...")
   Return
ElseIf cMesIni == cMesFin .And. cAnoIni == cAnoFin                                                                             
   xQuant := 1
ElseIf cMesIni < cMesFin .And. cAnoIni == cAnoFin
   xQuant := cMesFin - cMesIni+1
ElseIf cMesIni > cMesFin .And. cAnoIni < cAnoFin
   xQuant := 13-(cMesIni - cMesFin)
End

// --------------------------------------------
// Monta cabecalho para impressao de relatorio.
// --------------------------------------------

dbSelectArea("SHC")
dbSetOrder(1)
dbSeek(xFilial("SHC") + dtos(cDatIni), .T.)

xCOL   := 055
xPOS   := {}
xMESES := {}
xIni   := HC_Data
While xIni <= cDatFin
    If Ascan( xMESES, MONTH(xIni)) == 0
       aadd(xMESES ,MONTH(xIni) )
       aadd(xPOS   ,xCOL )
       cCabec  := cCabec + cMes[MONTH(xIni)][1]+"/"+StrZero(year(xIni),4)+"        "
       xCOL := xCOL + 13
    Endif
    xIni := xIni + 1
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "MRP - Necessidade de Materiais (Analitico)"
cabec1 := "Produto         Cod.Comp.       Descricao Componente                     Tp Grp Um Setor     Qtd.Nec         " + cCabec
//cabec1 := "Produto         Cod.Comp.       Descricao Componente                     Tp Grp Um Setor      Quantidade        " + cCabec 
cabec2 := ""
//         999999999999999 999999999999999 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xx xxx xx xxxxxxxx  999.999999  999,999,999  999,999,999  999,999,999  999,999,999
//         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                 10        20        30        40        50        60        70        80        90        100       110      120       130       140        150       160       170       180       190       200       210       220       230       240       250       260

If nLastKey == 27
   Return
Endif

 #IFDEF WINDOWS
      RptStatus({|| RptDetail()})
      Return
      Static Function RptDetail()
 #ENDIF

 xGerMes := {} 
 gQMES   := 0
 gVMES   := 0
 gFMES   := 0
 ****************************  
 For xI := 1 to xQuant
     xM := StrZero(xI,2)
     cQuant  := "gQmes"+xM
     cQPrd   := "gQComp"+xM
     nMes   := "vMes"+StrZero(iif(cMesIni+xI-1>12,cMesIni+xI-13,cMesIni+xI-1),2) 
     &cQuant:= 0
     &nMes  := xI 
     &cQPrd  := 0 
 Next
 ****************************    
 nTipo  := IIF(aReturn[4]==1,15,18) 
 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)

 dbSelectArea("SHC")
 dbSetOrder(4)
 dbSeek(xFilial("SHC") + mv_par03 + dtos(cDatIni), .T.)
 SetRegua(RecCount())

 xMRP := {}
 While !Eof() .And. HC_Produto <= mv_par04 .And. lContinua
       
       IncRegua()
       
       #IFNDEF WINDOWS
             If LastKey() == 286
                lEnd := .t.
             End
       #ENDIF
       
       If lEnd
          @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
          lContinua := .F.
          Exit
       EndIf
       
       If HC_Data < cDatIni .Or. HC_Data > cDatFin
          dbSkip()
          Loop     
       EndIf
       
       nMes     := "vMes" + StrZero(month(SHC->HC_Data),2)
       xProduto := HC_Produto
       xPassa   := .T.
       
       While !Eof() .And. xProduto == HC_Produto
       
             If HC_Data < cDatIni .Or. HC_Data > cDatFin
                dbSkip()
                Loop     
             End
             
             nMes := "vMes"+strzero(month(SHC->HC_Data),2)
       		 
             dbSelectArea("SB1")
             dbSetOrder(1)
             dbSeek(xFilial("SB1")+SHC->HC_Produto)
             xDesc   := Subs(B1_Desc,1,40)
             xTipo   := B1_Tipo
             xUm     := B1_Um
             cPrd    := xProduto
             aStru   := {}
             nEstru  := 0
             i       := 0
             aStru   := Estrut(cPrd)  // Obtem a estrutura

             
             /*
             For i:=1 to 1 // len(aStru)
                 For j:=1 to 10
                     msgstop(strzero(j,2))
                     msgstop(aStru[i,j])
                 Next
             Next
             Return
             */
             
             
             For i:=1 to Len(aStru)  // Monta Estrutura de Produto.
                 
                 cComp  := aStru[i,3]
                 cQnec  := 0
                 xSetor := ""
                 
                 dbSelectArea("SG1")  // Estrutura de Produto
                 dbSetOrder(1)
                 dbSeek(xFilial("SG1")+aStru[i,2]+aStru[i,3]+aStru[i,5])
                 
                 dbSelectArea("SB1")  // Cadastro de Produto
                 dbSetOrder(1)
                 dbSeek(xFilial("SB1")+cComp)
                 
                 /*If     mv_par05==1 .And. mv_par05#3 .And. B1_Manaus # "S" 
                 		xPassa := .F.
                 ElseIf mv_par05==2 .And. mv_par05#3 .And. B1_Manaus == "S" 
                        xPassa := .F. 
                 ElseIf mv_par05==3 .And. mv_par05#3 .And. B1_Manaus == "S" 
                        xPassa := .F. 
                 EndIf*/ 
                 
                 If     (B1_COD < mv_par08 .Or. B1_COD > mv_par09) .or.;
                        (B1_Grupo < mv_par06 .Or. B1_Grupo > mv_par07) .or.;
                        (B1_MRP # "S")
                        xPassa := .F. 
                 EndIf    
                 
                 Do Case
                    Case SG1->G1_LOCPRO=="01"    //  FUNDICAO
                         xSetor := "Fundicao"
                    Case SG1->G1_LOCPRO=="02"    //  USINAGEM
                         xSetor := "Usinagem"
                    Case SG1->G1_LOCPRO=="03"    //  PINTURA
                         xSetor := "Pintura "
                    Case SG1->G1_LOCPRO=="  ".OR.SG1->G1_LOCPRO=="04"  //  MONTAGEM
                         xSetor := "Montagem"
                 EndCase
                 
                // If ( cDatIni >= SG1->G1_Ini .And. cDatFin <= SG1->G1_Fim) .And. ( SB1->B1_Tipo $ "MP" ) .And. xPassa
                 If (SHC->HC_DATA >= SG1->G1_INI .AND. SHC->HC_DATA <= SG1->G1_FIM) .AND. ( SB1->B1_Tipo $ "MP" ) .And. xPassa
                    
                     cQnec := aStru[i,4] * SHC->HC_Quant
                    
                     aadd(xMRP, {xProduto,;                   // 01 Produto
                                 cComp,;                      // 02 Componente
                                 Substr(SB1->B1_desc,1,40),;  // 03 Descricao
                                 SB1->B1_Tipo,;               // 04 Tipo
                                 Substr(SB1->B1_Grupo,1,3),;  // 05 Grupo
                                 SB1->B1_Um,;                 // 06 Unidade Medida
                                 xSetor,;                     // 07 Setor
                                 cQnec,;                      // 08 Quantidade
                                 SHC->HC_Data,;               // 09 Data
                                 aStru[i,4] })                // 10 Quant. na Estrut.
                 EndIf
                 xPassa   := .T.
             Next
              
             dbSelectArea("SHC")
             dbSkip()
       Enddo      
 Enddo  
 
 asort(xMRP,,,{|x,y| x[2]+x[1]+dtos(x[9]) < y[2]+y[1]+dtos(y[9]) })
 xPs:=0
 i  :=1
 While i <= len(xMRP) .And.lContinua
       IncRegua()
       #IFNDEF WINDOWS
             If LastKey() == 286
                lEnd := .T.
             End
       #ENDIF
       If lEnd
          @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
          lContinua := .F.
          Exit
       EndIf
 
       xComp:=xMRP[i][02]
 
       While xComp==xMRP[i][02] .And. i <= len(xMRP)                                              
             
             @ li,000      PSAY xMRP[i][01]   // PA
             @ li,PCOL()+1 PSAY xMRP[i][02]   // Componente
             @ li,PCOL()+1 PSAY xMRP[i][03]   // Descricao
             @ li,PCOL()+1 PSAY xMRP[i][04]   // Tipo
             @ li,PCOL()+1 PSAY xMRP[i][05]   // Grupo
             @ li,PCOL()+1 PSAY xMRP[i][06]   // Um
	         @ li,PCOL()+1 PSAY xMRP[i][07]   // Setor  
             xPs   := PCOL()+2
	         xPQ   := .T.
	         xQpPA := 0
	         xPA   := xMRP[i][01]  
             XPRI  := 0
             While xMRP[i][01] == xPA
                   
                   xMes  := month(xMRP[i][09])
                   xQPrd := 0
                   
                   While xMRP[i][01] == xPA .And. xMes==month(xMRP[i][09])
                         
                         xQpPA := xMRP[i][10] // xQpPA + xMRP[i][10]
                         xQPrd := xQPrd + xMRP[i][08]
                         nMes := "vMes"+strzero(Month(xMRP[i][09]),2)
                         xPos := &nMes
                   
                         i := i  + 1
                         If i > len(xMRP)
                            Exit
                         EndIf   
                   
                   EndDo
                   XPRI := XPRI + 1
                   if xPRI == 1
                      @ li,PCOL()+1 PSAY transform(xQpPA,"@E 999.9999")   // Quant.Strut.
                      xPs:=PCOL()+3
                   endif 
                   @ li,xPs+(xPos-1)*16 PSAY transform(xQPrd,"@E 9,999,999.9999")   // Quant.Necess.
                   xM      := strzero(xPos,2)
                   cQuant  := "gQmes" + xM
                   &cQuant := &cQuant + xQPrd
                   cQProd  := "gQComp"+ xM
                   &cQProd := &cQPrd  + xQPrd
                   
                   If i > len(xMRP)
                      Exit
                   EndIf   
             
             EndDo      
            
             li := li + 1
             If li > 55
                cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
             End
             If i > len(xMRP)
                Exit
             EndIf   
                               
       enddo
       i := i - 1
       If i <= len(xMRP)
          li   := li + 2
          @ li,000 PSAY "Total do Componente...." 
          xPs2 := xPs // + 3
          For xI := 1 to xQuant
              xM := StrZero(xI,2)
              cQPrd   := "gQComp"+xM
              If &cQPrd <> 0   
                 @ li,xPs2  PSAY transform(&cQPrd,"@E 9,999,999.9999")   // Por componente
              else
                 @ li,xPs2  PSAY "              "
              endif
              xPs2:= PCOL()+2
              &cQPrd  := 0 
          Next
       EndIf   
       i := i + 1
       li := li + 2
 EndDo
 
 li := li + 1
 @ li,000 PSAY "Total Geral............"   
// xPs:=xPs+3
 For xI := 1 to xQuant
     xM := StrZero(xI,2)
     cQuant  := "gQmes"+xM 
     If &cQuant <> 0
        @ li,xPs PSAY transform(&cQuant,"@E 9,999,999.9999")  // Quant.
     else
        @ li,xPs PSAY "              "
     endif
     xPs:=PCOL()+2
 Next    
  
 Set Device To Screen

 dbSelectArea('SHC')
 RetIndex('SHC')

 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()      
 Return
