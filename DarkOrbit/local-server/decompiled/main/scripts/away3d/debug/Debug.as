package away3d.debug
{
   public class Debug
   {
      
      public static var active:Boolean = false;
      
      public static var warningsAsErrors:Boolean = true;
      
      public function Debug()
      {
         super();
      }
      
      public static function clear() : void
      {
      }
      
      public static function delimiter() : void
      {
      }
      
      public static function trace(param1:Object) : void
      {
         if(active)
         {
            dotrace(param1);
         }
      }
      
      public static function warning(param1:Object) : void
      {
         if(warningsAsErrors)
         {
            error(param1);
            return;
         }
      }
      
      public static function error(param1:Object) : void
      {
         throw new Error(param1);
      }
   }
}

function dotrace(param1:Object):void
{
   §§pop();
}
