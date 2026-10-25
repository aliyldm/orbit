package away3d.loaders.parsers.particleSubParsers.values.setters.color
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.ColorTransform;
   
   public class ConstColorSetter extends SetterBase
   {
      
      private var _color:ColorTransform;
      
      public function ConstColorSetter(param1:String, param2:ColorTransform)
      {
         super(param1);
         this._color = param2;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = this._color;
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         return this._color;
      }
   }
}

