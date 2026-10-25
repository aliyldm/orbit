package away3d.events
{
   import flash.events.Event;
   
   public class ShadingMethodEvent extends Event
   {
      
      public static const SHADER_INVALIDATED:String = "ShaderInvalidated";
      
      public function ShadingMethodEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

