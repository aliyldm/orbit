package away3d.events
{
   import away3d.animators.AnimatorBase;
   import flash.events.Event;
   
   public class AnimatorEvent extends Event
   {
      
      public static const START:String = "start";
      
      public static const STOP:String = "stop";
      
      public static const CYCLE_COMPLETE:String = "cycle_complete";
      
      private var _animator:AnimatorBase;
      
      public function AnimatorEvent(param1:String, param2:AnimatorBase)
      {
         super(param1,false,false);
         this._animator = param2;
      }
      
      public function get animator() : AnimatorBase
      {
         return this._animator;
      }
      
      override public function clone() : Event
      {
         return new AnimatorEvent(type,this._animator);
      }
   }
}

