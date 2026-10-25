package net.bigpoint.darkorbit.mvc.crafting.reroll.model
{
   import net.bigpoint.darkorbit.com.module.RerollWindowSettingsModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   import net.bigpoint.darkorbit.com.module.UnstableModuleRecycleResultCommand;
   import net.bigpoint.darkorbit.com.module.UnstableModulesListCommand;
   import net.bigpoint.darkorbit.com.module.UnstableModulesShardCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class RerollProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "RerollProxy";
      
      public function RerollProxy()
      {
         super(NAME,new RerollUIData());
      }
      
      private function get viewData() : RerollUIData
      {
         return data as RerollUIData;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
      }
      
      public function updateInfo(param1:UnstableModulesListCommand) : void
      {
         this.viewData.updateInfo(param1);
      }
      
      public function updateShardsAmount(param1:UnstableModulesShardCommand) : void
      {
         this.viewData.updateShardsAmount(param1);
      }
      
      public function updateModuleInfo(param1:UnstableModuleModule) : void
      {
         this.viewData.updateModuleInfo(param1);
      }
      
      public function updateRecycleResult(param1:UnstableModuleRecycleResultCommand) : void
      {
         this.viewData.updateRecycleResult(param1);
      }
      
      public function updateRerollWindowSettings(param1:RerollWindowSettingsModule) : void
      {
         this.viewData.updateRerollWindowSettings(param1);
      }
      
      public function resetPopup() : void
      {
         this.viewData.restabilizePending = false;
      }
   }
}

