package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class FinishGalaxyGateCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function FinishGalaxyGateCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         _description = _description.replace(/%TYPE%/,Map.getMissionMapName(int(param1[1])));
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

