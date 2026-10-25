package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.lights.LightBase;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class SingleObjectDepthPass extends MaterialPassBase
   {
      
      private var _textures:Vector.<Dictionary>;
      
      private var _projections:Dictionary;
      
      private var _textureSize:uint;
      
      private var _polyOffset:Vector.<Number>;
      
      private var _enc:Vector.<Number>;
      
      private var _projectionTexturesInvalid:Boolean = true;
      
      public function SingleObjectDepthPass(param1:uint = 512, param2:Number = 15)
      {
         super(true);
         this._textureSize = param1;
         _numUsedStreams = 2;
         _numUsedVertexConstants = 7;
         this._polyOffset = new <Number>[param2,0,0,0];
         this._enc = Vector.<Number>([1,255,65025,16581375,1 / 255,1 / 255,1 / 255,0]);
         _animatableAttributes = Vector.<String>(["va0","va1"]);
         _animationTargetRegisters = Vector.<String>(["vt0","vt1"]);
      }
      
      override public function dispose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Vector.<Texture> = null;
         var _loc3_:uint = 0;
         if(this._textures)
         {
            _loc1_ = 0;
            while(_loc1_ < this._textures.length)
            {
               for each(_loc2_ in this._textures[_loc1_])
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc2_.length)
                  {
                     _loc2_[_loc3_].dispose();
                     _loc3_++;
                  }
               }
               _loc1_++;
            }
            this._textures = null;
         }
      }
      
      private function updateProjectionTextures() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Vector.<Texture> = null;
         var _loc3_:uint = 0;
         if(this._textures)
         {
            _loc1_ = 0;
            while(_loc1_ < this._textures.length)
            {
               for each(_loc2_ in this._textures[_loc1_])
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc2_.length)
                  {
                     _loc2_[_loc3_].dispose();
                     _loc3_++;
                  }
               }
               _loc1_++;
            }
         }
         this._textures = new Vector.<Dictionary>(8);
         this._projections = new Dictionary();
         this._projectionTexturesInvalid = false;
      }
      
      override arcane function getVertexCode() : String
      {
         var _loc1_:String = null;
         _loc1_ = "mul vt7, vt1, vc4.x\t\n" + "add vt7, vt7, vt0\t\t\n" + "mov vt7.w, vt0.w\t\t\n";
         _loc1_ += "m44 vt2, vt7, vc0\t\t\n" + "mov op, vt2\t\t\t\n";
         return _loc1_ + "div v0, vt2, vt2.w \n";
      }
      
      override arcane function getFragmentCode(param1:String) : String
      {
         var _loc2_:String = "";
         return _loc2_ + ("mul ft0, fc0, v0.z     \n" + "frc ft0, ft0           \n" + "mul ft1, ft0.yzww, fc1 \n" + "sub ft0, ft0, ft1      \n" + "mov oc, ft0            \n");
      }
      
      arcane function getDepthMap(param1:IRenderable, param2:Stage3DProxy) : Texture
      {
         return this._textures[param2._stage3DIndex][param1];
      }
      
      arcane function getProjection(param1:IRenderable) : Matrix3D
      {
         return this._projections[param1];
      }
      
      override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         var _loc5_:Matrix3D = null;
         var _loc8_:uint = 0;
         var _loc9_:LightBase = null;
         var _loc6_:int = param2._stage3DIndex;
         var _loc7_:Context3D = param2._context3D;
         var _loc10_:Vector.<LightBase> = _lightPicker.allPickedLights;
         this._textures[_loc6_] = this._textures[_loc6_] || new Dictionary();
         if(!this._projections[param1])
         {
            this._projections[param1] = new Matrix3D();
         }
         _loc8_ = _loc10_.length;
         _loc9_ = _loc10_[0];
         _loc5_ = _loc9_.getObjectProjectionMatrix(param1,this._projections[param1]);
         var _loc11_:Texture = this._textures[_loc6_][param1] = this._textures[_loc6_][param1] || _loc7_.createTexture(this._textureSize,this._textureSize,Context3DTextureFormat.BGRA,true);
         param2.setRenderTarget(_loc11_,true);
         _loc7_.clear(1,1,1);
         _loc7_.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc5_,true);
         _loc7_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._enc,2);
         param1.activateVertexBuffer(0,param2);
         param1.activateVertexNormalBuffer(1,param2);
         _loc7_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         if(this._projectionTexturesInvalid)
         {
            this.updateProjectionTextures();
         }
         super.arcane::activate(param1,param2);
         param1._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this._polyOffset,1);
      }
   }
}

