package mx.accessibility
{
   import flash.accessibility.Accessibility;
   import flash.events.Event;
   import mx.controls.DateChooser;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class DateChooserAccImpl extends AccImpl
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var calFlag:Boolean = true;
      
      private var monthFlag:Boolean = true;
      
      private var lastSelectedDate:Date;
      
      private var selDateFallsInCurrMonth:Boolean;
      
      public function DateChooserAccImpl(param1:UIComponent)
      {
         super(param1);
         role = AccConst.ROLE_SYSTEM_WINDOW;
      }
      
      public static function enableAccessibility() : void
      {
         DateChooser.createAccessibilityImplementation = createAccessibilityImplementation;
      }
      
      mx_internal static function createAccessibilityImplementation(param1:UIComponent) : void
      {
         param1.accessibilityImplementation = new DateChooserAccImpl(param1);
      }
      
      override protected function get eventsToHandle() : Array
      {
         return super.eventsToHandle.concat(["focusIn","change","scroll"]);
      }
      
      override public function get_accState(param1:uint) : uint
      {
         return getState(param1);
      }
      
      override public function accDoDefaultAction(param1:uint) : void
      {
      }
      
      override protected function getName(param1:uint) : String
      {
         var _loc2_:String = null;
         var _loc5_:Date = null;
         var _loc3_:DateChooser = DateChooser(master);
         var _loc4_:Date = _loc3_.selectedDate;
         this.selDateFallsInCurrMonth = _loc4_ != null && _loc4_.getMonth() == _loc3_.displayedMonth && _loc4_.getFullYear() == _loc3_.displayedYear;
         if(_loc4_ != null && this.selDateFallsInCurrMonth)
         {
            if(this.monthFlag)
            {
               _loc2_ = "" + _loc4_.getDate() + " " + _loc3_.dayNames[_loc4_.getDay()] + ", " + _loc3_.monthNames[_loc3_.displayedMonth] + " " + _loc3_.displayedYear;
            }
            else
            {
               _loc2_ = "" + _loc4_.getDate() + " " + _loc3_.dayNames[_loc4_.getDay()];
            }
            _loc5_ = new Date();
            if(_loc5_.getDate() == _loc4_.getDate() && _loc5_.getMonth() == _loc4_.getMonth() && _loc5_.getFullYear() == _loc4_.getFullYear())
            {
               _loc2_ += ", today";
            }
         }
         else
         {
            _loc2_ = _loc3_.monthNames[_loc3_.displayedMonth] + " " + _loc3_.displayedYear;
         }
         if(this.calFlag)
         {
            _loc2_ = " Calendar View, " + _loc2_;
         }
         return _loc2_;
      }
      
      override protected function eventHandler(param1:Event) : void
      {
         var _loc4_:Date = null;
         $eventHandler(param1);
         var _loc2_:DateChooser = DateChooser(master);
         var _loc3_:int = _loc2_.displayedMonth + _loc2_.displayedYear;
         switch(param1.type)
         {
            case "focusIn":
               this.calFlag = true;
               this.monthFlag = true;
               break;
            case "change":
               this.calFlag = false;
               _loc4_ = _loc2_.selectedDate;
               if(_loc4_)
               {
                  if(this.lastSelectedDate)
                  {
                     this.monthFlag = this.lastSelectedDate.getDate() == _loc4_.getDate();
                  }
                  Accessibility.sendEvent(master,_loc3_ + _loc4_.getDate() + 100,AccConst.EVENT_OBJECT_FOCUS);
                  Accessibility.sendEvent(master,_loc3_ + _loc4_.getDate() + 100,AccConst.EVENT_OBJECT_SELECTION);
               }
               this.lastSelectedDate = _loc4_;
               break;
            case "scroll":
               this.calFlag = false;
               this.monthFlag = true;
               Accessibility.sendEvent(master,_loc3_,AccConst.EVENT_OBJECT_FOCUS);
               Accessibility.sendEvent(master,_loc3_,AccConst.EVENT_OBJECT_SELECTION);
         }
      }
   }
}

