package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.renderers
{
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   import spark.components.supportClasses.ItemRenderer;
   
   public class ModuleInventoryGridItemRenderer extends ItemRenderer
   {
      
      private var _784343010moduleItemComponent:ModuleItem;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _data:ModuleVO;
      
      private var _newData:Boolean = true;
      
      public function ModuleInventoryGridItemRenderer()
      {
         super();
         mx_internal::_document = this;
         this.width = 32;
         this.height = 32;
         this.mxmlContent = [this._ModuleInventoryGridItemRenderer_ModuleItem1_i()];
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
         super.data = param1;
         if(param1 != this._data)
         {
            this._newData = true;
            this._data = param1 as ModuleVO;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this._newData)
         {
            this._newData = false;
            this.moduleItemComponent.moduleVO = this._data;
            this.moduleItemComponent.moduleType = this._data.type;
         }
      }
      
      private function _ModuleInventoryGridItemRenderer_ModuleItem1_i() : ModuleItem
      {
         var _loc1_:ModuleItem = new ModuleItem();
         _loc1_.verticalCenter = 0;
         _loc1_.horizontalCenter = 0;
         _loc1_.id = "moduleItemComponent";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.moduleItemComponent = _loc1_;
         BindingManager.executeBindings(this,"moduleItemComponent",this.moduleItemComponent);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get moduleItemComponent() : ModuleItem
      {
         return this._784343010moduleItemComponent;
      }
      
      public function set moduleItemComponent(param1:ModuleItem) : void
      {
         var _loc2_:Object = this._784343010moduleItemComponent;
         if(_loc2_ !== param1)
         {
            this._784343010moduleItemComponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"moduleItemComponent",_loc2_,param1));
            }
         }
      }
   }
}

