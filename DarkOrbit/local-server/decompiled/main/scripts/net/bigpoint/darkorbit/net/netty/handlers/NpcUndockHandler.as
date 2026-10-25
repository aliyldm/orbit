package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.NpcUndockCommand;
   import net.bigpoint.darkorbit.map.model.ship.MotherShipTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class NpcUndockHandler extends BaseHandler
   {
      
      public function NpcUndockHandler()
      {
         super();
      }
      
      public static function run(param1:IModule) : void
      {
         var _loc2_:NpcUndockCommand = param1 as NpcUndockCommand;
         MotherShipTrait.undockMinion(_loc2_.motherShipId,map.getEntityById(_loc2_.minionId) as Ship);
      }
   }
}

