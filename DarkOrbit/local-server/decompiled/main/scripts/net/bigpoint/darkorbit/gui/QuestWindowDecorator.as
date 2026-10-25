package net.bigpoint.darkorbit.gui
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.events.QuestTabEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.questfm.QuestDotList;
   import net.bigpoint.darkorbit.questfm.QuestTreeContainer;
   import net.bigpoint.darkorbit.questfm.rewardsList.QuestRewardsListContainer;
   
   public class QuestWindowDecorator
   {
      
      private var _window:SimpleWindow;
      
      private var guiManager:GuiManager;
      
      private var uiResources:SWFFinisher;
      
      private var _noQuestInProgress:Boolean;
      
      private var questTabButtons:Dictionary = new Dictionary();
      
      private var questTabPages:Dictionary = new Dictionary();
      
      private var _selectedTabId:int;
      
      private var _aborting:Boolean;
      
      public function QuestWindowDecorator(param1:GuiManager, param2:SimpleWindow)
      {
         super();
         this._window = param2;
         this.guiManager = param1;
         this.uiResources = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.prepareWindow();
      }
      
      private function prepareWindow() : void
      {
         var _loc4_:QuestDotList = null;
         var _loc5_:SimpleContainer = null;
         var _loc1_:int = 8;
         var _loc2_:int = 35;
         var _loc3_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_QUEST_TABS);
         this.createTabButton(ButtonElementTypes.TYPE_QUEST_TAB_INFO,_loc3_,"label_description",false);
         this.createTabButton(ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW,_loc3_,"label_overview",true);
         this.createTabButton(ButtonElementTypes.TYPE_QUEST_TAB_REWARD,_loc3_,"label_reward",false);
         this.createTabLine(_loc3_);
         this._window.addContainer(_loc3_);
         _loc3_.addPredefinedPosition(new Point(_loc1_,_loc2_));
         _loc3_.setPredefinedPosition();
         _loc2_ += _loc3_.height;
         this.renderTabPage(SimpleContainer.CLASS_QUEST_TABPAGE_OVERVIEW,ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW,this._window,true);
         this.renderTabPage(SimpleContainer.CLASS_QUEST_TABPAGE_REWARD,ButtonElementTypes.TYPE_QUEST_TAB_REWARD,this._window,false);
         this.renderTabPage(SimpleContainer.CLASS_QUEST_TABPAGE_INFO,ButtonElementTypes.TYPE_QUEST_TAB_INFO,this._window,false);
         this._selectedTabId = ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW;
         _loc4_ = new QuestDotList(this.guiManager.getMain());
         _loc4_.y = 8;
         this._window.addContainer(_loc4_);
         _loc5_ = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_QUEST_BUTTONS);
         _loc5_.visible = false;
         var _loc6_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_CANCEL_QUEST,BPLocale.getItem("btn_quest_cancel"),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc5_.addElement(_loc6_,SimpleContainer.ALIGN_HORIZONTAL);
         this._window.addContainer(_loc5_);
         this.onResizeQuestContent();
         this._window.addEventListener(SimpleWindowEvent.ON_RESIZE,this.onResizeQuestContent);
         this._window.addEventListener(SimpleWindowEvent.SHOW_POPUP,this.showPopupHandler);
         this._window.addEventListener(SimpleWindowEvent.HIDE_POPUP,this.hidePopupHandler);
      }
      
      private function showPopupHandler(param1:SimpleWindowEvent) : void
      {
         this._noQuestInProgress = false;
         this.contentUnderPopupVisibility = false;
         this.onResizeQuestContent(null,true);
      }
      
      private function hidePopupHandler(param1:SimpleWindowEvent) : void
      {
         this.contentUnderPopupVisibility = true;
         this.onResizeQuestContent();
      }
      
      private function set contentUnderPopupVisibility(param1:Boolean) : void
      {
         var _loc6_:SimpleContainer = null;
         var _loc7_:SimpleContainer = null;
         this._aborting = !param1;
         var _loc2_:SimpleWindow = this.guiManager.getQuestWindow();
         if(!this._noQuestInProgress)
         {
            _loc6_ = _loc2_.getContainer(SimpleContainer.CLASS_QUEST_BUTTONS);
            _loc7_ = _loc2_.getContainer(SimpleContainer.CLASS_QUEST_TABS);
            _loc6_.visible = _loc7_.visible = param1;
         }
         var _loc3_:QuestTreeContainer = this.guiManager.getQuestTreeContainer();
         _loc3_.visible = param1 && this._selectedTabId == ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW;
         var _loc4_:QuestRewardsListContainer = this.guiManager.getQuestRewardsListContainer();
         _loc4_.visible = param1 && this._selectedTabId == ButtonElementTypes.TYPE_QUEST_TAB_REWARD;
         var _loc5_:SimpleContainer = this.guiManager.getQuestInfoContainer();
         _loc5_.visible = param1 && this._selectedTabId == ButtonElementTypes.TYPE_QUEST_TAB_INFO;
      }
      
      private function createTabButton(param1:int, param2:SimpleContainer, param3:String, param4:Boolean = false) : void
      {
         var _loc5_:ButtonElement = new ButtonElement(param1,BPLocale.getItem(param3),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc5_.selected = param4;
         _loc5_.addEventListener(MouseEvent.CLICK,this.tabClickHandler);
         param2.addElement(_loc5_,SimpleContainer.ALIGN_HORIZONTAL);
         this.questTabButtons[param1] = _loc5_;
      }
      
      private function createTabLine(param1:SimpleContainer) : void
      {
         var _loc2_:SimpleElement = new SimpleElement(SimpleElement.TYPE_DEFAULT_ELEMENT);
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.lineStyle(1,8289918);
         _loc3_.graphics.moveTo(0,0);
         _loc3_.graphics.lineTo(240,0);
         _loc2_.addChild(_loc3_);
         _loc2_.y = 20;
         param1.addElement(_loc2_,SimpleContainer.NO_ALIGN,0);
      }
      
      private function renderTabPage(param1:int, param2:int, param3:SimpleWindow, param4:Boolean = true) : SimpleContainer
      {
         var _loc7_:QuestTreeContainer = null;
         var _loc8_:QuestRewardsListContainer = null;
         var _loc9_:SimpleContainer = null;
         var _loc5_:int = 8;
         var _loc6_:int = 60;
         switch(param1)
         {
            case SimpleContainer.CLASS_QUEST_TABPAGE_OVERVIEW:
               _loc7_ = new QuestTreeContainer(this.guiManager);
               _loc7_.x = _loc5_;
               _loc7_.y = _loc6_;
               _loc7_.isDefaultVisible = true;
               _loc7_.setSize(param3.getWindow().width - 20,param3.getWindow().height - 30);
               _loc7_.visible = param4;
               param3.addContainer(_loc7_);
               this.questTabPages[param2] = _loc7_;
               _loc7_.addEventListener(QuestTabEvent.UNSELECT_TAB,this.unselectTabHandler);
               break;
            case SimpleContainer.CLASS_QUEST_TABPAGE_REWARD:
               _loc8_ = new QuestRewardsListContainer(this.guiManager);
               _loc8_.x = _loc5_;
               _loc8_.y = _loc6_;
               _loc8_.visible = param4;
               param3.addContainer(_loc8_);
               this.questTabPages[param2] = _loc8_;
               _loc8_.addEventListener(QuestTabEvent.UNSELECT_TAB,this.unselectTabHandler);
               break;
            case SimpleContainer.CLASS_QUEST_TABPAGE_INFO:
               _loc9_ = new QuestInfoContainer(this.guiManager);
               _loc9_.x = _loc5_;
               _loc9_.y = _loc6_;
               _loc9_.visible = param4;
               param3.addContainer(_loc9_);
               this.questTabPages[param2] = _loc9_;
               _loc9_.addEventListener(QuestTabEvent.UNSELECT_TAB,this.unselectTabHandler);
         }
         return _loc8_;
      }
      
      private function unselectTabHandler(param1:QuestTabEvent) : void
      {
         this._noQuestInProgress = param1.noQuestInProgress;
         this.selectTab(param1.newSelectedTabId);
      }
      
      private function tabClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = (param1.currentTarget as ButtonElement).getType();
         this.selectTab(_loc2_);
      }
      
      private function selectTab(param1:int) : void
      {
         this._selectedTabId = param1;
         (this.questTabButtons[ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW] as ButtonElement).selected = param1 == ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW;
         (this.questTabButtons[ButtonElementTypes.TYPE_QUEST_TAB_REWARD] as ButtonElement).selected = param1 == ButtonElementTypes.TYPE_QUEST_TAB_REWARD;
         (this.questTabButtons[ButtonElementTypes.TYPE_QUEST_TAB_INFO] as ButtonElement).selected = param1 == ButtonElementTypes.TYPE_QUEST_TAB_INFO;
         (this.questTabPages[ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW] as SimpleContainer).visible = param1 == ButtonElementTypes.TYPE_QUEST_TAB_OVERVIEW;
         (this.questTabPages[ButtonElementTypes.TYPE_QUEST_TAB_REWARD] as SimpleContainer).visible = param1 == ButtonElementTypes.TYPE_QUEST_TAB_REWARD;
         (this.questTabPages[ButtonElementTypes.TYPE_QUEST_TAB_INFO] as SimpleContainer).visible = param1 == ButtonElementTypes.TYPE_QUEST_TAB_INFO;
         this.onResizeQuestContent();
      }
      
      private function onResizeQuestContent(param1:Event = null, param2:Boolean = false) : void
      {
         var _loc6_:DisplayObject = null;
         var _loc7_:Number = NaN;
         var _loc3_:SimpleContainer = this._window.getContainer(SimpleContainer.CLASS_QUEST_TABS);
         var _loc4_:SimpleContainer = this._window.getContainer(SimpleContainer.CLASS_QUEST_BUTTONS);
         var _loc5_:QuestTreeContainer = this.guiManager.getQuestTreeContainer();
         if(param2)
         {
            this._window.setSize(_loc5_.width,138);
         }
         else
         {
            _loc6_ = this.getCurrentContent();
            if(!this._aborting)
            {
               if(_loc6_)
               {
                  _loc4_.x = Math.max(_loc6_.width / 2 - _loc4_.width / 2,10);
                  _loc4_.y = _loc6_.y + _loc6_.height + _loc4_.height;
                  _loc7_ = Math.max(_loc6_.width + _loc6_.x,_loc3_.x + _loc3_.width);
                  this._window.setSize(_loc7_,_loc4_.height + _loc4_.y);
               }
               _loc3_.visible = _loc4_.visible = !_loc5_.isDefaultVisible;
            }
         }
         this.updateQuestDotListPosition();
      }
      
      private function updateQuestDotListPosition() : void
      {
         var _loc1_:QuestDotList = QuestDotList(this._window.getContainer(SimpleContainer.CLASS_QUEST_PAGE_DOTS));
         _loc1_.x = this._window.getWindow().width - _loc1_.width - QuestDotList.OFFSET;
      }
      
      private function getCurrentContent() : DisplayObject
      {
         return this.questTabPages[this._selectedTabId] as DisplayObject;
      }
   }
}

