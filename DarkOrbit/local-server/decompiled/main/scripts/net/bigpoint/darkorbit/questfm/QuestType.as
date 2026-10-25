package net.bigpoint.darkorbit.questfm
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.QuestTypeModule;
   
   public class QuestType
   {
      
      public static const CLIENT_QUEST_HONOUR:int = -1;
      
      private var _typeDict:Dictionary = new Dictionary();
      
      public function QuestType()
      {
         super();
      }
      
      public function init(param1:Vector.<QuestTypeModule>) : void
      {
         this._typeDict = new Dictionary();
         this.setTypes(param1);
      }
      
      public function setTypes(param1:Vector.<QuestTypeModule>) : void
      {
         var _loc2_:QuestTypeModule = null;
         for each(_loc2_ in param1)
         {
            this.setType(_loc2_.type);
         }
      }
      
      public function setType(param1:int, param2:Boolean = true) : void
      {
         this._typeDict[param1] = param2;
      }
      
      public function hasQuestType(param1:int) : Boolean
      {
         return Boolean(this._typeDict[param1]);
      }
   }
}

