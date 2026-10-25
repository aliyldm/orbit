package net.bigpoint.darkorbit.mvc.crafting.disassembly.model
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.attributes.RecipeAttributes;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyRecipeModel;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeModel;
   import org.as3commons.lang.StringUtils;
   
   public class DisassemblyProxy extends UpgradeProxy
   {
      
      public static const NAME:String = "DisassemblyProxy";
      
      public function DisassemblyProxy()
      {
         super();
         this.proxyName = NAME;
         this.setData(new DisassemblyModel());
      }
      
      private function get model() : DisassemblyModel
      {
         return data as DisassemblyModel;
      }
      
      override protected function getAllValidRecipes() : Vector.<ItemVO>
      {
         var _loc4_:ItemVO = null;
         var _loc1_:Vector.<ItemVO> = ItemDataProviderHelper.getItemsByAttrClass(RecipeAttributes);
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc1_[_loc3_];
            if(!StringUtils.startsWith(_loc4_.lootID,AssemblyConsts.DISASSEBLY_PREFIX))
            {
               _loc1_.splice(_loc3_,1);
            }
            _loc3_--;
         }
         return _loc1_;
      }
      
      override protected function addTypes(param1:Vector.<String>, param2:Object) : void
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.model.addType(new DisassemblyTypeModel(param2[param1[_loc4_]],ItemDataProviderHelper.getItem(param1[_loc4_])));
            _loc4_++;
         }
      }
      
      override protected function handleRecipeAdded(param1:AssemblyRecipeModel) : void
      {
         var _loc3_:Vector.<UpgradeTypeModel> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:UpgradeTypeModel = null;
         var _loc7_:Vector.<ItemVO> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:ItemVO = null;
         var _loc2_:DisassemblyRecipeModel = param1 as DisassemblyRecipeModel;
         if(_loc2_)
         {
            _loc3_ = this.model.availableUpgradeTypes;
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
               _loc7_ = _inventory.getById(_loc6_.targetItemType.lootID);
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
         invalidate();
      }
      
      override protected function handleRecipeRemoved(param1:AssemblyRecipeModel) : void
      {
         var _loc3_:Vector.<UpgradeTypeModel> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:UpgradeTypeModel = null;
         var _loc2_:DisassemblyRecipeModel = param1 as DisassemblyRecipeModel;
         if(_loc2_)
         {
            _loc3_ = this.model.availableUpgradeTypes;
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
         invalidate();
      }
   }
}

