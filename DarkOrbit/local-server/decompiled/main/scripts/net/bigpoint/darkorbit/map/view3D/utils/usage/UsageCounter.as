package net.bigpoint.darkorbit.map.view3D.utils.usage
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UsageCounter
   {
      
      public const used:ISignal = new Signal();
      
      public const notUsed:ISignal = new Signal();
      
      private var _target:Object;
      
      private var _counter:int = 0;
      
      private var _used:Boolean = false;
      
      private var _notUsedSignalDelaySeconds:Number = 0;
      
      private var _timeout:uint;
      
      public function UsageCounter(param1:Object, param2:Number = 0)
      {
         super();
         this._target = param1;
         this._notUsedSignalDelaySeconds = param2;
      }
      
      public function increase() : void
      {
         ++this._counter;
         clearTimeout(this._timeout);
         if(!this._used)
         {
            this._used = true;
            this.used.dispatch(this._target);
         }
      }
      
      public function decrease() : void
      {
         --this._counter;
         if(this._counter <= 0)
         {
            this._counter = 0;
            if(this._used)
            {
               this._used = false;
               clearTimeout(this._timeout);
               if(this._notUsedSignalDelaySeconds > 0)
               {
                  this._timeout = setTimeout(this.notUsed.dispatch,this._notUsedSignalDelaySeconds * 1000,this._target);
               }
               else
               {
                  this.notUsed.dispatch(this._target);
               }
            }
         }
      }
      
      public function dispose() : void
      {
         clearTimeout(this._timeout);
         this._counter = 0;
         this._used = false;
      }
      
      public function get counter() : int
      {
         return this._counter;
      }
   }
}

