package net.bigpoint.darkorbit.mvc.tdm.popups.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOPopUp;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.VGroup;
   
   public class TeamDeathMatchParticipationPopup extends DOPopUp
   {
      
      public static const EVENT_TIMER_FINISHED:String = "timerFinishedEvent";
      
      public static const EVENT_LEAVE_QUEUE:String = "leaveQueue";
      
      public static const EVENT_JOIN:String = "joinMatch";
      
      protected static const PLACEHOLDER:String = "%SECONDS%";
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _1719531403bigTopLevelHoldingGroupObjectThingy:Group;
      
      private var _2087175378buttonConfirm:DOButtonBase;
      
      private var _1777408347buttonLeave:DOButtonBase;
      
      private var _315970861groupDepth1:VGroup;
      
      private var _990911370labelCountDownMessage:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var timer:Timer;
      
      private var timerValue:uint;
      
      public function TeamDeathMatchParticipationPopup()
      {
         super();
         mx_internal::_document = this;
         this.styleName = "battleStationPopup";
         this.title = "";
         this.minHeight = 150;
         this.minWidth = 400;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._TeamDeathMatchParticipationPopup_Array1_c);
         this.addEventListener("creationComplete",this.___TeamDeathMatchParticipationPopup_DOPopUp1_creationComplete);
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      private function handlePopUpReady() : void
      {
         this.title = BPLocale.getItem("teamdeathmatch_popup_match_participation_title");
         this.buttonConfirm.label = BPLocale.getItem("teamdeathmatch_popup_match_participation_confirm");
         this.buttonLeave.label = BPLocale.getItem("teamdeathmatch_popup_match_participation_leave");
      }
      
      override protected function handleCloseButtonClick(param1:MouseEvent = null) : void
      {
         super.handleCloseButtonClick(param1);
      }
      
      private function handleJoinButtonClick(param1:Event) : void
      {
         dispatchEvent(new Event(EVENT_JOIN));
      }
      
      private function handleLeaveButtonClick(param1:Event) : void
      {
         dispatchEvent(new Event(EVENT_LEAVE_QUEUE));
      }
      
      private function initTimer() : void
      {
         if(this.timer == null)
         {
            this.timer = new Timer(1000);
            this.timer.addEventListener(TimerEvent.TIMER,this.handleTimerEvent);
         }
      }
      
      public function startTimer(param1:int) : void
      {
         this.timerValue = param1;
         this.initTimer();
         this.timer.start();
         this.setCoutDownMessage(this.timerValue.toString());
      }
      
      public function stopTimer() : void
      {
         if(this.timer)
         {
            this.timer.stop();
         }
      }
      
      public function clearTimer() : void
      {
         this.stopTimer();
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.handleTimerEvent);
            this.timer = null;
         }
      }
      
      protected function handleTimerEvent(param1:TimerEvent) : void
      {
         if(this.timerValue > 0)
         {
            --this.timerValue;
         }
         else
         {
            this.clearTimer();
            dispatchEvent(new Event(EVENT_TIMER_FINISHED));
            closeWindow();
         }
         this.setCoutDownMessage(this.timerValue.toString());
      }
      
      public function setCoutDownMessage(param1:String) : void
      {
         var _loc2_:String = BPLocale.getItem("teamdeathmatch_popup_match_participation_description");
         var _loc3_:String = _loc2_.replace(PLACEHOLDER,param1);
         this.labelCountDownMessage.text = _loc3_;
      }
      
      private function _TeamDeathMatchParticipationPopup_Array1_c() : Array
      {
         return [this._TeamDeathMatchParticipationPopup_Group1_i()];
      }
      
      private function _TeamDeathMatchParticipationPopup_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 85;
         _loc1_.mxmlContent = [this._TeamDeathMatchParticipationPopup_VGroup1_i(),this._TeamDeathMatchParticipationPopup_HGroup1_c()];
         _loc1_.id = "bigTopLevelHoldingGroupObjectThingy";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bigTopLevelHoldingGroupObjectThingy = _loc1_;
         BindingManager.executeBindings(this,"bigTopLevelHoldingGroupObjectThingy",this.bigTopLevelHoldingGroupObjectThingy);
         return _loc1_;
      }
      
      private function _TeamDeathMatchParticipationPopup_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalCenter = 0;
         _loc1_.mxmlContent = [this._TeamDeathMatchParticipationPopup_Label1_i()];
         _loc1_.id = "groupDepth1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth1 = _loc1_;
         BindingManager.executeBindings(this,"groupDepth1",this.groupDepth1);
         return _loc1_;
      }
      
      private function _TeamDeathMatchParticipationPopup_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.percentWidth = 95;
         _loc1_.height = 100;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontSize",15);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "labelCountDownMessage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelCountDownMessage = _loc1_;
         BindingManager.executeBindings(this,"labelCountDownMessage",this.labelCountDownMessage);
         return _loc1_;
      }
      
      private function _TeamDeathMatchParticipationPopup_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.bottom = 4;
         _loc1_.percentWidth = 100;
         _loc1_.height = 28;
         _loc1_.horizontalAlign = "center";
         _loc1_.horizontalCenter = 0;
         _loc1_.mxmlContent = [this._TeamDeathMatchParticipationPopup_DOButtonBase1_i(),this._TeamDeathMatchParticipationPopup_DOButtonBase2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TeamDeathMatchParticipationPopup_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.label = "Cancel";
         _loc1_.styleName = "questWindowAcceptQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__buttonConfirm_click);
         _loc1_.id = "buttonConfirm";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.buttonConfirm = _loc1_;
         BindingManager.executeBindings(this,"buttonConfirm",this.buttonConfirm);
         return _loc1_;
      }
      
      public function __buttonConfirm_click(param1:MouseEvent) : void
      {
         this.handleJoinButtonClick(param1);
      }
      
      private function _TeamDeathMatchParticipationPopup_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.label = "Cancel";
         _loc1_.styleName = "questWindowAcceptQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__buttonLeave_click);
         _loc1_.id = "buttonLeave";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.buttonLeave = _loc1_;
         BindingManager.executeBindings(this,"buttonLeave",this.buttonLeave);
         return _loc1_;
      }
      
      public function __buttonLeave_click(param1:MouseEvent) : void
      {
         this.handleLeaveButtonClick(param1);
      }
      
      public function ___TeamDeathMatchParticipationPopup_DOPopUp1_creationComplete(param1:FlexEvent) : void
      {
         this.handlePopUpReady();
      }
      
      [Bindable(event="propertyChange")]
      public function get bigTopLevelHoldingGroupObjectThingy() : Group
      {
         return this._1719531403bigTopLevelHoldingGroupObjectThingy;
      }
      
      public function set bigTopLevelHoldingGroupObjectThingy(param1:Group) : void
      {
         var _loc2_:Object = this._1719531403bigTopLevelHoldingGroupObjectThingy;
         if(_loc2_ !== param1)
         {
            this._1719531403bigTopLevelHoldingGroupObjectThingy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bigTopLevelHoldingGroupObjectThingy",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonConfirm() : DOButtonBase
      {
         return this._2087175378buttonConfirm;
      }
      
      public function set buttonConfirm(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._2087175378buttonConfirm;
         if(_loc2_ !== param1)
         {
            this._2087175378buttonConfirm = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonConfirm",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonLeave() : DOButtonBase
      {
         return this._1777408347buttonLeave;
      }
      
      public function set buttonLeave(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1777408347buttonLeave;
         if(_loc2_ !== param1)
         {
            this._1777408347buttonLeave = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonLeave",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupDepth1() : VGroup
      {
         return this._315970861groupDepth1;
      }
      
      public function set groupDepth1(param1:VGroup) : void
      {
         var _loc2_:Object = this._315970861groupDepth1;
         if(_loc2_ !== param1)
         {
            this._315970861groupDepth1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupDepth1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelCountDownMessage() : Label
      {
         return this._990911370labelCountDownMessage;
      }
      
      public function set labelCountDownMessage(param1:Label) : void
      {
         var _loc2_:Object = this._990911370labelCountDownMessage;
         if(_loc2_ !== param1)
         {
            this._990911370labelCountDownMessage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelCountDownMessage",_loc2_,param1));
            }
         }
      }
   }
}

