package away3d.loaders.parsers.particleSubParsers.values.setters.oneD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   
   public class OneDConstSetter extends SetterBase
   {
      
      private var _value:Number;
      
      public function OneDConstSetter(param1:String, param2:Number)
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

