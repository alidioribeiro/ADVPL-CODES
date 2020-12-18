#INCLUDE "rwmake.ch"    
#Include "TOPCONN.CH"



User Function RelFat() 


#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 07/03/02 ==> 	#DEFINE PSAY SAY
#ENDIF
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � RelImHE  � Autor � JEFFERSON MOREIRA     � Data � 16/04/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Relatorio de Solicitacao de horas extras                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������Ĵ��
*/
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

titulo    := PADC("RELATORIO DE FATURAMENTO POR PERIODO",74)
cDesc1    := PADC("Este programa tem como objetivO emitir o relatorio de faturamento ",74)
cDesc2    := ""
cDesc3    := ""
aORD      := {}//{"OP","PRODUTO","RECURSO"}
tamanho   := "G" // largura do relatorio --> P 80 pos - M 132 pos - G 220 pos
//limite    := 132
limite    := 220
cString   := "SD2"
lContinua := .T.
cUM       := ""
lEnd      := .F.
aReturn   := { "Zebrado", 1,"Contabilidade", 2, 2, 1, "",1 }
nomeprog  := "RelFat"
nLastKey  := 0
cPerg := "MTRFAT"


m_pag     := 01     
Li:=0


/*TESTE DE INTEGRA��O COM O PONTO*/
//U_INTPONHE()
//��������������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                             �
//����������������������������������������������������������������������������������

pergunte(cPerg,.F.)
  
//��������������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                           �
//��������������������������������������������������������������������������������Ĵ
//�   mv_par01  - Da Data ?                                                        �
//�   mv_par02  - Ate a Data ?                                                     �
//�   mv_par03  - Do Doc ?                                                         �
//�   mv_par04  - Ate o Doc ?                                                      �
//�   mv_par05  - Da Matricula ?                                                   �
//�   mv_par06  - Ate a Matricula ?                                                �
//�   mv_par07  - Do CCusto ?                                                      �
//�   mv_par08  - Ate o CCusto ?                                                   �
//�                                                                                |
//����������������������������������������������������������������������������������

//�������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                       �
//���������������������������������������������������������������

wnrel  := "RelFat"

wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

//������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape  �
//��������������������������������������������������������������
nOrdem := aReturn[8]
cbtxt  := Space(10)
cbcont := 00

 


//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������

 Tipo:=IIf(mv_par07=1,"Anal�tico","Sint�tico")
 titulo := " Demonstrativo do Faturamento "+Tipo
 if mv_par07=1
	 cabec1 :="Cod|Nome do Cliente                           |Codigo           |Descri��o do Produto                                 |UN |TP| Modelo        |Lote       |Vr. Venda        |Custo          |Margem Lucro"
 Else 	 
	 cabec1 :="Cod|Nome do Cliente                           |Codigo           |Descri��o do Produto                                 |UN |TP| Modelo        |Vr. Venda        |Custo          |Margem Lucro"
 EndIf 

 cabec2 := ""



If nLastKey == 27
   Return
Endif

nTipo  := IIF(aReturn[4]==1,15,18)

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Group:=""
If mv_par07=1 
	cQuery:="SELECT D2_CLIENTE,A1_NOME,D2_COD,B1_DESC,D2_UM,B1_TIPO,B1_MODELO,D2_LOTECTL,SUM(D2_TOTAL) VRVENDA, SUM(D2_CUSTO1) CUSTO "
    Group:=" GROUP BY D2_CLIENTE,A1_NOME,D2_COD,B1_DESC,D2_UM,B1_TIPO,B1_MODELO,D2_LOTECTL "
Else  
	cQuery:="SELECT D2_CLIENTE,A1_NOME,D2_COD,B1_DESC,D2_UM,B1_TIPO,B1_MODELO,SUM(D2_TOTAL) VRVENDA, SUM(D2_CUSTO1) CUSTO "
    Group:=" GROUP BY D2_CLIENTE,A1_NOME,D2_COD,B1_DESC,D2_UM,B1_TIPO,B1_MODELO"

EndIF 	

cQuery+="FROM SD2010 SD2,SB1010 SB1, SA1010 SA1 "               
cQuery+=" WHERE "
cQuery+=" SD2.D_E_L_E_T_=''  AND "
cQuery+=" SB1.D_E_L_E_T_=''  AND "
cQuery+=" SA1.D_E_L_E_T_=''  AND "
cQuery+=" D2_CLIENTE= A1_COD AND "
cQuery+=" D2_LOJA = A1_LOJA  AND "
cQuery+=" D2_FILIAL=B1_FILIAL AND " 
cQuery+=" D2_FILIAL='"+xFilial()+"' AND" 
cQuery+=" D2_COD=B1_COD AND  "
cQuery+=" D2_EMISSAO>='"+Dtos(mv_par01)+"' AND "
cQuery+=" D2_EMISSAO<='"+Dtos(mv_par02)+"' AND "
cQuery+=" B1_MODELO>='"+mv_par03+"' AND "
cQuery+=" B1_MODELO<='"+mv_par04+"' AND "
cQuery+=" D2_CLIENTE>='"+mv_par05+"' AND "
cQuery+=" D2_CLIENTE<='"+mv_par06+"' AND "
cQuery+=" substring(D2_CF,2,3)='101' " 

cQuery+= Group

TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
DbGotop()
QtdGerTot:=0
lote:=iif(mv_par07=1,D2_LOTECTL,'')
While !EOF ()       
	DbSelectArea("TRB")
    MarLuc:=(1-(CUSTO/VRVENDA))*100
    @ li,000      PSAY D2_CLIENTE+"|"
    @ li,PCOL()+2 PSAY A1_NOME   +"|"
    @ li,PCOL()+2 PSAY D2_COD    +"|"
    @ li,PCOL()+3 PSAY B1_DESC   +"|"
    @ li,PCOL()   PSAY D2_UM     +"|"
    @ li,PCOL()   PSAY B1_TIPO +"|"
    @ li,PCOL()   PSAY B1_MODELO +"|"    
    if !Empty(Lote)
    	@ li,PCOL()PSAY D2_LOTECTL+"|"
	    @ li,160   PSAY Str(VRVENDA,10,2)+"|"
    	@ li,175   PSAY Str(Custo,10,2)+"|" //Transform(str(CUSTO),  "@R 999.999.999,99") +"|"
	    @ li,185   PSAY    Str(MarLuc,10,2)  +"|"
    Else
	    @ li,150   PSAY Str(VRVENDA,10,2)+"|"
    	@ li,165   PSAY Str(Custo,10,2)+"|" //Transform(str(CUSTO),  "@R 999.999.999,99") +"|"
    	@ li,175   PSAY    Str(MarLuc,10,2)  +"|"
    Endif 
    li++   
     If Li > 60
 	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
     Endif  
//     @ li,000      PSAY Replicate("_",limite)
//     li ++
//     If Li > 69
// 	    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
//     Endif  
	dbSelectArea("TRB")
	dbSkip()

Enddo          
/*
If QtdGerTot>0
     @ li,000      PSAY "<Geral> Total por periodo:"+Alltrim(Str(QtdGerTot))//+Replicate('_',Limite-Len(Str(QtdGerTot))-Len(DescOrd))+Str(QtdGerTot)
EndIf                                         +
*/
DbSelectArea("TRB")
DbCloseArea("TRB") 
//IF li != 80
//       roda(cbcont,cbtxt,tamanho)
//EndIF

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

