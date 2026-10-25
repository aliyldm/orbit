package net.bigpoint.darkorbit.questfm.conditions
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   
   public class RestrictAmmunitionKillPlayerCondition extends net.bigpoint.darkorbit.questfm.conditions.Condition
   {
      
      public function RestrictAmmunitionKillPlayerCondition()
      {
         super();
      }
      
      override protected function parseMatches(param1:Vector.<String>) : void
      {
         var _loc3_:InGameCatalog = null;
         var _loc5_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc14_:String = null;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc2_:String = "q2_condition_" + _definition.TRANS_BASE_KEY;
         _loc3_ = InGameCatalog.getInstance();
         var _loc4_:Vector.<String> = param1;
         _loc5_ = int(_loc4_.shift());
         var _loc6_:int = int(_loc4_.shift());
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<int> = new Vector.<int>();
         var _loc10_:Vector.<int> = new Vector.<int>();
         while(_loc4_.length >= 2)
         {
            _loc17_ = int(_loc4_.shift());
            switch(_loc17_)
            {
               case 1:
                  _loc7_ += 1;
                  _loc9_.push(int(_loc4_.shift()));
                  break;
               case 2:
                  _loc8_ += 1;
                  _loc10_.push(int(_loc4_.shift()));
            }
         }
         _loc11_ = "";
         if(_loc5_ > 0)
         {
            _loc11_ = _loc3_.getShipName(_loc5_);
            _loc2_ += "_ship";
         }
         else
         {
            _loc2_ += "_anyship";
         }
         _loc12_ = "";
         if(_loc6_ > 0)
         {
            _loc12_ = _loc3_.factions_names[_loc6_];
            _loc2_ += "_faction";
         }
         else
         {
            _loc2_ += "_anyfaction";
         }
         var _loc13_:Array = [];
         _loc14_ = "";
         if(_loc7_ > 0)
         {
            _loc2_ += "_laser";
            for each(_loc18_ in _loc9_)
            {
               _loc13_.push(_loc3_.batteryNames[_loc18_]);
            }
            _loc14_ = _loc13_.join(", ");
         }
         var _loc15_:Array = [];
         _loc16_ = "";
         if(_loc8_ > 0)
         {
            _loc2_ += "_rocket";
            for each(_loc19_ in _loc10_)
            {
               _loc15_.push(_loc3_.rocketNames[_loc19_]);
            }
            _loc16_ = _loc15_.join(", ");
         }
         _target_plain = "/" + TextFormatter.round(_target);
         _description = BPLocale.getItem(_loc2_);
         _description = _description.replace(/%ship%/,_loc11_);
         _description = _description.replace(/%faction%/,_loc12_);
         _description = _description.replace(/%laser%/,_loc14_);
         _description = _description.replace(/%rocket%/,_loc16_);
         if(_loc5_ > 0)
         {
            _helpIconData = getBitmapDataByKey(_loc3_.getShipIcon(_loc5_) + "_icon.png");
         }
      }
      
      override public function get currentVerbose() : String
      {
         return String(_current);
      }
   }
}

