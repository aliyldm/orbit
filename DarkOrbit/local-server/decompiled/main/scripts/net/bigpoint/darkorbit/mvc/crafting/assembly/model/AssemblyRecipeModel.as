package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeUnavailableStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.attributes.BuildPart;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.items.utils.ItemSortorder;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AbstractAssemblyState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AbstractAssemblyType;
   import net.bigpoint.darkorbit.mvc.discount.model.DiscountSource;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AssemblyRecipeModel
   {
      
      private static var stateLookup:Object = {};
      
      stateLookup[AssemblyRecipeReadyToCollectStatusModule.instance.getLibcomModuleId()] = 4;
      stateLookup[AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId()] = 3;
      stateLookup[AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId()] = 2;
      stateLookup[AssemblyRecipeUnavailableStatusModule.instance.getLibcomModuleId()] = 1;
      
      public const stateChanged:ISignal = new Signal();
      
      public const typeChanged:ISignal = new Signal();
      
      public const isBuildAbleOnce:ISignal = new Signal();
      
      protected var _state:AbstractAssemblyState;
      
      protected var _type:AbstractAssemblyType;
      
      protected var _ingredients:Vector.<AssemblyLootCount> = new Vector.<AssemblyLootCount>(0);
      
      protected var _itemVO:ItemVO;
      
      protected var _outPutItem:Vector.<ItemVO>;
      
      protected var _cachedisBuildAbleOnce:Boolean;
      
      protected var _targetId:Number;
      
      private var _source:String;
      
      public function AssemblyRecipeModel(param1:ItemVO, param2:Vector.<ItemVO>, param3:Number, param4:String = null)
      {
         super();
         this._itemVO = param1;
         this._outPutItem = param2;
         this._targetId = param3;
         this._source = param4 || DiscountSource.ASSEMBLY;
      }
      
      public static function sort(param1:AssemblyRecipeModel, param2:AssemblyRecipeModel) : int
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:AssemblyRecipeAvailableStatusModule = null;
         var _loc8_:AssemblyRecipeAvailableStatusModule = null;
         var _loc3_:int = param1.state.status.getLibcomModuleId();
         var _loc4_:int = param2.state.status.getLibcomModuleId();
         if(_loc3_ == _loc4_)
         {
            if(_loc3_ == AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
            {
               _loc5_ = param1.cachedisBuildAbleOnce;
               _loc6_ = param2.cachedisBuildAbleOnce;
               if(_loc5_ != _loc6_)
               {
                  if(_loc6_)
                  {
                     return 1;
                  }
                  if(_loc5_)
                  {
                     return -1;
                  }
               }
               else
               {
                  _loc7_ = param2.state.status as AssemblyRecipeAvailableStatusModule;
                  _loc8_ = param1.state.status as AssemblyRecipeAvailableStatusModule;
                  if(_loc7_.isNew != _loc8_.isNew)
                  {
                     if(_loc7_.isNew)
                     {
                        return 1;
                     }
                     if(_loc8_.isNew)
                     {
                        return -1;
                     }
                  }
               }
            }
            return ItemSortorder.getSortIndexByLootID(param1.outPutItem.lootID) - ItemSortorder.getSortIndexByLootID(param2.outPutItem.lootID);
         }
         return stateLookup[_loc4_] - stateLookup[_loc3_];
      }
      
      public function get lootId() : String
      {
         return this._itemVO.lootID;
      }
      
      public function get state() : AbstractAssemblyState
      {
         return this._state;
      }
      
      public function set state(param1:AbstractAssemblyState) : void
      {
         if(this._state)
         {
            this._state.dispose();
         }
         this._state = param1;
         this.updateBuildableCachedValue();
         this.stateChanged.dispatch();
      }
      
      public function get type() : AbstractAssemblyType
      {
         return this._type;
      }
      
      public function set type(param1:AbstractAssemblyType) : void
      {
         this._type = param1;
         this.typeChanged.dispatch();
      }
      
      public function get ingredients() : Vector.<AssemblyLootCount>
      {
         return this._ingredients;
      }
      
      public function get itemVO() : ItemVO
      {
         return this._itemVO;
      }
      
      public function set itemVO(param1:ItemVO) : void
      {
         this._itemVO = param1;
      }
      
      public function get outPutItem() : ItemVO
      {
         return this._outPutItem[0];
      }
      
      public function get attribute() : RecipeAttributes
      {
         return this._itemVO.item.attributes as RecipeAttributes;
      }
      
      public function get cachedisBuildAbleOnce() : Boolean
      {
         return this._cachedisBuildAbleOnce;
      }
      
      public function get targetId() : Number
      {
         return this._targetId;
      }
      
      public function setIngredient(param1:AssemblyLootCount) : void
      {
         if(!this.hasIngredient(param1.lootId))
         {
            this._ingredients.push(param1);
            param1.count.changed.add(this.updateBuildableCachedValue);
         }
      }
      
      public function isBuildAble(param1:uint = 1, param2:int = 0) : Boolean
      {
         if(this.state.status.getLibcomModuleId() != AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
         {
            return false;
         }
         var _loc3_:AssemblyRecipeAvailableStatusModule = this.state.status as AssemblyRecipeAvailableStatusModule;
         if(_loc3_.currentBuildCount >= this.attribute.maxUses)
         {
            return false;
         }
         return this.checkIngredientCount(this.attribute.costs[0].parts,param1);
      }
      
      protected function updateBuildableCachedValue() : void
      {
         var _loc1_:Boolean = this.isBuildAble();
         if(_loc1_ != this._cachedisBuildAbleOnce && _loc1_)
         {
            this.isBuildAbleOnce.dispatch();
         }
         this._cachedisBuildAbleOnce = _loc1_;
      }
      
      protected function checkIngredientCount(param1:Vector.<BuildPart>, param2:uint) : Boolean
      {
         var _loc6_:AssemblyLootCount = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AssemblyRecipeAvailableStatusModule = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:BuildPart = null;
         var _loc3_:int = int(this._ingredients.length);
         var _loc4_:Boolean = true;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = this._ingredients[_loc5_];
            _loc7_ = int(param1.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc12_ = param1[_loc8_];
               if(_loc12_.lootID == _loc6_.lootId)
               {
                  break;
               }
               _loc12_ = null;
               _loc8_++;
            }
            if(!_loc12_)
            {
               return false;
            }
            _loc9_ = this.state.status as AssemblyRecipeAvailableStatusModule;
            _loc10_ = this.attribute.costScalingFactor;
            _loc11_ = ItemDataProviderHelper.getAmountWithDiscount(_loc12_.lootID,_loc12_.ammount,this.source);
            if(_loc10_ != 1 && _loc9_ != null)
            {
               _loc10_ = Number.pow(_loc10_,_loc9_.currentBuildCount) - Number.pow(_loc10_,_loc9_.currentBuildCount + param2);
               _loc11_ = _loc11_ * _loc10_ / (1 - this.attribute.costScalingFactor);
            }
            else
            {
               _loc11_ *= param2;
            }
            _loc4_ &&= _loc6_.count.value >= Number.round(_loc11_);
            if(!_loc4_)
            {
               return false;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function hasIngredient(param1:String) : Boolean
      {
         var _loc4_:AssemblyLootCount = null;
         var _loc2_:int = int(this._ingredients.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._ingredients[_loc3_];
            if(_loc4_.lootId == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function get source() : String
      {
         return this._source;
      }
   }
}

