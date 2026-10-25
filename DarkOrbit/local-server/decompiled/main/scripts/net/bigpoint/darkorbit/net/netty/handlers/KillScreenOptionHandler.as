package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.KillScreenOptionModule;
   import net.bigpoint.darkorbit.com.module.MessageLocalizedWildcardCommand;
   import net.bigpoint.darkorbit.com.module.MessageWildcardReplacementModule;
   import net.bigpoint.darkorbit.com.module.PriceModule;
   import net.bigpoint.darkorbit.gui.killscreen.vos.KillScreenOptionDetailVo;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class KillScreenOptionHandler extends BaseHandler
   {
      
      public function KillScreenOptionHandler()
      {
         super();
      }
      
      public static function run(param1:KillScreenOptionModule) : void
      {
         var _loc4_:MessageWildcardReplacementModule = null;
         var _loc11_:MessageWildcardReplacementModule = null;
         var _loc2_:MessageLocalizedWildcardCommand = param1.descriptionKey;
         var _loc3_:MessageLocalizedWildcardCommand = param1.descriptionKeyAddon;
         var _loc5_:KillScreenOptionDetailVo = new KillScreenOptionDetailVo();
         var _loc6_:KillScreenOptionDetailVo = new KillScreenOptionDetailVo();
         var _loc7_:Killscreen = Killscreen.getInstance();
         _loc5_.currency = getCurrencyByPriceModule(param1.price.type);
         _loc6_.currency = getCurrencyByPriceModule(param1.price.type);
         var _loc8_:int = 0;
         while(_loc8_ < _loc2_.wildCardReplacements.length)
         {
            _loc4_ = _loc2_.wildCardReplacements[_loc8_];
            _loc5_.wildcard = _loc4_.wildcard;
            _loc5_.replacement = _loc4_.replacement;
            _loc8_++;
         }
         _loc5_.baseKey = _loc2_.baseKey;
         var _loc9_:int = 0;
         while(_loc9_ < _loc3_.wildCardReplacements.length)
         {
            _loc4_ = _loc3_.wildCardReplacements[_loc9_];
            _loc6_.wildcard = _loc4_.wildcard;
            _loc6_.replacement = _loc4_.replacement;
            _loc9_++;
         }
         _loc6_.baseKey = _loc3_.baseKey;
         if(_loc4_)
         {
            _loc7_.setOptionDetailText(param1.repairType.repairTypeValue,_loc5_,_loc6_);
         }
         else
         {
            _loc7_.setOptionDetailText(param1.repairType.repairTypeValue,_loc5_);
         }
         var _loc10_:MessageLocalizedWildcardCommand = param1.buttonKey;
         var _loc12_:int = 0;
         while(_loc12_ < _loc10_.wildCardReplacements.length)
         {
            _loc11_ = _loc10_.wildCardReplacements[_loc12_];
            _loc12_++;
         }
         if(_loc11_)
         {
            _loc7_.addOption(param1.repairType.repairTypeValue,param1.price.amount,param1.price.type,_loc10_.baseKey,_loc11_.replacement,param1.affordableForPlayer,param1.cooldownTime,param1.price.type);
         }
         else
         {
            _loc7_.addOption(param1.repairType.repairTypeValue,param1.price.amount,param1.price.type,_loc10_.baseKey,"",param1.affordableForPlayer,param1.cooldownTime,param1.price.type);
         }
      }
      
      public static function getCurrencyByPriceModule(param1:int) : String
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case PriceModule.CURRENCYTYPE_CREDITS:
               _loc2_ = BPLocale.getItem("ttip_credits");
               break;
            case PriceModule.CURRENCYTYPE_URIDIUM:
               _loc2_ = BPLocale.getItem("ttip_uridium");
               break;
            default:
               _loc2_ = BPLocale.getItem("ttip_uridium");
         }
         return _loc2_;
      }
   }
}

