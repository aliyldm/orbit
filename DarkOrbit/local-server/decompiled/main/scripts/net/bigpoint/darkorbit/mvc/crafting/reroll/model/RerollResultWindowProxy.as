package net.bigpoint.darkorbit.mvc.crafting.reroll.model
{
   import net.bigpoint.darkorbit.com.module.UnstableModuleRestabilizeResultCommand;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryModel;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class RerollResultWindowProxy extends SimpleWindowProxy
   {
      
      protected var _inventory:InventoryModel;
      
      public function RerollResultWindowProxy(param1:String)
      {
         super(param1,new RerollResultWindowData());
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._inventory = (retrieveProxy(InventoryProxy.NAME) as InventoryProxy).inventory;
      }
      
      public function get rerollResultData() : RerollResultWindowData
      {
         return data as RerollResultWindowData;
      }
      
      public function updateResults(param1:UnstableModuleRestabilizeResultCommand) : void
      {
         this.rerollResultData.updateResult(param1,this._inventory);
      }
   }
}

