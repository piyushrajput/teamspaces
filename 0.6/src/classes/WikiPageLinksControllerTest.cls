@IsTest private class WikiPageLinksControllerTest { 
	public static testMethod void testWiki() {
		GenerateEnvironmentTest.gen();
		
		Test.startTest();
		WikiPage__c newWiki = GenerateEnvironmentTest.newWiki;
		System.currentPageReference().getParameters().put('idWP', newWiki.Id);
		
		WikiPageLinksController wikiLink = new WikiPageLinksController();
		WikiPageLinksController.AttachmentInfo wikiInfo = new WikiPageLinksController.AttachmentInfo();
		wikiInfo.getId();
		wikiInfo.getName();
		wikiInfo.getAttachImage();
		
		// Create a new Wiki Attachment
		Attachment newAttach = new Attachment();
		newAttach.Name = 'Foo Attach';
		newAttach.ParentId = newWiki.Id;    
		newAttach.ContentType = 'plain/txt';
		newAttach.Body = Blob.valueOf('Foo body');
		upsert newAttach;
		
		wikiLink.getAttachments();
		wikiLink.getCntAttachments();
		
		wikiLink.getWikiPagesTeam();
		wikiLink.getCntTeamWikis();
		wikiLink.getWikiPagesAll();
		wikiLink.getCntAllWikis();
		wikiLink.getWikiChilds();
		wikiLink.getCntWikiChilds();
		
		wikiLink.setIdWikiPage('{!idWikiPage}');
		wikiLink.getAttachments();
		
		Test.stopTest();
	}
}