package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components
{
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui.IngredientAssigner;
   
   public class UpgradeIngredientAssigner extends IngredientAssigner
   {
      
      public function UpgradeIngredientAssigner()
      {
         super();
      }
      
      override protected function getTotal(param1:AssemblyLootCount) : Number
      {
         return param1.total;
      }
   }
}

