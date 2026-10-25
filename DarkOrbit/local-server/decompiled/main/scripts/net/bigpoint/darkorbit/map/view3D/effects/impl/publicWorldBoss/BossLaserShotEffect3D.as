package net.bigpoint.darkorbit.map.view3D.effects.impl.publicWorldBoss
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserShotEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.CrossTargetBeamEffect3D;
   
   public class BossLaserShotEffect3D implements IDisposable
   {
      
      private var _mapView:MapView3D;
      
      private var _effect:BossLaserShotEffect;
      
      private var _visualEffects:Array = [];
      
      public function BossLaserShotEffect3D(param1:MapView3D, param2:BossLaserShotEffect)
      {
         super();
         this._mapView = param1;
         this._effect = param2;
         this.addBolt(param2.source.position,new BindablePointLite(param2.targetPosition.x,param2.targetPosition.y,param2.targetPosition.z));
      }
      
      protected function addBolt(param1:BindablePointLite, param2:BindablePointLite) : void
      {
         var _loc3_:String = "BossLaserShot.awp";
         var _loc4_:* = new CrossTargetBeamEffect3D(this._mapView,this._effect,this._effect.source,null,_loc3_,param2);
         this._visualEffects.push(_loc4_);
         TweenMax.delayedCall(3,this.disposeView);
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._visualEffects.length)
         {
            this._visualEffects[_loc2_].disposeView();
            _loc2_++;
         }
      }
   }
}

