package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.components
{
   import flash.events.MouseEvent;
   import mx.binding.BindingManager;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.DragEvent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.renderers.ModuleInventoryGridItemRenderer;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.skins.ModuleInventoryGridSkin;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOButtonBaseSkin;
   import spark.components.BorderContainer;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.Scroller;
   import spark.components.VGroup;
   import spark.layouts.HorizontalLayout;
   
   public class ModuleInventoryView extends ModuleInventoryViewBase
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1891143702filterBtnActive:DOButtonBase;
      
      private var _1507938869filterBtnNormal:DOButtonBase;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function ModuleInventoryView()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._ModuleInventoryView_Array1_c);
         this.addEventListener("creationComplete",this.___ModuleInventoryView_ModuleInventoryViewBase1_creationComplete);
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
      
      private function _ModuleInventoryView_Array1_c() : Array
      {
         return [this._ModuleInventoryView_VGroup1_c()];
      }
      
      private function _ModuleInventoryView_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.mxmlContent = [this._ModuleInventoryView_HGroup1_c(),this._ModuleInventoryView_BorderContainer1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInventoryView_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.verticalAlign = "bottom";
         _loc1_.paddingTop = -3;
         _loc1_.paddingBottom = -2;
         _loc1_.mxmlContent = [this._ModuleInventoryView_Label1_i(),this._ModuleInventoryView_Group1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInventoryView_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 202;
         _loc1_.setStyle("fontSize",13);
         _loc1_.setStyle("fontFamily","EurostileTHea");
         _loc1_.setStyle("color",16763904);
         _loc1_.setStyle("paddingBottom",-2);
         _loc1_.id = "titleLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         titleLabel = _loc1_;
         BindingManager.executeBindings(this,"titleLabel",titleLabel);
         return _loc1_;
      }
      
      private function _ModuleInventoryView_Group1_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.mxmlContent = [this._ModuleInventoryView_DOButtonBase1_i(),this._ModuleInventoryView_DOButtonBase2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInventoryView_DOButtonBase1_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 15;
         _loc1_.height = 15;
         _loc1_.styleName = "downArrowButtonNormal";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__filterBtnNormal_click);
         _loc1_.id = "filterBtnNormal";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.filterBtnNormal = _loc1_;
         BindingManager.executeBindings(this,"filterBtnNormal",this.filterBtnNormal);
         return _loc1_;
      }
      
      public function __filterBtnNormal_click(param1:MouseEvent) : void
      {
         showInventoryPopupHandler(param1);
      }
      
      private function _ModuleInventoryView_DOButtonBase2_i() : DOButtonBase
      {
         var _loc1_:DOButtonBase = new DOButtonBase();
         _loc1_.width = 15;
         _loc1_.height = 15;
         _loc1_.visible = false;
         _loc1_.styleName = "downArrowButtonActive";
         _loc1_.mouseChildren = false;
         _loc1_.buttonMode = true;
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("skinClass",DOButtonBaseSkin);
         _loc1_.addEventListener("click",this.__filterBtnActive_click);
         _loc1_.id = "filterBtnActive";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.filterBtnActive = _loc1_;
         BindingManager.executeBindings(this,"filterBtnActive",this.filterBtnActive);
         return _loc1_;
      }
      
      public function __filterBtnActive_click(param1:MouseEvent) : void
      {
         showInventoryPopupHandler(param1);
      }
      
      private function _ModuleInventoryView_BorderContainer1_c() : BorderContainer
      {
         var _loc1_:BorderContainer = new BorderContainer();
         _loc1_.width = 225;
         _loc1_.height = 106;
         _loc1_.layout = this._ModuleInventoryView_HorizontalLayout1_c();
         _loc1_.mxmlContentFactory = new DeferredInstanceFromFunction(this._ModuleInventoryView_Array5_c);
         _loc1_.setStyle("borderColor",3884108);
         _loc1_.setStyle("backgroundColor",1448735);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInventoryView_HorizontalLayout1_c() : HorizontalLayout
      {
         var _loc1_:HorizontalLayout = new HorizontalLayout();
         _loc1_.paddingLeft = 2;
         _loc1_.paddingRight = 1;
         _loc1_.paddingTop = 2;
         _loc1_.paddingBottom = 2;
         return _loc1_;
      }
      
      private function _ModuleInventoryView_Array5_c() : Array
      {
         return [this._ModuleInventoryView_Scroller1_c()];
      }
      
      private function _ModuleInventoryView_Scroller1_c() : Scroller
      {
         var _loc1_:Scroller = new Scroller();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.styleName = "skinnedScroller";
         _loc1_.viewport = this._ModuleInventoryView_Group2_c();
         _loc1_.setStyle("horizontalScrollPolicy","off");
         _loc1_.setStyle("verticalScrollPolicy","on");
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInventoryView_Group2_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.top = -1;
         _loc1_.bottom = -1;
         _loc1_.mxmlContent = [this._ModuleInventoryView_List1_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _ModuleInventoryView_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.itemRenderer = this._ModuleInventoryView_ClassFactory1_c();
         _loc1_.allowMultipleSelection = false;
         _loc1_.dragEnabled = true;
         _loc1_.setStyle("skinClass",ModuleInventoryGridSkin);
         _loc1_.addEventListener("dragStart",this.__moduleItemList_dragStart);
         _loc1_.addEventListener("click",this.__moduleItemList_click);
         _loc1_.id = "moduleItemList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         moduleItemList = _loc1_;
         BindingManager.executeBindings(this,"moduleItemList",moduleItemList);
         return _loc1_;
      }
      
      private function _ModuleInventoryView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ModuleInventoryGridItemRenderer;
         return _loc1_;
      }
      
      public function __moduleItemList_dragStart(param1:DragEvent) : void
      {
         handleStartDrag(param1);
      }
      
      public function __moduleItemList_click(param1:MouseEvent) : void
      {
         handleItemClicked(param1);
      }
      
      public function ___ModuleInventoryView_ModuleInventoryViewBase1_creationComplete(param1:FlexEvent) : void
      {
         creationCompleteHandler();
      }
      
      [Bindable(event="propertyChange")]
      public function get filterBtnActive() : DOButtonBase
      {
         return this._1891143702filterBtnActive;
      }
      
      public function set filterBtnActive(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1891143702filterBtnActive;
         if(_loc2_ !== param1)
         {
            this._1891143702filterBtnActive = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filterBtnActive",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get filterBtnNormal() : DOButtonBase
      {
         return this._1507938869filterBtnNormal;
      }
      
      public function set filterBtnNormal(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1507938869filterBtnNormal;
         if(_loc2_ !== param1)
         {
            this._1507938869filterBtnNormal = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filterBtnNormal",_loc2_,param1));
            }
         }
      }
   }
}

