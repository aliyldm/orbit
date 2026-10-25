package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.TabBarAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchRedDotData;
   
   public class TabSpaceSearchAssigner extends TabBarAssigner
   {
      
      public var selectedButton:Button;
      
      public var tabButton:Button;
      
      public var redDot:Coreponent;
      
      public var redDotSprite:Sprite = new Sprite();
      
      public var key:String = "";
      
      public function TabSpaceSearchAssigner()
      {
         super();
      }
      
      override protected function drawSelection() : void
      {
         this.redDot.visible = !_selected;
         super.drawSelection();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.key = String(param1);
         SpaceSearchRedDotData.tabDictionary[this.key] = this;
         if(SpaceSearchRedDotData.instance)
         {
            SpaceSearchRedDotData.instance.tryUpdate();
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.redDot = FuiComponentSelectorUtil.selectComponent("redDot",this) as Coreponent;
         this.selectedButton = FuiComponentSelectorUtil.selectComponent("tab_selected",this) as Button;
         this.redDot.addChild(this.redDotSprite);
         this.redDotSprite.visible = false;
         this.redDotSprite.x = 4;
         this.redDotSprite.y = 4;
         SpaceSearchRedDotData.drawDot(this.redDotSprite);
         this.tabButton = FuiComponentSelectorUtil.selectComponent("tab",this) as Button;
      }
   }
}

