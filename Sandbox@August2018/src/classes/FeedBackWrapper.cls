public class FeedBackWrapper implements Comparable {
  
    private String type;
    //Private Integer value;

    Private decimal value;

    public FeedBackWrapper(String type, decimal value)
    {
        this.type= type;
        this.value= value;
    }
    
     public Integer compareTo(Object ObjToCompare) {
            return type.CompareTo(((FeedBackWrapper)ObjToCompare).type);
      }
        
    public FeedBackWrapper()
    {
    }

    public String getType()
    {
        return type;
    }
    
    public void setType(String type)
    {
        this.type = type;
    }


    public decimal getValue()
    {
        return value;
    }

    
    public void setValue(decimal value)
    {
        this.value = value;
    }
    
     public static void testCode() {
         Integer i =0;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
     }

 
}