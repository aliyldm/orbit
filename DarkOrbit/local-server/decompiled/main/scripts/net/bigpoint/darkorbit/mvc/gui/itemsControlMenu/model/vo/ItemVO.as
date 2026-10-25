package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.vo
{
   import net.bigpoint.darkorbit.com.module.MenuItemStatusCommand;
   import net.bigpoint.darkorbit.com.module.MessageKeyListWildcardCommand;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   
   public class ItemVO
   {
      
      private var _id:String;
      
      private var _counterType:String;
      
      private var _counterStyle:Number;
      
      private var _counterValue:Number;
      
      private var _maxCounterValue:Number;
      
      private var _actionStyle:String;
      
      private var _showTooltipCooldownTimer:Boolean;
      
      private var _timerVO:ItemTimerVO;
      
      private var _buyable:Boolean;
      
      private var _activatable:Boolean;
      
      private var _selected:Boolean;
      
      private var _available:Boolean;
      
      private var _visible:Boolean;
      
      private var _blocked:Boolean;
      
      private var _iconLootId:String;
      
      private var _toolTipItemBar:MessageKeyListWildcardCommand;
      
      private var _toolTipSlotBar:MessageKeyListWildcardCommand;
      
      private var _cooldownGroupType:int;
      
      public function ItemVO(param1:String, param2:String, param3:Number, param4:Number, param5:Number, param6:ItemTimerVO, param7:String, param8:Boolean, param9:Boolean, param10:Boolean, param11:Boolean, param12:Boolean, param13:Boolean, param14:Boolean, param15:String, param16:MessageKeyListWildcardCommand, param17:MessageKeyListWildcardCommand, param18:int)
      {
         super();
         this._id = param1;
         this._counterType = param2;
         this._counterStyle = param3 || ItemsControlMenuConstants.STYLE_BLUE;
         this._counterValue = param4;
         this._maxCounterValue = param5;
         this._timerVO = param6;
         this._actionStyle = param7;
         this._showTooltipCooldownTimer = param8;
         this._buyable = param9;
         this._activatable = param10;
         this._selected = param11;
         this._available = param12;
         this._visible = param13;
         this._blocked = param14;
         this._iconLootId = param15;
         this._toolTipItemBar = param16;
         this._toolTipSlotBar = param17;
         this._cooldownGroupType = param18;
      }
      
      public static function parse(param1:MenuItemStatusCommand, param2:String, param3:String, param4:Boolean, param5:ItemTimerVO, param6:int) : ItemVO
      {
         return new ItemVO(param1.menuItemId,param2,ItemsControlMenuConstants.COUNTER_STYLES_MAP[param1.counterStyle],param1.counterValue,param1.maxCounterValue,param5,param3,param4,param1.buyable,param1.activatable,param1.selected,param1.available,param1.visible,param1.blocked,param1.iconLootId,param1.toolTipItemBar,param1.toolTipSlotBar,param6);
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get counterType() : String
      {
         return this._counterType;
      }
      
      public function get counterValue() : Number
      {
         return this._counterValue;
      }
      
      public function get maxCounterValue() : Number
      {
         return this._maxCounterValue;
      }
      
      public function get actionStyle() : String
      {
         return this._actionStyle;
      }
      
      public function get showTooltipCooldownTimer() : Boolean
      {
         return this._showTooltipCooldownTimer;
      }
      
      public function get activatable() : Boolean
      {
         return this._activatable;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function get iconLootId() : String
      {
         return this._iconLootId;
      }
      
      public function set counterValue(param1:Number) : void
      {
         this._counterValue = param1;
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
      
      public function get counterStyle() : Number
      {
         return this._counterStyle;
      }
      
      public function set maxCounterValue(param1:Number) : void
      {
         this._maxCounterValue = param1;
      }
      
      public function get timerVO() : ItemTimerVO
      {
         return this._timerVO;
      }
      
      public function get hasCountDownTimer() : Boolean
      {
         return this._timerVO.countDownTimer != null;
      }
      
      public function set timerVO(param1:ItemTimerVO) : void
      {
         if(Boolean(this._timerVO) && Boolean(this._timerVO.countDownTimer))
         {
            this._timerVO.countDownTimer.dispose(param1.time == 0);
         }
         this._timerVO = param1;
      }
      
      public function get buyable() : Boolean
      {
         return this._buyable;
      }
      
      public function get toolTipItemBar() : MessageKeyListWildcardCommand
      {
         return this._toolTipItemBar;
      }
      
      public function get toolTipSlotBar() : MessageKeyListWildcardCommand
      {
         return this._toolTipSlotBar;
      }
      
      public function get cooldownGroupType() : int
      {
         return this._cooldownGroupType;
      }
      
      public function set cooldownGroupType(param1:int) : void
      {
         this._cooldownGroupType = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set activatable(param1:Boolean) : void
      {
         this._activatable = param1;
      }
      
      public function get blocked() : Boolean
      {
         return this._blocked;
      }
      
      public function set counterStyle(param1:Number) : void
      {
         this._counterStyle = param1;
      }
   }
}

