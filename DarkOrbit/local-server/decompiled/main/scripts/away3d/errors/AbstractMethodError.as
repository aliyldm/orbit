package away3d.errors
{
   public class AbstractMethodError extends Error
   {
      
      public function AbstractMethodError(param1:String = null, param2:int = 0)
      {
         super(param1 || "An abstract method was called! Either an instance of an abstract class was created, or an abstract method was not overridden by the subclass.",param2);
      }
   }
}

