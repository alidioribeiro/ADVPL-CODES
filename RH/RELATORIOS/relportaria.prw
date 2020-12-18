#INCLUDE "rwmake.ch" 
#Include "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO6     � Autor � AP6 IDE            � Data �  25/01/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RelPortaria()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de Entrada e Sa�da de Visitantes"
Local cPict          := ""
Local titulo       := "Relat�rio de Entrada e Sa�da de Visitantes"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RELPORTARIA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "PORTARIA"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "SCPV1" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "ZZH"

dbSelectArea("ZZH")
dbSetOrder(1)


pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  25/01/11   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local temT :=00.00
Local cCont :=1
dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
   titulo := " Relat�rio de controle de portaria "
   cabec1 := "Documento RG    Nome Visitante               Agendado?  Data da     Hora           Hora           Dura��o    Matricula     Aprovador                          Centro de         Descri��o          Segura�a"  
   cabec2 := "                                                        Entrada     Da entrada     Da sa�da       Total                    Nome                               Custo                                        "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20

//���������������������������������������������������������������������Ŀ
//� Selecionando dados de acordo com os par�metros informados. �
//�����������������������������������������������������������������������
CQuery:="  SELECT * FROM ZZH010 AS ZZH "
CQuery+="  WHERE  ZZH.D_E_L_E_T_=''"
CQuery+="  AND ZZH_DTENT >='"+Dtos(mv_par01)+"' AND ZZH_DTENT <='"+Dtos(mv_par02)+"' "  
CQuery+="  AND ZZH_CCUSTO >='"+mv_par03+"'AND ZZH_CCUSTO <='"+mv_par04+"'"
if mv_par05=1
    CQuery+="  AND ZZH_STATUS ='1'"
    Elseif mv_par05=2 
	CQuery+="  AND ZZH_STATUS ='4'" 
	Elseif mv_par05=3 
	CQuery+="  AND ZZH_STATUS ='3'" 
	Elseif mv_par05=4 
	CQuery+="  AND ZZH_STATUS ='2'"
	Else
	CQuery+="  AND ZZH_STATUS in('1','2','3','4')"
EndiF
CQuery+="  AND ZZH_MATAP >='"+STRZERO(VAL(mv_par06),6)+"'"
IF mv_par07 <> 'ZZZZZZ'
CQuery+="  AND ZZH_MATAP <='"+STRZERO(VAL(mv_par07),6)+"' "
ELSE                                                       
CQuery+="  AND ZZH_MATAP <='"+mv_par07+"' " 
ENDIF

IF mv_par08=1
CQuery+="  AND ZZH_TIPOAG ='NAO'"
ELSEif mv_par08=2
CQuery+="  AND ZZH_TIPOAG ='SIM'"
Else
CQuery+="  AND ZZH_TIPOAG in('SIM','NAO')"
ENDIF      

If !empty(mv_par09)
CQuery+="  AND ZZH_RG ='"+mv_par09+"'" 
EndIF

TCQUERY cQuery NEW ALIAS "ZZZ"

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Verifica se existem os valores das pesquisas                       �
//�����������������������������������������������������������������������
if empty(ZZZ->ZZH_COD)
alert("Aten��o:N�o foi encontrador nenhum registro! Por Favor ferifique os par�metros. T.I - 8913/8914")
EndIF

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������
dbSelectArea("ZZZ")
DbGotop()
While !EOF () 

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 66 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
   //contador
   cCont ++ 
   IF ZZZ->ZZH_HRSAI > 0        
   temT  = SomaHoras(temT,ZZZ->ZZH_HRTOTA)       
   ENDIF
   
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD        
   @nLin,00 PSAY ZZZ->ZZH_COD
   @nLin,PCOL()+1   PSAY Substr((ZZZ->ZZH_RG),1,17)
   @nLin,PCOL()+1   PSAY Substr((ZZZ->ZZH_NOME),1,30) 
   @nLin,PCOL()+1   PSAY Substr((ZZZ->ZZH_TIPOAG),1,12) 
   @nLin,PCOL()+5   PSAY Stod(ZZZ->ZZH_DTENT)
   @nLin,PCOL()+6   PSAY Transform(StrTran(StrZero(ZZZ->ZZH_HRENT,5,2),".",""),"@R !!:!!" )    
   @nLin,PCOL()+9   PSAY Transform(StrTran(StrZero(ZZZ->ZZH_HRSAI,5,2),".",""),"@R !!:!!" )   
   @nLin,PCOL()+9   PSAY Transform(StrTran(StrZero(ZZZ->ZZH_HRTOTAL,5,2),".",""),"@R !!:!!" )  
   @nLin,PCOL()+6   PSAY Substr((ZZZ->ZZH_MATAP),1,12) 
   @nLin,PCOL()+7   PSAY Substr((ZZZ->ZZH_APROV),1,30)
   @nLin,PCOL()+7   PSAY Substr((ZZZ->ZZH_CCUSTO),1,12)
   @nLin,PCOL()+10  PSAY Substr((ZZZ->ZZH_CDESC),1,19)
   @nLin,PCOL()+5   PSAY Substr((ZZZ->ZZH_SEG),1,23)
    
         

   nLin := nLin + 1 // Avanca a linha de impressao

   
   DbSelectArea("ZZZ")
   dbSkip() // Avanca o ponteiro do registro no arquivo  
         
EndDo                                 
//linha
@nLin,000      PSAY Replicate("-",limite) 
nLin := nLin + 1     
@nLin,010      PSAY "TOTAL HORAS :"  
@nLin,097      PSAY Transform(StrTran(StrZero(temT,5,2),".",""),"@R !!:!!" )   


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
DbCloseArea("ZZZ")
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return




User Function RelAge()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relat�rio de Agendamento Marcados"
Local cPict          := ""
Local titulo         := "Relat�rio de Agendamento"
Local nLin           := 80

Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "RELAGENDAMEN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "PORTARIA"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "AGENDAMENTO" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "ZZG"

dbSelectArea("ZZG")
dbSetOrder(1)


pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport01(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  25/01/11   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport01(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local temT :=00.00
Local cCont :=1
dbSelectArea(cString)
dbSetOrder(1)


//���������������������������������������������������������������������Ŀ
//� Selecionando dados de acordo com os par�metros informados. �
//�����������������������������������������������������������������������
CQuery:="  SELECT * FROM ZZG010 AS ZZG "
CQuery+="  WHERE  ZZG.D_E_L_E_T_=''"
CQuery+="  AND ZZG_DTVIS >='"+Dtos(mv_par01)+"' AND ZZG_DTVIS <='"+Dtos(mv_par02)+"' "  
CQuery+="  AND ZZG_CCUSTO >='"+mv_par03+"'AND ZZG_CCUSTO <='"+mv_par04+"'"
if mv_par05=1
    CQuery+="  AND ZZG_STATUS ='1'"
    Elseif mv_par05=2 
	CQuery+="  AND ZZG_STATUS ='4'" 
	Elseif mv_par05=3 
	CQuery+="  AND ZZG_STATUS ='3'" 
	Elseif mv_par05=4 
	CQuery+="  AND ZZG_STATUS ='2'"
	Else
	CQuery+="  AND ZZG_STATUS in('1','2','3','4')"
EndiF
CQuery+="  AND ZZG_MAT >='"+STRZERO(VAL(mv_par06),6)+"'"
IF mv_par07 <> 'ZZZZZZ'
CQuery+="  AND ZZG_MAT <='"+STRZERO(VAL(mv_par07),6)+"' "
ELSE                                                       
CQuery+="  AND ZZG_MAT <='"+mv_par07+"' " 
ENDIF
       

TCQUERY cQuery NEW ALIAS "ZZZ"


SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Verifica se existem os valores das pesquisas                       �
//�����������������������������������������������������������������������
if empty(ZZZ->ZZG_COD)
alert("Aten��o:N�o foi encontrador nenhum registro! Por Favor ferifique os par�metros. T.I - 8913/8914")
EndIF

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
   titulo := " Relat�rio de Agendamentos "
   cabec1 := "Documento Item    Representante     Visitante                Data da   Hora Prevista    Matricula     Nome do    Centro de  Descri��o"  
   cabec2 := "                                                             Entrada   Da entrada       Solicitante   Solicita   Custo                "
   //         999  999999  111111111122222222223333333333  HH:MM  HH:MM  HH:MM   01/01/08   123    Sim   Sim   ______________________________
   //         012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
   //                   1         2         3         4         5         6         7         8         9         10        11        12         13       14        15        16        17        18        19        20

dbSelectArea("ZZZ")
DbGotop()
While !EOF () 

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 66 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
   //contador
   cCont ++ 
   
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD        
   @nLin,00 PSAY Substr((ZZZ->ZZG_COD),1,17)
   @nLin,PCOL()+5   PSAY Substr((ZZZ->ZZG_ITEM),1,17)
   @nLin,PCOL()+4   PSAY Substr((ZZZ->ZZG_REPRE),1,17) 
   @nLin,PCOL()+1   PSAY Substr((ZZZ->ZZG_ACOM),1,20) 
   @nLin,PCOL()+5   PSAY Stod(ZZZ->ZZG_DTVIS)
   @nLin,PCOL()+6   PSAY ZZZ->ZZG_HVIS    
   @nLin,PCOL()+9   PSAY Substr((ZZZ->ZZG_MAT),1,12) 
   @nLin,PCOL()+7   PSAY Substr((ZZZ->ZZG_NOME),1,10)
   @nLin,PCOL()+1   PSAY Substr((ZZZ->ZZG_CCUSTO),1,12)
   @nLin,PCOL()+5  PSAY Substr((ZZZ->ZZG_CNOME),1,19)

    
         

   nLin := nLin + 1 // Avanca a linha de impressao

   
   DbSelectArea("ZZZ")
   dbSkip() // Avanca o ponteiro do registro no arquivo  
         
EndDo                                 
//linha
@nLin,000      PSAY Replicate("-",limite) 
nLin := nLin + 1     


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
DbCloseArea("ZZZ")
SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
