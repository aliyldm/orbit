package net.bigpoint.darkorbit.map.view3D.display3D.ship
{
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ExpansionPattern;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.weapons.ILaserPositionProvider;
   import net.bigpoint.darkorbit.map.model.traits.weapons.LaserCannon;
   import net.bigpoint.darkorbit.map.view3D.display3D.prefab.ShipView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberMesh3D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class Lasers3D implements ILaserPositionProvider
   {
      
      private var _ship:Ship;
      
      private var _lasersData:LaserCannon;
      
      private var _viewOwner:Ship3D;
      
      private var _ship3DLoader:ShipView3D;
      
      private const _tmpIn:Vector.<Number> = new Vector.<Number>(3,true);
      
      private const _tmpOut:Vector.<Number> = new Vector.<Number>(3,true);
      
      public function Lasers3D(param1:AttackerTrait, param2:Ship3D)
      {
         super();
         this._ship = param1.owner as Ship;
         this._viewOwner = param2;
         this._lasersData = (this._ship.getFirstTrait(AttackerTrait) as AttackerTrait).laser;
         this._lasersData.positionsProvider = this;
         this.updateProvider();
      }
      
      public function dispose() : void
      {
         if(this._lasersData.positionsProvider == this)
         {
            this._lasersData.positionsProvider = null;
         }
      }
      
      private function updateProvider() : void
      {
         if(this._ship.shipPattern.hasExpansion() && Boolean(this.mesh3D))
         {
            this._ship3DLoader = this.mesh3D.mesh as ShipView3D;
         }
         else
         {
            this._ship3DLoader = null;
         }
      }
      
      public function getSalvos() : Vector.<Vector.<String>>
      {
         var _loc1_:ExpansionPattern = this.expansionPattern;
         return _loc1_ ? _loc1_.salvos : null;
      }
      
      public function getLaserCannonSlot(param1:String) : Vector3D
      {
         return this._ship3DLoader ? this._ship3DLoader.getLaserSlot(param1) : null;
      }
      
      public function get mesh3D() : UberMesh3D
      {
         return this._viewOwner.view ? (this._viewOwner.view.uberMeshes.length > 0 ? this._viewOwner.view.uberMeshes[0] : null) : null;
      }
      
      public function getLaserCannonLocalPosition(param1:String, param2:Vector3D, param3:Number = NaN) : void
      {
         var _loc4_:Slot3D = this._ship3DLoader ? this._ship3DLoader.getLaserSlot(param1) : null;
         if(_loc4_)
         {
            this._tmpIn[0] = _loc4_.x;
            this._tmpIn[1] = _loc4_.y;
            this._tmpIn[2] = _loc4_.z;
            this.mesh3D.sceneTransform.transformVectors(this._tmpIn,this._tmpOut);
            param2.x = this._tmpOut[0] - this._ship.x3D;
            param2.y = this._tmpOut[1] - this._ship.y3D;
            param2.z = this._tmpOut[2] - this._ship.z3D;
         }
         else
         {
            param2.x = 0;
            param2.y = 0;
            param2.z = 0;
         }
      }
      
      private function get expansionPattern() : ExpansionPattern
      {
         if(!this._ship.shipPattern.hasExpansion())
         {
            return null;
         }
         var _loc1_:Array = PatternManager.expansionClasses[this._ship.shipPattern.expansionClassID];
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:* = int(Math.max(1,Math.min(4,this._ship.laserExpansionStage.value)));
         while(_loc2_ > 1 && !_loc1_[_loc2_])
         {
            _loc2_--;
         }
         return _loc1_[_loc2_] || _loc1_[0];
      }
   }
}

