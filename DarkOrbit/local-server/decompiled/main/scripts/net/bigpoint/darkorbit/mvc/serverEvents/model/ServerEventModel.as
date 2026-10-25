package net.bigpoint.darkorbit.mvc.serverEvents.model
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ServerEventModel
   {
      
      public const eventActivated:ISignal = new Signal(ServerEventVO);
      
      public const eventDeactivated:ISignal = new Signal(ServerEventVO);
      
      private var _data:Object = {};
      
      public function ServerEventModel()
      {
         super();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function addEvent(param1:String, param2:int, param3:Number) : void
      {
         var _loc4_:ServerEventVO = this.internalGetOrAdd(param1,param3);
         _loc4_.timeLeft.value = param2;
         this.eventActivated.dispatch(_loc4_);
      }
      
      public function removeEvent(param1:String) : void
      {
         var _loc2_:ServerEventVO = this.internalGetEvent(param1);
         if(_loc2_)
         {
            delete this._data[param1];
            this.eventDeactivated.dispatch(_loc2_);
         }
      }
      
      public function getAsVector() : Vector.<ServerEventVO>
      {
         var _loc2_:* = undefined;
         var _loc1_:Vector.<ServerEventVO> = new Vector.<ServerEventVO>(0);
         for(_loc2_ in this._data)
         {
            _loc1_.push(this._data[_loc2_]);
         }
         return _loc1_;
      }
      
      public function getAllActiveTypes() : Vector.<String>
      {
         var _loc2_:* = undefined;
         var _loc1_:Vector.<String> = new Vector.<String>(0);
         for(_loc2_ in this._data)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getEventByType(param1:String) : ServerEventVO
      {
         return this.internalGetEvent(param1);
      }
      
      private function internalGetEvent(param1:String) : ServerEventVO
      {
         return this._data[param1];
      }
      
      private function internalGetOrAdd(param1:String, param2:Number) : ServerEventVO
      {
         var _loc3_:ServerEventVO = null;
         if(this._data[param1])
         {
            return this._data[param1];
         }
         _loc3_ = this._data[param1] = new ServerEventVO(param1,param2);
         _loc3_.deactivated.addOnce(this.onEventDeactivated);
         return _loc3_;
      }
      
      private function onEventDeactivated(param1:ServerEventVO) : void
      {
         this.removeEvent(param1.type);
      }
   }
}

