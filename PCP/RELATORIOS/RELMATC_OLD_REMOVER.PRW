#INCLUDE "rwmake.ch"                     
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"
#Include "TBICONN.CH"
#Include "Protheus.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � AP6 IDE            � Data �  02/07/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RelMatC


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
//Local nLin         := 80
Local nLin         := 12
     
      
Local Cabec1       := "Relat�rio de Materia-Prima no processo"
Local Cabec2       := "Produto           Descri��o                                            Fechamento     Transferido            Perdas           Consumo " 
Local imprime      := .T.
Local aOrd := {}                                                                                    
Local  titulo    := "Movimenta��o de Materia-Prima "
Local ctitulo    := "Movimenta��o de Materia-Prima "

Private Programa:="RELMAT"
Private cDesc1    := "Este programa tem com objetivo, imprimir a relacao de mat�ria-prima "
Private cDesc2    := "por Fornecedor."                                     
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private  tamanho   := "M"
Private limite    := 220
Private nomeprog:="RELMAT"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELMAT" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString:=""                                                   
Private cPerg     := "ESTR32"
Private aLinha    := {}


pergunte(cperg,.F.)


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������


	wnrel := SetPrint(cString,NomeProg,cperg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  02/07/09   ���
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
Local CQuery:=""   
                                                      
LOCAL cDirDocs  := "\RELATO\" //Path para arquivo TMPorario. Se nao existir,
Local cPath	    := "C:\RELATORIO_SIGA\"
Local oExcelApp
Local cFiltro:="",cQuery:=""

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rela��o de mat�ria-prima no processo"
Local cPict          := ""
Local titulo       := "Relacao de materia-prima no processo"
Local nLin         := 12


                                                                     
//dbSelectArea(cString)
//dbSetOrder(1)           
//Saldos do fechamento 
DataI:=substr(Dtos(mv_par07),1,6)+'01'
cData:=STod(DataI)-1
DataI:=Dtos(cData)
DatInv:=substr(DataI,1,6)
Ender:=""
FiltroBc:=""

Do Case                                                             
	Case mv_par09=1 //Injecao Plastica
       Ender+=" and B2_CC='231' "
	Case mv_par09=2 //Impressao
       Ender+=" and B2_CC='221' "
    Case mv_par09=3 ///montagem
	   Ender+=" and B2_CC='211' "     
    Case mv_par09=4 //Ia
	   Ender+=" and B2_CC='241' "     
	Otherwise   //Todos
       Ender+="  "
EndCase            

If !Empty(mv_par07) 
	FiltroBC=" and BC_MOTIVO>='"+mv_par05+"' and BC_MOTIVO<='"+mv_par06+"' "
	FiltroBc+=" and BC_DTRM>='"+Dtos(mv_par07)+"'  and BC_DTRM<='"+Dtos(mv_par08)+"'"
EndIF 

FRecurso:=" C2_RECURSO>='"+mv_par10+"' and C2_RECURSO<='"+mv_par11+"' "


CQuery:= " SELECT D3_COD,B1_DESC,SB9.TOTINV AS TOTINV,"
CQuery+=" SUM(CASE WHEN (D3_CF IN('RE4','RE5') AND D3_LOCAL='10')   THEN D3_QUANT ELSE 0 END) AS QTDPERD,  " //Alterado para poder jogar as perdas para o custos 02/08/2012
CQuery+=" SUM(CASE WHEN D3_CF='RE3' OR (D3_CF='PR0' and D3_LOCAL='10') OR (D3_CF='DE2' AND D3_TM='499') THEN D3_QUANT ELSE 0 END) AS QTDTRAN , "
CQuery+=" SUM(CASE WHEN D3_CF='RE2' AND D3_LOCAL='10' THEN D3_QUANT ELSE 0 END) AS QTDCONS "
cQuery+=" FROM SD3010 "
cQuery+=" LEFT JOIN (SELECT B9_COD,SUM(B9_QINI) AS TOTINV FROM SB9010 WHERE D_E_L_E_T_='' AND B9_LOCAL='10' AND LEFT(B9_DATA,6)='"+DatInv+"' GROUP BY B9_COD ) SB9 ON SD3010.D3_COD=SB9.B9_COD "
cQuery+=" INNER JOIN SB1010  ON (B1_COD=D3_COD)  "
cQuery+=" INNER JOIN SB2010  ON (B2_COD=D3_COD)  "
cQuery+=" WHERE B2_LOCAL='10' "//AND D3_OP >='"+mv_par01 +"' and D3_OP<='"+mv_par02 +"' "  //OP TESTE
cQuery+=" and D3_ESTORNO<>'S' "                   
cQuery+=" and D3_COD>='" +mv_par03+"' and D3_COD<='"+mv_par04+"' "  //Codigo 
cQuery+=" and D3_EMISSAO>='"+Dtos(mv_par07)+"'  and D3_EMISSAO<='"+Dtos(mv_par08)+"' "//Movimenta��o do periodo
cQuery+=" and D3_CF IN('RE2','RE3','PR0','RE4','RE5','DE2') "     
cQuery+=" and D3_GRUPO NOT IN ('GGF') "
cQuery+=Ender 
CQuery+=" and SD3010.D_E_L_E_T_='' AND SB1010.D_E_L_E_T_='' "
cQuery+=" group by D3_COD,B1_DESC, SB9.TOTINV"
cQuery+=" order by D3_COD"
TCQUERY cQuery New Alias "TSD3" 

 aCampos:={} 
 cDirDocs  :="\RELATO\"                                                                                                                                  

AADD(aCampos, {"ITEM" ,"C",6,0})
AADD(aCampos, {"COD  "     ,"C",15,0})
AADD(aCampos, {"DESC  "    ,"C",50,0})
//AADD(aCampos, {"CCUSTO     "    ,"C",9,0})
AADD(aCampos, {"QTDINV        "    ,"N",14,2})
AADD(aCampos, {"QTDTRANS        "    ,"N",14,2})
AADD(aCampos, {"QTDMPUTL        "    ,"N",14,2})
AADD(aCampos, {"QTDPAPROD       "    ,"N",14,2})
AADD(aCampos, {"PERDA_MP         "    ,"N",14,4})
AADD(aCampos, {"PERDA_PR         "    ,"N",14,4})
AADD(aCampos, {"QTDCONS        "    ,"N",14,4})
AADD(aCampos, {"CONSTOTAL   "    ,"N",14,4})
cArq := Criatrab( ,.F.)
dbCreate(cDirDocs+"\"+cArq,aCampos,"CTREECDX")             //Cria o arquivo no caminho especificado
dbUseArea(.T.,"CTREECDX",cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.

 
DbSElectArea("TSD3")                                                      
DbGotop()                        		
ContI:=0
While !TSD3->(Eof())      
    ContI++
	DbselectArea("TSD3")
	RecLock("TRX",.T.)
	TRX->ITEM:=Alltrim(Str(ContI))
	TRX->COD:=TSD3->D3_COD
	TRX->DESC:=TSD3->B1_DESC
	TRX->QTDINV   :=TSD3->TOTINV
	TRX->QTDTRANS :=TSD3->QTDTRAN
	TRX->PERDA_MP:= TSD3->QTDPERD
	TRX->QTDCONS  :=TSD3->QTDCONS
	TRX->CONSTOTAL:=TSD3->QTDCONS+TSD3->QTDPERD
	Msunlock()
   /****************************************************************************************/
   /*Verifica as produ��e do produto***************************************************/
	Producao:=VerificaProd(TSD3->D3_COD)
//    Producao[i][1] Produto
//    Producao[i][2] Produ��o
//    Producao[i][3] QtdUtilizada
//    Producao[i][3] PerdaProducao
    
    For i:=1 to Len(Producao)
    	RecLock("TRX",.T.)
		TRX->ITEM:=Alltrim(Str(ContI))+"."+Alltrim(Str(i))
		TRX->COD:=Producao[i][1]
		TRX->DESC:=Posicione("SB1",1,xFilial("SB1")+Producao[i][1],"B1_DESC")
		TRX->QTDPAPROD:=Producao[i][2]
		TRX->QTDMPUTL:=Producao[i][3]
		TRX->PERDA_PR:=Producao[i][4]
//		TRX->PERDA_MP:= TSD3->QTDPERD

		Msunlock()
    Next    


   /****************************************************************************************/	
/*
    If lAbortPrint
     @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
    Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 12
   Endif

   @nLin,00       PSAY TRX->ITEM
   @nLin,00       PSAY TRX->COD
   @nLin,PCOL()+2 PSAY TRX->DESC
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDINV,"@E 99,999,999.99") 
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDTRANS,"@E 99,999,999.99")    
   @nLin,PCOL()+2 PSAY Transform(TRX->PERDAS_MP,"@E 99,999,999.99")    
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDCONS,"@E 99,999,999.99")    

   nLin := nLin + 1 // Avanca a linha de impressao
  */
   DbselectArea("TSD3")
   DbsKip()    
       
 Enddo
 

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

DbSelectArea("TSD3")
SetRegua(RecCount())
SExcel:=Msgbox("Deseja gerar o relatorio em Excel","Relatorio","YESNO")
If  SExcel
      cDirDocs  :="\RELATO\"
      cPath="C:\RELATORIO_SIGA\"
	  cNome := "RELMAT.XLS"
	  cNome := "RELMAT"+Dtos(mv_par07)+"a"+Dtos(mv_par08)+".xls
	  
  	  dbSelectArea("TRX")
	  COPY TO &(cDirDocs+cNome) via "CTREECDX"
//	  COPY TO &(cPath+cNome)
      CpyS2T( cDirDocs+cNome , cPath , .T. ) //cDirDocs+"\"+cArq+".DBF"  
      fErase(cDirDocs+cNome)
       If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
           MsgStop( 'MsExcel nao instalado' ) 
           DbSelectArea("TSD3")
	  	   DbcloseArea("TSD3")
		   DbSelectArea("TRX")
		   DbcloseArea("TRX")
	       Return
        EndIf

        oExcelApp := MsExcel():New()     // Cria um objeto para o uso do Excel
        oExcelApp:WorkBooks:Open(cPath+"\"+cNome) // Atribui � propriedade WorkBooks do Excel
  												    // o Arquivo criado com as informacoes acumuladas do SRC 
        oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
   
        MSGBOX("Foi gerado o Arquivo 'RELMAT.XLS'","Informacao","INFO")        	   

Endif  
 DbSelectArea("TSD3")
 DbcloseArea("TSD3")
 DbSelectArea("TRX")
 DbcloseArea("TRX")



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

Return
    
/***********************************************************************/

/***********************************************************************/
Static Function VerificaProd (CodMp)
CQuery:=""  
CFiltro:=" "

CFiltro:=" D_E_L_E_T_='' "	
CFiltro+=" and D3_COD='"+CodMp+"' "
CFiltro+=" and D3_EMISSAO>='"+Dtos(mv_par07)+"'  and D3_EMISSAO<='"+Dtos(mv_par08)+"' "//Movimenta��o do periodo
Cfiltro+=" and D3_CF IN('RE2') "  
CFiltro+=" and D3_ESTORNO<>'S' "                   

CQuery:=" SELECT D3_DOC,D3_TM,D3_COD, SUM(D3_QUANT)AS QTD, SUM(D3_PERDA) AS QTDPERDA FROM SD3010 C "
CQuery+=" WHERE D_E_L_E_T_='' AND EXISTS 
CQuery+=" (select D3_DOC FROM SD3010 WHERE "+cFiltro+" and D3_DOC=C.D3_DOC AND SD3010.D_E_L_E_T_='' AND C.D_E_L_E_T_='' ) "
CQuery+=" AND D3_CF in('RE2','PR0') and D3_ESTORNO<>'S'  "
CQuery+=" and D3_EMISSAO>='"+Dtos(mv_par07)+"'  and D3_EMISSAO<='"+Dtos(mv_par08)+"'"
CQuery+=" and (D3_TM='400' or D3_COD='"+CodMp+"')"
CQuery+=" GROUP BY D3_DOC,D3_TM,D3_COD   "
CQuery+=" ORDER BY D3_DOC,D3_TM,D3_COD   "
TCQUERY cQuery New Alias "ASD3" 
IProd:={}
DbSelectArea("ASD3")
DbGotop()
PosI=0
While !Eof()
    If !Empty(IProd)

    	If D3_TM="400"
		    PosI:=ASCAN(Iprod,{|x| x[1] == ASD3->D3_COD})
       		If PosI<>0
		    	IProd[PosI][2]+=ASD3->QTD    		
		    	IProd[PosI][4]+=ASD3->QTDPERDA    		
       		Else
			   	aaDD(IProd,{ASD3->D3_COD,ASD3->QTD,0,ASD3->QTDPERDA})       			
       		EndIf
        Else
		    PosI:=ASCAN(Iprod,{|x|Alltrim(x[1]) == Alltrim(ProdAnt)})
			If PosI<>0
		    	IProd[PosI][3]+=ASD3->QTD    		
		    EndIf	
        Endif 	
	Else 
	   	aaDD(IProd,{ASD3->D3_COD,ASD3->QTD,0,0})       			
    Endif 
    PosI:=0
    ProdAnt:=ASD3->D3_COD
	DbSelectArea("ASD3")
	DbSkip()
EndDo 

DbCloseArea() 
Return iProd



