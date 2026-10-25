package net.bigpoint.darkorbit.mvc.gui.windows.diminishingQuest.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ButtonElementTypes;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestTreeContainer;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class DiminishingQuestRootView
   {
      
      private const defaultWidth:int = 250;
      
      public var onQuestAccepted:ISignal = new Signal();
      
      private var guiManager:GuiManager;
      
      private var uiResources:SWFFinisher;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _window:SimpleWindow;
      
      private var _questTreeContainer:QuestTreeContainer;
      
      private var _questButtonContainer:SimpleContainer;
      
      public function DiminishingQuestRootView(param1:GuiManager, param2:SimpleWindow)
      {
         super();
         this._window = param2;
         this.guiManager = param1;
         this.uiResources = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this._fuiCache = new FuiComponentSelectorCache(param2.getUIContainer());
         this.prepareWindow();
      }
      
      public function get quest() : Quest
      {
         return this._questTreeContainer.quest;
      }
      
      public function set quest(param1:Quest) : void
      {
         this._questTreeContainer.quest = param1;
         this.refresh();
      }
      
      public function set isQuestRunning(param1:Boolean) : void
      {
         this.quest.running = param1;
         this.quest.notifyConditionsOfQuestsRunstate(param1);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:Label = this.acceptTimer;
         if(_loc2_ == null)
         {
            return;
         }
         if(param1 > 0)
         {
            _loc2_.text = TimeFormatter.getSmartFormatedTime(param1);
         }
         else
         {
            _loc2_.text = "-";
         }
      }
      
      public function updateCondition(param1:int, param2:Boolean) : void
      {
         this._questTreeContainer.updateCondition(param1,param2);
      }
      
      public function refresh() : void
      {
         if(this._questTreeContainer.quest == null)
         {
            this._questTreeContainer.clearContent();
         }
         else
         {
            this._questTreeContainer.update();
            this._questTreeContainer.updateBranches();
         }
         this.repositionButton();
         this.repositionTimerLabel();
         this.fitToQuestContainer();
      }
      
      public function toggleShowAcceptBtn(param1:Boolean) : void
      {
         this._questButtonContainer.visible = param1;
         this.acceptTimer.visible = param1;
      }
      
      private function prepareWindow() : void
      {
         this._questTreeContainer = new QuestTreeContainer(this.guiManager);
         this._questTreeContainer.x = 8;
         this._questTreeContainer.y = 30;
         this._questTreeContainer.isDefaultVisible = true;
         this._questTreeContainer.setSize(this._window.width - 16,this._window.height - 60);
         this._questTreeContainer.visible = true;
         this._window.addContainer(this._questTreeContainer);
         this._questButtonContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_QUEST_BUTTONS);
         this._questButtonContainer.x = Math.max((this._window.width - this._questButtonContainer.width) / 2,10);
         this._questButtonContainer.visible = true;
         var _loc1_:ButtonElement = new ButtonElement(ButtonElementTypes.TYPE_CANCEL_QUEST,BPLocale.getItem("btn_quest_accept"),this.uiResources.getEmbeddedMovieClip("button1"));
         _loc1_.addEventListener(MouseEvent.CLICK,this.handleAcceptClickHandler);
         this._questButtonContainer.addElement(_loc1_,SimpleContainer.ALIGN_HORIZONTAL);
         this._window.addContainer(this._questButtonContainer);
         this._window.addEventListener(SimpleWindowEvent.ON_RESIZE,this.onResizeQuestContent);
      }
      
      private function repositionButton() : void
      {
         var _loc1_:DisplayObject = this._questTreeContainer;
         this._questButtonContainer.x = Math.max(_loc1_.width / 2 - this._questButtonContainer.width / 2,10);
         this._questButtonContainer.y = _loc1_.y + _loc1_.height + this._questButtonContainer.height;
      }
      
      private function repositionTimerLabel() : void
      {
         var _loc1_:Label = this.acceptTimer;
         _loc1_.x = this._questButtonContainer.x + this._questButtonContainer.width + 8;
         _loc1_.y = this._questButtonContainer.y - this._questButtonContainer.height;
      }
      
      private function fitToQuestContainer() : void
      {
         var _loc1_:Number = Math.max(this._questTreeContainer.width + this._questTreeContainer.x,this.defaultWidth);
         this._window.setSize(_loc1_,this._questButtonContainer.height + this._questButtonContainer.y);
      }
      
      private function handleAcceptClickHandler(param1:MouseEvent) : void
      {
         this.onQuestAccepted.dispatch();
      }
      
      private function onResizeQuestContent(param1:Event = null, param2:Boolean = false) : void
      {
         this.repositionButton();
         this.repositionTimerLabel();
         this.fitToQuestContainer();
      }
      
      private function get acceptTimer() : Label
      {
         return this._fuiCache.selectComponent("root.footer.accept_timer") as Label;
      }
   }
}

