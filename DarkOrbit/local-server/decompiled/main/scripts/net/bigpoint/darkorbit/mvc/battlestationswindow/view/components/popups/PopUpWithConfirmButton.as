package net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups
{
   import flash.events.MouseEvent;
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOPopUp;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.VGroup;
   
   public class PopUpWithConfirmButton extends DOPopUp
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _1719531403bigTopLevelHoldingGroupObjectThingy:Group;
      
      private var _1990131276cancelButton:DOButtonBase;
      
      private var _236983790confirmButton:DOButtonBase;
      
      private var _315970861groupDepth1:VGroup;
      
      private var _954925063message:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public var slotIDOfModuleToRemove:int;
      
      public var moduleTypeToRemove:int;
      
      public var itemIDOFModuleToRemove:int;
      
      public function PopUpWithConfirmButton()
      {
         super();
         mx_internal::_document = this;
         this.styleName = "battleStationPopup";
         this.title = "-";
         this.width = 400;
         this.height = 145;
         this.minHeight = 130;
         this.minWidth = 400;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._PopUpWithConfirmButton_Array1_c);
         this.addEventListener("creationComplete",this.___PopUpWithConfirmButton_DOPopUp1_creationComplete);
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
      
      private function handleComponentReady() : void
      {
      }
      
      private function handleConfirmButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:BattleStationWindowEvent = new BattleStationWindowEvent(BattleStationWindowEvent.CONFIRM_BTN_CLICKED);
         _loc2_.slotId = this.slotIDOfModuleToRemove;
         _loc2_.itemId = this.itemIDOFModuleToRemove;
         dispatchEvent(_loc2_);
         handleCloseButtonClick(null);
      }
      
      private function handleCancelButtonClicked(param1:MouseEvent) : void
      {
         handleCloseButtonClick(null);
      }
      
      public function setMessageText(param1:String) : void
      {
         this.message.text = param1;
      }
      
      public function setButtonTexts(param1:String, param2:String) : void
      {
         this.confirmButton.label = param1;
         this.cancelButton.label = param2;
      }
      
      private function _PopUpWithConfirmButton_Array1_c() : Array
      {
         return [this._PopUpWithConfirmButton_Group1_i()];
      }
      
      private function _PopUpWithConfirmButton_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._PopUpWithConfirmButton_VGroup1_i()];
         _loc1_.id = "bigTopLevelHoldingGroupObjectThingy";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.bigTopLevelHoldingGroupObjectThingy = _loc1_;
         BindingManager.executeBindings(this,"bigTopLevelHoldingGroupObjectThingy",this.bigTopLevelHoldingGroupObjectThingy);
         return _loc1_;
      }
      
      private function _PopUpWithConfirmButton_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.mxmlContent = [this._PopUpWithConfirmButton_Label1_i(),this._PopUpWithConfirmButton_HGroup1_c()];
         _loc1_.id = "groupDepth1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.groupDepth1 = _loc1_;
         BindingManager.executeBindings(this,"groupDepth1",this.groupDepth1);
         return _loc1_;
      }
      
      private function _PopUpWithConfirmButton_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "-";
         _loc1_.minHeight = 40;
         _loc1_.width = 390;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.setStyle("fontSize",16);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "message";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.message = _loc1_;
         BindingManager.executeBindings(this,"message",this.message);
         return _loc1_;
      }
      
      private function _PopUpWithConfirmButton_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.mxmlContent = [this._PopUpWithConfirmButton_DOButtonBase1_i(),this._PopUpWithConfirmButton_DOButtonBase2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithConfirmButton_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.label = "Confirm";
         _loc1_.styleName = "questWindowAcceptQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__confirmButton_click);
         _loc1_.id = "confirmButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.confirmButton = _loc1_;
         BindingManager.executeBindings(this,"confirmButton",this.confirmButton);
         return _loc1_;
      }
      
      public function __confirmButton_click(param1:MouseEvent) : void
      {
         this.handleConfirmButtonClick(param1);
      }
      
      private function _PopUpWithConfirmButton_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.label = "Cancel";
         _loc1_.styleName = "questWindowAbortQuest";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__cancelButton_click);
         _loc1_.id = "cancelButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.cancelButton = _loc1_;
         BindingManager.executeBindings(this,"cancelButton",this.cancelButton);
         return _loc1_;
      }
      
      public function __cancelButton_click(param1:MouseEvent) : void
      {
         this.handleCancelButtonClicked(param1);
      }
      
      public function ___PopUpWithConfirmButton_DOPopUp1_creationComplete(param1:FlexEvent) : void
      {
         this.handleComponentReady();
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
      public function get cancelButton() : DOButtonBase
      {
         return this._1990131276cancelButton;
      }
      
      public function set cancelButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1990131276cancelButton;
         if(_loc2_ !== param1)
         {
            this._1990131276cancelButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cancelButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get confirmButton() : DOButtonBase
      {
         return this._236983790confirmButton;
      }
      
      public function set confirmButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._236983790confirmButton;
         if(_loc2_ !== param1)
         {
            this._236983790confirmButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"confirmButton",_loc2_,param1));
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
      public function get message() : Label
      {
         return this._954925063message;
      }
      
      public function set message(param1:Label) : void
      {
         var _loc2_:Object = this._954925063message;
         if(_loc2_ !== param1)
         {
            this._954925063message = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message",_loc2_,param1));
            }
         }
      }
   }
}

