public class UploadAttachmentController {
	// Parent Id parameter
	public String parentId = System.currentPageReference().getParameters().get('pId');
	
	public void setParentId (String parentId) {
		this.parentId = parentId;
	}
	
	public String getParentId () {
		return parentId;
	}
			
	// Construct Method
	public UploadAttachmentController () {
		constructMethods();		
	}
	
	public void constructMethods () {
		if (parentId != null) {
			String parentIdPrefix = parentId.substring(0,3);
			String wikiPrefix = Schema.SObjectType.WikiPage__c.getKeyPrefix();
			String teamPrefix = Schema.SObjectType.Team__c.getKeyPrefix();
			if (parentIdPrefix == wikiPrefix) 
				buttonStyle = 'wiki';
			if (parentIdPrefix == teamPrefix) {
				buttonStyle = 'team';
			}
		}	
	}
	
	// Set place witch the Form is used
	public String buttonStyle = '';
	
	public String getButtonStyle () {
		return buttonStyle;
	}
	
	// New Attachment Object
	public Attachment newAttach = new Attachment();
	
	public void setNewAttach (Attachment newAttach) {
		this.newAttach = newAttach;	
	}
	
	public Attachment getNewAttach () {
		return newAttach;
	}
	
	// Save new Attachment Method
	public PageReference saveNewAttach () {
		newAttach.ParentId = parentId;
		insert newAttach;
		PageReference pageRef = new PageReference('/apex/UploadAttachment');
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	// Cancel Methods
	public PageReference cancelAttach () {
		PageReference pageRef = new PageReference('/apex/UploadAttachment');
		pageRef.setRedirect(true);
		return pageRef;
	} 
	
}