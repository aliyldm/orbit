package net.bigpoint.darkorbit.net
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AbilityStartCommand;
   import net.bigpoint.darkorbit.com.module.AbilityStopCommand;
   import net.bigpoint.darkorbit.net.models.AbilitiesLogUtil;
   
   public class AbilityButtonAssembly extends BaseAssembly
   {
      
      private static var instance:AbilityButtonAssembly;
      
      public function AbilityButtonAssembly(param1:Function)
      {
         super();
         if(param1 !== hidden)
         {
            throw new Error("AbilityButtonAssembly is a Singleton and can only be accessed through AbilityButtonAssembly.getInstance()");
         }
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : AbilityButtonAssembly
      {
         if(instance == null)
         {
            instance = new AbilityButtonAssembly(hidden);
         }
         return instance;
      }
      
      public function assembleFlashAbilityButton(param1:AbilityStartCommand) : void
      {
         var _loc2_:int = param1.selectedAbilityId;
         if(param1.activatorId == Hero.userID)
         {
            AbilitiesLogUtil.logHeroMessage(_loc2_,true);
         }
         else
         {
            AbilitiesLogUtil.logNonHeroMessage(_loc2_,true);
         }
      }
      
      public function assembleStopFlashAbilityButton(param1:AbilityStopCommand) : void
      {
         if(param1.activatorId == Hero.userID)
         {
            AbilitiesLogUtil.logHeroMessage(param1.selectedAbilityId,false);
         }
         else
         {
            AbilitiesLogUtil.logNonHeroMessage(param1.selectedAbilityId,false);
         }
      }
   }
}

