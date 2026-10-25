package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import net.bigpoint.darkorbit.com.module.AssemblySetFilterRequest;
   import net.bigpoint.darkorbit.com.module.AssemblyWindowSettingsModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.RecipeUserSettingsFilterProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SaveAssemblyFilterSettingsCommand extends SimpleCommand
   {
      
      public function SaveAssemblyFilterSettingsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:RecipeUserSettingsFilterProxy = facade.retrieveProxy(RecipeUserSettingsFilterProxy.NAME) as RecipeUserSettingsFilterProxy;
         var _loc3_:ItemFilterSettingsVO = _loc2_.filterSettingsVO;
         var _loc4_:Vector.<String> = _loc3_.getAllSelectedCategoriesAsVector();
         var _loc5_:AssemblyWindowSettingsModule = new AssemblyWindowSettingsModule();
         _loc5_.assemblyItemFilters = _loc4_;
         var _loc6_:AssemblySetFilterRequest = new AssemblySetFilterRequest(_loc5_,AssemblySetFilterRequest.FILTERTYPE_ASSEMBLY);
         var _loc7_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc7_.sendNettyRequest(_loc6_);
      }
   }
}

