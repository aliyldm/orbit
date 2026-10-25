package net.bigpoint.darkorbit.mvc.serverEvents.model
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableSmartCountDown;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ServerEventVO
   {
      
      public const timeLeft:BindableSmartCountDown = new BindableSmartCountDown();
      
      public const deactivated:ISignal = new Signal();
      
      private var _type:String;
      
      private var _id:Number;
      
      public function ServerEventVO(param1:String, param2:Number)
      {
         super();
         this._type = param1;
         this._id = param2;
         this.timeLeft.complete.add(this.handleCompleted);
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      public function toString() : String
      {
         return "type= " + this._type + ",id= " + this._id + ",timeLeft= " + TimeFormatter.getSmartFormatedTime(this.timeLeft.value);
      }
      
      private function handleCompleted() : void
      {
         this.deactivated.dispatch(this);
      }
   }
}

