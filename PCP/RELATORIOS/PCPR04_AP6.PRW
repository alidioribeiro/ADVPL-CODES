#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function PCPR04()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CVAR,CCOMBO,NVAR,NVAR1,NLIST,LCHECK1")
SetPrvt("LCHECK2,LCHECK3,LCHECK4,AITEMS,ARADIO,NRADIO")
SetPrvt("CARQNTX,CINDCOND,XDOC,XVENCREA,XVALOR,XLINHA")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PCPR04� Autor � Marcelo Iannuzzi Silveira � Data � 02.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Demostracao do Interpretador xBase Windows                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �RDMake <Programa.Ext> -w                                    ���
�������������������������������������������������������������������������Ĵ��
��� Exemplo  �RDMake RDDemo.prw -w                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
cVar := "com PICTURE, VALID, WHEN e F3"
cCombo := "Linha 02"
nVar := 0
nVar1 := 10
nList := 4
lCheck1 := .t.
lCheck2 := .f.
lCheck3 := .t.
lCheck4 := .f.
aItems := {"Elemento 01","Elemento 02","Elemento 03","Elemento 04"}
aRadio := {"Sim","Nao","Talvez","Quem sabe?"}
nRadio := 2
*/
Pergunte("PCPR04",.T.)    

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Gera��o Autom�tica de Plano de Produ��o."
@ 8,10 TO 84,222
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("PCPR04")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este programa copia planos de produ��o j� lansados"
@ 33,14 SAY "para que sejam modificados de acordo com os par�metros fornecidos."
@ 43,14 SAY "Obs.: 1.No caso de gera��o de um novo plano, considerar a segunda data"
@ 53,14 SAY "      do Par�metro como a nova data de Previs�o."
@ 63,14 SAY "      2.A Cria��o de um novo plano deve ser feita diariamente."
ACTIVATE DIALOG oDlg5

Return nil        

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �OkProc    � Autor � Jorge S. da Silva     � Data � 02.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Confirma o Processamento                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function OkProc
Static Function OkProc()
Close(oDlg5)

dbSelectArea("SHC")
cArqSD3 := CriaTrab(NIL,.F. )
cKeySD3 := "HC_Filial+HC_NUMPLAN+dtos(HC_DATA)" // IndexKey()

IF MV_PAR02 == 2
   cFilSD3 := "HC_FILIAL='"+xFilial("SHC")+"'.And. HC_NUMPLAN= '"+MV_PAR01+"'.And.DTOS(HC_DATA)>='"+DTOS(MV_PAR03)+"'.And.DTOS(HC_DATA)<='"+DTOS(MV_PAR04)+"'" 
ELSE
   cFilSD3 := "HC_FILIAL='"+xFilial("SHC")+"'.And. HC_NUMPLAN= '"+MV_PAR01+"'.And.DTOS(HC_DATA)= '"+DTOS(MV_PAR03)+"'" 
endif

IndRegua("SHC",cArqSD3,cKeySD3,,cFilSD3,"Selecionando Registros...")
nIndex1 := RetIndex("SHC")
dbSelectArea("SHC")
dbSetIndex(cArqSD3+OrdBagExt())
dbSetOrder(nIndex1+1)

Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Processa( {|| Execute(RunProc) } )
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RunProc   � Autor � Jorge S. da Silva     � Data � 02.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Executa o Processamento                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RunProc
Static Function RunProc()

dbSelectArea("SHC")
ProcRegua(RecCount())

dbGotop()
xPMP := {}
While !Eof()
  /*    xProduto := HC_Produto
      xData    := HC_Data
      xQuant   := HC_Quant
      xDtAju   := HC_DtAju
      xNivel   := HC_Nivel
      xOP      := HC_OP
      xOPC     := HC_OPC
      xStatus  := HC_Status*/
      AADD(xPMP,{HC_Produto,HC_Data,HC_Quant,HC_DtAju,HC_Nivel,HC_OP,HC_OPC,HC_Periodo,HC_Status})
      DBSKIP()
EndDo
dbSelectArea("SHC")
For xI:=1 to len(xPMP)      
      
      RecLock("SHC",.T.)
	  If MV_PAR02 == 1
		 SHC->HC_Filial  :=  xFilial()
         SHC->HC_NUMPLAN :=  "01"
         SHC->HC_Produto :=  xPMP[xI][1]
         SHC->HC_Data    :=  MV_PAR04
         SHC->HC_Quant   :=  0
         SHC->HC_DtAju   :=  xPMP[xI][4]
         SHC->HC_Nivel   :=  xPMP[xI][5]
         SHC->HC_OP      :=  xPMP[xI][6]
         SHC->HC_OPC     :=  xPMP[xI][7]
         SHC->HC_DtVigen :=  DDataBase
         SHC->HC_Periodo :=  xPMP[xI][8]
         SHC->HC_Status  :=  xPMP[xI][9]
      Else
         SHC->HC_Filial  :=  xFilial()
         SHC->HC_NUMPLAN :=  STRZERO(VAL(MV_PAR01)+1,2)
         SHC->HC_Produto :=  xPMP[xI][1]
         SHC->HC_Data    :=  xPMP[xI][2]
         SHC->HC_Quant   :=  xPMP[xI][3]
         SHC->HC_DtAju   :=  xPMP[xI][4]
         SHC->HC_Nivel   :=  xPMP[xI][5]
         SHC->HC_OP      :=  xPMP[xI][6]
         SHC->HC_OPC     :=  xPMP[xI][7]
         SHC->HC_DtVigen :=  DDataBase
         SHC->HC_Periodo :=  xPMP[xI][8]                	
         SHC->HC_Status  :=  xPMP[xI][9]
      EndIf
      msUnlock()
Next

dbSelectArea('SHC')
RetIndex('SHC')

If !(Type('ArqNtx') == 'U')
	fErase(cArqNtx)
Endif

Return nil