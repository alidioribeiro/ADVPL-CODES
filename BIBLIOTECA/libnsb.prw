#INCLUDE 'rwmake.ch' 
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'ap5mail.ch' 
#INCLUDE 'fivewin.ch'
#INCLUDE 'tbiconn.ch' 

//Gera sequencia de indice da tabela
/**********************************************************************************/
static Function GeraSeq (Alias,Campo)
Local Seq:=1,AuxS

cQuery:=" select max("+Campo+") as SEQ from "+RetSqlName(ALIAS)+" 
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias TMP New 
DbSelectArea("TMP")
DbGotop()
If !Eof()
	Seq:=Val(TMP->SEQ)+1
EndIf    
NumSeq:=StrZero(Seq,6)
DbSelectArea("TMP")
DbCloseArea()

Return NumSeq   

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Validar aprovador                                                       ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/ 


Static function ValAprova(cAprov,nPosicao) 
Local cPermitir
Local IRel := .T.
Local nTam :=0

cPermitir := alltrim(Posicione("ZZS",2,cAprov,"ZZS_ACESSO")) 
nTam:= len(cPermitir)
     
 if subStr(cPermitir,nPosicao,1)!="S"
 IRel :=.F.
 EndIF
 
return(IRel)

//**************************************************/
static function CCDeResp(cAprov,nPosicao) 
Local cPermitir
Local IRel := .T.
Local nTam :=0
Local CCResp:={}

DbSelectArea("ZZS")
DbSetOrder(2)
If DbSeek(cAprov)
	While !Eof()
		If Alltrim(ZZS->ZZS_USER)==Alltrim(cAprov)
		   If Subst(ZZS->ZZS_ACESSO,4,1)='S'
		    	aadd(ccResp,ZZS->ZZS_CCUSTO)
		   Endif
		EndIf 
	EndDO 
EndIf 


return(ccResp)

//***************************************************/
//**************************************************/
static function EmailCC(cAprov,nPosicao) 
Local cPermitir
Local IRel := .T.
Local nTam :=0
Local CCResp:={}

DbSelectArea("ZZS")
DbSetOrder(2)
If DbSeek(cAprov)
	While !Eof()
		If Alltrim(ZZS->ZZS_USER)==Alltrim(cAprov)
		   If Subst(ZZS->ZZS_ACESSO,4,1)='S'
		    	aadd(ccResp,ZZS->ZZS_CCUSTO)
		   Endif
		EndIf 
	EndDO 
EndIf 


return(ccResp)

/***************************************************/

/***************************************************/

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Consultas dados do Funcionário                                          ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/


static function FunPesq(cMatricula)    
Local lRet :=.T. 
LOCAL aFunc :={}
LOCAL cNome   
LOCAL cMat  
LOCAL cCusto
LOCAL cDescCusto    
LOCAL cImg        
LOCAL cIdTurno 
LOCAL cTurno       
LOCAL nSaiAlm      
LOCAL nEntraAlm
LOCAL nHrEntAl  
LOCAL nHrSaiAl  
 
//LOCAL cMatricula :=  str(strZero(val(cMatricula),6))

if Alltrim(cMatricula) <> ''
if len(Alltrim(cMatricula)) == 1
    cMatricula := "00000"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 2
    cMatricula := "0000"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 3
    cMatricula := "000"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 4
    cMatricula := "00"+cMatricula
    ElseIF len(Alltrim(cMatricula)) == 5
    cMatricula := "0"+cMatricula
EndIF
 



	DbSelectArea("SRA")
	DbSetOrder(1)     
    DbGotop()
    	If DbSeek(xFilial("SRA") + cMatricula)
    		cNome       := SRA->RA_NOME 
		    cMat        := SRA->RA_MAT  
		    cCusto      := SRA->RA_CC
		    cImg        := SRA->RA_BITMAP  
		    cIdTurno   := SRA->RA_TNOTRAB
		    cTurno     := alltrim(Posicione("SR6",1,xFilial("SR6") + cIdTurno,"R6_DESC"))    
		    nSaiAlm    := Posicione("SPJ",1,xFilial("SPJ") + cIdTurno,"PJ_SAIDA1")    
            nEntraAlm  :=Posicione("SPJ",1,xFilial("SPJ") + cIdTurno,"PJ_ENTRA2")
            nHrEntAl   :=nEntraAlm 
            nHrSaiAl   := nSaiAlm 
            cDescCusto := alltrim(Posicione("CTT",1,xFilial("CTT") + cCusto,"CTT_DESC01"))            		               		      
        Endif     
          
		if empty(SRA->RA_MAT)     
    		cQuery := " SELECT RA_NOME,RA_CC,RA_DEMISSA,RA_MAT,RA_TNOTRAB,RA_BITMAP FROM SRA020 WHERE D_E_L_E_T_='' AND  RA_MAT = '" +cMatricula+ "'
    		Query := ChangeQuery(cQuery)
    		TCQUERY cQuery Alias TRA New 
    	dbSelectArea("TRA")
            cNome       := TRA->RA_NOME 
		    cMat        := TRA->RA_MAT  
		    cCusto      := TRA->RA_CC
		    cImg        := TRA->RA_BITMAP   
		    cIdTurno   := TRA->RA_TNOTRAB
		    cTurno     := alltrim(Posicione("SR6",1,xFilial("020") + cIdTurno,"R6_DESC"))
		    nSaiAlm    := Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_SAIDA1")    
            nEntraAlm  :=Posicione("SPJ",1,xFilial("020") + cIdTurno,"PJ_ENTRA2")
            nHrEntAl   :=nEntraAlm 
            nHrSaiAl   := nSaiAlm
            cDescCusto := alltrim(Posicione("CTT",1,xFilial("CTT") + cCusto,"CTT_DESC01"))       
		EndIF
EndIF            
If empty(cMat) .And. empty(cNome)
   lRet := .F.
EndIF         

aadd(aFunc,{lRet,cMat,cNome,cCusto,cDescCusto,cIdTurno,cTurno,nHrEntAl,nHrSaiAl,nEntraAlm,nSaiAlm,cImg})
               
dbCloseArea("SRA")                
dbCloseArea("TRA") 


Return(aFunc)  

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Consultas dados do produto  SB1010                                      ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
STATIC FUNCTION PESQPROD(cCodigo)
    
    Local cDescMat
    Local cMarca
    Local aDados := {}
    Local bAchou := .T.
    
	cQuery  	:= "SELECT * FROM SB1010 WHERE B1_COD ='"+AllTrim(cCodigo)+"'"
	Query   	:= ChangeQuery(cQuery)
	TCQUERY cQuery Alias TRA New  			
	dbSelectArea("TRA")  
	cDescMat   := TRA->B1_DESC
	cMarca     := TRA->B1_MODELO 	
    dbCloseArea("TRA")

    IF Empty(cDescMat)
    	bAchou := .F.
    Else
        bAchou := .T.
    EndIF
    AADD(aDados,{bAchou,cDescMat,cMarca})
RETURN(aDados)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Calcular Horas de atividades                                            ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± para Calcular e preciso informar por parametro Data inicio, data fim,hora inicio,hora fim e horas de trabalho do colaborador
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Static function calcAtv(dtIni,dtFim,nHrIni,nHrFim,nHrTraIni,nHrTraFim)
    Local nTT:=0
    Local nDias:=0
    
    nDias:= val( TransForm(dtFim-dtIni,'@R 9999'))
    
    MsgAlert(nDias)

	If nDias > 0
	   //nTT +=SubHoras(nHrIni,nHrTraFim)
	   
	   For I:=1 To nDias
	      If I == nDias
	      nTT +=SubHoras(nHrFim,nHrTraIni) 
	      ElseIF I==1
	      nTT +=SubHoras(nHrTraFim,nHrIni)
	      
	      ELSEIf DiaUtil(dtIni)
	         MsgAlert(dtIni)
	         nTT +=SubHoras(nHrTraFim,nHrTraIni)-1
	      EndIF
	      dtIni++
	   Next I
	   
	ElseIf nDias < 0
		MsgInfo("Informe a data corretamente! ","Atenção")
  
	Else
	   nTT +=SubHoras (nHrIni,nHrFim)
	EndIf
return(nTT)

/*************************************************************/
//Calcular os dias Util
/*************************************************************/
Static Function DiaUtil(DataHe) 
lRet:=.T.
AuxD:=Dtos(DataHe)       
Ano:=Substr(Dtos(DataHe),1,4)
Mes:=Substr(Dtos(DataHe),5,2)
DbSelectArea("RCG")
DbSetOrder(1)
if DbSeek(xFilial("RCG")+Ano+Mes)
	While !Eof()
        If Dtos(RCG->RCG_DIAMES)=AuxD
        	If RCG->RCG_TIPDIA $ '234' //NÃO TRABALHADO2 /DSR 3 OU FERIADO  4
				lRet:=.F.
        	EndIf
        	Exit 
        EndIf
		DbSelectArea("RCG")
		DbSkip()
	EndDo
EndIf
Return lRet

static function xUsrDados(cIdUser,nPosicao)
	_NomeRetorno := ""
	// Defino a ordem
	PswOrder(1) // Ordem de ID
     
	// Efetuo a pesquisa, definindo se pesquiso usuário ou grupo
	If PswSeek(cIdUser,.T.)

  		// Obtenho o resultado conforme vetor
   		_aRetUser := PswRet(1)
   	
  		_NomeRetorno:= upper(alltrim(_aRetUser[1,nPosicao]))
	    
    EndIf	



return(_NomeRetorno) 
