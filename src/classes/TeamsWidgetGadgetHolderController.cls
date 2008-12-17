public class TeamsWidgetGadgetHolderController {
	
	String source = null;
	String name = null;
	Boolean sidebar = false;
	
	public void setSource (String s){
		source = s;
	}
	
	public String getSource (){
		return source;
	}
	
	public void setName (String s){
		name = s;
	}

	public String getName (){
		return name;
	}
	
	public void setSidebar(Boolean b){
		sidebar = b;	
	}
	
	public Boolean getSidebar(){
		return sidebar;
	}

}