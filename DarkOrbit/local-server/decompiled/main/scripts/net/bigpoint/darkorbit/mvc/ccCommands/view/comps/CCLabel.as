package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
{
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import spark.components.Label;
   
   public class CCLabel extends CCAbstractComponent
   {
      
      private var _1055687225textLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function CCLabel()
      {
         super();
         mx_internal::_document = this;
         this._CCLabel_Label1_i();
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
      
      override public function set data(param1:Object) : void
      {
         group.addElement(this.textLabel);
         super.data = param1;
         this.textLabel.text = _data.name;
      }
      
      override public function get currentData() : CCValueModule
      {
         return new CCValueModule(_data.name);
      }
      
      private function _CCLabel_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("fontSize",16);
         _loc1_.id = "textLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.textLabel = _loc1_;
         BindingManager.executeBindings(this,"textLabel",this.textLabel);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get textLabel() : Label
      {
         return this._1055687225textLabel;
      }
      
      public function set textLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1055687225textLabel;
         if(_loc2_ !== param1)
         {
            this._1055687225textLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textLabel",_loc2_,param1));
            }
         }
      }
   }
}

