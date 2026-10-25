package net.bigpoint.darkorbit.mvc.crafting.disassembly.model
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.traits.StackableTrait;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   
   public class DisassemblyRecipeModel extends TargetItemRecipeModel
   {
      
      public function DisassemblyRecipeModel(param1:ItemVO, param2:Vector.<ItemVO>, param3:Number)
      {
         super(param1,param2,param3,null);
      }
      
      public function getOverflowResources(param1:int) : Vector.<ItemVO>
      {
         var _loc6_:AssemblyLootCount = null;
         var _loc7_:StackableTrait = null;
         var _loc2_:Vector.<ItemVO> = new Vector.<ItemVO>();
         var _loc3_:Vector.<AssemblyLootCount> = getIngredients(param1 - 1,param1).filter(AssemblyLootCount.filterNegative);
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc7_ = _loc6_.itemVO.getTraitByType(StackableTrait.TYPE) as StackableTrait;
            if((Boolean(_loc7_)) && _loc7_.maxQuantity < _loc6_.count.value + _loc6_.total * -1)
            {
               _loc2_.push(_loc6_.itemVO);
            }
            _loc5_++;
         }
         return _loc2_;
      }
   }
}

