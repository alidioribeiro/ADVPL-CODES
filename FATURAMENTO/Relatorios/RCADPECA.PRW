#INCLUDE "rwmake.ch"    
#Include "TOPCONN.CH"



User Function RCadPeca() 


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

titulo    := PADC("INFORMAÇÃO DO CADASTRO DE PECA ",74)
cDesc1    := PADC("Este programa tem como objetivO emitir o relatorio de faturamento ",74)
cDesc2    := ""
cDesc3    := ""
nlin      :=6
aORD      := {}//{"OP","PRODUTO","RECURSO"}
tamanho   := "M" // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
//limite    := 132
limite    := 220
cString   := "SD2"
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Contabilidade", 2, 2, 1, "",1 }
nomeprog  := "CADPECA"
nLastKey  := 0
cPerg := "CADPEC"


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
//³   mv_par01  - Do Cod Peca ?                                                        ³
//³   mv_par02  - Da  Revisao ?                                                     ³
//³   mv_par03  - Ate a Peca ?                                                         ³
//³   mv_par04  - Ate a Revisão ?                                                      ³
//³                                                                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel  := "CADPECA"

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

// Tipo:=IIf(mv_par07=1,"Analítico","Sintético")
 titulo := " Cadastro da Peça "//+Tipo

// if mv_par07=1
//	 cabec1 :="Cod|Nome do Cliente                           |Codigo           |Descrição do Produto                                 |UN |TP| Modelo        |Lote       |Vr. Venda        |Custo          |Margem Lucro"
// Else 	 
//	 cabec1 :="Cod|Nome do Cliente                           |Codigo           |Descrição do Produto                                 |UN |TP| Modelo        |Vr. Venda        |Custo          |Margem Lucro"
// EndIf 
 cabec1 :=""
 cabec2 := ""



If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
cQuery:=" select QK1_PECA,QK1_REV,QK1_PCCLI, "
cQuery+=" QK1_DESC,QK1_CODCLI,QK1_LOJCLI,QK2_ITEM,QK2_CODCAR,QK2_DESC, "
cQuery+="  QK2_ESPE,QK2_TPCAR,QK2_TOL,QK2_LIE,QK2_LSE,QK2_SIMB,QK2_UM,QK2_CHAVE,QK2_SIMB "
cQuery+="  from QK1010,QK2010 "
cQuery+="  WHERE "
cQuery+="  QK1_PECA=QK2_PECA "
cQuery+="  AND QK1010.D_E_L_E_T_='' "
cQuery+="  AND QK2010.D_E_L_E_T_='' "
cQuery+="  and QK1_PECA >= '"+mv_par01+"' "
cQuery+="  and QK1_PECA <= '"+mv_par03+"' "
cQuery+="  and QK1_REV >= '"+mv_par02+"' "
cQuery+="  and QK1_REV <= '"+mv_par04+"' "
cQuery+="  order by QK1_PECA,QK2_ITEM "

TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
DbGotop()
CodPec:=""
While !EOF ()       
/**/   
   @ nlin, 000      PSAY Replicate("-",limite)           
   CheckLin()    
   @ nlin,000 Psay "Nr. Peca: " +QK1_PECA +"   Revisao: " +QK1_REV      
   CheckLin()    
   @ nlin,000 Psay "Nr. Pc Cliente: "+QK1_PCCLI
   CheckLin()    
   @ nlin,000 Psay "Descrição peça : "+QK1_DESC
   CheckLin()    
   @ nlin,000 Psay "Codigo do Cliente: "+QK1_CODCLI+" Loja:"+ QK1_LOJCLI
   CheckLin()    
   @ nlin, 000      PSAY Replicate("-",limite)           
   CheckLin()    
   CodPec:=QK1_PECA
   While !Eof() 
   		if CodPec=QK1_PECA
			@ nlin,000      Psay "-> Item:"+ QK2_ITEM
			CheckLin()    
			@ nlin,000      Psay "Cod Caracter: "+QK2_CODCAR
			@ nlin,Pcol()+2 Psay "Decrição    : "+QK2_DESC
        	CheckLin()    
			@ nlin,000      Psay "Especif.: "+QK2_ESPE
    		@ nlin,Pcol()+2 Psay "Tipo Caract.: "+QK2_TPCAR
			CheckLin()  
			@ nlin,000      Psay "Tolerancia  : "+QK2_TOL
    		@ nlin,Pcol()+2 Psay "LIE : "+QK2_LIE
    		@ nlin,Pcol()+2 Psay "LSE : "+QK2_LSE
     		@ nlin,Pcol()+2 Psay "Simb: "+QK2_SIMB
    		@ nlin,Pcol()+2 Psay "UM  : "+QK2_UM
//    		@ nlin,Pcol()+2 Psay "Toleraipo Caract.: "+QK2_TPCAR
			CheckLin()    
   		Else
   		     Exit
   		EndIf 
		DbSelectArea("TRB")
    	DbSkip() 
	EndDo    	
Enddo          
DbSelectArea("TRB")
DbCloseArea("TRB") 

Set Device To Screen

If aReturn[5] == 1
   Set Printer to
   dbCommitAll()
   OurSpool(wnrel)
End

MS_FLUSH()      
Return 
/********************************************************************************/
/********************************************************************************/
Static Function CheckLin()
  nlin++ 
  if nLin>60
     nlin:=6
     Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
  Endif
Return 
