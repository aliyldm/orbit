package com.bigpoint.utils.ui.tooltip
{
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.Styles;
   
   public class ToolTipHook
   {
      
      private static var tooltipText:TextField;
      
      private static const MAX_TOOLTIP_WIDTH:int = 300;
      
      private static const SHOW_DELAY:int = 500;
      
      private static const HIDE_DELAY:int = 100;
      
      private var targetObject:InteractiveObject;
      
      private var text:String;
      
      private var t:Timer;
      
      private var toolTipVisible:Boolean;
      
      private var bounds:Rectangle;
      
      public var showImmediately:Boolean = false;
      
      private var htmlText:Boolean;
      
      public function ToolTipHook(param1:InteractiveObject, param2:String, param3:Boolean = false)
      {
         super();
         this.targetObject = param1;
         this.text = param2;
         this.htmlText = param3;
      }
      
      public function updateText(param1:String) : void
      {
         this.text = param1;
         if(this.toolTipVisible && tooltipText != null)
         {
            if(this.htmlText)
            {
               tooltipText.htmlText = param1;
            }
            else
            {
               tooltipText.text = param1;
            }
            this.updateTextFieldWidth();
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(this.showImmediately)
         {
            this.showTooltip();
         }
         else
         {
            this.t = new Timer(SHOW_DELAY,1);
            this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t.start();
         }
      }
      
      private function onRollOut(param1:MouseEvent = null) : void
      {
         if(this.t != null)
         {
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t.stop();
            this.t = null;
         }
         if(this.toolTipVisible)
         {
            this.t = new Timer(HIDE_DELAY,1);
            this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.hideTooltip);
            this.t.start();
         }
      }
      
      public function addEventListeners() : void
      {
         this.targetObject.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.targetObject.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      private function removeEventListeners() : void
      {
         this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         this.bounds = param1;
      }
      
      public function showTooltip(param1:TimerEvent = null) : void
      {
         var event:TimerEvent = param1;
         if(tooltipText == null)
         {
            this.createToolTipTextField();
         }
         if(this.bounds == null || this.targetObject == null)
         {
            return;
         }
         if(this.htmlText)
         {
            tooltipText.htmlText = this.text;
         }
         else
         {
            tooltipText.text = this.text;
         }
         this.updateTextFieldWidth();
         try
         {
            tooltipText.x = this.targetObject.stage.mouseX + 10;
            tooltipText.y = this.targetObject.stage.mouseY - tooltipText.height - 10;
            if(tooltipText.x + tooltipText.width > this.bounds.width)
            {
               tooltipText.x = this.targetObject.stage.mouseX - tooltipText.width - 10;
            }
            if(tooltipText.y - tooltipText.height < 0)
            {
               tooltipText.y = this.targetObject.stage.mouseY + 10;
            }
            this.targetObject.stage.addChild(tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = true;
      }
      
      public function hideTooltip(param1:TimerEvent = null) : void
      {
         if(this.t != null)
         {
            this.t.stop();
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.hideTooltip);
            this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
            this.t = null;
         }
         try
         {
            this.targetObject.stage.removeChild(tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = false;
      }
      
      public function hide2() : void
      {
         try
         {
            this.targetObject.stage.removeChild(tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = false;
      }
      
      public function getTargetObject() : InteractiveObject
      {
         return this.targetObject;
      }
      
      internal function suicide() : void
      {
         try
         {
            this.removeEventListeners();
            this.hideTooltip(null);
         }
         catch(e:Error)
         {
         }
      }
      
      private function createToolTipTextField() : DisplayObject
      {
         tooltipText = new TextField();
         tooltipText.embedFonts = false;
         if(Styles.baseEmbed)
         {
            tooltipText.defaultTextFormat = Styles.tooltipFmt;
         }
         else
         {
            tooltipText.defaultTextFormat = Styles.tooltipFmtDeviceFonts;
         }
         tooltipText.autoSize = TextFieldAutoSize.LEFT;
         tooltipText.textColor = 13421772;
         tooltipText.backgroundColor = 0;
         tooltipText.background = true;
         tooltipText.border = true;
         tooltipText.borderColor = 1873341;
         tooltipText.antiAliasType = AntiAliasType.ADVANCED;
         tooltipText.selectable = false;
         tooltipText.wordWrap = true;
         tooltipText.multiline = true;
         if(this.htmlText)
         {
            tooltipText.htmlText = this.text;
         }
         else
         {
            tooltipText.text = this.text;
         }
         tooltipText.mouseEnabled = false;
         return tooltipText;
      }
      
      private function updateTextFieldWidth() : void
      {
         tooltipText.width = MAX_TOOLTIP_WIDTH;
         if(tooltipText.textWidth < MAX_TOOLTIP_WIDTH - 5)
         {
            tooltipText.width = tooltipText.textWidth + 5;
         }
      }
      
      public function getText() : String
      {
         return tooltipText.text;
      }
   }
}

