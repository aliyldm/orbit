package net.bigpoint.darkorbit.questfm
{
   public interface ICase extends IQuestBaseObject
   {
      
      function get completed() : Boolean;
      
      function set completed(param1:Boolean) : void;
      
      function get mandatory() : Boolean;
      
      function get mandatory_child_count() : int;
      
      function toTextTree() : String;
      
      function get children() : Array;
   }
}

