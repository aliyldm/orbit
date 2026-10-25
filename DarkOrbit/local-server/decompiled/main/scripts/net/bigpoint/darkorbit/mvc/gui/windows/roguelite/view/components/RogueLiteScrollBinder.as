package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   
   public class RogueLiteScrollBinder
   {
      
      internal var _scrollbar:Scrollbar;
      
      internal var _scrollContainer:ScrollContainer;
      
      public function RogueLiteScrollBinder(param1:Scrollbar, param2:ScrollContainer)
      {
         super();
         this._scrollbar = param1;
         this._scrollContainer = param2;
         this._scrollbar.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollbarPositionChangeEvent);
         this._scrollContainer.addEventListener(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED,this.handleScrollContainerSizeChanged);
         this._scrollContainer.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollContainerMouseWheelEvent);
         this._scrollContainer.addEventListener(ScrollEvent.SCROLL_POSITION_CHANGED,this.handleScrollContainerScrollPositionChanged);
      }
      
      private function handleScrollContainerMouseWheelEvent(param1:MouseEvent) : void
      {
         this._scrollbar.updateScrollPositionByScrollDelta(param1.delta);
      }
      
      private function handleScrollContainerScrollPositionChanged(param1:MouseEvent) : void
      {
         if(param1.target != this._scrollContainer)
         {
            return;
         }
         this._scrollbar.setScrollPositionInPercent(this._scrollContainer.getScrollPositionInPercent());
      }
      
      private function handleScrollContainerSizeChanged(param1:ScrollEvent) : void
      {
         if(param1.target != this._scrollContainer)
         {
            return;
         }
         this._scrollbar.updateBySizes(param1.viewSize,param1.contentSize);
      }
      
      private function handleScrollbarPositionChangeEvent(param1:ScrollEvent) : void
      {
         if(param1.target != this._scrollbar)
         {
            return;
         }
         var _loc2_:Number = this._scrollbar.getScrollPositionInPercent();
         this._scrollContainer.setScrollPositionInPercent(_loc2_);
      }
   }
}

