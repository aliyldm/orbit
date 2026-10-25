package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class TakeDamageCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _damage_type_id:int;
      
      public function TakeDamageCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         this._damage_type_id = parseInt(param1[0]);
         if(_mandatory)
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_" + InGameCatalog.instance.damage_types[this._damage_type_id]);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

