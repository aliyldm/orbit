package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.map.model.Map;
   
   public class FinishGalaxyGatesCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _gate_name_list:String = "";
      
      public function FinishGalaxyGatesCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc5_:String = null;
         var _loc2_:Vector.<String> = param1;
         var _loc3_:int = parseInt(_loc2_.shift());
         var _loc4_:int = _loc3_;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = Map.getMissionMapName(int(param1[_loc4_]));
            if(_loc5_)
            {
               this._gate_name_list += ", " + _loc5_;
            }
            _loc4_++;
         }
         this._gate_name_list = this._gate_name_list.substring(2);
         _description = BPLocale.getItem("q2_condition_FINISH_GALAXY_GATE_any_of").replace(/%TYPE%/,this._gate_name_list);
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

