package net.bigpoint.darkorbit.map.view3D.utils.usage
{
   import flash.utils.Dictionary;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class UsageGroup
   {
      
      public const used:ISignal = new Signal();
      
      public const notUsed:ISignal = new Signal();
      
      private var _notUsedSignalDelaySeconds:Number = 0;
      
      private var _usage:Dictionary = new Dictionary(true);
      
      public function UsageGroup(param1:Number = 0)
      {
         super();
         this._notUsedSignalDelaySeconds = param1;
      }
      
      public function getUsage(param1:Object) : UsageCounter
      {
         var _loc2_:UsageCounter = this._usage[param1];
         if(_loc2_ == null)
         {
            this._usage[param1] = _loc2_ = new UsageCounter(param1,this._notUsedSignalDelaySeconds);
            _loc2_.used.add(this.used.dispatch);
            _loc2_.notUsed.add(this.notUsed.dispatch);
         }
         return this._usage[param1];
      }
      
      public function reset() : void
      {
         var _loc1_:UsageCounter = null;
         var _loc2_:Object = null;
         for(_loc2_ in this._usage)
         {
            _loc1_ = this._usage[_loc2_] as UsageCounter;
            _loc1_.dispose();
            _loc1_.used.remove(this.used.dispatch);
            _loc1_.notUsed.remove(this.notUsed.dispatch);
            this._usage[_loc2_] = null;
            delete this._usage[_loc2_];
         }
      }
      
      public function get objectsCount() : int
      {
         var _loc2_:* = undefined;
         var _loc1_:int = 0;
         for(_loc2_ in this._usage)
         {
            _loc1_++;
         }
         return _loc1_;
      }
   }
}

