package net.bigpoint.darkorbit.questfm
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class QuestTreeContainer extends SimpleContainer
   {
      
      private var _questTreeComponent:QuestTreeComponent;
      
      public function QuestTreeContainer(param1:GuiManager)
      {
         super(param1,SimpleContainer.CLASS_QUEST_TREE);
         addChild(this._questTreeComponent = new QuestTreeComponent());
         this._questTreeComponent.addEventListener(QuestTreeComponent.SIZE_CHANGED,this.sizeChangedHandler);
      }
      
      private function sizeChangedHandler(param1:Event) : void
      {
         guiManager.getWindow(GuiConstants.QUEST_WINDOW).dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_RESIZE));
      }
      
      public function set isDefaultVisible(param1:Boolean) : void
      {
         this._questTreeComponent.isDefaultVisible = param1;
      }
      
      public function get isDefaultVisible() : Boolean
      {
         return this._questTreeComponent.isDefaultVisible;
      }
      
      public function get isHonourQuestVisible() : Boolean
      {
         return this._questTreeComponent.isHonourQuestVisible;
      }
      
      public function showDefaultText(param1:String) : void
      {
         this._questTreeComponent.showDefaultText(param1);
      }
      
      public function updateQuestTitle() : void
      {
         this._questTreeComponent.updateQuestTitle();
      }
      
      public function clearContent() : void
      {
         this._questTreeComponent.clearContent();
      }
      
      public function updateCondition(param1:int, param2:Boolean) : void
      {
         this._questTreeComponent.updateCondition(param1,param2);
      }
      
      public function update() : void
      {
         this._questTreeComponent.update();
      }
      
      public function setSize(param1:int, param2:int) : void
      {
      }
      
      public function updateBranches() : void
      {
         this._questTreeComponent.updateBranches();
         guiManager.getWindow(GuiConstants.QUEST_WINDOW).dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_RESIZE));
      }
      
      public function get visibleHeight() : int
      {
         return this._questTreeComponent.visibleHeight;
      }
      
      public function get quest() : Quest
      {
         return this._questTreeComponent.quest;
      }
      
      public function set quest(param1:Quest) : void
      {
         this._questTreeComponent.quest = param1;
      }
   }
}

