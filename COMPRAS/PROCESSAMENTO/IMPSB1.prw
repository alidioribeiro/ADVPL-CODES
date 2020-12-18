#include 'rwmake.ch'
#include 'protheus.ch'
#include 'topconn.ch'

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		   	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPATOMN  บAutor  ณ Sr. Alex		     บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta dados do cadastro de produtos                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ NIPPON                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function IMPSB1()

Private cPerg	:= "IMPSB1"
Private nOpca 	:= 0
ValidPerg() // Ajusta as Perguntas do SX1
Pergunte(cPerg,.T.) // Carrega as Perguntas do SX1

DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Importa็ใo SB1") PIXEL    //"Rec lculo do Custo de Reposio"
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi("Esta rotina realiza a importa็ใo de Planilha Excel Com  os dados do cadastro de    ") SIZE 268, 8 OF oDlg PIXEL    
@ 38, 15 SAY OemToAnsi("produtos. ") SIZE 268, 8 OF oDlg PIXEL
@ 48, 15 SAY OemToAnsi("Para isto, o caminho de  localiza็ใo da Planilha deve ser informado nos Parametros") SIZE 268, 8 OF oDlg PIXEL    
DEFINE SBUTTON FROM 80, 196 TYPE 5 ACTION pergunte(cPerg,.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 250 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
   MsAguarde({|| fImpExcel()},OemtoAnsi("Aguarde Efetuando Importa็ใo da Planilha"))
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIMPEXCEL บAutor  ณDeltaDecisao        บ Data ณ  14/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta planilha Ativo Fixo                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ZATIX                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FImpExcel()

Local _cNumPVPro  := ''
Local _cNumPVSer  := ''
Local nHdl 		  := ExecInDLLOpen(iif(file('C:\Smartclient11\readexcel.dll'),'C:\Smartclient11\readexcel.dll','C:\Smartclient\readexcel.dll'))
Local cBuffer	  := ''
Local cDir		  := Alltrim(MV_PAR01)
Local cArq		  := Alltrim(MV_PAR02)
local _cTipo	  := "EX"
Private _aCelulas  := {}
Private 	aLog:= {} 
//Private _ntxDepre  := MV_PAR03
// Efetua ajuste no Parametro de Diretorio
Private cTexto := ""
Private lGravalog := .f.
//

If Right(Alltrim(cDir),1) <>'\'
   cDir := Alltrim(cDir)+"\"
Endif
// Efetua Ajuste na Variavel de Nome do Arquivo
cArq := Alltrim(cArq)
If Right(cArq,4) <>'.XLS' .AND. Right(cArq,4) <>'.XLSX'
   cArq := substr(cArq,1,AT(".",cArq)-1)+".XLSX"
Endif
cFile   := cDir+cArq
//
//cFileLog := cDir+substr(cArq,1,AT(".",cArq)-1)+".TXT"
//If File(cFileLog) 
//   Ferase(cFileLog)
//Endif


// Elementos da Matriz _aCelula
// 
// 1o.-> Descri็ใo do Campo
// 2o.-> Coluna da Planilha
// 3o.-> Linha da Planilha
// 4o.-> Tipo do dado a ser Gravado( Caracter,Numerico,Data)
// 5o.-> Tamanho do Dado a Ser Gravado
// 6o.-> Casas decimais do dado a ser Gravado

// Montagem das Celulas 
//B1_COD	B1_DESC_EN	B1_QE	B1_EMIN	B1_PESO	B1_ESTSEG	B1_PE	B1_TIPE	 B1_LE	B1_LM	B1_TOLER	B1_UREV	B1_MRP	B1_EMAX	B1_PERSEG	B1_INDPER
//C-15      C-50        N-14,4  N-12,2  N-11,4  N-12,2      N-5,0   C-1      N-14,4 N-14,4  N-3,0       D-8     C-1     N-12,2  N-5,2       N-5,2 
AADD(_aCelulas,{'B1_COD               ',"A",01,'C',15,0}) 
AADD(_aCelulas,{'B1_DESC_EN           ',"B",01,'C',50,0}) 
AADD(_aCelulas,{'B1_QE                ',"C",01,'N',14,4}) 
AADD(_aCelulas,{'B1_EMIN              ',"D",01,'N',12,2}) 
AADD(_aCelulas,{'B1_PESO              ',"E",01,'N',11,4}) 
AADD(_aCelulas,{'B1_ESTSEQ            ',"F",01,'N',12,2}) 
AADD(_aCelulas,{'B1_PE                ',"G",01,'N',05,0}) 
AADD(_aCelulas,{'B1_TIPE              ',"H",01,'C',01,0}) 
AADD(_aCelulas,{'B1_LE                ',"I",01,'N',14,4}) 
AADD(_aCelulas,{'B1_LM                ',"J",01,'N',14,4}) 
AADD(_aCelulas,{'B1_TOLER             ',"K",01,'N',03,0}) 
AADD(_aCelulas,{'B1_UREV              ',"L",01,'D',08,0}) 
AADD(_aCelulas,{'B1_MRP               ',"M",01,'C',01,0}) 
AADD(_aCelulas,{'B1_EMAX              ',"N",01,'N',12,2}) 
AADD(_aCelulas,{'B1_PERSEG            ',"O",01,'N',05,2}) 
AADD(_aCelulas,{'B1_INDPER            ',"P",01,'N',05,2}) 
//
// Verifica se Conseguiu efetuar a Abertura do Arquivo
If ( nHdl >= 0 )    
    //
	// Carrega o Excel e Abre o arquivo
	cBuffer := cFile + Space(512)
	nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	//
	If ( nBytes < 0 )                    
		// Erro critico na abertura do arquivo sem msg de erro
		MsgStop('Nใo foi possํvel abrir o arquivo : ' + cFile)
		Return
	ElseIf ( nBytes > 0 )                     
		// Erro critico na abertura do arquivo com msg de erro
		MsgStop(Subs(cBuffer, 1, nBytes))		
		Return
	EndIf                           
	//
	// Seleciona a worksheet
	cBuffer := "SB1"// + Space(512)
	ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)   
	
	dbSelectarea("SB1")
	SB1->(dbSetorder(1))	
	
	_nSomaLin	:= 1    
	//
	For _nElemx := 2 To 70000
		//
		//
		_cCod   := Alltrim(U_VERDADOS(nHdl,'_aCelulas',01,_nSomaLin))

		MsProcTxt("Proc.Registro: "+StrZero(_nElemx,6)+'  Codigo:'+_cCod)		
        //
		/*
		cConta    := Alltrim(StrTran(Substr(_cTexto,01,12),".",""))
		cCodRed   := Substr(_cTexto,19,05)
		cDescri   := Substr(_cTexto,28,45)
		cNatureza := Substr(_cTexto,72,01)		*/
        //
	    If Upper(Alltrim(_cCod)) == "FIM" .Or. Empty(_cCod)
	       MsgInfo("A linha "+Alltrim(Str(_nElemx))+" possue codigo em branco e impede que a atualiza็ใo continue. Favor corrigir e reiniciar a rotina!","Aten็ใo")
	       Exit
		Else
			If !Empty(_cCod)	   
				
				SB1->(dbSeek(xFilial("SB1")+ _cCod))
			    RecLock("SB1", .F.)
			    SB1->B1_DESC_EN  := Left(Alltrim(U_VERDADOS(nHdl,'_aCelulas',02,_nSomaLin)),50)
//			    SB1->B1_QE       := U_VERDADOS(nHdl,'_aCelulas',03,_nSomaLin)
			    SB1->B1_EMIN     := U_VERDADOS(nHdl,'_aCelulas',04,_nSomaLin)
			    SB1->B1_PESO     := U_VERDADOS(nHdl,'_aCelulas',05,_nSomaLin)
			    SB1->B1_ESTSEG   := U_VERDADOS(nHdl,'_aCelulas',06,_nSomaLin)
			    SB1->B1_PE       := U_VERDADOS(nHdl,'_aCelulas',07,_nSomaLin)
			    SB1->B1_TIPE     := U_VERDADOS(nHdl,'_aCelulas',08,_nSomaLin)
			    SB1->B1_LE       := U_VERDADOS(nHdl,'_aCelulas',09,_nSomaLin)
			    SB1->B1_LM       := U_VERDADOS(nHdl,'_aCelulas',10,_nSomaLin)
			    SB1->B1_TOLER    := U_VERDADOS(nHdl,'_aCelulas',11,_nSomaLin)
			    SB1->B1_UREV     := dDatabase //U_VERDADOS(nHdl,'_aCelulas',12,_nSomaLin)
			    SB1->B1_MRP      := U_VERDADOS(nHdl,'_aCelulas',13,_nSomaLin)
			    SB1->B1_EMAX     := U_VERDADOS(nHdl,'_aCelulas',14,_nSomaLin)
			    SB1->B1_PERSEG   := U_VERDADOS(nHdl,'_aCelulas',15,_nSomaLin)
			    SB1->B1_INDPER   := U_VERDADOS(nHdl,'_aCelulas',16,_nSomaLin) 
			    MsUnlock()
		    Endif
	    Endif
	    //
   		_nSomaLin++		
   		//
	Next _nElemx
	//
	// Fecha o arquivo e remove o excel da memoria
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)	
	ExecInDLLClose(nHdl)	
Else
    MsgStop('Nao foi possivel carregar a DLL')
EndIf
//      
mSGINFO("Importa็ใo de dados finalizada!")
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณJonas L. Souza JR   บ Data ณ  01/14/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao de perguntas no SX1                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ OmniLink                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VALIDPERG()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

cPerg := PADR(cPerg,len(sx1->x1_grupo))

AAdd(aHelpPor,"Diretorio ( Pasta ) que se encontra ")
AAdd(aHelpPor,"a Planilha Excel")
PutSx1(cPerg,"01","Diretorio do arquivo ","Diretorio do arquivo","Diretorio do arquivo","mv_ch1","C",30,0,0,"G","","","","","MV_PAR01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Nome do Arquivo Excel a Ser Importado")
PutSx1(cPerg,"02","Nome do Arquivo "     ,"Nome do Arquivo"     ,"Nome do Arquivo"     ,"mv_ch2","C",30,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={}
AAdd(aHelpPor,"Nome da Sheet a Ser Lida")
PutSx1(cPerg,"03","Nome da  Sheet "      ,"Nome da Sheet "      ,"Nome da Sheet "      ,"mv_ch3","C",15,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERDADOS   บAutor  ณEduardo Barbosa     บ Data ณ  22/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Conteudo de Uma celula na planilha Excel         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ZATIX                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER Function VERDADOS(_nArq,_cMatriz,_nElemento,_nSoma,_lExtrai)

Local _cRetorno	:= ''
Local _cBufferPl:= ''
Local _nBytesPl	:= 0
Local _cCelula	:=''
Local _cDescCam	:=''
Local _cColuna	:=''
Local _cLinha	:=''
Local _cTipo	:=''
Local _cTamanho	:=''
Local _cDecimal	:=''
Local _cString	:=''

If _lExtrai == Nil
   _lExtrai := .F.
Endif
_cDescCam		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",1]"
_cColuna		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",2]"
_cLinha			:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",3]"
_cTipo   		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",4]"
_cTamanho		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",5]"
_cDecimal		:=   _cMatriz+"["+Alltrim(STR(_nElemento))+",6]"

_cDescCam		:= &_cDescCam
_cColuna		:= &_cColuna
_cLinha			:= Alltrim(Str(&_cLinha+_nSoma))
_cTipo   		:= Upper(&_cTipo)
_cTamanho		:= &_cTamanho
_cDecimal		:= &_cDecimal
_cCelula		:= _cColuna+_cLinha


// Efetua Leitura da Planilha
_cBufferPl := _cCelula + Space(1024)
_nBytesPl  := ExeDLLRun2(_nArq, CMD_READCELL, @_cBufferPl)
_cRetorno  := Subs(_cBufferPl, 1, _nBytesPl)
_cRetorno  := Alltrim(_cRetorno)

// Realiza tratamento do campo  de acordo com o Tipo

If _cTipo =='N' // Numerico
   _cString	:=''
   _cNewRet :=''
   For _nElem	:= 1 To Len(_cRetorno)
       _cString := SubStr(_cRetorno,_nElem,1)
       If _cString ==','
          _cString :='.'
       Endif
       _cNewRet	:=Alltrim(_cNewRet)+_cString
   Next _nElem
   _cNewRet		:= Val(_cNewRet)
   _cRetorno    := Round(_cNewRet,_cDecimal)
Endif

If _cTipo =='D' // Data 21/01/2006
   _cRetorno 	:= Alltrim(_cRetorno)
   _cNewRet 	:= Left(_cRetorno,6)+Right(_cRetorno,2)
   _cRetorno    := CtoD(_cNewRet)
Endif

If _cTipo =='C' .AND. _lExtrai // Caracter e extra็เo de caracteres 
   _cString	:=''
   _cNewRet :=''
   For _nElem	:= 1 To Len(_cRetorno)
       _cString := SubStr(_cRetorno,_nElem,1)
       If _cString $ '#/#,#.#-'
          Loop
       Endif
       _cNewRet	:=Alltrim(_cNewRet)+_cString
   Next _nElem
   _cRetorno    := _cNewRet
Endif

// Ajusta O Tamanho da variavel

If _cTipo =='C'
   _cRetorno := Alltrim(_cRetorno)
   _cRetorno := _cRetorno+Space(_cTamanho-Len(_cRetorno))
Endif

Return _cRetorno


*---------------------------*
Static FUNCTION GravaLog() 
*---------------------------*
 Local lReturn := .T.
 Local cString:=""                          

 If !File( cFileLog  )
   fHandle:=FCREATE( cFileLog  )   
 Else
   fHandle := FOPEN( cFileLog  ,2)
 Endif 
 //
 For nX := 1 to Len(aLog)
	 cString := aLog[nX]+CHR(13)+CHR(10)
	 FSEEK(fHandle,0,2)
	 FWRITE(fHandle,cString)
 Next	                 
 
 FCLOSE(fHandle)
 WinExec("C:\windows\notepad.exe "+ cFileLog)
 
Return(lReturn)
