package net.bigpoint.darkorbit.equipment.view.components.items
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.utils.TextFormatter;
   
   public class PopUpGridSellComponent extends GridComponent
   {
      
      public static const DIVISION_SUFFIXES:Array = ["","_kilo","_mega","_giga","_tera","_peta","_exa"];
      
      private var _multiSelectTotal:int = 0;
      
      private var _gridItems:Array;
      
      private var _divisionPower:int = 0;
      
      private var _divisionQuotient:int = 1;
      
      public function PopUpGridSellComponent(param1:Boolean)
      {
         super(param1);
      }
      
      public function get GridItems() : Array
      {
         return this._gridItems;
      }
      
      override public function addDragListeners(param1:Array) : void
      {
      }
      
      override public function removeDragListeners(param1:Array) : void
      {
      }
      
      override public function addGridToMultiSelector() : void
      {
      }
      
      override public function createGridMenu(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:Array = null;
         var _loc6_:InventoryItemComponent = null;
         super.createGridMenu(param1,param2);
         _loc3_ = iconsInThisMenu;
         var _loc4_:uint = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc6_.multiSellItem = true;
            dragComp.removeDraggableIcon(_loc3_[_loc5_]);
            _loc5_++;
         }
         this.resetValues();
      }
      
      protected function resetValues() : void
      {
         this._gridItems = [];
         this._multiSelectTotal = 0;
         this._divisionPower = 0;
         this._divisionQuotient = 1;
      }
      
      override public function placeSingleItem(param1:ItemInstanceVO, param2:int = -1) : void
      {
         super.placeSingleItem(param1,param2);
         var _loc3_:int = param1.level;
         var _loc4_:int = 0;
         if(param1.hasPetGearModifier())
         {
            _loc4_ = int(param1.itemInfo.saleValuesByLevel[_loc3_ + "X"]);
         }
         else
         {
            _loc4_ = int(param1.itemInfo.saleValuesByLevel[_loc3_]);
         }
         var _loc5_:int = this._multiSelectTotal + _loc4_;
         if(_loc5_ <= 0)
         {
            this._multiSelectTotal = Math.floor(this._multiSelectTotal / 1000);
            this._divisionQuotient = Math.pow(1000,++this._divisionPower);
            _loc4_ = Math.floor(_loc4_ / this._divisionQuotient);
         }
         this._multiSelectTotal += _loc4_;
         this._gridItems.push(param1);
      }
      
      public function getMultiSelectPriceTotalText() : String
      {
         if(this._divisionPower >= PopUpGridSellComponent.DIVISION_SUFFIXES.length)
         {
            this._divisionPower = PopUpGridSellComponent.DIVISION_SUFFIXES.length - 1;
         }
         var _loc1_:String = PopUpGridSellComponent.DIVISION_SUFFIXES[this._divisionPower];
         return BPLocale.getItem("pricetag_credits_compact" + _loc1_).replace("%VALUE%",TextFormatter.round(this._multiSelectTotal));
      }
   }
}

