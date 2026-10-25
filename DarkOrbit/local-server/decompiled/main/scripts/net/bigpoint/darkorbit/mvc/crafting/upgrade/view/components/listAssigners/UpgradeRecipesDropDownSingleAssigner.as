package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners
{
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class UpgradeRecipesDropDownSingleAssigner extends UpgradeRecipesDropDownListAssigner
   {
      
      private var _arrow:Coreponent;
      
      public function UpgradeRecipesDropDownSingleAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._arrow = FuiComponentSelectorUtil.selectComponent("arrowContainer.arrow",this) as Coreponent;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         var _loc1_:Boolean = isSelected();
         this._arrow.setSkinState(_loc1_ ? "normal" : "down");
      }
   }
}

