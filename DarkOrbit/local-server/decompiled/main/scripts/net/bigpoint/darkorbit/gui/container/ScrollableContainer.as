package net.bigpoint.darkorbit.gui.container
{
   import fl.containers.ScrollPane;
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.gui.GuiManager;
   
   public class ScrollableContainer extends SimpleContainer
   {
      
      private var aSp:ScrollPane;
      
      public function ScrollableContainer(param1:GuiManager, param2:int)
      {
         super(param1,param2);
         this.aSp = new ScrollPane();
         this.aSp.source = this;
      }
      
      override public function addElement(param1:DisplayObject, param2:int = 0, param3:int = 5) : void
      {
         super.addElement(param1,param2,param3);
         this.invalidateScroller();
      }
      
      protected function invalidateScroller() : void
      {
         this.aSp.invalidate();
         this.aSp.refreshPane();
      }
      
      public function getScrollPane() : ScrollPane
      {
         return this.aSp;
      }
      
      override public function get containerView() : DisplayObject
      {
         return this.aSp;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this.aSp.visible = param1;
      }
      
      override public function get visible() : Boolean
      {
         return this.aSp.visible;
      }
   }
}

