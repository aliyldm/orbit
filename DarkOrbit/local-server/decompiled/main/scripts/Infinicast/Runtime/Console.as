package Infinicast.Runtime
{
   public class Console
   {
      
      public static var writeFunc:*;
      
      public function Console()
      {
         super();
      }
      
      public static function writeLine(param1:Object) : void
      {
         if(writeFunc)
         {
            writeFunc(param1);
         }
      }
   }
}

