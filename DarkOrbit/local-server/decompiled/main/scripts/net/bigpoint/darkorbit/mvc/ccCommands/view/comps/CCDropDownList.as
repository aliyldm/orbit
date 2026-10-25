package net.bigpoint.darkorbit.mvc.ccCommands.view.comps
{
   import mx.core.ClassFactory;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.com.module.CCValueModule;
   import spark.components.DropDownList;
   import spark.layouts.VerticalLayout;
   
   public class CCDropDownList extends DropDownList
   {
      
      private static var _skinParts:Object = {
         "dropDown":false,
         "dataGroup":false,
         "dropIndicator":false,
         "labelDisplay":false,
         "scroller":false,
         "openButton":true
      };
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function CCDropDownList()
      {
         super();
         this.itemRenderer = this._CCDropDownList_ClassFactory1_c();
         this.labelFunction = this.itemToLabel;
         this.minWidth = 200;
         this.percentWidth = 100;
         this.layout = this._CCDropDownList_VerticalLayout1_c();
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
      
      override public function itemToLabel(param1:Object) : String
      {
         return CCModuleTranslater.moduleToString(param1 as CCValueModule);
      }
      
      private function _CCDropDownList_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = CCValueModuleRenderer;
         return _loc1_;
      }
      
      private function _CCDropDownList_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.requestedMaxRowCount = 50;
         _loc1_.requestedRowCount = 30;
         _loc1_.useVirtualLayout = false;
         return _loc1_;
      }
   }
}

