package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class ClearGalaxyGateWaveCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function ClearGalaxyGateWaveCondition()
      {
         super();
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = null;
         super.parseMatches(param1);
         if(param1.length > 0)
         {
            _loc2_ = "q2_condition_" + _definition.TRANS_BASE_KEY;
            _description = BPLocale.getItem(_loc2_);
            _description = _description.replace(/%WAVES%/,_target);
            _description = _description.replace(/%TYPE%/,Map.getMissionMapName(int(param1[1])));
         }
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
      }
   }
}

