package net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups
{
   import flash.events.MouseEvent;
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOPopUp;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   
   public class PopUpWithActivationButton extends DOPopUp
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _1880218107activateButton:DOButtonBase;
      
      private var _1990131276cancelButton:DOButtonBase;
      
      private var _1094898053popupTextLabel:Label;
      
      private var _143441987priceFieldLabel:Label;
      
      private var _260652293topLevelLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public var moduleType:int;
      
      public var itemId:int;
      
      public var slotId:int;
      
      public var moduleItem:ModuleItem;
      
      public function PopUpWithActivationButton()
      {
         super();
         mx_internal::_document = this;
         this.styleName = "battleStationPopup";
         this.title = "Do that.";
         this.minHeight = 225;
         this.minWidth = 146;
         this.width = 245;
         this.height = 215;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._PopUpWithActivationButton_Array1_c);
         this.addEventListener("creationComplete",this.___PopUpWithActivationButton_DOPopUp1_creationComplete);
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
      
      public function setPopupText(param1:String, param2:String) : void
      {
         this.popupTextLabel.text = param1;
         this.topLevelLabel.text = param2;
      }
      
      public function setRepairPrice(param1:String) : void
      {
         this.priceFieldLabel.text = param1;
      }
      
      public function setButtonText(param1:String) : void
      {
         this.activateButton.label = param1;
      }
      
      private function handleActivateButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:BattleStationWindowEvent = new BattleStationWindowEvent(BattleStationWindowEvent.ACTIVATE_BUTTON_CLICKED);
         _loc2_.itemId = this.itemId;
         _loc2_.slotId = this.slotId;
         _loc2_.moduleItem = this.moduleItem;
         dispatchEvent(_loc2_);
         handleCloseButtonClick(null);
      }
      
      private function handleCancelButtonClick(param1:MouseEvent) : void
      {
         handleCloseButtonClick(null);
      }
      
      private function handleComponentReady() : void
      {
         this.activateButton.label = BPLocale.getItem("popup_bswin_activation_btn_repair_module");
         this.cancelButton.label = BPLocale.getItem("popup_bswin_btn_cancel_module_removal");
      }
      
      private function _PopUpWithActivationButton_Array1_c() : Array
      {
         return [this._PopUpWithActivationButton_Group1_c(),this._PopUpWithActivationButton_Group2_c()];
      }
      
      private function _PopUpWithActivationButton_Group1_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.horizontalCenter = 0;
         _loc1_.width = 225;
         _loc1_.top = -5;
         _loc1_.mxmlContent = [this._PopUpWithActivationButton_Label1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithActivationButton_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.id = "topLevelLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.topLevelLabel = _loc1_;
         BindingManager.executeBindings(this,"topLevelLabel",this.topLevelLabel);
         return _loc1_;
      }
      
      private function _PopUpWithActivationButton_Group2_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.width = 225;
         _loc1_.height = 146;
         _loc1_.mxmlContent = [this._PopUpWithActivationButton_SkinnableContainer1_c(),this._PopUpWithActivationButton_Label2_i(),this._PopUpWithActivationButton_Label3_i(),this._PopUpWithActivationButton_VGroup1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithActivationButton_SkinnableContainer1_c() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "emergencyRepairBackground";
         _loc1_.width = 225;
         _loc1_.height = 146;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithActivationButton_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "";
         _loc1_.horizontalCenter = 0;
         _loc1_.percentWidth = 90;
         _loc1_.percentHeight = 100;
         _loc1_.top = 20;
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",14998949);
         _loc1_.id = "popupTextLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.popupTextLabel = _loc1_;
         BindingManager.executeBindings(this,"popupTextLabel",this.popupTextLabel);
         return _loc1_;
      }
      
      private function _PopUpWithActivationButton_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.text = "-";
         _loc1_.horizontalCenter = 0;
         _loc1_.percentHeight = 100;
         _loc1_.top = 58;
         _loc1_.setStyle("fontSize",11);
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.setStyle("color",16777215);
         _loc1_.id = "priceFieldLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.priceFieldLabel = _loc1_;
         BindingManager.executeBindings(this,"priceFieldLabel",this.priceFieldLabel);
         return _loc1_;
      }
      
      private function _PopUpWithActivationButton_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.bottom = 4;
         _loc1_.percentWidth = 95;
         _loc1_.horizontalCenter = 0;
         _loc1_.gap = 1;
         _loc1_.mxmlContent = [this._PopUpWithActivationButton_DOButtonBase1_i(),this._PopUpWithActivationButton_DOButtonBase2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithActivationButton_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.label = "";
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "scalableGreenConfirmButton";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("fontSize",14);
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__activateButton_click);
         _loc1_.id = "activateButton";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.activateButton = _loc1_;
         BindingManager.executeBindings(this,"activateButton",this.activateButton);
         return _loc1_;
      }
      
      public function __activateButton_click(param1:MouseEvent) : void
      {
         this.handleActivateButtonClick(param1);
      }
      
      private function _PopUpWithActivationButton_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.label = "";
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "scalableBlueCancelButton";
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
         this.handleCancelButtonClick(param1);
      }
      
      public function ___PopUpWithActivationButton_DOPopUp1_creationComplete(param1:FlexEvent) : void
      {
         this.handleComponentReady();
      }
      
      [Bindable(event="propertyChange")]
      public function get activateButton() : DOButtonBase
      {
         return this._1880218107activateButton;
      }
      
      public function set activateButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1880218107activateButton;
         if(_loc2_ !== param1)
         {
            this._1880218107activateButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"activateButton",_loc2_,param1));
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
      public function get priceFieldLabel() : Label
      {
         return this._143441987priceFieldLabel;
      }
      
      public function set priceFieldLabel(param1:Label) : void
      {
         var _loc2_:Object = this._143441987priceFieldLabel;
         if(_loc2_ !== param1)
         {
            this._143441987priceFieldLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"priceFieldLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get topLevelLabel() : Label
      {
         return this._260652293topLevelLabel;
      }
      
      public function set topLevelLabel(param1:Label) : void
      {
         var _loc2_:Object = this._260652293topLevelLabel;
         if(_loc2_ !== param1)
         {
            this._260652293topLevelLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topLevelLabel",_loc2_,param1));
            }
         }
      }
   }
}

