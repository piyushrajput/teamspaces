/**
*@author Bruno Fagundez @ 06/30/2008
*/
public class PeopleSuscribeController {
	
		public Id personId;
		public String SubscriptionStatus;
		public String SubsRow;
		public String SubsName;
		
		/**
		*@Constructor
		*/
		public PeopleSuscribeController(){
			
		}
				
		/**
		*Setter method for personId variable
		*@param String id
		*/
		public void setPersonId(String id) {
			personId = id;	
		}
		
		/**
		*@return Id
		*/
		public Id getPersonId(){
			return personId;
		}
		
		// Userid
		public String USERID = UserInfo.getUserId();
		
		/**
		*@return Id
		*/
		public Id getCurrentId(){
			return USERID;		
		}
		
		// User
		List<User> u = new List<User>();
		
		// Suscription row to this user (if any)
		List<PeopleSubscription__c> Subscription = new List<PeopleSubscription__c>();
		
		public boolean isSuscribed;
		
		public boolean isCurrentUser = false;
		
		/**
		*@return boolean
		*/
		public boolean getIsCurrentUser(){
			return isCurrentUser;		
		} 

		/**
		* Return a string for subsribe or unsuscribe, depending the user's status
		*@return String
		*/
		public String getSubscriptionStatus() {
			if(personId==null)
				personId = System.currentPageReference().getParameters().get('id');			
			
			u = [select FirstName from User where Id =: personId];	
			Subscription = [Select p.Subscriber__c, p.Person__c, p.Person__r.FirstName, p.Name, p.Id, p.CreatedById From PeopleSubscription__c p where Person__c =: personId and p.Subscriber__c =: UserInfo.getUserId()];		
			
			if( personId == UserInfo.getUserId() ){
				isCurrentUser = true;
			}
			
			if(Subscription.size() > 0){
				isSuscribed = true;
				SubscriptionStatus = 'Unsubscribe';
				SubsName = Subscription[0].Person__r.FirstName;
				SubsRow = Subscription[0].Id;
			} else {
				isSuscribed = false;
				SubscriptionStatus = 'Subscribe to ' + u[0].FirstName + '\'s Updates';
				SubsName = u[0].FirstName;
				SubsRow = ' ';
			}
				
			return SubscriptionStatus;		
		} 
		
		/**
		* Subscribe an user
		*@void
		*/
        public void Subscribe() {
        	if(isSuscribed){
	        	PeopleSubscription__c SubObj = new PeopleSubscription__c();
	        	SubObj = Subscription[0];	        	
	        	delete SubObj;
	        	SubscriptionStatus = 'Subscribe to ' +  u[0].FirstName + '\'s Updates';
	        	isSuscribed = false;
        	}else {
        		PeopleSubscription__c SubObj = new PeopleSubscription__c();
	        	SubObj.Person__c = personId;	        	
	        	SubObj.Subscriber__c = UserInfo.getUserId();	        	
	        	insert SubObj;
	        	SubscriptionStatus = 'Unsubscribe';
	        	isSuscribed = true;
        	}      
        }
        
        /**
        * Return if current user is subscribed
        *@return boolean
        */
        public boolean getSubscribedBoolean(){
			return isSuscribed;
		}
		
        /**
        *@return String
        */
		public String getSubscribedName(){
			return SubsName;
		}
		
        /**
        *@return String
        */
		public String getSubsRow(){
			return SubsRow;
		}
}