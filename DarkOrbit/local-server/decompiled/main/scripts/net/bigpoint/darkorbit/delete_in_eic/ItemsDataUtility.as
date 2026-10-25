package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.filecollection.FileCollection;
   import net.bigpoint.as3toolbox.filecollection.vo.FileVO;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.IDataReceptible;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.items.item.attributes.GeneralAttributes;
   import net.bigpoint.darkorbit.items.item.traits.UpgradableTrait;
   import net.bigpoint.darkorbit.items.item.vo.AcceptedType;
   import net.bigpoint.darkorbit.items.utils.ItemSortorder;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.as3commons.lang.StringUtils;
   
   public class ItemsDataUtility
   {
      
      private static var _itemSortInstance:ItemSort;
      
      private static const ATTRIBUTE_CATEGORY:String = "category";
      
      public function ItemsDataUtility()
      {
         super();
      }
      
      public static function transformItemListIntoItemMap(param1:Vector.<ItemVO>) : Dictionary
      {
         var _loc4_:ItemVO = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:uint = param1.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1[_loc5_];
            _loc2_[_loc4_.id] = _loc4_;
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function extractItemVOs(param1:Vector.<ICoreponent>) : Vector.<ItemVO>
      {
         var _loc4_:IDataReceptible = null;
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>();
         var _loc3_:uint = param1.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1[_loc5_] as IDataReceptible;
            _loc2_.push(_loc4_.data as ItemVO);
            _loc5_++;
         }
         return _loc2_;
      }
      
      public static function extractItemIDsFromItemVOs(param1:Vector.<ItemVO>) : Vector.<Number>
      {
         var _loc3_:ItemVO = null;
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_.id);
         }
         return _loc2_;
      }
      
      public static function filterItemsByClassTypes(param1:Vector.<ItemVO>, param2:Array) : Vector.<ItemVO>
      {
         var _loc6_:AcceptedType = null;
         var _loc3_:Vector.<ItemVO> = new Vector.<ItemVO>();
         var _loc4_:uint = param2.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param2[_loc5_];
            _loc3_ = _loc3_.concat(filterItemsByClassType(param1,_loc6_.classname));
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function filterItemsByClassType(param1:Vector.<ItemVO>, param2:String) : Vector.<ItemVO>
      {
         var _loc6_:ItemVO = null;
         var _loc3_:Vector.<ItemVO> = new Vector.<ItemVO>();
         var _loc4_:uint = param1.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_] as ItemVO;
            if(_loc6_.getItemType() == param2)
            {
               _loc3_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      protected static function splitItemVOListIntoItemTypeBasedDictionary(param1:Vector.<ItemVO>) : Dictionary
      {
         var _loc5_:ItemVO = null;
         var _loc6_:Vector.<ItemVO> = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_] as ItemVO;
            if(_loc5_)
            {
               if(_loc2_[_loc5_.typeClass] == null)
               {
                  _loc2_[_loc5_.typeClass] = new Vector.<ItemVO>();
               }
               _loc6_ = _loc2_[_loc5_.typeClass];
               _loc6_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      protected static function filterItemTypeGroups(param1:Dictionary, param2:Object) : Dictionary
      {
         var _loc4_:String = null;
         var _loc3_:Dictionary = new Dictionary();
         if(param2)
         {
            for(_loc4_ in param2)
            {
               if(param1[_loc4_])
               {
                  _loc3_[_loc4_] = param1[_loc4_];
               }
            }
         }
         else
         {
            _loc3_ = param1;
         }
         return _loc3_;
      }
      
      protected static function subdivideCPUTypedCategory(param1:Dictionary) : Dictionary
      {
         var _loc3_:String = null;
         var _loc4_:Vector.<ItemVO> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:ItemVO = null;
         var _loc8_:GeneralAttributes = null;
         var _loc9_:String = null;
         var _loc10_:Vector.<ItemVO> = null;
         var _loc2_:Dictionary = new Dictionary();
         for(_loc3_ in param1)
         {
            if(_loc3_ == ItemFilterTypes.CPUType)
            {
               _loc4_ = param1[_loc3_];
               _loc5_ = _loc4_.length;
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc7_ = _loc4_[_loc6_];
                  _loc8_ = _loc7_.item.attributes as GeneralAttributes;
                  _loc9_ = _loc3_ + "." + _loc8_[ATTRIBUTE_CATEGORY];
                  if(_loc2_[_loc9_] == null)
                  {
                     _loc2_[_loc9_] = new Vector.<ItemVO>();
                  }
                  _loc10_ = _loc2_[_loc9_] as Vector.<ItemVO>;
                  _loc10_.push(_loc7_);
                  _loc6_++;
               }
            }
            else
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
         }
         return _loc2_;
      }
      
      private static function filterWeakestItemVOsInCategoryDictionary(param1:Dictionary) : Dictionary
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<ItemVO> = null;
         var _loc4_:uint = 0;
         var _loc5_:ItemVO = null;
         var _loc6_:uint = 0;
         var _loc7_:ItemVO = null;
         var _loc8_:int = 0;
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_] as Vector.<ItemVO>;
            _loc4_ = 65564;
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               _loc7_ = _loc3_[_loc6_];
               _loc8_ = int(ItemSortorder.getSortIndexByLootID(_loc7_.lootID));
               if(_loc8_ < _loc4_)
               {
                  _loc4_ = uint(_loc8_);
                  _loc5_ = _loc7_;
               }
               _loc6_++;
            }
            param1[_loc2_] = _loc5_;
         }
         return param1;
      }
      
      public static function filterWeakestItemVOsByCategoryTypes(param1:Vector.<ItemVO>, param2:Object = null) : Vector.<ItemVO>
      {
         var _loc3_:Dictionary = null;
         var _loc5_:ItemVO = null;
         _loc3_ = splitItemVOListIntoItemTypeBasedDictionary(param1);
         _loc3_ = filterItemTypeGroups(_loc3_,param2);
         _loc3_ = subdivideCPUTypedCategory(_loc3_);
         _loc3_ = filterWeakestItemVOsInCategoryDictionary(_loc3_);
         var _loc4_:Vector.<ItemVO> = new Vector.<ItemVO>();
         for each(_loc5_ in _loc3_)
         {
            _loc4_.push(_loc5_);
         }
         return _loc4_;
      }
      
      public static function isItemWeaker(param1:ItemVO, param2:ItemVO) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:uint = ItemSortorder.getSortIndexByLootID(param1.lootID);
         var _loc5_:uint = ItemSortorder.getSortIndexByLootID(param2.lootID);
         if(_loc4_ == _loc5_)
         {
            _loc3_ = param1.upgradeLevel <= param2.upgradeLevel ? false : true;
         }
         else
         {
            _loc3_ = _loc4_ < _loc5_ ? true : false;
         }
         return _loc3_;
      }
      
      public static function get itemSort() : ItemSort
      {
         if(_itemSortInstance)
         {
            return _itemSortInstance;
         }
         return _itemSortInstance = new ItemSort();
      }
      
      public static function sort(param1:Vector.<ItemVO>, param2:String = null) : Vector.<ItemVO>
      {
         param2 = param2 ? param2 : ItemSort.SORT_BEHAVIOUR_ASC;
         return itemSort.sort(param1,param2);
      }
      
      public static function existItemWithType(param1:Vector.<ItemVO>, param2:String) : int
      {
         var _loc5_:ItemVO = null;
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_)
            {
               if(_loc5_.typeClass == param2)
               {
                  return _loc4_;
               }
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function existItemWithAttributeCategory(param1:Vector.<ItemVO>, param2:ItemVO) : int
      {
         var _loc5_:ItemVO = null;
         var _loc6_:GeneralAttributes = null;
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_)
            {
               _loc6_ = _loc5_.item.attributes;
               if(_loc6_)
               {
                  if(_loc6_.hasOwnProperty(ATTRIBUTE_CATEGORY))
                  {
                     if(_loc6_[ATTRIBUTE_CATEGORY] == param2.item.attributes[ATTRIBUTE_CATEGORY])
                     {
                        return _loc4_;
                     }
                  }
               }
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function existItemWithLootID(param1:Vector.<ItemVO>, param2:String) : int
      {
         var _loc5_:ItemVO = null;
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_)
            {
               if(_loc5_.lootID == param2)
               {
                  return _loc4_;
               }
            }
            _loc4_++;
         }
         return -1;
      }
      
      public static function getVideoURLbyLootId(param1:String, param2:String = null, param3:Boolean = true, param4:String = "ITEMS") : String
      {
         var _loc8_:String = null;
         var _loc9_:Vector.<FileVO> = null;
         var _loc10_:String = null;
         var _loc11_:FileVO = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc5_:String = param1;
         if(param3)
         {
            _loc5_ = _loc5_.substr(_loc5_.lastIndexOf("_") + 1,_loc5_.length);
         }
         if(param2 != null)
         {
            _loc5_ = _loc5_ + "-" + param2;
         }
         var _loc6_:FileCollection = (GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy).getFileCollectionByInstanceName(param4);
         var _loc7_:FileVO = null;
         if(_loc6_.listOfFiles[_loc5_] is FileVO)
         {
            _loc7_ = _loc6_.listOfFiles[_loc5_] as FileVO;
         }
         else if(_loc6_.listOfFiles[_loc5_] is Vector.<FileVO>)
         {
            _loc9_ = _loc6_.listOfFiles[_loc5_] as Vector.<FileVO>;
            _loc10_ = param1.substr(0,param1.indexOf(_loc5_) - 1);
            for each(_loc11_ in _loc9_)
            {
               if(StringUtils.endsWith(_loc11_.location.id,_loc10_))
               {
                  _loc7_ = _loc11_;
               }
            }
         }
         if(_loc7_)
         {
            _loc12_ = Settings.staticHost;
            _loc13_ = _loc7_.cdnHash;
            _loc14_ = _loc7_.id;
            _loc15_ = _loc7_.location.path;
            _loc8_ = _loc12_ + "/do_img/global/" + _loc15_ + _loc14_ + ".flv?__cv=" + _loc13_;
         }
         return _loc8_;
      }
      
      public static function getVideoURLbyItem(param1:Item, param2:String = null) : String
      {
         return getVideoURLbyLootId(param1.attributes.lootId,param1.attributes.isFractionDependent ? param2 || Hero.factionName : null);
      }
      
      public static function getMockList(param1:int = 100) : Vector.<ItemVO>
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         var _loc3_:Object = ItemDataProvider.items;
         var _loc4_:Vector.<String> = new Vector.<String>(0);
         for(_loc5_ in _loc3_)
         {
            _loc4_.push(_loc5_);
         }
         _loc6_ = 0;
         while(_loc6_ < param1)
         {
            _loc2_.push(ItemDataProviderHelper.getItem(_loc4_[int(Math.random() * (_loc4_.length - 1))]));
            _loc6_++;
         }
         return _loc2_;
      }
      
      public static function isMaxLevel(param1:ItemVO) : Boolean
      {
         var _loc2_:UpgradableTrait = param1.item.traits.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
         if(!_loc2_)
         {
            return true;
         }
         return param1.upgradeLevel >= _loc2_.levels;
      }
      
      public static function isMinLevel(param1:ItemVO) : Boolean
      {
         var _loc2_:UpgradableTrait = param1.item.traits.getTraitByType(TraitTypes.UPGRADABLE) as UpgradableTrait;
         if(!_loc2_)
         {
            return true;
         }
         return param1.upgradeLevel <= 0;
      }
      
      public static function getDisplayUpgradeLevel(param1:ItemVO) : int
      {
         return param1.upgradeLevel + 1;
      }
   }
}

import flash.utils.Dictionary;
import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
import net.bigpoint.darkorbit.items.item.attributes.BoosterAttributes;
import net.bigpoint.darkorbit.items.item.attributes.PaymentItemAttributes;
import net.bigpoint.darkorbit.items.utils.ItemSortorder;
import org.as3commons.lang.StringUtils;

class ItemSort
{
   
   public static const SORT_BEHAVIOUR_ASC:String = "asc";
   
   public static const SORT_BEHAVIOUR_DESC:String = "desc";
   
   public static const SORT_BEHAVIOUR_TARGETED_OFFERS:String = "SORT_BEHAVIOUR_TARGETED_OFFERS";
   
   private var const2FX:Dictionary;
   
   public function ItemSort()
   {
      super();
      ItemSortorder.initialize();
      this.const2FX = new Dictionary();
      this.const2FX[SORT_BEHAVIOUR_ASC] = this.sortBehaviourAscending;
      this.const2FX[SORT_BEHAVIOUR_DESC] = this.sortBehaviourDescending;
      this.const2FX[SORT_BEHAVIOUR_TARGETED_OFFERS] = this.sortTargetedOffers;
   }
   
   public function sort(param1:Vector.<ItemVO>, param2:String = "asc") : Vector.<ItemVO>
   {
      var _loc3_:Function = this.const2FX[param2] as Function;
      return param1.sort(_loc3_);
   }
   
   public function sortBehaviourAscending(param1:ItemVO, param2:ItemVO) : int
   {
      var _loc3_:uint = param1.sortIndex;
      var _loc4_:uint = param2.sortIndex;
      if(_loc3_ == _loc4_)
      {
         if(param1.upgradeLevel < param2.upgradeLevel)
         {
            return 1;
         }
         if(param1.upgradeLevel > param2.upgradeLevel)
         {
            return -1;
         }
         return 0;
      }
      return _loc3_ < _loc4_ ? -1 : 1;
   }
   
   public function sortBehaviourDescending(param1:ItemVO, param2:ItemVO) : int
   {
      var _loc3_:ItemVO = param1 as ItemVO;
      var _loc4_:ItemVO = param2 as ItemVO;
      if(_loc3_.sortIndex > _loc4_.sortIndex)
      {
         return -1;
      }
      if(_loc3_.sortIndex < _loc4_.sortIndex)
      {
         return 1;
      }
      return 0;
   }
   
   public function sortTargetedOffers(param1:ItemVO, param2:ItemVO) : int
   {
      var _loc3_:String = param1.lootID;
      var _loc4_:String = param2.lootID;
      if(_loc3_ != _loc4_)
      {
         if(_loc3_ == "currency_uridium")
         {
            return -1;
         }
         if(_loc4_ == "currency_uridium")
         {
            return 1;
         }
         if(param1.item.attributes is PaymentItemAttributes != param2.item.attributes is PaymentItemAttributes)
         {
            if(param1.item.attributes is PaymentItemAttributes)
            {
               return -1;
            }
            if(param2.item.attributes is PaymentItemAttributes)
            {
               return 1;
            }
         }
         if(param1.item.attributes is BoosterAttributes != param2.item.attributes is BoosterAttributes)
         {
            if(param1.item.attributes is BoosterAttributes)
            {
               return -1;
            }
            if(param2.item.attributes is BoosterAttributes)
            {
               return 1;
            }
         }
         if(_loc3_ == "resource_extra-energy")
         {
            return -1;
         }
         if(_loc4_ == "resource_extra-energy")
         {
            return 1;
         }
         if(StringUtils.startsWith(_loc3_,"resource_booty-key") != StringUtils.startsWith(_loc4_,"resource_booty-key"))
         {
            if(StringUtils.startsWith(_loc3_,"resource_booty-key"))
            {
               return -1;
            }
            if(StringUtils.startsWith(_loc4_,"resource_booty-key"))
            {
               return 1;
            }
         }
         if(_loc3_ == "resource_logfile")
         {
            return -1;
         }
         if(_loc4_ == "resource_logfile")
         {
            return 1;
         }
         return this.sortBehaviourAscending(param1,param2);
      }
      return 0;
   }
}
