package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.menuBar
{
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.SlotAndItemBarElement;
   
   public class TwoLevelsMenuBar extends MenuBar
   {
      
      private static const ARROW_OFFSET:int = 15;
      
      private var _secondLevelMenuBar:MenuBar;
      
      public function TwoLevelsMenuBar(param1:SWFFinisher)
      {
         super(param1,false);
      }
      
      override public function decorate() : void
      {
         super.decorate();
         addViewChild(this._secondLevelMenuBar = new MenuBar(_swfFinisher,false));
      }
      
      override public function updateLayout() : void
      {
         super.updateLayout();
         this._secondLevelMenuBar.y = -this._secondLevelMenuBar.height - 1;
      }
      
      override public function get topOffset() : int
      {
         return SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP;
      }
      
      override public function get boundsHeight() : int
      {
         return 2 * (SlotAndItemBarElement.DEFAULT_SIZE + SLOTS_GAP) + SLOTS_GAP;
      }
      
      override public function get boundsWidth() : int
      {
         return super.boundsWidth + ARROW_OFFSET;
      }
      
      public function get secondLevelMenuBar() : MenuBar
      {
         return this._secondLevelMenuBar;
      }
   }
}

