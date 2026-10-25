package net.bigpoint.darkorbit.mvc.crafting.disassembly.view.comps
{
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class DisassemblyView
   {
      
      private var _targetTypeComponents:DisassemblyTargetTypeView;
      
      private var _targetGridComponents:DisassemblyTargetGridView;
      
      private var _targetBuildComponents:DisassemblyTargetInteractionView;
      
      private var _view:FuiComponentSelectorCache;
      
      public function DisassemblyView(param1:Container)
      {
         super();
         this._view = new FuiComponentSelectorCache(param1);
         this._targetTypeComponents = new DisassemblyTargetTypeView(param1);
         this._targetGridComponents = new DisassemblyTargetGridView(param1);
         this._targetBuildComponents = new DisassemblyTargetInteractionView(param1);
      }
      
      public function get standardViewContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer") as Container;
      }
      
      public function get filterEmptyItemsContainer() : Container
      {
         return this._view.selectComponent("contentContainer.filterEmptyItemsContainer") as Container;
      }
      
      public function get targetTypeComponents() : DisassemblyTargetTypeView
      {
         return this._targetTypeComponents;
      }
      
      public function get targetGridComponents() : DisassemblyTargetGridView
      {
         return this._targetGridComponents;
      }
      
      public function get targetBuildComponents() : DisassemblyTargetInteractionView
      {
         return this._targetBuildComponents;
      }
   }
}

