package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.HeroMoveCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.ship.minimap.HeroMiniMapTrait;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class HeroMoveHandler extends BaseHandler
   {
      
      public function HeroMoveHandler()
      {
         super();
      }
      
      public static function run(param1:HeroMoveCommand) : void
      {
         if(map.hero)
         {
            HeroMiniMapTrait(map.hero.getFirstTrait(HeroMiniMapTrait)).destinationMarkerVisible = true;
            ScreenManager.getInstance().eventManager.moveHeroToCordinates(param1.x,param1.y);
         }
      }
   }
}

