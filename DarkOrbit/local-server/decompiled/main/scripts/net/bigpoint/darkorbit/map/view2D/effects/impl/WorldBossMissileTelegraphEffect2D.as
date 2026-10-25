package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.WorldBossMissileTelegraphEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   
   public class WorldBossMissileTelegraphEffect2D implements IDisposable
   {
      
      private static const LOGGER:ILogger = Log.getLogger("WorldBossMissileTelegraphEffect2D");
      
      private var _effect:WorldBossMissileTelegraphEffect;
      
      private var _mapView:MapView2D;
      
      private var _emitters:Vector.<WorldBossMissileTelegraphEmitter2D> = new Vector.<WorldBossMissileTelegraphEmitter2D>();
      
      public function WorldBossMissileTelegraphEffect2D(param1:MapView2D, param2:WorldBossMissileTelegraphEffect)
      {
         super();
         this._effect = param2;
         this._mapView = param1;
         this.initEffectVisuals();
      }
      
      protected function initEffectVisuals() : void
      {
         if(this._effect.positions == null || this._effect.positions.length == 0)
         {
            LOGGER.error("ERROR - Shouldn\'t be creating world boss missile telegraph without coordinates");
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._effect.positions.length)
         {
            this._emitters.push(new WorldBossMissileTelegraphEmitter2D(this._mapView,this._effect,_loc1_));
            _loc1_ += 2;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._emitters.length)
         {
            this._emitters[_loc2_].disposeView(param1);
            _loc2_++;
         }
         this._emitters = new Vector.<WorldBossMissileTelegraphEmitter2D>(0);
      }
   }
}

