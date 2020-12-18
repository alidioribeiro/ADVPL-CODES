#INCLUDE "rwmake.ch"                     
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     º Autor ³ AP6 IDE            º Data ³  02/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelMat


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc3         := ""
Local cPict          := ""
Local titulo       := ""
Local nLin         := 80
     
      
Local Cabec1       := "Relatório de Materia-Prima no processo"
Local Cabec2       := "Produto           Descrição                                            Fechamento     Transferido            Perdas           Consumo " 
Local imprime      := .T.
Local aOrd := {}                                                                                    
Local  titulo    := "Movimentação de Materia-Prima "
Local ctitulo    := "Movimentação de Materia-Prima "

Private Programa:="RELMAT"
Private cDesc1    := "Este programa tem com objetivo, imprimir a relacao de matéria-prima "
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


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	wnrel := SetPrint(cString,NomeProg,cperg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local CQuery:=""                                                         
LOCAL cDirDocs  := MsDocPath() //Path para arquivo TMPorario. Se nao existir,
Local cPath	    := AllTrim(GetTempPath()) 
Local oExcelApp
Local cFiltro:="",cQuery:=""

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relação de matéria-prima no processo"
Local cPict          := ""
Local titulo       := "Relacao de materia-prima no processo"
Local nLin         := 80


                                                                     
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
//	   Ender+=" and BK_LOCALIZ='INJECAO' "           
       Ender+=" and B2_CC='231' "
//	   FiltroBc:=" and BC_APLIC ='231' "       
	Case mv_par09=2 //Impressao
       Ender+=" and B2_CC='221' "
 //	   FiltroBc:=" and BC_APLIC ='221' "       
    Case mv_par09=3 ///montagem
	   Ender+=" and B2_CC='211' "     

    Case mv_par09=4 //Ia
	   Ender+=" and B2_CC='241' "     

	Otherwise   //Todos
       Ender+="  "
//	   FiltroBc:=" and BC_APLIC ='211' "       


EndCase            

FiltroBc:=""
If !Empty(mv_par07) 
	FiltroBC=" and BC_MOTIVO>='"+mv_par05+"' and BC_MOTIVO<='"+mv_par06+"' "
	FiltroBc+=" and BC_DTRM>='"+Dtos(mv_par07)+"'  and BC_DTRM<='"+Dtos(mv_par08)+"'"
EndIF 
FRecurso:=" C2_RECURSO>='"+mv_par10+"' and C2_RECURSO<='"+mv_par11+"' "


CQuery:= " SELECT D3_COD,B1_DESC,SB9.TOTINV AS TOTINV,"
//SBC.QTDPER AS QTDPERD,OR D3_CF='PR0'"
//CQuery+=" SUM(CASE WHEN D3_CF='RE4' AND D3_LOCAL='10' THEN D3_QUANT ELSE 0 END) AS QTDPERD, Alterado para poder jogar as perdas para o custos 02/08/2012
CQuery+=" SUM(CASE WHEN (D3_CF IN('RE4','RE5') AND D3_LOCAL='10')   THEN D3_QUANT ELSE 0 END) AS QTDPERD, " //Alterado para poder jogar as perdas para o custos 02/08/2012
//CQuery+=" SUM(CASE WHEN D3_CF='RE5' AND D3_LOCAL='10' AND D3_GRUPO<>'GGF'  THEN D3_QUANT ELSE 0 END) AS QTDPERD,
CQuery+=" SUM(CASE WHEN D3_CF='RE3' OR (D3_CF='PR0' and D3_LOCAL='10') OR (D3_CF='DE2' AND D3_TM='499') THEN D3_QUANT ELSE 0 END) AS QTDTRAN , "
CQuery+=" SUM(CASE WHEN D3_CF='RE2' AND D3_LOCAL='10' THEN D3_QUANT ELSE 0 END) AS QTDCONS "
cQuery+=" FROM SD3010 "
cQuery+=" LEFT  JOIN (SELECT B9_COD,SUM(B9_QINI) AS TOTINV FROM SB9010 WHERE D_E_L_E_T_='' AND B9_LOCAL='10' AND   B9_DATA LIKE '"+DatInv+"%' GROUP BY B9_COD ) SB9 ON SD3010.D3_COD=SB9.B9_COD "
//CqUERY+=" LEFT  JOIN (SELECT BC_PRODUTO,SUM(BC_QUANT) AS QTDPER FROM SBC010   WHERE BC_APLIC='231' AND D_E_L_E_T_=''  and BC_MOTIVO>='   ' and BC_MOTIVO<='ZZZ'  and BC_DATA>='20100201'  and BC_DATA<='20100228' GROUP BY BC_PRODUTO) SBC ON  SD3010.D3_COD=SBC.BC_PRODUTO "
//cQuery+=" LEFT  JOIN (SELECT BC_PRODUTO,SUM(BC_QUANT) AS QTDPER FROM SBC010   WHERE D_E_L_E_T_='' "+FiltroBc+" GROUP BY BC_PRODUTO) SBC ON  SD3010.D3_COD=SBC.BC_PRODUTO "
cQuery+=" INNER JOIN SB1010  ON (B1_COD=D3_COD)  "
cQuery+=" INNER JOIN SB2010  ON (B2_COD=D3_COD)  "
cQuery+=" WHERE B2_LOCAL='10' AND D3_OP >='"+mv_par01 +"' and D3_OP<='"+mv_par02 +"' "  //OP
cQuery+=" and D3_ESTORNO<>'S' "                   
cQuery+=" and D3_COD>='" +mv_par03+"' and D3_COD<='"+mv_par04+"' "  //Codigo 
cQuery+=" and D3_EMISSAO>='"+Dtos(mv_par07)+"'  and D3_EMISSAO<='"+Dtos(mv_par08)+"' "//Movimentação do periodo
//cQuery+=" and D3_CF IN('RE2','RE3','PR0','RE4','DE2') " Alt. para jogar as perdas para o custo 02/08/2012
cQuery+=" and D3_CF IN('RE2','RE3','PR0','RE4','RE5','DE2') "
cQuery+= " and D3_GRUPO NOT IN('GGF') " 
//cQuery+=" and D3_OP IN( SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM SC2010 where C2_RECURSO='INJP-9' AND D_E_L_E_T_='' )  "
cQuery+=" and D3_OP in ( SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM SC2010 where "+Frecurso+" )  "
cQuery+=Ender 


/*
Do Case 
	Case mv_par09=1 //Injecao Plastica
	   CQuery+=" and D3_CC='231' "
	Case mv_par09=2 //Impressao
	   CQuery+=" and D3_CC='221' "		   
	Otherwise   //Montagem 
	   CQuery+=" and D3_CC='211' "		   
EndCase          
*/
CQuery+=" and SD3010.D_E_L_E_T_='' AND SB1010.D_E_L_E_T_='' "
cQuery+=" group by D3_COD,B1_DESC, SB9.TOTINV"
cQuery+=" order by D3_COD"
TCQUERY cQuery New Alias "TSD3" 


                               
 
 aCampos:={} 
 cDirDocs  :="\RELATO\"                                                                                                                                  

AADD(aCampos, {"COD  "     ,"C",15,0})
AADD(aCampos, {"DESC  "    ,"C",50,0})
//AADD(aCampos, {"CCUSTO     "    ,"C",9,0})
AADD(aCampos, {"QTDINV        "    ,"N",14,2})
AADD(aCampos, {"QTDTRANS        "    ,"N",14,2})
AADD(aCampos, {"QTDPERDAS         "    ,"N",14,4})
AADD(aCampos, {"QTDCONS        "    ,"N",14,4})
AADD(aCampos, {"CONSTOTAL   "    ,"N",14,4})
cArq := Criatrab( ,.F.)
dbCreate(cDirDocs+"\"+cArq,aCampos,"DBFCDXADS")             //Cria o arquivo no caminho especificado
dbUseArea(.T.,"DBFCDXADS",cDirDocs+"\"+cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.

 
DbSElectArea("TSD3")                                                      
DbGotop()      
While !TSD3->(Eof())      
                 
	DbselectArea("TSD3")
	RecLock("TRX",.T.)
	TRX->COD:=TSD3->D3_COD
	TRX->DESC:=TSD3->B1_DESC
	TRX->QTDINV   :=TSD3->TOTINV
	TRX->QTDTRANS :=TSD3->QTDTRAN
	TRX->QTDPERDAS:= TSD3->QTDPERD
	TRX->QTDCONS  :=TSD3->QTDCONS
	TRX->CONSTOTAL:=TSD3->QTDCONS+TSD3->QTDPERD
	Msunlock()
    If lAbortPrint
     @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
    Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 10
   Endif

   @nLin,00       PSAY TRX->COD
   @nLin,PCOL()+2 PSAY TRX->DESC
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDINV,"@E 99,999,999.99") 
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDTRANS,"@E 99,999,999.99")    
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDPERDAS,"@E 99,999,999.99")    
   @nLin,PCOL()+2 PSAY Transform(TRX->QTDCONS,"@E 99,999,999.99")    

   nLin := nLin + 1 // Avanca a linha de impressao

   DbselectArea("TSD3")
   DbsKip()    
       
 Enddo
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("TSD3")
SetRegua(RecCount())
SExcel:=Msgbox("Deseja gerar o relatorio em Excel","Relatorio","YESNO")
If  SExcel
      cDirDocs  :="\RELATO\"
      cPath="C:\RELATORIO_SIGA"
	  cNome := "RELMAT.XLS"
	  cNome := "RELMAT"+Dtos(mv_par07)+"a"+Dtos(mv_par08)+".xls
	  
  	  dbSelectArea("TRX")
	  COPY TO &(cDirDocs+cNome) via "DBFCDXADS"
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
        oExcelApp:WorkBooks:Open(cPath+"\"+cNome) // Atribui à propriedade WorkBooks do Excel
  												    // o Arquivo criado com as informacoes acumuladas do SRC 
        oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
   
        MSGBOX("Foi gerado o Arquivo 'RELMAT.XLS'","Informacao","INFO")
        

	   

Endif  
 DbSelectArea("TSD3")
 DbcloseArea("TSD3")
 DbSelectArea("TRX")
 DbcloseArea("TRX")



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
