package net.bigpoint.darkorbit.mvc.gui.messages.view.components
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quad;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.GridFitType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.vo.LogMessageProfileVO;
   
   public class InstantMessageItem extends Sprite
   {
      
      private static var I:uint;
      
      public static const HANDLE_FADEOUT_COMPLETE:String = "handleFadeOutComplete";
      
      private static const mediumGlowFilter:Array = [new GlowFilter(0,1,4,4,6,1)];
      
      private static const textFormat:TextFormat = new TextFormat(Styles.h2Fmt.font,Styles.h2FontHeight);
      
      private static const DELETE_VARS:Object = {"y":true};
      
      textFormat.align = TextFormatAlign.CENTER;
      textFormat.color = 16777215;
      
      private var _logMessageProfile:LogMessageProfileVO;
      
      private var _started:Boolean;
      
      private var _msg:String;
      
      private var _itemWidth:int;
      
      private var _index:uint;
      
      public function InstantMessageItem(param1:String, param2:int, param3:LogMessageProfileVO)
      {
         super();
         this._itemWidth = param2;
         this._index = ++I;
         this._logMessageProfile = param3;
         this._msg = param1;
      }
      
      public static function sort(param1:InstantMessageItem, param2:InstantMessageItem) : int
      {
         if(param1.logMessageProfile.highPriority == param2.logMessageProfile.highPriority)
         {
            return param1.index - param2.index;
         }
         return param1.logMessageProfile.highPriority ? -1 : 1;
      }
      
      public function start() : void
      {
         var _loc1_:TextField = null;
         if(!this._started)
         {
            _loc1_ = new TextField();
            _loc1_.defaultTextFormat = textFormat;
            _loc1_.autoSize = TextFieldAutoSize.CENTER;
            _loc1_.embedFonts = Styles.h2Embed;
            _loc1_.text = this._msg;
            _loc1_.width = this._itemWidth;
            _loc1_.wordWrap = true;
            _loc1_.gridFitType = GridFitType.SUBPIXEL;
            _loc1_.antiAliasType = AntiAliasType.ADVANCED;
            _loc1_.filters = mediumGlowFilter;
            _loc1_.autoSize = TextFieldAutoSize.CENTER;
            _loc1_.x = -_loc1_.width * 0.5;
            addChild(_loc1_);
            alpha = 0;
            this._started = true;
            TweenLite.to(this,0.3,{"alpha":1});
            TweenMax.delayedCall(this.logMessageProfile.displayTime,this.startFadeOut);
         }
      }
      
      public function dispose() : void
      {
         TweenLite.killTweensOf(this);
         visible = false;
         this.removeFromParent();
      }
      
      public function removeFromParent() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      public function moveTo(param1:int) : void
      {
         if(param1 == y)
         {
            return;
         }
         if(!this._started)
         {
            y = param1;
         }
         else
         {
            y = param1;
            TweenLite.killTweensOf(this,false,DELETE_VARS);
            TweenLite.to(this,0.2,{
               "y":param1,
               "ease":Quad.easeOut
            });
         }
      }
      
      private function startFadeOut() : void
      {
         TweenLite.to(this,0.3,{
            "alpha":0,
            "ease":Quad.easeOut,
            "onComplete":this.handleFadeOutComplete
         });
      }
      
      private function handleFadeOutComplete() : void
      {
         this.dispose();
         dispatchEvent(new Event(HANDLE_FADEOUT_COMPLETE));
      }
      
      public function get logMessageProfile() : LogMessageProfileVO
      {
         return this._logMessageProfile;
      }
      
      override public function toString() : String
      {
         return "{_logMessageProfile=" + String(this._logMessageProfile.highPriority) + ",_msg=" + String(this._msg) + "}";
      }
      
      public function get index() : uint
      {
         return this._index;
      }
   }
}

