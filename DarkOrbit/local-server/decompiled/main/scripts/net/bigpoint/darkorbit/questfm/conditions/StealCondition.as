package net.bigpoint.darkorbit.questfm.conditions
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class StealCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function StealCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc8_:String = null;
         _loc3_ = [];
         _loc4_ = "";
         var _loc5_:Vector.<String> = param1;
         _loc2_ = parseInt(_loc5_.shift());
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc3_[_loc6_] = parseInt(_loc5_[_loc6_]);
            _loc8_ = InGameCatalog.instance.getShipName(_loc3_[_loc6_]);
            if(_loc8_)
            {
               _loc4_ += ", " + _loc8_;
            }
            _loc6_++;
         }
         _loc4_ = _loc4_.substring(2);
         var _loc7_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         if(_loc4_.length > 0)
         {
            _loc7_ += "_ship";
         }
         else
         {
            _loc7_ += "_any";
         }
         if(_loc2_ > 0)
         {
            _loc7_ += "_faction";
         }
         else
         {
            _loc7_ += "_enemyfaction";
         }
         if(_target == 0)
         {
            _loc7_ += "_challenge";
         }
         else
         {
            _target_plain = "/" + _target;
         }
         _description = BPLocale.getItem(_loc7_);
         _description = description.replace(/%ship%/,_loc4_);
         _description = description.replace(/%faction%/,InGameCatalog.instance.factions_names[_loc2_]);
         if(_loc3_.length > 0)
         {
            _helpIconData = getBitmapDataByKey(InGameCatalog.instance.getShipIcon(_loc3_[0]) + "_icon.png");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

