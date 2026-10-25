package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class CannonNormalCostGroup
   {
      
      private var uiCache:FuiComponentSelectorCache;
      
      private var item_label:Label;
      
      private var item_bg_list:ItemList;
      
      private var item_list:Grid;
      
      private var cost_item_list:Grid;
      
      private var synthesis_btn:Button;
      
      private var selectItems:Vector.<HangarShipEquipmentInventoryItem>;
      
      private var _btn_label_key:String = "";
      
      public function CannonNormalCostGroup(param1:Sprite)
      {
         super();
         this.uiCache = new FuiComponentSelectorCache(param1);
         this.item_label = this.uiCache.selectComponent("item_labe") as Label;
         this.item_bg_list = this.uiCache.selectComponent("select_item_bg_list") as ItemList;
         this.item_list = this.uiCache.selectComponent("select_item_list") as Grid;
         this.cost_item_list = this.uiCache.selectComponent("cost_item_list") as Grid;
         this.synthesis_btn = this.uiCache.selectComponent("synthesis_btn") as Button;
         this.selectItems = new Vector.<HangarShipEquipmentInventoryItem>();
         if(this.synthesisBtn)
         {
            this.synthesisBtn.enabled = false;
         }
         this.cost_item_list.itemDataAssigner = CostItem;
         this.item_bg_list.itemDataAssigner = SelectedItemRenderer;
         this.item_list.itemDataAssigner = SelectedItemRenderer;
      }
      
      public function get costItemList() : Grid
      {
         return this.cost_item_list;
      }
      
      public function get itemList() : Grid
      {
         return this.item_list;
      }
      
      public function get itemListBg() : ItemList
      {
         return this.item_bg_list;
      }
      
      public function get synthesisBtn() : Button
      {
         return this.synthesis_btn;
      }
      
      public function get selectCount() : int
      {
         return this.selectItems.length;
      }
      
      public function isMax() : Boolean
      {
         if(!this.selectItems || !this.itemListBg || !this.itemListBg.list || this.itemListBg.list.length <= 0)
         {
            return false;
         }
         return this.selectItems.length >= this.itemListBg.list.length;
      }
      
      public function addItem(param1:HangarShipEquipmentInventoryItem) : void
      {
         this.selectItems.push(param1);
         this.item_list.list = new VectorCollection(this.selectItems);
         this.setBtnStatus();
      }
      
      public function removeItem(param1:int) : void
      {
         var _loc3_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.selectItems.length)
         {
            _loc3_ = this.selectItems[_loc2_];
            if(_loc3_.itemid == param1)
            {
               this.selectItems.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         this.item_list.list = new VectorCollection(this.selectItems);
         this.setBtnStatus();
      }
      
      public function clean() : void
      {
         this.selectItems = new Vector.<HangarShipEquipmentInventoryItem>();
         if(this.costItemList)
         {
            this.costItemList.list = new VectorCollection([]);
         }
         if(this.itemList)
         {
            this.itemList.list = new VectorCollection(this.selectItems);
         }
         if(Boolean(this.itemListBg) && !this.itemListBg.list)
         {
            this.itemListBg.list = new VectorCollection([]);
         }
         this.setBtnStatus();
      }
      
      public function set btn_label_key(param1:String) : void
      {
         this._btn_label_key = param1;
      }
      
      public function isEnough() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:CostItem = null;
         if(!this.cost_item_list || !this.cost_item_list.list || this.cost_item_list.list.length <= 0)
         {
            return true;
         }
         if(this.cost_item_list.itemsContainer)
         {
            _loc1_ = 0;
            while(_loc1_ < this.cost_item_list.list.length)
            {
               _loc2_ = this.cost_item_list.itemsContainer.getChildAt(_loc1_) as CostItem;
               if(Boolean(_loc2_) && Boolean(_loc2_.data))
               {
                  if(!_loc2_.isEnough)
                  {
                     return false;
                  }
               }
               _loc1_++;
            }
         }
         return true;
      }
      
      public function hasAdvancedItem() : Boolean
      {
         var _loc2_:HangarShipEquipmentInventoryItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.selectItems.length)
         {
            _loc2_ = this.selectItems[_loc1_];
            if(this.getItemLevel(_loc2_) > 1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function hasStarItem() : Boolean
      {
         var _loc2_:HangarShipEquipmentInventoryItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.selectItems.length)
         {
            _loc2_ = this.selectItems[_loc1_];
            if(_loc2_.star > 0)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function getItemLevel(param1:HangarShipEquipmentInventoryItem) : int
      {
         var _loc5_:String = null;
         var _loc2_:int = param1.level ? _loc2_ : 1;
         var _loc3_:int = 1;
         var _loc4_:int = 0;
         while(_loc4_ < param1.UpgradeLevel.length)
         {
            _loc5_ = param1.UpgradeLevel[_loc4_];
            _loc3_ = int(_loc5_.split(",")[1]);
            _loc4_++;
         }
         return Math.max(_loc2_,_loc3_);
      }
      
      public function getItemIds(param1:Vector.<Number>) : void
      {
         var _loc3_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.selectItems.length)
         {
            _loc3_ = this.selectItems[_loc2_];
            param1.push(_loc3_.itemid);
            _loc2_++;
         }
      }
      
      public function hasItem(param1:int) : Boolean
      {
         var _loc3_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.selectItems.length)
         {
            _loc3_ = this.selectItems[_loc2_];
            if(_loc3_.itemid == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function setBtnStatus() : void
      {
         if(!this.synthesisBtn)
         {
            return;
         }
         this.synthesisBtn.text = this._btn_label_key != "" ? BPLocale.getItemInCategory("",this._btn_label_key) : "";
         this.synthesisBtn.enabled = this.isMax() && this.isEnough();
      }
   }
}

