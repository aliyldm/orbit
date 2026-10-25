package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextLineMetrics;
   import flash.ui.Keyboard;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.DateChooserEventDetail;
   import mx.managers.IFocusManagerComponent;
   import mx.skins.halo.DateChooserIndicator;
   import mx.styles.ISimpleStyleClient;
   
   use namespace mx_internal;
   
   public class CalendarLayout extends UIComponent implements IFocusManagerComponent, IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var dcis:Object = {};
      
      private var todayRow:int = -1;
      
      private var todayColumn:int = -1;
      
      private var enabledDaysInMonth:Array = [];
      
      private var disabledRangeMode:Array;
      
      private var cellHeight:Number = 14;
      
      private var cellWidth:Number = 14;
      
      private var yOffset:Number = -1;
      
      mx_internal var dayBlocksArray:Array = [];
      
      private var disabledArrays:Array = [];
      
      private var todaysLabelReference:IUITextField = null;
      
      private var selectedMonthYearChanged:Boolean = false;
      
      private var todayIndicator:IFlexDisplayObject;
      
      private var selectionIndicator:Array = [];
      
      private var rollOverIndicator:IFlexDisplayObject;
      
      private var selectedRangeCount:int = 0;
      
      private var lastSelectedDate:Date;
      
      private var rangeStartDate:Date = null;
      
      mx_internal var selRangeMode:int = 1;
      
      private var _enabled:Boolean = true;
      
      private var enabledChanged:Boolean = false;
      
      private var _allowDisjointSelection:Boolean = true;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var _dayNames:Array;
      
      private var dayNamesChanged:Boolean = false;
      
      private var dayNamesOverride:Array;
      
      private var _disabledDays:Array = [];
      
      private var _disabledRanges:Array = [];
      
      private var _displayedMonth:int = new Date().getMonth();
      
      private var _proposedDisplayedMonth:int = -1;
      
      private var _displayedYear:int = new Date().getFullYear();
      
      private var _proposedDisplayedYear:int = -1;
      
      private var _firstDayOfWeek:int = 0;
      
      private var _selectableRange:Object = null;
      
      private var _selectedRanges:Array = [];
      
      private var _showToday:Boolean = true;
      
      public function CalendarLayout()
      {
         super();
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
      }
      
      mx_internal static function getNewIncrementDate(param1:int, param2:int, param3:int, param4:int) : Object
      {
         var _loc5_:* = int(param1 + param3);
         var _loc6_:int = param2 + param4;
         while(_loc6_ < 0)
         {
            _loc5_--;
            _loc6_ += 12;
         }
         while(_loc6_ > 11)
         {
            _loc5_++;
            _loc6_ -= 12;
         }
         return {
            "month":_loc6_,
            "year":_loc5_
         };
      }
      
      private static function isDateChooserIndicator(param1:Object) : Boolean
      {
         var xmllist:XMLList;
         var s:String = null;
         var x:XML = null;
         var parent:Object = param1;
         s = getQualifiedClassName(parent);
         if(dcis[s] == 1)
         {
            return true;
         }
         if(dcis[s] == 0)
         {
            return false;
         }
         if(s == "mx.skins.halo::DateChooserIndicator")
         {
            dcis[s] == 1;
            return true;
         }
         x = describeType(parent);
         xmllist = x.extendsClass.(@type == "mx.skins.halo::DateChooserIndicator");
         if(xmllist.length() == 0)
         {
            dcis[s] = 0;
            return false;
         }
         dcis[s] = 1;
         return true;
      }
      
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         this._enabled = param1;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      public function get allowDisjointSelection() : Boolean
      {
         return this._allowDisjointSelection;
      }
      
      public function set allowDisjointSelection(param1:Boolean) : void
      {
         this._allowDisjointSelection = param1;
      }
      
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(param1:Boolean) : void
      {
         this._allowMultipleSelection = param1;
      }
      
      public function get dayNames() : Array
      {
         return this._dayNames;
      }
      
      public function set dayNames(param1:Array) : void
      {
         this.dayNamesOverride = param1;
         this._dayNames = param1 != null ? param1 : resourceManager.getStringArray("controls","dayNamesShortest");
         this._dayNames = this._dayNames ? this._dayNames.slice(0) : null;
         this.dayNamesChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get disabledDays() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc2_ < this._disabledDays.length)
         {
            if(this._disabledDays[_loc2_] >= 0 && this._disabledDays[_loc2_] <= 6)
            {
               _loc1_[_loc3_] = this._disabledDays[_loc2_];
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set disabledDays(param1:Array) : void
      {
         this._disabledDays = param1.slice(0);
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var _loc2_:Array = this.selectedRanges;
      }
      
      public function get disabledRanges() : Array
      {
         return this._disabledRanges.slice(0);
      }
      
      public function set disabledRanges(param1:Array) : void
      {
         this._disabledRanges = param1.slice(0);
         this.disabledRangeMode = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._disabledRanges.length)
         {
            if(this._disabledRanges[_loc2_] is Date)
            {
               this.disabledRangeMode[_loc2_] = 4;
               this._disabledRanges[_loc2_] = new Date(param1[_loc2_].getFullYear(),param1[_loc2_].getMonth(),param1[_loc2_].getDate());
            }
            else if(this._disabledRanges[_loc2_] is Object)
            {
               this._disabledRanges[_loc2_] = {};
               this._disabledRanges[_loc2_] = param1[_loc2_];
               if(!this._disabledRanges[_loc2_].rangeStart && Boolean(this._disabledRanges[_loc2_].rangeEnd))
               {
                  this.disabledRangeMode[_loc2_] = 3;
               }
               else if(Boolean(this._disabledRanges[_loc2_].rangeStart) && !this._disabledRanges[_loc2_].rangeEnd)
               {
                  this.disabledRangeMode[_loc2_] = 2;
               }
               else if(Boolean(this._disabledRanges[_loc2_].rangeStart) && Boolean(this._disabledRanges[_loc2_].rangeEnd))
               {
                  this.disabledRangeMode[_loc2_] = 1;
               }
            }
            _loc2_++;
         }
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var _loc3_:Array = this.selectedRanges;
      }
      
      public function get displayedMonth() : int
      {
         return this._proposedDisplayedMonth == -1 ? this._displayedMonth : this._proposedDisplayedMonth;
      }
      
      public function set displayedMonth(param1:int) : void
      {
         if(param1 < 0 || param1 > 11)
         {
            return;
         }
         if(param1 == this._displayedMonth)
         {
            return;
         }
         this._proposedDisplayedMonth = param1;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      public function get displayedYear() : int
      {
         return this._proposedDisplayedYear == -1 ? this._displayedYear : this._proposedDisplayedYear;
      }
      
      public function set displayedYear(param1:int) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         if(param1 == this._displayedYear)
         {
            return;
         }
         this._proposedDisplayedYear = param1;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      public function get firstDayOfWeek() : int
      {
         return this._firstDayOfWeek;
      }
      
      public function set firstDayOfWeek(param1:int) : void
      {
         if(param1 < 0 || param1 > 6)
         {
            return;
         }
         if(param1 == this._firstDayOfWeek)
         {
            return;
         }
         this._firstDayOfWeek = param1;
         this.dayNamesChanged = true;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(param1:IFlexModuleFactory) : void
      {
         this.moduleFactory = param1;
      }
      
      public function get selectableRange() : Object
      {
         return this._selectableRange;
      }
      
      public function set selectableRange(param1:Object) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!param1)
         {
            this._selectableRange = null;
            this.selectedMonthYearChanged = true;
            invalidateProperties();
            return;
         }
         var _loc2_:Date = new Date();
         var _loc3_:int = _loc2_.getMonth();
         var _loc4_:int = _loc2_.getFullYear();
         if(param1 is Date)
         {
            this.selRangeMode = 4;
            this._selectableRange = new Date(param1.getFullYear(),param1.getMonth(),param1.getDate());
            _loc5_ = int(param1.getMonth());
            _loc6_ = int(param1.getFullYear());
         }
         else if(param1 is Object)
         {
            this._selectableRange = {};
            if(!param1.rangeStart && Boolean(param1.rangeEnd))
            {
               this.selRangeMode = 3;
               this._selectableRange.rangeEnd = param1.rangeEnd;
               if(_loc4_ <= this._selectableRange.rangeEnd.getFullYear())
               {
                  if(_loc3_ >= this._selectableRange.rangeEnd.getMonth())
                  {
                     _loc5_ = int(this._selectableRange.rangeEnd.getMonth());
                     _loc6_ = int(this._selectableRange.rangeEnd.getFullYear());
                  }
                  else if(_loc3_ <= this._selectableRange.rangeEnd.getMonth())
                  {
                     _loc5_ = _loc3_;
                     _loc6_ = _loc4_;
                  }
               }
               else if(_loc4_ > this._selectableRange.rangeEnd.getFullYear())
               {
                  _loc5_ = int(this._selectableRange.rangeEnd.getMonth());
                  _loc6_ = int(this._selectableRange.rangeEnd.getFullYear());
               }
            }
            else if(!param1.rangeEnd && Boolean(param1.rangeStart))
            {
               this.selRangeMode = 2;
               this._selectableRange.rangeStart = param1.rangeStart;
               if(_loc4_ >= this._selectableRange.rangeStart.getFullYear())
               {
                  if(_loc3_ <= this._selectableRange.rangeStart.getMonth())
                  {
                     _loc5_ = int(this._selectableRange.rangeStart.getMonth());
                     _loc6_ = int(this._selectableRange.rangeStart.getFullYear());
                  }
                  else if(_loc3_ >= this._selectableRange.rangeStart.getMonth())
                  {
                     _loc5_ = _loc3_;
                     _loc6_ = _loc4_;
                  }
               }
               else if(_loc4_ < this._selectableRange.rangeStart.getFullYear())
               {
                  _loc5_ = int(this._selectableRange.rangeStart.getMonth());
                  _loc6_ = int(this._selectableRange.rangeStart.getFullYear());
               }
            }
            else if(Boolean(param1.rangeStart) && Boolean(param1.rangeEnd))
            {
               this.selRangeMode = 1;
               this._selectableRange.rangeStart = param1.rangeStart;
               this._selectableRange.rangeEnd = param1.rangeEnd;
               if(_loc2_ >= this._selectableRange.rangeStart && _loc2_ <= this._selectableRange.rangeEnd)
               {
                  _loc5_ = _loc3_;
                  _loc6_ = _loc4_;
               }
               else if(_loc2_ < this._selectableRange.rangeStart)
               {
                  _loc5_ = int(this._selectableRange.rangeStart.getMonth());
                  _loc6_ = int(this._selectableRange.rangeStart.getFullYear());
               }
               else if(_loc2_ > this._selectableRange.rangeEnd)
               {
                  _loc5_ = int(this._selectableRange.rangeEnd.getMonth());
                  _loc6_ = int(this._selectableRange.rangeEnd.getFullYear());
               }
            }
         }
         this._displayedMonth = _loc5_;
         this._displayedYear = _loc6_;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var _loc7_:Array = this.selectedRanges;
      }
      
      public function get selectedRanges() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         if(this._selectableRange)
         {
            switch(this.selRangeMode)
            {
               case 1:
                  this.removeRangeFromSelection(null,this._selectableRange.rangeStart);
                  this.removeRangeFromSelection(this._selectableRange.rangeEnd,null);
                  break;
               case 2:
               case 3:
                  this.removeRangeFromSelection(this._selectableRange.rangeEnd,this._selectableRange.rangeStart);
                  break;
               case 4:
                  this.removeRangeFromSelection(null,this._selectableRange as Date);
                  this.removeRangeFromSelection(this._selectableRange as Date,null);
            }
         }
         _loc1_ = 0;
         while(_loc1_ < this._disabledRanges.length)
         {
            switch(this.disabledRangeMode[_loc1_])
            {
               case 1:
               case 2:
               case 3:
                  this.removeRangeFromSelection(this._disabledRanges[_loc1_].rangeStart,this._disabledRanges[_loc1_].rangeEnd);
                  break;
               case 4:
                  this.removeRangeFromSelection(this._disabledRanges[_loc1_],this._disabledRanges[_loc1_]);
            }
            _loc1_++;
         }
         if(this._disabledDays.length > 0 && Boolean(this.selectedRangeCount))
         {
            _loc2_ = this._selectedRanges[0].rangeStart;
            _loc3_ = this._selectedRanges[0].rangeEnd;
            _loc1_ = 1;
            while(_loc1_ < this.selectedRangeCount)
            {
               if(_loc2_ > this._selectedRanges[_loc1_].rangeStart)
               {
                  _loc2_ = this._selectedRanges[_loc1_].rangeStart;
               }
               if(_loc3_ < this._selectedRanges[_loc1_].rangeEnd)
               {
                  _loc3_ = this._selectedRanges[_loc1_].rangeEnd;
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this._disabledDays.length)
            {
               _loc4_ = _loc2_;
               _loc5_ = this._disabledDays[_loc1_] - _loc4_.getDay();
               if(_loc5_ < 0)
               {
                  _loc5_ += 7;
               }
               _loc4_ = this.incrementDate(_loc4_,_loc5_);
               while(_loc4_ < _loc3_)
               {
                  this.removeRangeFromSelection(_loc4_,_loc4_);
                  _loc4_ = this.incrementDate(_loc4_,7);
               }
               _loc1_++;
            }
         }
         this._selectedRanges.length = this.selectedRangeCount;
         return this._selectedRanges;
      }
      
      public function set selectedRanges(param1:Array) : void
      {
         this._selectedRanges = param1;
         this.selectedRangeCount = this._selectedRanges.length;
         this.setSelectedIndicators();
      }
      
      public function get showToday() : Boolean
      {
         return this._showToday;
      }
      
      public function set showToday(param1:Boolean) : void
      {
         if(this._showToday != param1)
         {
            this._showToday = param1;
         }
         this.selectedMonthYearChanged = true;
         invalidateProperties();
      }
      
      public function get selectedDate() : Date
      {
         return this.selectedRangeCount ? this._selectedRanges[0].rangeStart : null;
      }
      
      public function set selectedDate(param1:Date) : void
      {
         this.selectedRangeCount = 0;
         if(Boolean(param1) && !this.checkDateIsDisabled(param1))
         {
            this.addToSelected(param1);
            this._displayedMonth = param1.getMonth();
            this._displayedYear = param1.getFullYear();
            this.selectedMonthYearChanged = true;
            invalidateProperties();
         }
         else
         {
            this.setSelectedIndicators();
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc2_:Class = null;
         super.createChildren();
         var _loc1_:Number = 0;
         this.createDayLabels(-1);
         this.createTodayIndicator(0);
         if(!this.rollOverIndicator)
         {
            _loc2_ = getStyle("rollOverIndicatorSkin");
            if(!_loc2_)
            {
               _loc2_ = DateChooserIndicator;
            }
            this.rollOverIndicator = IFlexDisplayObject(new _loc2_());
            if(isDateChooserIndicator(this.rollOverIndicator))
            {
               Object(this.rollOverIndicator).indicatorColor = "rollOverColor";
            }
            if(this.rollOverIndicator is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.rollOverIndicator).styleName = this;
            }
            addChildAt(DisplayObject(this.rollOverIndicator),0);
            this.rollOverIndicator.visible = false;
         }
         this.dayNamesChanged = true;
         this.selectedMonthYearChanged = true;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Date = null;
         super.commitProperties();
         if(hasFontContextChanged() && this.todayIndicator != null)
         {
            this.removeSelectionIndicators();
            _loc1_ = getChildIndex(DisplayObject(this.todayIndicator));
            this.removeTodayIndicator();
            this.createTodayIndicator(_loc1_);
            _loc1_ = getChildIndex(this.dayBlocksArray[0][0]);
            this.removeDayLabels();
            this.createDayLabels(_loc1_);
            this.enabledChanged = true;
            this.dayNamesChanged = true;
            this.selectedMonthYearChanged = true;
         }
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               _loc3_ = 0;
               while(_loc3_ < 7)
               {
                  this.dayBlocksArray[_loc2_][_loc3_].enabled = this._enabled;
                  this.disabledArrays[_loc2_][_loc3_] = this._enabled;
                  _loc3_++;
               }
               _loc2_++;
            }
            if(!this._enabled)
            {
               if(this.todayIndicator)
               {
                  this.todayIndicator.alpha = 0.3;
               }
               removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
               removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
               removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
               removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            }
            else
            {
               if(this.todayIndicator)
               {
                  this.todayIndicator.alpha = 1;
               }
               this.selectedMonthYearChanged = true;
               addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
               addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
               addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
               addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            }
         }
         if(this.dayNamesChanged)
         {
            this.dayNamesChanged = false;
            this.drawDayNames();
         }
         if(this.selectedMonthYearChanged)
         {
            this.selectedMonthYearChanged = false;
            _loc4_ = new Date(this._proposedDisplayedYear == -1 ? this._displayedYear : this._proposedDisplayedYear,this._proposedDisplayedMonth == -1 ? this._displayedMonth : this._proposedDisplayedMonth);
            if(this.isDateInRange(_loc4_,this._selectableRange,this.selRangeMode,true))
            {
               this.setSelectedMonthAndYear();
            }
            this._proposedDisplayedYear = -1;
            this._proposedDisplayedMonth = -1;
         }
      }
      
      override protected function measure() : void
      {
         var _loc7_:TextLineMetrics = null;
         var _loc9_:String = null;
         super.measure();
         var _loc1_:Number = getStyle("verticalGap");
         var _loc2_:Number = getStyle("horizontalGap");
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingRight");
         var _loc5_:Number = getStyle("paddingBottom");
         var _loc6_:Number = getStyle("paddingTop");
         this.cellWidth = 0;
         this.cellHeight = 0;
         var _loc8_:int = 0;
         while(_loc8_ < 7)
         {
            _loc9_ = this.dayNames ? this.dayNames[_loc8_] : "";
            _loc7_ = measureText(_loc9_);
            if(_loc7_.width > this.cellWidth)
            {
               this.cellWidth = _loc7_.width;
            }
            if(_loc7_.height > this.cellHeight)
            {
               this.cellHeight = _loc7_.height;
            }
            _loc8_++;
         }
         _loc7_ = measureText("30");
         if(_loc7_.width > this.cellWidth)
         {
            this.cellWidth = _loc7_.width;
         }
         if(_loc7_.height > this.cellHeight)
         {
            this.cellHeight = _loc7_.height;
         }
         measuredWidth = _loc3_ + _loc2_ * 6 + this.cellWidth * 7 + _loc4_;
         measuredHeight = _loc1_ * 6 + this.cellHeight * 7 + _loc5_ + _loc6_;
         measuredMinWidth = this.cellWidth * 7;
         measuredMinHeight = this.cellHeight * 7;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc10_:int = 0;
         var _loc11_:IUITextField = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = getStyle("paddingLeft");
         var _loc4_:Number = getStyle("paddingRight");
         var _loc5_:Number = getStyle("paddingBottom");
         var _loc6_:Number = getStyle("paddingTop");
         var _loc7_:Number = _loc3_;
         this.cellWidth = Math.max((param1 - (_loc3_ + _loc4_)) / 7,4);
         this.cellHeight = Math.max((param2 - _loc5_) / 7,4);
         var _loc8_:Number = _loc6_;
         this.rollOverIndicator.setActualSize(this.cellWidth,this.cellHeight);
         this.todayIndicator.setActualSize(this.cellWidth,this.cellHeight);
         var _loc9_:int = 0;
         while(_loc9_ < 7)
         {
            _loc10_ = 0;
            while(_loc10_ < 7)
            {
               _loc11_ = this.dayBlocksArray[_loc9_][_loc10_];
               if(_loc10_ == 0)
               {
                  _loc8_ = _loc6_;
               }
               else
               {
                  _loc8_ += this.cellHeight;
               }
               _loc11_.setActualSize(this.cellWidth,this.cellHeight);
               _loc11_.move(_loc7_,_loc8_);
               if(this.selectionIndicator[_loc9_][_loc10_])
               {
                  this.selectionIndicator[_loc9_][_loc10_].setActualSize(this.cellWidth,this.cellHeight);
                  this.selectionIndicator[_loc9_][_loc10_].move(_loc7_,_loc8_ + this.yOffset);
               }
               _loc10_++;
            }
            _loc7_ += this.cellWidth;
            _loc9_++;
         }
         this.drawDayNames();
         this.setSelectedMonthAndYear();
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc2_:Boolean = !param1 || param1 == "styleName";
         if(_loc2_ || param1 == "todayStyleName")
         {
            this.selectedMonthYearChanged = true;
            invalidateProperties();
         }
         if(_loc2_ || param1 == "weekDayStyleName")
         {
            _loc3_ = getStyle("weekDayStyleName");
            if(!_loc3_)
            {
               _loc3_ = this;
            }
            if(this.dayBlocksArray)
            {
               _loc4_ = 0;
               while(_loc4_ < 7)
               {
                  if(Boolean(this.dayBlocksArray[_loc4_]) && Boolean(this.dayBlocksArray[_loc4_][0]))
                  {
                     this.dayBlocksArray[_loc4_][0].styleName = _loc3_;
                  }
                  _loc4_++;
               }
            }
         }
         super.styleChanged(param1);
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.dayNames = this.dayNamesOverride;
      }
      
      mx_internal function createDayLabels(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:IUITextField = null;
         var _loc2_:Object = getStyle("weekDayStyleName");
         var _loc3_:int = 0;
         while(_loc3_ < 7)
         {
            this.dayBlocksArray[_loc3_] = [];
            this.selectionIndicator[_loc3_] = [];
            _loc4_ = 0;
            while(_loc4_ < 7)
            {
               _loc5_ = this.dayBlocksArray[_loc3_][_loc4_] = IUITextField(createInFontContext(UITextField));
               _loc5_.selectable = false;
               _loc5_.ignorePadding = true;
               if(param1 == -1)
               {
                  addChild(DisplayObject(_loc5_));
               }
               else
               {
                  addChildAt(DisplayObject(_loc5_),param1++);
               }
               if(_loc4_ == 0)
               {
                  _loc5_.styleName = _loc2_ ? _loc2_ : this;
               }
               else
               {
                  _loc5_.styleName = this;
               }
               _loc4_++;
            }
            this.disabledArrays[_loc3_] = new Array(7);
            _loc3_++;
         }
      }
      
      mx_internal function removeDayLabels() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               removeChild(this.dayBlocksArray[_loc1_][_loc2_]);
               this.dayBlocksArray[_loc1_][_loc2_] = null;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      mx_internal function createTodayIndicator(param1:int) : void
      {
         var _loc2_:Class = null;
         if(!this.todayIndicator)
         {
            _loc2_ = getStyle("todayIndicatorSkin");
            if(!_loc2_)
            {
               _loc2_ = DateChooserIndicator;
            }
            this.todayIndicator = IFlexDisplayObject(new _loc2_());
            if(isDateChooserIndicator(this.todayIndicator))
            {
               Object(this.todayIndicator).indicatorColor = "todayColor";
            }
            if(this.todayIndicator is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.todayIndicator).styleName = this;
            }
            addChildAt(DisplayObject(this.todayIndicator),param1);
            this.todayIndicator.visible = false;
         }
      }
      
      mx_internal function removeTodayIndicator() : void
      {
         if(this.todayIndicator)
         {
            removeChild(DisplayObject(this.todayIndicator));
            this.todayIndicator = null;
         }
      }
      
      mx_internal function drawDayNames() : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = (_loc1_ + this.firstDayOfWeek) % 7;
            _loc3_ = this.dayNames ? this.dayNames[_loc2_] : "";
            this.dayBlocksArray[_loc1_][0].text = _loc3_;
            _loc1_++;
         }
      }
      
      mx_internal function setSelectedMonthAndYear(param1:int = -1, param2:int = -1) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc17_:Date = null;
         var _loc18_:IUITextField = null;
         var _loc19_:String = null;
         var _loc20_:Object = null;
         var _loc21_:int = 0;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Date = null;
         var _loc9_:int = param1 == -1 ? this.displayedMonth : param1;
         var _loc10_:int = param2 == -1 ? this.displayedYear : param2;
         this.enabledDaysInMonth = [];
         var _loc11_:int = this.getOffsetOfMonth(_loc10_,_loc9_);
         var _loc12_:int = this.getNumberOfDaysInMonth(_loc10_,_loc9_);
         var _loc13_:Date = new Date();
         var _loc14_:Boolean = _loc13_.getFullYear() == _loc10_ && _loc13_.getMonth() == _loc9_;
         var _loc15_:int = Math.max(_loc9_ - 1,0);
         var _loc16_:Date = new Date(_loc10_,_loc15_,1);
         _loc3_ = this.getNumberOfDaysInMonth(_loc16_.getFullYear(),_loc16_.getMonth());
         _loc5_ = 1;
         _loc4_ = 0;
         while(_loc4_ < _loc11_)
         {
            this.dayBlocksArray[_loc4_][_loc5_].text = "";
            this.disabledArrays[_loc4_][_loc5_] = true;
            this.removeSelectionIndicator(_loc4_,_loc5_);
            _loc4_++;
         }
         _loc3_ = 1;
         while(_loc3_ <= _loc12_)
         {
            _loc17_ = new Date(_loc10_,_loc9_,_loc3_);
            _loc6_ = _loc11_ + _loc3_ - 1;
            _loc4_ = _loc6_ % 7;
            _loc5_ = 1 + Math.floor(_loc6_ / 7);
            _loc18_ = this.dayBlocksArray[_loc4_][_loc5_];
            _loc18_.text = _loc3_.toString();
            if(this._enabled)
            {
               this.disabledArrays[_loc4_][_loc5_] = false;
               _loc18_.enabled = true;
            }
            if(!_loc18_.styleName)
            {
               _loc18_.styleName = this;
            }
            if(_loc14_ && _loc17_.getDate() == _loc13_.getDate() && this._showToday)
            {
               this.todayRow = _loc5_;
               this.todayColumn = _loc4_;
               _loc7_ = true;
               this.todayIndicator.visible = this._showToday;
               _loc18_.styleName = getStyle("todayStyleName");
               this.todayIndicator.move(_loc18_.x,_loc18_.y + this.yOffset);
               this.todaysLabelReference = _loc18_;
            }
            else if(!_loc7_)
            {
               if(this.todaysLabelReference)
               {
                  this.todaysLabelReference.styleName = this;
               }
               this.todayIndicator.visible = false;
            }
            if(this._selectableRange)
            {
               if(!this.isDateInRange(_loc17_,this._selectableRange,this.selRangeMode))
               {
                  _loc18_.enabled = false;
                  this.disabledArrays[_loc4_][_loc5_] = true;
               }
            }
            if(this._disabledRanges.length > 0)
            {
               _loc21_ = 0;
               while(_loc21_ < this._disabledRanges.length)
               {
                  if(this.isDateInRange(_loc17_,this._disabledRanges[_loc21_],this.disabledRangeMode[_loc21_]))
                  {
                     _loc18_.enabled = false;
                     this.disabledArrays[_loc4_][_loc5_] = true;
                  }
                  _loc21_++;
               }
            }
            _loc20_ = {};
            if(_loc18_.enabled)
            {
               _loc20_.name = _loc18_.name;
               _loc20_.text = _loc18_.text;
               _loc20_.x = _loc18_.x;
               _loc20_.y = _loc18_.y;
            }
            this.enabledDaysInMonth.push(_loc20_);
            _loc3_++;
         }
         _loc3_ = 1;
         _loc6_ = _loc11_ + _loc12_;
         while(_loc6_ < 42)
         {
            _loc4_ = _loc6_ % 7;
            _loc5_ = 1 + Math.floor(_loc6_ / 7);
            this.dayBlocksArray[_loc4_][_loc5_].text = "";
            this.disabledArrays[_loc4_][_loc5_] = true;
            this.removeSelectionIndicator(_loc4_,_loc5_);
            _loc6_++;
         }
         if(this._disabledDays.length > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < this._disabledDays.length)
            {
               if(this._disabledDays[_loc6_] >= 0 && this._disabledDays[_loc6_] <= 6 && this._disabledDays[_loc6_] != -1)
               {
                  _loc4_ = (7 + this._disabledDays[_loc6_] - this._firstDayOfWeek) % 7;
                  _loc5_ = 1;
                  while(_loc5_ < 7)
                  {
                     this.disabledArrays[_loc4_][_loc5_] = true;
                     _loc22_ = Number(this.dayBlocksArray[_loc4_][_loc5_].text);
                     if(!isNaN(_loc22_))
                     {
                        _loc23_ = _loc11_ + _loc22_ % 7;
                        this.enabledDaysInMonth[_loc22_ - 1] = null;
                     }
                     this.dayBlocksArray[_loc4_][_loc5_].enabled = false;
                     _loc5_++;
                  }
               }
               _loc6_++;
            }
         }
         this._displayedMonth = _loc9_;
         this._displayedYear = _loc10_;
         _loc8_ = new Date(_loc10_,_loc9_,1);
         this.todayIndicator.alpha = this.todaysLabelReference ? (this.todaysLabelReference.enabled == false ? 0.3 : 1) : 1;
         this.setSelectedIndicators();
         invalidateDisplayList();
      }
      
      mx_internal function getOffsetOfMonth(param1:int, param2:int) : int
      {
         var _loc3_:Date = new Date(param1,param2,1);
         var _loc4_:int = _loc3_.getDay() - this._firstDayOfWeek;
         return _loc4_ < 0 ? int(_loc4_ + 7) : _loc4_;
      }
      
      mx_internal function getNumberOfDaysInMonth(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         if(param2 == 1)
         {
            if(param1 % 4 == 0 && param1 % 100 != 0 || param1 % 400 == 0)
            {
               _loc3_ = 29;
            }
            else
            {
               _loc3_ = 28;
            }
         }
         else if(param2 == 3 || param2 == 5 || param2 == 8 || param2 == 10)
         {
            _loc3_ = 30;
         }
         else
         {
            _loc3_ = 31;
         }
         return _loc3_;
      }
      
      mx_internal function stepDate(param1:int, param2:int, param3:Event = null) : void
      {
         var _loc4_:int = this.displayedYear;
         var _loc5_:int = this.displayedMonth;
         var _loc6_:Object = getNewIncrementDate(_loc4_,_loc5_,param1,param2);
         var _loc7_:int = int(_loc6_.year);
         var _loc8_:int = int(_loc6_.month);
         this._displayedMonth = _loc8_;
         this._displayedYear = _loc7_;
         this.selectedMonthYearChanged = true;
         invalidateProperties();
         var _loc9_:DateChooserEvent = new DateChooserEvent(DateChooserEvent.SCROLL);
         _loc9_.triggerEvent = param3;
         if(_loc7_ > _loc4_)
         {
            _loc9_.detail = DateChooserEventDetail.NEXT_YEAR;
         }
         else if(_loc7_ < _loc4_)
         {
            _loc9_.detail = DateChooserEventDetail.PREVIOUS_YEAR;
         }
         else if(_loc8_ > _loc5_)
         {
            _loc9_.detail = DateChooserEventDetail.NEXT_MONTH;
         }
         else if(_loc8_ < _loc5_)
         {
            _loc9_.detail = DateChooserEventDetail.PREVIOUS_MONTH;
         }
         dispatchEvent(_loc9_);
      }
      
      mx_internal function dispatchChangeEvent(param1:Event = null) : void
      {
         var _loc2_:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         _loc2_.newDate = this.lastSelectedDate;
         _loc2_.triggerEvent = param1;
         dispatchEvent(_loc2_);
      }
      
      mx_internal function isDateInRange(param1:Date, param2:Object, param3:int, param4:Boolean = false) : Boolean
      {
         var _loc6_:Object = null;
         var _loc7_:Date = null;
         var _loc8_:Date = null;
         var _loc5_:Boolean = true;
         if(param2)
         {
            if(param4)
            {
               _loc6_ = {};
               if(param2.rangeStart)
               {
                  _loc7_ = param2.rangeStart;
                  _loc6_.rangeStart = new Date(_loc7_.fullYear,_loc7_.month,1);
               }
               if(param2.rangeEnd)
               {
                  _loc8_ = param2.rangeEnd;
                  _loc6_.rangeEnd = new Date(_loc8_.fullYear,_loc8_.month,this.getNumberOfDaysInMonth(_loc8_.fullYear,_loc8_.month));
               }
               param2 = _loc6_;
            }
            switch(param3)
            {
               case 1:
                  if(param1 < param2.rangeStart || param1 > param2.rangeEnd)
                  {
                     _loc5_ = false;
                  }
                  break;
               case 2:
                  if(param1 < param2.rangeStart)
                  {
                     _loc5_ = false;
                  }
                  break;
               case 3:
                  if(param1 > param2.rangeEnd)
                  {
                     _loc5_ = false;
                  }
                  break;
               case 4:
                  if(param1 > param2 || param1 < param2)
                  {
                     _loc5_ = false;
                  }
            }
         }
         return _loc5_;
      }
      
      mx_internal function checkDateIsDisabled(param1:Date) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!param1)
         {
            return false;
         }
         var _loc2_:Boolean = false;
         if(this._selectableRange)
         {
            if(!this.isDateInRange(param1,this._selectableRange,this.selRangeMode))
            {
               _loc2_ = true;
            }
         }
         if(this._disabledRanges.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this._disabledRanges.length)
            {
               if(this.isDateInRange(param1,this._disabledRanges[_loc3_],this.disabledRangeMode[_loc3_]))
               {
                  _loc2_ = true;
               }
               _loc3_++;
            }
         }
         if(this._disabledDays.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this._disabledDays.length)
            {
               if(param1.getDay() == this._disabledDays[_loc4_])
               {
                  _loc2_ = true;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      mx_internal function addToSelected(param1:Date, param2:Boolean = false) : void
      {
         if(!this.selectedRangeCount)
         {
            this.rangeStartDate = null;
         }
         this.lastSelectedDate = param1;
         if(param2 == false)
         {
            this._selectedRanges[this.selectedRangeCount] = {};
            this._selectedRanges[this.selectedRangeCount].rangeStart = new Date(param1);
            this._selectedRanges[this.selectedRangeCount].rangeEnd = this._selectedRanges[this.selectedRangeCount].rangeStart;
            ++this.selectedRangeCount;
         }
         else
         {
            if(this.selectedRangeCount == 0)
            {
               this._selectedRanges[0] = {};
               this._selectedRanges[0].rangeStart = new Date(param1);
            }
            else
            {
               this.selectedRangeCount = 1;
               if(!this.rangeStartDate)
               {
                  this.rangeStartDate = this._selectedRanges[0].rangeStart;
               }
               this._selectedRanges[0].rangeStart = new Date(this.rangeStartDate);
               if(param1 < this._selectedRanges[0].rangeStart)
               {
                  this._selectedRanges[0].rangeEnd = this._selectedRanges[0].rangeStart;
                  this._selectedRanges[0].rangeStart = new Date(param1);
                  return;
               }
            }
            this._selectedRanges[0].rangeEnd = new Date(param1);
         }
      }
      
      mx_internal function incrementDate(param1:Date, param2:int = 1) : Date
      {
         var _loc3_:Date = new Date(param1);
         var _loc4_:Number = _loc3_.getTime();
         _loc3_.setTime(_loc4_ + param2 * 86400000);
         return _loc3_;
      }
      
      mx_internal function isSelected(param1:Date) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.selectedRangeCount)
         {
            if(param1 >= this._selectedRanges[_loc2_].rangeStart && param1 <= this._selectedRanges[_loc2_].rangeEnd)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      mx_internal function removeRangeFromSelection(param1:Date, param2:Date) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Date = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.selectedRangeCount)
         {
            if(!param1 || param1 <= this._selectedRanges[_loc3_].rangeStart)
            {
               _loc4_ = 1;
            }
            else if(param1 <= this._selectedRanges[_loc3_].rangeEnd)
            {
               _loc4_ = 2;
            }
            else if(param1 > this._selectedRanges[_loc3_].rangeEnd)
            {
               _loc4_ = 3;
            }
            if(param2 < this._selectedRanges[_loc3_].rangeStart)
            {
               _loc4_ *= 5;
            }
            else if(param2 < this._selectedRanges[_loc3_].rangeEnd)
            {
               _loc4_ *= 7;
            }
            else if(!param2 || param2 >= this._selectedRanges[_loc3_].rangeEnd)
            {
               _loc4_ *= 11;
            }
            switch(_loc4_)
            {
               case 5:
               case 33:
                  break;
               case 14:
                  _loc5_ = this._selectedRanges[_loc3_].rangeEnd;
                  this._selectedRanges[_loc3_].rangeEnd = this.incrementDate(param1,-1);
                  this._selectedRanges[this.selectedRangeCount] = {};
                  this._selectedRanges[this.selectedRangeCount].rangeStart = this.incrementDate(param2);
                  this._selectedRanges[this.selectedRangeCount].rangeEnd = _loc5_;
                  this.selectedRangeCount += 1;
                  break;
               case 7:
                  this._selectedRanges[_loc3_].rangeStart = this.incrementDate(param2);
                  break;
               case 22:
                  this._selectedRanges[_loc3_].rangeEnd = this.incrementDate(param1,-1);
                  break;
               case 11:
                  this._selectedRanges[_loc3_] = this._selectedRanges[this.selectedRangeCount - 1];
                  this._selectedRanges[this.selectedRangeCount - 1] = null;
                  --this.selectedRangeCount;
            }
            _loc3_++;
         }
      }
      
      mx_internal function setSelectedIndicators() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:Date = null;
         var _loc1_:int = this.getOffsetOfMonth(this.displayedYear,this.displayedMonth);
         var _loc2_:int = this.getNumberOfDaysInMonth(this.displayedYear,this.displayedMonth);
         var _loc6_:int = 1;
         while(_loc6_ <= _loc2_)
         {
            _loc8_ = new Date(this.displayedYear,this.displayedMonth,_loc6_);
            _loc5_ = _loc1_ + _loc6_ - 1;
            _loc3_ = _loc5_ % 7;
            _loc4_ = 1 + Math.floor(_loc5_ / 7);
            if(this.isSelected(_loc8_) && this.disabledArrays[_loc3_][_loc4_] == false)
            {
               this.addSelectionIndicator(_loc3_,_loc4_);
            }
            else
            {
               this.removeSelectionIndicator(_loc3_,_loc4_);
            }
            _loc6_++;
         }
         var _loc7_:Date = new Date();
         if(this.isSelected(_loc7_))
         {
            this.todayIndicator.alpha = 1;
         }
      }
      
      mx_internal function addSelectionIndicator(param1:int, param2:int) : void
      {
         var _loc3_:Class = null;
         var _loc4_:IUITextField = null;
         if(!this.selectionIndicator[param1][param2])
         {
            _loc3_ = getStyle("selectionIndicatorSkin");
            if(!_loc3_)
            {
               _loc3_ = DateChooserIndicator;
            }
            this.selectionIndicator[param1][param2] = IFlexDisplayObject(new _loc3_());
            if(isDateChooserIndicator(this.selectionIndicator[param1][param2]))
            {
               Object(this.selectionIndicator[param1][param2]).indicatorColor = "selectionColor";
            }
            if(this.selectionIndicator[param1][param2] is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.selectionIndicator[param1][param2]).styleName = this;
            }
            addChildAt(DisplayObject(this.selectionIndicator[param1][param2]),0);
            _loc4_ = this.dayBlocksArray[param1][param2];
            this.selectionIndicator[param1][param2].move(_loc4_.x,_loc4_.y + this.yOffset);
            this.selectionIndicator[param1][param2].setActualSize(this.cellWidth,this.cellHeight);
         }
         this.selectionIndicator[param1][param2].visible = true;
      }
      
      mx_internal function removeSelectionIndicator(param1:int, param2:int) : void
      {
         if(this.selectionIndicator[param1][param2])
         {
            removeChild(this.selectionIndicator[param1][param2]);
            this.selectionIndicator[param1][param2] = null;
         }
      }
      
      mx_internal function removeSelectionIndicators() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < 7)
         {
            _loc2_ = 0;
            while(_loc2_ < 7)
            {
               this.removeSelectionIndicator(_loc1_,_loc2_);
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         var _loc7_:Date = null;
         var _loc2_:Boolean = false;
         var _loc3_:* = this.lastSelectedDate ? int(this.lastSelectedDate.getDate()) : 1;
         var _loc4_:int = this.getNumberOfDaysInMonth(this.displayedYear,this.displayedMonth);
         var _loc5_:uint = mapKeycodeForLayoutDirection(param1);
         var _loc6_:uint = 0;
         while(_loc6_ < 31)
         {
            if(_loc5_ == Keyboard.LEFT)
            {
               if(_loc3_ <= 1)
               {
                  return;
               }
               _loc3_--;
               _loc2_ = true;
            }
            else if(_loc5_ == Keyboard.RIGHT)
            {
               if(_loc3_ >= _loc4_)
               {
                  return;
               }
               _loc3_++;
               _loc2_ = true;
            }
            else if(_loc5_ == Keyboard.UP)
            {
               if(_loc3_ <= 7)
               {
                  return;
               }
               _loc3_ -= 7;
               _loc2_ = true;
            }
            else if(_loc5_ == Keyboard.DOWN)
            {
               if(_loc3_ + 7 > _loc4_)
               {
                  return;
               }
               _loc3_ += 7;
               _loc2_ = true;
            }
            else if(_loc5_ == Keyboard.HOME)
            {
               if(_loc6_ == 0)
               {
                  _loc3_ = 1;
               }
               else
               {
                  _loc3_++;
               }
               _loc2_ = true;
            }
            else if(_loc5_ == Keyboard.END)
            {
               if(_loc6_ == 0)
               {
                  _loc3_ = _loc4_;
               }
               else
               {
                  _loc3_--;
               }
               _loc2_ = true;
            }
            else if(Boolean(this.lastSelectedDate) && Boolean(param1.shiftKey) && (_loc5_ == Keyboard.PAGE_UP || _loc5_ == Keyboard.PAGE_DOWN))
            {
               _loc2_ = true;
            }
            else if(Boolean(this.lastSelectedDate) && (_loc5_ == 189 || _loc5_ == 187))
            {
               _loc2_ = true;
            }
            if(_loc5_ >= Keyboard.PAGE_UP && _loc5_ <= Keyboard.DOWN)
            {
               param1.stopPropagation();
            }
            if(_loc2_)
            {
               _loc7_ = new Date(this.displayedYear,this.displayedMonth,_loc3_);
               if(!(this.checkDateIsDisabled(_loc7_) && !param1.shiftKey))
               {
                  if(!(param1.shiftKey && this._allowMultipleSelection))
                  {
                     this.selectedRangeCount = 0;
                  }
                  this.addToSelected(_loc7_,param1.shiftKey && this._allowMultipleSelection);
                  this.setSelectedIndicators();
                  this.dispatchChangeEvent(param1);
                  return;
               }
            }
            _loc6_++;
         }
      }
      
      private function mouseOverHandler(param1:MouseEvent) : void
      {
         if(Boolean(param1.relatedObject) && param1.relatedObject.parent != this)
         {
            addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         }
         else
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function mouseOutHandler(param1:MouseEvent) : void
      {
         var _loc2_:Date = null;
         if(Boolean(param1.relatedObject) && param1.relatedObject.parent != this)
         {
            removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
            this.rollOverIndicator.visible = false;
            if(this.todayColumn != -1 && this.todayRow != -1 && !this.disabledArrays[this.todayColumn][this.todayRow])
            {
               _loc2_ = new Date();
               if(!this.isSelected(_loc2_))
               {
                  this.todayIndicator.alpha = 1;
               }
            }
         }
         else
         {
            param1.stopImmediatePropagation();
         }
      }
      
      private function mouseMoveHandler(param1:MouseEvent) : void
      {
         var _loc13_:Date = null;
         var _loc2_:Number = getStyle("paddingLeft");
         var _loc3_:Number = getStyle("paddingTop");
         var _loc4_:Number = Number(this.dayBlocksArray[0][0].x);
         var _loc5_:Number = Number(this.dayBlocksArray[6][0].x);
         var _loc6_:Number = this.dayBlocksArray[6][0].y + this.cellHeight;
         var _loc7_:Point = new Point(param1.stageX,param1.stageY);
         _loc7_ = globalToLocal(_loc7_);
         var _loc8_:Number = _loc7_.y;
         var _loc9_:Number = _loc7_.x;
         if(_loc9_ < _loc4_ || _loc9_ > _loc5_ + this.cellWidth || _loc8_ < _loc6_)
         {
            return;
         }
         var _loc10_:int = Math.floor((_loc8_ - _loc3_) / this.cellHeight);
         var _loc11_:int = Math.floor((_loc9_ - _loc2_) / this.cellWidth);
         _loc11_ = Math.min(_loc11_,6);
         _loc10_ = Math.min(_loc10_,6);
         var _loc12_:IUITextField = this.dayBlocksArray[_loc11_][_loc10_];
         if(Boolean(this.disabledArrays[_loc11_][_loc10_]) || _loc10_ == 0)
         {
            return;
         }
         if(_loc8_ >= _loc12_.y && _loc8_ <= _loc12_.y + this.cellHeight && _loc9_ >= _loc12_.x && _loc9_ <= _loc12_.x + this.cellWidth)
         {
            this.rollOverIndicator.move(_loc12_.x,_loc12_.y + this.yOffset);
            this.rollOverIndicator.visible = true;
            if(this.selectionIndicator[_loc11_][_loc10_])
            {
               this.rollOverIndicator.visible = false;
            }
            if(this.todayColumn != -1 && this.todayRow != -1 && !this.disabledArrays[this.todayColumn][this.todayRow])
            {
               _loc13_ = new Date();
               if(this.rollOverIndicator.x == this.todayIndicator.x && this.rollOverIndicator.y == this.todayIndicator.y)
               {
                  this.todayIndicator.alpha = 0.6;
               }
               else if(!this.isSelected(_loc13_))
               {
                  this.todayIndicator.alpha = 1;
               }
            }
         }
      }
      
      private function mouseUpHandler(param1:MouseEvent) : void
      {
         var _loc13_:Date = null;
         var _loc14_:Boolean = false;
         var _loc15_:Date = null;
         var _loc2_:Number = getStyle("paddingLeft");
         var _loc3_:Number = getStyle("paddingTop");
         var _loc4_:Number = Number(this.dayBlocksArray[0][0].x);
         var _loc5_:Number = Number(this.dayBlocksArray[6][0].x);
         var _loc6_:Number = this.dayBlocksArray[6][0].y + this.cellHeight;
         var _loc7_:Point = new Point(param1.stageX,param1.stageY);
         _loc7_ = globalToLocal(_loc7_);
         var _loc8_:Number = _loc7_.y;
         var _loc9_:Number = _loc7_.x;
         if(_loc9_ < _loc4_ && _loc9_ >= _loc5_ + this.cellWidth || _loc8_ < _loc6_)
         {
            return;
         }
         var _loc10_:int = Math.floor((_loc8_ - _loc3_) / this.cellHeight);
         if(_loc10_ <= 0)
         {
            return;
         }
         _loc10_ = Math.min(_loc10_,6);
         var _loc11_:int = Math.floor((_loc9_ - _loc2_) / this.cellWidth);
         _loc11_ = Math.min(_loc11_,6);
         var _loc12_:IUITextField = this.dayBlocksArray[_loc11_][_loc10_];
         if(this.disabledArrays[_loc11_][_loc10_])
         {
            return;
         }
         if(_loc8_ >= _loc12_.y && _loc8_ <= _loc12_.y + this.cellHeight && _loc9_ >= _loc12_.x && _loc9_ <= _loc12_.x + this.cellWidth)
         {
            _loc13_ = new Date(this.displayedYear,this.displayedMonth,int(_loc12_.text));
            if(param1.shiftKey && this._allowMultipleSelection)
            {
               this.addToSelected(_loc13_,true);
               this.setSelectedIndicators();
            }
            else
            {
               _loc14_ = this.selectionIndicator[_loc11_][_loc10_] ? true : false;
               if(param1.ctrlKey && this._allowMultipleSelection && this._allowDisjointSelection)
               {
                  if(_loc14_)
                  {
                     this.removeSelectionIndicator(_loc11_,_loc10_);
                     this.removeRangeFromSelection(_loc13_,_loc13_);
                  }
                  else
                  {
                     this.addSelectionIndicator(_loc11_,_loc10_);
                     this.addToSelected(_loc13_);
                  }
               }
               else
               {
                  this.rangeStartDate = null;
                  if(_loc14_)
                  {
                     if(this.selectedRangeCount > 1 || this.selectedRangeCount == 1 && this._selectedRanges[0].rangeStart != this._selectedRanges[0].rangeEnd)
                     {
                        this.selectedRangeCount = 0;
                        this.addSelectionIndicator(_loc11_,_loc10_);
                        this.addToSelected(_loc13_);
                        this.setSelectedIndicators();
                     }
                     else if(param1.ctrlKey)
                     {
                        this.removeSelectionIndicator(_loc11_,_loc10_);
                        this.removeRangeFromSelection(_loc13_,_loc13_);
                     }
                  }
                  else
                  {
                     this.selectedRangeCount = 0;
                     this.addSelectionIndicator(_loc11_,_loc10_);
                     this.addToSelected(_loc13_);
                     this.setSelectedIndicators();
                  }
               }
            }
            this.dispatchChangeEvent(param1);
            if(this.todayColumn != -1 && this.todayRow != -1 && !this.disabledArrays[this.todayColumn][this.todayRow])
            {
               _loc15_ = new Date();
               this.todayIndicator.alpha = this.isSelected(_loc15_) ? 0.6 : 1;
            }
            if(this.selectionIndicator[_loc11_][_loc10_])
            {
               this.rollOverIndicator.visible = false;
            }
         }
      }
   }
}

