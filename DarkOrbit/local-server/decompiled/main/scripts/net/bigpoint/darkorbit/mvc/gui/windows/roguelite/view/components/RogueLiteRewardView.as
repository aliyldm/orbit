package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteInventoryItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RogueLiteRewardView implements ITabItem
   {
      
      public const rewardSelected:ISignal = new Signal(String);
      
      private const _borderSize:int = 2;
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function RogueLiteRewardView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.rewards") as Coreponent;
         this.rewardList.itemDataAssigner = RogueLiteRewardAssigner;
         this.rewardList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onRewardSelected);
         this.showContainer = false;
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_bounty";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      private function get activeContainer() : Coreponent
      {
         return this._cache.selectComponent("root.rewards.active") as Coreponent;
      }
      
      private function get inactiveContainer() : Coreponent
      {
         return this._cache.selectComponent("root.rewards.inactive") as Coreponent;
      }
      
      public function set showContainer(param1:Boolean) : void
      {
         this.activeContainer.visible = param1;
         this.inactiveContainer.visible = !param1;
         if(!param1)
         {
            this.rewardList.clearList();
         }
      }
      
      public function get rewardList() : ItemList
      {
         return this._cache.selectComponent("root.rewards.active.rewards_list") as ItemList;
      }
      
      public function set list(param1:Object) : void
      {
         this.rewardList.list = new VectorCollection(param1);
         this.rewardList.width = this.rewardList.list.length * this.rewardList.itemWidth + (this.rewardList.list.length - 1) * this.rewardList.itemGap + this._borderSize;
         this.rewardList.alignX = "center";
         this.enableListMouse = true;
      }
      
      public function get selectedItem() : Object
      {
         return this.rewardList.selectedItemData;
      }
      
      private function set enableListMouse(param1:Boolean) : void
      {
         this.rewardList.mouseEnabled = param1;
         this.rewardList.mouseChildren = param1;
      }
      
      public function selectPackageReward() : void
      {
         if(!this.rewardList.list)
         {
            return;
         }
         this.enableListMouse = false;
         this.rewardSelected.dispatch((this.rewardList.list.getItemAt(0) as RogueLiteInventoryItemVO).itemVO.lootID);
      }
      
      private function onRewardSelected(param1:ItemListEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:RogueLiteRewardAssigner = null;
         for each(_loc2_ in this.rewardList.itemsContainer.getAllCoreponentChildren())
         {
            if(_loc2_ is RogueLiteRewardAssigner)
            {
               _loc3_ = _loc2_ as RogueLiteRewardAssigner;
               _loc3_.alpha = _loc3_.isSelected() ? 1 : 0.3;
            }
         }
         this.enableListMouse = false;
         this.rewardSelected.dispatch((param1.itemVO as RogueLiteInventoryItemVO).itemVO.lootID);
      }
   }
}

