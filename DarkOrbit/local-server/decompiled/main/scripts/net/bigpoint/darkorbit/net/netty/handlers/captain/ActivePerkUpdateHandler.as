package net.bigpoint.darkorbit.net.netty.handlers.captain
{
   import flash.globalization.LocaleID;
   import flash.globalization.NumberFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.ActivePerkUpdateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ActivePerkUpdateHandler extends BaseHandler
   {
      
      public function ActivePerkUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:ActivePerkUpdateCommand) : void
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:NumberFormatter = null;
         var _loc2_:String = "\n";
         var _loc3_:int = 0;
         while(_loc3_ < param1.activePerkModuleList.length)
         {
            _loc4_ = param1.activePerkModuleList[_loc3_].perkTypeId;
            _loc5_ = param1.activePerkModuleList[_loc3_].modifierValue;
            _loc6_ = new NumberFormatter(flash.globalization.LocaleID.DEFAULT);
            _loc6_.fractionalDigits = 1;
            _loc6_.trailingZeros = true;
            if(_loc4_.indexOf("evasion") >= 0)
            {
               _loc5_ *= -1;
            }
            _loc2_ += BPLocale.getItem("ttip_captain_" + _loc4_ + "_description").replace(/%VALUE%/,String(_loc6_.formatNumber(_loc5_))) + "\n";
            _loc3_++;
         }
         _main.getConnectionManager().getAttributeAssembly().assembleActivePerkUpdate(_loc2_);
      }
   }
}

