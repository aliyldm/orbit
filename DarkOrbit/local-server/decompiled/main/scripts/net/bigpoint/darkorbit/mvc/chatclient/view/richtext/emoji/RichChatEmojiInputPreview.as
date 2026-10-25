package net.bigpoint.darkorbit.mvc.chatclient.view.richtext.emoji
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.fui.components.text.input.Input;
   import net.bigpoint.darkorbit.fui.components.text.input.InputSkin;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatProxy;
   
   public class RichChatEmojiInputPreview extends Sprite
   {
      
      private static const MAX_VISIBLE_CHARACTERS:int = DOChatProxy.MAX_MESSAGE_LENGTH;
      
      private static const MAX_INPUT_CODE_UNITS:int = MAX_VISIBLE_CHARACTERS * 2;
      
      private static const ICON_SIZE:Number = 22;
      
      private static const EMOJI_SLOT_WIDTH:Number = 23;
      
      private static const MARKER_FONT:String = "_typewriter";
      
      private static const MARKER_FONT_SIZE:Number = 1;
      
      private static const INPUT_BACKGROUND_COLOR:uint = 4890;
      
      private static const INPUT_TEXT_BOTTOM_PADDING:Number = 1;
      
      private static const MAX_LAYOUT_REFRESH_ATTEMPTS:int = 2;
      
      private var _input:Input;
      
      private var _normalTextFormat:TextFormat;
      
      private var _markerFormats:Object = {};
      
      private var _refreshing:Boolean;
      
      private var _refreshScheduled:Boolean;
      
      private var _layoutRefreshAttempts:int;
      
      private var _disposed:Boolean;
      
      public function RichChatEmojiInputPreview(param1:Input)
      {
         super();
         this._input = param1;
         mouseEnabled = false;
         mouseChildren = false;
         this._input.addChild(this);
         this._normalTextFormat = this.copyTextFormat(this.textField.defaultTextFormat);
         this._normalTextFormat.letterSpacing = 0;
         this.textField.maxChars = MAX_INPUT_CODE_UNITS;
         this.textField.addEventListener(Event.CHANGE,this.handleInputChanged);
         this.textField.addEventListener(Event.SCROLL,this.handleInputChanged);
         this.refresh();
      }
      
      private function get inputSkin() : InputSkin
      {
         return this._input.skin as InputSkin;
      }
      
      private function get textField() : TextField
      {
         return this.inputSkin.textField;
      }
      
      public function refresh() : void
      {
         var field:TextField = null;
         var selectionStart:int = 0;
         var selectionEnd:int = 0;
         var scrollH:Number = NaN;
         var emojiMarkers:Array = null;
         var i:int = 0;
         var missingBounds:Boolean = false;
         var markerData:Object = null;
         var marker:String = null;
         var id:String = null;
         var bounds:Rectangle = null;
         var iconPosition:Point = null;
         var fieldTopLeft:Point = null;
         var fieldTopRight:Point = null;
         var fieldLeft:Number = NaN;
         var fieldRight:Number = NaN;
         var iconX:Number = NaN;
         var inputTopLeft:Point = null;
         var inputBottomLeft:Point = null;
         var inputTop:Number = NaN;
         var inputBottom:Number = NaN;
         var iconY:Number = NaN;
         var bitmap:Bitmap = null;
         if(this._disposed || !this._input)
         {
            return;
         }
         if(this._refreshScheduled)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleScheduledRefresh);
            this._refreshScheduled = false;
         }
         if(this._refreshing)
         {
            this.scheduleRefresh();
            return;
         }
         this._refreshing = true;
         try
         {
            field = this.textField;
            this.limitInputLength();
            selectionStart = field.selectionBeginIndex;
            selectionEnd = field.selectionEndIndex;
            scrollH = field.scrollH;
            while(numChildren > 0)
            {
               removeChildAt(0);
            }
            graphics.clear();
            this.alignTextToBottom(field);
            field.defaultTextFormat = this._normalTextFormat;
            if(field.text.length > 0)
            {
               field.setTextFormat(this._normalTextFormat,0,field.text.length);
            }
            emojiMarkers = [];
            i = 0;
            while(i < field.text.length)
            {
               marker = field.text.charAt(i);
               id = RichChatEmojiCodec.getEmojiIdForMarker(marker);
               if(id)
               {
                  field.setTextFormat(this.getMarkerFormat(marker),i,i + 1);
                  emojiMarkers.push({
                     "index":i,
                     "id":id
                  });
               }
               i++;
            }
            field.scrollH = scrollH;
            missingBounds = false;
            for each(markerData in emojiMarkers)
            {
               bounds = field.getCharBoundaries(markerData.index);
               if(!bounds)
               {
                  missingBounds = true;
               }
               else
               {
                  iconPosition = field.localToGlobal(new Point(bounds.x - field.scrollH + (EMOJI_SLOT_WIDTH - ICON_SIZE) * 0.5,bounds.y));
                  iconPosition = globalToLocal(iconPosition);
                  fieldTopLeft = globalToLocal(field.localToGlobal(new Point(0,0)));
                  fieldTopRight = globalToLocal(field.localToGlobal(new Point(field.width,0)));
                  fieldLeft = Math.min(fieldTopLeft.x,fieldTopRight.x);
                  fieldRight = Math.max(fieldTopLeft.x,fieldTopRight.x);
                  iconX = iconPosition.x;
                  inputTopLeft = globalToLocal(this._input.localToGlobal(new Point(0,0)));
                  inputBottomLeft = globalToLocal(this._input.localToGlobal(new Point(0,this._input.height)));
                  inputTop = Math.min(inputTopLeft.y,inputBottomLeft.y);
                  inputBottom = Math.max(inputTopLeft.y,inputBottomLeft.y);
                  iconY = Math.max(inputTop,Math.min(iconPosition.y,inputBottom - ICON_SIZE));
                  if(!(iconX < fieldLeft || iconX + ICON_SIZE > fieldRight))
                  {
                     bitmap = RichChatEmojiRegistry.createBitmap(markerData.id,ICON_SIZE,ICON_SIZE);
                     if(bitmap)
                     {
                        bitmap.x = iconX;
                        bitmap.y = iconY;
                        addChild(bitmap);
                     }
                  }
               }
            }
            if(missingBounds)
            {
               this.scheduleRefresh();
            }
            else
            {
               this._layoutRefreshAttempts = 0;
            }
            field.defaultTextFormat = this._normalTextFormat;
            if(selectionStart >= 0 && selectionEnd >= 0)
            {
               selectionStart = Math.min(selectionStart,field.text.length);
               selectionEnd = Math.min(selectionEnd,field.text.length);
               field.setSelection(selectionStart,selectionEnd);
            }
            field.scrollH = scrollH;
         }
         finally
         {
            this._refreshing = false;
         }
      }
      
      public function dispose() : void
      {
         this._disposed = true;
         removeEventListener(Event.ENTER_FRAME,this.handleScheduledRefresh);
         this._refreshScheduled = false;
         if(Boolean(this._input) && Boolean(this._input.skin))
         {
            this.textField.removeEventListener(Event.CHANGE,this.handleInputChanged);
            this.textField.removeEventListener(Event.SCROLL,this.handleInputChanged);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this._input = null;
      }
      
      private function getMarkerFormat(param1:String) : TextFormat
      {
         var _loc2_:TextFormat = this._markerFormats[param1] as TextFormat;
         if(_loc2_)
         {
            return _loc2_;
         }
         var _loc3_:TextFormat = new TextFormat(MARKER_FONT,MARKER_FONT_SIZE,INPUT_BACKGROUND_COLOR);
         _loc3_.letterSpacing = 0;
         var _loc4_:TextField = new TextField();
         _loc4_.width = 100;
         _loc4_.height = 30;
         _loc4_.defaultTextFormat = this._normalTextFormat;
         _loc4_.text = param1 + "|";
         _loc4_.setTextFormat(_loc3_,0,1);
         _loc4_.setTextFormat(this._normalTextFormat,1,2);
         var _loc5_:Rectangle = _loc4_.getCharBoundaries(0);
         var _loc6_:Rectangle = _loc4_.getCharBoundaries(1);
         var _loc7_:Number = Boolean(_loc5_) && Boolean(_loc6_) ? _loc6_.x - _loc5_.x : MARKER_FONT_SIZE;
         if(isNaN(_loc7_) || _loc7_ <= 0 || _loc7_ > EMOJI_SLOT_WIDTH)
         {
            _loc7_ = MARKER_FONT_SIZE;
         }
         var _loc8_:TextFormat = new TextFormat(MARKER_FONT,MARKER_FONT_SIZE,INPUT_BACKGROUND_COLOR);
         _loc8_.letterSpacing = EMOJI_SLOT_WIDTH - _loc7_;
         this._markerFormats[param1] = _loc8_;
         return _loc8_;
      }
      
      private function alignTextToBottom(param1:TextField) : void
      {
         var _loc2_:Number = Number(this._normalTextFormat.size);
         if(isNaN(_loc2_) || _loc2_ <= 0)
         {
            _loc2_ = 11;
         }
         var _loc3_:Number = _loc2_ + 4;
         param1.y = Math.max(0,Math.round(this._input.height - _loc3_ - INPUT_TEXT_BOTTOM_PADDING));
         param1.height = Math.max(_loc3_,this._input.height - param1.y);
      }
      
      private function copyTextFormat(param1:TextFormat) : TextFormat
      {
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.align = param1.align;
         _loc2_.blockIndent = param1.blockIndent;
         _loc2_.bold = param1.bold;
         _loc2_.bullet = param1.bullet;
         _loc2_.color = param1.color;
         _loc2_.font = param1.font;
         _loc2_.indent = param1.indent;
         _loc2_.italic = param1.italic;
         _loc2_.kerning = param1.kerning;
         _loc2_.leading = param1.leading;
         _loc2_.leftMargin = param1.leftMargin;
         _loc2_.letterSpacing = param1.letterSpacing;
         _loc2_.rightMargin = param1.rightMargin;
         _loc2_.size = param1.size;
         _loc2_.tabStops = param1.tabStops;
         _loc2_.target = param1.target;
         _loc2_.underline = param1.underline;
         _loc2_.url = param1.url;
         return _loc2_;
      }
      
      private function scheduleRefresh() : void
      {
         if(this._disposed || this._refreshScheduled || this._layoutRefreshAttempts >= MAX_LAYOUT_REFRESH_ATTEMPTS)
         {
            return;
         }
         ++this._layoutRefreshAttempts;
         this._refreshScheduled = true;
         addEventListener(Event.ENTER_FRAME,this.handleScheduledRefresh);
      }
      
      private function limitInputLength() : void
      {
         var _loc1_:TextField = this.textField;
         var _loc2_:String = this.truncateByCodePoint(_loc1_.text,MAX_VISIBLE_CHARACTERS);
         if(_loc2_ == _loc1_.text)
         {
            return;
         }
         var _loc3_:int = Math.max(0,Math.min(_loc1_.selectionBeginIndex,_loc2_.length));
         var _loc4_:int = Math.max(_loc3_,Math.min(_loc1_.selectionEndIndex,_loc2_.length));
         _loc1_.text = _loc2_;
         this._input.text = _loc2_;
         _loc1_.setSelection(_loc3_,_loc4_);
      }
      
      private function truncateByCodePoint(param1:String, param2:int) : String
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(!param1 || param2 <= 0)
         {
            return "";
         }
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length && _loc3_ < param2)
         {
            _loc5_ = param1.charCodeAt(_loc4_++);
            if(_loc5_ >= 55296 && _loc5_ <= 56319 && _loc4_ < param1.length)
            {
               _loc6_ = param1.charCodeAt(_loc4_);
               if(_loc6_ >= 56320 && _loc6_ <= 57343)
               {
                  _loc4_++;
               }
            }
            _loc3_++;
         }
         return _loc4_ < param1.length ? param1.substring(0,_loc4_) : param1;
      }
      
      private function handleInputChanged(param1:Event) : void
      {
         if(param1.type == Event.CHANGE)
         {
            this._layoutRefreshAttempts = 0;
         }
         this.refresh();
      }
      
      private function handleScheduledRefresh(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleScheduledRefresh);
         this._refreshScheduled = false;
         this.refresh();
      }
   }
}

