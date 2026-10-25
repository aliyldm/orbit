package away3d.animators.data
{
   import away3d.animators.nodes.AnimationNodeBase;
   import away3d.core.math.Matrix3DUtils;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import flash.geom.Matrix3D;
   import flash.utils.Dictionary;
   
   public class AnimationRegisterCache extends ShaderRegisterCache
   {
      
      public var positionAttribute:ShaderRegisterElement;
      
      public var uvAttribute:ShaderRegisterElement;
      
      public var positionTarget:ShaderRegisterElement;
      
      public var scaleAndRotateTarget:ShaderRegisterElement;
      
      public var velocityTarget:ShaderRegisterElement;
      
      public var vertexTime:ShaderRegisterElement;
      
      public var vertexLife:ShaderRegisterElement;
      
      public var vertexZeroConst:ShaderRegisterElement;
      
      public var vertexOneConst:ShaderRegisterElement;
      
      public var vertexTwoConst:ShaderRegisterElement;
      
      public var uvTarget:ShaderRegisterElement;
      
      public var colorAddTarget:ShaderRegisterElement;
      
      public var colorMulTarget:ShaderRegisterElement;
      
      public var colorAddVary:ShaderRegisterElement;
      
      public var colorMulVary:ShaderRegisterElement;
      
      public var uvVar:ShaderRegisterElement;
      
      public var rotationRegisters:Vector.<ShaderRegisterElement>;
      
      public var needFragmentAnimation:Boolean;
      
      public var needUVAnimation:Boolean;
      
      public var sourceRegisters:Vector.<String>;
      
      public var targetRegisters:Vector.<String>;
      
      private var indexDictionary:Dictionary = new Dictionary(true);
      
      public var hasUVNode:Boolean;
      
      public var needVelocity:Boolean;
      
      public var hasBillboard:Boolean;
      
      public var hasColorMulNode:Boolean;
      
      public var hasColorAddNode:Boolean;
      
      public var vertexConstantData:Vector.<Number> = new Vector.<Number>();
      
      public var fragmentConstantData:Vector.<Number> = new Vector.<Number>();
      
      private var _numVertexConstant:int;
      
      private var _numFragmentConstant:int;
      
      public function AnimationRegisterCache(param1:String)
      {
         super(param1);
      }
      
      override public function reset() : void
      {
         var _loc2_:ShaderRegisterElement = null;
         super.reset();
         this.rotationRegisters = new Vector.<ShaderRegisterElement>();
         this.positionAttribute = this.getRegisterFromString(this.sourceRegisters[0]);
         this.scaleAndRotateTarget = this.getRegisterFromString(this.targetRegisters[0]);
         addVertexTempUsages(this.scaleAndRotateTarget,1);
         var _loc1_:int = 1;
         while(_loc1_ < this.targetRegisters.length)
         {
            this.rotationRegisters.push(this.getRegisterFromString(this.targetRegisters[_loc1_]));
            addVertexTempUsages(this.rotationRegisters[_loc1_ - 1],1);
            _loc1_++;
         }
         this.scaleAndRotateTarget = new ShaderRegisterElement(this.scaleAndRotateTarget.regName,this.scaleAndRotateTarget.index);
         this.vertexZeroConst = getFreeVertexConstant();
         this.vertexZeroConst = new ShaderRegisterElement(this.vertexZeroConst.regName,this.vertexZeroConst.index,0);
         this.vertexOneConst = new ShaderRegisterElement(this.vertexZeroConst.regName,this.vertexZeroConst.index,1);
         this.vertexTwoConst = new ShaderRegisterElement(this.vertexZeroConst.regName,this.vertexZeroConst.index,2);
         this.positionTarget = getFreeVertexVectorTemp();
         addVertexTempUsages(this.positionTarget,1);
         this.positionTarget = new ShaderRegisterElement(this.positionTarget.regName,this.positionTarget.index);
         if(this.needVelocity)
         {
            this.velocityTarget = getFreeVertexVectorTemp();
            addVertexTempUsages(this.velocityTarget,1);
            this.velocityTarget = new ShaderRegisterElement(this.velocityTarget.regName,this.velocityTarget.index);
            this.vertexTime = new ShaderRegisterElement(this.velocityTarget.regName,this.velocityTarget.index,3);
            this.vertexLife = new ShaderRegisterElement(this.positionTarget.regName,this.positionTarget.index,3);
         }
         else
         {
            _loc2_ = getFreeVertexVectorTemp();
            addVertexTempUsages(_loc2_,1);
            this.vertexTime = new ShaderRegisterElement(_loc2_.regName,_loc2_.index,0);
            this.vertexLife = new ShaderRegisterElement(_loc2_.regName,_loc2_.index,1);
         }
      }
      
      public function setUVSourceAndTarget(param1:String, param2:String) : void
      {
         this.uvVar = this.getRegisterFromString(param2);
         this.uvAttribute = this.getRegisterFromString(param1);
         this.uvTarget = new ShaderRegisterElement(this.positionTarget.regName,this.positionTarget.index);
      }
      
      public function setRegisterIndex(param1:AnimationNodeBase, param2:int, param3:int) : void
      {
         var _loc4_:Vector.<int> = this.indexDictionary[param1] = this.indexDictionary[param1] || new Vector.<int>(8,true);
         _loc4_[param2] = param3;
      }
      
      public function getRegisterIndex(param1:AnimationNodeBase, param2:int) : int
      {
         return this.indexDictionary[param1][param2];
      }
      
      public function getInitCode() : String
      {
         var _loc1_:int = int(this.sourceRegisters.length);
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ += "mov " + this.targetRegisters[_loc3_] + "," + this.sourceRegisters[_loc3_] + "\n";
            _loc3_++;
         }
         _loc2_ += "mov " + this.positionTarget + ".xyz," + this.vertexZeroConst.toString() + "\n";
         if(this.needVelocity)
         {
            _loc2_ += "mov " + this.velocityTarget + ".xyz," + this.vertexZeroConst.toString() + "\n";
         }
         return _loc2_;
      }
      
      public function getCombinationCode() : String
      {
         return "add " + this.scaleAndRotateTarget + ".xyz," + this.scaleAndRotateTarget + ".xyz," + this.positionTarget + ".xyz\n";
      }
      
      public function initColorRegisters() : String
      {
         var _loc1_:String = "";
         if(this.hasColorMulNode)
         {
            this.colorMulTarget = getFreeVertexVectorTemp();
            addVertexTempUsages(this.colorMulTarget,1);
            this.colorMulVary = getFreeVarying();
            _loc1_ += "mov " + this.colorMulTarget + "," + this.vertexOneConst + "\n";
         }
         if(this.hasColorAddNode)
         {
            this.colorAddTarget = getFreeVertexVectorTemp();
            addVertexTempUsages(this.colorAddTarget,1);
            this.colorAddVary = getFreeVarying();
            _loc1_ += "mov " + this.colorAddTarget + "," + this.vertexZeroConst + "\n";
         }
         return _loc1_;
      }
      
      public function getColorPassCode() : String
      {
         var _loc1_:String = "";
         if(this.needFragmentAnimation && (this.hasColorAddNode || this.hasColorMulNode))
         {
            if(this.hasColorMulNode)
            {
               _loc1_ += "mov " + this.colorMulVary + "," + this.colorMulTarget + "\n";
            }
            if(this.hasColorAddNode)
            {
               _loc1_ += "mov " + this.colorAddVary + "," + this.colorAddTarget + "\n";
            }
         }
         return _loc1_;
      }
      
      public function getColorCombinationCode(param1:String) : String
      {
         var _loc3_:ShaderRegisterElement = null;
         var _loc2_:String = "";
         if(this.needFragmentAnimation && (this.hasColorAddNode || this.hasColorMulNode))
         {
            _loc3_ = this.getRegisterFromString(param1);
            addFragmentTempUsages(_loc3_,1);
            if(this.hasColorMulNode)
            {
               _loc2_ += "mul " + _loc3_ + "," + _loc3_ + "," + this.colorMulVary + "\n";
            }
            if(this.hasColorAddNode)
            {
               _loc2_ += "add " + _loc3_ + "," + _loc3_ + "," + this.colorAddVary + "\n";
            }
         }
         return _loc2_;
      }
      
      private function getRegisterFromString(param1:String) : ShaderRegisterElement
      {
         var _loc2_:Array = param1.split(/(\d+)/);
         return new ShaderRegisterElement(_loc2_[0],_loc2_[1]);
      }
      
      public function get numVertexConstant() : int
      {
         return this._numVertexConstant;
      }
      
      public function get numFragmentConstant() : int
      {
         return this._numFragmentConstant;
      }
      
      public function setDataLength() : void
      {
         this._numVertexConstant = _numUsedVertexConstants - _vertexConstantOffset;
         this._numFragmentConstant = _numUsedFragmentConstants - _fragmentConstantOffset;
         this.vertexConstantData.length = this._numVertexConstant * 4;
         this.fragmentConstantData.length = this._numFragmentConstant * 4;
      }
      
      public function setVertexConst(param1:int, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0) : void
      {
         var _loc6_:* = int((param1 - _vertexConstantOffset) * 4);
         var _loc7_:Number;
         this.vertexConstantData[_loc7_ = _loc6_++] = param2;
         var _loc8_:Number;
         this.vertexConstantData[_loc8_ = _loc6_++] = param3;
         var _loc9_:Number;
         this.vertexConstantData[_loc9_ = _loc6_++] = param4;
         this.vertexConstantData[_loc6_] = param5;
      }
      
      public function setVertexConstFromVector(param1:int, param2:Vector.<Number>) : void
      {
         var _loc3_:* = int((param1 - _vertexConstantOffset) * 4);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            var _loc5_:Number;
            this.vertexConstantData[_loc5_ = _loc3_++] = param2[_loc4_];
            _loc4_++;
         }
      }
      
      public function setVertexConstFromMatrix(param1:int, param2:Matrix3D) : void
      {
         var _loc3_:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
         param2.copyRawDataTo(_loc3_);
         var _loc4_:* = int((param1 - _vertexConstantOffset) * 4);
         var _loc5_:Number;
         this.vertexConstantData[_loc5_ = _loc4_++] = _loc3_[0];
         var _loc6_:Number;
         this.vertexConstantData[_loc6_ = _loc4_++] = _loc3_[4];
         var _loc7_:Number;
         this.vertexConstantData[_loc7_ = _loc4_++] = _loc3_[8];
         var _loc8_:Number;
         this.vertexConstantData[_loc8_ = _loc4_++] = _loc3_[12];
         var _loc9_:Number;
         this.vertexConstantData[_loc9_ = _loc4_++] = _loc3_[1];
         var _loc10_:Number;
         this.vertexConstantData[_loc10_ = _loc4_++] = _loc3_[5];
         var _loc11_:Number;
         this.vertexConstantData[_loc11_ = _loc4_++] = _loc3_[9];
         var _loc12_:Number;
         this.vertexConstantData[_loc12_ = _loc4_++] = _loc3_[13];
         var _loc13_:Number;
         this.vertexConstantData[_loc13_ = _loc4_++] = _loc3_[2];
         var _loc14_:Number;
         this.vertexConstantData[_loc14_ = _loc4_++] = _loc3_[6];
         var _loc15_:Number;
         this.vertexConstantData[_loc15_ = _loc4_++] = _loc3_[10];
         var _loc16_:Number;
         this.vertexConstantData[_loc16_ = _loc4_++] = _loc3_[14];
         var _loc17_:Number;
         this.vertexConstantData[_loc17_ = _loc4_++] = _loc3_[3];
         var _loc18_:Number;
         this.vertexConstantData[_loc18_ = _loc4_++] = _loc3_[7];
         var _loc19_:Number;
         this.vertexConstantData[_loc19_ = _loc4_++] = _loc3_[11];
         this.vertexConstantData[_loc4_] = _loc3_[15];
      }
      
      public function setFragmentConst(param1:int, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0) : void
      {
         var _loc6_:* = int((param1 - _fragmentConstantOffset) * 4);
         var _loc7_:Number;
         this.fragmentConstantData[_loc7_ = _loc6_++] = param2;
         var _loc8_:Number;
         this.fragmentConstantData[_loc8_ = _loc6_++] = param3;
         var _loc9_:Number;
         this.fragmentConstantData[_loc9_ = _loc6_++] = param4;
         this.fragmentConstantData[_loc6_] = param5;
      }
   }
}

