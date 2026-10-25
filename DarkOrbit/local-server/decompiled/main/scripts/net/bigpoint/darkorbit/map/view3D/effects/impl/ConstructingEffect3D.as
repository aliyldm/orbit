package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.ConstructingEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class ConstructingEffect3D implements IUpdatable, IDisposable
   {
      
      private var _uberAsset:UberAsset3D;
      
      private var _effect:ConstructingEffect;
      
      public function ConstructingEffect3D(param1:MapView3D, param2:ConstructingEffect)
      {
         super();
         this._effect = param2;
         this._uberAsset = new UberAsset3D(UberAssetsLib.instance.getDescriptor("cbs-construction",UberAssetsLib.LIB_BATTLE_STATION).display3D[0]);
         this._uberAsset.ready.add(this.assetReady);
         World3D.instance.mapView.gameWorld.addChild(this._uberAsset);
      }
      
      private function assetReady() : void
      {
         World3D.instance.mapView.addUpdatable(this);
      }
      
      public function updateObj(param1:Number) : void
      {
         this._uberAsset.moveTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._uberAsset)
         {
            this._uberAsset.disposeView(param1);
            this._uberAsset = null;
         }
         World3D.instance.mapView.removeUpdatable(this);
      }
   }
}

