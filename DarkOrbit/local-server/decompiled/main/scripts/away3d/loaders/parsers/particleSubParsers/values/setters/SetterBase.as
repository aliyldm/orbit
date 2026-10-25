package away3d.loaders.parsers.particleSubParsers.values.setters
{
   import away3d.animators.data.ParticleProperties;
   import away3d.errors.AbstractMethodError;
   
   public class SetterBase
   {
      
      protected var _propName:String;
      
      public function SetterBase(param1:String)
      {
         super();
         this._propName = param1;
      }
      
      public function get propName() : String
      {
         return this._propName;
      }
      
      public function startPropsGenerating(param1:ParticleProperties) : void
      {
      }
      
      public function setProps(param1:ParticleProperties) : void
      {
         throw new AbstractMethodError();
      }
      
      public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         throw new AbstractMethodError();
      }
      
      public function finishPropsGenerating(param1:ParticleProperties) : void
      {
      }
   }
}

