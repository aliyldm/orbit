package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo
{
   import net.bigpoint.darkorbit.com.module.porting.TupleTwoModule;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class WarpControlsItemData
   {
      
      public static const BASE_DAMAGE:String = "baseDamage";
      
      private var _viweName:String;
      
      private var _setId:int = 0;
      
      private var _itemVo:HangarShipEquipmentInventoryItem = null;
      
      private var _configVo:ItemVO;
      
      public function WarpControlsItemData(param1:String, param2:HangarShipEquipmentInventoryItem = null)
      {
         super();
         this._viweName = param1;
         this._itemVo = param2;
         if(this._itemVo)
         {
            this._configVo = ItemDataProviderHelper.getItem(this._itemVo.lootId);
         }
      }
      
      public function get viewName() : String
      {
         return this._viweName;
      }
      
      public function get itemVo() : HangarShipEquipmentInventoryItem
      {
         return this._itemVo;
      }
      
      public function get configVo() : ItemVO
      {
         return this._configVo;
      }
      
      public function get baseDamage() : String
      {
         var _loc3_:TupleTwoModule = null;
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._itemVo.extAttributes.length)
         {
            _loc3_ = this._itemVo.extAttributes[_loc2_];
            if(_loc3_.param0 == BASE_DAMAGE)
            {
               _loc1_ = parseInt(_loc3_.param1);
            }
            _loc2_++;
         }
         return Math.round(this.configVo.item.attributes.damage + _loc1_ / 100 * this.configVo.item.attributes.damage).toString();
      }
   }
}

