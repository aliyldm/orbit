package net.bigpoint.darkorbit.map.hud.ship
{
   import flash.text.TextField;
   
   public final class StaticHUDTextCache
   {
      
      public function StaticHUDTextCache()
      {
         super();
      }
      
      public static function configure(param1:TextField, param2:Boolean) : void
      {
         param1.cacheAsBitmap = param2 && !param1.embedFonts && param1.width <= 1024 && param1.height <= 128;
      }
   }
}

