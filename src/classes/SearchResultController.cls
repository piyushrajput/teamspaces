/**
*@author Martin Prado @ 6-30-2008
*/
public class SearchResultController {   
    
    protected String typeAction;
    //Generate Instance of PaginatorController Class
    protected PaginatorController paginator = new PaginatorController();
    protected String title = '';
    protected boolean myPeople = false;
    //User Id 
    protected String userId = System.currentPageReference().getParameters().get('id');
    protected Integer SizeList = 0;

    /**
    *@Constructor
    */
    public SearchResultController() {}
        
    /**
    * Setter method for Type of action variable
    * Types of action: SubscribesToMe, MyPeople, Search
    *@param String
    */ 
    public void setTypeAction(String tAc){
        typeAction = tAc;
        ResultCore(typeAction);     
    }
    
    /**
    * Set Size of List
    *@param Integer
    */
    public Void setSizeList(Integer size){
        SizeList = size;
    }
    
    /**
    * GET Type of action Attribute
    *@return String
    */
    public String getTypeAction(){
        return typeAction;
    }
    
    /**
    * GET Generic List of Pepole Profile
    *@return List<PeopleProfile__c>
    */
    public List<PeopleProfile__c> getPeople(){
        return result;
    }
    
    /**
    * GET Instance of Class PaginatorController
    *@return PaginatorController
    */
    public PaginatorController getPaginator(){
        return paginator;
    }
    
    /**
    * GET Size of List
    *@return Integer
    */
    public Integer getSizeList(){
        return SizeList;
    }

    /**
    * Get Tilte for page
    *@return String
    */
    public String getTitle(){
        return title;
    }
    
    //List of PeopleProfile__c 
    List<PeopleProfile__c> result = new List<PeopleProfile__c>();
    
    /**
    * Load result depending the Type of Action and set the value of section's title
    *@param String ActionType
    */
    public void ResultCore(String TypeA){
        
        if(userId == Userinfo.getUserId()) 
        	myPeople = true;
        //Result of People subscribe to me
        if(TypeA == 'SubscribesToMe'){
                List<User> users = new List<User>();
                List<PeopleSubscription__c> suscribers = [Select t.Id, t.Person__r.Id, t.Person__c, t.Subscriber__c, t.Subscriber__r.Id From PeopleSubscription__c t where t.Person__c =: userId];
                for(PeopleSubscription__c ps : suscribers){
                    users.add(ps.Subscriber__r);
                }
                result = [Select p.YahooIM__c, 
                             p.User__r.Phone, 
                             p.User__r.Email, 
                             p.User__r.Title, 
                             p.User__r.Department, 
                             p.User__r.Division, 
                             p.User__r.CompanyName, 
                             p.User__r.Name,
                             p.User__r.Id, 
                             p.User__c, 
                             p.Skype__c, 
                             p.Aol__c,
                             p.Picture__c, 
                             p.AboutMe__c
                             From PeopleProfile__c p 
                             where p.User__c in : users 
                             order by p.User__r.Name asc];  
        //Result of my People 
        }else if(TypeA == 'MyPeople'){
                List<User> users = new List<User>();
                List<PeopleSubscription__c> suscribers = [Select t.Id, t.Person__r.Id, t.Person__c, t.Subscriber__c, t.Subscriber__r.Id From PeopleSubscription__c t where t.Subscriber__c =: userId];
                for(PeopleSubscription__c ps : suscribers){
                    users.add(ps.Person__r);
                }
                result = [Select p.YahooIM__c, 
                             p.Aol__c,
                             p.User__r.Phone, 
                             p.User__r.Email, 
                             p.User__r.Title, 
                             p.User__r.Department, 
                             p.User__r.Division, 
                             p.User__r.CompanyName, 
                             p.User__r.Name,
                             p.User__r.Id, 
                             p.User__c, 
                             p.Skype__c, 
                             p.Picture__c, 
                             p.AboutMe__c
                             From PeopleProfile__c p where p.User__c in : users
                             order by p.User__r.Name asc
                             ]; 
        }
        
        //Set the Values of Paginator
        setSizeList(result.size());
        paginator.setTotalItemsNumber(result.size());
        paginator.genCntPagination();
        
        //SET Title 
        if(myPeople){
            if(typeAction == 'SubscribesToMe'){
                title = 'Subscribers to your Updates';
            }else if(typeAction == 'MyPeople'){
                title = 'My People Updates';
            }else if(typeAction == 'Search'){
                title = 'Search Results from People';
            }
        }else {   
            List<User> u = new List<User>();
            u  = [Select u.Id, u.FirstName From User u where u.Id =:userId];
            if(u.size() > 0){
                String firstName = u[0].FirstName;
                if(typeAction == 'SubscribesToMe'){
                    title = firstName+'\'s People Updates';
                }else if(typeAction == 'MyPeople'){
                    title = 'Subscribers to '+ firstName +'\' Updates';
                }
            }
            
        }
        
     }
     
}