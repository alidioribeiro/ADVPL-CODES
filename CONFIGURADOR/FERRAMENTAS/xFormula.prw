#Include 'Protheus.ch'
#Include 'ParmType.ch'


//+------------+------------+--------+--------------------------------------------+
//| Função:    | xFormula   | Autor: | David Alves dos Santos                     | 
//+------------+------------+--------+--------------------------------------------+
//| Descrição: | Rotina para execução de funções dentro do Protheus.              |
//+------------+------------------------------------------------------------------+
//+-------------------------------------------------------------------------------+
User Function xFormula()
	
	//-> Declaração de variáveis.
	Local bError 
	Local cGet1Frm := PadR("Ex.: u_NomeFuncao() ", 50)
	Local oDlg1Frm := Nil
	Local oSay1Frm := Nil
	Local oGet1Frm := Nil
	Local oBtn1Frm := Nil
	Local oBtn2Frm := Nil
	
	//-> Recupera e/ou define um bloco de código para ser avaliado quando ocorrer um erro em tempo de execução.
	bError := ErrorBlock( {|e| cError := e:Description } ) //, Break(e) } )
	X31UPDTABLE("PA1")
	//-> Inicia sequencia.
	BEGIN SEQUENCE
	
		//-> Construção da interface.
		oDlg1Frm := MSDialog():New( 091, 232, 225, 574, "SigaMDI.net | Fórmulas" ,,, .F.,,,,,, .T.,,, .T. )
		
		//-> Rótulo. 
		oSay1Frm := TSay():New( 008 ,008 ,{ || "Informe a sua função aqui:" } ,oDlg1Frm ,,,.F. ,.F. ,.F. ,.T. ,CLR_BLACK ,CLR_WHITE ,084 ,008 )
		
		//-> Campo.
		oGet1Frm := TGet():New( 020 ,008 ,{ | u | If( PCount() == 0 ,cGet1Frm ,cGet1Frm := u ) } ,oDlg1Frm ,150 ,008 ,'!@' ,,CLR_BLACK ,CLR_WHITE ,,,,.T. ,"" ,,,.F. ,.F. ,,.F. ,.F. ,"" ,"cGet1Frm" ,,)
		
		//-> Botões.
		oBtn1Frm := TButton():New( 040 ,008 ,"Executar" ,oDlg1Frm ,{ || &(cGet1Frm)    } ,037 ,012 ,,,,.T. ,,"" ,,,,.F. )
		oBtn2Frm := TButton():New( 040 ,120 ,"Sair"     ,oDlg1Frm ,{ || oDlg1Frm:End() } ,037 ,012 ,,,,.T. ,,"" ,,,,.F. )
		
		//-> Ativação da interface.
		oDlg1Frm:Activate( ,,,.T.)
	
	RECOVER
		
		//-> Recupera e apresenta o erro.
		ErrorBlock( bError )
		MsgStop( cError )
		
	END SEQUENCE
	
Return