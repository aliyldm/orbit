package net.bigpoint.darkorbit.mvc.crafting.upgrade.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.items.utils.ItemFilter;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class UpgradeTypeUserSettingsFilterProxy extends Proxy
   {
      
      public static const NAME:String = "UpgradeTypeUserSettingsFilterProxy";
      
      protected var _filterSettingsVO:ItemFilterSettingsVO;
      
      public function UpgradeTypeUserSettingsFilterProxy()
      {
         super(NAME);
         this.initSettings();
         ItemFilterTypes.initialize();
      }
      
      protected function initSettings() : void
      {
         this._filterSettingsVO = new ItemFilterSettingsVO(ItemFilter.getFilterByType(ItemFilter.FILTER_TYPE_UPGRADE),"UPGRADE");
      }
      
      public function get filterSettingsVO() : ItemFilterSettingsVO
      {
         return this._filterSettingsVO;
      }
      
      public function filter(param1:Vector.<UpgradeTypeModel>) : Vector.<UpgradeTypeModel>
      {
         return this.filterItems(param1,this._filterSettingsVO.getAllSelectedItemTypes());
      }
      
      protected function filterItems(param1:Vector.<UpgradeTypeModel>, param2:Dictionary) : Vector.<UpgradeTypeModel>
      {
         var _loc6_:UpgradeTypeModel = null;
         var _loc3_:Vector.<UpgradeTypeModel> = new Vector.<UpgradeTypeModel>();
         var _loc4_:uint = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            if(Boolean(param2[_loc6_.targetItemType.typeClass]) || Boolean(param2[_loc6_.targetItemType.typeClass + "." + _loc6_.targetItemType.typeValue]))
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc3_;
      }
   }
}

