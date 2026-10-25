package net.bigpoint.darkorbit.net.netty.handlers.ore
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.OreTradeInfoCommand;
   import net.bigpoint.darkorbit.com.module.OreTypeModule;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class OreTradeInfoHandler extends BaseHandler
   {
      
      public function OreTradeInfoHandler()
      {
         super();
      }
      
      public static function run(param1:OreTradeInfoCommand) : void
      {
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_PROMETIUM]).price = param1.prometiumPrice;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_ENDURIUM]).price = param1.enduriumPrice;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_TERBIUM]).price = param1.terbiumPrice;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_PROMETID]).price = param1.prometidPrice;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_DURANIUM]).price = param1.duraniumPrice;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_PROMERIUM]).price = param1.promeriumPrice;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_SEPROM]).price = param1.sepromPrice;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_PALLADIUM]).price = param1.palladiumExchangeRate;
         OrePattern(PatternManager.orePatterns[OreTypeModule.ORETYPE_OSMIUM]).price = param1.osmiumPrice;
         Hero.setTradeAreaType(param1.type);
         _main.getGuiManager().updateTradeWindow(true);
         _main.getGuiManager().showTradeWindow();
      }
   }
}

