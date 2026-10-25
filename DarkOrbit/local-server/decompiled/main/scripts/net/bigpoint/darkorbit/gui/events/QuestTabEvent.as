package net.bigpoint.darkorbit.gui.events
{
   import flash.events.Event;
   
   public class QuestTabEvent extends Event
   {
      
      public static const UNSELECT_TAB:String = "unselectTab";
      
      private var _newSelectedTabId:int;
      
      private var _noQuestInProgress:Boolean = true;
      
      public function QuestTabEvent(param1:String, param2:int, param3:Boolean)
      {
         super(param1,true);
         this._newSelectedTabId = param2;
         this._noQuestInProgress = param3;
      }
      
      public function get newSelectedTabId() : int
      {
         return this._newSelectedTabId;
      }
      
      public function get noQuestInProgress() : Boolean
      {
         return this._noQuestInProgress;
      }
   }
}

