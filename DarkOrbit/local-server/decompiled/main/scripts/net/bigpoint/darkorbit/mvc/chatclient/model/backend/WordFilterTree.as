package net.bigpoint.darkorbit.mvc.chatclient.model.backend
{
   import flash.utils.Dictionary;
   
   public class WordFilterTree
   {
      
      private static var badWordReplace:String = "!§$%&^*";
      
      private var startingChars:Dictionary = new Dictionary();
      
      private var finishingChars:Dictionary = new Dictionary();
      
      public function WordFilterTree()
      {
         super();
      }
      
      public function addWord(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1.length > 0)
         {
            _loc2_ = param1.charAt(0);
            if(!this.startingChars[_loc2_])
            {
               this.startingChars[_loc2_] = new WordFilterTree();
            }
            if(param1.length == 1)
            {
               this.finishingChars[_loc2_] = true;
            }
            else
            {
               this.startingChars[_loc2_].addWord(param1.substr(1,param1.length));
            }
         }
      }
      
      public function filterAllWords(param1:String) : String
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = "";
         var _loc4_:String = param1.toLowerCase();
         while(_loc2_ < param1.length)
         {
            _loc5_ = this.checkFilter(_loc4_,_loc2_);
            if(_loc5_ > 0)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  _loc3_ += badWordReplace.charAt(_loc6_ % badWordReplace.length);
                  _loc6_++;
               }
               _loc2_ += _loc5_;
            }
            else
            {
               _loc3_ += param1.charAt(_loc2_);
               _loc2_++;
            }
         }
         return _loc3_;
      }
      
      public function checkFilter(param1:String, param2:int) : int
      {
         var _loc4_:int = 0;
         var _loc3_:String = param1.charAt(param2);
         if(this.startingChars[_loc3_])
         {
            _loc4_ = int(this.startingChars[_loc3_].checkFilter(param1,param2 + 1));
            if(_loc4_ > 0)
            {
               return _loc4_ + 1;
            }
         }
         if(this.finishingChars[_loc3_])
         {
            return 1;
         }
         return 0;
      }
   }
}

