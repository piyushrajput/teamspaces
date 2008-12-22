/**
*@author Gabriel Rilo @ 18/12/2008
*/
public class WikiWidgetMyRecentChangesController {
	
   	
   	List<Wiki> wikis = new List<Wiki>();
	
	/**
	* Costructor
	*/
	public WikiWidgetMyRecentChangesController () {
	}
	

   	/**
   	*@return List<Wiki>
   	*/
   	public List<Wiki> getMyRecentChanges () {
   		List<Wiki> wikis = new List<Wiki>();
   		for (WikiPage__c item: [ SELECT Team__r.Id , Team__r.Name, Id, Name, ShortDescription__c, LastModifiedById, LastModifiedDate FROM WikiPage__c WHERE LastModifiedById =: UserInfo.getUserId() ORDER BY LastModifiedDate desc limit 5]) {
   			Wiki wiki = new Wiki();
   			wiki.setId(item.Id);
   			wiki.setName(item.Name);
   			wiki.setLastModifiedBy(item.LastModifiedById);
   			wiki.setLastModifiedDate(item.LastModifiedDate);
   			wiki.setParentName(item.Team__r.Name);
   			wiki.setParentId(item.Team__r.Id);
   			wiki.setShortDescription(item.ShortDescription__c);
   			wikis.add(wiki);
   		}
   		return wikis;
   	}
   	
   	/**
   	*@return Integer
   	*/
   	public Integer getCntMyRecentChanges () {
   		return [ SELECT count() FROM WikiPage__c WHERE LastModifiedById =:UserInfo.getUserId()];
   	}

   	/**
   	* Class Wiki
   	*/
   	public class Wiki {
   		String name; 
   		String id;
   		String lastModifiedBy;
   		String lastModifiedById;
   		String lastModifiedDate;
   		String parentName;
   		String parentId;
   		String shortDescription;
   		String modifiedByPicture;
   		
		/**
		*@param String
		*/
		public void setModifiedByPicture (String modById) {
			String PictureId = '';
			List<PeopleProfile__c> itemProfile = new List<PeopleProfile__c>();
			itemProfile = [SELECT Picture__c FROM PeopleProfile__c WHERE User__c =:modById];
			
			if (itemProfile != null) {
				if (itemProfile.size() > 0) {
					PeopleProfile__c picture = new PeopleProfile__c();
					picture = itemProfile.get(0);
			        if(picture.Picture__c == '' || picture.Picture__c == null) {                	                                          	 
				     	PictureId = '';
					}else {
						PictureId = picture.Picture__c;
					} 
				}else {
					PictureId = '';
				}
			}
   			this.modifiedByPicture = PictureId ;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getModifiedByPicture () {
   			return modifiedByPicture;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setParentName (String parentName) {
   			this.parentName = parentName;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getParentName () {
   			return parentName;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setParentId (String parentId) {
   			this.parentId = parentId;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getParentId () {
   			return parentId;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setName (String Name) {
   			this.name = Name;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getName () {
   			return name;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setId (String Id) {
   			this.id = Id;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getId () {
   			return id;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setLastModifiedBy (String modById) {
   			User modBy = [select Name from User where id=: modById];
   			this.lastModifiedBy = modBy.Name;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getLastModifiedBy () {
   			return lastModifiedBy;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setLastModifiedById (String modById) {
   			this.lastModifiedById = modById;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getLastModifiedById () {
   			return lastModifiedById;
   		}
   		   		
   		/**
   		*@param Datetime
   		*/
   		public void setLastModifiedDate (DateTime dateMod) {
   			this.lastModifiedDate = dateMod.format();
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getLastModifiedDate () {
   			return LastModifiedDate;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setShortDescription (String shortDescription) {
   			this.shortDescription = shortDescription;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getShortDescription () {
   			return shortDescription;
   		}   		
   	}	



}