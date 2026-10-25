package com.bigpoint.utils.ui.tooltip
{
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class StickyToolTipHook
   {
      
      private static const SHOW_DELAY:int = 500;
      
      private static const HIDE_DELAY:int = 100;
      
      private var targetObject:DisplayObject;
      
      private var text:String;
      
      public var toolTipVisible:Boolean;
      
      private var MAX_TOOLTIP_WIDTH:int = 220;
      
      private var tooltipText:TextField;
      
      private var bounds:Rectangle;
      
      private var xGap:Number = 0;
      
      private var yGap:Number = 0;
      
      private var htmlText:Boolean;
      
      public function StickyToolTipHook(param1:DisplayObject, param2:String, param3:int, param4:int, param5:int, param6:Boolean = false)
      {
         super();
         this.targetObject = param1;
         this.text = param2;
         this.xGap = param3;
         this.yGap = param4;
         this.htmlText = param6;
         this.MAX_TOOLTIP_WIDTH = param5;
         this.createToolTipTextField();
      }
      
      public function updateText(param1:String) : void
      {
         this.text = param1;
         if(this.htmlText)
         {
            this.tooltipText.htmlText = param1;
         }
         else
         {
            this.tooltipText.text = param1;
         }
      }
      
      public function setBounds(param1:Rectangle) : void
      {
         this.bounds = param1;
      }
      
      public function showTooltip() : void
      {
         if(this.bounds == null || this.targetObject == null || this.tooltipText == null || this.targetObject.stage == null)
         {
            return;
         }
         this.tooltipText.x = this.targetObject.x + this.xGap + this.targetObject.stage.x;
         this.tooltipText.y = this.targetObject.y + this.yGap + this.targetObject.stage.y;
         if(this.tooltipText.x < 0)
         {
            this.tooltipText.x = 0;
         }
         if(this.tooltipText.x + this.tooltipText.width > this.bounds.width)
         {
            this.tooltipText.x -= this.tooltipText.x + this.tooltipText.width - this.bounds.width;
         }
         if(this.tooltipText.y < 0)
         {
            this.tooltipText.y = 0;
         }
         if(this.tooltipText.y + this.tooltipText.height > this.bounds.height)
         {
            this.tooltipText.y -= this.tooltipText.y + this.tooltipText.height - this.bounds.height;
         }
         try
         {
            this.targetObject.stage.addChild(this.tooltipText);
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = true;
      }
      
      public function hideTooltip(param1:TimerEvent = null) : void
      {
         MovieClipUtils.removeDisplayObject(this.tooltipText);
         this.toolTipVisible = false;
      }
      
      public function getTargetObject() : DisplayObject
      {
         return this.targetObject;
      }
      
      public function suicide() : void
      {
         try
         {
            this.hideTooltip(null);
         }
         catch(e:Error)
         {
         }
      }
      
      private function createToolTipTextField() : DisplayObject
      {
         this.tooltipText = new TextField();
         this.tooltipText.multiline = true;
         this.tooltipText.defaultTextFormat = Styles.tooltipFmt;
         if(Styles.tooltipEmbed)
         {
            this.tooltipText.defaultTextFormat = Styles.tooltipFmt;
         }
         else
         {
            this.tooltipText.defaultTextFormat = Styles.tooltipFmtDeviceFonts;
         }
         this.tooltipText.embedFonts = Styles.tooltipEmbed;
         this.tooltipText.autoSize = TextFieldAutoSize.LEFT;
         this.tooltipText.textColor = 13421772;
         this.tooltipText.backgroundColor = 0;
         this.tooltipText.background = true;
         this.tooltipText.border = true;
         this.tooltipText.borderColor = 1873341;
         this.tooltipText.antiAliasType = AntiAliasType.ADVANCED;
         this.tooltipText.selectable = false;
         if(this.htmlText)
         {
            this.tooltipText.htmlText = this.text;
         }
         else
         {
            this.tooltipText.text = this.text;
         }
         this.tooltipText.mouseEnabled = false;
         if(this.tooltipText.width > this.MAX_TOOLTIP_WIDTH)
         {
            this.tooltipText.width = this.MAX_TOOLTIP_WIDTH;
            this.tooltipText.wordWrap = true;
         }
         return this.tooltipText;
      }
   }
}

