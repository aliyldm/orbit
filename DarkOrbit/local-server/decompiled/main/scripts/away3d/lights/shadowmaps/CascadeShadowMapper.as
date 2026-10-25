package away3d.lights.shadowmaps
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.cameras.lenses.FreeMatrixLens;
   import away3d.cameras.lenses.LensBase;
   import away3d.containers.Scene3D;
   import away3d.core.math.Matrix3DUtils;
   import away3d.core.render.DepthRenderer;
   import flash.display3D.textures.TextureBase;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   
   use namespace arcane;
   
   public class CascadeShadowMapper extends DirectionalShadowMapper implements IEventDispatcher
   {
      
      protected var _scissorRects:Vector.<Rectangle>;
      
      private var _scissorRectsInvalid:Boolean = true;
      
      private var _splitRatios:Vector.<Number>;
      
      private var _numCascades:int;
      
      private var _depthCameras:Vector.<Camera3D>;
      
      private var _depthLenses:Vector.<FreeMatrixLens>;
      
      private var _texOffsetsX:Vector.<Number>;
      
      private var _texOffsetsY:Vector.<Number>;
      
      private var _changeDispatcher:EventDispatcher;
      
      private var _nearPlaneDistances:Vector.<Number>;
      
      public function CascadeShadowMapper(param1:uint = 3)
      {
         super();
         if(param1 < 1 || param1 > 4)
         {
            throw new Error("numCascades must be an integer between 1 and 4");
         }
         this._numCascades = param1;
         this._changeDispatcher = new EventDispatcher(this);
         this.init();
      }
      
      public function getSplitRatio(param1:uint) : Number
      {
         return this._splitRatios[param1];
      }
      
      public function setSplitRatio(param1:uint, param2:Number) : void
      {
         if(param2 < 0)
         {
            param2 = 0;
         }
         else if(param2 > 1)
         {
            param2 = 1;
         }
         if(param1 >= this._numCascades)
         {
            throw new Error("index must be smaller than the number of cascades!");
         }
         this._splitRatios[param1] = param2;
      }
      
      public function getDepthProjections(param1:uint) : Matrix3D
      {
         return this._depthCameras[param1].viewProjection;
      }
      
      private function init() : void
      {
         this._splitRatios = new Vector.<Number>(this._numCascades,true);
         this._nearPlaneDistances = new Vector.<Number>(this._numCascades,true);
         var _loc1_:Number = 1;
         var _loc2_:* = int(this._numCascades - 1);
         while(_loc2_ >= 0)
         {
            this._splitRatios[_loc2_] = _loc1_;
            _loc1_ *= 0.4;
            _loc2_--;
         }
         this._texOffsetsX = new <Number>[-1,1,-1,1];
         this._texOffsetsY = new <Number>[1,1,-1,-1];
         this._scissorRects = new Vector.<Rectangle>(4,true);
         this._depthLenses = new Vector.<FreeMatrixLens>();
         this._depthCameras = new Vector.<Camera3D>();
         _loc2_ = 0;
         while(_loc2_ < this._numCascades)
         {
            this._depthLenses[_loc2_] = new FreeMatrixLens();
            this._depthCameras[_loc2_] = new Camera3D(this._depthLenses[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function set depthMapSize(param1:uint) : void
      {
         if(param1 == _depthMapSize)
         {
            return;
         }
         super.depthMapSize = param1;
         this.invalidateScissorRects();
      }
      
      private function invalidateScissorRects() : void
      {
         this._scissorRectsInvalid = true;
      }
      
      public function get numCascades() : int
      {
         return this._numCascades;
      }
      
      public function set numCascades(param1:int) : void
      {
         if(param1 == this._numCascades)
         {
            return;
         }
         if(param1 < 1 || param1 > 4)
         {
            throw new Error("numCascades must be an integer between 1 and 4");
         }
         this._numCascades = param1;
         this.invalidateScissorRects();
         this.init();
         this.dispatchEvent(new Event(Event.CHANGE));
      }
      
      override protected function drawDepthMap(param1:TextureBase, param2:Scene3D, param3:DepthRenderer) : void
      {
         if(this._scissorRectsInvalid)
         {
            this.updateScissorRects();
         }
         _casterCollector.cullPlanes = _cullPlanes;
         _casterCollector.camera = _overallDepthCamera;
         _casterCollector.clear();
         param2.traversePartitions(_casterCollector);
         param3.renderCascades(_casterCollector,param1,this._numCascades,this._scissorRects,this._depthCameras);
         _casterCollector.cleanUp();
      }
      
      private function updateScissorRects() : void
      {
         var _loc1_:Number = _depthMapSize * 0.5;
         this._scissorRects[0] = new Rectangle(0,0,_loc1_,_loc1_);
         this._scissorRects[1] = new Rectangle(_loc1_,0,_loc1_,_loc1_);
         this._scissorRects[2] = new Rectangle(0,_loc1_,_loc1_,_loc1_);
         this._scissorRects[3] = new Rectangle(_loc1_,_loc1_,_loc1_,_loc1_);
         this._scissorRectsInvalid = false;
      }
      
      override protected function updateDepthProjection(param1:Camera3D) : void
      {
         var _loc2_:Matrix3D = null;
         var _loc3_:LensBase = param1.lens;
         var _loc4_:Number = _loc3_.near;
         var _loc5_:Number = _loc3_.far - _loc4_;
         updateProjectionFromFrustumCorners(param1,param1.lens.frustumCorners,_matrix);
         _matrix.appendScale(0.96,0.96,1);
         _overallDepthLens.matrix = _matrix;
         updateCullPlanes(param1);
         var _loc6_:int = 0;
         while(_loc6_ < this._numCascades)
         {
            _loc2_ = this._depthLenses[_loc6_].matrix;
            this._nearPlaneDistances[_loc6_] = _loc4_ + this._splitRatios[_loc6_] * _loc5_;
            this._depthCameras[_loc6_].transform = _overallDepthCamera.transform;
            this.updateProjectionPartition(_loc2_,this._splitRatios[_loc6_],this._texOffsetsX[_loc6_],this._texOffsetsY[_loc6_]);
            this._depthLenses[_loc6_].matrix = _loc2_;
            _loc6_++;
         }
      }
      
      private function updateProjectionPartition(param1:Matrix3D, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc5_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         var _loc12_:Number = Number.POSITIVE_INFINITY;
         var _loc13_:Number = Number.POSITIVE_INFINITY;
         var _loc15_:Number = Number.NEGATIVE_INFINITY;
         var _loc16_:Number = Number.NEGATIVE_INFINITY;
         var _loc17_:Number = Number.NEGATIVE_INFINITY;
         var _loc18_:uint = 0;
         while(_loc18_ < 12)
         {
            _loc6_ = _localFrustum[_loc18_];
            _loc7_ = _localFrustum[uint(_loc18_ + 1)];
            _loc8_ = _localFrustum[uint(_loc18_ + 2)];
            _loc9_ = _loc6_ + (_localFrustum[uint(_loc18_ + 12)] - _loc6_) * param2;
            _loc10_ = _loc7_ + (_localFrustum[uint(_loc18_ + 13)] - _loc7_) * param2;
            _loc11_ = _loc8_ + (_localFrustum[uint(_loc18_ + 14)] - _loc8_) * param2;
            if(_loc6_ < _loc12_)
            {
               _loc12_ = _loc6_;
            }
            if(_loc6_ > _loc15_)
            {
               _loc15_ = _loc6_;
            }
            if(_loc7_ < _loc13_)
            {
               _loc13_ = _loc7_;
            }
            if(_loc7_ > _loc16_)
            {
               _loc16_ = _loc7_;
            }
            if(_loc8_ > _loc17_)
            {
               _loc17_ = _loc8_;
            }
            if(_loc9_ < _loc12_)
            {
               _loc12_ = _loc9_;
            }
            if(_loc9_ > _loc15_)
            {
               _loc15_ = _loc9_;
            }
            if(_loc10_ < _loc13_)
            {
               _loc13_ = _loc10_;
            }
            if(_loc10_ > _loc16_)
            {
               _loc16_ = _loc10_;
            }
            if(_loc11_ > _loc17_)
            {
               _loc17_ = _loc11_;
            }
            _loc18_ += 3;
         }
         _loc14_ = 1;
         var _loc19_:Number = _loc15_ - _loc12_;
         var _loc20_:Number = _loc16_ - _loc13_;
         var _loc21_:Number = 1 / (_loc17_ - _loc14_);
         if(_loc12_ < 0)
         {
            _loc12_ -= _snap;
         }
         if(_loc13_ < 0)
         {
            _loc13_ -= _snap;
         }
         _loc12_ = int(_loc12_ / _snap) * _snap;
         _loc13_ = int(_loc13_ / _snap) * _snap;
         var _loc22_:Number = 2 * _snap;
         _loc19_ = int(_loc19_ / _loc22_ + 1) * _loc22_;
         _loc20_ = int(_loc20_ / _loc22_ + 1) * _loc22_;
         _loc15_ = _loc12_ + _loc19_;
         _loc16_ = _loc13_ + _loc20_;
         _loc19_ = 1 / _loc19_;
         _loc20_ = 1 / _loc20_;
         _loc5_[0] = 2 * _loc19_;
         _loc5_[5] = 2 * _loc20_;
         _loc5_[10] = _loc21_;
         _loc5_[12] = -(_loc15_ + _loc12_) * _loc19_;
         _loc5_[13] = -(_loc16_ + _loc13_) * _loc20_;
         _loc5_[14] = -_loc14_ * _loc21_;
         _loc5_[15] = 1;
         _loc5_[1] = _loc5_[2] = _loc5_[3] = _loc5_[4] = _loc5_[6] = _loc5_[7] = _loc5_[8] = _loc5_[9] = _loc5_[11] = 0;
         param1.copyRawDataFrom(_loc5_);
         param1.appendScale(0.96,0.96,1);
         param1.appendTranslation(param3,param4,0);
         param1.appendScale(0.5,0.5,1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._changeDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._changeDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._changeDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._changeDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._changeDispatcher.willTrigger(param1);
      }
      
      arcane function get nearPlaneDistances() : Vector.<Number>
      {
         return this._nearPlaneDistances;
      }
   }
}

