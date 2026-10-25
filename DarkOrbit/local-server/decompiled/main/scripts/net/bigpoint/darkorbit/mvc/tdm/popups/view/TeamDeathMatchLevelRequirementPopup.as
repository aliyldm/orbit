package net.bigpoint.darkorbit.mvc.tdm.popups.view
{
   import flash.events.MouseEvent;
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
   
   public class TeamDeathMatchLevelRequirementPopup extends DOPopUp
   {
      
      public static const EVENT_EXIT_QUEUE_CONFIRMATION:String = "SectorControlLeaveGamePopUp.EVENT_EXIT_QUEUE_CONFIRMATION";
      
      public static const EVENT_EXIT_QUEUE_CANCEL:String = "SectorControlLeaveGamePopUp.EVENT_EXIT_QUEUE_CANCEL";
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _1719531403bigTopLevelHoldingGroupObjectThingy:Group;
      
      private var _32957383confirmationButton:DOButtonBase;
      
      private var _315970861groupDepth1:VGroup;
      
      private var _467213939labelMessage:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function TeamDeathMatchLevelRequirementPopup()
      {
         super();
         mx_internal::_document = this;
         this.styleName = "battleStationPopup";
         this.title = "";
         this.minHeight = 150;
         this.minWidth = 400;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._TeamDeathMatchLevelRequirementPopup_Array1_c);
         this.addEventListener("creationComplete",this.___TeamDeathMatchLevelRequirementPopup_DOPopUp1_creationComplete);
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
         this.title = BPLocale.getItem("teamdeathmatch_popup_level_requirement_title");
         this.confirmationButton.label = BPLocale.getItem("label_close");
         this.labelMessage.text = BPLocale.getItem("teamdeathmatch_popup_level_requirement_description");
      }
      
      public function set message(param1:String) : void
      {
         this.labelMessage.text = param1;
      }
      
      override protected function handleCloseButtonClick(param1:MouseEvent = null) : void
      {
         super.handleCloseButtonClick(param1);
      }
      
      private function _TeamDeathMatchLevelRequirementPopup_Array1_c() : Array
      {
         return [this._TeamDeathMatchLevelRequirementPopup_Group1_i()];
      }
      
      private function _TeamDeathMatchLevelRequirementPopup_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 85;
         _loc1_.mxmlContent = [this._TeamDeathMatchLevelRequirementPopup_VGroup1_i(),this._TeamDeathMatchLevelRequirementPopup_HGroup1_c()];
         _loc1_.id = "bigTopLevelHoldingGroupObjectThingy";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bigTopLevelHoldingGroupObjectThingy = _loc1_;
         BindingManager.executeBindings(this,"bigTopLevelHoldingGroupObjectThingy",this.bigTopLevelHoldingGroupObjectThingy);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLevelRequirementPopup_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalCenter = 0;
         _loc1_.mxmlContent = [this._TeamDeathMatchLevelRequirementPopup_Label1_i()];
         _loc1_.id = "groupDepth1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth1 = _loc1_;
         BindingManager.executeBindings(this,"groupDepth1",this.groupDepth1);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLevelRequirementPopup_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.percentWidth = 95;
         _loc1_.height = 100;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontSize",15);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "labelMessage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelMessage = _loc1_;
         BindingManager.executeBindings(this,"labelMessage",this.labelMessage);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLevelRequirementPopup_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.bottom = 4;
         _loc1_.percentWidth = 100;
         _loc1_.height = 28;
         _loc1_.horizontalAlign = "center";
         _loc1_.horizontalCenter = 0;
         _loc1_.mxmlContent = [this._TeamDeathMatchLevelRequirementPopup_DOButtonBase1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TeamDeathMatchLevelRequirementPopup_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = null;
         _loc1_ = new DOButtonBase();
         _loc1_.label = "Cancel";
         _loc1_.styleName = "questWindowAcceptQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__confirmationButton_click);
         _loc1_.id = "confirmationButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.confirmationButton = _loc1_;
         BindingManager.executeBindings(this,"confirmationButton",this.confirmationButton);
         return _loc1_;
      }
      
      public function __confirmationButton_click(param1:MouseEvent) : void
      {
         this.handleCloseButtonClick(param1);
      }
      
      public function ___TeamDeathMatchLevelRequirementPopup_DOPopUp1_creationComplete(param1:FlexEvent) : void
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
      public function get confirmationButton() : DOButtonBase
      {
         return this._32957383confirmationButton;
      }
      
      public function set confirmationButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._32957383confirmationButton;
         if(_loc2_ !== param1)
         {
            this._32957383confirmationButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"confirmationButton",_loc2_,param1));
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
      public function get labelMessage() : Label
      {
         return this._467213939labelMessage;
      }
      
      public function set labelMessage(param1:Label) : void
      {
         var _loc2_:Object = this._467213939labelMessage;
         if(_loc2_ !== param1)
         {
            this._467213939labelMessage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelMessage",_loc2_,param1));
            }
         }
      }
   }
}

