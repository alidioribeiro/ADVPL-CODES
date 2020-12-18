#include "rwmake.ch"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PCPR40  ³ Autor ³ Jorge Silveira         ³ Data ³ 13/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Formação de Preço conforme Rel. simplificada das estruturas³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±³                                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PCPR40() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "G"
LOCAL titulo   := "Relacao Completa das Estruturas"
LOCAL cDesc1   := "Este programa emite a rela‡„o de estrutura de um determinado produto"
LOCAL cDesc2   := "selecionado pelo usu rio. Esta rela‡„o n„o demonstra custos. Caso o"
LOCAL cDesc3   := "produto use opcionais, ser  listada a estrutura com os opcionais padr„o."
LOCAL cString  := "SG1"
LOCAL wnrel	   := "PCPR40"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lNegEstr:= GETMV("MV_NEGESTR")
PRIVATE aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 ,cPerg1 := "MTR225"
Private cPerg   := PADR(cPerg1,10)
Private aLinha  := {}
Private aExport := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01   // Produto de             ³
//³ mv_par02   // Produto ate            ³
//³ mv_par03   // Tipo de                ³
//³ mv_par04   // Tipo ate               ³
//³ mv_par05   // Grupo de               ³
//³ mv_par06   // Grupo ate              ³
//³ mv_par07   // Salta Pagina: Sim/Nao  ³
//³ mv_par08   // Qual Rev da Estrut     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
EndIf

RptStatus({|lEnd| PCPR40Imp(@lEnd,wnRel,titulo,Tamanho)},titulo)

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PCPR40IMP³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 11.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR225			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PCPR40Imp(lEnd,WnRel,titulo,Tamanho)

LOCAL cRodaTxt := "ESTRUTURA(S)"
LOCAL nCntImpr := 0
LOCAL nTipo    := 0
LOCAL cProduto ,nNivel ,cPictQuant:="" ,cPictPerda:="" ,nX,nPosCnt:=nPosOld:=0
LOCAL i 	   := 0
LOCAL cDirDocs := MsDocPath() //Path para arquivo temporario. Se nao existir,
Local cPath	   := AllTrim(GetTempPath()) 
Local oExcelApp                 
Local aEstru   := {}
AADD(aEstru, {"NIVEL"   ,"C"  , 4,0})
AADD(aEstru, {"COMP"    ,"C"  ,15,0})
AADD(aEstru, {"TRT"     ,"C"  ,03,0})
AADD(aEstru, {"TIPO"    ,"C"  ,03,0})
AADD(aEstru, {"GRUPO"   ,"C"  ,04,0})
AADD(aEstru, {"DESC"    ,"C"  ,50,0})
AADD(aEstru, {"UN"      ,"C"  ,02,0})
AADD(aEstru, {"OBSERV"  ,"C"  ,250,0})
AADD(aEstru, {"OBSERV1" ,"C"  ,250,0})
AADD(aEstru, {"QTDNECES","N"  ,10,6})
AADD(aEstru, {"QUANT"   ,"N"  ,10,6})
//AADD(aEstru, {"BASEST" ,"C",5,2})
AADD(aEstru, {"DATINI"  ,"D", 10})
AADD(aEstru, {"DATFIM"  ,"D", 10})

//cDrive   := 'DBFCDX'
cArq := CriaTrab(NIL,.f.)
dbCreate(cArq, aEstru, 'CTREECDX')           //Cria o arquivo no caminho especificado
dbUseArea(.T.,'CTREECDX',cArq,"TRX",.F.,.F.) //Seleciona o arquivo para uso.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cabec1:= "NIVEL                CODIGO          TRT TP GRUP OPC     DESCRICAO                          OBSERVACAO                                        QUANTIDADE UM PERDA     QUANTIDADE QTD. BASE  TIPO DE     INICIO      FIM    GRP. ITEM"
 cabec1 := "NIVEL                CODIGO          TRT TP GRUP DESCRICAO                          OBSERVACAO                                       QUANTIDADE UM           QUANTIDADE QTD. BASE  TIPO DE     INICIO      FIM    GRP. ITEM"
 cabec2 := "                                                                                                                                     NECESSARIA      %                  ESTRUTURA QUANTIDADE  VALIDADE   VALIDADE OPCI  OPCI"
//         99999999999999999999 999999999999999 999 99 9999 9999999999999999999999999999999999 XXXXXXXXX1XXXXXXXXX2XXXXXXXXX3XXXXXXXXX4XXXXX 9999999.999999 XX 99.99 9999999.999999   9999999  XXXXXXXX  99/99/9999 99/99/9999 XXX  XXXX
//         0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//         01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a Picture da quantidade (maximo de 14 posicoes)         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("G1_QUANT")
If X3_TAMANHO >= 14
	For nX := 1 To 14
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictQuant := cPictQuant+"."
		Else
			cPictQuant := cPictQuant+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 14
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictQuant := "."+cPictQuant
		Else
			cPictQuant := "9"+cPictQuant
		EndIf
	Next nX
EndIf
dbSeek("G1_PERDA")
If X3_TAMANHO >= 6
	For nX := 1 To 6
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictPerda := cPictPerda+"."
		Else
			cPictPerda := cPictPerda+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 6
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictPerda := "."+cPictPerda
		Else
			cPictPerda := "9"+cPictPerda
		EndIf
	Next nX
EndIf
dbSetOrder(1)
dbSelectArea("SG1")
SetRegua(LastRec())
Set SoftSeek On
dbSeek(xFilial()+mv_par01)
Set SoftSeek Off

While !Eof() .And. G1_FILIAL+G1_COD <= xFilial()+mv_par02
	If lEnd
		@ PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	IncRegua()
	cProduto := G1_COD
	nNivel   := 2
	dbSelectArea("SB1")
	dbSeek(xFilial()+cProduto)
	If EOF() .Or. B1_TIPO < mv_par03 .Or. B1_TIPO > mv_par04 .Or.;
		B1_GRUPO < mv_par05 .Or. B1_GRUPO > mv_par06
		dbSelectArea("SG1")
		While !EOF() .And. xFilial()+cProduto == G1_FILIAL+G1_COD
			dbSkip()
			IncRegua()
		EndDo
	Else
		If li > 58
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona 1 ao contador de registros impressos         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCntImpr++
		dbSelectArea("SB1")
        
		@ li,004 PSAY cProduto
	    @ li,024 PSAY SB1->B1_TIPO
		@ li,027 PSAY SB1->B1_GRUPO
		@ li,032 PSAY SubStr(SB1->B1_DESC,1,50)
		@ li,107 PSAY SB1->B1_UM

         
/*		@ li,024 PSAY SB1->B1_TIPO
		@ li,027 PSAY SB1->B1_GRUPO
		@ li,032 PSAY SubStr(SB1->B1_DESC,1,50)
		@ li,107 PSAY SB1->B1_UM
		@ li,172 PSAY If(SB1->B1_QB==0,'      1',SB1->B1_QB) Picture PesqPict("SB1","B1_QB",7)
		Ajuste do espaço
*/

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime grupo de opcionais.                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(SB1->B1_OPC)
			@ li,137 PSAY "Opc. "
			@ li,142 PSAY SB1->B1_OPC Picture PesqPict("SB1","B1_OPC",80)
		EndIf
		
		// 1a Linha dados do PA
		aAdd(aLinha,"Codigo:")
   			aAdd(aLinha,AllTrim(cProduto))
        aAdd(aLinha,"Descrição:")		
  			aAdd(aLinha,ALLTRIM(SB1->B1_DESC))
		aAdd(aLinha,"Tipo:")		
        	aAdd(aLinha,SB1->B1_TIPO) 
        aAdd(aLinha,"Grupo:")		
  	    	aAdd(aLinha,SB1->B1_GRUPO)          
  	    aAdd(aLinha,"Unidade:")		
        	aAdd(aLinha,ALLTRIM(SB1->B1_UM))
        aAdd(aLinha,"Base Estrut:")		
		If SB1->B1_QB==0
		   aAdd(aLinha,'1')
		else
		   aAdd(aLinha,str(SB1->B1_QB))
		endif                                
		
        If !Empty(SB1->B1_OPC)		
           aAdd(aLinha,"Opc. Default:")		
			   aAdd(aLinha,ALLTRIM(SB1->B1_OPC))
        Endif
        
		For x = 1 to 3
		  if x>1       
   		    aAdd(aLinha,"'")
          endif
          aAdd(aExport,Array(Len(aLinha)))
          aExport[Len(aExport)] := aClone(aLinha)        
          aLinha := {}       
        next
		
		@ li,172 PSAY If(SB1->B1_QB==0,'      1',SB1->B1_QB) Picture PesqPict("SB1","B1_QB",7)      

		Li += 1

 		@ li,000 PSAY __PrtThinLine()

		Li += 1

		nPosOld := nPosCnt
		nPosCnt += PCPR40Expl(cProduto,IF(SB1->B1_QB==0,1,SB1->B1_QB),nNivel,cPictQuant,cPictPerda,B1_OPC,IF(SB1->B1_QB==0,1,SB1->B1_QB),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(Empty(mv_par08),SB1->B1_REVATU,mv_par08))
		For i:= nPosOld to nPosCnt
			IncRegua()
		Next I

		//-- Verifica se salta ou nao pagina	
		If mv_par07 == 1
		    Li:= 90
		Else    
	 		@ li,000 PSAY __PrtThinLine()
	 		Li +=2
	 	EndIf	 
	EndIf
	dbSelectArea("SG1")
EndDo
If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

/*Incluido pela Aglair  Data:17/09/06*/           

dbSelectArea("TRX")
dbCloseArea("TRX")

//CpyS2T( cArq+".dbf", cPath, .T. ) //cDirDocs+"\"+cArq+".DBF"
//cCaminho := "\\NSBSRV17\G\PROTHEUS11\PROTHEUS_DATA\SYSTEM\"+cArq+".dbf"        

If     File("C:\Program Files\Microsoft Office\Office11\Excel.exe")
    WinExec("C:\Program Files\Microsoft Office\Office11\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

ElseIf File("C:\Arquivos de Programas\Microsoft Office\Office11\Excel.exe")
    WinExec("C:\Arquivos de Programas\Microsoft Office\Office11\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )
    
ElseIf File("C:\Program Files\Microsoft Office\Office12\Excel.exe")
    WinExec("C:\Program Files\Microsoft Office\Office12\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

ElseIf File("C:\Arquivos de Programas\Microsoft Office\Office12\Excel.exe")
    WinExec("C:\Arquivos de Programas\Microsoft Office\Office12\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

ElseIf File("C:\Program Files\Microsoft Office\Office14\Excel.exe")
	WinExec("C:\Program Files\Microsoft Office\Office14\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )
	
ElseIf File("C:\Arquivos de Programas\Microsoft Office\Office14\Excel.exe")
	WinExec("C:\Arquivos de Programas\Microsoft Office\Office14\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

ElseIf File("D:\Program Files\Microsoft Office\Office11\Excel.exe")
    WinExec("D:\Program Files\Microsoft Office\Office11\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

ElseIf File("D:\Arquivos de Programas\Microsoft Office\Office11\Excel.exe")
    WinExec("D:\Arquivos de Programas\Microsoft Office\Office11\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )
    
ElseIf File("D:\Program Files\Microsoft Office\Office12\Excel.exe")
    WinExec("D:\Program Files\Microsoft Office\Office12\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

ElseIf File("D:\Arquivos de Programas\Microsoft Office\Office12\Excel.exe")
    WinExec("D:\Arquivos de Programas\Microsoft Office\Office12\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

ElseIf File("D:\Program Files\Microsoft Office\Office14\Excel.exe")
	WinExec("D:\Program Files\Microsoft Office\Office14\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )
	
ElseIf File("D:\Arquivos de Programas\Microsoft Office\Office14\Excel.exe")
	WinExec("D:\Arquivos de Programas\Microsoft Office\Office14\Excel.exe \\NSBSRV17\G\Protheus11\protheus_data\system\"+cArq+".dbf" )

Endif
//
//fErase(cArq+".DBF")
//     
//If File(cPath+cNome)
//	fErase(cPath+cNome)
//EndIf
//
//
/* Exibe o Arquivo em Excel
If ! ApOleClient( 'MsExcel' )        //Verifica se o Excel esta instalado
	MsgStop( 'MsExcel nao instalado' ) 
	IW_MSGBOX("Foi gerado o Arquivo MATR225.DBF","Informacao","INFO")

?EndIf
oExcelApp := MsExcel():New()     // Cria um objeto para o uso do Excel
oExcelApp:WorkBooks:Open(cPath+"MATR225.DBF" ) // Atribui à propriedade WorkBooks do Excel
  												    // o Arquivo criado com as informacoes acumuladas do SRC 
oExcelApp:SetVisible(.T.)   // Abre o Excel com o arquivo criado exibido na Primeira planilha.
IW_MSGBOX("Foi gerado o Arquivo MATR225.DBF","Informacao","INFO")
fErase(cPath+cNome)
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SG1")
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf      

SExcel:=Msgbox("Confirma geração dos dados em Excel","Planilha","YESNO")
If  SExcel                                                    
   MsgRun("Exportando Dados, Aguarde...",,{|| Exporta()})
ENDIF

MS_FLUSH()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³PCPR40Expl ³ Autor ³ Eveli Morasco        ³ Data ³ 08/09/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Faz a explosao de uma estrutura                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ PCPR40Expl(ExpC1,ExpN1,ExpN2,ExpC2,ExpC3,ExpC4,ExpN3)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto a ser explodido                  ³±±
±±³          ³ ExpN1 = Quantidade do pai a ser explodida                  ³±±
±±³          ³ ExpN2 = Nivel a ser impresso                               ³±±
±±³          ³ ExpC2 = Picture da quantidade                              ³±±
±±³          ³ ExpC3 = Picture da perda                                   ³±±
±±³          ³ ExpC4 = Opcionais do produto                               ³±±
±±³          ³ ExpN3 = Quantidade do Produto Nivel Anterior               ³±±
±±³          ³ As outras 6 variaveis sao utilizadas pela funcao Cabec     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
STATIC Function PCPR40Expl(cProduto,nQuantPai,nNivel,cPictQuant,cPictPerda,cOpcionais,nQtdBase,Titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,cRevisao)
LOCAL nReg,nQuantItem,nCntItens := 0
LOCAL nPrintNivel
Local nX        := 0
Local aObserv   := {}
Local aAreaSB1  := {}          

dbSelectArea("SG1")
While !Eof() .And. G1_FILIAL+G1_COD == xFilial()+cProduto

    /*
    If ddatabase < G1_Ini .Or. ddatabase > G1_Fim
       dbSkip()
       Loop
    End */  

	nReg       := Recno()
	nQuantItem := ExplEstr(nQuantPai,,cOpcionais,cRevisao)
	dbSelectArea("SG1")
	If lNegEstr .Or. (!lNegEstr .And. QtdComp(nQuantItem,.T.) > QtdComp(0) )
		If li > 58
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			dbSelectArea("SB1")
			aAreaSB1:=GetArea()
			dbSeek(xFilial()+cProduto)
			@ li,004 PSAY cProduto
			@ li,024 PSAY SB1->B1_TIPO
			@ li,027 PSAY SB1->B1_GRUPO
			@ li,032 PSAY SubStr(SB1->B1_DESC,1,34)
			@ li,107 PSAY SB1->B1_UM
			@ li,172 PSAY If(SB1->B1_QB==0,'      1',SB1->B1_QB) Picture PesqPict("SB1","B1_QB",7)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime grupo de opcionais.                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(SB1->B1_OPC)
				@ li,137 PSAY "Opc. "
				@ li,142 PSAY SB1->B1_OPC Picture PesqPict("SB1","B1_OPC",80)
			EndIf
			RestArea(aAreaSB1)

  		    Li += 1

 		    @ li,000 PSAY __PrtThinLine()
		    Li += 1
			dbSelectArea("SG1")
		EndIf
		
		//-- Divide a Observa‡„o em Sub-Arrays com 45 posi‡”es
		//aObserv := {}
		//For nX := 1 to MlCount(AllTrim(G1_OBSERV + G1_OBSERV2),45)
		//	aAdd(aObserv, MemoLine(AllTrim(G1_OBSERV + G1_OBSERV2),45,nX))
		//Next nX
		
	   /* aAdd(aLinha,AllTrim(cProduto))
        aAdd(aLinha,SB1->B1_TIPO) 
  	    aAdd(aLinha,SB1->B1_GRUPO)          
  		aAdd(aLinha,ALLTRIM(SB1->B1_DESC))
        aAdd(aLinha,ALLTRIM(SB1->B1_UM))
		aAdd(aLinha,"Opc. "+ALLTRIM(SB1->B1_OPC))
		If SB1->B1_QB==0
		   aAdd(aLinha,'1')
		else
		   aAdd(aLinha,str(SB1->B1_QB))
		endif  */

		nPrintNivel := IIF(nNivel>17,17,nNivel-2)
		
		@ li,nPrintNivel PSAY StrZero(nNivel,3) 
		  aAdd(aLinha,"'"+StrZero(nNivel,3))
		
		SB1->(dbSeek(xFilial("SB1")+SG1->G1_COMP))

//        @ li,52  PSAY G1_GROPC+'-'+G1_OPC  //Adiciona grupo e item do grupo 19/04/2012
        /*
         Fonte:Original
         			@ li,21  PSay G1_COMP
			@ li,37  PSay Substr(G1_TRT,1,3)
			@ li,41  PSay SB1->B1_TIPO
			@ li,44  PSay SB1->B1_GRUPO
			@ li,49  PSay SubStr(SB1->B1_DESC,1,34)
			@ li,84  PSay If(Len(aObserv)>0,aObserv[1],Left(G1_OBSERV,45))
	  	    @ li,130 PSay nQuantItem Picture cPictQuant
 			@ li,145 PSay SB1->B1_UM
			@ li,147 PSay G1_PERDA   Picture cPictPerda
			@ li,152 PSay G1_QUANT   Picture cPictQuant
			@ li,168 PSay If(RetFldProd(SB1->B1_COD,"B1_QB")==0,1,RetFldProd(SB1->B1_COD,"B1_QB")) Picture PesqPict("SB1","B1_QB",11)
			@ li,180 PSay If(G1_FIXVAR $' úV',STR0011,STR0012)		//"VARIAVEL"###"FIXA"
			@ li,190 PSay G1_INI	Picture PesqPict("SG1","G1_INI",10)
			@ li,201 PSay G1_FIM	Picture PesqPict("SG1","G1_FIM",10)
			@ li,212 PSay G1_GROPC	Picture PesqPict("SG1","G1_GROPC",3)
			@ li,216 PSay G1_OPC	Picture PesqPict("SG1","G1_OPC",4)

        */        
 
		@ li,21  PSAY G1_COMP
    	  aAdd(aLinha,"'"+AllTrim(G1_COMP))
		@ li,37  PSAY Substr(G1_TRT,1,3)
          aAdd(aLinha,Substr(G1_TRT,1,3))		
		@ li,41  PSAY SB1->B1_TIPO
          aAdd(aLinha,SB1->B1_TIPO)				  
		@ li,44  PSAY SB1->B1_GRUPO //Atual
		  aAdd(aLinha,SB1->B1_GRUPO)				  
		@ li,49  PSAY TRIM(SB1->B1_DESC)
  		  aAdd(aLinha,ALLTRIM(SB1->B1_DESC))				  
		@ li,95  PSAY G1_OBSERV     //If(Len(aObserv)>0,aObserv[1],Left(G1_OBSERV,45))
		   aAdd(aLinha,"'"+ALLTRIM(G1_OBSERV))				   
   	    @ li,142 PSAY nQuantItem Picture cPictQuant
   	      aAdd(aLinha,TRANSFORM(nQuantItem, "@E 999.999999"))				   
		@ li,157 PSAY SB1->B1_UM
		  aAdd(aLinha,SB1->B1_UM)				   
//		@ li,148 PSAY G1_PERDA   Picture cPictPerda
		@ li,159 PSAY G1_QUANT   Picture cPictQuant //171
		  aAdd(aLinha,TRANSFORM(G1_QUANT, '@E 999.999999'))				    
		@ li,175 PSAY If(SB1->B1_QB==0,1,SB1->B1_QB) Picture PesqPict("SB1","B1_QB",2)
		  If SB1->B1_QB==0
  		     aAdd(aLinha,'1')				   
  		  else
  		     aAdd(aLinha,Str(SB1->B1_QB))  		  
  		  endif   
//		@ li,180 PSAY If(G1_FIXVAR $' úV',STR0011,STR0012)		//"VARIAVEL"###"FIXA"
		@ li,187 PSAY G1_INI Picture PesqPict("SG1","G1_INI",10)
  		  //aAdd(aLinha,Substr(G1_INI,7,2)+"/"+Substr(G1_INI,5,2)+"/"+Substr(G1_INI,1,4))				   
  		  aAdd(aLinha,dtoc(G1_INI))
		@ li,198 PSAY G1_FIM Picture PesqPict("SG1","G1_FIM",10)
		  //aAdd(aLinha,Substr(G1_FIM,7,2)+"/"+Substr(G1_FIM,5,2)+"/"+Substr(G1_FIM,1,4))
		  aAdd(aLinha,dtoc(G1_FIM))
		@ li,209 PSAY G1_GROPC Picture PesqPict("SG1","G1_GROPC",3)
		  aAdd(aLinha,G1_GROPC)
		@ li,213 PSAY G1_OPC Picture PesqPict("SG1","G1_OPC",4)
		  aAdd(aLinha,G1_OPC)
		  
		//-- Caso existam, Imprime as outras linhas da Observa‡„o
        /*inclui arq.parar o excelaglair*/
        dbselectarea("TRX")
        RecLock("TRX",.T.)
        TRX->NIVEL   := StrZero(nNivel,3)
		TRX->COMP    := SG1->G1_COMP
		TRX->TRT     := Substr(SG1->G1_TRT,1,3)
		TRX->TIPO    := SB1->B1_TIPO
		TRX->GRUPO   := SB1->B1_GRUPO
		TRX->DESC    := substr(SB1->B1_DESC,1,50)
		TRX->OBSERV  := SG1->G1_OBSERV 
		TRX->OBSERV1 := substring(SG1->G1_OBSERV ,250,500)
		TRX->QTDNECES:= nQuantItem
		TRX->UN      := SB1->B1_UM
		TRX->QUANT   := SG1->G1_QUANT 
//		TRX->BASEST  := If(SB1->B1_QB==0,STR(0),STR(SB1->B1_QB)) 
		TRX->DATINI  := SG1->G1_INI
		TRX->DATFIM  := SG1->G1_FIM
                /*aglair*/
        If Len(aObserv) > 1
			For nX := 2 to Len(aObserv)
				Li ++
				@ li,107 PSAY aObserv[nX]
			Next nX
		EndIf
		
		Li++
		
 	    aAdd(aExport,Array(Len(aLinha)))
        aExport[Len(aExport)] := aClone(aLinha)
        aLinha := {}
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe sub-estrutura                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SG1")
		dbSeek(xFilial()+G1_COMP)
		IF Found()
			PCPR40Expl(G1_COD,nQuantItem,nNivel+1,cPictQuant,cPictPerda,cOpcionais,IF(SB1->B1_QB==0,1,SB1->B1_QB),titulo,cabec1,cabec2,wnrel,Tamanho,nTipo,If(!Empty(SB1->B1_REVATU),SB1->B1_REVATU,mv_par08))
		EndIf
		dbGoto(nReg)
	EndIf
	dbSkip()
	nCntItens++

EndDo
nCntItens--
Return nCntItens
/******************************************************************************/

/*-----------------------------------------------.
 |     Rotina de geração do arquivo em Excel     |
 '-----------------------------------------------*/

Static Function Exporta()
   Local cArqTxt    := GetTempPath() + "PCPR40.xls"
   Local nHdl       :=  Nil 
   Local cLinha     := "" //Chr(9)+"Relatório"+Chr(13)+Chr(10)   
   
   If File(cArqTxt)
	  FErase(cArqTxt)
   Endif
   
   nHdl := fCreate(cArqTxt)                         
   
   If !File(cArqTXT)
      MsgStop("O Arquivo " + cArqTXT + " não pode ser Criado!")
	  Return nil  
   EndIf	

   cLinha := "Relação Completa da Estrutura"+chr(13)+chr(10)

   If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
   EndIf    
	
   cLinha := "Nivel"+Chr(9)+"Codigo"+Chr(9)+"TRT"+Chr(9)+"TP"+Chr(9)+"GRUP"+Chr(9)+"Descricao"+Chr(9)+"Observacao"+Chr(9)+"Qtde.Necessaria"+Chr(9)+"UM"+Chr(9)
   cLinha += "Quantidade"+Chr(9)+"Qtde.Base Estrut"+Chr(9)+"Inicio Valid."+Chr(9)+"Fim Valid."+Chr(9)+"Grp.OPCI"+Chr(9)+"Item.OPCI"  +chr(13)+chr(10)                                                               
	
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