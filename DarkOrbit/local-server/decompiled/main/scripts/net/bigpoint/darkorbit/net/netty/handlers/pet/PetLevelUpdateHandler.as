package net.bigpoint.darkorbit.net.netty.handlers.pet
{
   import net.bigpoint.darkorbit.com.module.PetLevelUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class PetLevelUpdateHandler extends BaseHandler
   {
      
      public function PetLevelUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:PetLevelUpdateCommand) : void
      {
         _main.getConnectionManager().getPetAssembly().assembleLevelUp(param1.petLevel,param1.petExperiencePointsUntilNextLevel,param1.designId,param1.expansionStage);
      }
   }
}

