package net.bigpoint.darkorbit.delete_in_eic
{
   import com.adobe.utils.StringUtil;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.Item;
   import net.bigpoint.darkorbit.items.item.traits.AbstractTrait;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.utils.ClassUtils;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.discount.model.DiscountProxy;
   import org.as3commons.lang.IllegalArgumentError;
   
   public class ItemDataProviderHelper
   {
      
      public static const AND:String = "and";
      
      public static const OR:String = "or";
      
      public function ItemDataProviderHelper()
      {
         super();
      }
      
      public static function getItem(param1:String) : ItemVO
      {
         var _loc2_:Item = ItemDataProvider.getItem(param1);
         if(_loc2_)
         {
            return internalCreate(_loc2_);
         }
         return null;
      }
      
      public static function getItems(param1:Vector.<String>) : Vector.<ItemVO>
      {
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.push(getItem(param1[_loc4_]));
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function internalCreate(param1:Item) : ItemVO
      {
         var _loc2_:ItemVO = new ItemVO();
         _loc2_.lootID = param1.attributes.lootId;
         _loc2_.item = param1;
         return _loc2_;
      }
      
      public static function getAmountOfItems(param1:Vector.<ItemVO>, param2:ItemSelectMode = null, param3:String = null) : Number
      {
         var _loc6_:Number = NaN;
         var _loc8_:ItemVO = null;
         param2 ||= ItemSelectMode.ALL;
         var _loc4_:int = int(param1.length);
         var _loc5_:Number = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc8_ = param1[_loc7_];
            _loc6_ = 0;
            if(param2 == ItemSelectMode.ALL)
            {
               _loc6_ = _loc8_.amount;
            }
            else if(param2 == ItemSelectMode.NOT_EQUIPPED)
            {
               if(!_loc8_.isEquipped)
               {
                  if(!isItemUpgrading(_loc8_))
                  {
                     _loc6_ = _loc8_.amount;
                  }
               }
            }
            else if(param2 == ItemSelectMode.ONLY_EQUIPPED && _loc8_.isEquipped)
            {
               _loc6_ = _loc8_.amount;
            }
            _loc5_ += _loc6_;
            _loc7_++;
         }
         return _loc5_;
      }
      
      public static function getAmountWithDiscount(param1:String, param2:Number, param3:String) : Number
      {
         var _loc4_:DiscountProxy = GameFacade.getInstance().retrieveProxy(DiscountProxy.NAME) as DiscountProxy;
         return _loc4_.getAmountWithDiscount(param1,param2,param3);
      }
      
      public static function isItemUpgrading(param1:ItemVO) : Boolean
      {
         if(param1.id == 0 || param1.item.traits.getTraitByType(TraitTypes.UPGRADABLE) == null)
         {
            return false;
         }
         var _loc2_:AssemblyProxy = GameFacade.getInstance().retrieveProxy(AssemblyProxy.NAME) as AssemblyProxy;
         var _loc3_:AssemblyRecipeModel = _loc2_.recipes.getByTargetId(param1.id);
         if(_loc3_ != null && (_loc3_.state.status.getLibcomModuleId() == AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId() || _loc3_.state.status.getLibcomModuleId() == AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId()))
         {
            return true;
         }
         return false;
      }
      
      public static function getItemsByAttrClass(param1:Class) : Vector.<ItemVO>
      {
         var _loc3_:Item = null;
         var _loc5_:String = null;
         var _loc2_:Dictionary = ItemDataProvider.items;
         var _loc4_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         for(_loc5_ in _loc2_)
         {
            _loc3_ = _loc2_[_loc5_] as Item;
            if(Boolean(_loc3_) && ClassUtils.getClass(_loc3_.attributes) == param1)
            {
               _loc4_.push(internalCreate(_loc3_));
            }
         }
         return _loc4_;
      }
      
      public static function getWithPrefix(param1:String) : Vector.<ItemVO>
      {
         var _loc3_:Item = null;
         var _loc5_:String = null;
         var _loc2_:Dictionary = ItemDataProvider.items;
         var _loc4_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         for(_loc5_ in _loc2_)
         {
            _loc3_ = _loc2_[_loc5_] as Item;
            if(Boolean(_loc3_) && StringUtil.beginsWith(_loc5_,param1))
            {
               _loc4_.push(internalCreate(_loc3_));
            }
         }
         return _loc4_;
      }
      
      public static function getItemsWithOutTrait(param1:Vector.<Class>, param2:String = "and") : Vector.<ItemVO>
      {
         var _loc4_:Item = null;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:Vector.<AbstractTrait> = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Class = null;
         var _loc13_:int = 0;
         var _loc3_:Dictionary = ItemDataProvider.items;
         var _loc5_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         for(_loc7_ in _loc3_)
         {
            _loc4_ = _loc3_[_loc7_] as Item;
            _loc6_ = false;
            if(Boolean(_loc4_) && Boolean(_loc4_.traits))
            {
               _loc8_ = _loc4_.traits.traits;
               _loc9_ = int(_loc8_.length);
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  if(param2 == AND)
                  {
                     _loc9_ = int(param1.length);
                     _loc11_ = 0;
                     while(_loc11_ < _loc9_)
                     {
                        _loc12_ = param1[_loc11_];
                        if(_loc8_[_loc10_] is _loc12_)
                        {
                           _loc6_ = true;
                           break;
                        }
                        _loc11_++;
                     }
                  }
                  else
                  {
                     if(param2 != OR)
                     {
                        throw new IllegalArgumentError("the argument " + param2 + " is not supported");
                     }
                     _loc13_ = 0;
                     _loc9_ = int(param1.length);
                     _loc11_ = 0;
                     while(_loc11_ < _loc9_)
                     {
                        _loc12_ = param1[_loc11_];
                        if(_loc8_[_loc10_] is _loc12_)
                        {
                           _loc13_++;
                        }
                        _loc11_++;
                     }
                     if(_loc13_ != _loc9_)
                     {
                        _loc6_ = true;
                     }
                  }
                  _loc10_++;
               }
               if(!_loc6_)
               {
                  _loc5_.push(internalCreate(_loc4_));
               }
            }
            else
            {
               _loc5_.push(internalCreate(_loc4_));
            }
         }
         return _loc5_;
      }
   }
}

