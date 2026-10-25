package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   
   public class ActivateLaserCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "activateLaser";
      
      public function ActivateLaserCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         var _loc4_:int = 0;
         if(param1.hero == null)
         {
            return;
         }
         var _loc3_:MapEntity = param1.lockManager.target;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.id;
            if(_loc4_ != -1)
            {
               if(param1.hero.attackTrait.target != null)
               {
                  GameFacade.getInstance().sendNotification(MapAssetNotification.ABORT_LASER_ATTACK,[true,Hero.userID,false]);
               }
               else
               {
                  GameFacade.getInstance().sendNotification(MapAssetNotification.ATTACK_MAP_ASSET);
               }
            }
         }
         else
         {
            GameFacade.getInstance().sendNotification(MapAssetNotification.ABORT_LASER_ATTACK,[true,Hero.userID,true]);
         }
      }
   }
}

