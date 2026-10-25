package net.bigpoint.darkorbit.mvc.crafting.disassembly.view.comps
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeTargetTypeListAssigner;
   
   public class DisassemblyTargetTypeView
   {
      
      private var _view:FuiComponentSelectorCache;
      
      public function DisassemblyTargetTypeView(param1:Container)
      {
         super();
         this._view = new FuiComponentSelectorCache(param1);
         this.upgradeTargetTypeList.itemDataAssigner = UpgradeTargetTypeListAssigner;
      }
      
      public function get upgradeTargetTypeList() : ItemList
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.itemListContainer.disassemblyTargetTypeList") as ItemList;
      }
      
      public function get upgradeTargetListLeft() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.itemListContainer.left") as Button;
      }
      
      public function get upgradeTargetListRight() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.itemListContainer.right") as Button;
      }
   }
}

