package net.bigpoint.darkorbit.mvc.crafting.upgrade.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemsDataUtility;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import org.as3commons.lang.IllegalArgumentError;
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UpgradeTypeModel
   {
      
      public const changed:ISignal = new Signal();
      
      public const hasCollectibleRecipe:BindableBoolean = new BindableBoolean();
      
      protected var _targetItemType:ItemVO;
      
      protected var _recipes:Vector.<AssemblyRecipeModel> = new Vector.<AssemblyRecipeModel>();
      
      protected var _targets:Vector.<UpgradeRecipeItemPair> = new Vector.<UpgradeRecipeItemPair>(0);
      
      protected var _id2Pair:Object = {};
      
      protected var _recipeDefinitions:Object = {};
      
      private var _collectibleCount:int;
      
      public function UpgradeTypeModel(param1:Vector.<ItemVO>, param2:ItemVO)
      {
         super();
         if(param1 == null || param1.length == 0)
         {
            throw new IllegalArgumentError("upgrade must have at least 1 recipe");
         }
         if(param2 == null)
         {
            throw new IllegalArgumentError("pTargetItem must not be null");
         }
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this._recipeDefinitions[param1[_loc4_].lootID] = param1[_loc4_];
            _loc4_++;
         }
         this._targetItemType = param2;
      }
      
      public static function filterEmpty(param1:UpgradeTypeModel, param2:int, param3:Vector.<UpgradeTypeModel>) : Boolean
      {
         return param1.recipes.length > 0 && param1.hasTargets;
      }
      
      public static function sort(param1:UpgradeTypeModel, param2:UpgradeTypeModel) : int
      {
         return StringUtils.compareTo(param1.targetItemType.lootID,param2.targetItemType.lootID);
      }
      
      public function get targetItemType() : ItemVO
      {
         return this._targetItemType;
      }
      
      public function get recipes() : Vector.<AssemblyRecipeModel>
      {
         return this._recipes;
      }
      
      public function get targets() : Vector.<UpgradeRecipeItemPair>
      {
         return this._targets;
      }
      
      public function get targetsLevelSorted() : Vector.<UpgradeRecipeItemPair>
      {
         return this._targets.filter(this.isVisibleTarget).sort(this.levelSortTargets);
      }
      
      protected function isVisibleTarget(param1:UpgradeRecipeItemPair, param2:int = 0, param3:Vector.<UpgradeRecipeItemPair> = null) : Boolean
      {
         return param1.item != null && !ItemsDataUtility.isMaxLevel(param1.item);
      }
      
      public function get hasTargets() : Boolean
      {
         var _loc1_:UpgradeRecipeItemPair = null;
         for each(_loc1_ in this._targets)
         {
            if(this.isVisibleTarget(_loc1_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function addPossibleTarget(param1:ItemVO) : void
      {
         if(ItemsDataUtility.isMaxLevel(param1))
         {
            return;
         }
         var _loc2_:UpgradeRecipeItemPair = this.getOrAdd(param1.id);
         _loc2_.item = param1;
      }
      
      public function removePossibleTarget(param1:ItemVO) : void
      {
         var _loc2_:UpgradeRecipeItemPair = this._id2Pair[param1.id];
         if(_loc2_)
         {
            this.deletePair(_loc2_);
         }
      }
      
      public function addPossibleRecipe(param1:TargetItemRecipeModel) : void
      {
         var _loc2_:UpgradeRecipeItemPair = this.getOrAdd(param1.targetId);
         _loc2_.recipe = param1;
      }
      
      public function removePossibleRecipe(param1:TargetItemRecipeModel) : void
      {
         var _loc2_:UpgradeRecipeItemPair = this._id2Pair[param1.targetId];
         if(_loc2_)
         {
            _loc2_.recipe = null;
            if(_loc2_.empty)
            {
               this.deletePair(_loc2_);
            }
         }
      }
      
      public function hasRecipeType(param1:String) : Boolean
      {
         return this._recipeDefinitions[param1];
      }
      
      public function addState(param1:TargetItemRecipeModel) : void
      {
         if(this._recipes.indexOf(param1) == -1)
         {
            this._recipes.push(param1);
         }
      }
      
      public function removeState(param1:TargetItemRecipeModel) : void
      {
         var _loc2_:Number = this._recipes.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._recipes.splice(_loc2_,1);
         }
      }
      
      public function cleanup() : void
      {
         while(this._targets.length != 0)
         {
            this.deletePair(this._targets[this._targets.length - 1]);
         }
         this._recipes.length = 0;
         this._targets.length = 0;
         this._id2Pair = {};
         this._collectibleCount = 0;
         this.hasCollectibleRecipe.value = false;
      }
      
      protected function levelSortTargets(param1:UpgradeRecipeItemPair, param2:UpgradeRecipeItemPair) : int
      {
         return param1.item.upgradeLevel - param2.item.upgradeLevel;
      }
      
      private function deletePair(param1:UpgradeRecipeItemPair) : void
      {
         var _loc2_:int = 0;
         if(param1)
         {
            _loc2_ = this._targets.indexOf(param1);
            if(_loc2_ != -1)
            {
               this._targets.splice(_loc2_,1);
            }
            delete this._id2Pair[param1.id];
            this.setCollectible(param1,false);
            param1.cleanup();
            this.changed.dispatch();
         }
      }
      
      protected function getOrAdd(param1:Number) : UpgradeRecipeItemPair
      {
         var _loc2_:UpgradeRecipeItemPair = this._id2Pair[param1];
         if(!_loc2_)
         {
            _loc2_ = this._id2Pair[param1] = new UpgradeRecipeItemPair(param1);
            this._targets.push(_loc2_);
            _loc2_.parent = this;
            this.changed.dispatch();
         }
         return _loc2_;
      }
      
      internal function handlePairChanged(param1:UpgradeRecipeItemPair) : void
      {
         if(this._id2Pair[param1.id] !== param1)
         {
            return;
         }
         this.setCollectible(param1,param1.item != null && param1.recipe != null && param1.recipe.state != null && param1.recipe.state.status is AssemblyRecipeReadyToCollectStatusModule);
      }
      
      private function setCollectible(param1:UpgradeRecipeItemPair, param2:Boolean) : void
      {
         if(param1.countedCollectible == param2)
         {
            return;
         }
         param1.countedCollectible = param2;
         this._collectibleCount += param2 ? 1 : -1;
         this.hasCollectibleRecipe.value = this._collectibleCount > 0;
      }
   }
}

