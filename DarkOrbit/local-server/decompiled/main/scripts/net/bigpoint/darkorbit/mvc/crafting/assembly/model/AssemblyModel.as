package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeKeyModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeReadyToCollectStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusUpdateCommand;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeTemporaryTypeModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeTypeModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.ItemDataProvider;
   import net.bigpoint.darkorbit.items.item.attributes.BuildPart;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeCosts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AbstractAssemblyState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyAvailableState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.states.AssemblyTimerState;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AbstractAssemblyType;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AssemblyTemporaryType;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.model.DisassemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgraderecipeModel;
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AssemblyModel
   {
      
      private static const _type2Class:Object = {};
      
      _type2Class[AssemblyRecipeTemporaryTypeModule.instance.getLibcomModuleId()] = AssemblyTemporaryType;
      
      public const buildWarning:ISignal = new Signal();
      
      public const recipeAdded:ISignal = new Signal(AssemblyRecipeModel);
      
      public const recipeRemoved:ISignal = new Signal(AssemblyRecipeModel);
      
      private var _currentRecipes:Vector.<AssemblyRecipeModel> = new Vector.<AssemblyRecipeModel>(0);
      
      public function AssemblyModel()
      {
         super();
      }
      
      public function get currentRecipes() : Vector.<AssemblyRecipeModel>
      {
         return this._currentRecipes;
      }
      
      public function update(param1:AssemblyRecipeModule) : void
      {
         var _loc2_:AssemblyRecipeModel = this.getOrAdd(param1);
         if(!_loc2_)
         {
            return;
         }
         _loc2_.state = this.createState(param1.status);
         _loc2_.type = this.createType(param1.type);
         this.sortModel();
      }
      
      public function sortModel() : void
      {
         this._currentRecipes.sort(AssemblyRecipeModel.sort);
      }
      
      public function updateStatus(param1:AssemblyRecipeStatusUpdateCommand) : void
      {
         var _loc2_:AssemblyRecipeModel = this.getById(param1.lootId,param1.targetItemId);
         if(_loc2_)
         {
            _loc2_.state = this.createState(param1.status);
         }
         this.sortModel();
      }
      
      public function removeRecipes(param1:Vector.<AssemblyRecipeKeyModule>) : void
      {
         var _loc4_:AssemblyRecipeModel = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:AssemblyRecipeKeyModule = null;
         var _loc2_:int = int(this._currentRecipes.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = this._currentRecipes[_loc3_];
            _loc5_ = int(param1.length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = param1[_loc6_];
               if(_loc4_.lootId == _loc7_.lootId && _loc4_.targetId == _loc7_.targetId)
               {
                  this.internalRemove(_loc4_);
                  break;
               }
               _loc6_++;
            }
            _loc3_--;
         }
      }
      
      public function getByTargetId(param1:Number) : AssemblyRecipeModel
      {
         var _loc4_:AssemblyRecipeModel = null;
         var _loc2_:int = int(this._currentRecipes.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._currentRecipes[_loc3_];
            if(_loc4_.targetId == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function getByTargetIdAndLootID(param1:int, param2:String) : AssemblyRecipeModel
      {
         var _loc5_:AssemblyRecipeModel = null;
         var _loc3_:int = int(this._currentRecipes.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._currentRecipes[_loc4_];
            if(_loc5_.targetId == param1 && _loc5_.lootId == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function cleanup() : void
      {
         var _loc3_:AssemblyRecipeModel = null;
         var _loc1_:int = int(this._currentRecipes.length);
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this._currentRecipes[_loc2_];
            this.internalRemove(_loc3_);
            _loc2_--;
         }
      }
      
      private function internalRemove(param1:AssemblyRecipeModel) : void
      {
         param1.isBuildAbleOnce.remove(this.buildWarning.dispatch);
         var _loc2_:int = this._currentRecipes.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._currentRecipes.splice(_loc2_,1);
         }
         this.recipeRemoved.dispatch(param1);
      }
      
      private function createType(param1:AssemblyRecipeTypeModule) : AbstractAssemblyType
      {
         return new (_type2Class[param1.getLibcomModuleId()] || AbstractAssemblyType)(param1);
      }
      
      private function createState(param1:AssemblyRecipeStatusModule) : AbstractAssemblyState
      {
         if(param1 is AssemblyRecipeBuildStatusModule)
         {
            return new AssemblyTimerState(param1 as AssemblyRecipeBuildStatusModule);
         }
         if(param1 is AssemblyRecipeAvailableStatusModule)
         {
            return new AssemblyAvailableState(param1 as AssemblyRecipeAvailableStatusModule);
         }
         if(param1 is AssemblyRecipeReadyToCollectStatusModule)
         {
            this.buildWarning.dispatch();
         }
         return new AbstractAssemblyState(param1);
      }
      
      private function getOrAdd(param1:AssemblyRecipeModule) : AssemblyRecipeModel
      {
         var _loc2_:AssemblyRecipeModel = this.getById(param1.recipeLootId,param1.targetItemId);
         if(!_loc2_)
         {
            _loc2_ = this.createRecipe(param1);
            if(!_loc2_)
            {
               return null;
            }
            _loc2_.isBuildAbleOnce.add(this.buildWarning.dispatch);
            this.writeIngredients(_loc2_);
            this._currentRecipes.push(_loc2_);
            setTimeout(this.recipeAdded.dispatch,1,_loc2_);
         }
         return _loc2_;
      }
      
      private function createRecipe(param1:AssemblyRecipeModule) : AssemblyRecipeModel
      {
         var recipeAttr:RecipeAttributes = null;
         var data:AssemblyRecipeModule = param1;
         try
         {
            recipeAttr = ItemDataProvider.getItem(data.recipeLootId).attributes as RecipeAttributes;
            if(recipeAttr.targets.length > 0)
            {
               if(StringUtils.startsWith(recipeAttr.lootId,AssemblyConsts.UPGRADE_PREFIX))
               {
                  return new UpgraderecipeModel(ItemDataProviderHelper.getItem(data.recipeLootId),this.getItems(recipeAttr.result),data.targetItemId);
               }
               if(StringUtils.startsWith(recipeAttr.lootId,AssemblyConsts.DISASSEBLY_PREFIX))
               {
                  return new DisassemblyRecipeModel(ItemDataProviderHelper.getItem(data.recipeLootId),this.getItems(recipeAttr.result),data.targetItemId);
               }
            }
            return new AssemblyRecipeModel(ItemDataProviderHelper.getItem(data.recipeLootId),this.getItems(recipeAttr.result),data.targetItemId);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      private function getItems(param1:Vector.<BuildPart>) : Vector.<ItemVO>
      {
         var _loc5_:BuildPart = null;
         var _loc6_:ItemVO = null;
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>(0);
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = ItemDataProviderHelper.getItem(_loc5_.lootID);
            _loc6_.amount = _loc5_.ammount;
            _loc2_.push(_loc6_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function writeIngredients(param1:AssemblyRecipeModel) : void
      {
         var _loc5_:RecipeCosts = null;
         var _loc6_:Vector.<BuildPart> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:BuildPart = null;
         var _loc12_:BuildPart = null;
         var _loc2_:RecipeAttributes = ItemDataProvider.getItem(param1.lootId).attributes as RecipeAttributes;
         var _loc3_:int = int(_loc2_.costs.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.costs[_loc4_];
            _loc6_ = _loc5_.parts;
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc11_ = _loc6_[_loc8_];
               param1.setIngredient(new AssemblyLootCount(ItemDataProviderHelper.getItem(_loc11_.lootID),_loc11_.ammount,ItemDataProviderHelper.getAmountWithDiscount(_loc11_.lootID,_loc11_.ammount,param1.source)));
               _loc8_++;
            }
            _loc9_ = int(_loc5_.skipCosts.length);
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc12_ = _loc5_.skipCosts[_loc10_];
               param1.setIngredient(new AssemblyLootCount(ItemDataProviderHelper.getItem(_loc12_.lootID),_loc12_.ammount,ItemDataProviderHelper.getAmountWithDiscount(_loc12_.lootID,_loc12_.ammount,param1.source)));
               _loc10_++;
            }
            _loc4_++;
         }
      }
      
      private function getById(param1:String, param2:Number) : AssemblyRecipeModel
      {
         var _loc5_:AssemblyRecipeModel = null;
         var _loc3_:int = int(this._currentRecipes.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._currentRecipes[_loc4_];
            if(_loc5_.lootId == param1 && _loc5_.targetId == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
   }
}

