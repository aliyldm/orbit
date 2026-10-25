package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class DamageNPCsCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var npcIDcount:int;
      
      private var npcIDs:Array = [];
      
      private var npcListing:String = "";
      
      private var damageTypeCount:int;
      
      private var damageTypeID:int;
      
      public function DamageNPCsCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc6_:String = null;
         var _loc2_:Vector.<String> = param1;
         this.npcIDcount = int(_loc2_.shift());
         var _loc3_:Vector.<String> = _loc2_.splice(0,this.npcIDcount);
         this.damageTypeCount = int(_loc2_.shift());
         this.damageTypeID = int(_loc2_.shift());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            this.npcIDs[_loc4_] = int(_loc3_[_loc4_]);
            _loc6_ = InGameCatalog.instance.getNpcName(this.npcIDs[_loc4_]);
            if(_loc6_)
            {
               this.npcListing += ", " + _loc6_;
            }
            _loc4_++;
         }
         this.npcListing = this.npcListing.substring(2);
         var _loc5_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this.npcIDcount > 0)
         {
            _loc5_ += "_spec";
         }
         _loc5_ += "_" + InGameCatalog.instance.damage_types[this.damageTypeID];
         if(_target > 0)
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem(_loc5_);
         _description = description.replace(/%npcs%/,this.npcListing);
         if(this.npcIDcount > 0)
         {
            _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getNpcIcon(this.npcIDs[0]) + "_icon.png");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

