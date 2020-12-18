#include 'protheus.ch'
#include 'parmtype.ch'

/*/
зддддддддддбддддддддддбдддддбдддддддддддддддддддддддддбддддддбдддддддддд©
ЁPrograma  ЁU_NEWUSER ЁAutorЁMarinaldo de Jesus       Ё Data Ё25/11/2008Ё
цддддддддддеддддддддддадддддадддддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁExemplo de inclusao de usuarios atraves de User Function    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                    Ё
цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
Ё            ATUALIZACOES SOFRIDAS DESDE A CONSTRU─AO INICIAL           Ё
цддддддддддддбддддддддддбдддддддддддбддддддддддддддддддддддддддддддддддд╢
ЁProgramador ЁData      ЁNro. Ocorr.ЁMotivo da Alteracao                Ё
цддддддддддддеддддддддддедддддддддддеддддддддддддддддддддддддддддддддддд╢
Ё            Ё          Ё           Ё                                   Ё
юддддддддддддаддддддддддадддддддддддаддддддддддддддддддддддддддддддддддды
/*/

//user function NSCFGR01()


#DEFINE ID_USER_ADMINISTRATOR		"000000"

#DEFINE APSWDET_USER_ID				aPswDet[01][01]
#DEFINE APSWDET_USER_NAME			aPswDet[01][02]
#DEFINE APSWDET_USER_PWD			aPswDet[01][03]
#DEFINE APSWDET_USER_FULL_NAME	aPswDet[01][04]
//...
#DEFINE APSWDET_USER_GROUPS		aPswDet[01][10]
//...
#DEFINE APSWDET_USER_DEPARTMENT	aPswDet[01][12]
#DEFINE APSWDET_USER_JOB			aPswDet[01][13]
#DEFINE APSWDET_USER_MAIL			aPswDet[01][14]
//...
#DEFINE APSWDET_USER_STAFF			aPswDet[01][22]
//...
#DEFINE APSWDET_USER_DIR_PRINTER	aPswDet[02][03]
//...
#DEFINE APSWDET_USER_MENUS			aPswDet[03]
//...
User Function NSCFGR01

	Local oDlgLocal, oSay1
	Local oComboLocal, cCombo
	Local aRet := AllUsers()
	Local nI
	Local aUsers := {}
	
	For nI := 1 to Len(aRet)	
		Aadd(aUsers, aRet[nI][1][2])
	Next

	DEFINE MSDIALOG oDlg TITLE "Teste" From 000,0 TO 100,300 PIXEL
	@ 12, 05 SAY oSay1 VAR "UsuАrios: " OF oDlg PIXEL                                                                           
	@ 12, 30 COMBOBOX oCombo VAR cCombo ITEMS aUsers SIZE 100, 009 OF oDlg PIXEL
	@ 25, 80 BUTTON "Fechar" PIXEL SIZE 40,12 OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED
Return
/*
User Function AddNewUser()

Local aPswDet

//Defino a Tabela de Senhas
Local cPswFile	:= "sigapss.spf"
Local cPswId	:= ""
Local cPswName 	:= ""
Local cPswPwd	:= ""
Local cPswDet 	:= ""

Local cOldPsw
Local cNewPsw

Local lEncrypt	:= .F.

Local nPswRec

//Obtenho o usuario Base
Local cUsrId	:= GetNextUsr( ID_USER_ADMINISTRATOR , "999999" , .F. ) 

IF Type( "cEmpAnt" ) <> "C"
Private cEmpAnt := "01"
EndIF
IF Type( "cFilAnt" ) <> "C"
Private cFilAnt := "01"
EndIF

//Abro a Tabela de Senhas
spf_CanOpen(cPswFile) 

//Procuro pelo usuario Base
nPswRec 					:= spf_Seek( cPswFile , "1U"+cUsrId , 1 ) 

//Obtenho as Informacoes do usuario Base ( retornadas por referencia na variavel cPswDet)
spf_GetFields( @cPswFile , @nPswRec , @cPswId , @cPswName , @cPswPwd , @cPswDet )

//Converto o conteudo da string cPswDet em um Array
aPswDet 					:= Str2Array( @cPswDet , @lEncrypt )

//Atribuindo o Novo user ID
APSWDET_USER_ID				:= GetNextUsr( NIL , "999999" , .T. )
//Atribuindo o Nome do novo usuario
APSWDET_USER_NAME			:= "Usuario."+APSWDET_USER_ID
//Decriptando a senha antiga para obter o tamanho valido para a senha
cOldPsw						:= PswEncript( APSWDET_USER_PWD , 1 )
//Encriptando a senha para o novo usuario
cNewPsw	 					:= PswEncript( Padr( APSWDET_USER_ID , Len( cOldPsw ) ) , 0 )
//Atribuindo a nova senha ao novo usuario
APSWDET_USER_PWD			:= cNewPsw
//Atribuindo o nome completo ao novo usuario
APSWDET_USER_FULL_NAME		:= "Nome.Completo."+APSWDET_USER_NAME
//Atribuindo o Departamento ao novo usuario
APSWDET_USER_DEPARTMENT		:= "Departamento."+APSWDET_USER_NAME
//Atribuindo o cargo ao novo usuario
APSWDET_USER_JOB			:= "Cargo."+APSWDET_USER_NAME
//Atribuindo o email ao novo usuario
APSWDET_USER_MAIL			:= APSWDET_USER_NAME+"@email.com"
//Atribuindo o vinculo funcional ao novo usuario
APSWDET_USER_STAFF			:= cEmpAnt+cFilAnt+APSWDET_USER_ID
//Atribuindo o diretorio de impressao ao novo usuario
APSWDET_USER_DIR_PRINTER    := "\SPOOL\"+APSWDET_USER_NAME

//Convertendo as informacoes no novo usuario para gravacao
cPswDet						:= Array2Str( @aPswDet , @lEncrypt )

//Incluindo o novo usuario
spf_Insert( cPswFile , "1U"+APSWDET_USER_ID , Upper("1U"+APSWDET_USER_NAME) , "1U"+APSWDET_USER_PWD , cPswDet )

Return( NIL )
//
//
//
Static Function GetNextUsr( cUser , cMaxUser , lNewUser )

Local aAllUsers 

Local bPswSeek

Static __cMaxUser

PswOrder(1)

IF (;
(;
Empty( __cMaxUser );
.and.;
Empty( cMaxUser );
);
.or.;
Empty( cUser );
)	
IF ( Select( "SX6" ) > 0 )
aAllUsers	:= AllUsers()
__cMaxUser	:= aAllUsers[ Len( aAllUsers ) , 1 , 1 ]
IF ( lNewUser )
cUser	:= __cMaxUser
EndIF
aAllUsers	:= NIL
EndIF	
EndIF

DEFAULT cUser		:= ID_USER_ADMINISTRATOR
DEFAULT cMaxUser	:= __cMaxUser
DEFAULT lNewUser	:= .F.

cUser				:= Soma1( cUser )

IF ( lNewUser )                       
bPswSeek 		:= { || PswSeek( @cUser ) }
Else
bPswSeek 		:= { || !PswSeek( @cUser ) }
EndIF	 

While ( Eval( bPswSeek ) )
cUser := Soma1( cUser )
IF (;
!( lNewUser );
.and.;
( cUser > cMaxUser );
)	
cUser := Space( 6 )
Exit
EndIF
End While

IF ( lNewUser )
__cMaxUser		:= cUser
EndIF	

Return( cUser )
return
*/