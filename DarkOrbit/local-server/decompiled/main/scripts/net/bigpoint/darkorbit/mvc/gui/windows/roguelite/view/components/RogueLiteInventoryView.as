package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.items.item.vo.AcceptedType;
   import net.bigpoint.darkorbit.items.item.vo.Slot;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteInventoryItemVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RogueLiteInventoryView implements ITabItem
   {
      
      public const tabSelected:ISignal = new Signal();
      
      private const _borderSize:int = 2;
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _maxSlot:BindableInt = new BindableInt(0,0);
      
      private var _selectedItems:Vector.<RogueLiteInventoryItemVO> = new Vector.<RogueLiteInventoryItemVO>(0);
      
      public function RogueLiteInventoryView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.inventory") as Coreponent;
         this.tabList.itemDataAssigner = RogueLiteInventoryTypeAssigner;
         this.tabList.addEventListener(ItemListEvent.ITEMS_SELECTION_CHANGED,this.onChangeInventoryTab);
         this.tabList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.onChangeInventoryTab);
         this.filteredList.allowDeselection = true;
         this.filteredList.itemDataAssigner = RogueLiteInventoryItemAssigner;
         this.filteredList.addEventListener(ItemListEvent.CLICKED,this.onInventoryItemClicked);
         this.showContainer(false);
         this.disableOverlay.visible = false;
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_manage";
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
         return this._cache.selectComponent("root.inventory.active") as Coreponent;
      }
      
      private function get inactiveContainer() : Coreponent
      {
         return this._cache.selectComponent("root.inventory.inactive") as Coreponent;
      }
      
      public function showContainer(param1:Boolean, param2:Boolean = false) : void
      {
         this.activeContainer.visible = param1 && param2;
         this.inactiveContainer.visible = !param1 || !param2;
      }
      
      private function get disableOverlay() : Coreponent
      {
         return this._cache.selectComponent("root.inventory.active.overlay") as Coreponent;
      }
      
      public function get tabList() : ItemList
      {
         return this._cache.selectComponent("root.inventory.active.tab_list") as ItemList;
      }
      
      public function set tabSelection(param1:Vector.<ItemVO>) : void
      {
         this.tabList.list = new VectorCollection(param1);
         this.tabList.width = this.tabList.list.length * this.tabList.itemWidth + (this.tabList.list.length - 1) * this.tabList.itemGap + this._borderSize;
         this.tabList.alignX = "center";
         this.tabList.forceRedraw();
         this.tabList.selectedIndex = 0;
      }
      
      private function get selectedTab() : RogueLiteInventoryTypeAssigner
      {
         return this.tabList.selectedItem as RogueLiteInventoryTypeAssigner;
      }
      
      private function onChangeInventoryTab(param1:ItemListEvent) : void
      {
         var _loc2_:ItemVO = param1.itemVO as ItemVO;
         if(_loc2_ == null)
         {
            return;
         }
         this.tabSelected.dispatch();
      }
      
      private function get infoLabel() : Label
      {
         return this._cache.selectComponent("root.inventory.active.info") as Label;
      }
      
      private function updateInfo() : void
      {
         var _loc1_:String = this.selectedTab ? this.selectedTab.tooltipData.toString() : "";
         _loc1_ += ": " + TextFormatter.roundInteger(this.selectedCount);
         _loc1_ += "/" + TextFormatter.roundInteger(this._maxSlot.value);
         this.infoLabel.text = _loc1_;
      }
      
      private function get selectedCount() : Number
      {
         return this._selectedItems ? this._selectedItems.length : 0;
      }
      
      private function updateMaxSlot() : void
      {
         var _loc2_:Slot = null;
         var _loc3_:AcceptedType = null;
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem(Hero.shipType);
         if(Boolean(_loc1_) && Boolean(this.selectedTab))
         {
            loop0:
            for each(_loc2_ in _loc1_.getSlots())
            {
               var _loc6_:int = 0;
               var _loc7_:* = _loc2_.acceptedTypes;
               do
               {
                  for each(_loc3_ in _loc7_)
                  {
                  }
                  continue loop0;
               }
               while(_loc3_.classname.indexOf(this.selectedTab.VO.getItemType()) < 0);
               this._maxSlot.value = _loc2_.size;
               return;
            }
         }
         this._maxSlot.value = 0;
      }
      
      private function get inventoryContainer() : Container
      {
         return this._cache.selectComponent("root.inventory.active.inventory") as Container;
      }
      
      public function get filteredList() : Grid
      {
         return this._cache.selectComponent("root.inventory.active.inventory.filtered_list") as Grid;
      }
      
      public function set filteredInventory(param1:Vector.<RogueLiteInventoryItemVO>) : void
      {
         this.filteredList.list = new VectorCollection(param1);
         this.filteredList.itemAlignX = "left";
         this.resetInventory();
      }
      
      private function onInventoryItemClicked(param1:ItemListEvent) : void
      {
         var _loc4_:RogueLiteInventoryItemVO = null;
         var _loc2_:RogueLiteInventoryItemVO = param1.itemVO as RogueLiteInventoryItemVO;
         if(_loc2_ == null)
         {
            return;
         }
         if(!_loc2_.equipped)
         {
            if(this.selectedCount > 0 && this.selectedCount == this._maxSlot.value)
            {
               return;
            }
            if(_loc2_.isUnstableModule)
            {
               for each(_loc4_ in this._selectedItems)
               {
                  if(_loc4_.itemVO.id != _loc2_.itemVO.id && _loc4_.itemVO.typeValue.indexOf(_loc2_.itemVO.typeValue) >= 0)
                  {
                     return;
                  }
               }
            }
         }
         _loc2_.equipped = !_loc2_.equipped;
         var _loc3_:int = this._selectedItems.indexOf(_loc2_);
         if(_loc2_.equipped && _loc3_ < 0)
         {
            this._selectedItems.push(_loc2_);
         }
         else if(!_loc2_.equipped && this._selectedItems.indexOf(_loc2_) >= 0)
         {
            this._selectedItems.splice(_loc3_,1);
         }
         this.updateInfo();
         this.enableConfigBtns = true;
      }
      
      public function get resetBtn() : Button
      {
         return this._cache.selectComponent("root.inventory.active.reset") as Button;
      }
      
      public function resetInventory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RogueLiteInventoryItemVO = null;
         this._selectedItems = new Vector.<RogueLiteInventoryItemVO>(0);
         this.inventoryContainer.visible = !(this.filteredList.list == null || this.filteredList.list.length == 0);
         if(this.inventoryContainer.visible)
         {
            _loc1_ = 0;
            while(_loc1_ < this.filteredList.list.length)
            {
               _loc2_ = this.filteredList.list.getItemAt(_loc1_) as RogueLiteInventoryItemVO;
               if(_loc2_)
               {
                  _loc2_.reset();
                  if(_loc2_.equipped)
                  {
                     this._selectedItems.push(_loc2_);
                  }
               }
               _loc1_++;
            }
         }
         this.updateMaxSlot();
         this.updateInfo();
         this.enableConfigBtns = false;
      }
      
      public function get saveBtn() : Button
      {
         return this._cache.selectComponent("root.inventory.active.save") as Button;
      }
      
      public function set enableConfigBtns(param1:Boolean) : void
      {
         this.resetBtn.enabled = param1;
         this.saveBtn.enabled = param1;
         if(this.selectedCount > this._maxSlot.value)
         {
            this.saveBtn.enabled = false;
         }
      }
      
      public function set enableInventoryItemMouse(param1:Boolean) : void
      {
         if(!this.activeContainer.visible)
         {
            return;
         }
         this.filteredList.mouseChildren = param1;
         this.enableConfigBtns = param1;
         this.disableOverlay.visible = !param1;
      }
   }
}

