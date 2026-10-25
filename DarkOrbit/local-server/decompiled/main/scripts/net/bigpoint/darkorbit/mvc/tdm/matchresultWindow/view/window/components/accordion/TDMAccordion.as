package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.accordion
{
   import flash.events.MouseEvent;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   import spark.components.List;
   
   public class TDMAccordion extends List
   {
      
      private static var _skinParts:Object = {
         "dataGroup":false,
         "scroller":false,
         "dropIndicator":false
      };
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _scrollInterval:int;
      
      public function TDMAccordion()
      {
         super();
         this.addEventListener("creationComplete",this.___TDMAccordion_List1_creationComplete);
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function item_mouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Number = dataGroup.getElementIndex(param1.currentTarget as IVisualElement);
         selectedIndices = calculateSelectedIndices(_loc2_,param1.shiftKey,true);
      }
      
      protected function mouseWheelHandler(param1:MouseEvent) : void
      {
         param1.delta = param1.delta > 0 ? this._scrollInterval : int(-this._scrollInterval);
      }
      
      public function set scrollInterval(param1:int) : void
      {
         this._scrollInterval = param1;
      }
      
      private function init() : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler,true);
      }
      
      public function ___TDMAccordion_List1_creationComplete(param1:FlexEvent) : void
      {
         this.init();
      }
   }
}

