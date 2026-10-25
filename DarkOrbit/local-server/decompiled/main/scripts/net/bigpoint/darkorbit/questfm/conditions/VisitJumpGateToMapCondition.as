package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class VisitJumpGateToMapCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private static const SEPARATOR:String = "0";
      
      private static const CONCATINATOR:String = ", ";
      
      public function VisitJumpGateToMapCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         super.parseMatches(param1);
         if(param1.length > 1)
         {
            _loc2_ = this.getFromMapString(param1);
            _loc3_ = this.getToMapsList(param1);
            _description = _description.replace(/%FROM%/,_loc2_).replace(/%TO%/,_loc3_);
         }
      }
      
      private function getToMapsList(param1:Vector.<String>) : String
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<String> = new Vector.<String>();
         while(true)
         {
            _loc2_ = param1.pop();
            if(!_loc2_)
            {
               break;
            }
            _loc3_.push(Map.getMissionMapName(int(_loc2_)));
         }
         return _loc3_.join(CONCATINATOR);
      }
      
      private function getFromMapString(param1:Vector.<String>) : String
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<String> = new Vector.<String>();
         while(true)
         {
            _loc2_ = param1.pop();
            if(_loc2_ == SEPARATOR)
            {
               break;
            }
            _loc3_.push(Map.getMissionMapName(int(_loc2_)));
         }
         return _loc3_.join(CONCATINATOR);
      }
   }
}

