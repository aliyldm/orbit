package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questRewards.components
{
   import flash.events.Event;
   import mx.binding.BindingManager;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questRewards.renderers.RewardsListItemRenderer;
   import spark.components.List;
   import spark.components.SkinnableContainer;
   
   public class QuestRewards extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _915835362rewardsList:List;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _rewardNameLabelMaxWidth:Number = 0;
      
      public function QuestRewards()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._QuestRewards_Array1_c);
         this.addEventListener("initialize",this.___QuestRewards_SkinnableContainer1_initialize);
         this.addEventListener("creationComplete",this.___QuestRewards_SkinnableContainer1_creationComplete);
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
      
      private function initializeHandler() : void
      {
         addEventListener(RewardsListItemRenderer.LAYOUT_CHANGED,this.layoutChangedHandler);
      }
      
      private function layoutChangedHandler(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:RewardsListItemRenderer = param1.target as RewardsListItemRenderer;
         if(_loc2_)
         {
            _loc3_ = _loc2_.rendererContent.rewardNameLabel.width;
            if(_loc3_ != this._rewardNameLabelMaxWidth)
            {
               this._rewardNameLabelMaxWidth = Math.max(this._rewardNameLabelMaxWidth,_loc3_);
               this.updateLayout();
            }
         }
      }
      
      private function updateLayout() : void
      {
         var _loc1_:int = 0;
         var _loc2_:RewardsListItemRenderer = null;
         if(Boolean(this.rewardsList) && Boolean(this.rewardsList.dataGroup))
         {
            _loc1_ = 0;
            while(_loc1_ != this.rewardsList.dataGroup.numElements)
            {
               _loc2_ = this.rewardsList.dataGroup.getElementAt(_loc1_) as RewardsListItemRenderer;
               if(_loc2_)
               {
                  _loc2_.rendererContent.rewardNameLabel.minWidth = this._rewardNameLabelMaxWidth;
                  _loc2_.rendererContent.rewardNameLabel.invalidateSize();
                  _loc2_.rendererContent.rewardNameLabel.invalidateDisplayList();
                  _loc2_.rendererContent.rewardNameLabel.invalidateLayoutDirection();
                  _loc2_.rendererContent.invalidateDisplayList();
                  _loc2_.rendererContent.invalidateSize();
                  _loc2_.rendererContent.invalidateLayoutDirection();
               }
               _loc1_++;
            }
         }
      }
      
      private function creationCompleteHandler() : void
      {
         this.rewardsList.scroller.verticalScrollBar.addEventListener(Event.CHANGE,this.listScrollHandler);
      }
      
      private function listScrollHandler(param1:Event) : void
      {
         this.updateLayout();
      }
      
      private function _QuestRewards_Array1_c() : Array
      {
         return [this._QuestRewards_List1_i()];
      }
      
      private function _QuestRewards_List1_i() : List
      {
         var _loc1_:List = new List();
         _loc1_.top = -2;
         _loc1_.bottom = -1;
         _loc1_.styleName = "skinnedList";
         _loc1_.itemRenderer = this._QuestRewards_ClassFactory1_c();
         _loc1_.left = 11;
         _loc1_.percentWidth = 100;
         _loc1_.setStyle("verticalScrollPolicy","auto");
         _loc1_.id = "rewardsList";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rewardsList = _loc1_;
         BindingManager.executeBindings(this,"rewardsList",this.rewardsList);
         return _loc1_;
      }
      
      private function _QuestRewards_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = RewardsListItemRenderer;
         return _loc1_;
      }
      
      public function ___QuestRewards_SkinnableContainer1_initialize(param1:FlexEvent) : void
      {
         this.initializeHandler();
      }
      
      public function ___QuestRewards_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.creationCompleteHandler();
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardsList() : List
      {
         return this._915835362rewardsList;
      }
      
      public function set rewardsList(param1:List) : void
      {
         var _loc2_:Object = this._915835362rewardsList;
         if(_loc2_ !== param1)
         {
            this._915835362rewardsList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardsList",_loc2_,param1));
            }
         }
      }
   }
}

