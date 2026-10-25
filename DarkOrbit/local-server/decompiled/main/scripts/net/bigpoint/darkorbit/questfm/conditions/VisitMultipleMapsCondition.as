package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class VisitMultipleMapsCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function VisitMultipleMapsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         if(param1.length == 1)
         {
            _description = BPLocale.getItem("q2_condition_VISIT_MAP");
         }
         _description = _description.replace(/%map%/,this.getMapString(param1));
      }
      
      private function getMapString(param1:Vector.<String>) : String
      {
         var _loc2_:String = Map.getMissionMapName(int(param1.pop()));
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ += ", " + Map.getMissionMapName(int(param1[_loc4_]));
            _loc4_++;
         }
         return _loc2_;
      }
   }
}

