#include "rwmake.ch"  
#include "TRM010.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao 					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³	   ³ 										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Trm010()        

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,AORD,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND,COLUNAS")
SetPrvt("TITULO,AT_PRG,WCABEC0,WCABEC1,CONTFL,LI")
SetPrvt("NPAG,NTAMANHO,CTIT,WNREL,NORDEM,CFILDE")
SetPrvt("CFILATE,CMATDE,CMATATE,CNOMDE,CNOMEDE,CNOMATE")
SetPrvt("CNOMEATE,CCALDE,CCALATE,CCURDE,CCURATE,CTURDE")
SetPrvt("CTURATE,CGRUDE,CGRUATE,CDEPDE,CDEPATE,CCARDE")
SetPrvt("CCARATE,CSITCUR,NVIAS,CARQDBF,AFIELDS,CINDCOND")
SetPrvt("CARQNTX,CFIL,CINICIO,CFIM,NIMPRVIAS,DET")
SetPrvt("CRESERVA,CCALEND,CCURSO,CTURMA,CFIL1")
SetPrvt("CGRUPO,CDEPTO,CCARGO")
SetPrvt("CACESSARA3")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TRM010   ³ Autor ³ Equipe RH		        ³ Data ³ 16/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Lista de Prsenca.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TRM010	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RdMake	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
cDesc1  := STR0001 //"Lista de Presença"
cDesc2  := STR0002 //"Será impresso de acordo com os parametros solicitados pelo"
cDesc3  := STR0003 //"usuário."
cString := "RA3"   //-- alias do arquivo principal (Base)
aOrd    := { STR0004,STR0005 } //"Nome"###"Matricula"

//+--------------------------------------------------------------+
//¦ Define Variaveis (Basicas)                                   ¦
//+--------------------------------------------------------------+
aReturn  := { STR0006,1,STR0007,2,2,1,"",1 } //"Zebrado"###"Administraçäo"
NomeProg := "TRM010"
aLinha   := {}
nLastKey := 0
cPerg    := "TRR030"
lEnd     := .F.
lImp	 := .F.

//+--------------------------------------------------------------+
//¦ Define Variaveis (Programa)                                  ¦
//+--------------------------------------------------------------+
Colunas  := 132
Titulo   := STR0011 //"LISTA DE PRESENCA"
AT_PRG   := "TRM010"
wCabec0  := 1
wCabec1  := ""
Contfl   := 1
Li       := 0
nPag     := 0
nTamanho := "M"

cTit     := STR0011 //"LISTA DE PRESENCA"

//+--------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas                           ¦
//+--------------------------------------------------------------+
pergunte("TRR030",.F.)

//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01        //  Filial  De                               ¦
//¦ mv_par02        //  Filial  Ate                              ¦
//¦ mv_par03        //  Matricula De                             ¦
//¦ mv_par04        //  Matricula Ate                            ¦
//¦ mv_par05        //  Nome De                                  ¦
//¦ mv_par06        //  Nome Ate                                 ¦
//¦ mv_par07        //  Calendario De                            ¦
//¦ mv_par08        //  Calendario Ate                           ¦
//¦ mv_par09        //  Curso De                                 ¦
//¦ mv_par10        //  Curso Ate                                ¦
//¦ mv_par11        //  Turma De                                 ¦
//¦ mv_par12        //  Turma Ate                                ¦
//¦ mv_par13        //  Grupo De                                 ¦
//¦ mv_par14        //  Grupo Ate                                ¦
//¦ mv_par15        //  Departamento De                          ¦
//¦ mv_par16        //  Departamento Ate                         ¦
//¦ mv_par17        //  Cargo De                                 ¦
//¦ mv_par18        //  Cargo Ate                                ¦
//¦ mv_par19        //  Situacao                                 ¦
//¦ mv_par20        //  Numeros de Vias                          ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+
WnRel :="TRM010"  //-- Nome Default do relatorio em Disco.
WnRel :=SetPrint(cString,WnRel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Relato()},cTit)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Relato   ³ Autor ³  Equipe RH        	³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina Principal do Relatorio.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Relato()	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Rdmake	                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Relato()

nOrdem  	:= aReturn[8]
cAcessaRA3	:= &("{ || " + ChkRH("TRM010","RA3","2") + "}")

//+--------------------------------------------------------------+
//¦ Carregando variaveis mv_par?? para Variaveis do Sistema.     ¦
//+--------------------------------------------------------------+
If(!Empty(mv_par01),cFilDe :=mv_par01,cFilDe  :="  ")
If(!Empty(mv_par02),cFilAte:=mv_par02,cFilAte :="99")
If(!Empty(mv_par03),cMatDe :=mv_par03,cMatDe  :="      ")
If(!Empty(mv_par04),cMatAte:=mv_par04,cMatAte :="999999")
If(!Empty(mv_par05),cNomDe :=mv_par05,cNomeDe :="                              ")
If(!Empty(mv_par06),cNomAte:=mv_par06,cNomeAte:="ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ")
If(!Empty(mv_par07),cCalDe :=mv_par07,cCalDe :="   ")
If(!Empty(mv_par08),cCalAte:=mv_par08,cCalAte:="999")
If(!Empty(mv_par09),cCurDe :=mv_par09,cCurDe :="    ")
If(!Empty(mv_par10),cCurAte:=mv_par10,cCurAte:="9999")
If(!Empty(mv_par11),cTurDe :=mv_par11,cTurDe :="   ")
If(!Empty(mv_par12),cTurAte:=mv_par12,cTurAte:="999")
If(!Empty(mv_par13),cGruDe :=mv_par13,cGruDe :="  ")
If(!Empty(mv_par14),cGruAte:=mv_par14,cGruAte:="99")
If(!Empty(mv_par15),cDepDe :=mv_par15,cDepDe :="   ")
If(!Empty(mv_par16),cDepAte:=mv_par16,cDepAte:="9999")
If(!Empty(mv_par17),cCarDe :=mv_par17,cCarDe :="     ")
If(!Empty(mv_par18),cCarAte:=mv_par18,cCarAte:="99999")
If(!Empty(mv_par19),cSitCur:=mv_par19,cSitCur:="LRS")
If(!Empty(mv_par20),nVias  :=mv_par20,nVias  :=1)

//+--------------------------------------------------------------+
//¦ Criando Arquivo Temporario pela ordem selecionada            ¦
//+--------------------------------------------------------------+
cArqDBF	:= CriaTrab(NIL,.f.)
aFields	:= {}
AADD(aFields,{"TR_FILIAL" ,"C",02,0})
AADD(aFields,{"TR_CC"     ,"C",09,0})
AADD(aFields,{"TR_MAT"    ,"C",06,0})
AADD(aFields,{"TR_NOME"   ,"C",30,0})
AADD(aFields,{"TR_CALEND" ,"C",04,0})
AADD(aFields,{"TR_CURSO" ,"C",04,0})
AADD(aFields,{"TR_TURMA" ,"C",03,0})
AADD(aFields,{"TR_SITCUR" ,"C",1,0})
AADD(aFields,{"TR_GRUPO"  ,"C",2,0})
AADD(aFields,{"TR_NOMEG"  ,"C",15,0})
AADD(aFields,{"TR_DEPTO"  ,"C",3,0})
AADD(aFields,{"TR_NOMED"  ,"C",20,0})
AADD(aFields,{"TR_CARGO"  ,"C",6,0})
AADD(aFields,{"TR_NOMEC"  ,"C",30,0})

DbCreate(cArqDbf,aFields)
DbUseArea(.T.,,cArqDbf,"TRA",.F.)
If nOrdem == 1
	cIndCond := "TRA->TR_CALEND+TRA->TR_CURSO + TRA->TR_TURMA + TRA->TR_FILIAL + TRA->TR_NOME + TRA->TR_MAT"
ElseIf nOrdem == 2
	cIndCond := "TRA->TR_CALEND+TRA->TR_CURSO + TRA->TR_TURMA + TRA->TR_FILIAL + TRA->TR_MAT"
EndIf

cArqNtx  := CriaTrab(NIL,.f.)
IndRegua("TRA",cArqNtx,cIndCond,,,STR0012) //"Selecionando Registros..."
dbGoTop()

dbSelectArea( "RA3" )
dbSetOrder(2)
dbGoTop()

cFil := If(xFilial() == "  ",xFilial(),cFilDe)
cInicio  := "RA3->RA3_FILIAL + RA3->RA3_CALEND"
cFim     := cFilAte + cCalAte
dbSeek( cFilDe + cCalDe ,.T.)

SetRegua(RecCount())

While !Eof() .And. &cInicio <= cFim

	//+--------------------------------------------------------------+
	//¦ Incrementa Regua de Processamento.                           ¦
	//+--------------------------------------------------------------+
	IncRegua()

	If lEnd
		IMPR(STR0026,"C") //"CANCELADO PELO USUARIO"
		Exit
	Endif

	
		If !Eval(cAcessaRA3)
			dbSkip()  
			Loop
		EndIf

	//+--------------------------------------------------------------+
	//¦ Consiste Parametrizaç¦o do Intervalo de Impress¦o.           ¦
	//+--------------------------------------------------------------+
	If 	(RA3->RA3_FILIAL 	< cFilDe) .Or. (RA3->RA3_FILIAL 	> cFilAte) .Or.;
		(RA3->RA3_MAT 		< cMatDe) .Or. (RA3->RA3_MAT 		> cMatAte) .Or.;
		(RA3->RA3_CALEND 	< cCalDe) .Or. (RA3->RA3_CALEND 	> cCalAte) .Or.;
		(RA3->RA3_CURSO  	< cCurDe) .Or. (RA3->RA3_CURSO 	> cCurAte) .Or.;
	   	!(RA3->RA3_RESERV $ cSitCur)

		dbSkip()
		Loop
	EndIf                          
		
	// Inicializa as variaveis do SQ3 - Cargos	
	cGrupo 	:= ""
	cDepto	:= ""
	cCargo	:= ""
		
	dbSelectArea( "SRA" )
	dbSetOrder(1)	
	If dbSeek( RA3->RA3_FILIAL + RA3->RA3_MAT )
		If SRA->RA_SITFOLH == "D"
		
			dbSelectArea( "RA3" )
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea( "SRJ" )
		dbSetOrder(1)
		cFil := If(xFilial() == "  ",xFilial(),SRA->RA_FILIAL)
		If dbSeek( cFil + SRA->RA_CODFUNC )
	
			dbSelectArea( "SQ3" )
			dbSetOrder(1)
			cFil := If(xFilial() == "  ",xFilial(),SRJ->RJ_FILIAL)
			If dbSeek( cFil + SRJ->RJ_CARGO )
				cGrupo:= SQ3->Q3_GRUPO            
				cDepto:= SQ3->Q3_DEPTO            
				cCargo:= SQ3->Q3_CARGO
			EndIf
		EndIf  
		
		Reclock("TRA",.T.)
			TRA->TR_CALEND  := RA3->RA3_CALEND
			TRA->TR_CURSO   := RA3->RA3_CURSO
			TRA->TR_TURMA   := RA3->RA3_TURMA
			TRA->TR_FILIAL  := SRA->RA_FILIAL
			TRA->TR_CC      := SRA->RA_CC
			TRA->TR_MAT     := SRA->RA_MAT
			TRA->TR_NOME    := SRA->RA_NOME
			TRA->TR_SITCUR  := RA3->RA3_RESERVA
			TRA->TR_GRUPO   := cGrupo 
			TRA->TR_NOMEG   := IIf(!Empty(cGrupo),TrmDesc("SQ0",cGrupo,"SQ0->Q0_DESCRIC"),Space(15))       
			TRA->TR_DEPTO   := cDepto 
			TRA->TR_NOMED   := IIf(!Empty(cDepto),TrmDesc("SQB",cDepto,"SQB->QB_DESCRIC"),Space(20))       
			TRA->TR_CARGO   := cCargo 
			TRA->TR_NOMEC   := IIf(!Empty(cCargo),TrmDesc("SQ3",cCargo,"SQ3->Q3_DESCSUM"),Space(30))       			
		MsUnlock()	
		
	EndIf
	
	dbSelectArea("RA3")
	dbSkip()
EndDo

For nImprVias := 1 To nVias

	dbSelectArea("TRA")
	dbGotop()

	SetRegua(RecCount())
   
	Do While ! Eof()
		cCalend	:= TRA->TR_CALEND
	    cCurso	:= TRA->TR_CURSO
	    cTurma	:= TRA->TR_TURMA
	    cFil1	:= TRA->TR_FILIAL
		Do While ! Eof() .And.	cCalend == TRA->TR_CALEND .And.;
								cCurso 	== TRA->TR_CURSO .And.;
								cTurma 	== TRA->TR_TURMA .And.;
								cFil1   == TRA->TR_FILIAL    
		
		    IncRegua()

			dbSelectArea("RA2")
			dbSetOrder(1)
			If dbSeek(xFilial("RA2")+TRA->TR_CALEND)
  				While ! Eof() .And. TRA->TR_CALEND == RA2->RA2_CALEND
					If 	TRA->TR_CURSO 	== RA2->RA2_CURSO .And. ;
						TRA->TR_TURMA	== RA2->RA2_TURMA 
				
						exit
					EndIf
					dbSkip()
				EndDo
            EndIf              
                     
            If RA2->(Eof()) .Or. 	TRA->TR_CALEND != RA2->RA2_CALEND .Or.;
									TRA->TR_CURSO 	!= RA2->RA2_CURSO .Or. ;
									TRA->TR_TURMA	!= RA2->RA2_TURMA 
           
	            dbSelectArea("TRA")
	            dbSkip()
	            Loop
            EndIf
            
            dbSelectArea("TRA")
            //Imprime Cabecalho
			fImpCab()
			//Imprime Detalhe
			fImpDet()

		EndDo
	EndDo

Next nImprVias

//+--------------------------------------------------------------+
//¦ Termino do Relatorio                                         ¦
//+--------------------------------------------------------------+

dbSelectArea( "RA3" )
dbSetOrder(1)

If lImp
	IMPR("","F")
EndIf

Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

TRA->(dbCloseArea())
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fImpCab  ³ Autor ³ Equipe RH		        ³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Cabecalho.										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpCab()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpCab()

DET := STR0013 + PadR(TRA->TR_CALEND,4) + " - " + PadR(RA2->RA2_DESC,30) + Repl(" ",14) //"CALENDARIO: "
DET := DET + STR0014 + PadR(TRA->TR_CURSO,4) + " - " + PadR(TrmDesc("RA1",TRA->TR_CURSO,"RA1->RA1_DESC"),30) + Repl(" ",14) //"CURSO: "
DET := DET + STR0015 + PadR(TRA->TR_TURMA,3) //"TURMA: "
IMPR(DET,"C")
DET := STR0016 + DtoC(RA2->RA2_DATAIN) + STR0017 + DtoC(RA2->RA2_DATAFI) + Repl(" ",14) + STR0018 + PadR(RA2->RA2_HORARI,20) //"PERIODO: "###" A "###"HORARIO: "
IMPR(DET,"C")
IMPR("","C")

//FIL. MATR.  MOME                           SITUACAO     GRUPO           DEPARTAMENTO         CARGO                            VISTO
//XX   XXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXX   XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX __________

DET := STR0019 //"FIL. MATR.  MOME                           SITUACAO     GRUPO           DEPARTAMENTO         CARGO                           VISTO"
IMPR(DET,"C")
IMPR("","C")
lImp := .T.
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fImpDet  ³ Autor ³ Equipe RH		        ³ Data ³ 19/03/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Detalhe											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpDet()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpDet()

cReserva := ""
dbSelectArea( "TRA" )
While !Eof() .And.	RA2->RA2_CALEND+RA2->RA2_CURSO+RA2->RA2_TURMA == ;
						TRA->TR_CALEND+TRA->TR_CURSO+TRA->TR_TURMA
	If LI >= 60
		fImpCab()
	EndIf
	DET := TRA->TR_FILIAL + "   " + TRA->TR_MAT + " " + TRA->TR_NOME + " "

	If TRA->TR_SITCUR == "R"
		cReserva := STR0020 //"RESERVADO"
	ElseIf TRA->TR_SITCUR == "L"
		cReserva := STR0021 //"LISTA ESPERA"
	ElseIf TRA->TR_SITCUR == "S"
		cReserva := STR0022 //"SOLICITACAO"
	Else
		cReserva := STR0023 //"CONCLUIDO"
	EndIf

	DET := DET + PadR(cReserva,12) + " "
	DET := DET + PadR(TRA->TR_NOMEG,15)+ " "
	DET := DET + PadR(TRA->TR_NOMED,20) + " "
	DET := DET + PadR(TRA->TR_NOMEC,30) + Repl("_",9)

	IMPR(DET,"C")
	IMPR("","C")
	dbSelectArea( "TRA" )
	dbSkip()
EndDo

IMPR("","C")
DET := REPL("-",132)
IMPR(DET,"C")
IMPR("","C")
		
dbSelectArea("RA7")
dbSeek(xFilial()+RA2->RA2_INSTRU)
DET := STR0024 + PadR(RA7->RA7_NOME,30) + " - " + Repl("_",85) //"INSTRUTOR: "
IMPR(DET,"C")
IMPR("","F")
LI := 00

Return Nil
