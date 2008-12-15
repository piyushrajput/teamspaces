/**
*@author Nicolas Gunther @ 09/15/2008 
*/
public class TeamsWidgetGadgetHolderController {
	
	String source = null;
	String name = null;
	Boolean sidebar = false;
	
	/**
	*@param String source
	*/
	public void setSource (String s){
		source = s;
	}
	
	/**
	*@return String soruce
	*/
	public String getSource (){
		return source;
	}
	
	/**
	*@param String doc name
	*/
	public void setName (String s){
		name = s;
	}

	/**
	*@return String doc name
	*/
	public String getName (){
		return name;
	}
	
	/**
	*@param Boolean is sidebar
	*/
	public void setSidebar(Boolean b){
		sidebar = b;	
	}
	
	/**
	*@return Boolean is sidebar
	*/
	public Boolean getSidebar(){
		return sidebar;
	}

}