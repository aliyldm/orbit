package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.RadiationEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class RadiationEffect3D implements IDisposable
   {
      
      private static const URL:String = "radiation_arrow.zip";
      
      private var _effect:RadiationEffect;
      
      private var _arrowParticleEffect:StandaloneParticle3D;
      
      private var showArrow:Boolean;
      
      private var view:MapView3D;
      
      private var _targetShip:Ship;
      
      public function RadiationEffect3D(param1:MapView3D, param2:RadiationEffect)
      {
         super();
         this._effect = param2;
         this.view = param1;
         this.showArrow = this._effect.mapGroupsWithoutArrow.indexOf(Map.getGroupSystemMapName(this.map.mapID)) == -1;
         this._targetShip = this.map.hero;
         if(this.showArrow)
         {
            this._targetShip.position.changed.add(this.handleHeroPosChanged);
         }
         this.updateRadiationHelp();
      }
      
      private function handleHeroPosChanged() : void
      {
         this.setRediationHelpPosition();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._targetShip.position.changed.remove(this.handleHeroPosChanged);
         if(this._arrowParticleEffect)
         {
            this._arrowParticleEffect.disposeView();
         }
      }
      
      private function updateRadiationHelp() : void
      {
         if(this.showArrow)
         {
            this._arrowParticleEffect = new StandaloneParticle3D(this._effect,URL,ScreenManager.getInstance().map.hero.position);
            this._arrowParticleEffect.offset3D.setTo(0,100,0);
            this.setRediationHelpPosition();
         }
      }
      
      private function setRediationHelpPosition() : void
      {
         if(this._arrowParticleEffect.view != null)
         {
            TweenLite.to(this._arrowParticleEffect.view,0.1,{"shortRotation":{"rotationY":this.calculateTargetRotation() - 270}});
         }
      }
      
      private function calculateTargetRotation() : Number
      {
         var _loc1_:PointLite = null;
         if(this._targetShip.x >= 1000 && this._targetShip.x <= this.map.serious_width - 1000 && this._targetShip.y >= 1000 && this._targetShip.y <= this.map.serious_height - 1000)
         {
            _loc1_ = new PointLite(this.map.serious_width / 2,this.map.serious_height / 2);
         }
         else
         {
            _loc1_ = new PointLite(this.clamp(this._targetShip.x,1000,this.map.serious_width - 1000),this.clamp(this._targetShip.y,1000,this.map.serious_height - 1000));
         }
         return Math.atan2(_loc1_.y - this._targetShip.y,_loc1_.x - this._targetShip.x) * (360 / (2 * Math.PI));
      }
      
      private function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}

