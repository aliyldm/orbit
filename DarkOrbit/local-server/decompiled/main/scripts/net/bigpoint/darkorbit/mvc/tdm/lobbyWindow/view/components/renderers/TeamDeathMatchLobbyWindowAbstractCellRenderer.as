package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components.renderers
{
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchOverviewModule;
   import net.bigpoint.darkorbit.mvc.common.view.components.MultilineMxLabel;
   import spark.components.VGroup;
   import spark.components.gridClasses.GridItemRenderer;
   
   public class TeamDeathMatchLobbyWindowAbstractCellRenderer extends GridItemRenderer
   {
      
      private var _1095790365columnLabelContainer:VGroup;
      
      private var _25619770rowLabel:MultilineMxLabel;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function TeamDeathMatchLobbyWindowAbstractCellRenderer()
      {
         super();
         mx_internal::_document = this;
         this.clipAndEnableScrolling = true;
         this.percentWidth = 100;
         this.mxmlContent = [this._TeamDeathMatchLobbyWindowAbstractCellRenderer_VGroup1_i()];
         this.addEventListener("creationComplete",this.___TeamDeathMatchLobbyWindowAbstractCellRenderer_GridItemRenderer1_creationComplete);
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
      
      protected function creationCompleteHandler(param1:FlexEvent) : void
      {
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
      }
      
      protected function get vo() : TeamDeathMatchOverviewModule
      {
         return data as TeamDeathMatchOverviewModule;
      }
      
      override public function set mxmlContent(param1:Array) : void
      {
         var _loc4_:IVisualElement = null;
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc2_)
         {
            _loc4_ = null;
            try
            {
               _loc4_ = super.getElementAt(_loc3_);
            }
            catch(e:Error)
            {
            }
            if(_loc4_ != null)
            {
               param1.push(_loc4_);
               _loc3_ += 1;
            }
            else
            {
               _loc2_ = false;
            }
         }
         param1.reverse();
         super.mxmlContent = param1;
      }
      
      private function _TeamDeathMatchLobbyWindowAbstractCellRenderer_VGroup1_i() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.height = 24;
         _loc1_.percentWidth = 100;
         _loc1_.verticalCenter = -1;
         _loc1_.verticalAlign = "middle";
         _loc1_.mxmlContent = [this._TeamDeathMatchLobbyWindowAbstractCellRenderer_MultilineMxLabel1_i()];
         _loc1_.id = "columnLabelContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.columnLabelContainer = _loc1_;
         BindingManager.executeBindings(this,"columnLabelContainer",this.columnLabelContainer);
         return _loc1_;
      }
      
      private function _TeamDeathMatchLobbyWindowAbstractCellRenderer_MultilineMxLabel1_i() : MultilineMxLabel
      {
         var _loc1_:MultilineMxLabel = new MultilineMxLabel();
         _loc1_.percentWidth = 100;
         _loc1_.text = ".";
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileTNoneCFF");
         _loc1_.id = "rowLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rowLabel = _loc1_;
         BindingManager.executeBindings(this,"rowLabel",this.rowLabel);
         return _loc1_;
      }
      
      public function ___TeamDeathMatchLobbyWindowAbstractCellRenderer_GridItemRenderer1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get columnLabelContainer() : VGroup
      {
         return this._1095790365columnLabelContainer;
      }
      
      public function set columnLabelContainer(param1:VGroup) : void
      {
         var _loc2_:Object = this._1095790365columnLabelContainer;
         if(_loc2_ !== param1)
         {
            this._1095790365columnLabelContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnLabelContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rowLabel() : MultilineMxLabel
      {
         return this._25619770rowLabel;
      }
      
      public function set rowLabel(param1:MultilineMxLabel) : void
      {
         var _loc2_:Object = this._25619770rowLabel;
         if(_loc2_ !== param1)
         {
            this._25619770rowLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowLabel",_loc2_,param1));
            }
         }
      }
   }
}

