package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.control.CreateDisassemblyWindowCommand;
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.control.CreateHyperforgeWindowCommand;
   import net.bigpoint.darkorbit.mvc.crafting.overview.control.CreateCraftingOverviewWindowCommand;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.control.CreateRerollWindowCommand;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.control.CreateUpgradeWindowCommand;
   import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
   
   public class InitAssemblySystemCommand extends AsyncMacroCommand
   {
      
      public function InitAssemblySystemCommand()
      {
         super();
      }
      
      override protected function initializeAsyncMacroCommand() : void
      {
         super.initializeAsyncMacroCommand();
         addSubCommand(InitAssemblyWindowProxyCommand);
         addSubCommand(CreateCraftingOverviewWindowCommand);
         addSubCommand(CreateAssemblyWindowCommand);
         addSubCommand(CreateUpgradeWindowCommand);
         addSubCommand(CreateDisassemblyWindowCommand);
         addSubCommand(CreateRerollWindowCommand);
         addSubCommand(CreateHyperforgeWindowCommand);
      }
   }
}

