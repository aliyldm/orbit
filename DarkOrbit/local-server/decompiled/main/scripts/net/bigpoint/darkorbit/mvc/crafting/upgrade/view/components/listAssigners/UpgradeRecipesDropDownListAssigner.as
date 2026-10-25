package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.TargetItemRecipeModel;
   
   public class UpgradeRecipesDropDownListAssigner extends DefaultItemDataAssigner
   {
      
      private var _btn:Button;
      
      public function UpgradeRecipesDropDownListAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         var _loc2_:TargetItemRecipeModel = param1 as TargetItemRecipeModel;
         if(Boolean(label) && Boolean(_loc2_))
         {
            tooltipData = label.text = _loc2_.itemVO.fullname;
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._btn = FuiComponentSelectorUtil.selectComponent("btn",this) as Button;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
      }
   }
}

