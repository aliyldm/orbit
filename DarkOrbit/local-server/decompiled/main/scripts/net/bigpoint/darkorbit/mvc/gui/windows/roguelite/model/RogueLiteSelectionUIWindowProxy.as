package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model
{
   import net.bigpoint.darkorbit.com.module.RogueLiteSelectShipCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class RogueLiteSelectionUIWindowProxy extends SimpleWindowProxy
   {
      
      public function RogueLiteSelectionUIWindowProxy(param1:String)
      {
         super(param1,new RogueLiteSelectionUIData());
      }
      
      public function get viewData() : RogueLiteSelectionUIData
      {
         return data as RogueLiteSelectionUIData;
      }
      
      public function updateShipList(param1:RogueLiteSelectShipCommand) : void
      {
         this.viewData.updateShipList(param1);
      }
   }
}

