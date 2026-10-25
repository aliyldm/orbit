package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.components
{
   import flash.events.Event;
   import mx.binding.BindingManager;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.renderers.ObjectivesListItemRenderer;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.skins.ObjectivesListSkin;
   import net.bigpoint.darkorbit.questfm.QuestTreeComponent;
   import spark.components.Group;
   import spark.components.Scroller;
   
   public class QuestObjectivesView extends QuestObjectivesBase
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1316591991objectiveList:ObjectivesList;
      
      private var _688450002objectiveListScrollerGroup:Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function QuestObjectivesView()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestObjectivesView_Array1_c);
         this.addEventListener("creationComplete",this.___QuestObjectivesView_QuestObjectivesBase1_creationComplete);
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
      
      override protected function creationCompleteHandler(param1:FlexEvent) : void
      {
         super.creationCompleteHandler(param1);
         this.objectiveList.addEventListener(QuestTreeComponent.SIZE_CHANGED,this.itemRendererSizeChangedHandler);
      }
      
      private function itemRendererSizeChangedHandler(param1:Event) : void
      {
      }
      
      private function _QuestObjectivesView_Array1_c() : Array
      {
         return [this._QuestObjectivesView_Scroller1_c()];
      }
      
      private function _QuestObjectivesView_Scroller1_c() : Scroller
      {
         var _loc1_:Scroller = new Scroller();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.styleName = "skinnedScroller";
         _loc1_.viewport = this._QuestObjectivesView_Group1_i();
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _QuestObjectivesView_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.mxmlContent = [this._QuestObjectivesView_ObjectivesList1_i()];
         _loc1_.id = "objectiveListScrollerGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.objectiveListScrollerGroup = _loc1_;
         BindingManager.executeBindings(this,"objectiveListScrollerGroup",this.objectiveListScrollerGroup);
         return _loc1_;
      }
      
      private function _QuestObjectivesView_ObjectivesList1_i() : ObjectivesList
      {
         var _loc1_:ObjectivesList = new ObjectivesList();
         _loc1_.itemRenderer = this._QuestObjectivesView_ClassFactory1_c();
         _loc1_.setStyle("skinClass",ObjectivesListSkin);
         _loc1_.id = "objectiveList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.objectiveList = _loc1_;
         BindingManager.executeBindings(this,"objectiveList",this.objectiveList);
         return _loc1_;
      }
      
      private function _QuestObjectivesView_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = ObjectivesListItemRenderer;
         return _loc1_;
      }
      
      public function ___QuestObjectivesView_QuestObjectivesBase1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get objectiveList() : ObjectivesList
      {
         return this._1316591991objectiveList;
      }
      
      public function set objectiveList(param1:ObjectivesList) : void
      {
         var _loc2_:Object = this._1316591991objectiveList;
         if(_loc2_ !== param1)
         {
            this._1316591991objectiveList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectiveList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get objectiveListScrollerGroup() : Group
      {
         return this._688450002objectiveListScrollerGroup;
      }
      
      public function set objectiveListScrollerGroup(param1:Group) : void
      {
         var _loc2_:Object = this._688450002objectiveListScrollerGroup;
         if(_loc2_ !== param1)
         {
            this._688450002objectiveListScrollerGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectiveListScrollerGroup",_loc2_,param1));
            }
         }
      }
   }
}

