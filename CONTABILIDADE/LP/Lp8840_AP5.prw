#include "rwmake.ch"   
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function LP8840() 
SetPrvt("CVAR,CCOMBO,NVAR,NVAR1,NLIST,LCHECK1")
SetPrvt("LCHECK2,LCHECK3,LCHECK4,AITEMS,ARADIO,NRADIO")
SetPrvt("CARQNTX,CINDCOND,CARQSD3,CKEYSD3,CFILSD3,NINDEX1")
SetPrvt("XDOC,XLINHA,XLANCTO,TMPN,TMPI,TMSN,tLIN,tPI")
SetPrvt("TMSI,XGRUPO,XCC,XDEBITO,XVALOR,XCREDITO")
SetPrvt("XI,oDlg5")

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥LP8840    ≥ Autor ≥ Jorge S. da Silva     ≥ Data ≥ 02.09.00 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Lancamento Padrao - Requisicao de Materiais.                ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥RDMake <Programa.Ext> -w                                    ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Exemplo  ≥RDMake RDDemo.prw -w                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
**********************************************************
/* Atualizado por : Remerson Mogi
             Data : 31/08/06
        DescriÁ„o : Contabilizar os movimentos do tipo:
                    999/499 - Transferencia de materiais
                    300     - DevoluÁıes de materiais 
                    600/RT  - RequisiÁıes de retrabalho 
   ManutenÁ„o por : Remerson Mogi
             Data : 07/09/06
        DescriÁ„o : Acumular os movimentos sem CCusto 
                    ou CCusto sem conta para:
                    3211    - Conta Contabil Geral  
   ManutenÁ„o por : Remerson Mogi
             Data : 09/01/07
        DescriÁ„o : 1.CCusto Direrente de 211/221/231 
                    jogar para a conta contabil da
                    ProduÁ„o.                    
                    2.Filtrar os Sub-Conjuntos que s„o 
                    retrabalhados.
*/                  
**********************************************************


@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Lancamento Padrao - Req. Material."
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("LP8840")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa realizar os Lancamentos Padroes para o Pre-Lancamento"
@ 33,14 SAY "referente as Requisicoes de Materiais."
@ 43,14 SAY ""
@ 53,14 SAY "Obs.: Informe o Periodo das baixas nos Parametros."
ACTIVATE DIALOG oDlg5

Return nil

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥OkProc    ≥ Autor ≥ Jorge S. da Silva     ≥ Data ≥ 02.09.00 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Confirma o Processamento                                    ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/  

Static Function OkProc()

// Parametros
// Da Data             mv_par01
// Ate a Data          mv_par02
Processa( {|| RunProc() } )

Close(oDlg5)

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÑo    ≥RunProc   ≥ Autor ≥ Jorge S. da Silva     ≥ Data ≥ 02.09.00 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÑo ≥Executa o Processamento                                     ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/  
 Static Function RunProc()

 dbSelectArea("SD3")
 cArqSD3 := CriaTrab(NIL,.F. )
 cKeySD3 := "D3_Filial + D3_GRUPO + D3_CC" // IndexKey()
 cFilSD3 := "D3_FILIAL='"+xFilial("SD3")+"'.And.DTOS(D3_EMISSAO)>='"+DTOS(MV_PAR01)+"'.And.DTOS(D3_EMISSAO)<='"+DTOS(MV_PAR02)+"'"
// cFilSD3 += " .And. (D3_CF $ 'RE0/RE1/RE3/RE4/DE3/DE4')" Alt. para atender as necessidades da inclus„o das perdas no custo RE5/DE5 de alguns documentos    
 cFilSD3 += " .And. (D3_CF $ 'RE0/RE1/RE3/RE4/RE5/DE3/DE4/DE5')
 cFilSD3 += " .And. (D3_TIPO $ 'MC/ME/MP/MS/RT' )"
 //cFilSD3 += " .OR. (D3_TM = '999' .And. D3_LOCAL = '10')"   
 //cFilSD3 += " .OR. (D3_TM # '499' .And. D3_CF = 'DE4')"
  
 IndRegua("SD3",cArqSD3,cKeySD3,,cFilSD3,"Selecionando Registros...")

 ProcRegua(RecCount())
 dbGoTop()

xDoc    := 1
xLinha  := 1
xDebito := "" 

xLancto := {}
xTrans  := {}
xDevo   := {}

While !Eof()               
      
      //Transferencia
      IF D3_TM $ "999/499/"            
//            IF AllTrim(D3_CF) == "RE4" .and. D3_local=="10"   " Alt. para atender as necessidades da inclus„o das perdas no custo RE5/DE5 de alguns documentos    

            IF ( AllTrim(D3_CF) == "RE4" .and. D3_local=="10" ) .or. (AllTrim(D3_CF) == "RE5" .and. D3_local=="10" .and. D3_GRUPO#"GGF" )
               nPos := aScan(xTrans,{ |X| X[4] == AllTrim(D3_Grupo) .and. X[5] == SUBS(D3_CC,1,3)})
               SetTrans(nPos)
            ENDIF
            dbSkip()
            loop                      
      END 
      
      //DevoluÁ„o
      if alltrim(D3_TM) == "300" .And. (alltrim(D3_Tipo)$"MP/MS/") //.And. D3_Local == "20"           
         nPos := aScan(xDevo,{ |X| X[4] == AllTrim(D3_Grupo) .and. X[5] == SUBS(D3_CC,1,3)})
         SetDevo(nPos)
         dbSkip()
         loop  
      end           
 
      //FILTRO
      If D3_Estorno=="S" .Or. !(D3_TM $ "499/600/610/620/") .AND. !(alltrim(D3_Tipo)$"MC/ME/MP/MS/RT/")
         dbSkip()
         Loop
      End

      tMPN    := 0
      tMPI    := 0
      tMSN    := 0
      tMSI    := 0
      tPI     := 0
      tRT     := 0
      tME     := 0
      tMC     := 0
      tOUT    := 0 // Outros....
      lDevol  := .F.
          
      xGrupo  := AllTrim(D3_Grupo)
      xTipo   := AllTrim(D3_Tipo)
      xCC     := SUBS(D3_CC,1,3)
      xLocal  := D3_LOCAL      

      xDebito := GetContaCC(xCC,xGrupo)  
       
      While !Eof() .And. xGrupo==AllTrim(D3_Grupo) .And. xCC==SUBS(D3_CC,1,3)
            
            IncProc("Grupo: "+xGrupo + " CC: "+xCC +" Saida: "+D3_CF)
            
            //Transferencia
            IF D3_TM $ "999/499"            
               //IF AllTrim(D3_CF) == "RE4" .and. D3_local=="10"  Alterado para atender a necessidade das perdas no custo 02/08/2012                      
               IF ( AllTrim(D3_CF) == "RE4" .and. D3_local=="10" ) .or. (AllTrim(D3_CF) == "RE5" .and. D3_local=="10" .and. D3_GRUPO#"GGF" )
                  nPos := aScan(xTrans,{ |X| X[4] == AllTrim(D3_Grupo) .and. X[5] == SUBS(D3_CC,1,3)})
                  SetTrans(nPos)
               ENDIF
               dbSkip()
               loop                      
            END             

            //DevoluÁ„o
            if alltrim(D3_TM) == "300"  .And. (alltrim(D3_Tipo)$"MP/MS/") //.And. D3_Local == "20"             
               nPos := aScan(xDevo,{ |X| X[4] == AllTrim(D3_Grupo) .and. X[5] == SUBS(D3_CC,1,3)})
               SetDevo(nPos)
               dbSkip()
               loop  
            end                 
            
            //FILTRO
            If D3_Estorno=="S" .Or. !(D3_TM $ "600/610/620/") .AND. !(alltrim(D3_Tipo)$"MC/ME/MP/MS/RT/")
               dbSkip()
               Loop               
            End  
            //FILTRO Os Sub-Conjuntos Retrabalhados - Rmogi 09/01/07
            If AllTrim(D3_Tipo ) == "RT" .AND. alltrim(D3_Local) # "20"    
               dbSkip()
               Loop               
            End  
            
                       
            If     AllTrim(D3_Grupo) == "MPN"
               tMPN := tMPN + D3_Custo1
            ElseIf AllTrim(D3_Grupo) == "MPI"
               tMPI := tMPI + D3_Custo1
            ElseIf AllTrim(D3_Grupo) == "MSI"
               tMSI := tMSI + D3_Custo1
            ElseIf AllTrim(D3_Grupo) == "MSN"
               tMSN := tMSN + D3_Custo1
            ElseIf AllTrim(D3_Tipo ) == "RT" 
               tRT  := tRT  + D3_Custo1            
            ElseIf AllTrim(D3_Tipo ) == "ME" 
               tME  := tME  + D3_Custo1
            ElseIf AllTrim(D3_Tipo ) == "MC" 
               tMC  := tMC  + D3_Custo1            
            Else
               tOUT := tOUT + D3_Custo1
            End

            dbSkip()            
      EndDo  
      
      xCredito := ""
      xContas  := {}
            
      DO Case
      Case xGrupo == "MPN"      // MPN - Mat. Prima Nacional
            xCredito := "11221001" 
            aadd(xContas,{xDebito,xCredito,xGrupo,tMPN})
            aadd(xLancto,{"11221005",xDebito,tMPN,"Transf. p/ Processo - M.P.N."})      
         
      Case xGrupo == "MPI"      // MPI - Mat. Prima Importado   
            xCredito := "11221002" 
            aadd(xContas,{xDebito,xCredito,xGrupo,tMPI})
            aadd(xLancto,{"11221005",xDebito,tMPI,"Transf. p/ Processo - M.P.I."})
                         
      Case xGrupo == "MSN"      // MSN - Mat. Secundario Nacional. 
            xCredito := "11221003" 
            aadd(xContas,{xDebito,xCredito,xGrupo,tMSN})
            aadd(xLancto,{"11221006",xDebito,tMSN,"Transf. p/ PA - M.S.N."})
         
      Case xGrupo == "MSI"      // MSI - Mat. Secundario Importado.
            xCredito := "11221004" 
            aadd(xContas,{xDebito,xCredito,xGrupo,tMSI})
            aadd(xLancto,{"11221006",xDebito,tMSI,"Transf. p/ PA - M.S.I."})    
         
      Case xTipo == "RT"        // RT - Retrabalho.             
         	aadd(xContas,{"11221005","11221006",xGrupo,tRT})
         	aadd(xLancto,{"11221006","11221005",tRT,"PeÁas Retrabalhadas"})
                      
      Case xTipo == "ME"        // ME - Material de Embalagem.             
            xCredito := "11222007" 
            aadd(xContas,{xDebito,xCredito,xGrupo,tME})
            aadd(xLancto,{"11221006",xDebito,tME,"Transf. p/ PA - ME"})    

      Case xTipo == "MC"        // ME - Material de Embalagem.             
            xCredito := "11222009" 
            aadd(xContas,{xDebito,xCredito,xGrupo,tMC})
            aadd(xLancto,{"11221006",xDebito,tME,"Transf. p/ PA - MC"})    

      OTHERWISE
         xCredito := "11221" 
         aadd(xContas,{xDebito,xCredito,xGrupo,tOUT})
         aadd(xLancto,{IIF(D3_TM$"600/620","11221005","11221006"),xDebito,tOUT,"Produtos N.Ident. Vide Materiais."})
      EndCase

      dbSelectArea("CT2") 
      For xI:=1 to len(xContas) 
          //conout(xContas[xI][1]+"D "+ xContas[xI][2]+"C "+ "Cons. de "+xContas[xI][3]+" C.C.: "+xCC )  
          //conout(xContas[xI][4])
          
          RecLock("CT2",.T.)
          CT2->CT2_Filial  :=  xFilial()
          CT2->CT2_Lote    :=  "008840"
          CT2->CT2_SBLote  :=  "001"
          CT2->CT2_Doc     :=  StrZero(xDoc,6)
          CT2->CT2_Linha   :=  StrZero(xLinha,3)
          CT2->CT2_SeqLan  :=  StrZero(xLinha,3) 
          CT2->CT2_Data    :=  mv_par02
          CT2->CT2_DC      :=  "3"
          CT2->CT2_CCD     :=  xCC
          CT2->CT2_Debito  :=  xContas[xI][1]
          CT2->CT2_Credito :=  xContas[xI][2]
          CT2->CT2_Moedas  :=  "12222"
		  CT2->CT2_Moedlc  :=  "01"
          CT2->CT2_Valor   :=  xContas[xI][4]
          CT2->CT2_Hist    :=  IIF(xTipo=="RT","PeÁas para Retrabalho","Req. de "+xContas[xI][3]+" C.C.: "+xCC )
          CT2->CT2_SeqHis  :=  "001" 
          CT2->CT2_DtVenc  :=  mv_par02
          CT2->CT2_Origem  :=  "LP8840"
          CT2->CT2_FilOrig :=  "01"
          CT2->CT2_EmpOrig :=  "01"
          CT2->CT2_TPSald  :=  "9"
          CT2->CT2_Manual  :=  "1"
          CT2->CT2_Aglut   :=  "3"
          msUnlock()
       
          xLinha := xLinha + 1
      Next    
  
      dbSelectArea("SD3")

EndDo                   
conout("")
conout("lancamentos...")
For xI := 1 to Len(xLancto)
    dbSelectArea("CT2")
    //conout(xLancto[xI][1]+"D "+ xLancto[xI][2]+"C "+ xLancto[xI][4])  
    //conout(xLancto[xI][3])
    
    RecLock("CT2",.T.)
    CT2->CT2_Filial  :=  xFilial()
    CT2->CT2_Lote    :=  "008840"
    CT2->CT2_SBLote  :=  "001"
    CT2->CT2_Doc     :=  StrZero(xDoc+1,6)
    CT2->CT2_Linha   :=  StrZero(xI,3)
    CT2->CT2_SeqLan  :=  StrZero(xI,3) 
    CT2->CT2_Data    :=  mv_par02
    CT2->CT2_DC      :=  "3"
    CT2->CT2_CCD     :=  xCC
    CT2->CT2_Debito  :=  xLancto[xI][1]
    CT2->CT2_Credito :=  xLancto[xI][2]
    CT2->CT2_Moedas  :=  "12222"
    CT2->CT2_Moedlc  :=  "01"
    CT2->CT2_Valor   :=  xLancto[xI][3]
    CT2->CT2_Hist    :=  xLancto[xI][4]
    CT2->CT2_DtVenc  :=  mv_par02
    CT2->CT2_Origem  :=  "LP8840"
    CT2->CT2_FilOrig :=  "01"
    CT2->CT2_EmpOrig :=  "01"
    CT2->CT2_TPSald  :=  "9"
    CT2->CT2_Manual  :=  "1"
    CT2->CT2_Aglut   :=  "3"
    CT2->CT2_SeqHis  :=  "001" 
    msUnlock()
    
Next


conout("")
conout("Devolucao")
For xI := 1 to Len(xDevo)
     //conout(xI)
     //conout(xDevo[xI][1]+"D "+ xDevo[xI][2]+"C "+ " Grupo- "+xDevo[xI][4] + " CC " +xDevo[xI][5]+xDevo[xI][6])  
     //conout(xDevo[xI][3])
     
     RecLock("CT2",.T.)
     CT2->CT2_Filial  :=  xFilial()
     CT2->CT2_Lote    :=  "008840"
     CT2->CT2_SBLote  :=  "001"
     CT2->CT2_Doc     :=  StrZero(xDoc+2,6)
     CT2->CT2_Linha   :=  StrZero(xI,3)
     CT2->CT2_SeqLan  :=  StrZero(xI,3) 
     CT2->CT2_Data    :=  mv_par02
     CT2->CT2_DC      :=  "3"
     CT2->CT2_CCD     :=  xDevo[xI][5]
     CT2->CT2_Debito  :=  xDevo[xI][1]
     CT2->CT2_Credito :=  xDevo[xI][2]
     CT2->CT2_Moedas  :=  "12222"
     CT2->CT2_Moedlc  :=  "01"
     CT2->CT2_Valor   :=  xDevo[xI][3]
     CT2->CT2_Hist    :=  xDevo[xI][6]
     CT2->CT2_DtVenc  :=  mv_par02
     CT2->CT2_Origem  :=  "LP8840"
     CT2->CT2_FilOrig :=  "01"
     CT2->CT2_EmpOrig :=  "01"
     CT2->CT2_TPSald  :=  "9"
     CT2->CT2_Manual  :=  "1"
     CT2->CT2_Aglut   :=  "3"
     CT2->CT2_SeqHis  :=  "001" 
     msUnlock()
          
next       
       

conout("")
conout("Transferencia")
For xI := 1 to Len(xTrans)
     //conout(xI)
     //conout(xTrans[xI][1]+"D "+ xTrans[xI][2]+"C " + "Grupo "+xTrans[xI][4]+getMsgTransf(xTrans[xI][4]))  
     //conout(xTrans[xI][3])
     
     RecLock("CT2",.T.)
     CT2->CT2_Filial  :=  xFilial()
     CT2->CT2_Lote    :=  "008840"
     CT2->CT2_SBLote  :=  "001"
     CT2->CT2_Doc     :=  StrZero(xDoc+3,6)
     CT2->CT2_Linha   :=  StrZero(xI,3)
     CT2->CT2_SeqLan  :=  StrZero(xI,3) 
     CT2->CT2_Data    :=  mv_par02
     CT2->CT2_DC      :=  "3"
     CT2->CT2_CCD     :=  xTrans[xI][5]
     CT2->CT2_Debito  :=  xTrans[xI][1]
     CT2->CT2_Credito :=  xTrans[xI][2]
     CT2->CT2_Moedas  :=  "12222"
     CT2->CT2_Moedlc  :=  "01"
     CT2->CT2_Valor   :=  xTrans[xI][3]
     CT2->CT2_Hist    :=  getMsgTransf(xTrans[xI][4])
     CT2->CT2_DtVenc  :=  mv_par02
     CT2->CT2_Origem  :=  "LP8840"
     CT2->CT2_FilOrig :=  "01"
     CT2->CT2_EmpOrig :=  "01"
     CT2->CT2_TPSald  :=  "9"
     CT2->CT2_Manual  :=  "1"
     CT2->CT2_Aglut   :=  "3"
     CT2->CT2_SeqHis  :=  "001" 
     msUnlock()
              
next

dbSelectArea('CT2')    
RetIndex('CT2')  

dbSelectArea('SD3')
RetIndex('SD3')

Set Filter To

If !(Type('ArqSD3') == 'U')
        fErase(cArqSD3)
Endif
Return nil         

*******************************
//METODOS DE APOIO
*******************************

******************************************
/*Retorna a conta contabil do CCusto por Grupo do Materiais
@PARAMETER String Cconta,String cGrupo
@RETURN    String fDebito
*/
Static function getContaCC(cCC,cGrupo)
******************************************
fDebito := ""
      Do Case //Transferencia TM=999/499 e CF=RE4/DE4

         Case cCC == "211" .Or. left(cCC,2)=="71"  // M O N T A G E M
              If     cGrupo == "MPI"      // MPI - Mat. Prima Importado
                 fDebito := "32111001"
              ElseIf cGrupo == "MPN"      // MPN - Mat. Prima Nacional
                 fDebito := "32111002"
              ElseIf cGrupo == "MSI"      // MSI - Mat. secundario importado.
                 fDebito := "32111003"
              ElseIf cGrupo == "MSN"      // MSN - Mat. secundario nacional.
                 fDebito := "32111004"
              ElseIf cGrupo == "MCN" .and. cCC == "211"     // MCN - Mat. consumo nacional.
	             fDebito := "31121007"
              ElseIf cGrupo == "MCN" .and. Left(cCC,1)= "7"     // MCN - Mat. consumo nacional.
	             fDebito := "35121006"//-35121006"  
              End                    


         Case cCC == "221"  // I M P R E S S √ O
              If     cGrupo == "MPI"      // MPI - Mat. Prima Importado
                 fDebito := "32112001"
              ElseIf cGrupo == "MPN"      // MPN - Mat. Prima Nacional
                 fDebito := "32112002"
              ElseIf cGrupo == "MSI"      // MSI - Mat. secundario importado.
                 fDebito := "32112003"
              ElseIf cGrupo == "MSN"      // MSN - Mat. secundario nacional.
                 fDebito := "32112004"
              ElseIf cGrupo == "MCN"      // MCN - Mat. consumo nacional.
	             fDebito := "31221007"
              End

         Case cCC == "231"  // I N J E C A O
              If     cGrupo == "MPI"  // MPI - Mat. Prima Importado
                 fDebito := "32114001"
              ElseIf cGrupo == "MPN"  // MPN - Mat. Prima Nacional
                 fDebito := "32114002"
              ElseIf cGrupo == "MSI"  // MSI - Mat. secundario importado.
                 fDebito := "32114003"
              ElseIf cGrupo == "MSN"  // MSN - Mat. secundario nacional.
                 fDebito := "32114004"
              ElseIf cGrupo == "MCN"      // MCN - Mat. consumo nacional.
	             fDebito := "31421007"
              End
              
         Case cCC == "241"  // I N S E R C A O
              If     cGrupo == "MPI"  // MPI - Mat. Prima Importado
                 fDebito := "32113001"
              ElseIf cGrupo == "MPN"  // MPN - Mat. Prima Nacional
                 fDebito := "32113002"
              ElseIf cGrupo == "MSI"  // MSI - Mat. secundario importado.
                 fDebito := "32113003"
              ElseIf cGrupo == "MSN"  // MSN - Mat. secundario nacional.
                 fDebito := "32113004"
              ElseIf cGrupo == "MCN"      // MCN - Mat. consumo nacional.
	             fDebito := "31321007"
              End
              
         Case cCC == "251"  // S E N S O R  D O C O M B U S T I V E L
              If     cGrupo == "MPI"  // MPI - Mat. Prima Importado
                 fDebito := "32115001"
              ElseIf cGrupo == "MPN"  // MPN - Mat. Prima Nacional
                 fDebito := "32115002"
              ElseIf cGrupo == "MSI"  // MSI - Mat. secundario importado.
                 fDebito := "32115003"
              ElseIf cGrupo == "MSN"  // MSN - Mat. secundario nacional.
                 fDebito := "32115004"
              ElseIf cGrupo == "MCN"      // MCN - Mat. consumo nacional.
	             fDebito := "31621007"
              End
              
              
         OTHERWISE   //Outros Ccusto seram Debitadas no 211
              //fDebito := "3211    "
              If     cGrupo == "MPI"      // MPI - Mat. Prima Importado
                 fDebito := "32111001"
              ElseIf cGrupo == "MPN"      // MPN - Mat. Prima Nacional
                 fDebito := "32111002"
              ElseIf cGrupo == "MSI"      // MSI - Mat. secundario importado.
                 fDebito := "32111003"
              ElseIf cGrupo == "MSN"      // MSN - Mat. secundario nacional.
                 fDebito := "32111004"
              End                         
              If cGrupo="MCN" .and. Left(cCC,1)="6"
              	 fDebito := "31521007"
              EndIf
              If cGrupo="MCN" .and. Left(cCC,1)="1"
              	 fDebito := "35121006"
              EndIf

         EndCase
Return fDebito 

***********************************
/*Retorna o Nr. da Conta Contabil do Estoque.
@PARAMETER String cGrupo
@RETURN    String cfNroCt
*/
Static function getContaEst(cGrupo)
***********************************
cfNroCt:=""
   Do case 
     case AllTrim(cGrupo) == "MPI"  // MPI - Mat. Prima Importado
     cfNroCt := "11221002"
     case AllTrim(cGrupo) == "MPN"  // MPN - Mat. Prima Nacional
     cfNroCt := "11221001"
     case AllTrim(cGrupo) == "MSI"  // MSI - Mat. secundario importado.
     cfNroCt := "11221004"
     case AllTrim(cGrupo) == "MSN"  // MSN - Mat. secundario nacional.
     cfNroCt := "11221006" 
     OTHERWISE
     cfNroCt := "11221"            //  PNI - Produtos n„o Identificados
   endcase
Return cfNroCt 

************************************
/*Retorna a descriÁ„o do armazem
@PARAMETER String clocal
@RETURN    String cflocal*/
Static function getDesArmazem(clocal)
************************************
  cflocal:=""
  Do case
  case clocal == "01"
      cflocal := "DevoluÁ„o"
  case clocal == "10"
      cflocal := "Processo"
  case clocal == "20" 
      cflocal := "ExpediÁ„o P.A"
  case clocal == "40" 
      cflocal := "Refugo" 
  case clocal == "50" 
      cflocal := "Scrap"      
  Endcase 
Return cflocal    

***************************************************
/*Retorna o Historico da transferencia de materiais
@PARAMETER String cGrupo - Grupo do material
@RETURN    String cfMsg  - Historico
*/
Static function getMsgTransf(cGrupo)
**************************************************
  cfMsg:=""
  Do case
  case cGrupo == "MPI"
       cfMsg  := "Transf. p/ M.P.I. - Processo"
  case cGrupo == "MPN"
       cfMsg  := "Transf. p/ M.P.N. - Processo"
  case cGrupo == "MSI" 
       cfMsg  := "Transf. p/ M.S.I. - Processo"
  case cGrupo == "MSN" 
       cfMsg  := "Transf. p/ M.S.N. - Processo"
  Endcase 
Return cfMsg 


***************************************************
/*Retorna o Historico da DevoluÁ„o de Materiais
@PARAMETER String cCC    - Centro de Custo
@PARAMETER String cGrupo - Grupo do material
@RETURN    String cfMsg  - Historico
*/
Static function getMsgDevol(cCC,cGrupo)
**************************************************
  cfMsg:=""
  Do case
  case cGrupo == "MPI"
       cfMsg  := "Devol. de M.P.I. CC " + cCC
  case cGrupo == "MPN"
       cfMsg  := "Devol. de M.P.N. CC " + cCC
  case cGrupo == "MSI" 
       cfMsg  := "Devol. de M.S.I. CC " + cCC
  case cGrupo == "MSN" 
       cfMsg  := "Devol. de M.S.N. CC " + cCC
  Endcase 
Return cfMsg     
                                                  
***************************************************
/*Cadastra as transferencias de materiais
@PARAMETER Numeric nfPos - PosiÁ„o do grupo
@RETURN    Boolean loK   - Sucesso do cadastro
*/
Static function setTrans(nfPos)
**************************************************
lOk := .F.
if nfPos == 0
   aadd(xTrans,{    getContaEst(D3_Grupo) ,;              // 1 - Debitar  no ESTOQUE
                                "11221005",;              // 2 - Creditar no PROCESSO
                                D3_Custo1,;               // 3 - Custo
                                AllTrim(D3_Grupo),;       // 4 - Grupo 
                                SUBS(D3_CC,1,3),;         // 5 - CCusto
                                getMsgTransf(D3_Grupo)})  // 6 - Historico
   lOk := .T.                                       
else 
   xTrans[nfPos][3]+=D3_Custo1
   lOk := .T.
end                           
Return lOk   


***************************************************
/*Cadastra as DevoluÁıes de materiais
@PARAMETER Numeric nfPos - PosiÁ„o do grupo
@RETURN    Boolean loK   - Sucesso do cadastro
*/
Static function SetDevo(nfPos)
**************************************************
lOk := .F.
if nfPos == 0
   aadd(xDevo,{getContaEst(xGrupo),;                    // 1 - Debito
                           "11221005",;                 // 2 - Credito
                           D3_Custo1,;                  // 3 - Custo
                           AllTrim(D3_Grupo),;          // 4 - Grupo
                           SUBS(D3_CC,1,3),;            // 5 - CCusto
                           getMsgDevol(D3_CC,xGrupo)})  // 6 - Hisitorico  
  lOk := .T.         
else
  xDevo[nfPos][3]+=D3_Custo1       
  lOk := .T.
end              
Return lOk                                      