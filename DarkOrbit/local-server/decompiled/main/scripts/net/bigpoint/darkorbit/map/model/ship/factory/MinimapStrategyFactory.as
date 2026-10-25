package net.bigpoint.darkorbit.map.model.ship.factory
{
   import net.bigpoint.darkorbit.com.module.MinimapStrategyModule;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.ship.minimap.CompanyColorStrategy;
   import net.bigpoint.darkorbit.map.model.ship.minimap.PlayerNpcAndInvadersStrategy;
   import net.bigpoint.darkorbit.map.model.ship.minimap.RedAndBlueColorStrategy;
   import net.bigpoint.darkorbit.map.model.ship.minimap.StdMinimapColorStrategy;
   
   public class MinimapStrategyFactory
   {
      
      public static const instance:MinimapStrategyFactory = new MinimapStrategyFactory();
      
      private const _minimapStrategyLookup:Object = new Object();
      
      public function MinimapStrategyFactory()
      {
         super();
         this._minimapStrategyLookup[MinimapStrategyModule.MINIMAPSTRATEGY_DEFAULT] = StdMinimapColorStrategy;
         this._minimapStrategyLookup[MinimapStrategyModule.MINIMAPSTRATEGY_RED_AND_BLUE] = RedAndBlueColorStrategy;
         this._minimapStrategyLookup[MinimapStrategyModule.MINIMAPSTRATEGY_COMPANY_COLORS] = CompanyColorStrategy;
         this._minimapStrategyLookup[MinimapStrategyModule.MINIMAPSTRATEGY_PLAYER_NPC_AND_INVADERS] = PlayerNpcAndInvadersStrategy;
      }
      
      public function build(param1:int) : AbstractMiniMapTrait
      {
         var _loc2_:Class = this._minimapStrategyLookup[param1] as Class || StdMinimapColorStrategy;
         return new _loc2_();
      }
   }
}

