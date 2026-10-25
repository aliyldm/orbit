package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class DamageCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _damage_type_id:int;
      
      public function DamageCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         this._damage_type_id = parseInt(param1[0]);
         _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_" + InGameCatalog.instance.damage_types[this._damage_type_id]);
      }
      
      override public function get currentVerbose() : String
      {
         return TextFormatter.roundInteger(_current);
      }
   }
}

