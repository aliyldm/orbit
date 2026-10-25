package net.bigpoint.darkorbit.map.view3D.display3D.decorators.trait
{
   import net.bigpoint.darkorbit.ctb.BeaconTrait;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class BeaconDecorator3D implements IDisposable
   {
      
      private var _trait:BeaconTrait;
      
      private var _viewOwner:MapUberAsset3D;
      
      private var _asset:UberAsset3D;
      
      public function BeaconDecorator3D(param1:BeaconTrait, param2:MapUberAsset3D)
      {
         super();
         this._trait = param1;
         this._viewOwner = param2;
         this._trait.beaconID.changed.add(this.updateBeaconView);
         this.updateBeaconView();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._asset)
         {
            this._asset.disposeView();
            if(this._asset.parent)
            {
               this._asset.parent.removeChild(this._asset);
            }
         }
         if(this._trait)
         {
            this._trait.beaconID.changed.remove(this.updateBeaconView);
            this._trait = null;
         }
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
            this._asset = new UberAsset3D(_loc1_.display3D[0]);
            this._asset.scaleX = this._asset.scaleY = this._asset.scaleZ = 0.7;
            this._asset.y = 120;
            this._viewOwner.addChild(this._asset);
         }
      }
   }
}

