package net.bigpoint.darkorbit.mvc.global.contorl
{
   import net.bigpoint.darkorbit.delete_in_eic.InventoryCleanupCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.control.CraftingCleanupCommand;
   import net.bigpoint.darkorbit.mvc.groupsystem.control.GroupSystemCleanupCommand;
   import org.puremvc.as3.multicore.patterns.command.MacroCommand;
   
   public class OnConnectionLostMacroCommand extends MacroCommand
   {
      
      public function OnConnectionLostMacroCommand()
      {
         super();
      }
      
      override protected function initializeMacroCommand() : void
      {
         addSubCommand(GroupSystemCleanupCommand);
         addSubCommand(InventoryCleanupCommand);
         addSubCommand(CraftingCleanupCommand);
         addSubCommand(CloseAlienHuntWindow);
         addSubCommand(DisconnectChatCommand);
      }
   }
}

