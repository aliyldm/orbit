package away3d.animators.data
{
   public class ParticleGroupEventProperty
   {
      
      private var _occurTime:Number;
      
      private var _customName:String;
      
      public function ParticleGroupEventProperty(param1:Number, param2:String)
      {
         super();
         this._occurTime = param1;
         this._customName = param2;
      }
      
      public function get customName() : String
      {
         return this._customName;
      }
      
      public function get occurTime() : Number
      {
         return this._occurTime;
      }
   }
}

