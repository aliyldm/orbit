package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetActivationCommand;
   import net.bigpoint.darkorbit.map.model.effects.impl.PetSpawnEffect;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetActivationHandler extends BaseHandler
   {
      
      public function PetActivationHandler()
      {
         super();
      }
      
      public static function run(param1:PetActivationCommand) : void
      {
         var _loc17_:Pet = null;
         var _loc2_:int = param1.petId;
         var _loc3_:int = param1.ownerId;
         var _loc4_:int = param1.petDesignId;
         var _loc5_:String = param1.petName;
         var _loc6_:int = param1.petFactionId;
         var _loc7_:int = param1.petClanID;
         var _loc8_:int = param1.petLevel;
         var _loc9_:String = param1.clanTag;
         var _loc10_:int = param1.clanRelationship.type;
         var _loc11_:int = param1.x;
         var _loc12_:int = param1.y;
         var _loc13_:int = param1.petSpeed;
         var _loc14_:Boolean = param1.isInIdleMode;
         var _loc15_:Boolean = !param1.isVisible;
         var _loc16_:int = param1.minimapStrategyModule.minimapStrategy;
         if(map.getShipManager().getPet(_loc2_) == null)
         {
            _loc17_ = map.getShipManager().createPet(_loc4_.toString(),_loc2_,_loc3_,_loc11_,_loc12_,_loc13_,_loc5_,_loc8_,_loc6_,_loc7_,_loc9_,_loc10_,_loc16_);
            _loc17_.idleState = _loc14_;
            _loc17_.visible = !_loc14_;
            _loc17_.cloaked.value = _loc15_;
            if(!_loc14_)
            {
               map.effects.addMapObjectEffectOnce(new PetSpawnEffect(_loc17_));
            }
         }
      }
   }
}

