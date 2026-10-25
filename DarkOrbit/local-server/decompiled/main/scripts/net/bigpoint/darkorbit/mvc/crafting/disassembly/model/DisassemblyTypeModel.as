package net.bigpoint.darkorbit.mvc.crafting.disassembly.model
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeRecipeItemPair;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeModel;
   
   public class DisassemblyTypeModel extends UpgradeTypeModel
   {
      
      public function DisassemblyTypeModel(param1:Vector.<ItemVO>, param2:ItemVO)
      {
         super(param1,param2);
      }
      
      override protected function isVisibleTarget(param1:UpgradeRecipeItemPair, param2:int = 0, param3:Vector.<UpgradeRecipeItemPair> = null) : Boolean
      {
         return UpgradeRecipeItemPair.filterEmptyEquippedAndUnupgraded(param1,param2,param3);
      }
      
      override public function addPossibleTarget(param1:ItemVO) : void
      {
         var _loc2_:UpgradeRecipeItemPair = getOrAdd(param1.id);
         _loc2_.item = param1;
      }
   }
}

