package net.bigpoint.darkorbit.map.hud.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.effects.impl.PointingArrowEffect;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class PointingArrowEffect2D extends AbstractHUDElement
   {
      
      private static const _tmpTarget:PointLite = new PointLite();
      
      private static const _tmpSource:PointLite = new PointLite();
      
      private var _effect:PointingArrowEffect;
      
      private var _directionArrow:MovieClip;
      
      public function PointingArrowEffect2D(param1:IMapView, param2:PointingArrowEffect)
      {
         this._effect = param2;
         super(param1,new BindablePointLite(param2.sourcePosition.x,param2.sourcePosition.y,0));
         this._directionArrow = ResourceManager.getMovieClip("ui","tutorial_arrow");
         this._directionArrow.mouseEnabled = this._directionArrow.mouseChildren = false;
         this._directionArrow.alpha = 0;
         addChild(this._directionArrow);
         TweenLite.to(this._directionArrow,0.5,{"alpha":1});
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         _mapView.game2screen(this._effect.targetPosition.x,this._effect.targetPosition.y,0,_tmpTarget);
         _mapView.game2screen(this._effect.sourcePosition.x,this._effect.sourcePosition.y,0,_tmpSource);
         this._directionArrow.rotation = Math.atan2(_tmpTarget.y - _tmpSource.y,_tmpTarget.x - _tmpSource.x) * FastMath.RADTODEG;
      }
   }
}

