#include "rwmake.ch" 
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Estr22()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CBTXT,CBCONT,CABEC1,CABEC2,WNREL,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE,CSTRING")
SetPrvt("AORD,LCONTINUA,CUM,LEND,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,CPERG,XGERVO,XGERVP,XGERSA,_CFLAG")
SetPrvt("NORDEM,LI,M_PAG,NTIPO,XTOTQTD,XTOTVAL")
SetPrvt("XGERQTD,XGERVAL,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ESTR22   ³ Autor ³ Jorge Silveira        ³ Data ³ 19/07/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Perdas                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ rdmake ESTR22 -x                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

titulo    := PADC("Movimentação Interna.",74)
cDesc1    := PADC("Este Ralatorio tem como objetivo, apresentar a relação de Perdas,",74)
cDesc2    := PADC("(Scrap/Refugo), ou Devolução de Materiais para os armazens 50,40 ou 01",74)
cDesc3    := PADC("respectivamente conforme paramentros solicitados pelo usuário.",74)
tamanho   := "G"
limite    := 220
cString   := "SBC"
aOrd      := {} //-- Ordem
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "ESTR22"
nLastKey  := 0
cPerg     := "ESTR20"
xGerVo    := 0
xGerVp    := 0
xGerSa    := 0
_cFlag    :=.t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01             // Do O.Produção                       ³
//³ mv_par02             // Até O.Produção                      ³
//³ mv_par03             // Do Produto                          ³
//³ mv_par04             // Até o Produto                       ³
//³ mv_par05             // Do Recurso                          ³
//³ mv_par06             // Até o Recurso                       ³
//³ mv_par07             // Do Motivo                           ³
//³ mv_par08             // Até o Motivo                        ³
//³ mv_par09             // Da Data                             ³
//³ mv_par10             // Até a Data                          ³
//³ mv_par11             // Tipo de Devoloção (DRST)            ³
//³ mv_par12             // Localização (Inj/Imp/Mon)           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "ESTR22"
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,)

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
m_pag  := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Cabec1 :="TIPO        OP           DOC     DATA      Produto          Descrição                                           UM  TP  Grupo    Quant        Custo   Arm MT Descricao da Perda     Observacao" 
cabec2 :="Entre: "+dtoc(mv_par09)+" a "+dtoc(mv_par10)
//        Fornecedor  99999999999  999999  99/99/99  xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xx  xx  xxxx 999.999,99  999.999,99   99  xx xxxxxxxxxxxxxxxxxxxx  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//        01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                  111111111122222222223333333333444444444455555555556666666666777777777788888888889999999999111111111122222222223333333333

If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

 #IFDEF WINDOWS
      RptStatus({|| RptDetail()})
      Return
      Static Function RptDetail()
 #ENDIF

 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 //³ Inicio do Processamento da Nota Fiscal                       ³
 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 cbtxt  := Space(10)
 cbcont := 00
 xDocs := {}

 dbSelectArea("SBC")
 dbSetOrder(1)
 SetRegua(Reccount())
 dbSeek(xFilial("SBC")+mv_par01,.T.)
 While !Eof() .And.BC_OP <= mv_par02 .And. lContinua

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

       dbSelectArea("SB1")
       dbSetOrder(1)
       dbSeek(xFilial("SB1")+SBC->BC_PRODUTO)  
       
       dbSelectArea("SG1")
       dbSetOrder(2)
       dbSeek(xFilial("SG1")+SBC->BC_PRODUTO)  
       
       dbSelectArea("SD3")
       dbSetOrder(4)
       dbSeek(xFilial("SD3")+SBC->BC_SEQSD3)    
       
       dbSelectArea("SX5")
       dbSetOrder(1)
       dbSeek(xFilial("SX5")+"43"+SBC->BC_MOTIVO) 
       
       dbSelectArea("SBC")
       
       If BC_PRODUTO < mv_par03 .Or. BC_PRODUTO > mv_par04
          dbSkip()
          Loop  
       end                              
       
       If BC_DTRM < mv_par09 .Or. BC_DTRM > mv_par10
          dbSkip()
          Loop  
       end
         
       If BC_MOTIVO < mv_par07 .Or. BC_MOTIVO > mv_par08
          dbSkip()
          Loop
       End 

       If (mv_par11 # 5 .And. BC_TIPO == "D" .And. mv_par11 # 1) .Or. ;
          (mv_par11 # 5 .And. BC_TIPO == "R" .And. mv_par11 # 2) .Or. ;
          (mv_par11 # 5 .And. BC_TIPO == "S" .And. mv_par11 # 3) .Or. ;
          (mv_par11 # 5 .And. BC_TIPO == "T" .And. mv_par11 # 4)          
          dbSkip()
          Loop
       End 

       If (mv_par12 # 5 .And. SG1->G1_LOCPRO == "01" .And. mv_par12 # 1) .Or. ;
          (mv_par12 # 5 .And. SG1->G1_LOCPRO == "03" .And. mv_par12 # 2) .Or. ;
          (mv_par12 # 5 .And. SG1->G1_LOCPRO == "04" .And. mv_par12 # 3)
          dbSkip()
          Loop
       End 

       aadd(xDocs,{BC_TIPO,;                                   // 01
                   BC_OP,;                                     // 02
                   SD3->D3_DOC,;                               // 03
                   BC_DTRM,;                                   // 04
                   BC_PRODUTO,;                                // 05
                   SB1->B1_DESC,;                              // 06
                   SB1->B1_UM,;                                // 07
                   SB1->B1_TIPO,;                              // 08
                   SB1->B1_GRUPO,;                             // 09
                   SD3->D3_QUANT,;                             // 10
                   SD3->D3_CUSTO1,;                            // 11
                   BC_LOCAL,;                                  // 12
                   BC_MOTIVO,;                                 // 13
                   SubStr(SX5->X5_DESCRI,1,20),;               // 14
                   BC_OBS,;                                    // 15
                   SG1->G1_LOCPRO })                           // 16
          
       dbSkip()
       
 Enddo   
 
 aSort(xDocs,,,{|x,y| x[3]+x[5] < y[3]+y[5]} )
 
 For xI := 1 To Len(xDocs)
	XDESCTIPO := "*** "
	IF xDocs[xI][1]=="S"
	   XDESCTIPO := "SCRAP     "
	ELSEIF xDocs[xI][1]=="R"
	   XDESCTIPO := "REFUGO    "
	ELSEIF xDocs[xI][1]=="D"
		   XDESCTIPO := "DEVOLUCAO "
	ELSEIF xDocs[xI][1]=="T"			
		   XDESCTIPO := "RETRABALHO"
	ENDIF		

     @ li,000      PSAY XDESCTIPO
//     @ li,000      PSAY Iif(xDocs[xI][1]=="S","SCRAP     ",Iif(xDocs[xI][1]=="R","FORNECEDOR","DEVOLUCAO "))
     @ li,PCOL()+2 PSAY xDocs[xI][2]        // OP
     @ li,PCOL()+2 PSAY xDocs[xI][3]        // Documento
     @ li,PCOL()+2 PSAY dtoc(xDocs[xI][4])  // Data
     @ li,PCOL()+2 PSAY xDocs[xI][5]        // Produto
     @ li,PCOL()+2 PSAY xDocs[xI][6]        // Descricao do Produto
     @ li,PCOL()+2 PSAY xDocs[xI][7]        // UM
     @ li,PCOL()+2 PSAY xDocs[xI][8]        // Tipo
     @ li,PCOL()+2 PSAY xDocs[xI][9]        // Grupo
     @ li,PCOL()+2 PSAY Transform(xDocs[xI][10],"@E 99,999,999")       // Quantidade
     @ li,PCOL()+2 PSAY Transform(xDocs[xI][11],"@E 999,999.99")       // Custo
     @ li,PCOL()+2 PSAY xDocs[xI][12]       // Armazem
     @ li,PCOL()+2 PSAY xDocs[xI][13]       // Motivo
     @ li,PCOL()+2 PSAY xDocs[xI][14]       // Descricao do Motivo
     @ li,PCOL()+2 PSAY xDocs[xI][15]       // Observação
     @ li,PCOL()+2 PSAY xDocs[xI][16]       // Processo
     
     li := li + 1 
     
     IF li > 65
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
     EndIF
     
 Next
       
 IF li != 80
    roda(cbcont,cbtxt,tamanho)
 EndIF

 Set Device To Screen

 If aReturn[5] == 1
    Set Printer to
    dbCommitAll()
    ourspool(wnrel)
 Endif
 MS_FLUSH()      
 Return

