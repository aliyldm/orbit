package net.bigpoint.darkorbit.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestTypeModule;
   
   public class Quest
   {
      
      private var _id:uint;
      
      private var _types:Vector.<QuestTypeModule>;
      
      private var _type:QuestType = new QuestType();
      
      private var _case:Case;
      
      private var _flatConditions:Array = [];
      
      private var _category:String = "std";
      
      private var _rewards:Array;
      
      private var _running:Boolean;
      
      private var _portraitId:String;
      
      private var _textKeyBase:String;
      
      private var _title:String;
      
      private var _description:String;
      
      public function Quest(param1:uint, param2:Case, param3:Array, param4:Boolean, param5:String, param6:String)
      {
         super();
         this._id = param1;
         this._case = param2;
         this._rewards = param3;
         this._running = param4;
         this._portraitId = param5;
         this._textKeyBase = param6;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function updateCondition(param1:int, param2:Number, param3:Boolean, param4:Boolean) : void
      {
         this._case.updateCondtition(param1,param2,param3,param4);
      }
      
      public function getCase() : Case
      {
         return this._case;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function set category(param1:String) : void
      {
         this._category = param1;
      }
      
      public function get flatConditions() : Array
      {
         return this._flatConditions;
      }
      
      public function set flatConditions(param1:Array) : void
      {
         this._flatConditions = param1;
      }
      
      public function get title() : String
      {
         if(!this._title)
         {
            this._title = QuestLocale.getTitleEx(this.id,this._textKeyBase,this.type);
         }
         return this._title;
      }
      
      public function get description() : String
      {
         if(!this._description)
         {
            this._description = QuestLocale.getDescriptionEx(this.id,this._textKeyBase,this.type);
         }
         return this._description;
      }
      
      public function get rewards() : Array
      {
         return this._rewards;
      }
      
      public function set types(param1:Vector.<QuestTypeModule>) : void
      {
         this._types = param1;
         this._type.init(this._types);
         var _loc2_:Array = [10000,10001,10002];
         if(_loc2_.indexOf(this._id) != -1)
         {
            this._type.setType(QuestType.CLIENT_QUEST_HONOUR);
         }
      }
      
      public function get type() : QuestType
      {
         return this._type;
      }
      
      public function notifyConditionsOfQuestsRunstate(param1:Boolean) : void
      {
         this.setRunstate(param1,this.flatConditions);
      }
      
      private function setRunstate(param1:Boolean, param2:Array) : void
      {
         var _loc3_:ICondition = null;
         for each(_loc3_ in param2)
         {
            _loc3_.questIsRunning = param1;
            if(_loc3_.children)
            {
               this.setRunstate(param1,_loc3_.children);
            }
         }
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function set running(param1:Boolean) : void
      {
         this._running = param1;
      }
      
      public function get portraitId() : String
      {
         return this._portraitId;
      }
   }
}

