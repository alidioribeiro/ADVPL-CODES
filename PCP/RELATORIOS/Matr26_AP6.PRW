#include "rwmake.ch"  
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function XMatr26()
Private cDirDocs  := MsDocPath() //Path para arquivo TMPorario. Se nao existir,
Private cPath	    := AllTrim(GetTempPath()) 
Private oExcelApp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,GMPN,GMPI,GMSN,GMSI")
SetPrvt("GOUT,GQUANT,_CFLAG,LI,M_PAG,NTIPO")
SetPrvt("cProduto,aStru,NESTRU,I,XDESC,XTIPO")
SetPrvt("XUM,XGRUPO,TMEDIO,CCOMP,CQUANT,CCUSTO,CPERDA")
SetPrvt("ACM,CMEDIO,PCOMPRA,CCOMPRA,XTOTMPN,XTOTMPI")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR26   ³ Autor ³ Jorge Silveira        ³ Data ³ 15.07.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ESTRUTURA DE PRODUTOS.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake MATR26 -X                                           ³±±
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

titulo    := PADC("Formacao de Precos.",74)
cDesc1    := PADC("Este programa tem com objetivo, apresentar o Custo dos Produtos.",74)
cDesc2    := PADC("conforme seus insumos cadastrados na Estrutura de Produtos.",74)
cDesc3    := ""
tamanho   := "M"
limite    := 132
cString   := "SG1"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nomeprog  := "MATR26"
nLastKey  := 0
cPerg     := "MATR02"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01     // Produto inicial                              ³
//³ MV_PAR02     // Produto final                                ³
//³ MV_PAR03     // Prc.Uit.Sujerido (Ult.Prc.Comrpra...         ³
//³ MV_PAR04     // Quant.Basica                                 ³
//³ MV_PAR05     // Impr. Estrutura (Sim/Nao)                    ³
//³ MV_PAR06     // Salta Pag. Impr. Estrutura (Sim/Nao)         ³
//³ MV_PAR07     // Quanto ao Idioma? (Portugues/Ingles)         ³
//³ MV_PAR08     // Do C.de Custo                                ³
//³ MV_PAR09     // Ate o C.de Custo                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "MATR26"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := Space(10)
cbcont := 00
li     := 80
m_pag  := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo := "Formacao de Precos Pelo - Ult.Prc.Compra / Custo de Entrada"
cabec1 := "Codigo          Tp Descricao                       Um  Grp    Quantidade        CUSTO UNITARIO                   CUSTO TOTAL  " 
cabec2 := "                                                                           Prc. Compra  Cust.Entrada    Preco Compra   Custo Entrada"
//         999999999999999 xx xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xx  999  9,999.999999  9.999.999999  9.999.999999  999.999.999999  999.999.999999
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                   111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999000000000011111111112222222222333

If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

 #IFDEF WINDOWS
      RptStatus({|| RptDetail()})
      Return
      Static Function RptDetail()
 #ENDIF

 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ Inicio do Processamento da Nota Fiscal                       ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
//  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
//------
aCampos:={} 
AADD(aCampos, {"CODIGO"     ,"C",15,0 })
AADD(aCampos, {"CC"         ,"C", 9,0 })
AADD(aCampos, {"DESCPAI"    ,"C",50,0 })
AADD(aCampos, {"GRUPOPAI"   ,"C",04,0 })
AADD(aCampos, {"TIPOPAI"    ,"C",02,0 })
AADD(aCampos, {"UNPAI"      ,"C",02,0 })
AADD(aCampos, {"COMPONENTE" ,"C",15,0 })
AADD(aCampos, {"DESCOMP"    ,"C",50,0 })
AADD(aCampos, {"GRUPOCOMP"  ,"C",04,0 })
AADD(aCampos, {"TIPOCOMP"   ,"C",02,0 })
AADD(aCampos, {"UNCOMP"     ,"C",02,0 })
AADD(aCampos, {"QTDEENG"    ,"N",12,6 })
AADD(aCampos, {"PRCCOMPRA"  ,"N",16,6 })
AADD(aCampos, {"CUSTENTRA"  ,"N",16,6 })
AADD(aCampos, {"TOTPRCOMP"  ,"N",16,6 })
AADD(aCampos, {"TOTCUSENT"  ,"N",16,6 })
cArq := Criatrab( ,.F.)
dbCreate(cDirDocs+"\"+cArq,aCampos,"DBFCDXADS")             //Cria o arquivo no caminho especificado
dbUseArea(.T.,"DBFCDXADS",cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.
//------
 cbtxt  := Space(10)
 cbcont := 00
 
 gpCompra := 0
 gcCompra := 0
 
 dbSelectArea("SG1")
 dbSetOrder(1)
 SetRegua(RecCount())
 dbSeek(xFilial("SG1")+mv_par01,.T.)

 While !Eof() .And. G1_Cod <= mv_par02 .And. lContinua

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
       Endif

       cProduto := G1_Cod
       aStru    := {}
       nEstru   := 0
       i        := 0
       aStru    := Estrut(cProduto)  // Obtem a estrutura
       
       dbSelectArea("SB1")
       dbSetOrder(1)
       dbSeek(xFilial("SB1")+cProduto)
       xDesc  := IIF(MV_PAR07==1,SB1->B1_DESC,SB1->B1_DESC_EN)
       xTipo  := B1_Tipo
       xUm    := B1_Um
       xGrupo := B1_Grupo
       xCC    := B1_CC
       
       TotCompra := 0
       TotCusto  := 0
       TotQuant  := 0
       XTOTMPN   := 0
       XTOTMPI   := 0

       If AllTrim(xTipo) $ "PA/PI" .And. (xCC >= Mv_Par08 .And. xCC <= Mv_Par09)
       
          cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
                                
          If Len(aStru) > 0
             @ li,000         PSAY cProduto
             @ li,PCOL()+2    PSAY xDesc
             @ li,PCOL()+2    PSAY xTipo
             @ li,PCOL()+2    PSAY xGrupo
             li := li + 2
          End   
    
          For i:=1 to Len(aStru)
              ImpEstr()
              If li > 55
                 cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
              End
          Next
          
          li := li + 1
          @ li,000  PSAY "Custo de insumos para producao de "+Transform(mv_par04,"@E 999,999")+" peca(s)."
          @ li,058  PSAY Transform(TotQuant*mv_par04,"@E 999,999.999999")
          @ li,102  PSAY Transform(TotCompra*mv_par04,"@E 999,999.999999")
          @ li,116  PSAY Transform(TotCusto *mv_par04,"@E 9,999,999.999999")
        
          li := li + 2                
          @ li,000  PSAY "RESUMO DAS MAT. PRIMAS, PELO CUSTO MEDIO."
          li := li + 1                
          @ li,000  PSAY "Total de Mat. Prima Nacional."      
          @ li,102  PSAY Transform((xTotMpn / TotCusto * 100),"@E 999.99 %")
          @ li,116  PSAY Transform(xTotMpn*mv_par04,"@E 9,999,999.999999")
          li := li + 1
          @ li,000  PSAY "Total de Mat. Prima Importada."
          @ li,102  PSAY Transform((xTotMpi/TotCusto*100),"@E 999.99 %")
          @ li,116  PSAY Transform(xTotMpi*mv_par04,"@E 9,999,999.999999")
          
       End
       
       dbSelectArea("SG1")

 EndDo

 Set Device To Screen

 dbSelectArea('SG1')
 RetIndex('SG1')
 
 dbSelectArea('SD1')
 RetIndex('SD1')

 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 
 //-----

 SExcel:=Msgbox("Confirma geração dos dados em Excel","Planilha","YESNO")
 If  SExcel
      cDirDocs  :="\RELATO\"
      cPath="C:\RELATORIO_SIGA\"
	  cNome := "MATR26 - "+Dtos(dDataBase)+".xls
	  
  	  dbSelectArea("TRX")
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
 
 DbSelectArea("TRX")
 DbcloseArea("TRX")
// 
 MS_FLUSH()      
 Return

 **************************
 Static Function ImpEstr()
 **************************

  cComp  := aStru[i,3]
  cQuant := aStru[i,4] 
  cPerda := aStru[i,6] 
  // cQuant := aStru[i,4] + aStru[i,4] * (SG1->G1_PERDA/100)
  
  dbSelectArea("SB1")
  dbSetOrder(1)
  dbSeek(xFilial("SB1")+cCOMP)
  
  dbSelectArea("SB2")
  dbSetOrder(1)
  dbSeek(xFilial("SB1")+cCOMP+"01")
  
  dbSelectArea("SB1")

  If SB1->B1_Tipo $ "MP/PI"
     If mv_par05 == 1 .And. cQuant > 0       
        @ li,000         PSAY cCOMP
        @ li,PCOL()+1    PSAY SB1->B1_TIPO
        @ li,PCOL()+1    PSAY IIF(MV_PAR07==1,SUBS(SB1->B1_DESC,1,30),SUBS(SB1->B1_DESC_EN,1,30))
        @ li,PCOL()+2    PSAY SB1->B1_UM
        @ li,PCOL()+2    PSAY Subs(SB1->B1_GRUPO,1,3)
        @ li,PCOL()+2    PSAY Transform(cQuant,  "@E 9,999.999999")
        If AllTrim(SB1->B1_TIPO) == "MP"
           PgUltPrc()
           tQuant   := cQuant
           tpCompra := ( pCompra * cQuant )
           tcCompra := ( cCompra * cQuant )
           @ li,PCOL()+2    PSAY Transform(pCompra, "@E 9,999.999999")
           @ li,PCOL()+2    PSAY Transform(cCompra, "@E 9,999.999999")
           @ li,PCOL()+2    PSAY Transform(tpCompra,"@E 999,999.999999")
           @ li,PCOL()+2    PSAY Transform(tcCompra,"@E 999,999.999999")
           TotQuant  := TotQuant  + tQuant
           TotCompra := TotCompra + tpCompra
           TotCusto  := TotCusto  + tcCompra
           
           If AllTrim(SB1->B1_GRUPO) == "MPN"
              XTOTMPN := XTOTMPN + tcCompra
           ElseIf AllTrim(SB1->B1_GRUPO) == "MPI"   
              XTOTMPI := XTOTMPI + tcCompra
           EndIf
           
          //---------
	      RecLock("TRX",.T.)
		  TRX->CODIGO		:=	cProduto
		  TRX->CC		    :=	xCC
		  TRX->DESCPAI		:=  xDesc
		  TRX->GRUPOPAI		:=  xGrupo
		  TRX->TIPOPAI		:=  xUM
		  TRX->UNPAI		:=  xUm
		  TRX->COMPONENTE	:=  cComp
		  TRX->DESCOMP		:=  IIF(MV_PAR07==1,SUBS(SB1->B1_DESC,1,30),SUBS(SB1->B1_DESC_EN,1,30))
		  TRX->GRUPOCOMP	:=  SB1->B1_GRUPO
		  TRX->TIPOCOMP		:=  SB1->B1_TIPO
		  TRX->UNCOMP		:=  SB1->B1_UM
		  TRX->QTDEENG		:=  cQuant
		  TRX->PRCCOMPRA	:=  pCompra
		  TRX->CUSTENTRA	:=  cCompra
		  TRX->TOTPRCOMP	:=  tpCompra
		  TRX->TOTCUSENT	:=  tcCompra
   		  Msunlock()  
          //           
          dbSelectArea("SB1")
        End   
        li := li + 1
     End                            
     
  End

 Return


 **************************
 Static Function PgUltPrc()
 **************************
 pCompra := 0 
 cCompra := 0
 dbSelectArea("SD1")
 dbSetOrder(7)
 dbSeek(xFilial("SD1")+cCOMP)
 While !Eof() .And. D1_Cod == cCOMP
       If D1_TIPO <> "N"
          dbSkip()
          Loop
       End   
       pCompra := D1_VUNIT
       cCompra := SB2->B2_CM1
       //cCompra := (D1_Custo / D1_Quant)
       dbSkip()
 EndDo
 Return()
