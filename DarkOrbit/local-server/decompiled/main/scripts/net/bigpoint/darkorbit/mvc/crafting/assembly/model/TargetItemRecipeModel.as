package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.attributes.BuildPart;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeCosts;
   import org.as3commons.lang.IllegalArgumentError;
   
   public class TargetItemRecipeModel extends AssemblyRecipeModel
   {
      
      private var _maxTargetLevel:int;
      
      public function TargetItemRecipeModel(param1:ItemVO, param2:Vector.<ItemVO>, param3:Number, param4:String = null)
      {
         var _loc8_:RecipeCosts = null;
         super(param1,param2,param3,param4);
         var _loc5_:Vector.<RecipeCosts> = attribute.costs;
         var _loc6_:int = int(_loc5_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = _loc5_[_loc7_];
            this._maxTargetLevel = Math.max(this._maxTargetLevel,_loc8_.level);
            _loc7_++;
         }
      }
      
      public function get maxTargetLevel() : int
      {
         return this._maxTargetLevel;
      }
      
      override protected function updateBuildableCachedValue() : void
      {
         var _loc1_:Boolean = false;
         if(_loc1_ != _cachedisBuildAbleOnce && _loc1_)
         {
            isBuildAbleOnce.dispatch();
         }
         _cachedisBuildAbleOnce = _loc1_;
      }
      
      override public function isBuildAble(param1:uint = 1, param2:int = 0) : Boolean
      {
         if(state.status.getLibcomModuleId() != AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
         {
            return false;
         }
         if(param2 > this.maxTargetLevel || param1 >= this.maxTargetLevel)
         {
            return false;
         }
         if(param1 >= param2)
         {
            return false;
         }
         var _loc3_:RecipeCosts = this.collectSteps(param1,param2);
         return this.checkIngredientCount(_loc3_.parts,1);
      }
      
      override protected function checkIngredientCount(param1:Vector.<BuildPart>, param2:uint) : Boolean
      {
         var _loc6_:BuildPart = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AssemblyLootCount = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:Boolean = true;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = int(_ingredients.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _ingredients[_loc8_];
               if(_loc6_.lootID == _loc9_.lootId)
               {
                  break;
               }
               _loc9_ = null;
               _loc8_++;
            }
            if(!_loc9_)
            {
               return false;
            }
            _loc4_ &&= _loc9_.count.value >= ItemDataProviderHelper.getAmountWithDiscount(_loc6_.lootID,_loc6_.ammount,source) * param2;
            if(!_loc4_)
            {
               return false;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function collectSteps(param1:int, param2:int) : RecipeCosts
      {
         var _loc7_:RecipeCosts = null;
         if(param1 > param2)
         {
            throw new IllegalArgumentError("sourceLevel bigger than targetLevel");
         }
         var _loc3_:Vector.<RecipeCosts> = attribute.costs;
         if(param2 > this.maxTargetLevel)
         {
            throw new IllegalArgumentError("targetLevel can\'t be bigger than the maximum level");
         }
         var _loc4_:Vector.<RecipeCosts> = new Vector.<RecipeCosts>(0);
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_[_loc6_];
            if(_loc7_.level > param1 && _loc7_.level <= param2)
            {
               _loc4_.push(_loc7_);
            }
            _loc6_++;
         }
         return this.joinRecipeCosts(_loc4_);
      }
      
      public function getBuildTime(param1:int, param2:int) : Number
      {
         if(state.status.getLibcomModuleId() != AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
         {
            return 0;
         }
         if(param2 > this.maxTargetLevel || param1 >= this.maxTargetLevel)
         {
            return 0;
         }
         var _loc3_:RecipeCosts = this.collectSteps(param1,param2);
         return _loc3_.buildTimeSec;
      }
      
      public function getIngredients(param1:int, param2:int) : Vector.<AssemblyLootCount>
      {
         var _loc7_:BuildPart = null;
         var _loc8_:AssemblyLootCount = null;
         if(state.status.getLibcomModuleId() != AssemblyRecipeAvailableStatusModule.instance.getLibcomModuleId())
         {
            return null;
         }
         if(param2 > this.maxTargetLevel || param1 >= this.maxTargetLevel)
         {
            return null;
         }
         var _loc3_:RecipeCosts = this.collectSteps(param1,param2);
         var _loc4_:Vector.<AssemblyLootCount> = new Vector.<AssemblyLootCount>();
         var _loc5_:int = int(_loc3_.parts.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_.parts[_loc6_];
            _loc8_ = new AssemblyLootCount(ItemDataProviderHelper.getItem(_loc7_.lootID),_loc7_.ammount,ItemDataProviderHelper.getAmountWithDiscount(_loc7_.lootID,_loc7_.ammount,source));
            _loc8_.setCount(this.getLootCount(_loc7_.lootID).count.value);
            _loc4_.push(_loc8_);
            _loc6_++;
         }
         return _loc4_;
      }
      
      public function getSkipIngredients(param1:int, param2:int) : Vector.<AssemblyLootCount>
      {
         var _loc7_:BuildPart = null;
         var _loc8_:AssemblyLootCount = null;
         if(state.status.getLibcomModuleId() != AssemblyRecipeBuildStatusModule.instance.getLibcomModuleId())
         {
            return null;
         }
         if(param2 > this.maxTargetLevel || param1 >= this.maxTargetLevel)
         {
            return null;
         }
         var _loc3_:RecipeCosts = this.collectSteps(param1,param2);
         var _loc4_:Vector.<AssemblyLootCount> = new Vector.<AssemblyLootCount>();
         var _loc5_:int = int(_loc3_.skipCosts.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc3_.skipCosts[_loc6_];
            _loc8_ = new AssemblyLootCount(ItemDataProviderHelper.getItem(_loc7_.lootID),_loc7_.ammount,ItemDataProviderHelper.getAmountWithDiscount(_loc7_.lootID,_loc7_.ammount,source));
            _loc8_.setCount(this.getLootCount(_loc7_.lootID).count.value);
            _loc4_.push(_loc8_);
            _loc6_++;
         }
         return _loc4_;
      }
      
      private function joinRecipeCosts(param1:Vector.<RecipeCosts>) : RecipeCosts
      {
         var _loc5_:RecipeCosts = null;
         var _loc2_:RecipeCosts = new RecipeCosts();
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc2_.buildTimeSec += _loc5_.buildTimeSec;
            this.joinBuildParts(_loc2_.parts,_loc5_.parts);
            this.joinBuildParts(_loc2_.skipCosts,_loc5_.skipCosts);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function joinBuildParts(param1:Vector.<BuildPart>, param2:Vector.<BuildPart>) : void
      {
         var _loc3_:Boolean = false;
         var _loc6_:BuildPart = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BuildPart = null;
         var _loc10_:BuildPart = null;
         var _loc4_:int = int(param2.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = false;
            _loc6_ = param2[_loc5_];
            _loc7_ = int(param1.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = param1[_loc8_];
               if(_loc6_.lootID == _loc9_.lootID)
               {
                  _loc3_ = true;
                  _loc9_.ammount += _loc6_.ammount;
                  break;
               }
               _loc8_++;
            }
            if(!_loc3_)
            {
               _loc10_ = this.cloneBuildPart(_loc6_);
               param1.push(_loc10_);
            }
            _loc5_++;
         }
      }
      
      private function cloneBuildPart(param1:BuildPart) : BuildPart
      {
         var _loc2_:BuildPart = new BuildPart();
         _loc2_.ammount = param1.ammount;
         _loc2_.lootID = param1.lootID;
         return _loc2_;
      }
      
      private function getLootCount(param1:String) : AssemblyLootCount
      {
         var _loc4_:AssemblyLootCount = null;
         var _loc2_:int = int(_ingredients.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _ingredients[_loc3_];
            if(_loc4_.lootId == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

