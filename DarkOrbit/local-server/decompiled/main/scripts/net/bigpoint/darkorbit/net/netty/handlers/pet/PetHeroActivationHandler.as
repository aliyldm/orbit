package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.ClanRelationModule;
   import net.bigpoint.darkorbit.com.module.PetHeroActivationCommand;
   import net.bigpoint.darkorbit.map.model.effects.impl.PetSpawnEffect;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.net.PetAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetHeroActivationHandler extends BaseHandler
   {
      
      public function PetHeroActivationHandler()
      {
         super();
      }
      
      public static function run(param1:PetHeroActivationCommand) : void
      {
         var _loc2_:int = param1.petId;
         var _loc3_:int = param1.ownerId;
         var _loc4_:int = param1.shipType;
         var _loc5_:String = param1.petName;
         var _loc6_:int = param1.factionId;
         var _loc7_:int = param1.clanId;
         var _loc8_:int = param1.petLevel;
         var _loc9_:String = param1.clanTag;
         var _loc10_:int = ClanRelationModule.TYPE_ALLIED;
         var _loc11_:int = param1.x;
         var _loc12_:int = param1.y;
         var _loc13_:int = param1.petSpeed;
         var _loc14_:int = param1.minimapStrategyModule.minimapStrategy;
         if(map == null || map.hero == null)
         {
            return;
         }
         var _loc15_:Pet = map.getShipManager().createPet(_loc4_.toString(),_loc2_,_loc3_,_loc11_,_loc12_,_loc13_,_loc5_,_loc8_,_loc6_,_loc7_,_loc9_,_loc10_,_loc14_);
         map.hero.pet = _loc15_;
         map.effects.addMapObjectEffectOnce(new PetSpawnEffect(_loc15_));
         PetAssembly.getInstance().petWindow.activatePet();
      }
   }
}

