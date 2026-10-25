package net.bigpoint.darkorbit.loadingscreen.mvc.assets.model.ids
{
   public class LibId
   {
      
      private static const _UI_ASSETS:String = "uiAssets.default";
      
      private static const _BG_ASSETS:String = "bgAssets.default";
      
      public function LibId()
      {
         super();
      }
      
      public static function get UI_ASSETS() : String
      {
         return _UI_ASSETS;
      }
      
      public static function get BG_ASSETS() : String
      {
         return _BG_ASSETS;
      }
   }
}

