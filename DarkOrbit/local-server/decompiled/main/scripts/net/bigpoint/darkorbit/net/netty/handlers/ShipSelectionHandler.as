package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ShipSelectionCommand;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.mvc.contactsWindow.ContactsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ShipSelectionHandler extends BaseHandler
   {
      
      public function ShipSelectionHandler()
      {
         super();
      }
      
      public static function run(param1:ShipSelectionCommand) : void
      {
         var _loc10_:Ship = null;
         var _loc11_:String = null;
         var _loc12_:GroupProxy = null;
         var _loc2_:int = param1.userId;
         var _loc3_:int = param1.shield;
         var _loc4_:int = param1.shieldMax;
         var _loc5_:Number = param1.hitpoints;
         var _loc6_:Number = param1.hitpointsMax;
         var _loc7_:int = param1.nanoHull;
         var _loc8_:int = param1.maxNanoHull;
         var _loc9_:Boolean = param1.shieldSkill;
         if(_loc2_ != -1)
         {
            if(map != null)
            {
               _loc10_ = map.getShipManager().selectShip(_loc2_,_loc5_,_loc6_,_loc3_,_loc4_,_loc7_,_loc8_);
               if(_loc9_)
               {
                  map.effects.playEffect(new ShieldEffect(_loc10_,Effect.NOT_PERSISTANT));
               }
               _loc11_ = getPlayerName(_loc10_);
               _loc12_ = _facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
               if(_loc12_)
               {
                  _loc12_.selectUser(_loc2_,_loc11_);
               }
               if(Boolean(_loc10_) && Boolean(!_loc10_.isNPC) && !(_loc10_ is Pet))
               {
                  _facade.sendNotification(ContactsWindowNotifications.SHIP_SELECTED,[_loc2_,_loc11_]);
               }
            }
         }
      }
      
      private static function getPlayerName(param1:Ship) : String
      {
         var _loc2_:String = "";
         if(param1)
         {
            _loc2_ = !(param1.isNPC || param1 is Pet) ? param1.info.username.value : "";
         }
         return _loc2_;
      }
   }
}

