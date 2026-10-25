package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.map.model.env.Station;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberDisplayObject2D;
   
   public class HealthStationDecorator2D implements IMapUberAssetDecorator2D
   {
      
      private var _viewOwner:UberAsset2D;
      
      private var _trait:UberDisplayTrait;
      
      public function HealthStationDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._trait = param1;
         this._viewOwner = param2;
         this.updateAnimations();
         param1.state.changed.add(this.updateAnimations);
      }
      
      private function updateAnimations() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:UberDisplayObject2D = this._viewOwner.getViewElement("healthStation") as UberDisplayObject2D;
         if(_loc1_)
         {
            _loc2_ = _loc1_.asset as MovieClip;
            if(this._trait.state.value == Station.STATE_ENABLED)
            {
               _loc2_.cross.alpha = 1;
               _loc2_.topLight.alpha = 1;
               _loc2_.botLight.alpha = 1;
               _loc2_.rightLight.alpha = 1;
               _loc2_.leftLight.alpha = 1;
               _loc2_.yellowCross.alpha = 0;
            }
            else
            {
               _loc2_.cross.alpha = 0;
               _loc2_.topLight.alpha = 0;
               _loc2_.botLight.alpha = 0;
               _loc2_.rightLight.alpha = 0;
               _loc2_.leftLight.alpha = 0;
               _loc2_.yellowCross.alpha = 1;
            }
         }
      }
   }
}

