package net.bigpoint.darkorbit.fui.builder.repository
{
   import flash.filters.BitmapFilter;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   
   public class FilterRepository
   {
      
      private static var instance:FilterRepository;
      
      private var filters:Dictionary;
      
      public function FilterRepository()
      {
         super();
         this.filters = new Dictionary();
      }
      
      public static function getInstance() : FilterRepository
      {
         if(instance == null)
         {
            instance = new FilterRepository();
         }
         return instance;
      }
      
      public function register(param1:String, param2:BitmapFilter) : void
      {
         if(this.filters[param1] == null)
         {
            this.filters[param1] = param2;
         }
         else
         {
            UISystem.log("A text style GlowFilter with the key " + param1 + " already exists.");
         }
      }
      
      public function getByKey(param1:String) : BitmapFilter
      {
         if(this.filters[param1] != null)
         {
            return this.filters[param1];
         }
         UISystem.log("A text style GlowFilter with the key = \'" + param1 + "\' doesn�t exists.",UISystem.LOG_LEVEL_WARN);
         return null;
      }
   }
}

