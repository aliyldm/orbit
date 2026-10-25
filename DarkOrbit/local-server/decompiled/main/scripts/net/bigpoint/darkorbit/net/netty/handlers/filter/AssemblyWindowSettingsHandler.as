package net.bigpoint.darkorbit.net.netty.handlers.filter
{
   import net.bigpoint.darkorbit.com.module.AssemblyWindowSettingsModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.RecipeUserSettingsFilterProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeUserSettingsFilterProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AssemblyWindowSettingsHandler extends DOAbstractSimpleCommand
   {
      
      public function AssemblyWindowSettingsHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:AssemblyWindowSettingsModule = param1.getBody() as AssemblyWindowSettingsModule;
         if(_loc2_.filterType == AssemblyWindowSettingsModule.FILTERTYPE_ASSEMBLY)
         {
            this.setAssemblyFilterSettings(_loc2_.assemblyItemFilters);
         }
         else if(_loc2_.filterType == AssemblyWindowSettingsModule.FILTERTYPE_UPGRADE)
         {
            this.setUpgradeFilterSettings(_loc2_.assemblyItemFilters);
         }
      }
      
      protected function setAssemblyFilterSettings(param1:Vector.<String>) : void
      {
         var _loc2_:RecipeUserSettingsFilterProxy = facade.retrieveProxy(RecipeUserSettingsFilterProxy.NAME) as RecipeUserSettingsFilterProxy;
         if(!_loc2_)
         {
            registerProxy(_loc2_ = new RecipeUserSettingsFilterProxy());
         }
         var _loc3_:ItemFilterSettingsVO = _loc2_.filterSettingsVO;
         _loc3_.setFilterSelectionByCategories(param1);
      }
      
      protected function setUpgradeFilterSettings(param1:Vector.<String>) : void
      {
         var _loc2_:UpgradeTypeUserSettingsFilterProxy = facade.retrieveProxy(UpgradeTypeUserSettingsFilterProxy.NAME) as UpgradeTypeUserSettingsFilterProxy;
         if(!_loc2_)
         {
            registerProxy(_loc2_ = new UpgradeTypeUserSettingsFilterProxy());
         }
         var _loc3_:ItemFilterSettingsVO = _loc2_.filterSettingsVO;
         _loc3_.setFilterSelectionByCategories(param1);
      }
   }
}

