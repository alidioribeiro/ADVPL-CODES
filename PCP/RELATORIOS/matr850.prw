#INCLUDE "rwmake.ch"    
#Include "MATR850.CH"
#include "Topconn.ch"     
#Include "FIVEWIN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR850  � Autor � Paulo Boschetti       � Data � 13.08.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relacao Das Ordens de Producao                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR850(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Edson   M.  �19/01/98�XXXXXX� Inclusao do Campo C2_SLDOP.              ���
���Edson   M.  �02/02/98�XXXXXX� Subst. do Campo C2_SLDOP p/ Funcao.      ���
���Rodrigo Sart�24/03/98�08929A� Inclusao da Coluna Termino Real da OP.   ���
���Rodrigo Sart�05/10/98�15995A� Acerto na filtragem das filiais          ���
���Rodrigo Sart�03/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Fernando J. �07/02/99�META  �Imprimir OP's Firmes, Previstas ou Ambas. ���
���Cesar       �31/03/99�XXXXXX�Manutencao na SetPrint()                  ��� 
���Rmogi       �16/05/07�XXXXXX�Inclusao dos tipos de OPs                 ��� 
���Rmogi       �11/07/07�XXXXXX�Inclusao dos totais das qtd das OPs       ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
User Function Matr8502()
LOCAL titulo 	:= STR0001 								//"Relacao Das Ordens de Producao" 
LOCAL cString	:= "SC2"
LOCAL wnrel		:= "MATR850"
LOCAL cDesc		:= STR0002								//"Este programa ira imprimir a Rela��o das Ordens de Produ��o."
LOCAL aOrd    	:= {STR0003,STR0004,STR0005}			//"Por O.P.       "###"Por Produto    "###"Por Centro de Custo"
LOCAL tamanho	:= "G"

PRIVATE aReturn := {STR0006,1,STR0007, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE cPerg   := "MTR850"
PRIVATE nLastKey:= 0 

 //  .----------------------------------.
 // |  Declaracao de variaveis Privadas  |
 //  '----------------------------------' 
Private aLinha  := {}
Private aExport := {}

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("MTR850",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Da OP                                 �
//� mv_par02        	// Ate a OP                              �
//� mv_par03        	// Do Produto                            �
//� mv_par04        	// Ate o Produto                         �
//� mv_par05        	// Do Centro de Custo                    �
//� mv_par06        	// Ate o Centro de Custo                 �
//� mv_par07        	// Da data                               �
//� mv_par08        	// Ate a data                            �
//� mv_par09        	// 1-EM ABERTO 2-ENCERRADAS  3-TODAS     �
//� mv_par10        	// 1-SACRAMENTADAS 2-SUSPENSA 3-TODAS    �
//� mv_par11            // Impr. OP's Firmes, Previstas ou Ambas �
//� mv_par12            // Do Recurso 							 �
//� mv_par13            // Ate o Recurso                         �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,aOrd,,Tamanho)

If nLastKey == 27
   Set Filter To
   Return
Endif
       

SetDefault(aReturn,cString)
             
If nLastKey == 27
   Set Filter To
   Return
Endif

RptStatus({|lEnd| R850Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R850Imp  � Autor � Waldemiro L. Lustosa  � Data � 13.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relat�rio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR850			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R850Imp(lEnd,wnRel,titulo,tamanho)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL CbCont,cabec1,cabec2
LOCAL limite   := 220
LOCAL nomeprog := "MATR850"
LOCAL nTipo    := 0 
LOCAL cProduto := SPACE(LEN(SC2->C2_PRODUTO))
LOCAL cStatus,nOrdem,cSeek,cTPOP 
LOCAL cTotal   := "",nTotOri:= 0,nTotSaldo:=0 ,nTotReal := 0 // Totalizar qdo ordem for por produto
LOCAL cQuery   := "",cIndex := CriaTrab("",.F.),nIndex:=0
LOCAL lQuery   := .F.
LOCAL aStruSC2 := {}
LOCAL cAliasSC2:= "SC2"
LOCAL cNumOpDe :=Substr(mv_par01,1,Len(SC2->C2_NUM) )
LOCAL cItemOpDe:=Substr(mv_par01,1+Len(SC2->C2_NUM),Len(SC2->C2_ITEM)) 
LOCAL cSeqOpDe :=Substr(mv_par01,1+Len(SC2->C2_NUM)+Len(SC2->C2_ITEM),Len(SC2->C2_SEQUEN)) 
LOCAL cItGrdDe :=Substr(mv_par01,1+Len(SC2->C2_NUM)+Len(SC2->C2_ITEM)+Len(SC2->C2_SEQUEN),Len(SC2->C2_ITEMGRD)) 
LOCAL cNumOpAte:=Substr(mv_par02,1,Len(SC2->C2_NUM))
LOCAL cItemOpAte:=Substr(mv_par02,1+Len(SC2->C2_NUM),Len(SC2->C2_ITEM))
LOCAL cSeqOpAte:=Substr(mv_par02,1+Len(SC2->C2_NUM)+Len(SC2->C2_ITEM),Len(SC2->C2_SEQUEN)) 
LOCAL cItGrdAte:=Substr(mv_par02,1+Len(SC2->C2_NUM)+Len(SC2->C2_ITEM)+Len(SC2->C2_SEQUEN),Len(SC2->C2_ITEMGRD)) 
LOCAL cRecDe   := mv_par12 
LOCAL cRecAte  := mv_par13
Local xSaldo:=0


#IFDEF TOP
	Local nX
#ENDIF

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt  := SPACE(10)
cbcont := 0
li     := 80
m_pag  := 1

nTipo  := IIF(aReturn[4]==1,15,18)
nOrdem := aReturn[8]

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
titulo += IIf(nOrdem==1,STR0008,IIf(nOrdem==2,STR0009,STR0010))	//" - Por O.P."###" - Por Produto"###" - Por Centro de Custo"
cabec1 := IF(!__lPyme, "NUMERO      P R O D U T O                                            C.C.   EMISSAO   ENTREGA     ENTREGA       QUANTIDADE    QUANTIDADE                      SALDO A  ST TP OBSERVACAO", STR0015)
cabec2 :=              "                                                                                      PREVISTA     REAL           ORIGINAL          REAL     DIFERENCA       ENTREGAR"
//  				    12345678901 123456789012345 1234567890123456789012345678901234567890 123  1234567890 1234567890 1234567890 123456789012345 1234567890123 1234567890123 123456789012345  1  1 1234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19         20        21
//                     012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567899012345678901234
// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164

dbSelectArea("SC2")
dbSetOrder( nOrdem )

//��������������������������������������������������������������Ŀ
//� Inicializa variavel para controle do filtro                  �
//����������������������������������������������������������������
#IFDEF TOP   
//	cTPOP := ""
	If mv_par10 == 1 
		cStatus := "'S'"
	ElseIf mv_par10 == 2
		cStatus := "'U'"
	ElseIf mv_par10 == 3
		cStatus := "'S','U','D','N',' '"
	EndIf	                                                     
	If mv_par11 = 1
		cTPOP := "'F'"
	ElseIf mv_par11 = 2
		cTPOP := "'P'"
	ElseIf mv_par11 = 3
		cTPOP := "'I'" 
		//msgstop("Fun��o disponivel apos a solicita��o ao TI")
		//return 
	ElseIf mv_par11 = 4
		cTPOP := "'R'"
		//msgstop("Fun��o disponivel apos a solicita��o ao TI") 		
	    //return
	ElseIf mv_par11 = 5
		cTPOP := "'F','P','I','R','T'"		
	EndIf		
	lQuery 	  := .T.
	aStruSC2  := SC2->(dbStruct())
	cAliasSC2 := "R850IMP"
	cQuery    := "SELECT SC2.* FROM "
	cQuery    += RetSqlName("SC2")+" SC2 "
	cQuery    += "WHERE "
	cQuery    += "SC2.C2_FILIAL = '"+xFilial("SC2")+"' And "
	cQuery    += "SC2.C2_NUM >= '"+cNumOpDe+"' AND "
	cQuery    += "SC2.C2_ITEM >= '"+cItemOpDe+"' AND "
	cQuery    += "SC2.C2_SEQUEN >= '"+cSeqOpDe+"' AND "
	cQuery    += "SC2.C2_ITEMGRD >= '"+cItGrdDe+"' AND "
	cQuery    += "SC2.C2_NUM <= '"+cNumOpAte+"' AND "
	cQuery    += "SC2.C2_ITEM <= '"+cItemOpAte+"' AND "
	cQuery    += "SC2.C2_SEQUEN <= '"+cSeqOpAte+"' AND "
	cQuery    += "SC2.C2_ITEMGRD <= '"+cItGrdAte+"' AND "
	cQuery    += "SC2.C2_PRODUTO >= '"+mv_par03+"' And SC2.C2_PRODUTO <= '"+mv_par04+"' And "
	cQuery    += "SC2.C2_CC  >= '"+mv_par05+"' And SC2.C2_CC  <= '"+mv_par06+"' And "
	cQuery    += "SC2.C2_EMISSAO  >= '"+DtoS(mv_par07)+"' And SC2.C2_EMISSAO  <= '"+DtoS(mv_par08)+"' And "
	cQuery    += "SC2.C2_STATUS IN ("+cStatus+") And "
	cQuery    += "SC2.C2_TPOP IN ("+cTPOP+") And "
	cQuery    += "SC2.C2_RECURSO >= '"+cRecDe+"' And "   
	cQuery    += "SC2.C2_RECURSO <= '"+cRecAte+"' And "
	cQuery    += "SC2.D_E_L_E_T_ = ' ' "

	cQuery    += "ORDER BY "+SqlOrder(SC2->(IndexKey()))

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC2,.T.,.T.)

	For nX := 1 To Len(aStruSC2)
		If ( aStruSC2[nX][2] <> "C" ) .And. FieldPos(aStruSC2[nX][1]) > 0
			TcSetField(cAliasSC2,aStruSC2[nX][1],aStruSC2[nX][2],aStruSC2[nX][3],aStruSC2[nX][4])
		EndIf
	Next nX
#ELSE
	If mv_par10 == 1 
		cStatus := "S"
	ElseIf mv_par10 == 2
		cStatus := "U"
	ElseIf mv_par10 == 3
		cStatus := "SUDN "
	EndIf	
	cQuery 	:= "C2_FILIAL=='"+xFilial("SC2")+"'.And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD>='"+mv_par01+"'"
	cQuery 	+= ".And.C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD<='"+mv_par02+"'"
	cQuery  += ".And.C2_PRODUTO>='"+mv_par03+"'.And.C2_PRODUTO<='"+mv_par04+"'"
	cQuery  += ".And.C2_STATUS$'"+cStatus+"'
	cQuery  += ".And.C2_CC>='"+mv_par05+"'.And.C2_CC<='"+mv_par06+"'"
	cQuery  += ".And.DtoS(C2_EMISSAO)>='"+DtoS(mv_par07)+"'.And.DtoS(C2_EMISSAO)<='"+DtoS(mv_par08)+"'"
	cQuery  += " .And.C2_RECURSO >= "+cRecDe+"'"   
   	cQuery  += " .And.C2_RECURSO <= "+cRecAte+"'"
	IndRegua("SC2",cIndex,IndexKey(),,cQuery)
	nIndex := RetIndex("SC2")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	cAliasSC2 := "SC2"
#ENDIF

SetRegua(RecCount())		// Total de Elementos da regua
dbGoTop()
While !Eof()

	IncRegua()

	If lEnd
		@ Prow()+1,001 PSay STR0013	//	"CANCELADO PELO OPERADOR"
		Exit
	EndIF

	If mv_par09 == 1  // O.P.s EM ABERTO
		If !Empty(C2_DATRF)
			dbSkip()
			Loop
		Endif
	Elseif mv_par09 == 2 //O.P.S ENCERRADAS
		If Empty(C2_DATRF)
			dbSkip()
			Loop
		Endif
	Endif
	
	//-- Valida se a OP deve ser Impressa ou n�o
	#IFNDEF TOP
		If !MtrAValOP(mv_par11, 'SC2')
			dbSkip()
			Loop
		EndIf
	#ENDIF	

	//�������������������Ŀ
	//� Filtro do Usuario �
	//���������������������
	If !Empty(aReturn[7])
		If !&(aReturn[7])
			dbSkip()
			Loop
		EndIf
	EndIf	

	//��������������������������������������������������������������Ŀ
	//� Termina filtragem e grava variavel p/ totalizacao            �
	//����������������������������������������������������������������
	cTotal  := IIf(nOrdem==2,xFilial("SC2")+C2_PRODUTO,xFilial("SC2"))
	nTotOri := nTotSaldo:= nTotReal := 0
	Do While !Eof() .And. cTotal == IIf(nOrdem==2,C2_FILIAL+C2_PRODUTO,C2_FILIAL)
		IncRegua()

		If mv_par09 == 1  // O.P.s EM ABERTO
			If !Empty(C2_DATRF)
				dbSkip()
				Loop
			Endif
		Elseif mv_par09 == 2 //O.P.S ENCERRADAS
			If Empty(C2_DATRF)
				dbSkip()
				Loop
			Endif
		Endif

		//-- Valida se a OP deve ser Impressa ou n�o
		#IFNDEF TOP
			If !MtrAValOP(mv_par11, 'SC2')
				dbSkip()
				Loop
			EndIf
		#ENDIF	
	
		//�������������������Ŀ
		//� Filtro do Usuario �
		//���������������������
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf	

		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial()+(cAliasSC2)->C2_PRODUTO))

		IF li > 58
			Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF

		// 1a Linha Posicoes:000/015/032/074/086/098/110/122/139/161/164
		@Li ,000 PSay C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
		     aAdd(aLinha,"'"+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
		@Li ,012 PSay C2_PRODUTO
  		     aAdd(aLinha,C2_PRODUTO)
		@Li ,028 PSay SubStr(SB1->B1_DESC,1,40)
  		     aAdd(aLinha,SB1->B1_DESC)		
		@Li ,069 PSay C2_CC          
  		     aAdd(aLinha,C2_CC)				
		@Li ,075 PSay C2_EMISSAO            
  		     aAdd(aLinha,DTOC(C2_EMISSAO))						
		@Li ,086 PSay C2_DATPRF        
             aAdd(aLinha,DTOC(C2_DATPRF))								
		@Li ,097 PSay C2_DATRF
             aAdd(aLinha,DTOC(C2_DATRF))								
		@Li ,111 PSay C2_QUANT Picture PesqPictQt("C2_QUANT",15)
             aAdd(aLinha,TRANSFORM(C2_QUANT,'@E 99999999999.99'))								
		@Li ,PCOL()+2 PSay C2_QUJE Picture PesqPictQt("C2_QUJE",15)		
             aAdd(aLinha,TRANSFORM(C2_QUJE,'@E 99999999999.99'))								
		@Li ,PCOL()+2 PSay C2_QUANT-C2_QUJE Picture PesqPictQt("C2_QUJE",13)				
             aAdd(aLinha,TRANSFORM((C2_QUANT-C2_QUJE),'@E 999999999.99'))								
		@Li ,PCOL()+3 PSay IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0) Picture PesqPictQt("C2_QUANT",13)
		     xSaldo := IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)
             aAdd(aLinha,TRANSFORM(xSaldo,'@E 99999999999.99'))										
		If ! __lPyme
			@Li ,PCOL()+2 PSay C2_STATUS //161                          
                 aAdd(aLinha,C2_STATUS)								
			@Li ,PCOL()+2 PSay C2_TPOP //164                        
                 aAdd(aLinha,C2_TPOP)											
		EndIf	              
		@Li ,174 PSay SUBSTR(C2_OBS,1,50) Picture "@!"
             aAdd(aLinha,C2_OBS)								
		Li++
		If nOrdem # 2
			@Li ,  0 PSay __PrtThinLine()
			Li++                                                 
			/*Rmogi - 11/07/07*/
			nTotOri	 += C2_QUANT
			nTotReal += C2_QUJE			
			nTotSaldo+= IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)
			/*Rmogi - 11/07/07*/
		Else
			nTotOri	 += C2_QUANT
			nTotOri	 += C2_QUJE			
			nTotSaldo+= IIf(Empty(C2_DATRF),aSC2Sld(cAliasSC2),0)
		EndIf
		dbSkip()               
		
 	    aAdd(aExport,Array(Len(aLinha)))
        aExport[Len(aExport)] := aClone(aLinha)
        aLinha := {}    

	EndDo
	If nOrdem == 2
		Li++           
		@Li ,000      PSay STR0014	//"Total ---->"
		@Li ,015      PSay Substr(cTotal,3)
		@Li ,110      PSay nTotOri	            Picture PesqPictQt("C2_QUANT",15)
		@Li ,PCOL()+2 PSay nTotReal	            Picture PesqPictQt("C2_QUANT",15)		
		@Li ,PCOL()+2 PSay nTotOri - nTotReal	Picture PesqPictQt("C2_QUANT",13)				
		@Li ,PCOL()+3 PSay nTotSaldo	        Picture PesqPictQt("C2_QUANT",13)
		Li++
		@Li ,  0 PSay __PrtThinLine()
		Li++
	EndIf
EndDo
If nOrdem # 2
   Li++           
   @Li ,000      PSay STR0014	//"Total ---->"   
   @Li ,110      PSay nTotOri	            Picture PesqPictQt("C2_QUANT",15)
   @Li ,PCOL()+2 PSay nTotReal	            Picture PesqPictQt("C2_QUANT",15)		
   @Li ,PCOL()+2 PSay nTotOri - nTotReal	Picture PesqPictQt("C2_QUANT",13)				
   @Li ,PCOL()+3 PSay nTotSaldo	            Picture PesqPictQt("C2_QUANT",13)
   Li++
   @Li ,  0 PSay __PrtThinLine()
EndIf

If Li != 80
	Roda(cbcont,cbtxt)
EndIF

If lQuery
	dbSelectArea(cAliasSC2)
	dbCloseArea()
EndIf

dbSelectArea("SC2")
Set Filter To
dbSetOrder(1)

If File(cIndex+OrdBagExt())
	Ferase(cIndex+OrdBagExt())
Endif

If aReturn[5] == 1
   Set Printer To
   OurSpool(wnrel)
EndIf                                                           

SExcel:=Msgbox("Confirma gera��o dos dados em Excel","Planilha","YESNO")
If  SExcel                                                    
   MsgRun("Exportando Dados, Aguarde...",,{|| Exporta()})
ENDIF


MS_FLUSH()
Return NIL

/*-----------------------------------------------.
 |     Rotina de gera��o do arquivo em Excel     |
 '-----------------------------------------------*/

Static Function Exporta()
   Local cArqTxt    := GetTempPath() + "MATR850.xls"
   Local nHdl       :=  Nil 
   Local cLinha     := "" //Chr(9)+"Relat�rio"+Chr(13)+Chr(10)  
   Local i := 0
   Local j := 0  
   
   If File(cArqTxt)
	  FErase(cArqTxt)
   Endif
   
   nHdl := fCreate(cArqTxt)                         
   
   If !File(cArqTXT)
      MsgStop("O Arquivo " + cArqTXT + " n�o pode ser Criado!")
	  Return nil  
	EndIf	


    cLinha := "Rela��o das Ordens de Produ��o"+chr(13)+chr(10)

    If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    EndIf      
    
    cLinha := "Numero" +Chr(9)+ "Produto"+Chr(9)+"Descri��o"+Chr(9)+"C.Custo"+Chr(9)+"Emiss�o"+Chr(9)+"Entrega Prevista"+Chr(9)+"Entrega Real"+Chr(9)
    cLinha += "Qtde.Original"+Chr(9)+"Qtde,Real"+Chr(9)+"Diferen�a"+Chr(9)+"Saldo a Entregar"+Chr(9)+"ST"+Chr(9)+"TP"+Chr(9)+"Observa��o"+chr(13)+chr(10) 
	
    If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    EndIf            
   
    For i:=1 to Len(aExport)
       cLinha := ""
         IncRegua()

       If ValType(aExport[i])<>"A"
          cLinha += aExport[i]
       Else
          For j := 1 to Len(aExport[i])
              cLinha += aExport[i][j]+Chr(9)
          Next
       Endif

       cLinha += chr(13)+chr(10)

       If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
       EndIf          
    Next
  fClose(nHdl)     
  RunExcel(cArqTxt)  
Return Nil                                                                                  

//*****************************************************************************************************************************      

Static Function RunExcel(cwArq)
  Local oExcelApp                           
  Local aNome := {}

  If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
    MsgStop( 'MsExcel nao instalado' ) 
    Return
  EndIf
    
  oExcelApp := MsExcel():New()     	  // Cria um objeto para o uso do Excel
  oExcelApp:WorkBooks:Open(cwArq) 
  oExcelApp:SetVisible(.T.) // Abre o Excel com o arquivo criado exibido na Primeira planilha.  
  oExcelApp:Destroy()
Return                                                           

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
