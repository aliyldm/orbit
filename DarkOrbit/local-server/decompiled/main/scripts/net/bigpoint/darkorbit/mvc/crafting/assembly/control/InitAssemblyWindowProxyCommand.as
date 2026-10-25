package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.RecipeUserSettingsFilterProxy;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.filter.DisassembleUserSettingsFilterProxy;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.model.HyperforgeProxy;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeUserSettingsFilterProxy;
   import net.bigpoint.darkorbit.mvc.discount.model.DiscountProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitAssemblyWindowProxyCommand extends DOAbstractAsyncCommand
   {
      
      public function InitAssemblyWindowProxyCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.removeCommand(param1.getName());
         if(!hasProxy(RecipeUserSettingsFilterProxy.NAME))
         {
            registerProxy(new RecipeUserSettingsFilterProxy());
         }
         if(!hasProxy(UpgradeTypeUserSettingsFilterProxy.NAME))
         {
            registerProxy(new UpgradeTypeUserSettingsFilterProxy());
         }
         if(!hasProxy(DisassembleUserSettingsFilterProxy.NAME))
         {
            registerProxy(new DisassembleUserSettingsFilterProxy());
         }
         if(!hasProxy(InventoryProxy.NAME))
         {
            registerProxy(new InventoryProxy());
         }
         if(!hasProxy(DiscountProxy.NAME))
         {
            registerProxy(new DiscountProxy());
         }
         registerProxy(new AssemblyProxy());
         registerProxy(new UpgradeProxy());
         registerProxy(new DisassemblyProxy());
         registerProxy(new RerollProxy());
         registerProxy(new HyperforgeProxy());
         commandComplete();
      }
   }
}

