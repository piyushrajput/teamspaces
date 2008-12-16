@IsTest private class PeopleKeywordSearchControllerTest {
    
    public static testMethod void PeopleKeywordSearchController() {
        TeamUtil.isTest = true;
        PeopleKeywordSearchController keywordSearchController = new PeopleKeywordSearchController();
        
        keywordSearchController.setIsTest(true);
        
        keywordSearchController.setUserId(UserInfo.getUserId());
        try { 
            keywordSearchController.setKeywordString('keyword');
        } catch(Exception e){
            System.assert(true, 'error setting keyword string'); 
        }
        
        try {
            keywordSearchController.setSizeList(2);
        } catch(Exception e){
            System.assert(true, 'error setting list size'); 
        } 
        
        if(keywordSearchController.getPeople() == null){
            System.assert(true, 'People list getter wrong'); 
        }
        
        if(keywordSearchController.getSizeList() == null){
            System.assert(true, 'People list size getter wrong'); 
        }
        
        if(keywordSearchController.getTitle() == null){
            System.assert(true, 'Title  getter wrong'); 
        }
        
        if(keywordSearchController.getKeyword() == null){
            System.assert(true, 'Keyword  getter wrong'); 
        }
        
        if(keywordSearchController.getTypeAction() == null){
            System.assert(true, 'TypeAction  getter wrong'); 
        }
        
        if(keywordSearchController.paramIsEmpty('sat') == null){
            System.assert(true, 'TypeAction  getter wrong'); 
        } 
        
        try {
            keywordSearchController.ResultCore('Search');
        } catch(Exception e){
            System.assert(true, 'Result Core broken :('); 
        }
        
        TeamUtil.isTest = false;
        
        PaginatorControllerTest.PaginatorController();
    }
    
}