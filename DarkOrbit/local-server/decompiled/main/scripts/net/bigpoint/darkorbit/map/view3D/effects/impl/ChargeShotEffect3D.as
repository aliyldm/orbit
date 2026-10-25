package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.impl.ChargeShotEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.ShipView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Slot3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   
   public class ChargeShotEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "charge_shot.zip";
      
      private var _ship:Ship;
      
      private var _ship3DLoader:ShipView3D;
      
      private var _ship3D:MapUberAsset3D;
      
      private var _laserPosition:Slot3D;
      
      private const _particleZOffSet:Number = 30;
      
      public function ChargeShotEffect3D(param1:MapView3D, param2:ChargeShotEffect)
      {
         this._ship = param2.source as Ship;
         this._ship3D = param1.mainContainer.getViewByTrait(this._ship.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         super(param2,URL,param2.source.position);
      }
      
      override protected function initAndPlay() : void
      {
         var _loc1_:UberMesh3D = null;
         super.initAndPlay();
         if(this._ship3D.uberMeshes.length > 0)
         {
            _loc1_ = this._ship3D.uberMeshes[0];
            this._ship3DLoader = ShipView3D(_loc1_.mesh);
            _loc1_.addChild(view);
            this._laserPosition = this._ship3DLoader.lasersSlots["centerFront"];
         }
         fixedScale = 0.3;
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         if(this._laserPosition)
         {
            view.moveTo(this._laserPosition.x,this._laserPosition.y,this._laserPosition.z + this._particleZOffSet);
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._laserPosition)
         {
            this._laserPosition = null;
         }
         super.disposeView(param1);
      }
   }
}

