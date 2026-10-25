package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabBarAssigner;
   
   public class SingularityDriveTabAssigner extends TabBarAssigner
   {
      
      public var selectedButton:Button;
      
      public var tabButton:Button;
      
      public var key:String = "";
      
      public function SingularityDriveTabAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.selectedButton = FuiComponentSelectorUtil.selectComponent("tab_selected",this) as Button;
         this.tabButton = FuiComponentSelectorUtil.selectComponent("tab",this) as Button;
      }
   }
}

