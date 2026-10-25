package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import mx.core.IVisualElement;
   import mx.core.mx_internal;
   import mx.events.ResizeEvent;
   import spark.components.List;
   
   use namespace mx_internal;
   
   public class AccordionList extends List
   {
      
      private static var _skinParts:Object = {
         "dataGroup":false,
         "scroller":false,
         "dropIndicator":false
      };
      
      private var expandingItem:EventDispatcher;
      
      public function AccordionList()
      {
         super();
         useVirtualLayout = false;
         addEventListener("expandEffectStart",this.item_expandStartHandler,true);
      }
      
      protected function item_expandStartHandler(param1:Event) : void
      {
         this.expandingItem = null;
         addEventListener("expandEffectEnd",this.item_expandEndHandler,true);
         var _loc2_:EventDispatcher = param1.target as EventDispatcher;
         if(_loc2_)
         {
            _loc2_.addEventListener(ResizeEvent.RESIZE,this.item_resizeHandler);
            this.expandingItem = _loc2_;
         }
      }
      
      protected function item_resizeHandler(param1:ResizeEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc2_:IVisualElement = param1.target as IVisualElement;
         if(Boolean(_loc2_) && Boolean(layout))
         {
            _loc3_ = layout.getScrollPositionDeltaToAnyElement(_loc2_);
            if(_loc3_)
            {
               _loc4_ = dataGroup.verticalScrollPosition + _loc3_.y;
               dataGroup.verticalScrollPosition = Math.round(Math.min(Math.max(_loc4_,0),this.maxVerticalScrollPosition));
            }
         }
      }
      
      protected function item_expandEndHandler(param1:Event) : void
      {
         removeEventListener("expandEffectEnd",this.item_expandEndHandler,true);
         if(this.expandingItem)
         {
            this.expandingItem.removeEventListener(ResizeEvent.RESIZE,this.item_resizeHandler);
         }
      }
      
      private function get maxVerticalScrollPosition() : Number
      {
         return scroller.viewport.contentHeight - scroller.viewport.height;
      }
   }
}

