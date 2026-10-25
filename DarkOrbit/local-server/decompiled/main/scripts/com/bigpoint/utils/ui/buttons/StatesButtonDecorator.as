package com.bigpoint.utils.ui.buttons
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
   
   public class StatesButtonDecorator extends DOAbstractComponentDecorator
   {
      
      public var selectedState:Sprite;
      
      public var rollOverState:Sprite;
      
      public var mouseDownState:Sprite;
      
      public var labelF:TextField;
      
      public var background:Sprite;
      
      private var _selected:Boolean;
      
      public function StatesButtonDecorator(param1:DisplayObjectContainer)
      {
         super(param1);
         this.addListeners();
         mouseChildren = false;
         buttonMode = true;
         this.hideUnusedStates();
      }
      
      override public function decorate() : void
      {
         addViewChild(this.background = getSpriteChild(this.backgroundLinkage,true));
         addViewChild(this.rollOverState = getSpriteChild(this.rollOverStateLinkage));
         addViewChild(this.mouseDownState = getSpriteChild(this.mouseDownStateLinkage));
         addViewChild(this.selectedState = getSpriteChild(this.selectedStateLinkage,true));
         addViewChild(this.labelF = getTextFieldChild("labelF",true));
      }
      
      protected function addListeners() : void
      {
         addEventListener(MouseEvent.ROLL_OVER,this.rollHandler,false,1000,true);
         addEventListener(MouseEvent.ROLL_OUT,this.rollHandler,false,1000,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseUpDownHandler,false,0,true);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpDownHandler,false,0,true);
         addEventListener(MouseEvent.CLICK,this.clickHandler,false,0,true);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClickHandler);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeFromStageListener,false,0,true);
      }
      
      public function rollHandler(param1:MouseEvent) : void
      {
         if(!this._selected)
         {
            setVisibility(param1.type == MouseEvent.ROLL_OVER,this.rollOverState);
            if(param1.type == MouseEvent.ROLL_OUT)
            {
               setVisibility(false,this.mouseDownState);
            }
         }
      }
      
      protected function hideUnusedStates() : void
      {
         setVisibility(false,this.selectedState,0);
         setVisibility(false,this.rollOverState,0);
         setVisibility(false,this.mouseDownState,0);
      }
      
      public function mouseUpDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = param1.type == MouseEvent.MOUSE_DOWN;
         if(!this._selected)
         {
            setVisibility(_loc2_,this.mouseDownState,0.1);
            if(Boolean(this.selectedState) || Boolean(this.mouseDownState))
            {
               if(_loc2_)
               {
                  setVisibility(false,this.rollOverState,0.6);
               }
            }
         }
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
      }
      
      protected function doubleClickHandler(param1:MouseEvent) : void
      {
      }
      
      protected function removeFromStageListener(param1:Event) : void
      {
      }
      
      public function set selected(param1:Boolean) : void
      {
         setVisibility(param1,this.selectedState);
         if(param1)
         {
            setVisibility(false,this.rollOverState,0);
            setVisibility(false,this.mouseDownState,0);
         }
         this._selected = param1;
      }
      
      protected function get backgroundLinkage() : String
      {
         return "background";
      }
      
      protected function get rollOverStateLinkage() : String
      {
         return "rollOverState";
      }
      
      protected function get mouseDownStateLinkage() : String
      {
         return "mouseDownState";
      }
      
      protected function get selectedStateLinkage() : String
      {
         return "selectedState";
      }
      
      public function set enable(param1:Boolean) : void
      {
         mouseEnabled = param1;
         alpha = param1 ? 1 : 0.3;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
   }
}

