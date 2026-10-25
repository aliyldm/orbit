package net.bigpoint.darkorbit.utils.time
{
   import com.bigpoint.utils.bindables.BindableCounter;
   import flash.utils.getTimer;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ServerTime
   {
      
      public static const instance:ServerTime = new ServerTime();
      
      public const timeUpdated:ISignal = new Signal();
      
      public const currentTime:BindableCounter = new BindableCounter(new Date().time,1000,Number.POSITIVE_INFINITY,1000);
      
      private var _lastUpdatedDate:Date;
      
      private var _lastUpdateTimer:int;
      
      private var _utcTimeOffset:Number = 0;
      
      public function ServerTime()
      {
         super();
         if(instance)
         {
            throw new Error("this is a Singleton");
         }
      }
      
      public function set timestamp(param1:Number) : void
      {
         if(Math.abs(param1 - this.currentTime.value) > 5000)
         {
            this.timeUpdated.dispatch();
         }
         this.currentTime.value = param1;
         this._lastUpdatedDate = new Date(param1);
         this._lastUpdateTimer = getTimer();
      }
      
      public function set utcTimeOffsetInSeconds(param1:Number) : void
      {
         this._utcTimeOffset = param1 * 1000;
      }
      
      public function get utcTimeOffset() : Number
      {
         return this._utcTimeOffset;
      }
   }
}

