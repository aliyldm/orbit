package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class KillNPCsCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _npc_id_count:int;
      
      private var _npc_names_list:String = "";
      
      public function KillNPCsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc3_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Vector.<String> = param1;
         this._npc_id_count = parseInt(_loc2_.shift());
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = parseInt(_loc2_[_loc4_]);
            _loc6_ = InGameCatalog.instance.getNpcName(_loc3_);
            if(_loc6_)
            {
               this._npc_names_list += ", " + _loc6_;
            }
            _loc4_++;
         }
         this._npc_names_list = this._npc_names_list.substring(2);
         var _loc5_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         else
         {
            _loc5_ += "_challenge";
         }
         _description = BPLocale.getItem(_loc5_);
         _description = description.replace(/%npcs%/,this._npc_names_list);
         if(this._npc_id_count > 0)
         {
            _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getNpcIcon(_loc3_) + "_icon.png");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

