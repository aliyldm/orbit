package away3d.events
{
   import away3d.animators.data.ParticleGroupEventProperty;
   import flash.events.Event;
   
   public class ParticleGroupEvent extends Event
   {
      
      public static const OCCUR:String = "occur";
      
      private var _eventProperty:ParticleGroupEventProperty;
      
      public function ParticleGroupEvent(param1:String, param2:ParticleGroupEventProperty, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._eventProperty = param2;
      }
      
      public function get eventProperty() : ParticleGroupEventProperty
      {
         return this._eventProperty;
      }
   }
}

