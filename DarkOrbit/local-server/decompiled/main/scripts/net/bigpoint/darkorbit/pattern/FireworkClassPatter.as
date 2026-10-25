package net.bigpoint.darkorbit.pattern
{
   public class FireworkClassPatter
   {
      
      private var _classID:String;
      
      private var _fireWorkList:Vector.<FireworkPattern>;
      
      public function FireworkClassPatter(param1:String, param2:Vector.<FireworkPattern>)
      {
         super();
         this._fireWorkList = param2;
         this._classID = param1;
      }
      
      public function getFireWorkKey(param1:int, param2:String) : String
      {
         var _loc3_:FireworkPattern = null;
         for each(_loc3_ in this._fireWorkList)
         {
            if(_loc3_.type == param2)
            {
               return _loc3_.getKeyByColor(param1);
            }
         }
         return this._fireWorkList[0].getKeyByColor(param1);
      }
   }
}

