package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.PetStatusCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetStatusHandler extends BaseHandler
   {
      
      public function PetStatusHandler()
      {
         super();
      }
      
      public static function run(param1:PetStatusCommand) : void
      {
         var _loc2_:String = param1.petLootId;
         var _loc3_:int = param1.petId;
         var _loc4_:int = param1.petLevel;
         var _loc5_:int = param1.petExperiencePoints;
         var _loc6_:int = param1.petExperiencePointsUntilNextLevel;
         var _loc7_:int = param1.petHitPoints;
         var _loc8_:int = param1.petHitPointsMax;
         var _loc9_:int = param1.petShieldEnergyNow;
         var _loc10_:int = param1.petShieldEnergyMax;
         var _loc11_:int = param1.petCurrentFuel;
         var _loc12_:int = param1.petMaxFuel;
         var _loc13_:int = param1.petSpeed;
         var _loc14_:String = param1.petName;
         var _loc15_:Vector.<MapEntity> = map.getEntityByType(Pet);
         var _loc16_:int = int(_loc15_.length);
         var _loc17_:int = 0;
         while(_loc17_ < _loc16_)
         {
            if((_loc15_[_loc17_] as Pet).ownerID == Hero.userID && (_loc15_[_loc17_] as Pet).id == _loc3_)
            {
               _main.getConnectionManager().getPetAssembly().assemblePetStatus(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_);
               return;
            }
            _loc17_++;
         }
      }
   }
}

