#include "rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "colors.ch"
#include "font.ch"
#include "ap5mail.ch"  

User Function ExpMenu()

	Local cPerg := "XNU0000001"

   ValidPerg(cPerg)

	@ 000,000 To 160,350 Dialog _WndMain TITLE "Auditoria em Menus"
	@ 005,005 To 040,165
	@ 015,010 Say OemToAnsi("Este programa ir agerar um arquivo CSV contendo a lista")
	@ 025,010 say OemToAnsi("dos programas disponiveis nos menus da versao 10.01" )
	@ 055,080 Bmpbutton Type 1 Action ProcMenus()
	@ 055,110 Bmpbutton Type 2 Action Close(_WndMain)
	@ 055,140 Bmpbutton Type 5 Action Pergunte("XNU0000001",.T.)
	Activate Dialog _WndMain Centered
	
Return

Static Function ProcMenus()
      
	Close(_WndMain)
	Processa({|| RunReport()},"Processando ..." )
	
Return

**************************************************************************************************************

Static Function RunReport()
	
	Local cNomeArq	:= "MENUS.DBF"
	Local cNomeRel	:= "\LOGTRF\MENUS.CSV"	
	Local aUsuario	:= AllUsers()
	Local aMenuAll	:= {}
	Local aAdminXnu	:= { "SIGAFIS","SIGACOM","SIGACTB","SIGAGPE","SIGAEST","SIGAFAT","SIGAFIN","SIGAPON","SIGAPCP" }
	Local aCampos	:= {{"MENU","C",50,0},{"GRUPO","C",35,0},{"DESCRI","C",35,0},{"MODO","C",1,0},{"TIPO","C",15,0},{"FUNCAO","C",12,0},{"ACS","C",10,0},{"MODULO","C",02,0},{"ARQS","C",255,0},;
	{"A1","C",1,0},{"A2","C",1,0},{"A3","C",1,0},{"A4","C",1,0},{"A5","C",1,0},{"A6","C",1,0},{"A7","C",1,0},{"A8","C",1,0},{"A9","C",1,0},{"A0","C",1,0},;
	{"LOGIN","C",20,0},{"NOME","C",35,0},{"DEPTO","C",30,0},{"CARGO","C",30,0},{"EMAIL","C",35,0}}
	Local cRelTrb	:= CriaTrab(aCampos,.T.)

                                                                                                                  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo de trabalho para gravar os dados do relatorio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbUseArea(.T.,"DBFCDX",cRelTrb,"TRB",.T.,.F.)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o relatorio ja existe gerado em disco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If File(cNomeRel)
		Delete File &(cNomeRel)
	Endif
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obter lista de todos os menus utilizados pelos usuarios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF MV_PAR01 == 1
		ProcRegua(Len(aUsuario))
		For x := 1 To Len(aUsuario)
			IncProc( "Analisando cadastro de usuarios" )
			aDados1 := aUsuario[x,1]
			aDados2 := aUsuario[x,2]
			aDados3 := aUsuario[x,3] // Menus
   	
			cLogin	:= aDados1[2]
			cNome	:= AllTrim(aDados1[4])
			cDepto	:= AllTrim(aDados1[12])
			cCargo	:= AllTrim(aDados1[13])
			cEMail	:= AllTrim(aDados1[14])

			For s := 1 To Len(aDados3)
				cMenu	:= AllTrim(Capital(AllTrim(Substr(aDados3[s],4,Len(aDados3[s])))))
				lUsado	:= IIF(Substr(aDados3[s],3,1)=="X",.F.,.T.)
				If lUsado
					If File(cMenu)
					aAdd( aMenuAll,{ cMenu,cLogin,cNome,cDepto,cCargo,cEMail } )
					Endif
				Endif
			Next
		Next
	Elseif MV_PAR01 == 2
		For x := 1 To Len(aAdminXnu)
			aAdd( aMenuAll,{ "\SYSTEM" + aAdminXnu[x] + ".XNU" ,"Administrador","Administrador","Tecnologia","","" } )
		Next
	Else
		aAdd( aMenuAll,{ UPPER(AllTrim(MV_PAR02)) ,"Menu","Menu","Configurador","","" } )
	Endif
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ A funcao XNULoad ira retornar para o      ³
	//³ vetor aEstrutura 4 elementos referente a: ³
	//³ aEstrutura[1] = Atualizacoes              ³
	//³ aEstrutura[2] = Consultas                 ³
	//³ aEstrutura[3] = Relatorios                ³
	//³ aEstrutura[4] = Miscelaneas               ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	ProcRegua(Len(aMenuAll))
    For z := 1 To Len(aMenuAll)
    
		IncProc( "Lendo " + Lower(AllTrim(aMenuAll[z,1])) )
		aEstrutura := XNULoad(aMenuAll[z,1])
	
		For a := 1 To Len(aEstrutura)
	
			If a == 1
				cTipo := "Atualizacoes"
			Elseif a == 2
				cTipo := "Consultas"
			Elseif a == 3
				cTipo := "Relatorios"
			Elseif a == 4
				cTipo := "Miscelaneas"
			Endif
		
			aParte    := aEstrutura[a]
			aGrupos   := aParte[3]
		
			For b := 1 To Len(aGrupos)
					
				If ValType(aGrupos[b][3]) == "A"
			
					aFuncoes  := aGrupos[b][3]
					cGrupo    := aGrupos[b][1][1]
			
					If ValType(aFuncoes) == "A"	
						For c := 1 To Len(aFuncoes)
							IF Len(aFuncoes[c]) >= 7
								aAlias		:= aFuncoes[c][4]
								cArquivo	:= ""
								aEval( aAlias,{ |h| cArquivo += h + " " },,)
					  			If	aFuncoes[c][2]=="E"
									DbSelectArea("TRB")
									RecLock("TRB",.T.)
										TRB->MENU	:= aMenuAll[z,1]
										TRB->DESCRI	:= RTrim(aFuncoes[c][1][1])
										TRB->MODO	:= aFuncoes[c][2]
										TRB->TIPO	:= cTipo
										TRB->FUNCAO	:= Upper(RTrim(aFuncoes[c][3]))
										TRB->ACS	:= Upper(aFuncoes[c][5])
										TRB->MODULO	:= RTrim(aFuncoes[c][6])
										TRB->ARQS	:= RTrim(cArquivo)
										TRB->GRUPO	:= RTrim(cGrupo)
										TRB->A1		:= Substr(Upper(aFuncoes[c][5]) ,1,1)
										TRB->A2		:= Substr(Upper(aFuncoes[c][5]) ,2,1)						
										TRB->A3		:= Substr(Upper(aFuncoes[c][5]) ,3,1)						
										TRB->A4		:= Substr(Upper(aFuncoes[c][5]) ,4,1)
										TRB->A5		:= Substr(Upper(aFuncoes[c][5]) ,5,1)
										TRB->A6		:= Substr(Upper(aFuncoes[c][5]) ,6,1)												
										TRB->A7		:= Substr(Upper(aFuncoes[c][5]) ,7,1)
										TRB->A8		:= Substr(Upper(aFuncoes[c][5]) ,8,1)
										TRB->A9		:= Substr(Upper(aFuncoes[c][5]) ,9,1)
										TRB->A0		:= Substr(Upper(aFuncoes[c][5]) ,10,1)						
										TRB->LOGIN	:= RTrim(aMenuAll[z,2])
										TRB->NOME	:= RTrim(Capital(aMenuAll[z,3]))
										TRB->DEPTO	:= RTrim(Capital(aMenuAll[z,4]))
										TRB->CARGO	:= RTrim(Capital(aMenuAll[z,5]))
										TRB->EMAIL	:= RTrim(lower(aMenuAll[z,6]))
									MsUnLock()								
								Endif
							EndIf
						Next
				    Endif
				Else
			    
					DbSelectArea("TRB")
					RecLock("TRB",.T.)
						TRB->MENU	:= aMenuAll[z,1]
						TRB->DESCRI	:= RTrim(aGrupos[b][1][1])
						TRB->MODO	:= RTrim(aGrupos[b][2])
						TRB->TIPO	:= cTipo					
						TRB->FUNCAO	:= RTrim(Upper(RTrim(aGrupos[b][3])))
						TRB->ACS	:= RTrim(Upper(aGrupos[b][5]))
						TRB->MODULO	:= RTrim(aGrupos[b][6])
						TRB->ARQS	:= RTrim(cArquivo)
						TRB->GRUPO	:= RTrim(cGrupo)
						TRB->A1		:= Substr(Upper(aGrupos[b][5]) ,1,1)
						TRB->A2		:= Substr(Upper(aGrupos[b][5]) ,2,1)						
						TRB->A3		:= Substr(Upper(aGrupos[b][5]) ,3,1)						
						TRB->A4		:= Substr(Upper(aGrupos[b][5]) ,4,1)
						TRB->A5		:= Substr(Upper(aGrupos[b][5]) ,5,1)
						TRB->A6		:= Substr(Upper(aGrupos[b][5]) ,6,1)												
						TRB->A7		:= Substr(Upper(aGrupos[b][5]) ,7,1)
						TRB->A8		:= Substr(Upper(aGrupos[b][5]) ,8,1)
						TRB->A9		:= Substr(Upper(aGrupos[b][5]) ,9,1)
						TRB->A0		:= Substr(Upper(aGrupos[b][5]) ,10,1)
						TRB->LOGIN	:= RTrim(aMenuAll[z,2])
						TRB->NOME	:= RTrim(Capital(aMenuAll[z,3]))
						TRB->DEPTO	:= RTrim(Capital(aMenuAll[z,4]))
						TRB->CARGO	:= RTrim(Capital(aMenuAll[z,5]))
						TRB->EMAIL	:= RTrim(lower(aMenuAll[z,6]))
					MsUnLock()
				
				Endif    
		
			Next	
	
		Next
	
	Next
	
	DbSelectArea("TRB")
	DbCloseArea()		                
	__CopyFile(cRelTrb+".DBF",Alltrim(MV_PAR03)+"\menu.dbf")
	
	
Return

**************************************************************************************************************

Static Function ValidPerg( cPerg )

	Local aArea := GetArea()
	Local aPerg:= {}

	aAdd(aPerg,{cPerg,"01","Analisar quais menus ?","mv_ch1","N",01 ,0,1,"C","","mv_par01","Todos","","","Padrao","","","Especifico","","","","","","","","  ",})
	aAdd(aPerg,{cPerg,"02","Menu especíico       ?","mv_ch2","C",40 ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","",})
	aAdd(aPerg,{cPerg,"03","Caminho              ?","mv_ch3","C",60 ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",})

	DbSelectArea("SX1")	                                                
	For _nLaco:=1 to LEN(aPerg)                                   
		If !dbSeek(aPerg[_nLaco,1]+aPerg[_nLaco,2])
	    	RecLock("SX1",.T.)
				SX1->X1_Grupo     := aPerg[_nLaco,01]
				SX1->X1_Ordem     := aPerg[_nLaco,02]
				SX1->X1_Pergunt   := aPerg[_nLaco,03]
				SX1->X1_PerSpa    := aPerg[_nLaco,03]
				SX1->X1_PerEng    := aPerg[_nLaco,03]				
				SX1->X1_Variavl   := aPerg[_nLaco,04]
				SX1->X1_Tipo      := aPerg[_nLaco,05]
				SX1->X1_Tamanho   := aPerg[_nLaco,06]
				SX1->X1_Decimal   := aPerg[_nLaco,07]
				SX1->X1_Presel    := aPerg[_nLaco,08]
				SX1->X1_Gsc       := aPerg[_nLaco,09]
				SX1->X1_Valid     := aPerg[_nLaco,10]
				SX1->X1_Var01     := aPerg[_nLaco,11]
				SX1->X1_Def01     := aPerg[_nLaco,12]
				SX1->X1_Cnt01     := aPerg[_nLaco,13]
				SX1->X1_Var02     := aPerg[_nLaco,14]
				SX1->X1_Def02     := aPerg[_nLaco,15]
				SX1->X1_Cnt02     := aPerg[_nLaco,16]
				SX1->X1_Var03     := aPerg[_nLaco,17]
				SX1->X1_Def03     := aPerg[_nLaco,18]
				SX1->X1_Cnt03     := aPerg[_nLaco,19]
				SX1->X1_Var04     := aPerg[_nLaco,20]
				SX1->X1_Def04     := aPerg[_nLaco,21]
				SX1->X1_Cnt04     := aPerg[_nLaco,22]
				SX1->X1_Var05     := aPerg[_nLaco,23]
				SX1->X1_Def05     := aPerg[_nLaco,24]
				SX1->X1_Cnt05     := aPerg[_nLaco,25]
				SX1->X1_F3        := aPerg[_nLaco,26]
			MsUnLock()
		EndIf
	Next
	RestArea( aArea )
Return