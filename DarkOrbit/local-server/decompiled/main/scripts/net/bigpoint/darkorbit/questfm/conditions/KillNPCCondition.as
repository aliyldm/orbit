package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class KillNPCCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _npc_id:int;
      
      public function KillNPCCondition()
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
         this._npc_id = parseInt(param1[0]);
         if(mandatory && _target > 0)
         {
            _target_plain = "/" + _target;
            _validatable = true;
         }
         else
         {
            _validatable = false;
            _description = BPLocale.getItem("q2_condition_" + _definition.TRANS_BASE_KEY + "_challenge");
         }
         _description = _description.replace(/%npc%/,InGameCatalog.instance.getNpcName(this._npc_id));
         _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getNpcIcon(this._npc_id) + "_icon.png");
      }
   }
}

