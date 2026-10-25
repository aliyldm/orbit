package net.bigpoint.darkorbit.managers
{
   import net.bigpoint.darkorbit.Main;
   
   public class BaseManager
   {
      
      protected static var _main:Main;
      
      public function BaseManager()
      {
         super();
      }
      
      public static function setMain(param1:Main) : void
      {
         _main = param1;
      }
   }
}

