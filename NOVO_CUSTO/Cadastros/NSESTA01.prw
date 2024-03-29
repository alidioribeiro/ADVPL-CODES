
#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "FWMVCDEF.ch"

/*_______________________________________________________________________________
���������������������������������������������������������������������������������
��+-----------+------------+-------+----------------------+------+------------+��
��� Programa  � NSESTA01   � Autor �				      � Data � 21/11/2016 ���
��+-----------+------------+-------+----------------------+------+------------+��
��� Descri��o � Conta Contabil x Grupo de Produto	                          ���
��+-----------+---------------------------------------------------------------+��
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/
User Function NSESTA01()
 
    oBrowse := FWMBrowse():New()    
    oBrowse:SetAlias('ZZ8')
    oBrowse:SetDescription('Conta Contabil x Grupo')
    oBrowse:SetMenuDef('NSESTA01')
    oBrowse:Activate()
    
Return

Static Function ModelDef()
    
     Local oModel     := Nil
     Local oStrMaster := Nil
     Local oStrDetail := Nil
     
     oStrMaster :=  FWFormStruct( 1, 'ZZ8' )
     oStrDetail :=  FWFormStruct( 1, 'ZZ8' )
       
     oModel := MPFormModel():New( 'MODESTA01' )    
     
     oModel:AddFields( 'MASTER', , oStrMaster )
     oModel:AddGrid( 'DETAIL', 'MASTER', oStrDetail  )  
     
     oModel:SetDescription( 'Modelo de CT1 X SBM' )
     
     oModel:GetModel( 'MASTER' ):SetDescription( 'Conta Contabil' )
     oModel:GetModel( 'DETAIL' ):SetDescription( 'Grupo' )
     
     oModel:SetPrimaryKey({'ZZ8_FILIAL','ZZ8_CONTA'})
     oModel:SetRelation( 'DETAIL', { { 'ZZ8_FILIAL', 'xFilial( "ZS8" )' }, {'ZZ8_CONTA', 'ZZ8_CONTA' } }, ZZ8->( IndexKey( 1 ) ) )  
     oModel:GetModel('DETAIL'):SetUniqueLine({"ZZ8_GRUPO"})
     
Return oModel 

Static Function ViewDef()
    Local oView  := Nil
    Local oModel := Nil
    
    Local oStrMaster := Nil
    Local oStrDetail := Nil
    
    oStrMaster :=  FWFormStruct( 2, 'ZZ8' )
    oStrDetail :=  FWFormStruct( 2, 'ZZ8' )  
    
    oStrMaster:RemoveField( 'ZZ8_GRUPO' )       
    oStrMaster:RemoveField( 'ZZ8_DGRUPO' )   
    oStrDetail:RemoveField( 'ZZ8_CONTA' )  
    oStrDetail:RemoveField( 'ZZ8_DCONTA' )  

    oModel := FWLoadModel( 'NSESTA01' )         
    oView :=  FWFormView():New()
    
    oView:SetModel(oModel)
    oView:AddField( 'VIEW_MASTER', oStrMaster, 'MASTER' )
    oView:AddGrid( 'VIEW_DETAIL', oStrDetail, 'DETAIL' )        
    oView:CreateHorizontalBox( 'Cabecalho' , 40)
    oView:CreateHorizontalBox( 'Itens' , 60)    
    
    oView:SetOwnerView( 'VIEW_MASTER', 'Cabecalho' )
    oView:SetOwnerView( 'VIEW_DETAIL', 'Itens' )
    
    //oView:EnableTitleView()
    
Return oView 

Static Function Menudef()
    Local aRotina := {}
    
    aAdd( aRotina, { 'Visualizar', 'VIEWDEF.NSESTA01', 0, 2, 0, NIL } )
    aAdd( aRotina, { 'Incluir'   , 'VIEWDEF.NSESTA01', 0, 3, 0, NIL } )
    aAdd( aRotina, { 'Alterar'   , 'VIEWDEF.NSESTA01', 0, 4, 0, NIL } )
    aAdd( aRotina, { 'Excluir'   , 'VIEWDEF.NSESTA01', 0, 5, 0, NIL } )
    aAdd( aRotina, { 'Copiar'    , 'VIEWDEF.NSESTA01', 0, 9, 0, NIL } )
    
Return aRotina

                                                           
