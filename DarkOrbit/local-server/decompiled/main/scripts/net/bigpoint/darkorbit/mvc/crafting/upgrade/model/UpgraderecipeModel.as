package net.bigpoint.darkorbit.mvc.crafting.upgrade.model
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   import net.bigpoint.darkorbit.mvc.discount.model.DiscountSource;
   
   public class UpgraderecipeModel extends TargetItemRecipeModel
   {
      
      public function UpgraderecipeModel(param1:ItemVO, param2:Vector.<ItemVO>, param3:Number, param4:String = null)
      {
         super(param1,param2,param3,DiscountSource.UPGRADE);
      }
   }
}

