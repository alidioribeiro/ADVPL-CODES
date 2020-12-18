#include "rwmake.ch"        // inclcSaldoHEuido  asistente de conversao do AP5 IDE em 21/02/02
#Include "TOPCONN.CH" 
#include "ap5mail.ch"
#Include "TBICONN.CH"


User Function BloqHE()
 
Local TotHEAut,HoraIniE,HoraFimE
Local HEPend:={}

Prepare Environment Empresa "01" Filial "01" Tables "SPC,SP8"  // Usado apenas quando o uso for por agendamento

//--Relação de Hextras não autorizadas
cQuery:=" select * from SPC010,SRA010 WHERE PC_PD IN('111','115','116','121','283')  "
cQuery+=" and RA_MAT=PC_MAT "        
cquery+=" and RA_FILIAL=PC_FILIAL "
cQuery+=" and SRA010.D_E_L_E_T_=''   "
cQuery+=" and SPC010.D_E_L_E_T_=''   "
//cquery+=" and RA_MAT='000295' "
cQuery+=" AND PC_PDI='' and (PC_USUARIO='AP.AUT' or  PC_USUARIO='')  "
cQuery+=" AND PC_MAT+PC_DATA NOT IN (SELECT ZP_MAT+ZP_DATA FROM SZP010 WHERE D_E_L_E_T_='' AND ZP_DTAPROV<>'')  "
//cQuery+=" AND PC_MAT='000450'  "
TCQUERY cQuery Alias TRA New 

//Bloqueia todas as horas extras não aprovadas no módulo de Horas-Extras
DbSelectArea("TRA")
DbGotop()
While !Eof()      
	DbSelectArea("SPC")
    DbSetOrder(2)   
    If DbSeek(xFilial("SPC")+TRA->PC_MAT+TRA->PC_DATA+TRA->PC_PD)
	   If Empty(SPC->PC_PDI) .or. SPC->PC_USUARIO ="AP.AUT"
		    RecLock('SPC',.F.)     	
		    SPC->PC_PDI:=GerCodBl(SPC->PC_PD)
		    SPC->PC_QUANTI:=SPC->PC_QUANTC     
		    SPC->PC_USUARIO:="AP.AUT"
		    MsUnlock()
            //Preenche o vetor para o envio das divergências para o gestor 
            Pos:=ascan(HEPEND, {|x| x[2] ==SPC->PC_MAT .and. x[4] ==Dtoc(SPC->PC_DATA) }) 
            IF Pos>0 
            	HEPEND[Pos][6]=somahoras(HEPEND[Pos][6],SPC->PC_QUANTC)
            	HEPEND[Pos][7]=somahoras(HEPEND[Pos][7],SPC->PC_QUANTC)
            Else
                Nome:=Posicione("SRA",1,xFilial("SRA")+SPC->PC_MAT,"RA_NOME")
				aadd(HEPend,{TRA->RA_CC,SPC->PC_MAT,Nome,Dtoc(SPC->PC_DATA),0,SPC->PC_QUANTC,SPC->PC_QUANTC})            
            EndIf 
	   EndIf 
    EndIf 
    //PC_FILIAL, PC_MAT, PC_DATA, PC_PD, PC_TPMARCA, PC_CC, PC_DEPTO, PC_POSTO, PC_CODFUNC, R_E_C_N_O_, D_E_L_E_T_
	DbSelectArea("TRA")
	DbSkip()
EndDo 

DbSelectArea("TRA")
DbCloseArea()
//Verifica as datas dos apontamentos 
cQuery:=" select * from SZP010,SRA010 "
cQuery+=" WHERE "  
//cQuery+=" ZP_MAT='000450' AND "
//cquery+=" ZP_MAT='000906' and ZP_DATA IN('20120324') AND "
//,'20120331') AND "
cQuery+=" ZP_DTAPROV<>''  AND " 
cquery+=" ZP_MAT=RA_MAT AND "
cQuery+=" SRA010.D_E_L_E_T_='' and "
//para teste
//cquery+=" RA_MAT='000295'  and " // ZP_DATA IN('20120331') and "
cQuery+=" SZP010.D_E_L_E_T_='' AND ZP_DATA >= "
cQuery+=" ( "
cQuery+=" select MIN(PC_DATA) from SPC010  "
cQuery+=" WHERE PC_PD IN('111','115','116','121','283')  and D_E_L_E_T_='' "
//PARA TESTE
//cQuery+=" AND PC_MAT='000295' "
cQuery+=" ) order by ZP_DATA,ZP_MAT "
TCQUERY cQuery Alias TSZ New 
DbSelectArea("TSZ")
DbGotop()
While !Eof()
	Chave:=TSZ->ZP_DATA+TSZ->ZP_MAT
	HoraIniE:=0
	HoraFimE:=0        
	TotHEAut:=0
    While !eof() .and. Chave==TSZ->ZP_DATA+TSZ->ZP_MAT //V368erifica se os horas são do mesmo dia
    	HoraFimE:=TSZ->ZP_HORA
   		HoraIniE:=somahoras(HoraIniE,HoraFimE)
    	ChaveSpc:=xFilial("SPC")+TSZ->ZP_MAT+TSZ->ZP_DATA
    	DbSelectArea("TSZ")
   		DbSkip()                             
    EndDo 
    TotHEAut:=somahoras(HoraIniE,0.3)
    
     // Total de Horas Autorizadas + 30 minutos de tolerancia 
    TotEfAnt:=0
  	HoraIniE:=0
	HoraFime:=0                        
	HoraBlq:=0
    TotHoraBlq:=0
    DbSelectArea("SPC")
    DbSetOrder(2)       
    DbSeek(ChaveSPC)    
//    lAtu:=.F.
    While !Eof() .and. ChaveSPC==xFilial("SPC")+SPC->PC_MAT+DTos(SPC->PC_DATA)
		If SPC->PC_PD $ "111,115,116,121,283"         
	    	HoraFimE:=SPC->PC_QUANTC                  //Calcula  as horas efetivas realizadas
	    	HoraIniE:=somahoras(HoraIniE,HoraFimE)
	    	If HoraIniE>TotHEAut  .and. TotEfAnt>TotHEAut // Tolerancia de 15 minutos 
			    If Empty(SPC-> PC_PDI)
			        HoraBlq:=SPC->PC_QUANTC 
		    	EndIf 
    		Else 
    			If HoraIniE>TotHeAut .and. TotEfAnt< TotHEAut
                    //SubHoras (nHr1,nHr2) 
     	//			HoraBlq:=subhoras(HoraIniE,TotHEAutu)
   	    			HoraBlq:=subhoras(HoraIniE,TotHEAut)
    			EndIf
	    	
	    	End
            If (HoraBlq>0 .OR. HoraBlq=0)  .and. ( Empty(SPC->PC_PDI) .OR. SPC->PC_USUARIO="AP.AUT"  )
			    RecLock('SPC',.F.)     	
			    SPC->PC_PDI:=GerCodBl("")
			    SPC->PC_QUANTI:=HoraBlq    
		    	SPC->PC_USUARIO:="AP.AUT"
			    MsUnlock()                                               
			    //Caso existisse um bloqueio inicial como não autorizado. 
//            ElseIf HoraBlq=0 .and. SPC->PC_PDI$'060,064,065,062,063,283'  .and. SPC->PC_USUARIO="AP.AUT"  
//			    RecLock('SPC',.F.)     	
//			    SPC->PC_PDI:=""
//			    SPC->PC_QUANTI:=0
//		    	SPC->PC_USUARIO:="AP.AUT"
//			    MsUnlock()
            EndIF 
            TotEfAnt:=HoraIniE
            if HoraBlq > 0
	            Pos:=ascan(HEPEND, {|x| x[2] ==SPC->PC_MAT .and. x[4] ==Dtoc(SPC->PC_DATA) }) 
		        IF Pos>0 
           	    	HEPEND[Pos][6]=HoraIniE
        	    	HEPEND[Pos][7]=somahoras(HEPEND[Pos][7],HoraBlq)
            	Else 
   	                Nome:=Posicione("SRA",1,xFilial("SRA")+SPC->PC_MAT,"RA_NOME")                                                                                    
    	        	CC:=Posicione("SRA",1,xFilial("SRA")+SPC->PC_MAT,"RA_CC")                                                                                    
					aadd(HEPend,{CC,SPC->PC_MAT,Nome,Dtoc(SPC->PC_DATA),TotHEAut,HoraIniE,HoraBlq})            
	            EndIf 
            EndIF 
	  	EndIF 
	  	
    	DbSelectArea("SPC") 
    	DbSkip()
    EndDo
	DbSelectArea("TSZ")
	//DbSkip()             
EndDo                   
If len(HEPend)>0
 	HEPend(HEPend)
EndIf  
DbSelectArea("TSZ")
DbCloseArea()

Return 
///****************************************************************//
/*Função:Função que gera o código de bloqueio                      */
/******************************************************************/
Static Function GerCodBl(CodPc)
Local CodBlQ:=""
Do Case 
Case CodPC="111"
 	CodBlq:="060"
Case CodPC="115"
 	CodBlq:="064"
Case CodPC="116"
 	CodBlq:="065"	
Case CodPC="121"
 	CodBlq:="062"	
Case CodPC="123"
 	CodBlq:="063"	
Case CodPC="283"
 	CodBlq:="283"	
EndCase  

Return CodBlq

///****************************************************************//
Static Function HEPend(HEPend)
    oProcess := TWFProcess():New( "000001", "Bloqueio de Hora-Extra" )
    oProcess :NewTask( "100001", "\WORKFLOW\bloqextra.HTML" )
    oProcess :cSubject := "WFE28 - Horas-Extras Bloqueadas"
    oHTML    := oProcess:oHTML 

   	oHtml:ValByName("it.cc"	, {})
	oHtml:ValByName("it.mat"	, {})
	oHtml:ValByName("it.nome"	, {})
	oHtml:ValByName("it.data"	, {})
	oHtml:ValByName("it.horasatu" 	, {})
	oHtml:ValByName("it.horasrea" 	, {})
	oHtml:ValByName("it.horasblo"	, {})

    CColor:=""

    For x:= 1 to Len(HEPend)

//      if Val(aEnvia[x][15])>0
//		Ccolor=' color="FF0000" '	      
//      Endif 
//		Prod:=aEnvia[x][1]
  		aadd(oHtml:ValByName("it.cc"		) 	 , HEPend[x][1])
		aadd(oHtml:ValByName("it.mat"	  	) 	 , HEPend[x][2])
		aadd(oHtml:ValByName("it.nome"		) 	 , HEPend[x][3])
		aadd(oHtml:ValByName("it.data"		)  	 , HEPend[x][4])
		aadd(oHtml:ValByName("it.horasatu"	)  	 ,Transform(StrTran(StrZero(HEPend[x][5],5,2),".",""),"@R !!:!!" ) )
		aadd(oHtml:ValByName("it.horasrea"	) 	 ,Transform(StrTran(StrZero(HEPend[x][6],5,2),".",""),"@R !!:!!" ) )
		aadd(oHtml:ValByName("it.horasblo"	) 	 ,Transform(StrTran(StrZero(HEPend[x][7],5,2),".",""),"@R !!:!!" ) )
	Next

	Mto:="railma@nippon-seikibr.com.br;kaira.lima@nippon-seikibr.com.br"
    oProcess:cTo  := Mto
 //   oProcess:cTo := "jmoreira@nippon-seikibr.com.br" // Com Copia Oculta
    //oProcess:ATTACHFILE(cArq) - ANEXA UM ARQUIVO <CAMINHO + NOME DO ARQUIVO>
    cMailId := oProcess:Start()


Return 
///****************************************************************//
