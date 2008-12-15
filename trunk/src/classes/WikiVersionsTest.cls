@IsTest private class WikiVersionsTest {
    public static testMethod void testWiki() {
        GenerateEnvironmentTest.gen();
	
		Test.startTest();
	
        WikiVersionsController wiki = new WikiVersionsController();
        
        WikiVersionsController.InfoRev infoRev = new WikiVersionsController.InfoRev();
        infoRev.setModifiedBy('Some Name');
        infoRev.getModifiedBy();
        infoRev.setBody('<br />'); 
        infoRev.getBody();
        infoRev.setRevisionCount(1);
        infoRev.getRevisionCount();
        infoRev.setId('Some Id');
        infoRev.getId();
        infoRev.setName('Some Name');
        infoRev.getName();
        infoRev.setLastModifiedDate(System.now());
        infoRev.getLastModifiedDate();
        
        List<WikiVersionsController.InfoRev> listRevisions = wiki.getRevisionsList(); 
        
        WikiPage__c wp = GenerateEnvironmentTest.newWiki;
        WikiVersions__c wv = new WikiVersions__c();
        wv.Name = 'Foo Version';
        wv.Body__c = 'Foo Body';
        wv.WikiPageId__c = wp.Id;
        wv.revisionCount__c = 1; 
        insert wv;	
        
        wiki.setIdWikiPage(wp.Id);
        wiki.setIdRevL(wv.Id);
        wiki.setIdRevR(wv.Id);
        
        WikiVersionsController.InfoRev infoRev2 = wiki.getRevLeftBody();
        WikiVersionsController.InfoRev infoRev3 = wiki.getRevRightBody();
        
        wiki.getWikiInfo();
        wiki.getGoDiff();
        wiki.getGoLeft();
        wiki.getWikiLeft();
        wiki.cancelRevision();
        wiki.hideLeftBody();
        wiki.getGoRight();
        wiki.getWikiRight();
        wiki.hideRightBody();
        
        Test.stopTest();
        
    } 
    
    public static testMethod void testWiki2() {  
    	GenerateEnvironmentTest.gen();
	
		Test.startTest();
	
        WikiVersionsController wiki = new WikiVersionsController();

        WikiPage__c wp = GenerateEnvironmentTest.newWiki;
        WikiVersions__c wv = new WikiVersions__c();
        wv.Name = 'Foo Version';
        wv.Body__c = 'Foo Body';
        wv.WikiPageId__c = wp.Id;
        wv.revisionCount__c = 1; 
        insert wv;	
        
        wiki.getRevLeftBody();
        wiki.getRevRightBody(); 
        
        System.currentPageReference().getParameters().put('idRevL', wv.Id);
        System.currentPageReference().getParameters().put('idRevR', wv.Id);
        
        wiki.getRevLeftBody();
        wiki.getRevRightBody();
        wiki.setIdWikiPage(wp.Id);
        wiki.setIdRevL(wv.Id);
        wiki.setIdRevR(wv.Id);
       	wiki.saveLeft ();
        wiki.saveRight ();
        
        Test.stopTest();
    }
}