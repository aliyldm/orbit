package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.com.module.CombatMusicCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class CombatMusicHandler extends BaseHandler
   {
      
      public function CombatMusicHandler()
      {
         super();
      }
      
      public static function run(param1:CombatMusicCommand) : void
      {
         switch(param1.combatEvent)
         {
            case CombatMusicCommand.COMBATEVENT_COMBAT_START:
               Settings.combatMusicActive.value = true;
               break;
            case CombatMusicCommand.COMBATEVENT_COMBAT_END:
               Settings.combatMusicActive.value = false;
         }
      }
   }
}

