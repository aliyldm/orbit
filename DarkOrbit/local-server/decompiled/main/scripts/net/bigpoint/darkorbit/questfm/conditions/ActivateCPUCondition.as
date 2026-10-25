package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class ActivateCPUCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var cpuCategory:String;
      
      public function ActivateCPUCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:String = null;
         if(param1.length > 0)
         {
            this.cpuCategory = param1[0];
            _loc2_ = "q2_condition_" + _definition.TRANS_BASE_KEY + "_" + this.cpuCategory;
            _description = BPLocale.getItem(_loc2_);
         }
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         _description = _description.replace(/%count%/,_target);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

