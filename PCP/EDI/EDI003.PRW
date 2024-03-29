#include "rwmake.ch"       

User Function EDI003()     

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("NOPCA,ODLG,CMENS,CGRV,CGRVF1,CGRVD1")
SetPrvt("CTYPE,CARQUIVO,ACPO,CTRB,CSTRING,CDESC1")
SetPrvt("CDESC2,CDESC3,TAMANHO,ARETURN,NOMEPROG,LCONTINUA")
SetPrvt("ALINHA,NLASTKEY,LEND,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,LI,M_PAG,WNREL,TVALPAG,TVALCOB")
SetPrvt("TVALOUT,XTITPAG,XTITCOB,XTITOUT,NTIPO,XVALDOC")
SetPrvt("XVALPAG,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � EDI003   � Autor 쿝emerson Yoshiyuki Mogi� Data � 04.05.08 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Importacao de arquivo kanban HONDA                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌lteracoes� * Jorge Em: 26/05/2009                                     낢�
굇�          � Solicitacao Honda - Foi incluido na Ordem de Expedicao, o  낢�
굇�          � Campo CK_Entrega (Local de Entrega)                        낢�
굇�          � * Jorge Em: 28/05/2009                                     낢�
굇�          � Substituida forma de identificacao da posicao do _aCols,   낢�
굇�          � do Numero informado, pelo ASCAN do vetor _aHeader.         낢�
굇�          � * Jorge Em: 14/09/2009                                     낢�
굇�          � Separacao da "ORDEM DE EXPEDICAO", sempre que o Cliente    낢�
굇�          � solicitar o "LOCAL DE ENTREGA" diferente em um mesmo       낢�
굇�          � Pedido de Compra (kanban).                                 낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂� 
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

nOpca  := 0
oDlg   := ""
cMens  := ""
cGrv   := ""
cGrvF1 := ""
cGrvD1 := ""
cGrv   := ""

@ 96,13 To 310,592 DIALOG oDlg TITLE "Importacao de arquivo de or�amento do kanban - HONDA"
@ 18, 6 To 66, 287
@ 29, 15 SAY OemToAnsi("Este programa tem como objetivo Importar os dados do arquivo (Kanban da Honda).")
@ 80, 160 BUTTON "Importar"  SIZE 34, 11 ACTION A010I()
@ 80, 220 BMPBUTTON TYPE 2 ACTION A010Fim()           
ACTIVATE DIALOG oDlg
Return 

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿌010I     � Autor 쿝emerson Yoshiyuki Mogi� Data � 01.11.06 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Selecionar o arquivo de Importacao de dados                낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
Static Function A010I()

nOpca    := 0
cType    := "Kanban da Honda | *.TXT"
cArquivo := cGetFile(cType, OemToAnsi("Selecione arquivo "+Subs(cType,1,17)))

If !Empty( cArquivo )
    If File( cArquivo) 
             nOpca := 1                        
    Else  
             MsgAlert("Arquivo nao encontrado")
    Endif
Endif

If nOpca == 1
   Processa({|| ProcImp() })
EndIf
Close(oDlg)
Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � ProcImp  � Autor 쿝emerson Yoshiyuki Mogi� Data � 03.05.08 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Processamento de Importacao dos Dados                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

Static Function ProcImp()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria Arquivo de Trabalho.                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
  aCpo := {} 
  
  AADD(aCpo,{"TR_TIPO"    ,"C",01,0})  // 09
  AADD(aCpo,{"TR_CODITE"  ,"C",25,0})  // 10
  AADD(aCpo,{"TR_DESITE"  ,"C",30,0})  // 11
  AADD(aCpo,{"TR_CODSEP"  ,"C",25,0})  // 12
  AADD(aCpo,{"TR_DTSEP"   ,"C",08,0})  // 13
  AADD(aCpo,{"TR_CODFIL"  ,"C",12,0})  // 14
  AADD(aCpo,{"TR_DESSET"  ,"C",30,0})  // 15
  AADD(aCpo,{"TR_TPOPED"  ,"C",02,0})  // 16
  AADD(aCpo,{"TR_NROPED"  ,"C",08,0})  // 17
  AADD(aCpo,{"TR_DTENTR"  ,"C",08,0})  // 18
  AADD(aCpo,{"TR_CODVIG"  ,"C",03,0})  // 19
  AADD(aCpo,{"TR_QTDTOT"  ,"C",07,0})  // 20
      
  For I:=1 to 24
      AADD(aCpo,{"TR_HRENT" + STRZERO(I,2) ,"C",4,0})
      AADD(aCpo,{"TR_QTD"   + STRZERO(I,2) ,"C",7,0})
      AADD(aCpo,{"TR_LINHA" + STRZERO(I,2) ,"C",6,0})  
  Next

  AADD(aCpo,{"TR_ENTREGA"  ,"C",30,0}) 

  cTRB   := CriaTrab(aCpo,.T.)
  dbUseArea(.T.,,cTRB,"TRB",.T.,.F.)
  
  Append From &(cArquivo) SDF // DELIMITED
  TRB->(dbgotop())
  
  A020I()  // Impressao do Relatorio.
  
  //----- Teste M�rcio -------------//
  //	While !TRB->(EOF())  	     
  //	     TRB->(dbSkip())  	     
  //	Enddo

  TRB->(dbCloseArea())
  fErase( cTRB )
  
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿌020I     � Autor 쿝emerson Yoshiyuki Mogi� Data � 01.11.06 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mpressao da saida dos produtos a ser faturado.             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
  
Static Function A020I()

cString   := "TRB"
cDesc1    := OemToAnsi("Este programa tem como objetivo, demostrar a utiliza눯o ")
cDesc2    := OemToAnsi("das ferramentas de impress�o do Interpretador xBase.      ")
cDesc3    := ""
tamanho   := "M"
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "EDI003"
lContinua := .T.
aLinha    := { }
nLastKey  := 0
lEnd      := .f.
titulo    := "                              K A N B A N   D A  H O N D A                                 "
cabec1    := "                                                        |            P R E V I S � O               " 
cabec2    := " Codigo NSB       Descri豫o                       Modelo|  Nro Ped  Cod  DT. Ent   Hora  Qtd/Prod TP Linha  Fl   Setor Destino Local Entrega"               
          //   123456789012345  123456789012345678901234567890  123456  12345678  123  DD/MM/AA  HH:MM  234.567 99 123456 1234 123456789012  123456789012  
          //  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          //            1         2         3         4         5         6         7         8         9        10        11         12        13
cCancel := "***** CANCELADO PELO OPERADOR *****"

li     := 80
m_pag  := 01

wnrel:="EDI003"            //Nome Default do relatorio em Disco
SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

RptStatus({|| RptDetail() })
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝ptDetail � Autor 쿕efferson Moreira      � Data � 03.05.08 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mpressao do corpo do relatorio                             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  

*******************************
Static Function RptDetail()
*******************************
vProd:={}

xNovoPlano := .T.
xGravaDB   := .T.

xCodProNSB := "" 

cPedido := 0
xItem   := 0
aInfPed := {}
nTipo   := IIF(aReturn[4]==1,15,18)
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

dbSelectArea("TRB")
SetRegua(RecCount())
dbGoTop()
While !EOF() .And. lContinua

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
    
          
      If TR_TIPO == "2"  
      
         xCodFilial := TR_CODFIL
         xDesSetor  := TR_DESSET                             // Local de Destino (Honda)       
         xTpPedido  := TR_TPOPED
         xCodProCli := SUBS(TR_CODITE,1,20)
         xNumPed    := TR_NROPED                             // Nro pedido do cliente
         xDtEnt     := TR_DTENTR                             // Data de entrega do pedido
         xEntrega   := TR_ENTREGA                            // Local de Entrega (Honda)
                 
         //Procura o codigo da NIPPON SEIKI
         DBSELECTAREA("SA7")                                 // TABELA PRODUTO POR CLIENTE
         DBSETORDER(4) //3
         IF DBSEEK(XFILIAL("SA7") + xCodProCli  )              // CODPRODCLI+CLIENTE            
            xCodProNSB    := A7_PRODUTO                      // Codigo do Produto NSB             	          	            	            
            xDesCliProNSB := AllTrim(A7_DESCCLI)+"  "+AllTrim(A7_PRODUTO)  // Descri豫o do Produto no Pedido 

            DBSELECTAREA("SB1")
            DBSETORDER(1)
            DBSEEK(XFILIAL("SB1") + xCodProNSB)
            xTes      := B1_TS                               // Tipo de Saida
            xDesr_NSB := B1_DESC                             // Descri豫o do Produto no Pedido 
              
            DBSELECTAREA("TRB")                 
                      
            For i:=1 to 24
                xHORA := "TR_HRENT" + STRZERO(I,2)              
                xQTD  := "TR_QTD"   + STRZERO(I,2)              
                xLIN  := "TR_LINHA" + STRZERO(I,2)
                      
                If &xHORA == "0000" .OR. VAL(&xQTD)==0
                   loop
                Else  
                   xHrEntreg :=&xHORA                       // Hora de entrega do pedido
                   xQtd      :=VAL(&xQTD)                   // Qtd do pedido de um determinado item e hora.    

                   aAdd(vProd,{xCodProNSB,;	   	            // 01 CODIGO DO PRODUTO
                               xDesr_NSB,;                  // 02 Descri豫o do produto
			                   xNumPed,;	                // 03 Nro pedido do cliente
			                   xDtEnt,;                     // 04 Data de entrega do pedido
			                   xTes,;                       // 05 Tipo de Saida do produto
			                   xHrEntreg,;                  // 06 Hora de entrega do pedido
			                   xQtd,;                       // 07 Numero do Item                     
			                   &xlin,;                      // 08 Linha
			                   xCodFilial,;                 // 09 Filial
                               xDesSetor,;                  // 10 Setor de Destino
                               xTpPedido,;                  // 11 Tp pedido
                               xEntrega})                   // 12 Local de Entrega
                End     
            Next                 

         Else  
            msgstop("Produto N�o Cadastrado..." + xCodProCli)
         End                            
      End         
      dbSkip()
End

asort(vProd,,,{|x,y| x[05] + x[06] < y[05] + y[06]})

For i:=1 to len(vProd)                  

         xProd := vProd[i][1]
         
         //Capturando os dados dos itens
         DBSELECTAREA("SB1")
         DBSETORDER(1)
         DBSEEK(XFILIAL("SB1") + xProd)         
         xUm        := B1_UM                                  //Unidade de medida
         xDesProNSB := B1_DESC                                //Descri豫o do produto
         xModelo    := B1_MODELO                              //Pre�o unitario         
         xLocal     := B1_LOCPAD                              //Armazem
         
         DBSELECTAREA("SF4")                             //TABELA PRODUTO POR CLIENTE
         DBSETORDER(1)
         DBSEEK(XFILIAL("SF4") + vProd[i][5])            //FILIAL+CODIGO(TES)
         xCFiscal:= Subs(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB   //Situacao tributaria

         DBSELECTAREA("SA1")                             //Capturando dados do cliente
         dbSetOrder(1)
         DBSEEK(XFILIAL("SA1") + "002" )                 //Clinte Honda                                       
         xTabela := A1_TABELA
         xTipoCli:= A1_TIPO
         xCondPg := A1_COND
         xTransp := A1_TRANSP
                 
         DBSELECTAREA("DA0")                             //Capturando a tabela do cliente
         dbSetOrder(1)
         DBSEEK(XFILIAL("DA0") + xTabela )                                                   
                 
         DBSELECTAREA("DA1")                             //Capturando os valores da tabela 
         dbSetOrder(1)                                   //FILIAL + TABELA + PRODUTO
         DBSEEK(XFILIAL("DA1") + xTabela +  xProd)                                                   
         xPrcVen := DA1_PRCVEN         

         @ li,001      PSAY SUBS(vProd[i][1],1,15) 
         @ li,PCOL()+2 PSAY SUBS(xDesProNSB,1,30) 
         @ li,PCOL()+2 PSAY SUBS(xModelo,1,6)        
         
         @ li,PCOL()+2 PSAY vProd[i][3]                  
         @ li,PCOL()+2 PSAY vProd[i][5]
         @ li,PCOL()+2 PSAY SUBS(vProd[i][4],1,2)+"/"+SUBS(vProd[i][4],3,2)+"/"+SUBS(vProd[i][4],7,2)
                  
         @ li,083      PSAY SUBS( vProd[i][6],1,2)+":"+SUBS( vProd[i][6],3,2)         
         @ li,PCOL()+2 PSAY TRANSFORM(vProd[i][7],"@E 999,999") 
         @ li,PCOL()+1 PSAY vProd[i][11] 
         @ li,PCOL()+1 PSAY vProd[i][8]
         @ li,PCOL()+1 PSAY SUBS(vProd[i][9],8,5)//@ li,PCOL()+1 PSAY SUBS(vProd[i][9],8,4) Alterado para atender o xml da Honda do siga
         @ li,PCOL()+1 PSAY SUBS(vProd[i][10],1,20)          
         @ li,PCOL()+1 PSAY SUBS(vProd[i][12],1,20)          
         li++
         
         If vProd[i][5] # vProd[IIF(i>1,i-1,1)][5] .or. vProd[i][6] # vProd[IIF(i>1,i-1,1)][6] .or. i==1        

              cPedido := ""
            //cPedido:=GetSX8Num("SCJ","CJ_NUM")
            //ConfirmSX8()             
          
            lExiste := .T.
			Do While lExiste
	            cPedido:=GetSX8Num("SCJ","CJ_NUM")
				confirmsx8()      
				If Empty(POSICIONE('SCJ', 1,  xFilial('SCJ')+ cPedido, 'CJ_NUM'))
				   lExiste := .F.
				Endif
			Enddo           
            
            dbSelectArea("SCJ") 
                       
            xItem:=1                        
            //Tabela Orcamentos de Venda
            RecLock("SCJ",.T.)
                   SCJ->CJ_FILIAL := xFilial("SCJ")
                   SCJ->CJ_NUM    := cPedido
                   SCJ->CJ_TIPO   := "N"
                   SCJ->CJ_CLIENTE:= "002"
                   //SCJ->CJ_TIPOCLI:= xTipoCli
                   SCJ->CJ_LOJAENT:= "01"
                   SCJ->CJ_LOJA   := "01"
                   SCJ->CJ_MOEDA  := 1
                   //SCJ->CJ_ESPECI1:= "GRANEL"
                   SCJ->CJ_TIPLIB := "1"
                   SCJ->CJ_CLIENT := "002"
                   SCJ->CJ_CONDPAG:= xCondPg
                   //SCJ->CJ_TRANSP := xTransp
                   SCJ->CJ_TABELA := xTabela
                   //SCJ->CJ_MENNOTA:= "FAVOR CHECAR O Nro. DO LACRE 000 ."                   
                   SCJ->CJ_STATUS := 'A'
                   SCJ->CJ_EMISSAO:= CTOD(SUBS(vProd[i][4],1,2)+"/"+SUBS(vProd[i][4],3,2)+"/"+SUBS(vProd[i][4],7,2))  // Deixar a emissao igual a entrega item   // dDataBase
                   SCJ->CJ_TPCARGA:= '1'
			       SCJ->(MsUnlock())
                  
         End         
       
         // Novo Item
         DBSELECTAREA("SCK")
         // dbSetOrder(1)
         // DBSEEK(XFILIAL("SCK") + vProd[i][3]  )                                                   
         RecLock("SCK",.T.)
                SCK->CK_FILIAL := xFilial("SCK")
                SCK->CK_NUM    := cPedido
                SCK->CK_PRODUTO:= xProd
                SCK->CK_UM     := xUm
                SCK->CK_QTDVEN := vProd[i][7]                           
                SCK->CK_PRCVEN := xPrcVen
                SCK->CK_VALOR  := vProd[i][7]*xPrcVen                          
                SCK->CK_PRUNIT := xPrcVen                           
                SCK->CK_TES    := vProd[i][5]
                SCK->CK_CLASFIS:= xCFiscal
                SCK->CK_DESCRI := vProd[i][2]
                SCK->CK_ITEM   := strzero(xItem,2)
				SCK->CK_PEDCLI := vProd[i][3]
                SCK->CK_ENTREG := CTOD(SUBS(vProd[i][4],1,2)+"/"+SUBS(vProd[i][4],3,2)+"/"+SUBS(vProd[i][4],7,2))
                SCK->CK_HORA   := vProd[i][6]                                                                          
                SCK->CK_LOCAL  := xLocal
                SCK->CK_LINHA  := vProd[i][8]
                SCK->CK_SETOR  := vProd[i][10]
                SCK->CK_TPEDIDO:= vProd[i][11]
                SCK->CK_FILVEN := '01'
                SCK->CK_FILENT := '01'
                SCK->CK_CLIENTE:= '002'
                SCK->CK_LOJA   := '01'
                SCK->CK_ENTREGA:= vProd[i][12]
                SCK->CK_LOCALIZ:= "EXPEDICAO"
                SCK->CK_FILIALP:= SUBS(vProd[i][9],8,5)//Inclus�o para atender a Honda dia 10/2011

                // ************************************** IMPORTANTE **********************************//
                //                     NAO ESQUECER DE ALTERAR O PROGRAMA NSACDG03                     //
                // ************************************** IMPORTANTE **********************************//
                                
                //SCK->CK_TPOP   := "F"
                //SCK->CK_CLI    := "002"
                //SCK->CK_CLASFIS:= xSitTrb
         MsUnlock()                                              
         AADD(aInfPed,{CK_NUM,CK_ITEM,CK_HORA,CK_LOCAL,CK_LINHA,CK_SETOR,CK_TPEDIDO,CK_ENTREGA})                  
         xItem++         
                                
Next

Roda(0,"","M")
Set Filter To

dbCloseArea()
fErase( cTRB )
dbClearFil(NIL)
dbCloseArea("TRB")
dbCloseArea()

If aReturn[5] == 1
    Set Printer To
    Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return


**********************************
Static Function A010Fim()
**********************************
Close(oDlg)

Return 




/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � MTA416PV � Autor 쿕efferson Mpreira      � Data � 04.06.08 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Atualizacao do pedido conforme orcamento de venda          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � AP8 Efetivacao do Orcamento de Venda                       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌lteracoes� * Jorge Em: 26/05/2009                                     낢�
굇�          � Solicitacao Honda - Foi incluido na Ordem de Expedicao, o  낢�
굇�          � Campo CK_Entrega (Local de Entrega)                        낢�
굇�          � * Jorge Em: 28/05/2009                                     낢�
굇�          � Substituida forma de identificacao da posicao do _aCols,   낢�
굇�          � do Numero informado, pelo ASCAN do vetor _aHeader.         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/                                                                              

**********************************
User Function MTA416PV()
**********************************

xNum  := SUBS(_aCols[Len(_aCols)][41],1,6)
xItem := SUBS(_aCols[Len(_aCols)][41],7,2)

dbSelectArea('SCK')
dbSetOrder(1)
If dbSeek(xFilial("SCK") + xNum + xItem )

   dbSelectArea("SA7") //Tabela: Produto X Cliente
   dbSetOrder(2)
   If dbSeek(xFilial("SA7") + SCK->CK_Produto + SCK->CK_CLIENTE + SCK->CK_LOJA)
      xDesCliProNSB := AllTrim(A7_DESCCLI)+"  "+Iif(SCK->CK_TES$"520",AllTrim(A7_CodAste),AllTrim(A7_CodCli))
   Else                                     
      xDesCliProNSB := SCK->CK_DESCRI                                //Descri豫o do Produto da NSB
   End
           
   dbSelectArea('SCK')
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_LINHA"	   })] := CK_LINHA
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_HORA"	   })] := CK_HORA
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_TPEDIDO"  })] := CK_TPEDIDO
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_SETOR"	   })] := CK_SETOR
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_DESCRI"   })] := xDesCliProNSB + " LOTE: "+ ALLTRIM(CK_LOTECTL) + " PED: " + CK_PEDCLI
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_ENTREGA"  })] := CK_ENTREGA    
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_LOTECTL"  })] := CK_LOTECTL
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_LOCALIZ"  })] := CK_LOCALIZ   
   _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_FILIALP"  })] := CK_FILIALP //Incluido para atender a Honda dia 10/06
   //
   M->C5_VOLUME1 += _aCols[Len(_aCols)][ASCAN(_aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN" })]
   //
   If Empty(M->C5_ESPECI1) .AND. ( Alltrim(M->C5_CLIENTE) == "028" .OR. Alltrim(M->C5_CLIENTE) == "002" )
   	  M->C5_ESPECI1   := "GRANEL"
   Endif
   If Empty(M->C5_MENNOTA)
      M->C5_MENNOTA := "FAVOR CHECAR O No. DO LACRE: "  
   Endif
   //
Endif
dbCloseArea('SCK')
Return  
