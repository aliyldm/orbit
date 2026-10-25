package away3d.animators.nodes
{
   import away3d.animators.IAnimator;
   import away3d.animators.ParticleAnimationSet;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.states.ParticleBillboardState;
   import away3d.arcane;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.passes.MaterialPassBase;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleBillboardNode extends ParticleNodeBase
   {
      
      arcane static const MATRIX_INDEX:int = 0;
      
      arcane var _billboardAxis:Vector3D;
      
      public function ParticleBillboardNode(param1:Vector3D = null)
      {
         super("ParticleBillboard",ParticlePropertiesMode.GLOBAL,0,4);
         _stateClass = ParticleBillboardState;
         this._billboardAxis = param1;
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc5_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:ShaderRegisterElement = param2.getFreeVertexConstant();
         param2.setRegisterIndex(this,MATRIX_INDEX,_loc3_.index);
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         var _loc4_:String = "m33 " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc3_ + "\n";
         for each(_loc5_ in param2.rotationRegisters)
         {
            _loc4_ += "m33 " + _loc5_.regName + _loc5_.index + ".xyz," + _loc5_ + "," + _loc3_ + "\n";
         }
         return _loc4_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleBillboardState
      {
         return param1.getAnimationState(this) as ParticleBillboardState;
      }
      
      override arcane function processAnimationSetting(param1:ParticleAnimationSet) : void
      {
         param1.hasBillboard = true;
      }
   }
}

