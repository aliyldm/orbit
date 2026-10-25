package away3d.animators.nodes
{
   import away3d.animators.ParticleAnimationSet;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.ColorSegmentPoint;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.states.ParticleSegmentedColorState;
   import away3d.arcane;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.passes.MaterialPassBase;
   import flash.geom.ColorTransform;
   
   use namespace arcane;
   
   public class ParticleSegmentedColorNode extends ParticleNodeBase
   {
      
      arcane static const START_MULTIPLIER_INDEX:uint = 0;
      
      arcane static const START_OFFSET_INDEX:uint = 1;
      
      arcane static const TIME_DATA_INDEX:uint = 2;
      
      arcane var _usesMultiplier:Boolean;
      
      arcane var _usesOffset:Boolean;
      
      arcane var _startColor:ColorTransform;
      
      arcane var _endColor:ColorTransform;
      
      arcane var _numSegmentPoint:int;
      
      arcane var _segmentPoints:Vector.<ColorSegmentPoint>;
      
      public function ParticleSegmentedColorNode(param1:Boolean, param2:Boolean, param3:int, param4:ColorTransform, param5:ColorTransform, param6:Vector.<ColorSegmentPoint>)
      {
         _stateClass = ParticleSegmentedColorState;
         super("ParticleSegmentedColor",ParticlePropertiesMode.GLOBAL,0,ParticleAnimationSet.COLOR_PRIORITY);
         if(param3 > 4)
         {
            throw new Error("the numSegmentPoint must be less or equal 4");
         }
         this._usesMultiplier = param1;
         this._usesOffset = param2;
         this._numSegmentPoint = param3;
         this._startColor = param4;
         this._endColor = param5;
         this._segmentPoints = param6;
      }
      
      override arcane function processAnimationSetting(param1:ParticleAnimationSet) : void
      {
         if(this._usesMultiplier)
         {
            param1.hasColorMulNode = true;
         }
         if(this._usesOffset)
         {
            param1.hasColorAddNode = true;
         }
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         var _loc8_:ShaderRegisterElement = null;
         var _loc9_:ShaderRegisterElement = null;
         var _loc10_:int = 0;
         var _loc11_:ShaderRegisterElement = null;
         var _loc12_:Vector.<ShaderRegisterElement> = null;
         var _loc13_:ShaderRegisterElement = null;
         var _loc14_:Vector.<ShaderRegisterElement> = null;
         param1 = param1;
         var _loc3_:String = "";
         if(param2.needFragmentAnimation)
         {
            if(this._usesMultiplier)
            {
               _loc4_ = param2.getFreeVertexVectorTemp();
               param2.addVertexTempUsages(_loc4_,1);
            }
            _loc5_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc5_,1);
            _loc6_ = param2.getFreeVertexVectorTemp();
            _loc7_ = new ShaderRegisterElement(_loc6_.regName,_loc6_.index,0);
            _loc8_ = new ShaderRegisterElement(_loc6_.regName,_loc6_.index,1);
            if(this._usesMultiplier)
            {
               param2.removeVertexTempUsage(_loc4_);
            }
            param2.removeVertexTempUsage(_loc5_);
            _loc9_ = param2.getFreeVertexConstant();
            param2.setRegisterIndex(this,TIME_DATA_INDEX,_loc9_.index);
            if(this._usesMultiplier)
            {
               _loc11_ = param2.getFreeVertexConstant();
               param2.setRegisterIndex(this,START_MULTIPLIER_INDEX,_loc11_.index);
               _loc12_ = new Vector.<ShaderRegisterElement>();
               _loc10_ = 0;
               while(_loc10_ < this._numSegmentPoint + 1)
               {
                  _loc12_.push(param2.getFreeVertexConstant());
                  _loc10_++;
               }
            }
            if(this._usesOffset)
            {
               _loc13_ = param2.getFreeVertexConstant();
               param2.setRegisterIndex(this,START_OFFSET_INDEX,_loc13_.index);
               _loc14_ = new Vector.<ShaderRegisterElement>();
               _loc10_ = 0;
               while(_loc10_ < this._numSegmentPoint + 1)
               {
                  _loc14_.push(param2.getFreeVertexConstant());
                  _loc10_++;
               }
            }
            if(this._usesMultiplier)
            {
               _loc3_ += "mov " + _loc4_ + "," + _loc11_ + "\n";
            }
            if(this._usesOffset)
            {
               _loc3_ += "add " + param2.colorAddTarget + "," + param2.colorAddTarget + "," + _loc13_ + "\n";
            }
            _loc10_ = 0;
            while(_loc10_ < this._numSegmentPoint)
            {
               switch(_loc10_)
               {
                  case 0:
                     _loc3_ += "min " + _loc8_ + "," + param2.vertexLife + "," + _loc9_ + ".x\n";
                     break;
                  case 1:
                     _loc3_ += "sub " + _loc7_ + "," + param2.vertexLife + "," + _loc9_ + ".x\n";
                     _loc3_ += "max " + _loc8_ + "," + _loc7_ + "," + param2.vertexZeroConst + "\n";
                     _loc3_ += "min " + _loc8_ + "," + _loc8_ + "," + _loc9_ + ".y\n";
                     break;
                  case 2:
                     _loc3_ += "sub " + _loc7_ + "," + _loc7_ + "," + _loc9_ + ".y\n";
                     _loc3_ += "max " + _loc8_ + "," + _loc7_ + "," + param2.vertexZeroConst + "\n";
                     _loc3_ += "min " + _loc8_ + "," + _loc8_ + "," + _loc9_ + ".z\n";
                     break;
                  case 3:
                     _loc3_ += "sub " + _loc7_ + "," + _loc7_ + "," + _loc9_ + ".z\n";
                     _loc3_ += "max " + _loc8_ + "," + _loc7_ + "," + param2.vertexZeroConst + "\n";
                     _loc3_ += "min " + _loc8_ + "," + _loc8_ + "," + _loc9_ + ".w\n";
               }
               if(this._usesMultiplier)
               {
                  _loc3_ += "mul " + _loc5_ + "," + _loc8_ + "," + _loc12_[_loc10_] + "\n";
                  _loc3_ += "add " + _loc4_ + "," + _loc4_ + "," + _loc5_ + "\n";
               }
               if(this._usesOffset)
               {
                  _loc3_ += "mul " + _loc5_ + "," + _loc8_ + "," + _loc14_[_loc10_] + "\n";
                  _loc3_ += "add " + param2.colorAddTarget + "," + param2.colorAddTarget + "," + _loc5_ + "\n";
               }
               _loc10_++;
            }
            if(this._numSegmentPoint == 0)
            {
               _loc8_ = param2.vertexLife;
            }
            else
            {
               switch(this._numSegmentPoint)
               {
                  case 1:
                     _loc3_ += "sub " + _loc7_ + "," + param2.vertexLife + "," + _loc9_ + ".x\n";
                     break;
                  case 2:
                     _loc3_ += "sub " + _loc7_ + "," + _loc7_ + "," + _loc9_ + ".y\n";
                     break;
                  case 3:
                     _loc3_ += "sub " + _loc7_ + "," + _loc7_ + "," + _loc9_ + ".z\n";
                     break;
                  case 4:
                     _loc3_ += "sub " + _loc7_ + "," + _loc7_ + "," + _loc9_ + ".w\n";
               }
               _loc3_ += "max " + _loc8_ + "," + _loc7_ + "," + param2.vertexZeroConst + "\n";
            }
            if(this._usesMultiplier)
            {
               _loc3_ += "mul " + _loc5_ + "," + _loc8_ + "," + _loc12_[this._numSegmentPoint] + "\n";
               _loc3_ += "add " + _loc4_ + "," + _loc4_ + "," + _loc5_ + "\n";
               _loc3_ += "mul " + param2.colorMulTarget + "," + param2.colorMulTarget + "," + _loc4_ + "\n";
            }
            if(this._usesOffset)
            {
               _loc3_ += "mul " + _loc5_ + "," + _loc8_ + "," + _loc14_[this._numSegmentPoint] + "\n";
               _loc3_ += "add " + param2.colorAddTarget + "," + param2.colorAddTarget + "," + _loc5_ + "\n";
            }
         }
         return _loc3_;
      }
   }
}

