package away3d.core.pick
{
   import away3d.arcane;
   import away3d.cameras.*;
   import away3d.containers.*;
   import away3d.core.base.*;
   import away3d.core.data.*;
   import away3d.core.managers.*;
   import away3d.core.math.*;
   import away3d.core.traverse.*;
   import away3d.entities.*;
   import away3d.tools.utils.GeomUtil;
   import com.adobe.utils.*;
   import flash.display.*;
   import flash.display3D.*;
   import flash.display3D.textures.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class ShaderPicker implements IPicker
   {
      
      private static const MOUSE_SCISSOR_RECT:Rectangle = new Rectangle(0,0,1,1);
      
      private var _stage3DProxy:Stage3DProxy;
      
      private var _context:Context3D;
      
      private var _onlyMouseEnabled:Boolean = true;
      
      private var _objectProgram3D:Program3D;
      
      private var _triangleProgram3D:Program3D;
      
      private var _bitmapData:BitmapData;
      
      private var _viewportData:Vector.<Number>;
      
      private var _boundOffsetScale:Vector.<Number>;
      
      private var _id:Vector.<Number>;
      
      private var _interactives:Vector.<IRenderable> = new Vector.<IRenderable>();
      
      private var _interactiveId:uint;
      
      private var _hitColor:uint;
      
      private var _projX:Number;
      
      private var _projY:Number;
      
      private var _hitRenderable:IRenderable;
      
      private var _hitEntity:Entity;
      
      private var _localHitPosition:Vector3D = new Vector3D();
      
      private var _hitUV:Point = new Point();
      
      private var _faceIndex:uint;
      
      private var _subGeometryIndex:uint;
      
      private var _localHitNormal:Vector3D = new Vector3D();
      
      private var _rayPos:Vector3D = new Vector3D();
      
      private var _rayDir:Vector3D = new Vector3D();
      
      private var _potentialFound:Boolean;
      
      public function ShaderPicker()
      {
         super();
         this._id = new Vector.<Number>(4,true);
         this._viewportData = new Vector.<Number>(4,true);
         this._boundOffsetScale = new Vector.<Number>(8,true);
         this._boundOffsetScale[3] = 0;
         this._boundOffsetScale[7] = 1;
      }
      
      public function get onlyMouseEnabled() : Boolean
      {
         return this._onlyMouseEnabled;
      }
      
      public function set onlyMouseEnabled(param1:Boolean) : void
      {
         this._onlyMouseEnabled = param1;
      }
      
      public function getViewCollision(param1:Number, param2:Number, param3:View3D) : PickingCollisionVO
      {
         var _loc4_:EntityCollector = param3.entityCollector;
         this._stage3DProxy = param3.stage3DProxy;
         if(!this._stage3DProxy)
         {
            return null;
         }
         this._context = this._stage3DProxy._context3D;
         this._viewportData[0] = param3.width;
         this._viewportData[1] = param3.height;
         this._viewportData[2] = -(this._projX = 2 * param1 / param3.width - 1);
         this._viewportData[3] = this._projY = 2 * param2 / param3.height - 1;
         this._potentialFound = false;
         this.draw(_loc4_,null);
         this._context.setVertexBufferAt(0,null);
         if(!this._context || !this._potentialFound)
         {
            return null;
         }
         if(!this._bitmapData)
         {
            this._bitmapData = new BitmapData(1,1,false,0);
         }
         this._context.drawToBitmapData(this._bitmapData);
         this._hitColor = this._bitmapData.getPixel(0,0);
         if(!this._hitColor)
         {
            this._context.present();
            return null;
         }
         this._hitRenderable = this._interactives[this._hitColor - 1];
         this._hitEntity = this._hitRenderable.sourceEntity;
         if(this._onlyMouseEnabled && (!this._hitEntity._ancestorsAllowMouseEnabled || !this._hitEntity.mouseEnabled))
         {
            return null;
         }
         var _loc5_:PickingCollisionVO = this._hitEntity.pickingCollisionVO;
         if(this._hitRenderable.shaderPickingDetails)
         {
            this.getHitDetails(param3.camera);
            _loc5_.localPosition = this._localHitPosition;
            _loc5_.localNormal = this._localHitNormal;
            _loc5_.uv = this._hitUV;
            _loc5_.index = this._faceIndex;
            _loc5_.subGeometryIndex = this._subGeometryIndex;
         }
         else
         {
            _loc5_.localPosition = null;
            _loc5_.localNormal = null;
            _loc5_.uv = null;
            _loc5_.index = 0;
            _loc5_.subGeometryIndex = 0;
         }
         return _loc5_;
      }
      
      public function getSceneCollision(param1:Vector3D, param2:Vector3D, param3:Scene3D) : PickingCollisionVO
      {
         return null;
      }
      
      protected function draw(param1:EntityCollector, param2:TextureBase) : void
      {
         var _loc3_:Camera3D = param1.camera;
         this._context.clear(0,0,0,1);
         this._stage3DProxy.scissorRect = MOUSE_SCISSOR_RECT;
         this._interactives.length = this._interactiveId = 0;
         if(!this._objectProgram3D)
         {
            this.initObjectProgram3D();
         }
         this._context.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         this._context.setDepthTest(true,Context3DCompareMode.LESS);
         this._context.setProgram(this._objectProgram3D);
         this._context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this._viewportData,1);
         this.drawRenderables(param1.opaqueRenderableHead,_loc3_);
         this.drawRenderables(param1.blendedRenderableHead,_loc3_);
      }
      
      private function drawRenderables(param1:RenderableListItem, param2:Camera3D) : void
      {
         var _loc4_:IRenderable = null;
         var _loc3_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
         var _loc5_:Matrix3D = param2.viewProjection;
         while(param1)
         {
            _loc4_ = param1.renderable;
            if(!_loc4_.sourceEntity.scene || !_loc4_.mouseEnabled && this._onlyMouseEnabled)
            {
               param1 = param1.next;
            }
            else
            {
               this._potentialFound = true;
               this._context.setCulling(Boolean(_loc4_.material) && Boolean(_loc4_.material.bothSides) ? Context3DTriangleFace.NONE : Context3DTriangleFace.BACK);
               var _loc6_:Number;
               this._interactives[_loc6_ = this._interactiveId++] = _loc4_;
               this._id[1] = (this._interactiveId >> 8) / 255;
               this._id[2] = (this._interactiveId & 0xFF) / 255;
               _loc3_.copyFrom(_loc4_.getRenderSceneTransform(param2));
               _loc3_.append(_loc5_);
               this._context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc3_,true);
               this._context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._id,1);
               _loc4_.activateVertexBuffer(0,this._stage3DProxy);
               this._context.drawTriangles(_loc4_.getIndexBuffer(this._stage3DProxy),0,_loc4_.numTriangles);
               param1 = param1.next;
            }
         }
      }
      
      private function updateRay(param1:Camera3D) : void
      {
         this._rayPos = param1.scenePosition;
         this._rayDir = param1.getRay(this._projX,this._projY,1);
         this._rayDir.normalize();
      }
      
      private function initObjectProgram3D() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         this._objectProgram3D = this._context.createProgram();
         _loc1_ = "m44 vt0, va0, vc0\t\t\t\n" + "mul vt1.xy, vt0.w, vc4.zw\t\n" + "add vt0.xy, vt0.xy, vt1.xy\t\n" + "mul vt0.xy, vt0.xy, vc4.xy\t\n" + "mov op, vt0\t\n";
         _loc2_ = "mov oc, fc0";
         this._objectProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX,_loc1_),new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT,_loc2_));
      }
      
      private function initTriangleProgram3D() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         this._triangleProgram3D = this._context.createProgram();
         _loc1_ = "add vt0, va0, vc5 \t\t\t\n" + "mul vt0, vt0, vc6 \t\t\t\n" + "mov v0, vt0\t\t\t\t\n" + "m44 vt0, va0, vc0\t\t\t\n" + "mul vt1.xy, vt0.w, vc4.zw\t\n" + "add vt0.xy, vt0.xy, vt1.xy\t\n" + "mul vt0.xy, vt0.xy, vc4.xy\t\n" + "mov op, vt0\t\n";
         _loc2_ = "mov oc, v0";
         this._triangleProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX,_loc1_),new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT,_loc2_));
      }
      
      private function getHitDetails(param1:Camera3D) : void
      {
         this.getApproximatePosition(param1);
         this.getPreciseDetails(param1);
      }
      
      private function getApproximatePosition(param1:Camera3D) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:Entity = this._hitRenderable.sourceEntity;
         var _loc10_:Matrix3D = Matrix3DUtils.CALCULATION_MATRIX;
         _loc10_.copyFrom(this._hitRenderable.getRenderSceneTransform(param1));
         _loc10_.append(param1.viewProjection);
         if(!this._triangleProgram3D)
         {
            this.initTriangleProgram3D();
         }
         this._boundOffsetScale[4] = 1 / (_loc4_ = _loc2_.maxX - _loc2_.minX);
         this._boundOffsetScale[5] = 1 / (_loc5_ = _loc2_.maxY - _loc2_.minY);
         this._boundOffsetScale[6] = 1 / (_loc6_ = _loc2_.maxZ - _loc2_.minZ);
         this._boundOffsetScale[0] = _loc7_ = -_loc2_.minX;
         this._boundOffsetScale[1] = _loc8_ = -_loc2_.minY;
         this._boundOffsetScale[2] = _loc9_ = -_loc2_.minZ;
         this._context.setProgram(this._triangleProgram3D);
         this._context.clear(0,0,0,0,1,0,Context3DClearMask.DEPTH);
         this._context.setScissorRectangle(MOUSE_SCISSOR_RECT);
         this._context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc10_,true);
         this._context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,this._boundOffsetScale,2);
         this._hitRenderable.activateVertexBuffer(0,this._stage3DProxy);
         this._context.drawTriangles(this._hitRenderable.getIndexBuffer(this._stage3DProxy),0,this._hitRenderable.numTriangles);
         this._context.drawToBitmapData(this._bitmapData);
         _loc3_ = this._bitmapData.getPixel(0,0);
         this._localHitPosition.x = (_loc3_ >> 16 & 0xFF) * _loc4_ / 255 - _loc7_;
         this._localHitPosition.y = (_loc3_ >> 8 & 0xFF) * _loc5_ / 255 - _loc8_;
         this._localHitPosition.z = (_loc3_ & 0xFF) * _loc6_ / 255 - _loc9_;
      }
      
      private function getPreciseDetails(param1:Camera3D) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:uint = 0;
         var _loc46_:uint = 0;
         var _loc47_:uint = 0;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc2_:ISubGeometry = SubMesh(this._hitRenderable).subGeometry;
         var _loc3_:Vector.<uint> = _loc2_.indexData;
         var _loc4_:Vector.<Number> = _loc2_.vertexData;
         var _loc5_:int = int(_loc3_.length);
         var _loc15_:uint = 0;
         var _loc16_:uint = 1;
         var _loc17_:uint = 2;
         var _loc38_:Vector.<Number> = _loc2_.UVData;
         var _loc39_:Vector.<Number> = _loc2_.faceNormals;
         var _loc40_:Number = this._localHitPosition.x;
         var _loc41_:Number = this._localHitPosition.y;
         var _loc42_:Number = this._localHitPosition.z;
         var _loc55_:int = int(_loc2_.vertexStride);
         var _loc56_:int = _loc2_.vertexOffset;
         this.updateRay(param1);
         while(_loc15_ < _loc5_)
         {
            _loc18_ = _loc56_ + _loc3_[_loc15_] * _loc55_;
            _loc19_ = _loc56_ + _loc3_[_loc16_] * _loc55_;
            _loc20_ = _loc56_ + _loc3_[_loc17_] * _loc55_;
            _loc6_ = _loc4_[_loc18_];
            _loc7_ = _loc4_[_loc18_ + 1];
            _loc8_ = _loc4_[_loc18_ + 2];
            _loc9_ = _loc4_[_loc19_];
            _loc10_ = _loc4_[_loc19_ + 1];
            _loc11_ = _loc4_[_loc19_ + 2];
            _loc12_ = _loc4_[_loc20_];
            _loc13_ = _loc4_[_loc20_ + 1];
            _loc14_ = _loc4_[_loc20_ + 2];
            if(!(_loc40_ < _loc6_ && _loc40_ < _loc9_ && _loc40_ < _loc12_ || _loc41_ < _loc7_ && _loc41_ < _loc10_ && _loc41_ < _loc13_ || _loc42_ < _loc8_ && _loc42_ < _loc11_ && _loc42_ < _loc14_ || _loc40_ > _loc6_ && _loc40_ > _loc9_ && _loc40_ > _loc12_ || _loc41_ > _loc7_ && _loc41_ > _loc10_ && _loc41_ > _loc13_ || _loc42_ > _loc8_ && _loc42_ > _loc11_ && _loc42_ > _loc14_))
            {
               _loc21_ = _loc12_ - _loc6_;
               _loc22_ = _loc13_ - _loc7_;
               _loc23_ = _loc14_ - _loc8_;
               _loc24_ = _loc9_ - _loc6_;
               _loc25_ = _loc10_ - _loc7_;
               _loc26_ = _loc11_ - _loc8_;
               _loc27_ = _loc40_ - _loc6_;
               _loc28_ = _loc41_ - _loc7_;
               _loc29_ = _loc42_ - _loc8_;
               _loc30_ = _loc21_ * _loc21_ + _loc22_ * _loc22_ + _loc23_ * _loc23_;
               _loc31_ = _loc21_ * _loc24_ + _loc22_ * _loc25_ + _loc23_ * _loc26_;
               _loc32_ = _loc21_ * _loc27_ + _loc22_ * _loc28_ + _loc23_ * _loc29_;
               _loc33_ = _loc24_ * _loc24_ + _loc25_ * _loc25_ + _loc26_ * _loc26_;
               _loc34_ = _loc24_ * _loc27_ + _loc25_ * _loc28_ + _loc26_ * _loc29_;
               _loc37_ = 1 / (_loc30_ * _loc33_ - _loc31_ * _loc31_);
               _loc35_ = (_loc33_ * _loc32_ - _loc31_ * _loc34_) * _loc37_;
               _loc36_ = (_loc30_ * _loc34_ - _loc31_ * _loc32_) * _loc37_;
               if(_loc35_ >= 0 && _loc36_ >= 0 && _loc35_ + _loc36_ <= 1)
               {
                  this.getPrecisePosition(this._hitRenderable.inverseSceneTransform,_loc39_[_loc15_],_loc39_[_loc15_ + 1],_loc39_[_loc15_ + 2],_loc6_,_loc7_,_loc8_);
                  _loc27_ = this._localHitPosition.x - _loc6_;
                  _loc28_ = this._localHitPosition.y - _loc7_;
                  _loc29_ = this._localHitPosition.z - _loc8_;
                  _loc48_ = _loc9_ - _loc6_;
                  _loc49_ = _loc10_ - _loc7_;
                  _loc50_ = _loc11_ - _loc8_;
                  _loc51_ = _loc12_ - _loc6_;
                  _loc52_ = _loc13_ - _loc7_;
                  _loc53_ = _loc14_ - _loc8_;
                  this._localHitNormal.x = _loc49_ * _loc53_ - _loc50_ * _loc52_;
                  this._localHitNormal.y = _loc50_ * _loc51_ - _loc48_ * _loc53_;
                  this._localHitNormal.z = _loc48_ * _loc52_ - _loc49_ * _loc51_;
                  _loc54_ = 1 / Math.sqrt(this._localHitNormal.x * this._localHitNormal.x + this._localHitNormal.y * this._localHitNormal.y + this._localHitNormal.z * this._localHitNormal.z);
                  this._localHitNormal.x *= _loc54_;
                  this._localHitNormal.y *= _loc54_;
                  this._localHitNormal.z *= _loc54_;
                  _loc32_ = _loc21_ * _loc27_ + _loc22_ * _loc28_ + _loc23_ * _loc29_;
                  _loc34_ = _loc24_ * _loc27_ + _loc25_ * _loc28_ + _loc26_ * _loc29_;
                  _loc35_ = (_loc33_ * _loc32_ - _loc31_ * _loc34_) * _loc37_;
                  _loc36_ = (_loc30_ * _loc34_ - _loc31_ * _loc32_) * _loc37_;
                  _loc45_ = uint(_loc3_[_loc15_] << 1);
                  _loc46_ = uint(_loc3_[_loc16_] << 1);
                  _loc47_ = uint(_loc3_[_loc17_] << 1);
                  _loc43_ = _loc38_[_loc45_];
                  _loc44_ = _loc38_[_loc45_ + 1];
                  this._hitUV.x = _loc43_ + _loc36_ * (_loc38_[_loc46_] - _loc43_) + _loc35_ * (_loc38_[_loc47_] - _loc43_);
                  this._hitUV.y = _loc44_ + _loc36_ * (_loc38_[_loc46_ + 1] - _loc44_) + _loc35_ * (_loc38_[_loc47_ + 1] - _loc44_);
                  this._faceIndex = _loc15_;
                  this._subGeometryIndex = GeomUtil.getMeshSubMeshIndex(SubMesh(this._hitRenderable));
                  return;
               }
            }
            _loc15_ += 3;
            _loc16_ += 3;
            _loc17_ += 3;
         }
      }
      
      private function getPrecisePosition(param1:Matrix3D, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         var _loc16_:Number = this._rayPos.x;
         var _loc17_:Number = this._rayPos.y;
         var _loc18_:Number = this._rayPos.z;
         _loc11_ = this._rayDir.x;
         _loc12_ = this._rayDir.y;
         _loc13_ = this._rayDir.z;
         param1.copyRawDataTo(_loc15_);
         _loc8_ = _loc15_[0] * _loc11_ + _loc15_[4] * _loc12_ + _loc15_[8] * _loc13_;
         _loc9_ = _loc15_[1] * _loc11_ + _loc15_[5] * _loc12_ + _loc15_[9] * _loc13_;
         _loc10_ = _loc15_[2] * _loc11_ + _loc15_[6] * _loc12_ + _loc15_[10] * _loc13_;
         _loc11_ = _loc15_[0] * _loc16_ + _loc15_[4] * _loc17_ + _loc15_[8] * _loc18_ + _loc15_[12];
         _loc12_ = _loc15_[1] * _loc16_ + _loc15_[5] * _loc17_ + _loc15_[9] * _loc18_ + _loc15_[13];
         _loc13_ = _loc15_[2] * _loc16_ + _loc15_[6] * _loc17_ + _loc15_[10] * _loc18_ + _loc15_[14];
         _loc14_ = ((param5 - _loc11_) * param2 + (param6 - _loc12_) * param3 + (param7 - _loc13_) * param4) / (_loc8_ * param2 + _loc9_ * param3 + _loc10_ * param4);
         this._localHitPosition.x = _loc11_ + _loc8_ * _loc14_;
         this._localHitPosition.y = _loc12_ + _loc9_ * _loc14_;
         this._localHitPosition.z = _loc13_ + _loc10_ * _loc14_;
      }
      
      public function dispose() : void
      {
         this._bitmapData.dispose();
         if(this._triangleProgram3D)
         {
            this._triangleProgram3D.dispose();
         }
         if(this._objectProgram3D)
         {
            this._objectProgram3D.dispose();
         }
         this._triangleProgram3D = null;
         this._objectProgram3D = null;
         this._bitmapData = null;
         this._hitRenderable = null;
         this._hitEntity = null;
      }
   }
}

