package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ClanTagChangedCommand;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ClanTagChangedHandler extends BaseHandler
   {
      
      public function ClanTagChangedHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc3_:Ship = null;
         var _loc2_:ClanTagChangedCommand = param1 as ClanTagChangedCommand;
         if(_main.screenManager.map)
         {
            _loc3_ = _main.screenManager.map.getShipManager().getShip(_loc2_.userId);
            _loc3_.info.clanID.value = _loc2_.clanId;
            _loc3_.info.clanTag.value = _loc2_.clanTag;
         }
         if(_loc2_.userId == Hero.userID)
         {
            Hero.clanTag = _loc2_.clanTag;
            Hero.clanID = _loc2_.clanId;
         }
      }
   }
}

