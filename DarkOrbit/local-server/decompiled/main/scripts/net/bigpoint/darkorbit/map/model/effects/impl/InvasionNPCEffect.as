package net.bigpoint.darkorbit.map.model.effects.impl
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.minimap.StdMinimapColorStrategy;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   
   public class InvasionNPCEffect extends MapObjectEffect
   {
      
      private var _iconTrait:IconTrait;
      
      public function InvasionNPCEffect(param1:Ship)
      {
         super(EffectIDList.INVASION_NPC_EFFECT,param1);
         this._iconTrait = new IconTrait("infiltration");
      }
      
      override public function activate() : Boolean
      {
         source.addTrait(this._iconTrait);
         var _loc1_:StdMinimapColorStrategy = source.getFirstTrait(StdMinimapColorStrategy) as StdMinimapColorStrategy;
         if(_loc1_)
         {
            _loc1_.updateColor();
         }
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         this.removeTrait();
         var _loc1_:StdMinimapColorStrategy = source.getFirstTrait(StdMinimapColorStrategy) as StdMinimapColorStrategy;
         if(_loc1_)
         {
            setTimeout(_loc1_.updateColor,1);
         }
         super.deactivate();
      }
      
      private function removeTrait() : void
      {
         source.removeTrait(this._iconTrait);
      }
   }
}

