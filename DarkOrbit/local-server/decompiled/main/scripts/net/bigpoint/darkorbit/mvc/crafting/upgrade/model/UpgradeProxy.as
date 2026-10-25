package net.bigpoint.darkorbit.mvc.crafting.upgrade.model
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryModel;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   import net.bigpoint.darkorbit.utils.VectorUtils;
   import org.as3commons.lang.StringUtils;
   
   public class UpgradeProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "UpgradeProxy";
      
      private var _assemblyModel:AssemblyModel;
      
      protected var _inventory:InventoryModel;
      
      private var _timeout:uint;
      
      public function UpgradeProxy()
      {
         super(NAME,new UpgradeModel());
      }
      
      private function get upgradeModel() : UpgradeModel
      {
         return data as UpgradeModel;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._inventory = (retrieveProxy(InventoryProxy.NAME) as InventoryProxy).inventory;
         this._inventory.itemAdded.add(this.handleItemAdded);
         this._inventory.itemRemoved.add(this.handleItemRemoved);
         this._assemblyModel = retrieveProxy(AssemblyProxy.NAME).getData() as AssemblyModel;
         this._assemblyModel.recipeAdded.add(this.handleRecipeAdded);
         this._assemblyModel.recipeAdded.add(this.handleRecipeRemoved);
         this.initTargetList();
      }
      
      public function cleanup() : void
      {
         var _loc4_:UpgradeTypeModel = null;
         var _loc1_:Vector.<UpgradeTypeModel> = this.upgradeModel.availableUpgradeTypes;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc1_[_loc3_];
            _loc4_.cleanup();
            _loc3_--;
         }
      }
      
      private function initTargetList() : void
      {
         var recipe:RecipeAttributes = null;
         var targets:Vector.<String> = null;
         var tVec:Vector.<ItemVO> = null;
         var lenJ:int = 0;
         var j:int = 0;
         var allRecipes:Vector.<ItemVO> = this.getAllValidRecipes();
         var targetRecipeLookup:Object = {};
         var lootIDs:Vector.<String> = new Vector.<String>(0);
         var len:int = int(allRecipes.length);
         var i:int = 0;
         while(i < len)
         {
            recipe = allRecipes[i].item.attributes as RecipeAttributes;
            targets = recipe.targets;
            if(targets)
            {
               lenJ = int(targets.length);
               j = 0;
               while(j < lenJ)
               {
                  tVec = targetRecipeLookup[targets[j]];
                  if(!tVec)
                  {
                     tVec = targetRecipeLookup[targets[j]] = new Vector.<ItemVO>(0);
                  }
                  tVec.push(allRecipes[i]);
                  j++;
               }
               lootIDs = lootIDs.concat(targets);
            }
            i++;
         }
         VectorUtils.unique(lootIDs,function(param1:String, param2:String):int
         {
            return param1 == param2 ? 1 : 0;
         });
         this.addTypes(lootIDs,targetRecipeLookup);
      }
      
      protected function addTypes(param1:Vector.<String>, param2:Object) : void
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.upgradeModel.addType(new UpgradeTypeModel(param2[param1[_loc4_]],ItemDataProviderHelper.getItem(param1[_loc4_])));
            _loc4_++;
         }
      }
      
      protected function getAllValidRecipes() : Vector.<ItemVO>
      {
         var _loc4_:ItemVO = null;
         var _loc1_:Vector.<ItemVO> = ItemDataProviderHelper.getItemsByAttrClass(RecipeAttributes);
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc1_[_loc3_];
            if(!StringUtils.startsWith(_loc4_.lootID,AssemblyConsts.UPGRADE_PREFIX))
            {
               _loc1_.splice(_loc3_,1);
            }
            _loc3_--;
         }
         return _loc1_;
      }
      
      private function handleItemRemoved(param1:ItemVO) : void
      {
         var _loc2_:UpgradeTypeModel = this.upgradeModel.getUpgradeByTargetLootID(param1.lootID);
         if(!_loc2_)
         {
            return;
         }
         _loc2_.removePossibleTarget(param1);
         this.invalidate();
      }
      
      private function handleItemAdded(param1:ItemVO) : void
      {
         var _loc2_:UpgradeTypeModel = this.upgradeModel.getUpgradeByTargetLootID(param1.lootID);
         if(!_loc2_)
         {
            return;
         }
         _loc2_.addPossibleTarget(param1);
         this.invalidate();
      }
      
      protected function handleRecipeAdded(param1:AssemblyRecipeModel) : void
      {
         var _loc3_:Vector.<UpgradeTypeModel> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:UpgradeTypeModel = null;
         var _loc7_:Vector.<ItemVO> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:ItemVO = null;
         var _loc2_:TargetItemRecipeModel = param1 as TargetItemRecipeModel;
         if(_loc2_)
         {
            _loc3_ = this.upgradeModel.availableUpgradeTypes;
            _loc4_ = int(_loc3_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_];
               if(_loc6_.hasRecipeType(_loc2_.lootId))
               {
                  if(_loc2_.targetId == 0)
                  {
                     _loc6_.addState(_loc2_);
                  }
                  else
                  {
                     _loc6_.addPossibleRecipe(_loc2_);
                  }
               }
               _loc7_ = this._inventory.getById(_loc6_.targetItemType.lootID);
               _loc8_ = int(_loc7_.length);
               _loc9_ = 0;
               while(_loc9_ < _loc8_)
               {
                  _loc10_ = _loc7_[_loc9_];
                  _loc6_.addPossibleTarget(_loc10_);
                  _loc9_++;
               }
               _loc5_++;
            }
         }
         this.invalidate();
      }
      
      protected function handleRecipeRemoved(param1:AssemblyRecipeModel) : void
      {
         var _loc3_:Vector.<UpgradeTypeModel> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:UpgradeTypeModel = null;
         var _loc2_:TargetItemRecipeModel = param1 as TargetItemRecipeModel;
         if(_loc2_)
         {
            _loc3_ = this.upgradeModel.availableUpgradeTypes;
            _loc4_ = int(_loc3_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc6_ = _loc3_[_loc5_];
               if(_loc6_.hasRecipeType(_loc2_.lootId))
               {
                  if(_loc2_.targetId == 0)
                  {
                     _loc6_.removeState(_loc2_);
                  }
                  else
                  {
                     _loc6_.removePossibleRecipe(_loc2_);
                  }
               }
               _loc5_++;
            }
         }
         this.invalidate();
      }
      
      protected function invalidate() : void
      {
         clearTimeout(this._timeout);
         this._timeout = setTimeout(this.upgradeModel.changed.dispatch,1);
      }
   }
}

