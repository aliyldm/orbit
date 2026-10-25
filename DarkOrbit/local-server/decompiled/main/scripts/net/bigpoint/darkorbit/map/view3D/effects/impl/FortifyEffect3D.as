package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.impl.FortifyEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class FortifyEffect3D implements IUpdatable, IDisposable
   {
      
      private var _uber:UberAsset3D;
      
      private var _citadel:UberAsset3D;
      
      private var _effect:FortifyEffect;
      
      private var _shipView:MapUberAsset3D;
      
      public function FortifyEffect3D(param1:MapView3D, param2:FortifyEffect)
      {
         super();
         this._effect = param2;
         this._uber = new UberAsset3D(UberAssetsLib.instance.getDescriptor("citadel_fortify",UberAssetsLib.LIB_SHIPS).display3D[0]);
         this._uber.ready.add(this.handleUberReady);
         this._shipView = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         if(String(this._shipView.descriptor.@citadel) != "true")
         {
            this._citadel = new UberAsset3D(UberAssetsLib.instance.getDescriptor("ship_citadel",UberAssetsLib.LIB_SHIPS).display3D[0]);
            this._citadel.visible = false;
            this._uber.addChild(this._citadel);
         }
         Ship(this._effect.source).lockPattern();
         World3D.instance.mapView.addUpdatable(this);
         World3D.instance.mapView.gameWorld.addChild(this._uber);
      }
      
      public function updateObj(param1:Number) : void
      {
         this._uber.rotationY = Ship(this._effect.source).rotation.degrees - 90;
         this._uber.moveTo(this._effect.source.x3D,this._effect.source.y3D,this._effect.source.z3D);
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         Ship(this._effect.source).unlockPattern();
         if(this._uber)
         {
            this._uber.playAnimation("close",this.handleCloseAnimationFinished);
         }
      }
      
      private function handleUberReady() : void
      {
         if(this._shipView)
         {
            if(this._citadel)
            {
               this._citadel.visible = true;
               this._shipView.visible = false;
            }
            this._shipView.disableFloating();
         }
         this._uber.playAnimation("open");
      }
      
      private function handleCloseAnimationFinished() : void
      {
         if(this._shipView)
         {
            if(this._citadel)
            {
               this._citadel.disposeView(true);
               this._citadel = null;
            }
            this._shipView.visible = true;
            this._shipView.enableFloating();
         }
         if(this._uber)
         {
            World3D.instance.mapView.removeUpdatable(this);
            this._uber.ready.remove(this.handleUberReady);
            this._uber.disposeView(true);
            this._uber = null;
         }
      }
   }
}

