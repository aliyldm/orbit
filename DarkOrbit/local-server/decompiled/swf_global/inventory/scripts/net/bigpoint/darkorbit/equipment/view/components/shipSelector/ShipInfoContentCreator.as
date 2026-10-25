package net.bigpoint.darkorbit.equipment.view.components.shipSelector
{
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipSkillVO;
   
   public class ShipInfoContentCreator
   {
      
      private static var initialized:Boolean = false;
      
      private static var TEXTFORMAT_VALUE:TextFormat = new TextFormat();
      
      private static var TEXTFORMAT_ATTRIBUTE:TextFormat = new TextFormat();
      
      private static var TEXTFORMAT_SKILL_NAME:TextFormat = new TextFormat();
      
      private static const TEXT_HEIGHT:uint = 16;
      
      private static const SEPARATOR_HEIGHT:uint = 6;
      
      private var _yPosLine:uint;
      
      private var _urlLoaderToIcon:Dictionary = new Dictionary();
      
      public function ShipInfoContentCreator()
      {
         super();
         if(!initialized)
         {
            this.initTextFormat();
         }
      }
      
      private function initTextFormat() : void
      {
         TEXTFORMAT_ATTRIBUTE.font = "Tahoma";
         TEXTFORMAT_ATTRIBUTE.color = 16579836;
         TEXTFORMAT_ATTRIBUTE.align = TextFormatAlign.LEFT;
         TEXTFORMAT_ATTRIBUTE.size = 12;
         TEXTFORMAT_VALUE.font = "Tahoma";
         TEXTFORMAT_VALUE.color = 16763904;
         TEXTFORMAT_VALUE.align = TextFormatAlign.RIGHT;
         TEXTFORMAT_VALUE.size = 12;
         TEXTFORMAT_SKILL_NAME.font = "Tahoma";
         TEXTFORMAT_SKILL_NAME.color = 11206655;
         TEXTFORMAT_SKILL_NAME.align = TextFormatAlign.LEFT;
         TEXTFORMAT_SKILL_NAME.size = 12;
         initialized = true;
      }
      
      public function createTextContent(param1:Array, param2:Sprite) : void
      {
         var l:uint;
         var i:uint = 0;
         var textData:Array = param1;
         var contentContainer:Sprite = param2;
         this._yPosLine = 0;
         l = textData.length;
         try
         {
            i = 0;
            while(i < l)
            {
               this.createLine(textData[i],i,contentContainer);
               i++;
            }
         }
         catch(e:Error)
         {
            throw e;
         }
      }
      
      public function createIconAndTextContent(param1:ShipSkillVO, param2:Sprite, param3:int = 0) : void
      {
         if(param1.name.indexOf("[") == 0 && param1.name.lastIndexOf("]") == param1.name.length - 1)
         {
            return;
         }
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(16711680,0);
         _loc4_.graphics.drawRect(0,0,32,35);
         _loc4_.graphics.endFill();
         var _loc5_:TextField = new TextField();
         _loc5_.mouseEnabled = false;
         _loc5_.selectable = false;
         _loc5_.defaultTextFormat = TEXTFORMAT_SKILL_NAME;
         _loc5_.autoSize = TextFieldAutoSize.LEFT;
         _loc5_.width = 240;
         _loc5_.x = _loc4_.width;
         _loc5_.y = param3;
         _loc5_.text = param1.name;
         _loc4_.y = param3 + 0.5 * _loc5_.height - 0.5 * _loc4_.height;
         var _loc6_:URLRequest = new URLRequest(Settings.cdnHost + param1.iconPath);
         var _loc7_:URLLoader = new URLLoader();
         _loc7_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc7_.addEventListener(Event.COMPLETE,this.handleIconLoaded);
         _loc7_.addEventListener(IOErrorEvent.IO_ERROR,this.handleIconLoadError);
         _loc7_.addEventListener(IOErrorEvent.DISK_ERROR,this.handleIconLoadError);
         _loc7_.addEventListener(IOErrorEvent.NETWORK_ERROR,this.handleIconLoadError);
         _loc7_.addEventListener(IOErrorEvent.VERIFY_ERROR,this.handleIconLoadError);
         this._urlLoaderToIcon[_loc7_] = _loc4_;
         _loc7_.load(_loc6_);
         var _loc8_:TextField = new TextField();
         _loc8_.mouseEnabled = false;
         _loc8_.selectable = false;
         _loc8_.defaultTextFormat = TEXTFORMAT_ATTRIBUTE;
         _loc8_.autoSize = TextFieldAutoSize.LEFT;
         _loc8_.multiline = true;
         _loc8_.wordWrap = true;
         _loc8_.width = 240;
         _loc8_.x = _loc5_.x;
         var _loc9_:int = Math.max(_loc5_.height,_loc4_.height);
         _loc8_.y = _loc5_.y + _loc5_.height;
         _loc8_.text = param1.text;
         this.createSkillBackground(param3,param2,_loc9_ + _loc8_.height);
         param2.addChild(_loc5_);
         param2.addChild(_loc4_);
         param2.addChild(_loc8_);
      }
      
      private function handleIconLoadError(param1:IOErrorEvent) : void
      {
      }
      
      private function handleIconLoaded(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:Sprite = this._urlLoaderToIcon[_loc2_];
         var _loc4_:int = _loc3_.height;
         var _loc5_:Loader = new Loader();
         _loc5_.loadBytes(_loc2_.data);
         _loc3_.addChild(_loc5_);
      }
      
      private function createLine(param1:Object, param2:uint, param3:Sprite) : void
      {
         var _loc4_:Number = NaN;
         if(param1.t == ShipDetailsViewData.SEPERATOR_LINE)
         {
            _loc4_ = SEPARATOR_HEIGHT;
            this.createLineBackground(param2,param3,_loc4_);
            this.createSeparatorLine(param2,param3,_loc4_);
         }
         else
         {
            _loc4_ = TEXT_HEIGHT;
            this.createLineBackground(param2,param3,_loc4_);
            this.createLineTextfields(param1,param2,param3,_loc4_);
         }
         this._yPosLine += _loc4_;
      }
      
      private function createLineBackground(param1:uint, param2:Sprite, param3:uint) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Sprite = null;
         var _loc8_:Graphics = null;
         var _loc4_:Boolean = param1 % 2 == 0 ? true : false;
         if(_loc4_)
         {
            _loc5_ = 2236962;
            _loc6_ = 0.4;
            _loc7_ = new Sprite();
            _loc7_.y = this._yPosLine;
            _loc8_ = _loc7_.graphics;
            _loc8_.beginFill(_loc5_,_loc6_);
            _loc8_.drawRect(0,0,350,param3);
            _loc8_.endFill();
            param2.addChild(_loc7_);
         }
      }
      
      private function createSkillBackground(param1:int, param2:Sprite, param3:Number) : void
      {
         var _loc4_:Number = 0;
         var _loc5_:Number = 2236962;
         var _loc6_:Number = 0.9;
         var _loc7_:Sprite = new Sprite();
         _loc7_.y = param1 - 2;
         var _loc8_:Graphics = _loc7_.graphics;
         _loc8_.beginFill(_loc4_,_loc6_);
         _loc8_.drawRect(0,0,350,param3 + 2);
         _loc8_.endFill();
         _loc8_.beginFill(_loc5_,_loc6_);
         _loc8_.drawRect(0,2,350,TEXT_HEIGHT);
         _loc8_.endFill();
         param2.addChild(_loc7_);
      }
      
      private function createSeparatorLine(param1:uint, param2:Sprite, param3:uint) : void
      {
         var _loc4_:Sprite = new Sprite();
         _loc4_.y = this._yPosLine + (param3 >> 1);
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.lineStyle(0.8,6842730);
         _loc5_.moveTo(25,0);
         _loc5_.lineTo(295,0);
         param2.addChild(_loc4_);
      }
      
      private function createLineTextfields(param1:Object, param2:uint, param3:Sprite, param4:uint) : void
      {
         var _loc5_:Number = this._yPosLine - 2;
         var _loc6_:TextField = new TextField();
         _loc6_.mouseEnabled = false;
         _loc6_.selectable = false;
         _loc6_.defaultTextFormat = TEXTFORMAT_ATTRIBUTE;
         _loc6_.width = 180;
         _loc6_.height = param4 + 2;
         _loc6_.x = 32;
         _loc6_.y = _loc5_;
         _loc6_.text = param1.t;
         param3.addChild(_loc6_);
         _loc6_ = new TextField();
         _loc6_.mouseEnabled = false;
         _loc6_.selectable = false;
         _loc6_.defaultTextFormat = TEXTFORMAT_VALUE;
         _loc6_.width = 180;
         _loc6_.height = param4 + 2;
         _loc6_.y = _loc5_;
         _loc6_.x = 118;
         if(param1.v != null)
         {
            _loc6_.text = param1.v;
         }
         else if(param1.h != null)
         {
            _loc6_.htmlText = param1.h;
         }
         else
         {
            _loc6_.text = "Text is missing !";
         }
         param3.addChild(_loc6_);
      }
   }
}

