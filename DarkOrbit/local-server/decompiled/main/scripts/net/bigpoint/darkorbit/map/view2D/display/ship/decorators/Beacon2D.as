package net.bigpoint.darkorbit.map.view2D.display.ship.decorators
{
   import net.bigpoint.darkorbit.ctb.BeaconTrait;
   import net.bigpoint.darkorbit.map.view2D.display.ship.Ship2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class Beacon2D
   {
      
      private var _trait:BeaconTrait;
      
      private var _asset:UberAsset2D;
      
      private var _viewOwner:Ship2D;
      
      public function Beacon2D(param1:BeaconTrait, param2:Ship2D)
      {
         super();
         this._trait = param1;
         this._viewOwner = param2;
         this._trait.beaconID.changed.add(this.updateBeaconView);
         this.updateBeaconView();
      }
      
      private function updateBeaconView() : void
      {
         if(this._asset)
         {
            this._asset.disposeView();
            if(this._asset.parent)
            {
               this._asset.parent.removeChild(this._asset);
            }
         }
         var _loc1_:XML = UberAssetsLib.instance.getDescriptor("beacon_" + this._trait.beaconID.value,UberAssetsLib.LIB_COLLECTABLES);
         if(_loc1_)
         {
            this._asset = new UberAsset2D(_loc1_.display2D[0]);
            this._asset.y = -50;
            this._viewOwner.addChild(this._asset);
         }
      }
   }
}

