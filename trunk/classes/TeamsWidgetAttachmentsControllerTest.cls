@IsTest private class TeamsWidgetAttachmentsControllerTest {
    
    public static testMethod void TeamsWidgetAttachments() {
        try{
			GenerateEnvironmentTest.gen();
            Test.startTest();        
	        
	        TeamsWidgetAttachmentsController TWA = new TeamsWidgetAttachmentsController();
	        
	        GenerateEnvironmentTest.gen();
	        Team__c newTeam = GenerateEnvironmentTest.newTeam;
	        Attachment a = new Attachment(Name = 'Name', Body = Blob.valueOf('Some String'), ContentType = 'plain/text', parentId = newTeam.Id);
	        
	        //insert new Attachment(Name = 'Name', Body = Blob.valueOf('Some String'), ContentType = 'plain/text', parentId = newTeam.Id);
	        insert a;
	        
	        TWA.setSidebar(true);
	        TWA.getSidebar();
	        TWA.getAttachs();
	        TWA.getTeamInfo();
	        TWA.setTeamInfo(newTeam);
	        
	        TWA.setTeamId(newTeam.Id);
	        String teamId = TWA.getTeamId();
	        if(teamId == null){
	            System.assert(false, 'getTeamId error');
	        }
	        TWA.refresh();
	        TWA.currentTeam();
	        TWA.PictureID = '';
	        
	        TWA.getUserPermissions();
	        
	        String PictureIDGET = TWA.PictureID;
	        if(PictureIDGET == null){
	            System.assert(false, 'getPictureID error');
	        }
	        TWA.teamInfo = newTeam;
	        Team__c teamInfo = TWA.teamInfo;
	        if(teamInfo == null){
	            System.assert(false, 'teamInfo error');
	        }
	        TeamsWidgetAttachmentsController.AttachmentInfo AI = new TeamsWidgetAttachmentsController.AttachmentInfo();
	        
	        String name = AI.getName();
	        String attI = AI.getAttachImage();
	        Attachment at = AI.getAttachment();
	        String Id = AI.getId();
	         
	        TWA.getAttachCount();
	        System.currentPageReference().getParameters().put('idAttach',a.Id);
	        TWA.DeleteAttach();
	        
	        Test.stopTest();
        }catch(Exception e){  
        	throw e;
        }
    }
}