package Infinicast.Runtime
{
   public class StringExtensions
   {
      
      public function StringExtensions()
      {
         super();
      }
      
      public static function IsNullOrEmpty(param1:String) : Boolean
      {
         if(null === param1)
         {
            return true;
         }
         return 0 == param1.length;
      }
   }
}

