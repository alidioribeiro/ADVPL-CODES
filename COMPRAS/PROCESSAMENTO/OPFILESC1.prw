#include "PROTHEUS.CH"   
#include "TOTVS.CH"
#include "shell.ch"

User Function OPFILESC1()  
Private cComando :=""
Private cNum  := CA110NUM                  
Private aCol  := ACOLS
Private cItem := ACOLS[n,1]                        
Private cDir       := Alltrim(Getmv('MV_PATHSC1'))
Private cMask      := "Arquivos PDF (*.PDF) | *.PDF"
Private cDirectory := ""
Private cFile      := ""
Private cFileDest  := ""                             
Private lVisualiza := .T.
Private aFile      := {}
Private aDirectory := {}
cPar       := ""
IF Empty(cDir)
   Alert("Informar ao TI o Caminho padrao para as imagens/PDF para o PARAMETRO -> MV_PATHSC1")
   lVisualiza := .F.
ENDIF            
//cFile      := aCols[n][40] // Diretorio do Anexo
cFile      := aCols[n,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C1_ANEXO" })		] // Diretorio do Anexo
cFile      := Alltrim(cGetFile('Arquivo *|*.*|Arquivo |*.*','Selecione arquivo',0,'C:\',.T.,,.F.))
cExt       := Substring(cFile   ,AT(".",cFile)+1,Len(cFile) - AT(".",cFile))
aDirectory := Directory(cFile,"D")  
cNameFile  := RetFileName(cFile)+"."+cExt //aDirectory[1,1]
cNameFileDest  := cNum+'-'+cItem+"."+cExt
cFileDest  := "T:\"+cNameFileDest

aCols[n,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C1_ANEXO" })] := cFile //40
aCols[n,ASCAN(aHeader, {|x| Alltrim(x[2]) == "C1_XANEXO" })] := cNameFileDest //41

WinExec("NET USE T: \\NSBSRV07\PROJETOS\ANEXOSC")
__CopyFile( cFile, cFileDest )
WinExec("NET USE T: /D") 
If !File(cFileDest)
   Alert("Avisar Ti que o servidor de Anexos (\\NSBSRV07\PROJETOS\ANEXOSC) não está disponível!")
Endif   
Return .T.         
