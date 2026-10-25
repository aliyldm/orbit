package net.bigpoint.darkorbit.loadingscreen.utils
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class ToolTipHook
   {
      
      private static const MAX_TOOLTIP_WIDTH:int = 300;
      
      private static const SHOW_DELAY:int = 250;
      
      private static const HIDE_DELAY:int = 100;
      
      private static const OFFSET_Y:int = 10;
      
      private static const OFFSET_X:int = 10;
      
      private var bounds:Rectangle;
      
      private var targetObject:InteractiveObject;
      
      private var text:String;
      
      private var toolClip:DisplayObject;
      
      private var t:Timer;
      
      private var toolTipVisible:Boolean;
      
      public function ToolTipHook(param1:InteractiveObject, param2:String)
      {
         super();
         this.targetObject = param1;
         this.text = param2;
         this.targetObject.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.targetObject.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.targetObject.addEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
         this.toolClip = this.createToolTipTextField();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.t = new Timer(SHOW_DELAY,1);
         this.t.addEventListener(TimerEvent.TIMER_COMPLETE,this.showTooltip);
         this.t.start();
      }
      
      private function onRollOut(param1:MouseEvent) : void
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
      
      private function showTooltip(param1:TimerEvent) : void
      {
         this.toolClip.x = this.targetObject.stage.mouseX + OFFSET_X;
         this.toolClip.y = this.targetObject.stage.mouseY + OFFSET_Y;
         this.bounds = this.targetObject.stage.getBounds(this.targetObject.stage);
         if(this.toolClip.x + this.toolClip.width > this.bounds.width)
         {
            this.toolClip.x = this.targetObject.stage.mouseX - this.toolClip.width - OFFSET_X;
         }
         if(this.toolClip.y + this.toolClip.height > this.bounds.height)
         {
            this.toolClip.y = this.targetObject.stage.mouseY - this.toolClip.height - OFFSET_Y;
         }
         try
         {
            this.toolClip.alpha = 0;
            this.targetObject.stage.addChild(this.toolClip);
            this.targetObject.addEventListener(MouseEvent.MOUSE_MOVE,this.moveToolTipWithMouse);
            TweenLite.to(this.toolClip,0.2,{"alpha":1});
         }
         catch(e:Error)
         {
         }
         this.toolTipVisible = true;
      }
      
      private function moveToolTipWithMouse(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.toolClip.x < this.targetObject.stage.mouseX)
         {
            _loc2_ = this.targetObject.stage.mouseX - this.toolClip.width - OFFSET_X;
            if(_loc2_ >= 0)
            {
               this.toolClip.x = _loc2_;
            }
         }
         else
         {
            _loc2_ = this.targetObject.stage.mouseX + OFFSET_X;
            if(_loc2_ + this.toolClip.width <= this.bounds.width)
            {
               this.toolClip.x = _loc2_;
            }
         }
         if(this.toolClip.y < this.targetObject.stage.mouseY)
         {
            _loc3_ = this.targetObject.stage.mouseY - this.toolClip.height - OFFSET_Y;
            if(_loc3_ >= 0)
            {
               this.toolClip.y = _loc3_;
            }
         }
         else
         {
            _loc3_ = this.targetObject.stage.mouseY + OFFSET_Y;
            if(_loc3_ + this.toolClip.height <= this.bounds.height)
            {
               this.toolClip.y = _loc3_;
            }
         }
      }
      
      private function hideTooltip(param1:TimerEvent) : void
      {
         this.t.removeEventListener(TimerEvent.TIMER_COMPLETE,this.hideTooltip);
         try
         {
            this.targetObject.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveToolTipWithMouse);
            this.targetObject.stage.removeChild(this.toolClip);
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
      
      public function suicide() : void
      {
         try
         {
            this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            this.targetObject.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOut);
            this.targetObject.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRollOut);
            this.targetObject.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveToolTipWithMouse);
            this.hideTooltip(null);
         }
         catch(e:Error)
         {
         }
      }
      
      private function createToolTipTextField() : DisplayObject
      {
         var _loc1_:TextField = new TextField();
         _loc1_.multiline = true;
         _loc1_.defaultTextFormat = Styles.tooltipFmt;
         _loc1_.embedFonts = Styles.tooltipEmbed;
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.backgroundColor = 1257018;
         _loc1_.background = true;
         _loc1_.border = true;
         _loc1_.borderColor = 1873341;
         _loc1_.antiAliasType = AntiAliasType.ADVANCED;
         _loc1_.selectable = false;
         _loc1_.text = "\n" + this.text + "\n ";
         _loc1_.mouseEnabled = false;
         if(_loc1_.width > MAX_TOOLTIP_WIDTH)
         {
            _loc1_.width = MAX_TOOLTIP_WIDTH;
            _loc1_.wordWrap = true;
         }
         return _loc1_;
      }
   }
}

