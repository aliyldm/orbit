package net.bigpoint.darkorbit.fui.components.list.dropupbox
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.skins.BasicSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.MovieClipLayer;
   
   public class DropUpBox extends Coreponent
   {
      
      private static const SPACING:int = 20;
      
      private static const TF_SPACING:int = 5;
      
      private var _currentEntry:int = 0;
      
      private var _dropUpTriangleClip:MovieClip;
      
      private var _dropUpSelectedClip:MovieClip;
      
      private var _dropUpSelectedTextField:TextField;
      
      private var _droppedEntryClip:MovieClip;
      
      private var _droppedEntries:Vector.<MovieClip>;
      
      private var _dropTextFields:Vector.<TextField>;
      
      private var _dropTextKeys:Vector.<String> = new <String>["quality_low","quality_medium","quality_good","quality_high"];
      
      private var _dropped:Boolean;
      
      private var _textFormat:TextFormat;
      
      private var _locaCategory:String;
      
      private var _useRawKeys:Boolean = false;
      
      public function DropUpBox()
      {
         super();
         this._dropTextFields = new Vector.<TextField>();
         this._droppedEntries = new Vector.<MovieClip>();
         this._dropped = false;
      }
      
      override protected function onAddedToStage(param1:Event) : void
      {
         super.onAddedToStage(param1);
         this._textFormat = new TextFormat();
         this._textFormat.align = TextFormatAlign.CENTER;
         this._textFormat.font = "Verdana";
         this._textFormat.size = 11;
         var _loc2_:BasicSkin = this.getChildAt(0) as BasicSkin;
         this._dropUpSelectedClip = (_loc2_.getSkinLayer("normal") as MovieClipLayer).getChildAt(0) as MovieClip;
         this.addChild(this._dropUpSelectedClip);
         this._dropUpTriangleClip = this._dropUpSelectedClip.getChildByName("ActiveTriangle") as MovieClip;
         this._droppedEntryClip = this._dropUpSelectedClip.getChildByName("DroppedUpEntry") as MovieClip;
         this._dropUpSelectedTextField = new TextField();
         this._dropUpSelectedTextField.mouseEnabled = false;
         this._dropUpSelectedTextField.multiline = false;
         this._dropUpSelectedTextField.width = this._dropUpSelectedClip.width = this.width;
         this._dropUpSelectedTextField.defaultTextFormat = this._textFormat;
         this._dropUpSelectedTextField.textColor = 11184810;
         this._dropUpSelectedTextField.height = this.height;
         this._dropUpSelectedTextField.x = this._dropUpSelectedClip.x;
         this._dropUpSelectedTextField.y = this._dropUpSelectedClip.y + 3;
         this._dropUpSelectedTextField.appendText(this.getKeyForIndex(this._currentEntry));
         this.addChild(this._dropUpSelectedTextField);
         this._dropUpSelectedClip.gotoAndStop(1);
         this._dropUpTriangleClip.gotoAndStop(1);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this._dropUpSelectedClip.addEventListener(MouseEvent.CLICK,this.handleMouseClicked);
         this._dropUpSelectedClip.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this._dropUpSelectedClip.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.updateSelectedText();
      }
      
      private function getKeyForIndex(param1:int) : String
      {
         if(this._useRawKeys)
         {
            return this._dropTextKeys[param1];
         }
         return this._locaCategory ? BPLocale.getItemInCategory(this._locaCategory,this._dropTextKeys[param1]) : BPLocale.getItem(this._dropTextKeys[param1]);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         if(!this._dropped)
         {
            this._dropUpSelectedClip.gotoAndStop(3);
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(!this._dropped)
         {
            this._dropUpSelectedClip.gotoAndStop(1);
         }
      }
      
      public function forceCollapse() : void
      {
         if(this._dropped)
         {
            this.toggleDroppedState();
         }
      }
      
      private function toggleDroppedState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:Point = null;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         var _loc8_:TextField = null;
         var _loc9_:int = 0;
         if(!this._dropped)
         {
            this._dropUpSelectedClip.gotoAndStop(2);
            this._dropUpTriangleClip.gotoAndStop(2);
            _loc1_ = this.width;
            _loc2_ = 0;
            while(_loc2_ < this._dropTextKeys.length)
            {
               _loc6_ = new TextField();
               _loc6_.setTextFormat(this._textFormat);
               _loc6_.autoSize = TextFieldAutoSize.LEFT;
               _loc6_.appendText(this.getKeyForIndex(_loc2_));
               _loc1_ = _loc1_ > _loc6_.width ? _loc1_ : int(_loc6_.width);
               _loc2_++;
            }
            _loc3_ = _loc1_ > this.width;
            _loc4_ = this.getPopupContainer();
            _loc5_ = _loc4_.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc2_ = 0;
            while(_loc2_ < this._dropTextKeys.length)
            {
               _loc7_ = this.cloneMC(this._droppedEntryClip);
               _loc7_.buttonMode = true;
               _loc7_.gotoAndStop(1);
               _loc7_.addEventListener(MouseEvent.MOUSE_OVER,this.handleEntryMouseOver);
               _loc7_.addEventListener(MouseEvent.MOUSE_OUT,this.handleEntryMouseOut);
               _loc7_.addEventListener(MouseEvent.CLICK,this.handleEntryMouseClick);
               _loc8_ = new TextField();
               _loc8_.appendText(this.getKeyForIndex(_loc2_));
               _loc8_.mouseEnabled = false;
               _loc8_.multiline = false;
               _loc8_.setTextFormat(this._textFormat);
               _loc8_.textColor = 11184810;
               _loc8_.width = _loc7_.width = !_loc3_ ? this.width : _loc1_ + SPACING + TF_SPACING;
               _loc7_.x = _loc5_.x;
               _loc7_.y = _loc5_.y - (this._dropTextKeys.length - _loc2_) * (this._droppedEntryClip.height - 3);
               _loc8_.x = _loc7_.x + TF_SPACING;
               _loc8_.y = _loc7_.y + 3;
               this._droppedEntries.push(_loc7_);
               this._dropTextFields.push(_loc8_);
               _loc4_.addChild(_loc7_);
               _loc4_.addChild(_loc8_);
               _loc2_++;
            }
            dispatchEvent(new DropUpBoxEvent(DropUpBoxEvent.DROPPED_UP));
         }
         else
         {
            this._dropUpSelectedClip.gotoAndStop(1);
            this._dropUpTriangleClip.gotoAndStop(1);
            _loc9_ = 0;
            while(_loc9_ < this._dropTextFields.length)
            {
               this._dropTextFields[_loc9_].parent.removeChild(this._dropTextFields[_loc9_]);
               this._droppedEntries[_loc9_].parent.removeChild(this._droppedEntries[_loc9_]);
               _loc9_++;
            }
            this._dropTextFields.length = 0;
            this._droppedEntries.length = 0;
         }
         this._dropped = !this._dropped;
      }
      
      private function handleMouseClicked(param1:MouseEvent) : void
      {
         this.toggleDroppedState();
      }
      
      private function handleEntryMouseOver(param1:MouseEvent) : void
      {
         (param1.target as MovieClip).gotoAndStop(2);
      }
      
      private function handleEntryMouseOut(param1:MouseEvent) : void
      {
         (param1.target as MovieClip).gotoAndStop(1);
      }
      
      private function handleEntryMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._droppedEntries.indexOf(param1.target as MovieClip);
         this.toggleDroppedState();
         this.activateEntry(_loc2_);
      }
      
      private function activateEntry(param1:int) : void
      {
         var _loc2_:Boolean = true;
         param1 = Math.max(0,Math.min(this._dropTextKeys.length - 1,param1));
         if(this._currentEntry == param1)
         {
            _loc2_ = false;
         }
         this._currentEntry = param1;
         this.updateSelectedText();
         if(_loc2_)
         {
            dispatchEvent(new DropUpBoxEvent(DropUpBoxEvent.SELECTED_ENTRY_CHANGED,this._currentEntry));
         }
      }
      
      private function updateSelectedText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         if(this._dropUpSelectedTextField)
         {
            this._dropUpSelectedTextField.text = this.getKeyForIndex(this._currentEntry);
            _loc1_ = this._dropUpSelectedTextField.width - this._dropUpTriangleClip.width - SPACING;
            if(this._dropUpSelectedTextField.textWidth > _loc1_ && !this._dropUpSelectedTextField.wordWrap)
            {
               _loc2_ = new TextField();
               _loc2_.defaultTextFormat = this._textFormat;
               _loc2_.appendText("…");
               while(this._dropUpSelectedTextField.textWidth + _loc2_.textWidth > _loc1_)
               {
                  this._dropUpSelectedTextField.text = this._dropUpSelectedTextField.text.substring(0,this._dropUpSelectedTextField.text.length - 1);
               }
               this._dropUpSelectedTextField.appendText(_loc2_.text);
            }
         }
      }
      
      private function cloneMC(param1:MovieClip) : MovieClip
      {
         return new param1.constructor() as MovieClip;
      }
      
      private function getPopupContainer() : DisplayObjectContainer
      {
         var _loc1_:DisplayObjectContainer = this.parent;
         while(Boolean(_loc1_) && Boolean(_loc1_.parent) && _loc1_.parent is Coreponent)
         {
            _loc1_ = _loc1_.parent;
         }
         return _loc1_ ? _loc1_ : this;
      }
      
      override protected function removeEventListeners() : void
      {
         super.removeEventListeners();
      }
      
      public function set currentEntry(param1:int) : void
      {
         this.activateEntry(param1);
      }
      
      public function updateAvailableEntries(param1:Vector.<String>) : void
      {
         this.forceCollapse();
         this._dropTextKeys = param1;
         this.activateEntry(this._currentEntry);
      }
      
      public function get currentEntryKey() : String
      {
         return this._dropTextKeys.length > this._currentEntry ? this._dropTextKeys[this._currentEntry] : null;
      }
      
      public function set locaCategory(param1:String) : void
      {
         this._locaCategory = param1;
      }
      
      public function get currentEntry() : int
      {
         return this._currentEntry;
      }
      
      public function set useRawKeys(param1:Boolean) : void
      {
         this._useRawKeys = param1;
      }
   }
}

