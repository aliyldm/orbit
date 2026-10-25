package away3d.loaders.parsers.particleSubParsers.values.setters.threeD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Vector3D;
   
   public class ThreeDConstSetter extends SetterBase
   {
      
      private var _value:Vector3D;
      
      public function ThreeDConstSetter(param1:String, param2:Vector3D)
      {
         super(param1);
         this._value = param2;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this._value;
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         return this._value;
      }
   }
}

