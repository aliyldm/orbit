package net.bigpoint.darkorbit.map.hud
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   
   public class AbstractHUDElement extends Sprite implements IUpdatable, IDisposable
   {
      
      private static const _tmpPoint:PointLite = new PointLite();
      
      protected var _mapView:IMapView;
      
      protected var _worldPosition:BindablePointLite;
      
      protected var _zoom:Number = 1;
      
      public function AbstractHUDElement(param1:IMapView, param2:BindablePointLite)
      {
         super();
         this._mapView = param1;
         this._worldPosition = param2;
         this._mapView.addUpdatable(this);
      }
      
      public function updateObj(param1:Number) : void
      {
         this._mapView.game2screen(this._worldPosition.x,this._worldPosition.y,this._worldPosition.z,_tmpPoint);
         x = int(_tmpPoint.x);
         y = int(_tmpPoint.y);
         this._zoom = _tmpPoint.z;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this._mapView.removeUpdatable(this);
      }
   }
}

