package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetExperiencePointsUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetExperiencePointsUpdateHandler extends BaseHandler
   {
      
      public function PetExperiencePointsUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:PetExperiencePointsUpdateCommand) : void
      {
         var _loc2_:int = param1.currentExperiencePoints;
         var _loc3_:int = param1.maxExperiencePoints;
         _main.getConnectionManager().getPetAssembly().assemblePetXPInfo(_loc2_,_loc3_);
      }
   }
}

