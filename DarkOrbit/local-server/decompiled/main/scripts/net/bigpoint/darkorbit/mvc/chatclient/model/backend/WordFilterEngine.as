package net.bigpoint.darkorbit.mvc.chatclient.model.backend
{
   public class WordFilterEngine
   {
      
      private var wordFilterTree:WordFilterTree = new WordFilterTree();
      
      public function WordFilterEngine()
      {
         super();
      }
      
      public function loadFromJsonArray(param1:Array) : void
      {
         var _loc2_:String = null;
         if(ChatSettings.isNew)
         {
            for each(_loc2_ in param1)
            {
               this.wordFilterTree.addWord(_loc2_);
            }
         }
         else
         {
            this.wordFilterTree.addWord("fuck");
         }
      }
      
      public function applyWordFilter(param1:String) : String
      {
         return this.wordFilterTree.filterAllWords(param1);
      }
   }
}

