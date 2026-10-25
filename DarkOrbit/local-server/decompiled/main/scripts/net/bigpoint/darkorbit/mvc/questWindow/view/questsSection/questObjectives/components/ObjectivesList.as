package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.components
{
   import mx.core.IFlexModuleFactory;
   import spark.components.SkinnableDataContainer;
   import spark.layouts.VerticalLayout;
   
   public class ObjectivesList extends SkinnableDataContainer
   {
      
      private static var _skinParts:Object = {"dataGroup":false};
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function ObjectivesList()
      {
         super();
         this.layout = this._ObjectivesList_VerticalLayout1_c();
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
      
      private function _ObjectivesList_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.useVirtualLayout = false;
         _loc1_.variableRowHeight = true;
         _loc1_.paddingTop = 0;
         _loc1_.paddingBottom = 0;
         return _loc1_;
      }
   }
}

