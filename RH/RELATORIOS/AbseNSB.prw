#include "rwmake.ch"        // inclcSaldoHEuido  asistente de conversao do AP5 IDE em 21/02/02
#Include "TOPCONN.CH" 
#include "ap5mail.ch"
#Include "TBICONN.CH"
#Include "Protheus.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO12    � Autor � AP6 IDE            � Data �  20/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AbseNSB()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������/*                                                      
Private  cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private  cDesc2         := "de acordo com os parametros informados pelo usuario."
Private  cDesc3         := "ABSENTEISMO "
Private  titulo       := "ABSENTEISMO "
Private  nLin         := 80
Private  Cabec1       := "Matricula  Nome                                  C.C  Turno---------------------------------------------    Admiss�o     Demiss�o   Evento---------------------------  Motivo--------------------------------------- "
Private  Cabec2       := "                                                      Codigo       Descri��o                                                        Data      Codigo  Descri��o        Codigo   Descri��o        Qtd        Qtd Acum "

Private imprime      := .T.
Private aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "ABSNSB" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ABSNSB" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Private cperg         := "ABSNSB    "

If ! Pergunte (cPerg,.T.,'Parametro para gera��o do relat�rio')
	Return
Endif 
//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.F.)
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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,wnrel) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  20/06/11   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,wnrel)

Local nOrdem


cFiltro:=" AND RA_CC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' " // Filtra por CCusto
cFiltro+=" AND  RA_TNOTRAB BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " //Turno de Trabalho
cFiltro+=" AND RA_MAT   BETWEEN '"+mv_par05+ "' AND '" +mv_par06+"'" //Matricula
cFiltro+=" AND RA_NOME  BETWEEN '"+mv_par07+ "' AND '" +mv_par08+"'" //Nome

cQuery:=""
/*
If mv_par13#3
	SelVerba:="AND C.P9_CODIGO>'400' " //-- Colocar o parametro com as verbas a serem selecionadas 
EndIf 
*/

if mv_par13 = 1 .or. mv_par13=3
	// Monta a query com os itens com advertencia
	QCAdv:=" SELECT RA_MAT as MAT ,RA_NOME as NOME,RA_CC AS CC,PC_TURNO AS TURNO,R6_DESC AS DESCT,"
	QCAdv+="SUBSTRING(RA_ADMISSA,7,2)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADM, "
	QCAdv+="SUBSTRING(RA_DEMISSA,7,2)+'/'+SUBSTRING(RA_DEMISSA,5,2)+'/'+SUBSTRING(RA_DEMISSA,1,4) AS DTDEM,"                                     
	QCAdv+="SUBSTRING(PC_DATA,7,2)+'/'+SUBSTRING(PC_DATA,5,2)+'/'+SUBSTRING(PC_DATA,1,4) AS DTENV,"
	QCAdv+="P9_CODIGO AS CODEV,P9_DESC DESCEV,ISNULL(P6_CODIGO,'') AS CMOT,ISNULL(P6_DESC,'') AS DESMOT,PC_QUANTC AS QTDHORAS "
	QCAdv+="FROM "+RetSqlName("SRA")+"  AS A "
	QCAdv+="INNER JOIN "+ RetSqlName("SPC")+"  AS B "
	QCAdv+="ON RA_MAT=PC_MAT  "
	QCAdv+="INNER JOIN "+RetSqlName("SP9")+" AS C "
	QCAdv+=" ON (P9_CODIGO=PC_PD or P9_CODIGO=PC_PDI) "
	QCAdv+=" LEFT  JOIN "+RetSqlName("SP6")+" AS D "
	QCAdv+="ON (P6_CODIGO=PC_ABONO AND D.D_E_L_E_T_='') "
	QCAdv+="INNER JOIN "+ RetSqlName("SR6")+"  AS E "
	QCAdv+="ON R6_TURNO=PC_TURNO "
	QCAdv+=" WHERE "
	QCAdv+=" A.D_E_L_E_T_='' "
	QCAdv+="AND B.D_E_L_E_T_='' "
	QCAdv+="AND C.D_E_L_E_T_='' "
	QCAdv+="AND E.D_E_L_E_T_='' "
	QCAdv+="AND C.P9_CODIGO>'400' " //-- Colocar o parametro com as verbas a serem selecionadas 
	QCAdv+=" AND B.PC_DATA BETWEEN '"+Dtos(mv_par11)+"' and '"+ Dtos(mv_par12)+"' " 
	//cQuery+=" AND D.P6_CODIGO NOT IN('069','024') " //Retirar a sa�da a servi�o e esquecimento de marca��o 
	//Motivos a serem abonados no absenteismos 
	//Conf. solicita��o do RH
	//"001/002/003/005/006/008/012/013/019/020/030/040/042/055/057/058/059/060/061/078/095"
//	QCAdv+=" and PC_ABONO in('001/002/003/005/006/008/012/013/019/020/030/040/042/055/057/058/059/060/061/078/095') "
		
	QCAdv+= CFiltro
	QCAdv+="UNION "
		//---Apontamentos acumulado
	QCAdv+=" SELECT RA_MAT AS MAT,RA_NOME AS NOME ,RA_CC AS CC ,PH_TURNO AS TURNO ,R6_DESC AS DESCT, "
	QCAdv+=" SUBSTRING(RA_ADMISSA,7,2)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADM,"
	QCAdv+=" SUBSTRING(RA_DEMISSA,7,2)+'/'+SUBSTRING(RA_DEMISSA,5,2)+'/'+SUBSTRING(RA_DEMISSA,1,4) AS DTDEM,"
	QCAdv+=" SUBSTRING(PH_DATA,7,2)+'/'+SUBSTRING(PH_DATA,5,2)+'/'+SUBSTRING(PH_DATA,1,4) AS DTENV,"
	QCAdv+=" P9_CODIGO AS CODEV,P9_DESC AS DESCEV,ISNULL(P6_CODIGO,'') AS CMOT,ISNULL(P6_DESC,'') AS DESMOT,PH_QUANTC AS QTDHORAS"
	QCAdv+=" FROM "+RetSqlName("SRA")+"  AS A "
	QCAdv+=" INNER JOIN "+RetSqlName("SPH")+" AS B "
	QCAdv+=" ON RA_MAT=PH_MAT "
	QCAdv+=" INNER JOIN "+RetSqlName("SP9")+" AS C "
	//QCAdv+=" ON P9_CODIGO=PH_PD "
	QCAdv+=" ON (P9_CODIGO=PH_PD or P9_CODIGO=PH_PDI) "	
	QCAdv+=" LEFT JOIN "+RetSqlName("SP6")+" AS D "
	QCAdv+=" ON (P6_CODIGO=PH_ABONO AND D.D_E_L_E_T_='' )"
	QCAdv+=" INNER JOIN "+ RetSqlName("SR6")+"  AS E "
	QCAdv+=" ON R6_TURNO=PH_TURNO "
	QCAdv+=" WHERE "
	QCAdv+=" A.D_E_L_E_T_='' "
	QCAdv+=" AND B.D_E_L_E_T_='' "
//	QCAdv+=" AND D.D_E_L_E_T_='' "
	QCAdv+=" AND C.D_E_L_E_T_=''  "
	QCAdv+=" AND E.D_E_L_E_T_='' "
	QCAdv+=" AND C.P9_CODIGO>'400' " //-- Colocar o parametro com as verbas a serem selecionadas 
		//cQuery+=" AND D.P6_CODIGO NOT IN('069','024') " //Retirar a sa�da a servi�o e esquecimento de marca��o
		//cQuery+=" AND D.P6_CODIGO NOT IN('071','024') "//
	QCAdv+=" AND B.PH_DATA BETWEEN '"+Dtos(mv_par11)+"' and '"+ Dtos(mv_par12)+"' " 
	//Motivos a serem abonados no absenteismos 
	//Conf. solicita��o do RH
	//"001/002/003/005/006/008/012/013/019/020/030/040/042/055/057/058/059/060/061/078/095"
   // QCAdv+=" and PH_ABONO in('001/002/003/005/006/008/012/013/019/020/030/040/042/055/057/058/059/060/061/078/095') "

	QCAdv+= CFiltro                                                                 
	cQuery+=QCAdv
EndIf
If mv_par13=2 .or. mv_par13=3
    //Monta a query sem advert�ncia
    if mv_par13=3
		QSAdv:=" UNION select RA_MAT AS MAT,RA_NOME AS NOME ,RA_CC AS CC,RA_TNOTRAB AS TURNO,R6_DESC AS DESCT, "
	Else 	
		QSAdv:=" select RA_MAT AS MAT,RA_NOME AS NOME ,RA_CC AS CC,RA_TNOTRAB AS TURNO,R6_DESC AS DESCT, "
    EndIf 
	QSAdv+=" SUBSTRING(RA_ADMISSA,7,2)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADM,"
	QSAdv+=" SUBSTRING(RA_DEMISSA,7,2)+'/'+SUBSTRING(RA_DEMISSA,5,2)+'/'+SUBSTRING(RA_DEMISSA,1,4) AS DTDEM,"
	QSAdv+=" 'N/C' AS DTENV,"
	QSAdv+=" 'N/C' AS CODEV,'N/C' AS DESCEV,'N/C' AS CMOT,'N/C' AS DESMOT,0 AS QTDHORAS"
	QSAdv+=" from "+RetSqlName("SRA")+"  A "
	QSAdv+=" INNER JOIN "+ RetSqlName("SR6")+"  "
	QSAdv+=" ON R6_TURNO=RA_TNOTRAB "
	QSAdv+=" WHERE "
	QSAdv+=" A.D_E_L_E_T_='' AND "
	QSAdv+=" (RA_DEMISSA='' OR RA_DEMISSA BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"') "
//	QSAdv+=" AND "
	QSAdv+= CFiltro+" AND "                      
	QSAdv+=" RA_MAT NOT IN( "
	QSAdv+="	select PC_MAT from "+ RetSqlName("SPC")+"  A "
	QSAdv+="	where  "
	QSAdv+="   A.D_E_L_E_T_='' AND "
	QSAdv+="   A.PC_PD >='400' AND "// --Selecao das verbas.
	QSAdv+="   A.PC_DATA BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"' "
	QSAdv+="	GROUP BY PC_MAT "
	QSAdv+="	UNION  "
	QSAdv+="	select PH_MAT AS PC_MAT from "+RetSqlName("SPH")+" A "
	QSAdv+="	where  "
	QSAdv+="   A.D_E_L_E_T_='' AND "
	QSAdv+="  A.PH_PD >='400'  AND  " //Selecao das verbas.
	QSAdv+="  PH_DATA BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"' "
	QSAdv+= " GROUP BY PH_MAT ) "
	cQuery+=QSAdv
EndIf





////*********************************************************************//
//Se a op��o for todas as verbas

if mv_par13 =4
	// Monta a query com os itens com advertencia
	QCAdv:=" SELECT RA_MAT as MAT ,RA_NOME as NOME,RA_CC AS CC,PC_TURNO AS TURNO,R6_DESC AS DESCT,"
	QCAdv+="SUBSTRING(RA_ADMISSA,7,2)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADM, "
	QCAdv+="SUBSTRING(RA_DEMISSA,7,2)+'/'+SUBSTRING(RA_DEMISSA,5,2)+'/'+SUBSTRING(RA_DEMISSA,1,4) AS DTDEM,"                                     
	QCAdv+="SUBSTRING(PC_DATA,7,2)+'/'+SUBSTRING(PC_DATA,5,2)+'/'+SUBSTRING(PC_DATA,1,4) AS DTENV,"
	QCAdv+="P9_CODIGO AS CODEV,P9_DESC DESCEV,ISNULL(P6_CODIGO,'') AS CMOT,ISNULL(P6_DESC,'') AS DESMOT,PC_QUANTC AS QTDHORAS "
	QCAdv+="FROM "+RetSqlName("SRA")+"  AS A "
	QCAdv+="INNER JOIN "+ RetSqlName("SPC")+"  AS B "
	QCAdv+="ON RA_MAT=PC_MAT "
	QCAdv+="INNER JOIN "+RetSqlName("SP9")+" AS C "
//	QCAdv+=" ON P9_CODIGO=PC_PD "
	QCAdv+=" ON (P9_CODIGO=PC_PD or P9_CODIGO=PC_PDI) "
	QCAdv+=" LEFT  JOIN "+RetSqlName("SP6")+" AS D "
	QCAdv+="ON (P6_CODIGO=PC_ABONO AND D.D_E_L_E_T_='') "
	QCAdv+="INNER JOIN "+ RetSqlName("SR6")+"  AS E "
	QCAdv+="ON R6_TURNO=PC_TURNO "
	QCAdv+=" WHERE "
	QCAdv+=" A.D_E_L_E_T_='' "
	QCAdv+="AND B.D_E_L_E_T_='' "
	QCAdv+="AND C.D_E_L_E_T_='' "
	QCAdv+="AND E.D_E_L_E_T_='' "
//	QCAdv+="AND C.P9_CODIGO>'400' " //-- Colocar o parametro com as verbas a serem selecionadas 
	QCAdv+=" AND B.PC_DATA BETWEEN '"+Dtos(mv_par11)+"' and '"+ Dtos(mv_par12)+"' " 
		//cQuery+=" AND D.P6_CODIGO NOT IN('069','024') " //Retirar a sa�da a servi�o e esquecimento de marca��o 
	QCAdv+= CFiltro
	QCAdv+="UNION "
		//---Apontamentos acumulado
	QCAdv+=" SELECT RA_MAT AS MAT,RA_NOME AS NOME ,RA_CC AS CC ,PH_TURNO AS TURNO ,R6_DESC AS DESCT, "
	QCAdv+=" SUBSTRING(RA_ADMISSA,7,2)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADM,"
	QCAdv+=" SUBSTRING(RA_DEMISSA,7,2)+'/'+SUBSTRING(RA_DEMISSA,5,2)+'/'+SUBSTRING(RA_DEMISSA,1,4) AS DTDEM,"
	QCAdv+=" SUBSTRING(PH_DATA,7,2)+'/'+SUBSTRING(PH_DATA,5,2)+'/'+SUBSTRING(PH_DATA,1,4) AS DTENV,"
	QCAdv+=" P9_CODIGO AS CODEV,P9_DESC AS DESCEV,ISNULL(P6_CODIGO,'') AS CMOT,ISNULL(P6_DESC,'') AS DESMOT,PH_QUANTC AS QTDHORAS"
	QCAdv+=" FROM "+RetSqlName("SRA")+"  AS A "
	QCAdv+=" INNER JOIN "+RetSqlName("SPH")+" AS B "
	QCAdv+=" ON RA_MAT=PH_MAT "
	QCAdv+=" INNER JOIN "+RetSqlName("SP9")+" AS C "
	//QCAdv+=" ON P9_CODIGO=PH_PD "
	QCAdv+=" ON (P9_CODIGO=PH_PD or P9_CODIGO=PH_PDI) "	
	QCAdv+=" LEFT JOIN "+RetSqlName("SP6")+" AS D "
	QCAdv+=" ON (P6_CODIGO=PH_ABONO AND D.D_E_L_E_T_='' )"
	QCAdv+=" INNER JOIN "+ RetSqlName("SR6")+"  AS E "
	QCAdv+=" ON R6_TURNO=PH_TURNO "
	QCAdv+=" WHERE "
	QCAdv+=" A.D_E_L_E_T_='' "
	QCAdv+=" AND B.D_E_L_E_T_='' "
//	QCAdv+=" AND D.D_E_L_E_T_='' "
	QCAdv+=" AND C.D_E_L_E_T_=''  "
	QCAdv+=" AND E.D_E_L_E_T_='' "
  //	QCAdv+=" AND C.P9_CODIGO>'400' " //-- Colocar o parametro com as verbas a serem selecionadas 
		//cQuery+=" AND D.P6_CODIGO NOT IN('069','024') " //Retirar a sa�da a servi�o e esquecimento de marca��o
		//cQuery+=" AND D.P6_CODIGO NOT IN('071','024') "//
	QCAdv+=" AND B.PH_DATA BETWEEN '"+Dtos(mv_par11)+"' and '"+ Dtos(mv_par12)+"' " 
	QCAdv+= CFiltro                                                                 
	cQuery+=QCAdv
EndIf
If mv_par13=2 .or. mv_par13=3
    //Monta a query sem advert�ncia
    if mv_par13=3
		QSAdv:=" UNION select RA_MAT AS MAT,RA_NOME AS NOME ,RA_CC AS CC,RA_TNOTRAB AS TURNO,R6_DESC AS DESCT, "
	Else 	
		QSAdv:=" select RA_MAT AS MAT,RA_NOME AS NOME ,RA_CC AS CC,RA_TNOTRAB AS TURNO,R6_DESC AS DESCT, "
    EndIf 
	QSAdv+=" SUBSTRING(RA_ADMISSA,7,2)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADM,"
	QSAdv+=" SUBSTRING(RA_DEMISSA,7,2)+'/'+SUBSTRING(RA_DEMISSA,5,2)+'/'+SUBSTRING(RA_DEMISSA,1,4) AS DTDEM,"
	QSAdv+=" 'N/C' AS DTENV,"
	QSAdv+=" 'N/C' AS CODEV,'N/C' AS DESCEV,'N/C' AS CMOT,'N/C' AS DESMOT,0 AS QTDHORAS"
	QSAdv+=" from "+RetSqlName("SRA")+"  A "
	QSAdv+=" INNER JOIN "+ RetSqlName("SR6")+"  "
	QSAdv+=" ON R6_TURNO=RA_TNOTRAB "
	QSAdv+=" WHERE "
	QSAdv+=" A.D_E_L_E_T_='' AND "
	QSAdv+=" (RA_DEMISSA='' OR RA_DEMISSA BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"') "
//	QSAdv+=" AND "
	QSAdv+= CFiltro+" AND "                      
	QSAdv+=" RA_MAT NOT IN( "
	QSAdv+="	select PC_MAT from "+ RetSqlName("SPC")+"  A "
	QSAdv+="	where  "
	QSAdv+="   A.D_E_L_E_T_='' AND "
//	QSAdv+="   A.PC_PD >='400' AND "// --Selecao das verbas.
	QSAdv+="   A.PC_DATA BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"' "
	QSAdv+="	GROUP BY PC_MAT "
	QSAdv+="	UNION  "
	QSAdv+="	select PH_MAT AS PC_MAT from "+RetSqlName("SPH")+" A "
	QSAdv+="	where  "
	QSAdv+="   A.D_E_L_E_T_='' AND "
  //	QSAdv+="  A.PH_PD >='400'  AND  " //Selecao das verbas.
	QSAdv+="  PH_DATA BETWEEN '"+Dtos(mv_par11)+"' AND '"+Dtos(mv_par12)+"' "
	QSAdv+= " GROUP BY PH_MAT ) "
	cQuery+=QSAdv
EndIf

///*********************************************************************//


TcQuery cQuery Alias "TRB"


dbSelectArea("TRB")
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

dbGoTop()
QtdAcu:=0
cMat:=""
While !EOF()

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

   //nTipo  := IIF(aReturn[4]==1,15,18)
   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
//      Cabec("A","B","B","d",10,10)
      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
      nLin := 9
   Endif                                    
   if !Empty(cMat) .and. cMat # TRB->MAT
	 QtdAcu:=0
   	 @ nlin,00  Psay  Replicate('-',220)	
     nLin++
   	 If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	      cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
          nLin := 9
     EndIf
  Endif                                    


   cMat:=TRB->MAT
   QtdAcu+=QTDHORAS  
   QtdAcu:=Round(QtdAcu,2)  
   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
    @ nlin,00  Psay TRB->MAT
    @ nlin,08  Psay "|"+SUBSTRING(TRB->NOME,1,39)
    @ nlin,47  Psay "|"+Alltrim(TRB->CC)
    @ nlin,52  Psay "|"+Alltrim(TRB->TURNO)
    @ nlin,64  Psay "|"+Substr(Alltrim(TRB->DESCT),1,35)
    @ nlin,106 Psay "|"+TRB->DTADM
    @ nlin,116 Psay "|"+TRB->DTDEM
    @ nlin,126  Psay "|"+TRB->DTENV
    @ nlin,141 Psay "|"+IIf(Empty(TRB->CODEV),'XXX',TRB->CODEV)
    @ nlin,146 Psay "|"+iif(Empty(TRB->DESCEV),'NAO JUSTIFICADO',Substr(Alltrim(TRB->DESCEV),1,15))
    @ nlin,163 Psay "|"+TRB->CMOT
    @ nlin,168 Psay "|"+Substr(Alltrim(TRB->DESMOT),1,20)
    @ nlin,190 Psay "|"+Transform(QTDHORAS,"@ 999.99")
    @ nlin,200 Psay "|"+Transform(QtdAcu  ,  "@ 999.99")

    
    nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
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
DbSelectArea("TRB")
DbCloseArea() 
Return
