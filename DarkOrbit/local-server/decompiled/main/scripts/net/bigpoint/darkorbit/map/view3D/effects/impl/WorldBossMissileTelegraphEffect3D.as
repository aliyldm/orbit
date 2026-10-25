package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.WorldBossMissileTelegraphEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class WorldBossMissileTelegraphEffect3D implements IDisposable
   {
      
      private static const PARTICLES_FILE:String = "fx_world-boss_missile-telegraph.zip";
      
      private var _mapView:MapView3D;
      
      private var _effect:WorldBossMissileTelegraphEffect;
      
      private var _effects:Vector.<BeamEffect3D> = new Vector.<BeamEffect3D>();
      
      public function WorldBossMissileTelegraphEffect3D(param1:MapView3D, param2:WorldBossMissileTelegraphEffect)
      {
         super();
         this._mapView = param1;
         this._effect = param2;
         this.initEffectVisuals();
      }
      
      private function initEffectVisuals() : void
      {
         var _loc2_:* = undefined;
         if(this._effect.positions == null || this._effect.positions.length == 0)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._effect.positions.length)
         {
            _loc2_ = new BeamEffect3D(this._effect,PARTICLES_FILE,this._effect.positions[_loc1_],this._effect.positions[_loc1_ + 1],0,false,this._effect.maxDist);
            this._effects.push(_loc2_);
            _loc1_ += 2;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._effects.length)
         {
            this._effects[_loc2_].disposeView();
            _loc2_++;
         }
         this._effects = new Vector.<BeamEffect3D>(0);
      }
   }
}

