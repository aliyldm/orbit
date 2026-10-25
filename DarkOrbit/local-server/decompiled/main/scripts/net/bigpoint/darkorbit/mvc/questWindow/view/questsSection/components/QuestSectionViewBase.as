package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.components
{
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOButtonBase;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestListItemVO;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import net.bigpoint.darkorbit.questfm.Quest;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Image;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   public class QuestSectionViewBase extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1783346541questDesc:Label;
      
      private var _1431956846questDescScrollerGroup:spark.components.Group;
      
      private var _565728918questTitle:Label;
      
      private var _1480909402acceptButton:DOButtonBase;
      
      private var _363785598abortButton:DOButtonBase;
      
      private var _681244486objectivesLabel:Label;
      
      private var _1674129872rewardsLabel:Label;
      
      private var _1419500450questSubTypeIcons:HGroup;
      
      public var currentlyDisplayedQuestID:int;
      
      public var currentlyDisplayedRootCaseID:int;
      
      public var currentlyDisplayedQuestActiveStatus:Boolean;
      
      public function QuestSectionViewBase()
      {
         super();
      }
      
      public function handleSectionCreationComplete() : void
      {
         this.acceptButton.label = BPLocale.getItem("btn_quest_accept");
         this.abortButton.label = BPLocale.getItem("label_close");
         this.objectivesLabel.text = BPLocale.getItem("label_overview");
         this.rewardsLabel.text = BPLocale.getItem("label_reward");
      }
      
      public function updateQuestSectionView(param1:Quest, param2:QuestListItemVO) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Bitmap = null;
         var _loc6_:Image = null;
         var _loc7_:String = null;
         this.currentlyDisplayedQuestID = param1.id;
         this.currentlyDisplayedRootCaseID = param1.getCase().id;
         this.currentlyDisplayedQuestActiveStatus = param2.getQuestActive();
         if(this.currentlyDisplayedQuestActiveStatus)
         {
            this.acceptButton.visible = false;
            this.abortButton.visible = true;
         }
         else
         {
            this.acceptButton.visible = true;
            this.abortButton.visible = false;
         }
         this.questSubTypeIcons.removeAllElements();
         if(param2.questSubTypeList != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param2.questSubTypeList.length)
            {
               _loc4_ = String(QuestProxy.questIconMap[param2.questSubTypeList[_loc3_].icon]);
               _loc5_ = ResourceManager.getBitmap("questWin",_loc4_ + "_framed");
               _loc6_ = new Image();
               _loc6_.source = _loc5_;
               this.questSubTypeIcons.addElement(_loc6_);
               _loc7_ = QuestProxy.questIconTooltipMap[param2.questSubTypeList[_loc3_].icon];
               if(_loc7_)
               {
                  _loc6_.toolTip = BPLocale.getItem(_loc7_);
               }
               _loc3_++;
            }
         }
         this.updateQuestTitle(param1.title);
         this.updateQuestDescription(param1.description);
      }
      
      public function refreshQuestActiveStatus(param1:QuestListItemVO) : void
      {
         this.currentlyDisplayedQuestActiveStatus = param1.getQuestActive();
         if(this.currentlyDisplayedQuestActiveStatus)
         {
            this.acceptButton.visible = false;
            this.abortButton.visible = true;
         }
         else
         {
            this.acceptButton.visible = true;
            this.abortButton.visible = false;
         }
      }
      
      private function updateQuestTitle(param1:String) : void
      {
         this.questTitle.text = param1;
      }
      
      private function updateQuestDescription(param1:String) : void
      {
         this.questDescScrollerGroup.verticalScrollPosition = 0;
         this.questDesc.text = String(param1);
      }
      
      protected function handleAcceptQuestButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:QuestGiverWindowEvent = new QuestGiverWindowEvent(QuestGiverWindowEvent.ACCEPT_QUEST);
         _loc2_.questID = this.currentlyDisplayedQuestID;
         _loc2_.rootCaseID = this.currentlyDisplayedRootCaseID;
         dispatchEvent(_loc2_);
      }
      
      protected function handleAbortQuestButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:QuestGiverWindowEvent = new QuestGiverWindowEvent(QuestGiverWindowEvent.ABORT_QUEST);
         _loc2_.questID = this.currentlyDisplayedQuestID;
         _loc2_.rootCaseID = this.currentlyDisplayedRootCaseID;
         dispatchEvent(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function get questDesc() : Label
      {
         return this._1783346541questDesc;
      }
      
      public function set questDesc(param1:Label) : void
      {
         var _loc2_:Object = this._1783346541questDesc;
         if(_loc2_ !== param1)
         {
            this._1783346541questDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questDescScrollerGroup() : spark.components.Group
      {
         return this._1431956846questDescScrollerGroup;
      }
      
      public function set questDescScrollerGroup(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1431956846questDescScrollerGroup;
         if(_loc2_ !== param1)
         {
            this._1431956846questDescScrollerGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questDescScrollerGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questTitle() : Label
      {
         return this._565728918questTitle;
      }
      
      public function set questTitle(param1:Label) : void
      {
         var _loc2_:Object = this._565728918questTitle;
         if(_loc2_ !== param1)
         {
            this._565728918questTitle = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questTitle",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get acceptButton() : DOButtonBase
      {
         return this._1480909402acceptButton;
      }
      
      public function set acceptButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._1480909402acceptButton;
         if(_loc2_ !== param1)
         {
            this._1480909402acceptButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"acceptButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get abortButton() : DOButtonBase
      {
         return this._363785598abortButton;
      }
      
      public function set abortButton(param1:DOButtonBase) : void
      {
         var _loc2_:Object = this._363785598abortButton;
         if(_loc2_ !== param1)
         {
            this._363785598abortButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abortButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get objectivesLabel() : Label
      {
         return this._681244486objectivesLabel;
      }
      
      public function set objectivesLabel(param1:Label) : void
      {
         var _loc2_:Object = this._681244486objectivesLabel;
         if(_loc2_ !== param1)
         {
            this._681244486objectivesLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"objectivesLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardsLabel() : Label
      {
         return this._1674129872rewardsLabel;
      }
      
      public function set rewardsLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1674129872rewardsLabel;
         if(_loc2_ !== param1)
         {
            this._1674129872rewardsLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardsLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questSubTypeIcons() : HGroup
      {
         return this._1419500450questSubTypeIcons;
      }
      
      public function set questSubTypeIcons(param1:HGroup) : void
      {
         var _loc2_:Object = this._1419500450questSubTypeIcons;
         if(_loc2_ !== param1)
         {
            this._1419500450questSubTypeIcons = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questSubTypeIcons",_loc2_,param1));
            }
         }
      }
   }
}

