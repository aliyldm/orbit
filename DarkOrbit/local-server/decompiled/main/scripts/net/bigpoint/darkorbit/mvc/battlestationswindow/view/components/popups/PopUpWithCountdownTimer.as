package net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups
{
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOPopUp;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   public class PopUpWithCountdownTimer extends DOPopUp
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _1374761920countdownTimerLabel:Label;
      
      private var _1048779289factionLogo:SkinnableContainer;
      
      private var _99290947owningClanName:Label;
      
      private var _1094898053popupTextLabel:Label;
      
      private var _1791483012titleLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var countdownIntervalMs:Number;
      
      private var countdownInterval:Number = 1000;
      
      private var timeLeft:int;
      
      private var totalTime:int;
      
      private var progressTimer:Timer;
      
      public function PopUpWithCountdownTimer()
      {
         super();
         mx_internal::_document = this;
         this.styleName = "battleStationPopup";
         this.title = "Some progress related title";
         this.minHeight = 225;
         this.minWidth = 146;
         this.width = 245;
         this.height = 215;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._PopUpWithCountdownTimer_Array1_c);
         this.addEventListener("creationComplete",this.___PopUpWithCountdownTimer_DOPopUp1_creationComplete);
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
      
      public function setPopupText(param1:String, param2:String, param3:String) : void
      {
         this.popupTextLabel.text = param1;
         this.titleLabel.text = param2;
         this.owningClanName.text = param3;
      }
      
      private function handleCancelButtonClicked(param1:MouseEvent) : void
      {
         handleCloseButtonClick(null);
      }
      
      public function setProgressBarProgress(param1:int, param2:int) : void
      {
         this.countdownIntervalMs = this.countdownInterval / 1000;
         this.timeLeft = param1;
         this.totalTime = param2;
         var _loc3_:String = this.convertToHHMMSS(param1);
         this.countdownTimerLabel.text = _loc3_;
         if(this.progressTimer != null)
         {
            this.progressTimer.stop();
            this.progressTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerTick);
         }
         this.progressTimer = new Timer(this.countdownInterval);
         this.progressTimer.addEventListener(TimerEvent.TIMER,this.handleTimerTick);
         this.progressTimer.start();
      }
      
      private function handleTimerComplete() : void
      {
         this.progressTimer.stop();
         this.progressTimer.removeEventListener(TimerEvent.TIMER,this.handleTimerTick);
         handleCloseButtonClick(null);
      }
      
      private function handleTimerTick(param1:TimerEvent) : void
      {
         this.timeLeft -= this.countdownIntervalMs;
         var _loc2_:String = this.convertToHHMMSS(this.timeLeft);
         this.countdownTimerLabel.text = _loc2_;
         if(this.timeLeft <= 0)
         {
            this.handleTimerComplete();
         }
      }
      
      private function convertToHHMMSS(param1:Number) : String
      {
         var _loc2_:Number = param1 % 60;
         var _loc3_:Number = Math.floor(param1 % 3600 / 60);
         var _loc4_:Number = Math.floor(param1 / (60 * 60));
         var _loc5_:String = _loc4_ == 0 ? "" : this.doubleDigitFormat(_loc4_) + ":";
         var _loc6_:String = this.doubleDigitFormat(_loc3_) + ":";
         var _loc7_:String = this.doubleDigitFormat(_loc2_);
         return _loc5_ + _loc6_ + _loc7_;
      }
      
      private function doubleDigitFormat(param1:uint) : String
      {
         if(param1 < 10)
         {
            return "0" + param1;
         }
         return String(param1);
      }
      
      private function handleComponentReady() : void
      {
      }
      
      public function setClanImage(param1:String) : void
      {
         this.factionLogo.styleName = param1;
      }
      
      private function _PopUpWithCountdownTimer_Array1_c() : Array
      {
         return [this._PopUpWithCountdownTimer_Group1_c(),this._PopUpWithCountdownTimer_Group2_c()];
      }
      
      private function _PopUpWithCountdownTimer_Group1_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.horizontalCenter = 0;
         _loc1_.width = 225;
         _loc1_.top = -5;
         _loc1_.mxmlContent = [this._PopUpWithCountdownTimer_Label1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithCountdownTimer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.id = "titleLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.titleLabel = _loc1_;
         BindingManager.executeBindings(this,"titleLabel",this.titleLabel);
         return _loc1_;
      }
      
      private function _PopUpWithCountdownTimer_Group2_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.width = 225;
         _loc1_.height = 150;
         _loc1_.mxmlContent = [this._PopUpWithCountdownTimer_SkinnableContainer1_c(),this._PopUpWithCountdownTimer_Label2_i(),this._PopUpWithCountdownTimer_Label3_i(),this._PopUpWithCountdownTimer_SkinnableContainer2_i(),this._PopUpWithCountdownTimer_Label4_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithCountdownTimer_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "constructionProgressBackground";
         _loc1_.width = 225;
         _loc1_.height = 150;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithCountdownTimer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.horizontalCenter = 0;
         _loc1_.percentHeight = 100;
         _loc1_.top = 12;
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",14208634);
         _loc1_.id = "popupTextLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.popupTextLabel = _loc1_;
         BindingManager.executeBindings(this,"popupTextLabel",this.popupTextLabel);
         return _loc1_;
      }
      
      private function _PopUpWithCountdownTimer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "ClanName";
         _loc1_.horizontalCenter = 0;
         _loc1_.top = 28;
         _loc1_.setStyle("fontSize",18);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",14931639);
         _loc1_.id = "owningClanName";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.owningClanName = _loc1_;
         BindingManager.executeBindings(this,"owningClanName",this.owningClanName);
         return _loc1_;
      }
      
      private function _PopUpWithCountdownTimer_SkinnableContainer2_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "";
         _loc1_.horizontalCenter = 0;
         _loc1_.bottom = 45;
         _loc1_.id = "factionLogo";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.factionLogo = _loc1_;
         BindingManager.executeBindings(this,"factionLogo",this.factionLogo);
         return _loc1_;
      }
      
      private function _PopUpWithCountdownTimer_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.bottom = 20;
         _loc1_.horizontalCenter = 0;
         _loc1_.setStyle("fontSize",18);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",14931639);
         _loc1_.id = "countdownTimerLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.countdownTimerLabel = _loc1_;
         BindingManager.executeBindings(this,"countdownTimerLabel",this.countdownTimerLabel);
         return _loc1_;
      }
      
      public function ___PopUpWithCountdownTimer_DOPopUp1_creationComplete(param1:FlexEvent) : void
      {
         this.handleComponentReady();
      }
      
      [Bindable(event="propertyChange")]
      public function get countdownTimerLabel() : Label
      {
         return this._1374761920countdownTimerLabel;
      }
      
      public function set countdownTimerLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1374761920countdownTimerLabel;
         if(_loc2_ !== param1)
         {
            this._1374761920countdownTimerLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"countdownTimerLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get factionLogo() : SkinnableContainer
      {
         return this._1048779289factionLogo;
      }
      
      public function set factionLogo(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._1048779289factionLogo;
         if(_loc2_ !== param1)
         {
            this._1048779289factionLogo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"factionLogo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get owningClanName() : Label
      {
         return this._99290947owningClanName;
      }
      
      public function set owningClanName(param1:Label) : void
      {
         var _loc2_:Object = this._99290947owningClanName;
         if(_loc2_ !== param1)
         {
            this._99290947owningClanName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"owningClanName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get popupTextLabel() : Label
      {
         return this._1094898053popupTextLabel;
      }
      
      public function set popupTextLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1094898053popupTextLabel;
         if(_loc2_ !== param1)
         {
            this._1094898053popupTextLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"popupTextLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleLabel() : Label
      {
         return this._1791483012titleLabel;
      }
      
      public function set titleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1791483012titleLabel;
         if(_loc2_ !== param1)
         {
            this._1791483012titleLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleLabel",_loc2_,param1));
            }
         }
      }
   }
}

