package net.bigpoint.darkorbit.map.hud.ship
{
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.ILayerChild;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   
   public class HealthInfoHUD extends AbstractHUDElement implements ILayerChild
   {
      
      private var _trait:HPTrait;
      
      private var _healthInfoDisplay:HealthInfoDisplay;
      
      public function HealthInfoHUD(param1:IMapView, param2:HPTrait)
      {
         this._trait = param2;
         super(param1,param2.owner.position);
         if(param2.owner.getFirstTrait(MapObjectInfoTrait) != null)
         {
            return;
         }
         this._healthInfoDisplay = new HealthInfoDisplay(param2);
         this._healthInfoDisplay.visible = true;
         this._healthInfoDisplay.x = -this._healthInfoDisplay.config.width / 2;
         var _loc3_:MouseHitAreaTrait = param2.owner.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait;
         if(_loc3_)
         {
            this._healthInfoDisplay.y = -_loc3_.clickRadius;
         }
         addChild(this._healthInfoDisplay);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._healthInfoDisplay)
         {
            this._healthInfoDisplay.disposeView();
         }
         super.disposeView(param1);
      }
      
      public function get layer() : int
      {
         return 0;
      }
   }
}

