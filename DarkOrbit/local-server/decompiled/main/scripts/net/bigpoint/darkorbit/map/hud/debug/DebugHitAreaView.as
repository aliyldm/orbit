package net.bigpoint.darkorbit.map.hud.debug
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.hud.*;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   
   public class DebugHitAreaView extends AbstractHUDElement
   {
      
      private var _trait:MouseHitAreaTrait;
      
      public function DebugHitAreaView(param1:IMapView, param2:MouseHitAreaTrait)
      {
         var mapView:IMapView = param1;
         var trait:MouseHitAreaTrait = param2;
         super(mapView,trait.owner.position);
         this._trait = trait;
         with(graphics)
         {
            lineStyle(2,16711680,1);
            beginFill(1123020,0.3);
            drawCircle(0,0,trait.clickRadius);
            endFill();
         }
      }
      
      override public function updateObj(param1:Number) : void
      {
         var _loc2_:PointLite = this._trait.getScreenPosition(_mapView);
         x = _loc2_.x;
         y = _loc2_.y;
      }
   }
}

