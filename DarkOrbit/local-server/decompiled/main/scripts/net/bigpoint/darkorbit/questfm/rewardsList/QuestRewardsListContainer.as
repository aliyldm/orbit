package net.bigpoint.darkorbit.questfm.rewardsList
{
   import com.bigpoint.utils.TextFormatter;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.RewardVO;
   import net.bigpoint.darkorbit.questfm.Quest;
   
   public class QuestRewardsListContainer extends SimpleContainer
   {
      
      private var _rewardsListComponent:QuestRewardsListComponent;
      
      private var _quest:Quest;
      
      public function QuestRewardsListContainer(param1:GuiManager)
      {
         super(param1,SimpleContainer.CLASS_QUEST_REWARDS);
         addElement(this._rewardsListComponent = new QuestRewardsListComponent(),SimpleContainer.ALIGN_HORIZONTAL);
         this._rewardsListComponent.addEventListener(QuestRewardsListComponent.SIZE_CHANGED,this.sizeChangedHandler);
      }
      
      private function initList() : void
      {
         var _loc1_:RewardVO = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         this._rewardsListComponent.vPanel.removeItems();
         for each(_loc1_ in this._quest.rewards)
         {
            if(_loc1_.lootId.indexOf("title_title") >= 0)
            {
               _loc2_ = BPLocale.getItemInCategory("achievements","label_achievement_titles");
               _loc3_ = BPLocale.getItemInCategory("achievements",_loc1_.modifier);
            }
            else
            {
               _loc2_ = BPLocale.getItemInCategory("items","items_" + _loc1_.lootId.toString() + "_fullname");
               _loc3_ = TextFormatter.roundInteger(_loc1_.amount);
            }
            this._rewardsListComponent.vPanel.addItem(new QuestRewardsListRow(_loc2_,_loc3_),-1,-1);
         }
         this.sizeChangedHandler();
      }
      
      private function sizeChangedHandler(param1:Event = null) : void
      {
         guiManager.getWindow(GuiConstants.QUEST_WINDOW).dispatchEvent(new SimpleWindowEvent(SimpleWindowEvent.ON_RESIZE));
      }
      
      public function set isDefaultVisible(param1:Boolean) : void
      {
         this._rewardsListComponent.isDefaultVisible = param1;
      }
      
      public function get isDefaultVisible() : Boolean
      {
         return this._rewardsListComponent.isDefaultVisible;
      }
      
      public function get quest() : Quest
      {
         return this._quest;
      }
      
      public function updateQuestTitle() : void
      {
         this._rewardsListComponent.questTitle = this.quest.title;
      }
      
      public function set quest(param1:Quest) : void
      {
         this._quest = param1;
         this._rewardsListComponent.questTitle = param1.title;
         this.initList();
      }
      
      public function clearContent() : void
      {
         this._rewardsListComponent.vPanel.removeItems();
      }
   }
}

