package net.bigpoint.darkorbit.mvc.questWindow.view.events
{
   import flash.events.Event;
   
   public class QuestGiverWindowEvent extends Event
   {
      
      public static const GET_DETAILED_QUEST_INFO:String = "GET_DETAILED_QUEST_INFO";
      
      public static const ACCEPT_QUEST:String = "ACCEPT_QUEST";
      
      public static const ABORT_QUEST:String = "ABORT_QUEST";
      
      public static const TAB_CHANGED:String = "TAB_CHANGED";
      
      public static const FILTERS_CHANGED:String = "FILTERS_CHANGED";
      
      public var questID:int;
      
      public var rootCaseID:int;
      
      private var _data:Object;
      
      public function QuestGiverWindowEvent(param1:String, param2:Object = null, param3:Boolean = true, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      override public function clone() : Event
      {
         var _loc1_:QuestGiverWindowEvent = new QuestGiverWindowEvent(type);
         _loc1_.questID = this.questID;
         _loc1_.rootCaseID = this.rootCaseID;
         return _loc1_;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

