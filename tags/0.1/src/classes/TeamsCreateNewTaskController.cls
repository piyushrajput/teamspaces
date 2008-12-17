public class TeamsCreateNewTaskController {
	

	ProjectTask__c theTask = new ProjectTask__c();

	String param; 
	String idTask;
	dateMyFormat dateMy = new dateMyFormat();
	assingTo assign = new assingTo();
	
	
	public dateMyFormat getdateMy(){ 
		return dateMy;
	}
	
	public assingTo getassingTo(){ 
		return assign;
	}
    
    public ProjectTask__c getTask(){
    	return theTask; 
    }
    
    public void setParam(String p){
    	param = p;
    }
    
    String typeOfAction = 'Add New';
    public String getTypeOfAction(){
		return typeOfAction;
	}
 
	public TeamsCreateNewTaskController(){
   		
   		param = System.currentPageReference().getParameters().get('id');
   		idTask = System.currentPageReference().getParameters().get('task');
   		
   		String qtEdit = System.currentPageReference().getParameters().get('ed');
   		   		
   		if(param != null && idTask != null){
   			getTaskForEdit(param, idTask);
   		}
   		
   		if(qtEdit == 'true'){
   			genTempTask();
   		}
    	
	}
	
	public void genTempTask(){
		//Get Params
		
		String taskAsignee = System.currentPageReference().getParameters().get('qtaid');
		dateMy.setMember(taskAsignee);
			
	}	
	
	public List<SelectOption> getMembers() {
    	List<TeamMember__c> teamMembers = new List<TeamMember__c>();  
  	 	List<SelectOption> options = new List<SelectOption>();
  	 	if(param != null){
	  	 	teamMembers = [Select t.Team__c, t.User__r.Name, t.Name, t.User__c, t.Id From TeamMember__c t where t.Team__c =: param];  
	  	 	options.add(new SelectOption('Choose a team Member', 'Choose a team Member'));
	  	 	for(TeamMember__c c: teamMembers) {
	    		options.add(new SelectOption(c.User__c, c.User__r.Name)); 
	 		}
  	 	}
  	 	return options;
   	}
   	
   	public List<SelectOption> getPercent() {
  	 	List<SelectOption> percents = new List<SelectOption>();
  	 	for(Integer i = 0; i<101; i=i+5)
  	 	{
  	 		percents.add(new SelectOption(String.valueOf(i)+'.0', String.valueOf(i)+'%'));
  	 	}
  	 	return percents;
   	}
   	
   	public List<SelectOption> getPercentDedicated() {
  	 	List<SelectOption> percentsD = new List<SelectOption>();
  	 	for(Integer i = 0; i<101; i=i+5)
  	 	{
  	 		percentsD.add(new SelectOption(String.valueOf(i)+'.0', String.valueOf(i)+'%'));
  	 	}
  	 	return percentsD;
   	}
   	
   	List<assingTo> resultMem = new List<assingTo>();
   	
   	public List<assingTo> getAssignMember() {
  	 	return resultMem;
   	}
   	
   	
   	
   	
   	public void getTaskForEdit(String myParam, String MyidTask) {
		setAttachment(MyidTask);
		typeOfAction = 'Edit';
		theTask = [Select p.Team__c, 
				          p.StartDate__c, 
				          p.Priority__c, 
				          p.Percent_Completed__c, 
				          p.ParentTask__c, 
				          p.Name, 
				          p.Milestone__c,
				          p.LastModifiedDate, 
				          p.LastModifiedById, 
				          p.Id, p.EndDate__c, 
				          p.Duration__c, 
				          p.Description__c, 
				          p.CreatedDate,  
				          p.LastModifiedBy.Name, 
				          p.CreatedBy.Name, 
				          p.CreatedById,
				          (Select User__c, PercentDedicated__c From ProjectAssignee__r) 
	    				   From ProjectTask__c p where
	    				   p.Id =: MyidTask 
	    				   ];
    				       		
		if(theTask.ProjectAssignee__r.size() > 0 && theTask.ProjectAssignee__r[0] != null ){
			dateMy.setMember(theTask.ProjectAssignee__r[0].User__c);
			dateMy.setPercent(theTask.ProjectAssignee__r[0].PercentDedicated__c);
		}
		for(ProjectAssignee__c t: theTask.ProjectAssignee__r){
			assingTo assignMem = new assingTo();
			assignMem.setPercent(t.PercentDedicated__c);
			assignMem.setIdMember(t.User__c);
			resultMem.add(assignMem);
		}
		
		dateMy.setHours(theTask.Duration__c);
		dateMy.setlastModify(theTask.LastModifiedDate);
		dateMy.setcreateDate(theTask.CreatedDate);
   	}
   	
   	public List<SelectOption> getPriority() {
  	 	List<SelectOption> priority = new List<SelectOption>(); 
  	 	priority.add(new SelectOption('Normal','Normal'));	 	
  	 	priority.add(new SelectOption('High', 'High')); 	 	
  	 	priority.add(new SelectOption('Low','Low'));
  	 	return priority;
   	}
   	
   	List<myAttachment> resultAt = new List<myAttachment>();
   	public List<myAttachment> getAttachment(){
   		return resultAt;
   	}
   	
   	public void setAttachment(String taskId)
   	{
   		List<Attachment> res = new List<Attachment>();
   		res = [Select Name, Id, Parent.Id, ContentType, BodyLength From Attachment where Parent.Id =: taskId ];
   		if(res.size() > 0)
   		{
   			for(Attachment t: res)
   			{
				myAttachment at = new myAttachment();
				at.setBodyLenght(t.BodyLength);
				at.setIdAttachment(t.Id);
				at.setContentType(t.ContentType);
				at.setNameAttachment(t.Name);
				resultAt.add(at);
			}
   		}
   	}
    
    /*************************
   	* Inner Class myAttachment
   	*************************/
    public class myAttachment {
   		
   		protected String nameAttachment;
		protected String contentType;
		protected String idAttachment;
		protected Integer bodyLenght;
 		
 		/********
 		** GET **
 		********/
   		public Integer getBodyLenght() 
   		{
      		return bodyLenght;
        }
        
        public String getidAttachment() 
   		{
      		return idAttachment;
        }
        
        public String getContentType() 
   		{
      		return contentType;
        }
        
        public String getNameAttachment() 
   		{
      		return nameAttachment;
        }
        
        /********
 		** SET **
 		********/
        public void setBodyLenght(Integer len)
        {
        	bodyLenght = len;
        }
        
        public void setIdAttachment(String idA)
        {
        	idAttachment = idA;
        }
        
        public void setContentType(String mime)
        {
        	if(mime == 'image/jpeg' || mime ==  'image/png'  || mime == 'image/gif'  || mime == 'image/bmp')
        	{
        		contentType = 'imageType';
        	}
        	else if(mime == 'application/pdf')
        	{
        		contentType = 'pdfType';
        	}
        	else if(mime == 'text/plain')
        	{
        		contentType = 'txtType';
        	}
        	else if(mime == 'application/msword')
        	{
        		contentType = 'docType';
        	}
        	else if(mime == 'application/x-zip-compressed')
        	{
        		contentType = 'zipType';
        	}
        	else 
        	{	
        		contentType = 'unknowType';
        	}
        	

        }
        
        public void setNameAttachment(String n)
        {
        	nameAttachment = n;
        }
        
        
   	}	
   	
   	/*
   	* Inner Class 
   	* public int hours;
   	* public string member; 
   	* public string lastModify;
   	* public string createDate;
   	*/
  	public class dateMyFormat {
   		
   		protected Integer hours = 	0;
   		protected String member = UserInfo.getUserId();
   		protected String lastModify = '';
   		protected String createDate = '';
   		protected Double percentD = 100.0;
   		
   		public String  getLastModify() {
   			return lastModify;
   		} 
   		
   		public void setLastModify(Datetime lastM){
   			lastModify = lastM.format('MM/dd/yy hh:mm');
   		}  
   		
   		public String  getCreateDate() {
   			return createDate;
   		}
   		
   		public void setCreateDate(Datetime cre){
   			createDate = cre.format('MM/dd/yy hh:mm' );
   		}  
   		
   		public Integer getHours() {
      		return hours;
        }
        
        public void setHours(Double hou){
        	hours = hou.intValue();
        }
   		
   		public String getMember() {
      		return member;
        }
        
        public void setMember(String mem){
        	member = mem;
        }
        
        
        public Double getPercent() {
      		return percentD;
        }
        
        public void setPercent(Double per){
        	percentD = per;
        }
   	}
   	
   	public class assingTo {
   		
   		public Integer percent;
		public String idMember;
 		
   		public Integer getPercent() {
      		return percent;
        }
        
        public void setPercent(Double per){
        	if(per == null){
        		percent = 0;
        	}else{
        		percent = per.IntValue();
        	}
        }
        
        
        public String getIdMember() {
      		return idMember;
        }
        
        public void setIdMember(String idm){
        	idMember = idm;
        }
   	}
}