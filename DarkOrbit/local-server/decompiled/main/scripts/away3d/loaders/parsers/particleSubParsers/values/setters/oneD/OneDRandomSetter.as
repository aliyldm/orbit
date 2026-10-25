package away3d.loaders.parsers.particleSubParsers.values.setters.oneD
{
   import away3d.animators.data.ParticleProperties;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   
   public class OneDRandomSetter extends SetterBase
   {
      
      private var _min:Number;
      
      private var _max:Number;
      
      private var _delta:Number;
      
      public function OneDRandomSetter(param1:String, param2:Number, param3:Number)
      {
         super(param1);
         this._min = param2;
         this._max = param3;
         this._delta = this._max - this._min;
      }
      
      override public function setProps(param1:ParticleProperties) : void
      {
         param1[_propName] = Math.random() * this._delta + this._min;
      }
      
      override public function generateOneValue(param1:int = 0, param2:int = 1) : *
      {
         return Math.random() * this._delta + this._min;
      }
   }
}

