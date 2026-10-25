package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   
   public class SpendItemCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _loot_id:String;
      
      public function SpendItemCondition()
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
            this._loot_id = param1[0];
            _loc2_ = "q2_condition_" + _definition.TRANS_BASE_KEY;
            _description = BPLocale.getItem(_loc2_);
         }
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         _description = _description.replace(/%type%/,TextUtils.getTranslationByType(this._loot_id,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME));
      }
   }
}

