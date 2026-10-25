package away3d.animators.nodes
{
   import away3d.*;
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   import away3d.materials.compilation.*;
   import away3d.materials.passes.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class ParticleSpriteSheetNode extends ParticleNodeBase
   {
      
      arcane static const UV_INDEX_0:uint = 0;
      
      arcane static const UV_INDEX_1:uint = 1;
      
      public static const UV_VECTOR3D:String = "UVVector3D";
      
      arcane var _usesCycle:Boolean;
      
      arcane var _usesPhase:Boolean;
      
      arcane var _totalFrames:int;
      
      arcane var _numColumns:int;
      
      arcane var _numRows:int;
      
      arcane var _cycleDuration:Number;
      
      arcane var _cyclePhase:Number;
      
      public function ParticleSpriteSheetNode(param1:uint, param2:Boolean, param3:Boolean, param4:int = 1, param5:uint = 1, param6:Number = 1, param7:Number = 0, param8:uint = 4294967295)
      {
         var _loc9_:int = 0;
         if(param2)
         {
            _loc9_ = 2;
            if(param3)
            {
               _loc9_++;
            }
         }
         super("ParticleSpriteSheet",param1,_loc9_,ParticleAnimationSet.POST_PRIORITY + 1);
         _stateClass = ParticleSpriteSheetState;
         this._usesCycle = param2;
         this._usesPhase = param3;
         this._numColumns = param4;
         this._numRows = param5;
         this._cyclePhase = param7;
         this._cycleDuration = param6;
         this._totalFrames = Math.min(param8,param4 * param5);
      }
      
      public function get numColumns() : Number
      {
         return this._numColumns;
      }
      
      public function get numRows() : Number
      {
         return this._numRows;
      }
      
      public function get totalFrames() : Number
      {
         return this._totalFrames;
      }
      
      override public function getAGALUVCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:ShaderRegisterElement = param2.getFreeVertexConstant();
         var _loc4_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,UV_INDEX_0,_loc3_.index);
         param2.setRegisterIndex(this,UV_INDEX_1,_loc4_.index);
         var _loc5_:ShaderRegisterElement = new ShaderRegisterElement(_loc3_.regName,_loc3_.index,0);
         var _loc6_:ShaderRegisterElement = new ShaderRegisterElement(_loc3_.regName,_loc3_.index,1);
         var _loc7_:ShaderRegisterElement = new ShaderRegisterElement(_loc3_.regName,_loc3_.index,2);
         var _loc8_:ShaderRegisterElement = new ShaderRegisterElement(_loc4_.regName,_loc4_.index,0);
         var _loc9_:ShaderRegisterElement = new ShaderRegisterElement(_loc4_.regName,_loc4_.index,1);
         var _loc10_:ShaderRegisterElement = new ShaderRegisterElement(_loc4_.regName,_loc4_.index,2);
         var _loc11_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc12_:ShaderRegisterElement = new ShaderRegisterElement(_loc11_.regName,_loc11_.index,0);
         var _loc13_:ShaderRegisterElement = new ShaderRegisterElement(_loc11_.regName,_loc11_.index,1);
         _loc11_ = new ShaderRegisterElement(_loc11_.regName,_loc11_.index,2);
         var _loc14_:ShaderRegisterElement = new ShaderRegisterElement(_loc11_.regName,_loc11_.index,3);
         var _loc15_:ShaderRegisterElement = new ShaderRegisterElement(param2.uvTarget.regName,param2.uvTarget.index,0);
         var _loc16_:ShaderRegisterElement = new ShaderRegisterElement(param2.uvTarget.regName,param2.uvTarget.index,1);
         var _loc17_:String = "";
         _loc17_ = _loc17_ + ("mul " + _loc15_ + "," + _loc15_ + "," + _loc6_ + "\n");
         if(this._numRows > 1)
         {
            _loc17_ += "mul " + _loc16_ + "," + _loc16_ + "," + _loc7_ + "\n";
         }
         if(this._usesCycle)
         {
            if(this._usesPhase)
            {
               _loc17_ += "add " + _loc12_ + "," + param2.vertexTime + "," + _loc10_ + "\n";
            }
            else
            {
               _loc17_ += "mov " + _loc12_ + "," + param2.vertexTime + "\n";
            }
            _loc17_ += "div " + _loc12_ + "," + _loc12_ + "," + _loc9_ + "\n";
            _loc17_ = _loc17_ + ("frc " + _loc12_ + "," + _loc12_ + "\n");
            _loc17_ = _loc17_ + ("mul " + _loc12_ + "," + _loc12_ + "," + _loc9_ + "\n");
            _loc17_ = _loc17_ + ("mul " + _loc11_ + "," + _loc12_ + "," + _loc8_ + "\n");
         }
         else
         {
            _loc17_ += "mul " + _loc11_.toString() + "," + param2.vertexLife + "," + _loc5_ + "\n";
         }
         if(this._numRows > 1)
         {
            _loc17_ += "frc " + _loc14_ + "," + _loc11_ + "\n";
            _loc17_ = _loc17_ + ("sub " + _loc13_ + "," + _loc11_ + "," + _loc14_ + "\n");
            _loc17_ = _loc17_ + ("mul " + _loc13_ + "," + _loc13_ + "," + _loc7_ + "\n");
            _loc17_ = _loc17_ + ("add " + _loc16_ + "," + _loc16_ + "," + _loc13_ + "\n");
         }
         _loc17_ += "div " + _loc14_ + "," + _loc11_ + "," + _loc6_ + "\n";
         _loc17_ = _loc17_ + ("frc " + _loc11_ + "," + _loc14_ + "\n");
         _loc17_ = _loc17_ + ("sub " + _loc14_ + "," + _loc14_ + "," + _loc11_ + "\n");
         _loc17_ = _loc17_ + ("mul " + _loc11_ + "," + _loc14_ + "," + _loc6_ + "\n");
         if(this._numRows > 1)
         {
            _loc17_ += "frc " + _loc11_ + "," + _loc11_ + "\n";
         }
         return _loc17_ + ("add " + _loc15_ + "," + _loc15_ + "," + _loc11_ + "\n");
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleSpriteSheetState
      {
         return param1.getAnimationState(this) as ParticleSpriteSheetState;
      }
      
      override arcane function processAnimationSetting(param1:ParticleAnimationSet) : void
      {
         param1.hasUVNode = true;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Number = NaN;
         if(this._usesCycle)
         {
            _loc2_ = param1[UV_VECTOR3D];
            if(!_loc2_)
            {
               throw new Error("there is no " + UV_VECTOR3D + " in param!");
            }
            if(_loc2_.x <= 0)
            {
               throw new Error("the cycle duration must be greater than zero");
            }
            _loc3_ = this._totalFrames / this._numColumns;
            _oneData[0] = _loc3_ / _loc2_.x;
            _oneData[1] = _loc2_.x;
            if(this._usesPhase)
            {
               _oneData[2] = _loc2_.y;
            }
         }
      }
   }
}

