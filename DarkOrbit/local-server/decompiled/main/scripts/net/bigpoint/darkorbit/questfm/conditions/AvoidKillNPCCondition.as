package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class AvoidKillNPCCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _npc_id:int;
      
      public function AvoidKillNPCCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         this._npc_id = parseInt(param1[0]);
         var _loc2_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(_target == 0)
         {
            _loc2_ += "_none";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         if(mandatory)
         {
            _loc2_ += "_challenge";
         }
         _description = BPLocale.getItem(_loc2_);
         _description = description.replace(/%npc%/,InGameCatalog.instance.getNpcName(this._npc_id));
         _description = description.replace(/%count%/,_target);
         _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getNpcIcon(this._npc_id) + "_icon.png");
      }
      
      override public function get currentVerbose() : String
      {
         if(_target == 0)
         {
            return "";
         }
         return String(_current);
      }
   }
}

