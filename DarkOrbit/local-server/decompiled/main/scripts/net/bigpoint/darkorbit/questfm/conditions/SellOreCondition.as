package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class SellOreCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      private var _ore_id:int;
      
      public function SellOreCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:InGameCatalog = null;
         var _loc3_:uint = 0;
         this._ore_id = parseInt(param1[0]);
         _loc2_ = InGameCatalog.instance;
         _loc3_ = uint(InGameCatalog.instance.ore_oldIDtoNewID[this._ore_id]);
         var _loc4_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(this._ore_id > 0)
         {
            _loc4_ += "_ore";
            _helpIconData = getBitmapDataByKey("ore_" + this._ore_id + ".png");
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
         _description = _description.replace(/%ore%/,_loc2_.ore_names[_loc3_]);
         _description = description.replace(/%count%/,_target);
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

