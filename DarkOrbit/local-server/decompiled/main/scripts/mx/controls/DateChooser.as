package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventPhase;
   import flash.events.KeyboardEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   import mx.core.FlexSprite;
   import mx.core.FlexVersion;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IUITextField;
   import mx.core.UIComponent;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.CalendarLayoutChangeEvent;
   import mx.events.DateChooserEvent;
   import mx.events.FlexEvent;
   import mx.graphics.RectangularDropShadow;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   import mx.utils.GraphicsUtil;
   
   use namespace mx_internal;
   
   public class DateChooser extends UIComponent implements IFocusManagerComponent, IFontContextComponent
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static var _nextMonthStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "nextMonthUpSkin":"nextMonthUpSkin",
         "nextMonthOverSkin":"nextMonthOverSkin",
         "nextMonthDownSkin":"nextMonthDownSkin",
         "nextMonthDisabledSkin":"nextMonthDisabledSkin",
         "nextMonthSkin":"nextMonthSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private static var _nextYearStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "nextYearUpSkin":"nextYearUpSkin",
         "nextYearOverSkin":"nextYearOverSkin",
         "nextYearDownSkin":"nextYearDownSkin",
         "nextYearDisabledSkin":"nextYearDisabledSkin",
         "nextYearSkin":"nextYearSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private static var _prevMonthStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "prevMonthUpSkin":"prevMonthUpSkin",
         "prevMonthOverSkin":"prevMonthOverSkin",
         "prevMonthDownSkin":"prevMonthDownSkin",
         "prevMonthDisabledSkin":"prevMonthDisabledSkin",
         "prevMonthSkin":"prevMonthSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private static var _prevYearStyleFilters:Object = {
         "highlightAlphas":"highlightAlphas",
         "prevYearUpSkin":"prevYearUpSkin",
         "prevYearOverSkin":"prevYearOverSkin",
         "prevYearDownSkin":"prevYearDownSkin",
         "prevYearDisabledSkin":"prevYearDisabledSkin",
         "prevYearSkin":"prevYearSkin",
         "repeatDelay":"repeatDelay",
         "repeatInterval":"repeatInterval"
      };
      
      private var HEADER_WIDTH_PAD:Number = 5;
      
      private var SKIN_WIDTH_PAD:Number = 6;
      
      private var SKIN_HEIGHT_PAD:Number = 4;
      
      private var YEAR_BUTTONS_PAD:Number = 6;
      
      mx_internal var background:UIComponent;
      
      mx_internal var border:UIComponent;
      
      mx_internal var headerDisplay:UIComponent;
      
      mx_internal var monthDisplay:IUITextField;
      
      mx_internal var fwdMonthHit:Sprite;
      
      mx_internal var backMonthHit:Sprite;
      
      mx_internal var upYearHit:Sprite;
      
      mx_internal var downYearHit:Sprite;
      
      mx_internal var calHeader:UIComponent;
      
      mx_internal var yearDisplay:IUITextField;
      
      mx_internal var upYearButton:Button;
      
      mx_internal var downYearButton:Button;
      
      mx_internal var fwdMonthButton:Button;
      
      mx_internal var backMonthButton:Button;
      
      mx_internal var dateGrid:CalendarLayout;
      
      mx_internal var dropShadow:RectangularDropShadow;
      
      private var previousSelectedCellIndex:Number = NaN;
      
      private var monthSkinWidth:Number = 6;
      
      private var monthSkinHeight:Number = 11;
      
      private var yearSkinWidth:Number = 10;
      
      private var yearSkinHeight:Number = 8;
      
      private var headerHeight:Number = 30;
      
      private var _enabled:Boolean = true;
      
      private var enabledChanged:Boolean = false;
      
      private var _allowDisjointSelection:Boolean = true;
      
      private var allowDisjointSelectionChanged:Boolean = false;
      
      private var _allowMultipleSelection:Boolean = false;
      
      private var allowMultipleSelectionChanged:Boolean = false;
      
      private var _dayNames:Array;
      
      private var dayNamesChanged:Boolean = false;
      
      private var dayNamesOverride:Array;
      
      private var _disabledDays:Array = [];
      
      private var disabledDaysChanged:Boolean = false;
      
      private var _disabledRanges:Array = [];
      
      private var disabledRangesChanged:Boolean = false;
      
      private var _displayedMonth:int = new Date().getMonth();
      
      private var displayedMonthChanged:Boolean = false;
      
      private var _displayedYear:int = new Date().getFullYear();
      
      private var displayedYearChanged:Boolean = false;
      
      private var _firstDayOfWeek:Object;
      
      private var firstDayOfWeekChanged:Boolean = false;
      
      private var firstDayOfWeekOverride:Object;
      
      private var _maxYear:int = 2100;
      
      private var _minYear:int = 1900;
      
      private var _monthNames:Array;
      
      private var monthNamesChanged:Boolean = false;
      
      private var monthNamesOverride:Array;
      
      private var _monthSymbol:String;
      
      private var monthSymbolChanged:Boolean = false;
      
      private var monthSymbolOverride:String;
      
      private var _selectableRange:Object;
      
      private var selectableRangeChanged:Boolean = false;
      
      private var _selectedDate:Date;
      
      private var selectedDateChanged:Boolean = false;
      
      private var _selectedRanges:Array = [];
      
      private var selectedRangesChanged:Boolean = false;
      
      private var _showToday:Boolean = true;
      
      private var showTodayChanged:Boolean = false;
      
      private var _yearNavigationEnabled:Boolean = false;
      
      private var yearNavigationEnabledChanged:Boolean = false;
      
      private var _yearSymbol:String;
      
      private var yearSymbolChanged:Boolean = false;
      
      private var yearSymbolOverride:String;
      
      public function DateChooser()
      {
         super();
         tabEnabled = true;
         tabFocusEnabled = true;
         tabChildren = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         return this.monthDisplay.y + this.monthDisplay.baselinePosition;
      }
      
      [Bindable("enabledChanged")]
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(param1 == this._enabled)
         {
            return;
         }
         this._enabled = param1;
         super.enabled = param1;
         this.enabledChanged = true;
         invalidateProperties();
      }
      
      [Bindable("allowDisjointSelectionChanged")]
      public function get allowDisjointSelection() : Boolean
      {
         return this._allowDisjointSelection;
      }
      
      public function set allowDisjointSelection(param1:Boolean) : void
      {
         this._allowDisjointSelection = param1;
         this.allowDisjointSelectionChanged = true;
         invalidateProperties();
      }
      
      [Bindable("allowMultipleSelectionChanged")]
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(param1:Boolean) : void
      {
         this._allowMultipleSelection = param1;
         this.allowMultipleSelectionChanged = true;
         invalidateProperties();
      }
      
      protected function get calendarLayoutStyleFilters() : Object
      {
         return null;
      }
      
      [Bindable("dayNamesChanged")]
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
      }
      
      [Bindable("disabledDaysChanged")]
      public function get disabledDays() : Array
      {
         return this._disabledDays;
      }
      
      public function set disabledDays(param1:Array) : void
      {
         this._disabledDays = param1;
         this.disabledDaysChanged = true;
         invalidateProperties();
      }
      
      [Bindable("disabledRangesChanged")]
      public function get disabledRanges() : Array
      {
         return this._disabledRanges;
      }
      
      public function set disabledRanges(param1:Array) : void
      {
         this._disabledRanges = this.scrubTimeValues(param1);
         this.disabledRangesChanged = true;
         invalidateProperties();
      }
      
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get displayedMonth() : int
      {
         if(Boolean(this.dateGrid) && this._displayedMonth != this.dateGrid.displayedMonth)
         {
            return this.dateGrid.displayedMonth;
         }
         return this._displayedMonth;
      }
      
      public function set displayedMonth(param1:int) : void
      {
         if(isNaN(param1) || this.displayedMonth == param1)
         {
            return;
         }
         this._displayedMonth = param1;
         this.displayedMonthChanged = true;
         invalidateProperties();
         if(this.dateGrid)
         {
            this.dateGrid.displayedMonth = param1;
         }
      }
      
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      public function get displayedYear() : int
      {
         if(this.dateGrid)
         {
            return this.dateGrid.displayedYear;
         }
         return this._displayedYear;
      }
      
      public function set displayedYear(param1:int) : void
      {
         if(isNaN(param1) || this.displayedYear == param1)
         {
            return;
         }
         this._displayedYear = param1;
         this.displayedYearChanged = true;
         invalidateProperties();
         if(this.dateGrid)
         {
            this.dateGrid.displayedYear = param1;
         }
      }
      
      [Bindable("firstDayOfWeekChanged")]
      public function get firstDayOfWeek() : Object
      {
         return this._firstDayOfWeek;
      }
      
      public function set firstDayOfWeek(param1:Object) : void
      {
         this.firstDayOfWeekOverride = param1;
         this._firstDayOfWeek = param1 != null ? int(param1) : resourceManager.getInt("controls","firstDayOfWeek");
         this.firstDayOfWeekChanged = true;
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
      
      public function get maxYear() : int
      {
         return this._maxYear;
      }
      
      public function set maxYear(param1:int) : void
      {
         if(this._maxYear == param1)
         {
            return;
         }
         this._maxYear = param1;
      }
      
      public function get minYear() : int
      {
         return this._minYear;
      }
      
      public function set minYear(param1:int) : void
      {
         if(this._minYear == param1)
         {
            return;
         }
         this._minYear = param1;
      }
      
      [Bindable("monthNamesChanged")]
      public function get monthNames() : Array
      {
         return this._monthNames;
      }
      
      public function set monthNames(param1:Array) : void
      {
         this.monthNamesOverride = param1;
         this._monthNames = param1 != null ? param1 : resourceManager.getStringArray("SharedResources","monthNames");
         this._monthNames = this._monthNames ? this.monthNames.slice(0) : null;
         this.monthNamesChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      [Bindable("monthSymbolChanged")]
      public function get monthSymbol() : String
      {
         return this._monthSymbol;
      }
      
      public function set monthSymbol(param1:String) : void
      {
         this.monthSymbolOverride = param1;
         this._monthSymbol = param1 != null ? param1 : resourceManager.getString("SharedResources","monthSymbol");
         this.monthSymbolChanged = true;
         invalidateProperties();
      }
      
      protected function get nextMonthStyleFilters() : Object
      {
         return _nextMonthStyleFilters;
      }
      
      protected function get nextYearStyleFilters() : Object
      {
         return _nextYearStyleFilters;
      }
      
      protected function get prevMonthStyleFilters() : Object
      {
         return _prevMonthStyleFilters;
      }
      
      protected function get prevYearStyleFilters() : Object
      {
         return _prevYearStyleFilters;
      }
      
      [Bindable("selectableRangeChanged")]
      public function get selectableRange() : Object
      {
         return this._selectableRange;
      }
      
      public function set selectableRange(param1:Object) : void
      {
         this._selectableRange = this.scrubTimeValue(param1);
         this.selectableRangeChanged = true;
         invalidateProperties();
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedDate() : Date
      {
         return this._selectedDate;
      }
      
      public function set selectedDate(param1:Date) : void
      {
         this._selectedDate = this.scrubTimeValue(param1) as Date;
         this.selectedDateChanged = true;
         invalidateProperties();
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedRanges() : Array
      {
         this._selectedRanges = this.dateGrid.selectedRanges;
         return this._selectedRanges;
      }
      
      public function set selectedRanges(param1:Array) : void
      {
         this._selectedRanges = this.scrubTimeValues(param1);
         this.selectedRangesChanged = true;
         invalidateProperties();
      }
      
      [Bindable("showTodayChanged")]
      public function get showToday() : Boolean
      {
         return this._showToday;
      }
      
      public function set showToday(param1:Boolean) : void
      {
         this._showToday = param1;
         this.showTodayChanged = true;
         invalidateProperties();
      }
      
      [Bindable("yearNavigationEnabledChanged")]
      public function get yearNavigationEnabled() : Boolean
      {
         return this._yearNavigationEnabled;
      }
      
      public function set yearNavigationEnabled(param1:Boolean) : void
      {
         this._yearNavigationEnabled = param1;
         this.yearNavigationEnabledChanged = true;
         invalidateProperties();
      }
      
      [Bindable("yearSymbolChanged")]
      public function get yearSymbol() : String
      {
         return this._yearSymbol;
      }
      
      public function set yearSymbol(param1:String) : void
      {
         this.yearSymbolOverride = param1;
         this._yearSymbol = param1 != null ? param1 : resourceManager.getString("controls","yearSymbol");
         this.yearSymbolChanged = true;
         invalidateProperties();
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DateChooser.createAccessibilityImplementation != null)
         {
            DateChooser.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.background)
         {
            this.background = new UIComponent();
            addChild(this.background);
            UIComponent(this.background).styleName = this;
         }
         if(!this.border)
         {
            this.border = new UIComponent();
            addChild(this.border);
            UIComponent(this.border).styleName = this;
         }
         if(!this.dateGrid)
         {
            this.dateGrid = new CalendarLayout();
            this.dateGrid.styleName = new StyleProxy(this,this.calendarLayoutStyleFilters);
            addChild(this.dateGrid);
            this.dateGrid.addEventListener(CalendarLayoutChangeEvent.CHANGE,this.dateGrid_changeHandler);
            this.dateGrid.addEventListener(DateChooserEvent.SCROLL,this.dateGrid_scrollHandler);
         }
         if(!this.calHeader)
         {
            this.calHeader = new UIComponent();
            addChild(this.calHeader);
            UIComponent(this.calHeader).styleName = this;
         }
         this.createMonthDisplay(-1);
         this.createYearDisplay(-1);
         if(this._yearNavigationEnabled)
         {
            this.getYearNavigationButtons();
         }
         if(!this.fwdMonthButton)
         {
            this.fwdMonthButton = new Button();
            this.fwdMonthButton.styleName = new StyleProxy(this,this.nextMonthStyleFilters);
            this.fwdMonthButton.autoRepeat = true;
            this.fwdMonthButton.focusEnabled = false;
            this.fwdMonthButton.upSkinName = "nextMonthUpSkin";
            this.fwdMonthButton.overSkinName = "nextMonthOverSkin";
            this.fwdMonthButton.downSkinName = "nextMonthDownSkin";
            this.fwdMonthButton.disabledSkinName = "nextMonthDisabledSkin";
            this.fwdMonthButton.skinName = "nextMonthSkin";
            this.fwdMonthButton.upIconName = "";
            this.fwdMonthButton.overIconName = "";
            this.fwdMonthButton.downIconName = "";
            this.fwdMonthButton.disabledIconName = "";
            this.fwdMonthButton.addEventListener(FlexEvent.BUTTON_DOWN,this.fwdMonthButton_buttonDownHandler);
            addChild(this.fwdMonthButton);
         }
         if(!this.backMonthButton)
         {
            this.backMonthButton = new Button();
            this.backMonthButton.styleName = new StyleProxy(this,this.prevMonthStyleFilters);
            this.backMonthButton.focusEnabled = false;
            this.backMonthButton.autoRepeat = true;
            this.backMonthButton.upSkinName = "prevMonthUpSkin";
            this.backMonthButton.overSkinName = "prevMonthOverSkin";
            this.backMonthButton.downSkinName = "prevMonthDownSkin";
            this.backMonthButton.disabledSkinName = "prevMonthDisabledSkin";
            this.backMonthButton.skinName = "prevMonthSkin";
            this.backMonthButton.upIconName = "";
            this.backMonthButton.overIconName = "";
            this.backMonthButton.downIconName = "";
            this.backMonthButton.disabledIconName = "";
            this.backMonthButton.addEventListener(FlexEvent.BUTTON_DOWN,this.backMonthButton_buttonDownHandler);
            addChild(this.backMonthButton);
         }
         if(!this.fwdMonthHit)
         {
            this.fwdMonthHit = new FlexSprite();
            this.fwdMonthHit.name = "fwdMonthHit";
            addChild(this.fwdMonthHit);
            this.fwdMonthHit.visible = false;
            this.fwdMonthButton.hitArea = this.fwdMonthHit;
         }
         if(!this.backMonthHit)
         {
            this.backMonthHit = new FlexSprite();
            this.backMonthHit.name = "backMonthHit";
            addChild(this.backMonthHit);
            this.backMonthHit.visible = false;
            this.backMonthButton.hitArea = this.backMonthHit;
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         super.commitProperties();
         if(hasFontContextChanged() && this.yearDisplay != null)
         {
            _loc1_ = getChildIndex(DisplayObject(this.yearDisplay));
            this.removeYearDisplay();
            this.createYearDisplay(_loc1_);
            _loc1_ = getChildIndex(DisplayObject(this.monthDisplay));
            this.removeMonthDisplay();
            this.createMonthDisplay(_loc1_);
         }
         if(this.showTodayChanged)
         {
            this.showTodayChanged = false;
            this.dateGrid.showToday = this._showToday;
            dispatchEvent(new Event("showTodayChanged"));
         }
         if(this.enabledChanged)
         {
            this.enabledChanged = false;
            this.fwdMonthButton.enabled = this._enabled;
            this.backMonthButton.enabled = this._enabled;
            this.monthDisplay.enabled = this._enabled;
            this.yearDisplay.enabled = this._enabled;
            if(this._yearNavigationEnabled)
            {
               this.upYearButton.enabled = this._enabled;
               this.downYearButton.enabled = this._enabled;
            }
            this.dateGrid.enabled = this._enabled;
            dispatchEvent(new Event("enabledChanged"));
         }
         if(this.firstDayOfWeekChanged)
         {
            this.firstDayOfWeekChanged = false;
            this.dateGrid.firstDayOfWeek = int(this._firstDayOfWeek);
            dispatchEvent(new Event("firstDayOfWeekChanged"));
         }
         if(this.displayedMonthChanged)
         {
            this.displayedMonthChanged = false;
            this.dateGrid.displayedMonth = this._displayedMonth;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
         }
         if(this.displayedYearChanged)
         {
            this.displayedYearChanged = false;
            this.dateGrid.displayedYear = this._displayedYear;
            invalidateDisplayList();
            dispatchEvent(new Event("viewChanged"));
         }
         if(this.dayNamesChanged)
         {
            this.dayNamesChanged = false;
            this.dateGrid.dayNames = this._dayNames ? this._dayNames.slice(0) : null;
            dispatchEvent(new Event("dayNamesChanged"));
         }
         if(this.disabledDaysChanged)
         {
            this.disabledDaysChanged = false;
            this.dateGrid.disabledDays = this._disabledDays.slice(0);
            dispatchEvent(new Event("disabledDaysChanged"));
         }
         if(this.selectableRangeChanged)
         {
            this.selectableRangeChanged = false;
            this.dateGrid.selectableRange = this._selectableRange is Array ? this._selectableRange.slice(0) : this._selectableRange;
            dispatchEvent(new Event("selectableRangeChanged"));
            invalidateDisplayList();
         }
         if(this.disabledRangesChanged)
         {
            this.disabledRangesChanged = false;
            this.dateGrid.disabledRanges = this._disabledRanges.slice(0);
            dispatchEvent(new Event("disabledRangesChanged"));
         }
         if(this.selectedDateChanged)
         {
            this.selectedDateChanged = false;
            this.dateGrid.selectedDate = this._selectedDate;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(this.selectedRangesChanged)
         {
            this.selectedRangesChanged = false;
            this.dateGrid.selectedRanges = this._selectedRanges;
            invalidateDisplayList();
            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
         }
         if(this.allowMultipleSelectionChanged)
         {
            this.allowMultipleSelectionChanged = false;
            this.dateGrid.allowMultipleSelection = this._allowMultipleSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowMultipleSelectionChanged"));
         }
         if(this.allowDisjointSelectionChanged)
         {
            this.allowDisjointSelectionChanged = false;
            this.dateGrid.allowDisjointSelection = this._allowDisjointSelection;
            invalidateDisplayList();
            dispatchEvent(new Event("allowDisjointSelectionChanged"));
         }
         if(this.monthNamesChanged)
         {
            this.monthNamesChanged = false;
            this.setMonthWidth();
            invalidateDisplayList();
            dispatchEvent(new Event("monthNamesChanged"));
         }
         if(this.yearNavigationEnabledChanged)
         {
            if(this._yearNavigationEnabled)
            {
               this.getYearNavigationButtons();
            }
            else if(Boolean(this.upYearButton) && Boolean(this.downYearButton))
            {
               removeChild(this.upYearButton);
               removeChild(this.downYearButton);
               removeChild(this.upYearHit);
               removeChild(this.downYearHit);
               this.upYearButton = null;
               this.downYearButton = null;
               this.upYearHit = null;
               this.downYearHit = null;
            }
            this.yearNavigationEnabledChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("yearNavigationEnabledChanged"));
         }
         if(this.yearSymbolChanged)
         {
            this.yearSymbolChanged = false;
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("yearSymbolChanged"));
         }
         if(this.monthSymbolChanged)
         {
            this.monthSymbolChanged = false;
            this.setMonthWidth();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("monthSymbolChanged"));
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         this.updateDateDisplay();
         this.setMonthWidth();
         var _loc1_:Number = getStyle("borderThickness");
         this.monthSkinWidth = this.fwdMonthButton.getExplicitOrMeasuredWidth();
         this.monthSkinHeight = this.fwdMonthButton.getExplicitOrMeasuredHeight();
         if(this._yearNavigationEnabled)
         {
            this.yearSkinWidth = this.upYearButton.getExplicitOrMeasuredWidth();
            this.yearSkinHeight = this.upYearButton.getExplicitOrMeasuredHeight();
         }
         else
         {
            this.yearSkinWidth = 0;
            this.yearSkinHeight = 0;
         }
         this.headerHeight = Math.ceil(Math.max(this.monthSkinHeight,this.monthDisplay.getExplicitOrMeasuredHeight())) + this.SKIN_HEIGHT_PAD * 2;
         measuredWidth = Math.max(this.dateGrid.getExplicitOrMeasuredWidth() + _loc1_ * 2,this.monthDisplay.width + this.yearDisplay.getExplicitOrMeasuredWidth() + this.HEADER_WIDTH_PAD + this.yearSkinWidth + this.YEAR_BUTTONS_PAD + (this.monthSkinWidth + this.SKIN_WIDTH_PAD * 2) * 2);
         measuredHeight = this.headerHeight + this.dateGrid.getExplicitOrMeasuredHeight() + _loc1_ * 2;
         measuredMinWidth = this.dateGrid.minWidth;
         measuredMinHeight = this.dateGrid.minHeight + this.headerHeight;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc13_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc30_:Class = null;
         var _loc31_:* = undefined;
         var _loc32_:* = undefined;
         var _loc33_:uint = 0;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:ColorTransform = null;
         var _loc37_:Graphics = null;
         var _loc38_:Graphics = null;
         var _loc39_:Number = NaN;
         var _loc40_:String = null;
         var _loc41_:Number = NaN;
         super.updateDisplayList(param1,param2);
         this.updateDateDisplay();
         var _loc3_:Number = getStyle("borderThickness");
         var _loc4_:Number = getStyle("cornerRadius");
         var _loc5_:Number = getStyle("borderColor");
         var _loc6_:Number = getStyle("borderAlpha");
         if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            if(getStyle("borderVisible") == false)
            {
               _loc3_ = 0;
            }
         }
         var _loc7_:Number = param1 - _loc3_ * 2;
         var _loc8_:Number = param2 - _loc3_ * 2;
         this.monthSkinWidth = this.fwdMonthButton.getExplicitOrMeasuredWidth();
         this.monthSkinHeight = this.fwdMonthButton.getExplicitOrMeasuredHeight();
         var _loc9_:Number = Number(this.monthDisplay.getExplicitOrMeasuredHeight());
         var _loc10_:Number = Number(this.yearDisplay.getExplicitOrMeasuredWidth());
         if(this._yearNavigationEnabled)
         {
            this.yearSkinWidth = this.upYearButton.getExplicitOrMeasuredWidth();
            this.yearSkinHeight = this.upYearButton.getExplicitOrMeasuredHeight();
         }
         var _loc11_:String = resourceManager.getString("SharedResources","dateFormat");
         var _loc12_:Boolean = this.yearBeforeMonth(_loc11_);
         if(_loc12_)
         {
            _loc13_ = _loc3_ + this.monthSkinWidth + this.SKIN_WIDTH_PAD + this.HEADER_WIDTH_PAD;
         }
         else
         {
            _loc13_ = _loc7_ - (this.monthSkinWidth + this.HEADER_WIDTH_PAD + this.yearSkinWidth + this.YEAR_BUTTONS_PAD) + _loc3_;
         }
         var _loc14_:Number = _loc3_ + (this.headerHeight - _loc9_) / 2;
         var _loc15_:Number = this.HEADER_WIDTH_PAD + this.yearSkinWidth + (this.monthSkinWidth + this.SKIN_WIDTH_PAD * 2) * 2;
         this.monthDisplay.setActualSize(Math.max(_loc7_ - _loc15_ - _loc10_,0),_loc9_);
         if(_loc12_)
         {
            this.monthDisplay.move(_loc13_ + _loc10_ + this.YEAR_BUTTONS_PAD + this.yearSkinWidth,_loc14_);
         }
         else
         {
            this.monthDisplay.move(_loc3_ + this.monthSkinWidth + this.SKIN_WIDTH_PAD + this.HEADER_WIDTH_PAD,_loc14_);
         }
         this.monthDisplay.visible = true;
         this.yearDisplay.setActualSize(_loc10_ + this.YEAR_BUTTONS_PAD,_loc9_);
         if(_loc12_)
         {
            this.yearDisplay.move(_loc13_ + this.YEAR_BUTTONS_PAD,_loc14_);
         }
         else
         {
            this.yearDisplay.move(_loc13_ - _loc10_ - this.YEAR_BUTTONS_PAD,_loc14_);
         }
         this.yearDisplay.visible = true;
         this.dateGrid.setActualSize(_loc7_,_loc8_ - this.headerHeight);
         this.dateGrid.move(_loc3_,this.headerHeight + _loc3_);
         var _loc16_:Graphics = this.background.graphics;
         _loc16_.clear();
         _loc16_.beginFill(16777215);
         _loc16_.drawRoundRect(0,0,_loc7_,_loc8_,_loc4_ * 2,_loc4_ * 2);
         _loc16_.endFill();
         this.background.$visible = true;
         var _loc17_:Graphics = this.border.graphics;
         _loc17_.clear();
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            _loc17_.beginFill(_loc5_);
         }
         else
         {
            _loc17_.beginFill(_loc5_,this.enabled ? _loc6_ : _loc6_ / 2);
         }
         _loc17_.drawRoundRect(0,0,param1,param2,_loc4_ * 2,_loc4_ * 2);
         _loc17_.drawRoundRect(_loc3_,_loc3_,param1 - _loc3_ * 2,param2 - _loc3_ * 2,_loc4_ * 2,_loc4_ * 2);
         _loc17_.endFill();
         var _loc18_:Boolean = false;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            _loc18_ = true;
         }
         else
         {
            _loc30_ = getStyle("borderSkin");
            _loc18_ = (Boolean(_loc30_)) && getQualifiedClassName(_loc30_).indexOf("skins.halo") >= 0;
         }
         var _loc19_:uint = StyleManager.NOT_A_COLOR;
         if(_loc18_ || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            _loc19_ = getStyle("backgroundColor");
         }
         else
         {
            _loc31_ = getStyle("contentBackgroundColor");
            _loc19_ = _loc31_ === undefined ? uint(getStyle("backgroundColor")) : uint(_loc31_);
         }
         var _loc20_:Number = 1;
         if(_loc18_ || FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            _loc20_ = getStyle("backgroundAlpha");
         }
         else
         {
            _loc32_ = getStyle("contentBackgroundAlpha");
            _loc20_ = _loc32_ === undefined ? Number(getStyle("backgroundAlpha")) : Number(_loc32_);
         }
         _loc17_.beginFill(_loc19_,_loc20_);
         _loc17_.drawRoundRect(_loc3_,_loc3_,_loc7_,_loc8_,_loc4_ > 0 ? (_loc4_ - 1) * 2 : 0,_loc4_ > 0 ? (_loc4_ - 1) * 2 : 0);
         _loc17_.endFill();
         this.border.visible = true;
         var _loc21_:Array = getStyle("headerColors");
         if(!_loc21_)
         {
            _loc21_ = [16777215,14211288];
         }
         var _loc22_:Graphics = this.calHeader.graphics;
         _loc22_.clear();
         styleManager.getColorNames(_loc21_);
         var _loc23_:Matrix = new Matrix();
         _loc23_.createGradientBox(_loc7_,this.headerHeight,Math.PI / 2,0,0);
         _loc22_.beginGradientFill(GradientType.LINEAR,_loc21_,[1,1],[0,255],_loc23_);
         GraphicsUtil.drawRoundRectComplex(_loc22_,_loc3_,_loc3_,_loc7_,this.headerHeight,_loc4_,_loc4_,0,0);
         _loc22_.endFill();
         if(!_loc18_ && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
         {
            _loc33_ = getStyle("chromeColor");
            _loc34_ = 204;
            _loc35_ = 13421772;
            if(_loc33_ != _loc35_)
            {
               _loc36_ = new ColorTransform();
               _loc36_.redOffset = ((_loc33_ & 255 << 16) >> 16) - _loc34_;
               _loc36_.greenOffset = ((_loc33_ & 255 << 8) >> 8) - _loc34_;
               _loc36_.blueOffset = (_loc33_ & 0xFF) - _loc34_;
               _loc36_.alphaMultiplier = alpha;
               this.calHeader.transform.colorTransform = _loc36_;
            }
            else
            {
               this.calHeader.transform.colorTransform = new ColorTransform();
            }
         }
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
         {
            _loc17_.lineStyle(_loc3_,_loc5_);
         }
         else
         {
            _loc17_.lineStyle(_loc3_,_loc5_,this.enabled ? _loc6_ : _loc6_ / 2);
         }
         _loc17_.moveTo(_loc3_,this.headerHeight + _loc3_);
         _loc17_.lineTo(_loc7_ + _loc3_,this.headerHeight + _loc3_);
         this.calHeader.$visible = true;
         this.fwdMonthButton.setActualSize(this.monthSkinWidth,this.monthSkinHeight);
         this.backMonthButton.setActualSize(this.monthSkinWidth,this.monthSkinHeight);
         this.fwdMonthButton.move(_loc7_ - (this.monthSkinWidth + this.HEADER_WIDTH_PAD) + _loc3_,Math.round(_loc3_ + (this.headerHeight - this.monthSkinHeight) / 2));
         this.backMonthButton.move(this.HEADER_WIDTH_PAD + _loc3_,Math.round(_loc3_ + (this.headerHeight - this.monthSkinHeight) / 2));
         if(this._yearNavigationEnabled)
         {
            this.upYearButton.setActualSize(this.yearSkinWidth,this.yearSkinHeight);
            this.downYearButton.setActualSize(this.yearSkinWidth,this.yearSkinHeight);
            this.upYearButton.x = _loc13_;
            this.upYearButton.y = Math.floor(this.headerHeight / 2 - this.yearSkinHeight / 2 - 2);
            this.downYearButton.x = _loc13_;
            this.downYearButton.y = Math.floor(this.headerHeight / 2 + this.yearSkinHeight / 2 - 2);
            _loc24_ = this.upYearButton.x - this.SKIN_WIDTH_PAD / 2;
            _loc25_ = this.upYearButton.y - this.SKIN_HEIGHT_PAD / 2;
            _loc37_ = this.upYearHit.graphics;
            _loc37_.clear();
            _loc37_.beginFill(13369344,0);
            _loc37_.moveTo(_loc24_,_loc25_);
            _loc37_.lineTo(_loc24_ + this.yearSkinWidth + this.SKIN_WIDTH_PAD,_loc25_);
            _loc37_.lineTo(_loc24_ + this.yearSkinWidth + this.SKIN_WIDTH_PAD,_loc25_ + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            _loc37_.lineTo(_loc24_,_loc25_ + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            _loc37_.lineTo(_loc24_,_loc25_);
            _loc37_.endFill();
            _loc24_ = this.downYearButton.x - this.SKIN_WIDTH_PAD / 2;
            _loc25_ = this.downYearButton.y;
            _loc38_ = this.downYearHit.graphics;
            _loc38_.clear();
            _loc38_.beginFill(13369344,0);
            _loc38_.moveTo(_loc24_,_loc25_);
            _loc38_.lineTo(_loc24_ + this.yearSkinWidth + this.SKIN_WIDTH_PAD,_loc25_);
            _loc38_.lineTo(_loc24_ + this.yearSkinWidth + this.SKIN_WIDTH_PAD,_loc25_ + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            _loc38_.lineTo(_loc24_,_loc25_ + this.yearSkinHeight + this.SKIN_HEIGHT_PAD / 2);
            _loc38_.lineTo(_loc24_,_loc25_);
            _loc38_.endFill();
         }
         _loc24_ = this.fwdMonthButton.x - this.SKIN_WIDTH_PAD / 2;
         _loc25_ = this.fwdMonthButton.y - this.SKIN_HEIGHT_PAD;
         var _loc26_:Graphics = this.fwdMonthHit.graphics;
         _loc26_.clear();
         _loc26_.beginFill(13369344,0);
         _loc26_.moveTo(_loc24_,_loc25_);
         _loc26_.lineTo(_loc24_ + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,_loc25_);
         _loc26_.lineTo(_loc24_ + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,_loc25_ + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         _loc26_.lineTo(_loc24_,_loc25_ + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         _loc26_.lineTo(_loc24_,_loc25_);
         _loc26_.endFill();
         _loc24_ = this.backMonthButton.x - this.SKIN_WIDTH_PAD / 2;
         _loc25_ = this.backMonthButton.y - this.SKIN_HEIGHT_PAD;
         var _loc27_:Graphics = this.backMonthHit.graphics;
         _loc27_.clear();
         _loc27_.beginFill(13369344,0);
         _loc27_.moveTo(_loc24_,_loc25_);
         _loc27_.lineTo(_loc24_ + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,_loc25_);
         _loc27_.lineTo(_loc24_ + this.monthSkinWidth + this.SKIN_WIDTH_PAD / 2,_loc25_ + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         _loc27_.lineTo(_loc24_,_loc25_ + this.monthSkinHeight + this.SKIN_HEIGHT_PAD);
         _loc27_.lineTo(_loc24_,_loc25_);
         _loc27_.endFill();
         var _loc28_:Object = getStyle("dropShadowEnabled");
         var _loc29_:Object = getStyle("dropShadowVisible");
         graphics.clear();
         if(_loc28_ == true || _loc29_ == true)
         {
            _loc39_ = getStyle("shadowDistance");
            _loc40_ = getStyle("shadowDirection");
            _loc41_ = 90;
            _loc39_ = Math.abs(_loc39_) + 2;
            if(!this.dropShadow)
            {
               this.dropShadow = new RectangularDropShadow();
            }
            this.dropShadow.distance = _loc39_;
            this.dropShadow.angle = _loc41_;
            this.dropShadow.color = getStyle("dropShadowColor");
            this.dropShadow.alpha = 0.4;
            this.dropShadow.tlRadius = _loc4_;
            this.dropShadow.trRadius = _loc4_;
            this.dropShadow.blRadius = _loc4_;
            this.dropShadow.brRadius = _loc4_;
            this.dropShadow.drawShadow(graphics,_loc3_,_loc3_,_loc7_,_loc8_);
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         var _loc2_:Object = null;
         super.styleChanged(param1);
         if(param1 == null || param1 == "styleName" || param1 == "borderColor" || param1 == "headerColor" || param1 == "headerColors" || param1 == "backgroundColor" || param1 == "horizontalGap" || param1 == "verticalGap" || param1 == "backgroundAlpha")
         {
            invalidateDisplayList();
         }
         if(param1 == null || param1 == "styleName" || Boolean(param1 == "headerStyleName") && Boolean(this.monthDisplay))
         {
            _loc2_ = getStyle("headerStyleName");
            if(!_loc2_)
            {
               _loc2_ = this;
            }
            if(this.monthDisplay)
            {
               this.monthDisplay.styleName = _loc2_;
            }
            if(this.yearDisplay)
            {
               this.yearDisplay.styleName = _loc2_;
            }
            if(this.backMonthButton)
            {
               this.backMonthButton.styleName = new StyleProxy(this,this.prevMonthStyleFilters);
            }
            if(this.fwdMonthButton)
            {
               this.fwdMonthButton.styleName = new StyleProxy(this,this.nextMonthStyleFilters);
            }
            if(this.upYearButton)
            {
               this.upYearButton.styleName = new StyleProxy(this,this.nextYearStyleFilters);
            }
            if(this.downYearButton)
            {
               this.downYearButton.styleName = new StyleProxy(this,this.prevYearStyleFilters);
            }
         }
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.dayNames = this.dayNamesOverride;
         this.firstDayOfWeek = this.firstDayOfWeekOverride;
         this.monthNames = this.monthNamesOverride;
         this.monthSymbol = this.monthSymbolOverride;
         this.yearSymbol = this.yearSymbolOverride;
      }
      
      mx_internal function createMonthDisplay(param1:int) : void
      {
         var _loc2_:TextFormat = null;
         var _loc3_:Object = null;
         if(!this.monthDisplay)
         {
            this.monthDisplay = IUITextField(createInFontContext(UITextField));
            _loc2_ = determineTextFormatFromStyles();
            this.monthDisplay.defaultTextFormat = _loc2_;
            this.monthDisplay.visible = false;
            this.monthDisplay.selectable = false;
            if(param1 == -1)
            {
               addChild(DisplayObject(this.monthDisplay));
            }
            else
            {
               addChildAt(DisplayObject(this.monthDisplay),param1);
            }
            _loc3_ = getStyle("headerStyleName");
            if(!_loc3_)
            {
               _loc3_ = this;
            }
            this.monthDisplay.styleName = _loc3_;
            this.setMonthWidth();
         }
      }
      
      mx_internal function removeMonthDisplay() : void
      {
         if(this.monthDisplay)
         {
            removeChild(DisplayObject(this.monthDisplay));
            this.monthDisplay = null;
         }
      }
      
      mx_internal function createYearDisplay(param1:int) : void
      {
         var _loc2_:TextFormat = null;
         var _loc3_:Object = null;
         if(!this.yearDisplay)
         {
            this.yearDisplay = IUITextField(createInFontContext(UITextField));
            _loc2_ = determineTextFormatFromStyles();
            this.yearDisplay.defaultTextFormat = _loc2_;
            this.yearDisplay.visible = false;
            this.yearDisplay.selectable = false;
            if(param1 == -1)
            {
               addChild(DisplayObject(this.yearDisplay));
            }
            else
            {
               addChildAt(DisplayObject(this.yearDisplay),param1);
            }
            _loc3_ = getStyle("headerStyleName");
            if(!_loc3_)
            {
               _loc3_ = this;
            }
            this.yearDisplay.styleName = _loc3_;
         }
      }
      
      mx_internal function removeYearDisplay() : void
      {
         if(this.yearDisplay)
         {
            removeChild(DisplayObject(this.yearDisplay));
            this.yearDisplay = null;
         }
      }
      
      mx_internal function updateDateDisplay() : void
      {
         var _loc1_:String = this.monthNames ? this.monthNames[this.dateGrid.displayedMonth] : "";
         this.monthDisplay.text = _loc1_ + this.monthSymbol;
         this.yearDisplay.text = this.displayedYear.toString() + this.yearSymbol;
      }
      
      private function getYearNavigationButtons() : void
      {
         if(!this.upYearButton)
         {
            this.upYearButton = new Button();
            this.upYearButton.styleName = new StyleProxy(this,this.nextYearStyleFilters);
            this.upYearButton.autoRepeat = true;
            this.upYearButton.focusEnabled = false;
            this.upYearButton.upSkinName = "nextYearUpSkin";
            this.upYearButton.overSkinName = "nextYearOverSkin";
            this.upYearButton.downSkinName = "nextYearDownSkin";
            this.upYearButton.disabledSkinName = "nextYearDisabledSkin";
            this.upYearButton.skinName = "nextYearSkin";
            this.upYearButton.upIconName = "";
            this.upYearButton.overIconName = "";
            this.upYearButton.downIconName = "";
            this.upYearButton.disabledIconName = "";
            this.upYearButton.addEventListener(FlexEvent.BUTTON_DOWN,this.upYearButton_buttonDownHandler);
            addChild(this.upYearButton);
         }
         if(!this.downYearButton)
         {
            this.downYearButton = new Button();
            this.downYearButton.styleName = new StyleProxy(this,this.prevYearStyleFilters);
            this.downYearButton.focusEnabled = false;
            this.downYearButton.autoRepeat = true;
            this.downYearButton.upSkinName = "prevYearUpSkin";
            this.downYearButton.overSkinName = "prevYearOverSkin";
            this.downYearButton.downSkinName = "prevYearDownSkin";
            this.downYearButton.disabledSkinName = "prevYearDisabledSkin";
            this.downYearButton.skinName = "prevYearSkin";
            this.downYearButton.upIconName = "";
            this.downYearButton.overIconName = "";
            this.downYearButton.downIconName = "";
            this.downYearButton.disabledIconName = "";
            this.downYearButton.addEventListener(FlexEvent.BUTTON_DOWN,this.downYearButton_buttonDownHandler);
            addChild(this.downYearButton);
         }
         if(!this.upYearHit)
         {
            this.upYearHit = new FlexSprite();
            this.upYearHit.name = "upYearHit";
            addChild(this.upYearHit);
            this.upYearHit.visible = false;
            this.upYearButton.hitArea = this.upYearHit;
         }
         if(!this.downYearHit)
         {
            this.downYearHit = new FlexSprite();
            this.downYearHit.name = "downYearHit";
            addChild(this.downYearHit);
            this.downYearHit.visible = false;
            this.downYearButton.hitArea = this.downYearHit;
         }
      }
      
      mx_internal function setMonthWidth() : void
      {
         var _loc2_:int = 0;
         var _loc8_:String = null;
         var _loc1_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < 12)
         {
            _loc8_ = this.monthNames ? this.monthNames[_loc4_] : "";
            _loc1_ = measureText(_loc8_ + this.monthSymbol).width;
            if(_loc3_ < _loc1_)
            {
               _loc3_ = _loc1_;
               _loc2_ = _loc4_;
            }
            _loc4_++;
         }
         var _loc5_:String = this.monthNames ? this.monthNames[_loc2_] : "";
         var _loc6_:String = _loc5_ + this.monthSymbol;
         var _loc7_:IUITextField = this.monthDisplay;
         _loc7_.text = _loc6_;
         this.monthDisplay.width = _loc3_ * _loc7_.getExplicitOrMeasuredWidth() / measureText(_loc6_).width;
      }
      
      private function yearBeforeMonth(param1:String) : Boolean
      {
         var _loc2_:int = param1 != null ? param1.length : 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1.charAt(_loc3_) == "M")
            {
               return false;
            }
            if(param1.charAt(_loc3_) == "Y")
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      mx_internal function scrubTimeValue(param1:Object) : Object
      {
         var _loc2_:Object = null;
         if(param1 is Date)
         {
            return new Date(param1.getFullYear(),param1.getMonth(),param1.getDate());
         }
         if(param1 is Object)
         {
            _loc2_ = {};
            if(param1.rangeStart)
            {
               _loc2_.rangeStart = new Date(param1.rangeStart.getFullYear(),param1.rangeStart.getMonth(),param1.rangeStart.getDate());
            }
            if(param1.rangeEnd)
            {
               _loc2_.rangeEnd = new Date(param1.rangeEnd.getFullYear(),param1.rangeEnd.getMonth(),param1.rangeEnd.getDate());
            }
            return _loc2_;
         }
         return null;
      }
      
      mx_internal function scrubTimeValues(param1:Array) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_[_loc3_] = this.scrubTimeValue(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      override protected function keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.eventPhase != EventPhase.AT_TARGET)
         {
            return;
         }
         if(param1.keyCode == Keyboard.PAGE_UP)
         {
            this.backMonthButton_buttonDownHandler(param1);
         }
         else if(param1.keyCode == Keyboard.PAGE_DOWN)
         {
            this.fwdMonthButton_buttonDownHandler(param1);
         }
         else if(param1.keyCode == 189)
         {
            if(this._yearNavigationEnabled)
            {
               this.downYearButton_buttonDownHandler(param1);
            }
         }
         else if(param1.keyCode == 187)
         {
            if(this._yearNavigationEnabled)
            {
               this.upYearButton_buttonDownHandler(param1);
            }
         }
         this.dateGrid.dispatchEvent(param1);
         param1.stopPropagation();
      }
      
      private function upYearButton_buttonDownHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Date = null;
         if(this.maxYear < this.displayedYear + 1)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 3))
         {
            _loc2_ = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,1,0);
            _loc3_ = new Date(_loc2_.year,_loc2_.month,this.selectableRange.rangeEnd.getDate());
            if(this.selectableRange.rangeEnd >= _loc3_)
            {
               this.dateGrid.stepDate(1,0,param1);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(1,0,param1);
            invalidateDisplayList();
         }
      }
      
      private function downYearButton_buttonDownHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Date = null;
         if(this.minYear > this.displayedYear - 1)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 2))
         {
            _loc2_ = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,-1,0);
            _loc3_ = new Date(_loc2_.year,_loc2_.month,this.selectableRange.rangeStart.getDate());
            if(this.selectableRange.rangeStart <= _loc3_)
            {
               this.dateGrid.stepDate(-1,0,param1);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(-1,0,param1);
            invalidateDisplayList();
         }
      }
      
      private function fwdMonthButton_buttonDownHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Date = null;
         if(this.maxYear < this.displayedYear + 1 && this.displayedMonth == 11)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 3))
         {
            _loc2_ = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,0,1);
            _loc3_ = new Date(_loc2_.year,_loc2_.month,this.selectableRange.rangeEnd.getDate());
            if(this.selectableRange.rangeEnd >= _loc3_)
            {
               this.dateGrid.stepDate(0,1,param1);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(0,1,param1);
            invalidateDisplayList();
         }
      }
      
      private function backMonthButton_buttonDownHandler(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Date = null;
         if(this.minYear > this.displayedYear - 1 && this.displayedMonth == 0)
         {
            return;
         }
         if(Boolean(this.selectableRange) && (this.dateGrid.selRangeMode == 1 || this.dateGrid.selRangeMode == 2))
         {
            _loc2_ = CalendarLayout.getNewIncrementDate(this.displayedYear,this.displayedMonth,0,-1);
            _loc3_ = new Date(_loc2_.year,_loc2_.month,this.selectableRange.rangeStart.getDate());
            if(this.selectableRange.rangeStart <= _loc3_)
            {
               this.dateGrid.stepDate(0,-1,param1);
               invalidateDisplayList();
            }
         }
         else if(this.dateGrid.selRangeMode != 4 || !this.selectableRange)
         {
            this.dateGrid.stepDate(0,-1,param1);
            invalidateDisplayList();
         }
      }
      
      private function dateGrid_scrollHandler(param1:DateChooserEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function dateGrid_changeHandler(param1:CalendarLayoutChangeEvent) : void
      {
         this._selectedDate = CalendarLayout(param1.target).selectedDate;
         var _loc2_:CalendarLayoutChangeEvent = new CalendarLayoutChangeEvent(CalendarLayoutChangeEvent.CHANGE);
         _loc2_.newDate = param1.newDate;
         _loc2_.triggerEvent = param1.triggerEvent;
         dispatchEvent(_loc2_);
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         if(scaleX != 1 || scaleY != 1)
         {
            invalidateSize();
         }
      }
   }
}

