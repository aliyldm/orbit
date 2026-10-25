package net.bigpoint.darkorbit.map.view2D.effects
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.ShipDisplayTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   
   public class AbstractMapObjectEffect2D extends AbstractEffect2D
   {
      
      public function AbstractMapObjectEffect2D(param1:MapView2D, param2:MapObjectEffect, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false)
      {
         super(param1,param2,param3);
         if(param5)
         {
            if(this.mapObjectView)
            {
               if(param4)
               {
                  this.mapObjectView.addChild(this);
               }
               else
               {
                  this.mapObjectView.addChildAt(this,0);
               }
            }
         }
         else
         {
            this.mapObject.position.changed.add(this.handlePositionChanged);
            this.handlePositionChanged();
            param1.fxLayer.addChild(this);
         }
      }
      
      protected function get mapObject() : MapEntity
      {
         return (effect as MapObjectEffect).source;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this.mapObject)
         {
            this.mapObject.position.changed.remove(this.handlePositionChanged);
         }
         super.disposeView(param1);
      }
      
      protected function handlePositionChanged() : void
      {
         if(this.mapObject)
         {
            this.x = this.mapObject.position.x;
            this.y = this.mapObject.position.y;
         }
      }
      
      protected function get mapObjectView() : Sprite
      {
         return (mapView.entitiesLayer.getViewByTrait(this.mapObject.getFirstTrait(ShipDisplayTrait)) || mapView.entitiesLayer.getViewByTrait(this.mapObject.getFirstTrait(UberDisplayTrait))) as Sprite;
      }
   }
}

