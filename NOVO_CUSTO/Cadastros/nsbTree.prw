#include "TOTVS.CH"
#include "Protheus.ch"
#include "topconn.ch"
#include 'dbtree.ch'

User Function nsbTree//(cProduto)          

//local cProduto := "HP1081001N0CE04"
local aNo := {} //Controla os no da estrutura
local cNivel := 1
local i
local nPN := 1 // Nivel da pasta 1= mesmo nivel, 2= nivel a baixo
local cCaption := iif(ALTERA, "Alterar","Visualizar")
Private cProduto := ZZ7->ZZ7_COD
Private aStru := PEstru(cProduto)
Private corFolder :={{"FOLDER5","FOLDER6"},{"FOLDER7","FOLDER8"}}  

  DEFINE DIALOG oDlg TITLE "Tempo Produção Produtos" FROM 180,180 TO 550,700 PIXEL

  // Cria a Tree
  oTree := DbTree():New(0,0,160,260,oDlg,,,.T.)
 
   // Inclusao do produto PAI
  SB1->(DbSetOrder(1))
  SB1->(dbSeek(xFilial("SB1")+cProduto))
  
  oTree:AddItem(cProduto+" - "+SB1->B1_DESC,"001", corFolder[1][1],corFolder[1][2],,,nPN)
  oTree:TreeSeek("001")
   
  For i := 2 To Len(aStru)
  
	  if aStru[i][5] <> 2  	 
	  	nPos := aScan ( aStru, {|x| x[3] == aStru[i][2] })
	  	oTree:TreeSeek(StrZero(nPos,3))                                              
	  endif
	  oTree:AddItem(aStru[i][3]+" - "+aStru[i][4],StrZero(i,3), corFolder[aStru[i][6]][1],corFolder[aStru[i][6]][2],,,2)
	  
   NEXT
        
    TButton():New( 172,02,cCaption, oDlg,{|| TreeSave() },;
		 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	                                
	nPosX := 52
	
	if ALTERA                             
		nPosX := 102      
		TButton():New( 172, 052, "Excluir", oDlg,{|| TreeDel()  },;
         40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	Endif       
	
	TButton():New( 172, nPosX, "Sair", oDlg,{|| (oDlg:End())  },;
         40,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	
  oTree:EndTree()

  ACTIVATE DIALOG oDlg CENTERED 

************************************************************************************************************************************************************************

//--Funcao para retornar a estrutura do produto.
Static Function PEstru(cProd)
local cQry:=""
local aStru :={}

cQry:="  WITH FILHOS  AS ( "
cQry+="	  SELECT SG.G1_COD AS COD_PROD,  "
cQry+="			 B1P.B1_GRUPO AS GRUPO_PAI, B1P.B1_TIPO AS TIPO, SB.B1_COD AS COD_COMPONENTE, "
cQry+="			 SB.B1_DESC AS COMPONENTE, SG.G1_COMP AS G1_COMP, SB.B1_GRUPO AS GRUPO_COMP, SB.B1_TIPO AS TIPO_COMP, SG.G1_QUANT AS QUANTIDADE, "
cQry+="			 2 AS NIVEL "
cQry+="	   FROM SG1010 (NOLOCK)SG INNER JOIN SB1010 (NOLOCK)SB  ON SB.B1_FILIAL=SG.G1_FILIAL AND SB.B1_COD=SG.G1_COMP "
cQry+="							  INNER JOIN SB1010 (NOLOCK)B1P ON B1P.B1_FILIAL=SG.G1_FILIAL AND B1P.B1_COD=SG.G1_COD "
cQry+="	   WHERE  SG.D_E_L_E_T_=' ' AND SB.D_E_L_E_T_=' ' AND B1P.D_E_L_E_T_=' '  "
cQry+="	   AND SG.G1_FIM > '20190430'   "
cQry+="	   GROUP BY SG.G1_COD, B1P.B1_DESC, B1P.B1_GRUPO, B1P.B1_TIPO, SB.B1_COD, SB.B1_DESC, SG.G1_COMP, SB.B1_GRUPO, SB.B1_TIPO, SG.G1_QUANT "
   
cQry+="    UNION ALL "

cQry+="		SELECT T2.COD_PROD,  "
cQry+="			   B1P.B1_GRUPO AS GRUPO_PAI, B1P.B1_TIPO  AS TIPO, X.G1_COD  AS COD_COMPONENTE, SB.B1_DESC AS COMPONENTE, "
cQry+="			   X.G1_COMP, SB.B1_GRUPO AS GRUPO_COMP, SB.B1_TIPO  AS TIPO_COMP, X.G1_QUANT AS QUANTIDADE, "
cQry+="			   NIVEL + 1 "
cQry+="		FROM SG1010 (NOLOCK)X INNER JOIN [FILHOS] T2 ON T2.G1_COMP=X.G1_COD  "
cQry+="							  INNER JOIN SB1010 (NOLOCK)SB ON SB.B1_FILIAL=X.G1_FILIAL AND SB.B1_COD=X.G1_COMP "
cQry+="							  INNER JOIN SB1010 (NOLOCK)B1P ON B1P.B1_COD=X.G1_COD "
cQry+="		WHERE X.D_E_L_E_T_=' ' AND B1P.D_E_L_E_T_=' '  "
cQry+="		AND X.G1_FIM > '20190430' "
cQry+=") 

cQry+="SELECT FILHOS.*,S.B1_UM AS UM_COMP "
cQry+="FROM FILHOS INNER JOIN SB1010 (NOLOCK)S ON FILHOS.G1_COMP=S.B1_COD  "
cQry+="WHERE S.D_E_L_E_T_ = ''  "
cQry+="   AND S.B1_UM <> ' '  "
cQry+="   AND S.B1_TIPO IN ('PI','PA') "
cQry+="   AND COD_PROD IN(  '"+ cProd+"'  ) "

cQry+="ORDER BY NIVEL " 

TCQUERY cQry Alias TQRY New
	
	ZZ7->(DbSetOrder(1))
	SB1->(DbSetOrder(1))
	
	SB1->(dbSeek(xFilial("SB1")+cProd))
	lAchou := ZZ7->(dbSeek(xFilial("ZZ7")+cProd))
		
	Aadd(aStru, { SB1->B1_COD, SB1->B1_COD, SB1->B1_COD, SB1->B1_DESC, 1, iif(lAchou, 1, 2) })

	While TQRY->(!EOF())
		lAchou := ZZ7->(dbSeek(xFilial("ZZ7")+TQRY->G1_COMP))
		Aadd(aStru, { TQRY->COD_PROD, TQRY->COD_COMPONENTE, TQRY->G1_COMP, TQRY->COMPONENTE, TQRY->NIVEL,iif(lAchou, 1, 2) })
    	TQRY->(dbskip())
	End

	TQRY->(dbCloseArea())

return aStru 

***************************************************************************************************************************************************

Static Function TreeSave()
Local aAlias := SB1->(GetArea())

local aAlter:={"ZZ7_MOD211","ZZ7_MAQ211","ZZ7_MOD221","ZZ7_MAQ221","ZZ7_MOD231","ZZ7_MAQ231","ZZ7_MOD241",;
"ZZ7_MAQ241","ZZ7_MOD251","ZZ7_MAQ251"} // camos para Alteracao     

local aAcho := {"ZZ7_COD","ZZ7_DESC","ZZ7_TIPO","ZZ7_GRUPO","ZZ7_MOD211","ZZ7_MAQ211","ZZ7_MOD221","ZZ7_MAQ221","ZZ7_MOD231","ZZ7_MAQ231","ZZ7_MOD241",;
"ZZ7_MAQ241","ZZ7_MOD251","ZZ7_MAQ251"} // campo no Browser

Local nRet 
Local aParam := {} 
Private aButtons := {}
//adiciona codeblock a ser executado no inicio, meio e fim
aAdd( aParam, {|| U_TreeBef() } ) //antes da abertura
aAdd( aParam, {|| U_TreeTOK() } ) //ao clicar no botao ok
aAdd( aParam, {|| U_TreeTra() } ) //durante a transacao
aAdd( aParam, {|| U_TreeFim() } )      // termino da transacao

dbSelectArea("ZZ7")
     
     cProd := Substr(oTree:GetPrompt(.T.),1,15)
     cCargo := oTree:GetCargo()
     nPosAtu := val(cCargo)
     IF ALTERA
        if (aStru[nPosAtu][6] == 1) // produto ja cadastrado 
             ZZ7->(dbSeek(xFilial("ZZ7")+cProd))
         	AxAltera("ZZ7", ZZ7->(Recno()), 4,,aAlter) 
 	    else
	    	nOpca := AxInclui("ZZ7", ZZ7->(Recno()), 3,aAcho,,aAlter ,,.F.,,,aParam,,,.T.,,,,,)
	    	if(nOpca == 1)
	    		aStru[nPosAtu][6] := 1 
	    		oTree:TreeSeek(cCargo)
	    		oTree:ChangeBmp(corFolder[1][1],corFolder[1][2],,,cCargo)
     	    Endif
     	endif
     Else
     	if (aStru[val(oTree:GetCargo())][6] == 1) // produto ja cadastrado
     	     ZZ7->(dbSeek(xFilial("ZZ7")+cProd))
           	AxVisual("ZZ7",ZZ7->(Recno()),2)
      	Else
      	    Alert("Produto Sem Tempo de Producao!")
      	Endif
     Endif
 
      RestArea(aAlias)

Return

***************************************************************************************************************************************************
 
Static Function TreeDel()

    cProd := Substr(oTree:GetPrompt(.T.),1,15)
    
    if (aStru[val(oTree:GetCargo())][6] == 1)
         ZZ7->(dbSeek(xFilial("ZZ7")+cProd))
        
        if cProd == cProduto // produto PAI
           Alert("Produto Pai nao poderá ser exluido por essa Rotina!") 
           return
        Endif
        
        If MsgYesNo( 'Excluir Tempo de Produção do Produto: '+chr(13)+ cProd, 'Tempo de Producao' )
		    cCargo := oTree:GetCargo()
		    nPosAtu := val(cCargo)
		    
		    ZZ7->( RecLock("ZZ7",.F.) )
				ZZ7->( dbDelete() )
			ZZ7->( MsUnlock() )
		    
		    aStru[nPosAtu][6] := 2 
			oTree:TreeSeek(cCargo)
			oTree:ChangeBmp(corFolder[2][1],corFolder[2][2],,,cCargo)		
		Endif       	
    Else
        Alert("Produto Sem Tempo de Producao!") 
        return
    Endif
    
Return

***************************************************************************************************************************************************
                                                      
User function TreeBef
Local cProd := ""
	cProd := Substr(oTree:GetPrompt(.T.),1,15)
	SB1->( DbSeek(xFilial("SB1")+cProd))
	 
	M->ZZ7_COD := SB1->B1_COD
	M->ZZ7_DESC :=SB1->B1_DESC 
	M->ZZ7_TIPO := SB1->B1_TIPO
	M->ZZ7_GRUPO := SB1->B1_GRUPO
	
return 

***************************************************************************************************************************************************

User function TreeTOK

Return .t. 

***************************************************************************************************************************************************

User function  TreeTra()

Return  .t.

***************************************************************************************************************************************************

User function  TreeFim()

return .t.
