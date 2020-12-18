#include "protheus.ch"
// Tela de escolha de Liberacao de Acesso.
//Márcio Macedo 06/12/12

/*Function f_Opcoes(uVarRet			,;	//Variavel de Retorno
					cTitulo			,;	//Titulo da Coluna com as opcoes
					aOpcoes			,;	//Opcoes de Escolha (Array de Opcoes)
					cOpcoes			,;	//String de Opcoes para Retorno
					nLin1			,;	//Nao Utilizado
					nCol1			,;	//Nao Utilizado
					l1Elem			,;	//Se a Selecao sera de apenas 1 Elemento por vez
					nTam			,;	//Tamanho da Chave
					nElemRet		,;	//No maximo de elementos na variavel de retorno
					lMultSelect		,;	//Inclui Botoes para Selecao de Multiplos Itens
					lComboBox		,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
					cCampo			,;	//Qual o Campo para a Montagem do aOpcoes
					lNotOrdena		,;	//Nao Permite a Ordenacao
					lNotPesq		,;	//Nao Permite a Pesquisa	
					lForceRetArr    ,;	//Forca o Retorno Como Array
					cF3				 ;	//Consulta F3	
				  )
*/

User Function LibAcess()

MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
aSit := {;
				"S - Liberacao de Saida de Funcionario",;
				"S - Liberacao de Saida de Veiculos",;
				"S - Liberacao de Saida de Materiais",;
				"S - Solicitacao de Materia de Expediente",;
				"S - Permite Aprovacao de SSI";
			}  
	MvParDef:="SSSSS"
	cTitulo :="Permissoes de Acesso"	
	
IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,.F.)  // Chama funcao f_Opcoes
		&MvRet := mvpar  // Devolve Resultado
EndIF	

Return MvRet