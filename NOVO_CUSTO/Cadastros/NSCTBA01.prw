#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

User Function NSCTBA01()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

//DbSelectArea("ZZ7")
//DbSetOrder(1)
//AxCadastro("ZZ7","Tempo Produção Produtos") 

Private cCadastro := "Tempo Produção Produtos"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","u_nsbTree",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","u_nsbTree",0,4} ,;
             {"Excluir","AxDeleta",0,5} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "ZZ7"

dbSelectArea("ZZ7")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

return