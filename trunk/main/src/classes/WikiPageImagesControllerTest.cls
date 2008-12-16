@IsTest private class WikiPageImagesControllerTest { 
	public static testMethod void testWiki() {
		GenerateEnvironmentTest.gen();
		
		Test.startTest();
		WikiPage__c newWiki = GenerateEnvironmentTest.newWiki;
		System.currentPageReference().getParameters().put('idWP', newWiki.Id);
		
		WikiPageImagesController wikiImage = new WikiPageImagesController();
		WikiPageImagesController.AttachmentInfo wikiInfo = new WikiPageImagesController.AttachmentInfo();
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
		
		wikiImage.getAttachments();
		wikiImage.getAttachCount();
		
		wikiImage.setIdWikiPage('{!idWikiPage}');
		wikiImage.getAttachments();
		
		Test.stopTest();
	}
}