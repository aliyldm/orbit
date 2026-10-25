package away3d.animators.nodes
{
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.states.ParticleSegmentedScaleState;
   import away3d.arcane;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.passes.MaterialPassBase;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleSegmentedScaleNode extends ParticleNodeBase
   {
      
      arcane static const START_INDEX:uint = 0;
      
      arcane var _startScale:Vector3D;
      
      arcane var _endScale:Vector3D;
      
      arcane var _numSegmentPoint:int;
      
      arcane var _segmentScales:Vector.<Vector3D>;
      
      public function ParticleSegmentedScaleNode(param1:int, param2:Vector3D, param3:Vector3D, param4:Vector.<Vector3D>)
      {
         _stateClass = ParticleSegmentedScaleState;
         super("ParticleSegmentedScale",ParticlePropertiesMode.GLOBAL,0,3);
         this._numSegmentPoint = param1;
         this._startScale = param2;
         this._endScale = param3;
         this._segmentScales = param4;
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc9_:int = 0;
         var _loc10_:ShaderRegisterElement = null;
         var _loc11_:Vector.<ShaderRegisterElement> = null;
         param1 = param1;
         var _loc3_:String = "";
         _loc4_ = param2.getFreeVertexVectorTemp();
         param2.addVertexTempUsages(_loc4_,1);
         var _loc5_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         param2.addVertexTempUsages(_loc5_,1);
         var _loc6_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc7_:ShaderRegisterElement = new ShaderRegisterElement(_loc6_.regName,_loc6_.index,0);
         var _loc8_:ShaderRegisterElement = new ShaderRegisterElement(_loc6_.regName,_loc6_.index,1);
         param2.removeVertexTempUsage(_loc4_);
         param2.removeVertexTempUsage(_loc5_);
         _loc10_ = param2.getFreeVertexConstant();
         param2.setRegisterIndex(this,START_INDEX,_loc10_.index);
         _loc11_ = new Vector.<ShaderRegisterElement>();
         _loc9_ = 0;
         while(_loc9_ < this._numSegmentPoint + 1)
         {
            _loc11_.push(param2.getFreeVertexConstant());
            _loc9_++;
         }
         _loc3_ += "mov " + _loc4_ + "," + _loc10_ + "\n";
         _loc9_ = 0;
         while(_loc9_ < this._numSegmentPoint)
         {
            switch(_loc9_)
            {
               case 0:
                  _loc3_ += "min " + _loc8_ + "," + param2.vertexLife + "," + _loc11_[_loc9_] + ".w\n";
                  break;
               case 1:
                  _loc3_ += "sub " + _loc7_ + "," + param2.vertexLife + "," + _loc11_[_loc9_ - 1] + ".w\n";
                  _loc3_ += "max " + _loc8_ + "," + _loc7_ + "," + param2.vertexZeroConst + "\n";
                  _loc3_ += "min " + _loc8_ + "," + _loc8_ + "," + _loc11_[_loc9_] + ".w\n";
                  break;
               default:
                  _loc3_ += "sub " + _loc7_ + "," + _loc7_ + "," + _loc11_[_loc9_ - 1] + ".w\n";
                  _loc3_ += "max " + _loc8_ + "," + _loc7_ + "," + param2.vertexZeroConst + "\n";
                  _loc3_ += "min " + _loc8_ + "," + _loc8_ + "," + _loc11_[_loc9_] + ".w\n";
            }
            _loc3_ += "mul " + _loc5_ + "," + _loc8_ + "," + _loc11_[_loc9_] + "\n";
            _loc3_ += "add " + _loc4_ + "," + _loc4_ + "," + _loc5_ + "\n";
            _loc9_++;
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
                  _loc3_ += "sub " + _loc7_ + "," + param2.vertexLife + "," + _loc11_[this._numSegmentPoint - 1] + ".w\n";
                  break;
               default:
                  _loc3_ += "sub " + _loc7_ + "," + _loc7_ + "," + _loc11_[this._numSegmentPoint - 1] + ".w\n";
            }
            _loc3_ += "max " + _loc8_ + "," + _loc7_ + "," + param2.vertexZeroConst + "\n";
         }
         _loc3_ += "mul " + _loc5_ + "," + _loc8_ + "," + _loc11_[this._numSegmentPoint] + "\n";
         _loc3_ += "add " + _loc4_ + "," + _loc4_ + "," + _loc5_ + "\n";
         return _loc3_ + ("mul " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc4_ + ".xyz\n");
      }
   }
}

