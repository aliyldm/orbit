package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ClanRelationChangedCommand;
   import net.bigpoint.darkorbit.com.module.ClanRelationModule;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ClanRelationChangedCommandHandler extends BaseHandler
   {
      
      public function ClanRelationChangedCommandHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:ClanRelationModule = null;
         var _loc2_:ClanRelationChangedCommand = param1 as ClanRelationChangedCommand;
         if(_main.screenManager.map)
         {
            _loc3_ = _main.screenManager.map.getShipManager().getShip(_loc2_.userId);
            _loc4_ = _loc2_.newRelation;
            _loc3_.info.clanDiplomacy.value = _loc4_.type;
            _loc3_.info.clanID.value = _loc2_.clanId;
         }
      }
   }
}

