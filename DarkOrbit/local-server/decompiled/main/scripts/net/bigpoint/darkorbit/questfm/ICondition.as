package net.bigpoint.darkorbit.questfm
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.questfm.conditions.ConditionTypeDefinition;
   
   public interface ICondition extends IQuestBaseObject
   {
      
      function toTextTree() : String;
      
      function get validatable() : Boolean;
      
      function get current() : Number;
      
      function set current(param1:Number) : void;
      
      function set definition(param1:ConditionTypeDefinition) : void;
      
      function get definition() : ConditionTypeDefinition;
      
      function init(param1:int, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean, param7:Vector.<String>) : void;
      
      function get description() : String;
      
      function get targetVerbose() : String;
      
      function get currentVerbose() : String;
      
      function get children() : Array;
      
      function get completed() : Boolean;
      
      function set completed(param1:Boolean) : void;
      
      function get id() : uint;
      
      function set id(param1:uint) : void;
      
      function get mandatory() : Boolean;
      
      function get runstate() : Boolean;
      
      function set runstate(param1:Boolean) : void;
      
      function get helpIconsClipCopy() : DisplayObject;
      
      function isSubcondition() : Boolean;
      
      function markAsSubCondition() : void;
      
      function updateCondtition(param1:int, param2:Number, param3:Boolean, param4:Boolean) : Boolean;
      
      function set questIsRunning(param1:Boolean) : void;
   }
}

