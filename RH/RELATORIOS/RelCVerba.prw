//#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#include "ap5mail.ch"
#Include "TOPCONN.CH"
#Include "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     � Autor � AP6 IDE            � Data �  30/08/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    
���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RelCVerba


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELA��O DE VERBAS "
Local cPict          := ""
Local titulo       := "RELA��O DE VERBAS "
Local nLin         := 55
Local Cabec1       := ""
Local Cabec2       := "C.Custo  Matricula   Nome                                Data Ini      Valor Inicial    Data Fim   Valor Final     Perc. de Ajuste"

Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "P"
Private nomeprog         := "NOME" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RelV" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg:="GRPRV"
Private cString:=""
If ! Pergunte (cPerg,.T.,'Parametro para gera��o do relat�rio')
	Return
Endif 

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,,.F.,,)

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
DescV:=Alltrim(posicione("SRV",1,xFilial("SRV")+mv_par03,"RV_DESC"))
Cabec1:="COMPARA��ES ENTRE A VERBA "+mv_par03+"("+DescV+") NO PERIODO "+substr(mv_par01,1,2)+'/'+substr(mv_par01,3,4)+" E NO PERIODO "+substr(mv_par02,1,2)+'/'+substr(mv_par02,3,4)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  30/08/10   ���
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
//Local nLin:=9
Local cQuery:=""                             
Local nFunc:=""
Local CCusto:=""   
ATotC:={}

MesAnoI:=substr(mv_par01,3,4)+substr(mv_par01,1,2)
MesAnoF:=substr(mv_par02,3,4)+substr(mv_par02,1,2)
CQuery:=" select RD_DATARQ,RD_MAT,RD_PD,RD_VALOR,RA_NOME,RA_CC from SRD010,SRA010 " 
CQuery+=" WHERE SRD010.D_E_L_E_T_='' AND SRA010.D_E_L_E_T_='' AND "
CQuery+=" RD_MAT=RA_MAT AND "
CQuery+=" RD_PD='"+mv_par03+"' AND RD_DATARQ IN('"+MesAnoI+"','"+MesAnoF+"')"

CQuery+=" UNION "
cQuery+=" select SUBSTRING(RC_DATA,1,6) AS RD_DATARQ, RC_MAT AS RD_MAT ,RC_PD AS RD_PD, "
cQuery+=" RC_VALOR AS RD_VALOR,RA_NOME,RA_CC from SRC010,SRA010 "
cQuery+=" WHERE SRA010.D_E_L_E_T_='' AND SRC010.D_E_L_E_T_='' AND"
CQuery+=" RC_MAT=RA_MAT AND "
cQuery+= "RC_PD='"+mv_par03+"' AND SUBSTRING(RC_DATA,1,6)='"+MesAnoF+"'"
cQuery+=" ORDER BY RA_CC,RD_MAT "
                     
TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
DbGotop()            


Perc:=0
VrIni:=0
VrFim:=0
Pos:=0
While !Eof()
   If nLin > 54 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,'G',nTipo)
      nLin := 10
   Endif
   nFunc:=Posicione("SRA",1,xFilial("SRA")+TRB->RD_MAT,"RA_NOME")		
   CCusto:=Posicione("SRA",1,xFilial("SRA")+TRB->RD_MAT,"RA_CC")		
   cMat:=TRB->RD_MAT            
   @nLin, 0        Psay cCusto
   @nLin, Pcol()+3 Psay TRB->RD_MAT    
   @nLin, Pcol()+3 Psay nFunc
   Pos:=AScan(aTotC,{|x|Alltrim(x[1])==Alltrim(cCusto)})
   If Pos==0
    	AaDD(aTotC,{cCusto,0,0,0})
    	Pos:=1
   EndIf
   aTotC[Pos][2]:=aTotC[Pos][2]+1
   if TRB->RD_DATARQ =MesAnoF //(Caso o funcion�rio n�o tenha movimenta��o na primeira data)
	   @nLin,087 Psay Substr(TRB->RD_DATARQ,5,2)+'/'+Substr( TRB->RD_DATARQ,1,4)
	   @nLin,097 Psay Transform(TRB->RD_VALOR,"@E 999,999.99")
	   aToTc[Pos][4]+=TRB->RD_VALOR
       VrFim:=TRB->RD_VALOR		                                
       VrIni:=1
   Else	                                                        
   	   @nLin, Pcol()+3 Psay Substr(TRB->RD_DATARQ,5,2)+'/'+Substr( TRB->RD_DATARQ,1,4)
	   @nLin, Pcol()+3 Psay Transform(TRB->RD_VALOR,"@E 999,999.99")
   	   aToTc[Pos][3]+=TRB->RD_VALOR		                                
   	   VrIni:=TRB->RD_VALOR		                                
   Endif	   
   
   DbSelectArea("TRB")		           
   
   DbSkip()	
   If ! Eof()
   		if cMat=TRB->RD_MAT
			@nLin, Pcol()+3 Psay Substr(TRB->RD_DATARQ,5,2)+'/'+Substr( TRB->RD_DATARQ,1,4)
			@nLin, Pcol()+3 Psay Transform(TRB->RD_VALOR,"@E 999,999.99")
  	        VrFim:=TRB->RD_VALOR		                                
	 	    aToTc[POS][4]+=TRB->RD_VALOR
	   	    DbSelectArea("TRB")		
		    DbSkip()	
		EndIf
   End     

   Perc:=((VrFim/VrIni)-1)*100
   If VrIni=1
   	 Perc:=100       
   EndIf 
   If VrFim=0
	  Perc:=-100      	
   Endif 
   @nLin, Pcol()+3 Psay Transform(Perc,"@E 999.99%")
 

   if !eof() .and. cCusto<>TRB->RA_CC
	 	DescCC:=Posicione("CTT",1,xFilial("CTT")+cCusto,"CTT_DESC01  ")
	 	If nLin+3 > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	    Endif
	  	nLin++
	 	@nLin,000 Psay replicate("_",Limite)
	  	nLin++
		@nLin,000 Psay Alltrim(cCusto)+'-'+DescCC
        @nLin,Pcol()+4 Psay 'Totais--->   '
        @nLin,Pcol()+3 Psay substr(mv_par01,1,2)+'/'+substr(mv_par01,3,4)
        @nLin,Pcol()+3 Psay Transform(aToTc[Pos][3],"@E 999,999.99")
        @nLin,Pcol()+3 Psay substr(mv_par02,1,2)+'/'+substr(mv_par02,3,4)
        @nLin,Pcol()+3 Psay Transform(aToTc[Pos][4],"@E 999,999.99")        
        @nLin,Pcol()+3 Psay Transform(aToTc[Pos][2],"@E 999,999")+ ' FUNCIONARIOS'	

        nLin++                                                    
		@nLin,000 Psay replicate("_",Limite)
	
   EndIf  
          
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	  Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   nLin := nLin + 1
//   If nLin > 70 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
//      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
//      nLin := 8
//   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

//   nLin := nLin + 1 // Avanca a linha de impressao
//   DbSelectArea("TRB")
//   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

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
DbCloseArea("TRB")
Return
