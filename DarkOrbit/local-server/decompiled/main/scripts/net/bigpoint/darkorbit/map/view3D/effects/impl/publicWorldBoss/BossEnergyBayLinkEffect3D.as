package net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.ChainBoltPositionProvider;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.BeamEffect3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.StandaloneParticle3D;
   
   public class BossEnergyBayLinkEffect3D implements IDisposable
   {
      
      private static const URL_BOLT_CORNER:String = "boss.awp";
      
      private static const URL_SHIELD_LINK:* = "BossEnergyBayShieldLink.awp";
      
      private var _mapView:MapView3D;
      
      private var _effect:AbstractBoltEffect;
      
      private var _positionProvider:ChainBoltPositionProvider;
      
      private var _effects:Vector.<StandaloneParticle3D> = new Vector.<StandaloneParticle3D>();
      
      public function BossEnergyBayLinkEffect3D(param1:MapView3D, param2:AbstractBoltEffect)
      {
         super();
         this._mapView = param1;
         this._effect = param2;
         this._positionProvider = new ChainBoltPositionProvider(param2.chainArray,param2.attacker);
         this.initEffectVisuals();
      }
      
      private function initEffectVisuals() : void
      {
         var _loc1_:int = int(this._positionProvider.positions.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TweenMax.delayedCall(_loc2_ * 0.2,this.addBolt,[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addBolt(param1:int) : void
      {
         var _loc2_:BindablePointLite = param1 <= 0 ? this._effect.attacker.position : this._positionProvider.positions[param1 - 1];
         var _loc3_:BindablePointLite = this._positionProvider.positions[param1];
         this._effects.push(new BeamEffect3D(this._effect,URL_SHIELD_LINK,_loc2_,_loc3_,0.1,true));
         this._effects.push(new StandaloneParticle3D(this._effect,URL_BOLT_CORNER,_loc3_));
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:int = int(this._effects.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this._effects[_loc3_].disposeView();
            _loc3_++;
         }
      }
   }
}

