package net.bigpoint.darkorbit.fui.components.list.dropdownbox
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.skins.BasicSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.MovieClipLayer;
   
   public class DropDownBox extends Coreponent
   {
      
      private static const SPACING:int = 20;
      
      private static const TF_SPACING:int = 5;
      
      private var _currentEntry:int = 0;
      
      private var _dropDownTriangleClip:MovieClip;
      
      private var _dropDownSelectedClip:MovieClip;
      
      private var _dropDownSelectedTextField:TextField;
      
      private var _droppedDownEntryClip:MovieClip;
      
      private var _droppedDownEntries:Vector.<MovieClip>;
      
      private var _dropDownTextFields:Vector.<TextField>;
      
      private var _dropDownTextKeys:Vector.<String> = new <String>["quality_low","quality_medium","quality_good","quality_high"];
      
      private var _droppedDown:Boolean;
      
      private var _textFormat:TextFormat;
      
      private var _locaCategory:String;
      
      private var _useRawKeys:Boolean = false;
      
      public function DropDownBox()
      {
         super();
         this._dropDownTextFields = new Vector.<TextField>();
         this._droppedDownEntries = new Vector.<MovieClip>();
         this._droppedDown = false;
      }
      
      override protected function onAddedToStage(param1:Event) : void
      {
         super.onAddedToStage(param1);
         this._textFormat = new TextFormat();
         this._textFormat.align = TextFormatAlign.LEFT;
         this._textFormat.font = "Verdana";
         this._textFormat.size = 10;
         var _loc2_:BasicSkin = this.getChildAt(0) as BasicSkin;
         this._dropDownSelectedClip = (_loc2_.getSkinLayer("normal") as MovieClipLayer).getChildAt(0) as MovieClip;
         this.addChild(this._dropDownSelectedClip);
         this._dropDownTriangleClip = this._dropDownSelectedClip.getChildByName("ActiveTriangle") as MovieClip;
         this._droppedDownEntryClip = this._dropDownSelectedClip.getChildByName("DroppedDownEntry") as MovieClip;
         this._dropDownSelectedTextField = new TextField();
         this._dropDownSelectedTextField.mouseEnabled = false;
         this._dropDownSelectedTextField.multiline = false;
         this._dropDownSelectedTextField.width = this._dropDownSelectedClip.width = this.width;
         this._dropDownSelectedTextField.defaultTextFormat = this._textFormat;
         this._dropDownSelectedTextField.textColor = 11184810;
         this._dropDownSelectedTextField.height = 20;
         this._dropDownSelectedTextField.x = this._dropDownSelectedClip.x + 5;
         this._dropDownSelectedTextField.y = this._dropDownSelectedClip.y;
         this._dropDownSelectedTextField.appendText(this.getKeyForIndex(this._currentEntry));
         this.addChild(this._dropDownSelectedTextField);
         this._dropDownSelectedClip.gotoAndStop(1);
         this._dropDownTriangleClip.gotoAndStop(1);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this._dropDownSelectedClip.addEventListener(MouseEvent.CLICK,this.handleMouseClicked);
         this._dropDownSelectedClip.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this._dropDownSelectedClip.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         this.updateSelectedText();
      }
      
      private function getKeyForIndex(param1:int) : String
      {
         if(this._useRawKeys)
         {
            return this._dropDownTextKeys[param1];
         }
         return this._locaCategory ? BPLocale.getItemInCategory(this._locaCategory,this._dropDownTextKeys[param1]) : BPLocale.getItem(this._dropDownTextKeys[param1]);
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         if(!this._droppedDown)
         {
            this._dropDownSelectedClip.gotoAndStop(3);
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(!this._droppedDown)
         {
            this._dropDownSelectedClip.gotoAndStop(1);
         }
      }
      
      public function forceCollapse() : void
      {
         if(this._droppedDown)
         {
            this.toggleDroppedState();
         }
      }
      
      private function toggleDroppedState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         var _loc8_:TextField = null;
         var _loc9_:int = 0;
         if(!this._droppedDown)
         {
            this._dropDownSelectedClip.gotoAndStop(2);
            this._dropDownTriangleClip.gotoAndStop(2);
            _loc1_ = this.width;
            _loc2_ = 0;
            while(_loc2_ < this._dropDownTextKeys.length)
            {
               _loc6_ = new TextField();
               _loc6_.setTextFormat(this._textFormat);
               _loc6_.autoSize = TextFieldAutoSize.LEFT;
               _loc6_.appendText(this.getKeyForIndex(_loc2_));
               _loc1_ = _loc1_ > _loc6_.width ? _loc1_ : int(_loc6_.width);
               _loc2_++;
            }
            _loc3_ = _loc1_ > this.width;
            _loc4_ = this.marginTop;
            _loc4_ = _loc4_ + ((this.parent.parent.parent as Coreponent).marginTop + (this.parent.parent as Coreponent).marginTop + (this.parent as Coreponent).marginTop);
            _loc5_ = this.marginLeft;
            _loc5_ = _loc5_ + ((this.parent.parent.parent as Coreponent).marginLeft + (this.parent.parent as Coreponent).marginLeft + (this.parent as Coreponent).marginLeft);
            _loc2_ = 0;
            while(_loc2_ < this._dropDownTextKeys.length)
            {
               _loc7_ = this.cloneMC(this._droppedDownEntryClip);
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
               _loc7_.x = _loc5_;
               _loc7_.y = _loc4_ + (_loc2_ + 1) * (this._droppedDownEntryClip.height - 1);
               _loc8_.x = _loc7_.x + TF_SPACING;
               _loc8_.y = _loc7_.y;
               this._droppedDownEntries.push(_loc7_);
               this._dropDownTextFields.push(_loc8_);
               this.parent.parent.parent.addChild(_loc7_);
               this.parent.parent.parent.addChild(_loc8_);
               _loc2_++;
            }
            dispatchEvent(new DropDownBoxEvent(DropDownBoxEvent.DROPPED_DOWN));
         }
         else
         {
            this._dropDownSelectedClip.gotoAndStop(1);
            this._dropDownTriangleClip.gotoAndStop(1);
            _loc9_ = 0;
            while(_loc9_ < this._dropDownTextFields.length)
            {
               this._dropDownTextFields[_loc9_].parent.removeChild(this._dropDownTextFields[_loc9_]);
               this._droppedDownEntries[_loc9_].parent.removeChild(this._droppedDownEntries[_loc9_]);
               _loc9_++;
            }
            this._dropDownTextFields.length = 0;
            this._droppedDownEntries.length = 0;
         }
         this._droppedDown = !this._droppedDown;
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
         this.activateEntry(this._droppedDownEntries.indexOf(param1.target as MovieClip));
         this.toggleDroppedState();
      }
      
      private function activateEntry(param1:int) : void
      {
         this._currentEntry = Math.max(0,Math.min(this._dropDownTextKeys.length - 1,param1));
         this.updateSelectedText();
         dispatchEvent(new DropDownBoxEvent(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this._currentEntry));
      }
      
      private function updateSelectedText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         if(this._dropDownSelectedTextField)
         {
            this._dropDownSelectedTextField.text = this.getKeyForIndex(this._currentEntry);
            _loc1_ = this._dropDownSelectedTextField.width - this._dropDownTriangleClip.width - SPACING;
            if(this._dropDownSelectedTextField.textWidth > _loc1_ && !this._dropDownSelectedTextField.wordWrap)
            {
               _loc2_ = new TextField();
               _loc2_.defaultTextFormat = this._textFormat;
               _loc2_.appendText("…");
               while(this._dropDownSelectedTextField.textWidth + _loc2_.textWidth > _loc1_)
               {
                  this._dropDownSelectedTextField.text = this._dropDownSelectedTextField.text.substring(0,this._dropDownSelectedTextField.text.length - 1);
               }
               this._dropDownSelectedTextField.appendText(_loc2_.text);
            }
         }
      }
      
      private function cloneMC(param1:MovieClip) : MovieClip
      {
         return new param1.constructor() as MovieClip;
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
         this._dropDownTextKeys = param1;
         this.activateEntry(this._currentEntry);
      }
      
      public function get currentEntryKey() : String
      {
         return this._dropDownTextKeys.length > this._currentEntry ? this._dropDownTextKeys[this._currentEntry] : null;
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

