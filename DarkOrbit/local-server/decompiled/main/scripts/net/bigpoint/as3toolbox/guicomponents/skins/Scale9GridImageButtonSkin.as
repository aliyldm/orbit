package net.bigpoint.as3toolbox.guicomponents.skins
{
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.PropertyChangeEvent;
   import mx.states.AddItems;
   import mx.states.State;
   import net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImage;
   import net.bigpoint.as3toolbox.guicomponents.components.Scale9GridImageButton;
   import spark.components.supportClasses.Skin;
   
   public class Scale9GridImageButtonSkin extends Skin implements IStateClient2
   {
      
      private var _2054743953disabledImageSkinPart:Scale9GridImage;
      
      private var _599153673downImageSkinPart:Scale9GridImage;
      
      private var _66476777overImageSkinPart:Scale9GridImage;
      
      private var _484364624upImageSkinPart:Scale9GridImage;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _213507019hostComponent:Scale9GridImageButton;
      
      public function Scale9GridImageButtonSkin()
      {
         var _loc1_:DeferredInstanceFromFunction = null;
         var _loc2_:DeferredInstanceFromFunction = null;
         var _loc4_:DeferredInstanceFromFunction = null;
         super();
         mx_internal::_document = this;
         this.mxmlContent = [];
         this.currentState = "disabled";
         _loc1_ = new DeferredInstanceFromFunction(this._Scale9GridImageButtonSkin_Scale9GridImage1_i);
         _loc2_ = new DeferredInstanceFromFunction(this._Scale9GridImageButtonSkin_Scale9GridImage2_i);
         var _loc3_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._Scale9GridImageButtonSkin_Scale9GridImage3_i);
         _loc4_ = new DeferredInstanceFromFunction(this._Scale9GridImageButtonSkin_Scale9GridImage4_i);
         states = [new State({
            "name":"disabled",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc4_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            })]
         }),new State({
            "name":"down",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            })]
         }),new State({
            "name":"over",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc3_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            })]
         }),new State({
            "name":"up",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            })]
         })];
         _loc1_.getInstance();
         _loc2_.getInstance();
         _loc3_.getInstance();
         _loc4_.getInstance();
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
      
      private function _Scale9GridImageButtonSkin_Scale9GridImage1_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.id = "upImageSkinPart";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.upImageSkinPart = _loc1_;
         BindingManager.executeBindings(this,"upImageSkinPart",this.upImageSkinPart);
         return _loc1_;
      }
      
      private function _Scale9GridImageButtonSkin_Scale9GridImage2_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.id = "downImageSkinPart";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.downImageSkinPart = _loc1_;
         BindingManager.executeBindings(this,"downImageSkinPart",this.downImageSkinPart);
         return _loc1_;
      }
      
      private function _Scale9GridImageButtonSkin_Scale9GridImage3_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.id = "overImageSkinPart";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.overImageSkinPart = _loc1_;
         BindingManager.executeBindings(this,"overImageSkinPart",this.overImageSkinPart);
         return _loc1_;
      }
      
      private function _Scale9GridImageButtonSkin_Scale9GridImage4_i() : Scale9GridImage
      {
         var _loc1_:Scale9GridImage = new Scale9GridImage();
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.id = "disabledImageSkinPart";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.disabledImageSkinPart = _loc1_;
         BindingManager.executeBindings(this,"disabledImageSkinPart",this.disabledImageSkinPart);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get disabledImageSkinPart() : Scale9GridImage
      {
         return this._2054743953disabledImageSkinPart;
      }
      
      public function set disabledImageSkinPart(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._2054743953disabledImageSkinPart;
         if(_loc2_ !== param1)
         {
            this._2054743953disabledImageSkinPart = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disabledImageSkinPart",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get downImageSkinPart() : Scale9GridImage
      {
         return this._599153673downImageSkinPart;
      }
      
      public function set downImageSkinPart(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._599153673downImageSkinPart;
         if(_loc2_ !== param1)
         {
            this._599153673downImageSkinPart = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"downImageSkinPart",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get overImageSkinPart() : Scale9GridImage
      {
         return this._66476777overImageSkinPart;
      }
      
      public function set overImageSkinPart(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._66476777overImageSkinPart;
         if(_loc2_ !== param1)
         {
            this._66476777overImageSkinPart = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"overImageSkinPart",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get upImageSkinPart() : Scale9GridImage
      {
         return this._484364624upImageSkinPart;
      }
      
      public function set upImageSkinPart(param1:Scale9GridImage) : void
      {
         var _loc2_:Object = this._484364624upImageSkinPart;
         if(_loc2_ !== param1)
         {
            this._484364624upImageSkinPart = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"upImageSkinPart",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : Scale9GridImageButton
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:Scale9GridImageButton) : void
      {
         var _loc2_:Object = this._213507019hostComponent;
         if(_loc2_ !== param1)
         {
            this._213507019hostComponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostComponent",_loc2_,param1));
            }
         }
      }
   }
}

