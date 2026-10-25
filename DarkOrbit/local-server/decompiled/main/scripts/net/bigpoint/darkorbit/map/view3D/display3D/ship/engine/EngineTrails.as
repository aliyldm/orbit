package net.bigpoint.darkorbit.map.view3D.display3D.ship.engine
{
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Geometry;
   import away3d.entities.Mesh;
   import away3d.primitives.PlaneGeometry;
   import com.bigpoint.utils.bindables.BindableRotation;
   import flash.geom.ColorTransform;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.view3D.display3D.ship.Slot3D;
   
   public class EngineTrails extends Mesh implements IUpdatable
   {
      
      private static const MATERIAL:EngineTrailMaterial = new EngineTrailMaterial();
      
      private static const GEOMETRY:Geometry = new PlaneGeometry();
      
      private var _container:ObjectContainer3D;
      
      private var _slots:Vector.<Slot3D>;
      
      private var _rotation:BindableRotation;
      
      private var _trailData:Vector.<Number>;
      
      private var _sampleInverval:Number;
      
      private const _tmp:Vector3D = new Vector3D();
      
      private var _prevPosition:Vector3D = new Vector3D();
      
      private var _accumulator:Number = 0;
      
      private const _tmpIn:Vector.<Number> = new Vector.<Number>(3,true);
      
      private const _tmpOut:Vector.<Number> = new Vector.<Number>(3,true);
      
      public function EngineTrails(param1:ObjectContainer3D, param2:Vector.<Slot3D>, param3:BindableRotation, param4:uint = 5948376, param5:Number = 1, param6:Number = 1)
      {
         this._container = param1;
         this._slots = param2.concat();
         this._rotation = param3;
         super(GEOMETRY,MATERIAL);
         this._trailData = new Vector.<Number>(EngineTrailMaterial.SEGMENTS_PER_TRAIL * 8 * param2.length,true);
         param5 /= 3;
         this._sampleInverval = param5 / EngineTrailMaterial.SEGMENTS_PER_TRAIL;
         this.shaderParams = {
            "trailThickness":3 * param6,
            "colorTransform":new ColorTransform(),
            "trailsNum":this._slots.length,
            "trailData":this._trailData,
            "t":0,
            "timeScale":param5
         };
         this.color = param4;
      }
      
      public function set color(param1:uint) : void
      {
         shaderParams.colorTransform.color = param1;
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         if(this._container.scene == null)
         {
            return;
         }
         shaderParams.t += param1;
         this._accumulator += param1;
         var _loc2_:Vector3D = this._container.scenePosition;
         moveTo(_loc2_.x,_loc2_.y,_loc2_.z);
         var _loc3_:Number = _loc2_.x - this._prevPosition.x;
         var _loc4_:Number = _loc2_.y - this._prevPosition.y;
         var _loc5_:Number = _loc2_.z - this._prevPosition.z;
         var _loc6_:Boolean = _loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_ > 2500;
         this._prevPosition.copyFrom(_loc2_);
         if(_loc6_ || this._accumulator > this._sampleInverval)
         {
            this._accumulator = 0;
            _loc7_ = int(this._slots.length - 1);
            while(_loc7_ >= 0)
            {
               if(_loc6_)
               {
                  this.getSlotGlobalPosition(this._slots[_loc7_],this._tmp);
               }
               _loc9_ = int(EngineTrailMaterial.SEGMENTS_PER_TRAIL - 1);
               while(_loc9_ > 0)
               {
                  _loc8_ = (_loc7_ * EngineTrailMaterial.SEGMENTS_PER_TRAIL + _loc9_) * 8;
                  this._trailData[_loc8_ + 0] = _loc6_ ? this._tmp.x : this._trailData[_loc8_ + 0 - 8];
                  this._trailData[_loc8_ + 1] = _loc6_ ? this._tmp.y : this._trailData[_loc8_ + 1 - 8];
                  this._trailData[_loc8_ + 2] = _loc6_ ? this._tmp.z : this._trailData[_loc8_ + 2 - 8];
                  this._trailData[_loc8_ + 3] = _loc6_ ? -this._rotation.radians : this._trailData[_loc8_ + 3 - 8];
                  this._trailData[_loc8_ + 4] = _loc6_ ? 0 : this._trailData[_loc8_ + 4 - 8];
                  _loc9_--;
               }
               _loc7_--;
            }
         }
         _loc7_ = int(this._slots.length - 1);
         while(_loc7_ >= 0)
         {
            this.getSlotGlobalPosition(this._slots[_loc7_],this._tmp);
            _loc8_ = _loc7_ * EngineTrailMaterial.SEGMENTS_PER_TRAIL * 8;
            this._trailData[_loc8_ + 0] = this._tmp.x;
            this._trailData[_loc8_ + 1] = this._tmp.y;
            this._trailData[_loc8_ + 2] = this._tmp.z;
            this._trailData[_loc8_ + 3] = -this._rotation.radians;
            this._trailData[_loc8_ + 4] = shaderParams.t;
            _loc7_--;
         }
      }
      
      private function getSlotGlobalPosition(param1:Slot3D, param2:Vector3D) : void
      {
         this._tmpIn[0] = param1.x;
         this._tmpIn[1] = param1.y;
         this._tmpIn[2] = param1.z;
         this._container.sceneTransform.transformVectors(this._tmpIn,this._tmpOut);
         param2.x = this._tmpOut[0];
         param2.y = this._tmpOut[1];
         param2.z = this._tmpOut[2];
      }
   }
}

