package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class SalvageCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _faction_id:int;
      
      private var _ship_type:int;
      
      private var _npc_type:int;
      
      private var _loot_type:int;
      
      private var _ore_id:int;
      
      public function SalvageCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:Vector.<String> = param1;
         var _loc3_:InGameCatalog = InGameCatalog.instance;
         this._faction_id = parseInt(_loc2_.shift());
         this._ship_type = parseInt(_loc2_.shift());
         this._npc_type = parseInt(_loc2_.shift());
         this._loot_type = parseInt(_loc2_.shift());
         this._ore_id = parseInt(_loc2_.shift());
         var _loc4_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._ore_id == 0)
         {
            _loc4_ += "_any";
         }
         else
         {
            _loc4_ += "_spec";
         }
         if(this._npc_type == 0 && this._ship_type == 0 && this._faction_id == 0)
         {
            _loc4_ += "_any";
         }
         else
         {
            if(this._npc_type > 0)
            {
               _loc4_ += "_npc";
            }
            if(this._ship_type > 0)
            {
               _loc4_ += "_ship";
            }
            if(this._faction_id > 0)
            {
               _loc4_ += "_faction";
            }
         }
         if(_target == 0)
         {
            _loc4_ += "_challenge";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem(_loc4_);
         var _loc5_:uint = uint(InGameCatalog.instance.ore_oldIDtoNewID[this._ore_id]);
         _description = description.replace(/%ore%/,InGameCatalog.instance.ore_names[_loc5_]);
         _description = description.replace(/%npc%/,InGameCatalog.instance.getNpcName(this._npc_type));
         _description = description.replace(/%ship%/,InGameCatalog.instance.getShipName(this._ship_type));
         _description = description.replace(/%faction%/,InGameCatalog.instance.factions_names[this._faction_id]);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

