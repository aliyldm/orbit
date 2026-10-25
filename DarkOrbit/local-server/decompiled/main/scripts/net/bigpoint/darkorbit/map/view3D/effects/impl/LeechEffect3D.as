package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.core.math.MathConsts;
   import flash.geom.Vector3D;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.LeechEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   public class LeechEffect3D implements IUpdatable
   {
      
      private static const URL:String = "testLifeSteal.zip";
      
      private static const URL_2:String = "testLifeSteal2.zip";
      
      private static var MAX_TIME:Number = 0.5;
      
      private var _tmpSourcePos:Vector3D = new Vector3D();
      
      private var _tmpTargetPos:Vector3D = new Vector3D();
      
      private var _effect:LeechEffect;
      
      private var _firstLeech:StandaloneParticle3D;
      
      private var _seccondLeech:StandaloneParticle3D;
      
      private var _currentTime:Number = 0;
      
      internal var spawnPosition:Vector3D;
      
      public function LeechEffect3D(param1:MapView3D, param2:LeechEffect)
      {
         super();
         this._effect = param2;
         this._firstLeech = new StandaloneParticle3D(this._effect,URL,this._effect.source.position,this._effect.target);
         this._firstLeech.addEvent("spawn",this.startNextEffect);
         this._firstLeech.ready.add(this.firstReady);
      }
      
      private function firstReady() : void
      {
         this._firstLeech.ready.remove(this.firstReady);
         var _loc1_:Number = this._effect.target.z3D - this._effect.source.z3D;
         var _loc2_:Number = this._effect.target.x3D - this._effect.source.x3D;
         this._firstLeech.view.rotationY = Math.atan2(_loc2_,_loc1_) * MathConsts.RADIANS_TO_DEGREES - 90;
      }
      
      private function startNextEffect() : void
      {
         this._firstLeech.completed.remove(this.startNextEffect);
         var _loc1_:Number = this._effect.target.z3D - this._effect.source.z3D;
         var _loc2_:Number = this._effect.target.x3D - this._effect.source.x3D;
         var _loc3_:Vector3D = new Vector3D(_loc2_,0,_loc1_);
         _loc3_.normalize();
         _loc3_.scaleBy(300);
         this._tmpSourcePos.setTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
         this.spawnPosition = this._tmpSourcePos.add(_loc3_);
         this._seccondLeech = new StandaloneParticle3D(this._effect,URL_2,null);
         this._seccondLeech.ready.add(this.secceondReady);
      }
      
      private function secceondReady() : void
      {
         this._seccondLeech.ready.remove(this.secceondReady);
         this._seccondLeech.view.position = new Vector3D(this._tmpSourcePos.x,this._tmpSourcePos.y,this._tmpSourcePos.z);
         setTimeout(this.dispose,MAX_TIME * 1000);
         World3D.instance.mapView.addUpdatable(this);
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:Vector3D = null;
         this._tmpTargetPos.setTo(this._effect.target.x3D,this._effect.target.y3D,this._effect.target.z3D);
         this._tmpSourcePos.setTo(this.spawnPosition.x,this.spawnPosition.y,this.spawnPosition.z);
         if(this._seccondLeech.view)
         {
            if(this._currentTime < MAX_TIME)
            {
               this._currentTime += param1;
               _loc2_ = this._tmpTargetPos.subtract(this._tmpSourcePos);
               _loc2_.scaleBy(this._currentTime / MAX_TIME);
               this._seccondLeech.view.position = this._tmpSourcePos.add(_loc2_);
            }
            else
            {
               this._seccondLeech.disposeView(true);
            }
         }
      }
      
      private function dispose() : void
      {
         this._seccondLeech.disposeView(true);
         World3D.instance.mapView.removeUpdatable(this);
      }
   }
}

