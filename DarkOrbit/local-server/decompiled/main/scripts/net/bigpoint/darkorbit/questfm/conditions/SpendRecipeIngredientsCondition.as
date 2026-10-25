package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   
   public class SpendRecipeIngredientsCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _loot_id:String;
      
      public function SpendRecipeIngredientsCondition()
      {
         super();
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         super.parseMatches(param1);
         if(param1.length > 0)
         {
            this._loot_id = param1[0];
            _description = _description.replace(/%type%/,TextUtils.getTranslationByType(this._loot_id,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME));
         }
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
      }
   }
}

