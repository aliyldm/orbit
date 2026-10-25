package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components
{
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import spark.components.BorderContainer;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.VGroup;
   
   public class PopUpWithInventoryFilter extends PopUpWithInventoryFilterBase
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _581456414popUpWithInventoryFilter:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function PopUpWithInventoryFilter()
      {
         super();
         mx_internal::_document = this;
         this.styleName = "battleStationPopup";
         this.width = 250;
         this.height = 220;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._PopUpWithInventoryFilter_Array1_c);
         this.addEventListener("creationComplete",this.___PopUpWithInventoryFilter_PopUpWithInventoryFilterBase1_creationComplete);
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
      
      private function _PopUpWithInventoryFilter_Array1_c() : Array
      {
         return [this._PopUpWithInventoryFilter_Group1_i()];
      }
      
      private function _PopUpWithInventoryFilter_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._PopUpWithInventoryFilter_VGroup1_c()];
         _loc1_.id = "popUpWithInventoryFilter";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.popUpWithInventoryFilter = _loc1_;
         BindingManager.executeBindings(this,"popUpWithInventoryFilter",this.popUpWithInventoryFilter);
         return _loc1_;
      }
      
      private function _PopUpWithInventoryFilter_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.horizontalCenter = 0;
         _loc1_.mxmlContent = [this._PopUpWithInventoryFilter_Label1_i(),this._PopUpWithInventoryFilter_BorderContainer1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithInventoryFilter_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.setStyle("paddingBottom",-3);
         _loc1_.id = "toogleLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         toogleLabel = _loc1_;
         BindingManager.executeBindings(this,"toogleLabel",toogleLabel);
         return _loc1_;
      }
      
      private function _PopUpWithInventoryFilter_BorderContainer1_c() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.width = 225;
         _loc1_.height = 144;
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._PopUpWithInventoryFilter_Array4_c);
         _loc1_.setStyle("borderColor",3884108);
         _loc1_.setStyle("backgroundColor",1448735);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _PopUpWithInventoryFilter_Array4_c() : Array
      {
         return [this._PopUpWithInventoryFilter_VGroup2_i()];
      }
      
      private function _PopUpWithInventoryFilter_VGroup2_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 0;
         _loc1_.top = 1;
         _loc1_.id = "optionsContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         optionsContainer = _loc1_;
         BindingManager.executeBindings(this,"optionsContainer",optionsContainer);
         return _loc1_;
      }
      
      public function ___PopUpWithInventoryFilter_PopUpWithInventoryFilterBase1_creationComplete(param1:FlexEvent) : void
      {
         creationCompleteHandler();
      }
      
      [Bindable(event="propertyChange")]
      public function get popUpWithInventoryFilter() : Group
      {
         return this._581456414popUpWithInventoryFilter;
      }
      
      public function set popUpWithInventoryFilter(param1:Group) : void
      {
         var _loc2_:Object = this._581456414popUpWithInventoryFilter;
         if(_loc2_ !== param1)
         {
            this._581456414popUpWithInventoryFilter = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"popUpWithInventoryFilter",_loc2_,param1));
            }
         }
      }
   }
}

