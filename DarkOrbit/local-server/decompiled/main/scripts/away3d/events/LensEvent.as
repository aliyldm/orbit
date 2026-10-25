package away3d.events
{
   import away3d.cameras.lenses.LensBase;
   import flash.events.Event;
   
   public class LensEvent extends Event
   {
      
      public static const MATRIX_CHANGED:String = "matrixChanged";
      
      private var _lens:LensBase;
      
      public function LensEvent(param1:String, param2:LensBase, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._lens = param2;
      }
      
      public function get lens() : LensBase
      {
         return this._lens;
      }
      
      override public function clone() : Event
      {
         return new LensEvent(type,this._lens,bubbles,cancelable);
      }
   }
}

