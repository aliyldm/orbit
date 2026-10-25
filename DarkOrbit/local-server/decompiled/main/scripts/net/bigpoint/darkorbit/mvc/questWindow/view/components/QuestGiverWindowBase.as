package net.bigpoint.darkorbit.mvc.questWindow.view.components
{
   import flash.display.MovieClip;
   import mx.collections.ArrayList;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOViewContainerBase;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.mvc.questWindow.view.QuestGiverWindowMediator;
   import net.bigpoint.darkorbit.mvc.questWindow.view.challengesSection.components.ChallengesSectionView;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.components.QuestSectionView;
   import net.bigpoint.darkorbit.questfm.Quest;
   import spark.components.Group;
   import spark.components.Image;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.TabBar;
   import spark.core.SpriteVisualElement;
   import spark.events.IndexChangeEvent;
   import spark.primitives.BitmapImage;
   
   public class QuestGiverWindowBase extends DOWindow
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      public var fullTabList:ArrayList;
      
      public var starterTabList:ArrayList;
      
      private var _1553853997tabList:ArrayList = new ArrayList();
      
      private var _1783104352questList:List;
      
      private var _957814533questGiverImageContainer:SpriteVisualElement;
      
      private var _2086100210questGiverPortraitNameText:BitmapImage;
      
      private var _1252008505noQuestListMessageContainer:DOViewContainerBase;
      
      private var _1432390988noQuestsMessageContainer:DOViewContainerBase;
      
      private var _1389530574noAvailableQuestsMessage:Label;
      
      private var _462786894noAvailableQuestsMessageDescription:Label;
      
      private var _561258129noAvailableQuestListMessage:Label;
      
      private var _1944353739questWindowQuestSection:QuestSectionView;
      
      private var _1540011261questWindowChallengesSection:ChallengesSectionView;
      
      private var _475505495mainTabBar:TabBar;
      
      private var _1872589050availableDesc:Image;
      
      private var _1909349631unavailableDesc:Image;
      
      private var _188173180completedDesc:Image;
      
      private var _1855550420questStateFilters:spark.components.Group;
      
      private var _1860051096notYetDoneDesc:Image;
      
      private var _1160643891doneDesc:Image;
      
      private var _1369159213challengeStateFilters:spark.components.Group;
      
      private var _portraitFrame:MovieClip;
      
      private var _portraitId:String;
      
      public function QuestGiverWindowBase()
      {
         super();
      }
      
      public function handleCreationComplete() : void
      {
         this._portraitFrame = ResourceManager.getMovieClip("questWin","questgiver_frame");
         this.questGiverImageContainer.addChild(this._portraitFrame);
         this.updatePortrait();
         title = BPLocale.getItem("title_questwin");
         this.fullTabList = new ArrayList([{"label":BPLocale.getItem("tab_questwin_missions")},{"label":BPLocale.getItem("tab_questwin_challenges")},{"label":BPLocale.getItem("tab_questwin_daily_missions")},{"label":BPLocale.getItem("tab_questwin_weekly_missions")},{"label":BPLocale.getItem("tab_questwin_event_missions")}]);
         this.starterTabList = new ArrayList([{"label":BPLocale.getItem("tab_questwin_starter_missions")}]);
         this.tabList = this.fullTabList;
         this.noAvailableQuestsMessage.text = BPLocale.getItem("title_questwin_no_quests_available");
         this.noAvailableQuestsMessageDescription.text = BPLocale.getItem("desc_questwin_no_quests_available_NYX");
         this.noAvailableQuestListMessage.text = BPLocale.getItem("label_questwin_no_quests_available");
         this.indexChangedHandler(new IndexChangeEvent(IndexChangeEvent.CHANGE,false,false,-1,0));
      }
      
      public function updatePortrait() : void
      {
         var _loc4_:String = null;
         if(this._portraitFrame == null)
         {
            return;
         }
         var _loc1_:Quest = QuestProxy(GameFacade.getInstance().retrieveProxy(QuestProxy.NAME)).selectedQuest;
         var _loc2_:Vector.<String> = new Vector.<String>();
         if(Boolean(_loc1_) && Boolean(_loc1_.portraitId))
         {
            _loc2_.push(_loc1_.portraitId);
            _loc2_.push(_loc1_.portraitId + "_" + Hero.factionName);
            _loc2_.push(InGameCatalog.getInstance().getQuestgiverPortrait(_loc1_.id));
         }
         else
         {
            _loc2_.push(InGameCatalog.getInstance().getQuestgiverPortrait());
         }
         var _loc3_:SWFFinisher = ResourceManager.fileCollection.getFinisher("questWin") as SWFFinisher;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc5_];
            if(_loc3_.hasEmbeddedObject(_loc4_))
            {
               break;
            }
            _loc5_++;
         }
         if(_loc4_ == this._portraitId)
         {
            return;
         }
         this._portraitId = _loc4_;
         while(this._portraitFrame.content.numChildren)
         {
            this._portraitFrame.content.removeChildAt(0);
         }
         if(_loc3_.hasEmbeddedObject(_loc4_))
         {
            this._portraitFrame.content.addChild(_loc3_.getEmbeddedMovieClip(_loc4_));
         }
         if(_loc4_ == "nyx_portrait")
         {
            this.questGiverPortraitNameText.source = ResourceManager.getBitmap("questWin","nyx_name_label_fancy");
         }
         else
         {
            this.questGiverPortraitNameText.source = null;
         }
      }
      
      public function setQuestAvailableStatus(param1:Boolean) : void
      {
         this.noQuestListMessageContainer.visible = param1;
         this.noQuestsMessageContainer.visible = param1;
      }
      
      public function init(param1:ArrayList) : void
      {
         this.questList.dataProvider = param1;
      }
      
      public function getQuestDataFromServer(param1:int) : void
      {
      }
      
      public function processIncomingQuestData(param1:int) : void
      {
      }
      
      public function acceptSelectedQuest(param1:int) : void
      {
      }
      
      public function startSelectedChallenge(param1:int) : void
      {
      }
      
      protected function indexChangedHandler(param1:IndexChangeEvent) : void
      {
         if(param1.newIndex == QuestGiverWindowMediator.TAB_MISSIONS || param1.newIndex == QuestGiverWindowMediator.TAB_EVENT_MISSIONS)
         {
            this.questWindowQuestSection.questsLeft.visible = true;
         }
         else
         {
            this.questWindowQuestSection.questsLeft.visible = false;
         }
         if(param1.newIndex == QuestGiverWindowMediator.TAB_CHALLENGES)
         {
            this.questStateFilters.visible = false;
            this.challengeStateFilters.visible = true;
         }
         else
         {
            this.questStateFilters.visible = true;
            this.challengeStateFilters.visible = false;
         }
         if(param1.newIndex == QuestGiverWindowMediator.TAB_EVENT_MISSIONS)
         {
            this.noAvailableQuestsMessageDescription.text = BPLocale.getItem("desc_questwin_no_event_quests_available_NYX");
         }
         else if(param1.newIndex == QuestGiverWindowMediator.TAB_WEEKLY_MISSIONS)
         {
            this.noAvailableQuestsMessageDescription.text = BPLocale.getItem("desc_questwin_no_weekly_event_quests_available_NYX");
         }
         else
         {
            this.noAvailableQuestsMessageDescription.text = BPLocale.getItem("desc_questwin_no_quests_available_NYX");
         }
         if(param1.oldIndex == param1.newIndex)
         {
            return;
         }
         dispatchEvent(new QuestGiverWindowEvent(QuestGiverWindowEvent.TAB_CHANGED,param1.newIndex,true));
      }
      
      [Bindable(event="propertyChange")]
      public function get tabList() : ArrayList
      {
         return this._1553853997tabList;
      }
      
      public function set tabList(param1:ArrayList) : void
      {
         var _loc2_:Object = this._1553853997tabList;
         if(_loc2_ !== param1)
         {
            this._1553853997tabList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tabList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questList() : List
      {
         return this._1783104352questList;
      }
      
      public function set questList(param1:List) : void
      {
         var _loc2_:Object = this._1783104352questList;
         if(_loc2_ !== param1)
         {
            this._1783104352questList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questGiverImageContainer() : SpriteVisualElement
      {
         return this._957814533questGiverImageContainer;
      }
      
      public function set questGiverImageContainer(param1:SpriteVisualElement) : void
      {
         var _loc2_:Object = this._957814533questGiverImageContainer;
         if(_loc2_ !== param1)
         {
            this._957814533questGiverImageContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questGiverImageContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questGiverPortraitNameText() : BitmapImage
      {
         return this._2086100210questGiverPortraitNameText;
      }
      
      public function set questGiverPortraitNameText(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._2086100210questGiverPortraitNameText;
         if(_loc2_ !== param1)
         {
            this._2086100210questGiverPortraitNameText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questGiverPortraitNameText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get noQuestListMessageContainer() : DOViewContainerBase
      {
         return this._1252008505noQuestListMessageContainer;
      }
      
      public function set noQuestListMessageContainer(param1:DOViewContainerBase) : void
      {
         var _loc2_:Object = this._1252008505noQuestListMessageContainer;
         if(_loc2_ !== param1)
         {
            this._1252008505noQuestListMessageContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"noQuestListMessageContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get noQuestsMessageContainer() : DOViewContainerBase
      {
         return this._1432390988noQuestsMessageContainer;
      }
      
      public function set noQuestsMessageContainer(param1:DOViewContainerBase) : void
      {
         var _loc2_:Object = this._1432390988noQuestsMessageContainer;
         if(_loc2_ !== param1)
         {
            this._1432390988noQuestsMessageContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"noQuestsMessageContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get noAvailableQuestsMessage() : Label
      {
         return this._1389530574noAvailableQuestsMessage;
      }
      
      public function set noAvailableQuestsMessage(param1:Label) : void
      {
         var _loc2_:Object = this._1389530574noAvailableQuestsMessage;
         if(_loc2_ !== param1)
         {
            this._1389530574noAvailableQuestsMessage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"noAvailableQuestsMessage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get noAvailableQuestsMessageDescription() : Label
      {
         return this._462786894noAvailableQuestsMessageDescription;
      }
      
      public function set noAvailableQuestsMessageDescription(param1:Label) : void
      {
         var _loc2_:Object = this._462786894noAvailableQuestsMessageDescription;
         if(_loc2_ !== param1)
         {
            this._462786894noAvailableQuestsMessageDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"noAvailableQuestsMessageDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get noAvailableQuestListMessage() : Label
      {
         return this._561258129noAvailableQuestListMessage;
      }
      
      public function set noAvailableQuestListMessage(param1:Label) : void
      {
         var _loc2_:Object = this._561258129noAvailableQuestListMessage;
         if(_loc2_ !== param1)
         {
            this._561258129noAvailableQuestListMessage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"noAvailableQuestListMessage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questWindowQuestSection() : QuestSectionView
      {
         return this._1944353739questWindowQuestSection;
      }
      
      public function set questWindowQuestSection(param1:QuestSectionView) : void
      {
         var _loc2_:Object = this._1944353739questWindowQuestSection;
         if(_loc2_ !== param1)
         {
            this._1944353739questWindowQuestSection = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questWindowQuestSection",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questWindowChallengesSection() : ChallengesSectionView
      {
         return this._1540011261questWindowChallengesSection;
      }
      
      public function set questWindowChallengesSection(param1:ChallengesSectionView) : void
      {
         var _loc2_:Object = this._1540011261questWindowChallengesSection;
         if(_loc2_ !== param1)
         {
            this._1540011261questWindowChallengesSection = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questWindowChallengesSection",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainTabBar() : TabBar
      {
         return this._475505495mainTabBar;
      }
      
      public function set mainTabBar(param1:TabBar) : void
      {
         var _loc2_:Object = this._475505495mainTabBar;
         if(_loc2_ !== param1)
         {
            this._475505495mainTabBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainTabBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get availableDesc() : Image
      {
         return this._1872589050availableDesc;
      }
      
      public function set availableDesc(param1:Image) : void
      {
         var _loc2_:Object = this._1872589050availableDesc;
         if(_loc2_ !== param1)
         {
            this._1872589050availableDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get unavailableDesc() : Image
      {
         return this._1909349631unavailableDesc;
      }
      
      public function set unavailableDesc(param1:Image) : void
      {
         var _loc2_:Object = this._1909349631unavailableDesc;
         if(_loc2_ !== param1)
         {
            this._1909349631unavailableDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unavailableDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get completedDesc() : Image
      {
         return this._188173180completedDesc;
      }
      
      public function set completedDesc(param1:Image) : void
      {
         var _loc2_:Object = this._188173180completedDesc;
         if(_loc2_ !== param1)
         {
            this._188173180completedDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"completedDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questStateFilters() : spark.components.Group
      {
         return this._1855550420questStateFilters;
      }
      
      public function set questStateFilters(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1855550420questStateFilters;
         if(_loc2_ !== param1)
         {
            this._1855550420questStateFilters = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questStateFilters",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get notYetDoneDesc() : Image
      {
         return this._1860051096notYetDoneDesc;
      }
      
      public function set notYetDoneDesc(param1:Image) : void
      {
         var _loc2_:Object = this._1860051096notYetDoneDesc;
         if(_loc2_ !== param1)
         {
            this._1860051096notYetDoneDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"notYetDoneDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get doneDesc() : Image
      {
         return this._1160643891doneDesc;
      }
      
      public function set doneDesc(param1:Image) : void
      {
         var _loc2_:Object = this._1160643891doneDesc;
         if(_loc2_ !== param1)
         {
            this._1160643891doneDesc = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"doneDesc",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get challengeStateFilters() : spark.components.Group
      {
         return this._1369159213challengeStateFilters;
      }
      
      public function set challengeStateFilters(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1369159213challengeStateFilters;
         if(_loc2_ !== param1)
         {
            this._1369159213challengeStateFilters = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"challengeStateFilters",_loc2_,param1));
            }
         }
      }
   }
}

