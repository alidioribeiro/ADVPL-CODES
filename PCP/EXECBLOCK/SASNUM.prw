#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SASNUM    � Autor � Jefferson Moreira  � Data �  18/10/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Esse programa faz a reenumera�ao das solicit��es ao armazem���
���          � e das pre-requisi��es.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SASNUM

PRIVATE oDlg5 := NIL

@ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Reenumera��o das Solicita�oes ao Armazem."
@ 8,10 TO 84,222
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
@ 23,14 SAY "Este Programa tem como objetivo, reenumerar as solicita��es ao " 
@ 33,14 SAY "armazem e das pre-requisi��es."
@ 43,14 SAY ""
@ 53,14 SAY ""
ACTIVATE DIALOG oDlg5

Return nil


Static Function OkProc()
Processa( {|| RunProc() } )
Close(oDlg5)
Return

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Static Function RunProc()

Private cString := "SCP"
xNumSa := 000001

dbSelectArea("SCP")
ProcRegua(RecCount())
dbgotop()
   
 While ! EOF()
         
         xNum := alltrim(CP_NUM)
         xSeq := CP_ITEM
         
         WHILE xNum == alltrim(CP_NUM)
               IncProc()
               Reclock("SCP")
               SCP->CP_NUM := StrZero(xNumSa,6)
	  	       SCP->(MsUnlock())
               DbSkip()
               ConOut("Nro SA : "+xNum +"Item"+SCP->CP_ITEM )
         ENDDO
  
   xNumSa += 1

 
Enddo
MsgBox ("Processo concluido com Sucesso.","Informa��o","INFO")
Return