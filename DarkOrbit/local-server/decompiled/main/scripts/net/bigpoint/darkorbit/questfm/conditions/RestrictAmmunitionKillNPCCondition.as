package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class RestrictAmmunitionKillNPCCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function RestrictAmmunitionKillNPCCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc2_:InGameCatalog = null;
         var _loc3_:Vector.<String> = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc11_:String = null;
         var _loc14_:Vector.<String> = null;
         var _loc15_:Vector.<String> = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         _loc2_ = InGameCatalog.getInstance();
         _loc3_ = param1;
         _loc4_ = int(_loc3_.shift());
         var _loc5_:int = int(_loc3_.shift());
         switch(_loc5_)
         {
            case 1:
               _loc6_ = int(_loc3_.shift());
               _loc14_ = _loc3_.splice(0,_loc6_);
               break;
            case 2:
               _loc7_ = int(_loc3_.shift());
               _loc15_ = _loc3_.splice(0,_loc7_);
         }
         if(_loc3_.length > 0 && _loc3_[0] == "RESTRICTED")
         {
            _loc8_ = "q2_condition_EXCLUDE_AMMUNITION_KILL_NPC";
         }
         else
         {
            _loc8_ = "q2_condition_RESTRICT_AMMUNITION_KILL_NPC";
         }
         _loc9_ = "";
         if(_loc4_ > 0)
         {
            _loc9_ = _loc2_.getNpcName(_loc4_);
            _loc8_ += "_npc";
         }
         else
         {
            _loc8_ += "_anynpc";
         }
         var _loc10_:Array = [];
         _loc11_ = "";
         if(_loc6_ > 0)
         {
            _loc8_ += "_laser";
            for each(_loc16_ in _loc14_)
            {
               _loc10_.push(_loc2_.batteryNames[_loc16_]);
            }
            _loc11_ = _loc10_.join(", ");
         }
         var _loc12_:Array = [];
         var _loc13_:String = "";
         if(_loc7_ > 0)
         {
            _loc8_ += "_rocket";
            for each(_loc17_ in _loc15_)
            {
               _loc12_.push(_loc2_.rocketNames[_loc17_]);
            }
            _loc13_ = _loc12_.join(", ");
         }
         _target_plain = "/" + TextFormatter.round(_target);
         _description = BPLocale.getItem(_loc8_);
         _description = _description.replace(/%npc%/,_loc9_);
         _description = _description.replace(/%laser%/,_loc11_);
         _description = _description.replace(/%rocket%/,_loc13_);
         if(_loc4_ > 0)
         {
            _helpIconData = getBitmapDataByKey(_loc2_.getNpcIcon(_loc4_) + "_icon.png");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

