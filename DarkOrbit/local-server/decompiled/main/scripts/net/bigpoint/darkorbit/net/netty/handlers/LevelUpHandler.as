package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.LevelUpCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.LevelUpEffect;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class LevelUpHandler extends BaseHandler
   {
      
      public function LevelUpHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:LevelUpCommand = param1 as LevelUpCommand;
         ScreenManager.getInstance().map.effects.addEffect(new LevelUpEffect(ScreenManager.getInstance().map.getShipManager().getShip(_loc2_.uid)));
      }
   }
}

