package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class MapDiverseCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function MapDiverseCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc5_:int = 0;
         var _loc8_:String = null;
         super.parseMatches(param1);
         var _loc2_:Array = [];
         var _loc3_:Vector.<String> = param1;
         var _loc4_:int = int(_loc3_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = parseInt(_loc3_[_loc6_]);
            _loc8_ = Map.getMissionMapName(_loc5_);
            if(_loc8_)
            {
               _loc2_.push(_loc8_);
            }
            _loc6_++;
         }
         var _loc7_:String = _loc2_.join(" ,");
         _loc7_ = "\n" + _loc7_;
         _description = _description.replace(/%maps%/,_loc7_);
      }
   }
}

