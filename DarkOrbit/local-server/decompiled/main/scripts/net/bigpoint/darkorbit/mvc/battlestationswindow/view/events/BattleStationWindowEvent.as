package net.bigpoint.darkorbit.mvc.battlestationswindow.view.events
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   
   public class BattleStationWindowEvent extends Event
   {
      
      public static const EQUIP_MODULE:String = "EQUIP_MODULE";
      
      public static const CONFIRM_BTN_CLICKED:String = "CONFIRM_BTN_CLICKED";
      
      public static const SLIDER_SELECTION_MADE:String = "CONSTRUCTION_TIME_SELECTED";
      
      public static const SHOW_BUILD_TIME_SELECTION_POPUP:String = "SHOW_BUILD_TIME_SELECTION_POPUP";
      
      public static const SHOW_DEFLECTOR_DEACTIVATION_POPUP:String = "SHOW_DEFLECTOR_DEACTIVATION_POPUP";
      
      public static const ACTIVATE_BUTTON_CLICKED:String = "ACTIVATE_BUTTON_CLICKED";
      
      public static const BATTLE_STATION_MODULE_CLICKED:String = "BATTLE_STATION_MODULE_CLICKED";
      
      public static const BATTLE_STATION_MODULE_ROLLED_IN:String = "BATTLE_STATION_MODULE_ROLLED_IN";
      
      public static const BATTLE_STATION_MODULE_ROLLED_OUT:String = "BATTLE_STATION_MODULE_ROLLED_OUT";
      
      public static const SHOW_INVENTORY_FILTER_POPUP:String = "SHOW_INVENTORY_FILTER_POPUP";
      
      public var itemId:int;
      
      public var slotId:int;
      
      public var moduleType:int;
      
      public var replaceFlag:Boolean = false;
      
      public var sliderSelectionValue:int;
      
      public var moduleItem:ModuleItem;
      
      public var bsName:String;
      
      public function BattleStationWindowEvent(param1:String = "", param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         var _loc1_:BattleStationWindowEvent = new BattleStationWindowEvent(type);
         _loc1_.itemId = this.itemId;
         _loc1_.slotId = this.slotId;
         _loc1_.replaceFlag = this.replaceFlag;
         _loc1_.moduleItem = this.moduleItem;
         _loc1_.bsName = this.bsName;
         return _loc1_;
      }
   }
}

