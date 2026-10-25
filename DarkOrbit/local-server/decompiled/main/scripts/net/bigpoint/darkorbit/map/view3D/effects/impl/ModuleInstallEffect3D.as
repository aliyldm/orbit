package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.ModuleInstallEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class ModuleInstallEffect3D implements IUpdatable, IDisposable
   {
      
      private var _uberAsset:UberAsset3D;
      
      private var _effect:ModuleInstallEffect;
      
      public function ModuleInstallEffect3D(param1:MapView3D, param2:ModuleInstallEffect)
      {
         super();
         this._uberAsset = new UberAsset3D(UberAssetsLib.instance.getDescriptor("module-construction",UberAssetsLib.LIB_BATTLE_STATION).display3D[0]);
         this._uberAsset.ready.add(this.assetReady);
         this._effect = param2;
         World3D.instance.mapView.gameWorld.addChild(this._uberAsset);
      }
      
      public function updateObj(param1:Number) : void
      {
         this._uberAsset.moveTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._uberAsset)
         {
            this._uberAsset.ready.remove(this.assetReady);
            this._uberAsset.disposeView(param1);
            this._uberAsset = null;
         }
         World3D.instance.mapView.removeUpdatable(this);
      }
      
      private function assetReady() : void
      {
         World3D.instance.mapView.addUpdatable(this);
      }
   }
}

