package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CraftingCleanupCommand extends DOAbstractSimpleCommand
   {
      
      public function CraftingCleanupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:AssemblyProxy = retrieveProxy(AssemblyProxy.NAME) as AssemblyProxy;
         if(_loc2_)
         {
            _loc2_.cleanup();
         }
         var _loc3_:UpgradeProxy = retrieveProxy(UpgradeProxy.NAME) as UpgradeProxy;
         if(_loc3_)
         {
            _loc3_.cleanup();
         }
         var _loc4_:DisassemblyProxy = retrieveProxy(DisassemblyProxy.NAME) as DisassemblyProxy;
         if(_loc4_)
         {
            _loc4_.cleanup();
         }
      }
   }
}

