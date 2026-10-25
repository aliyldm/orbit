package net.bigpoint.darkorbit.mvc.events.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.events.control.notifications.EventNotifications;
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class EventProxy extends Proxy
   {
      
      public static const NAME:String = "EventProxy";
      
      private var activeEvents:Dictionary = new Dictionary();
      
      public function EventProxy(param1:Object = null)
      {
         super(EventProxy.NAME,param1);
      }
      
      private function get events() : Vector.<IDOEvent>
      {
         return data as Vector.<IDOEvent>;
      }
      
      public function isEventActive(param1:int) : Boolean
      {
         var _loc2_:IDOEvent = this.getEventWithId(param1);
         return _loc2_ ? _loc2_.isActive : false;
      }
      
      public function getEventWithId(param1:int) : IDOEvent
      {
         var _loc2_:IDOEvent = null;
         var _loc3_:IDOEvent = null;
         for each(_loc3_ in this.events)
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public function addEvent(param1:IDOEvent) : void
      {
         if(this.getEventWithId(param1.id))
         {
            this.removeEventById(param1.id);
         }
         this.events.push(param1);
         sendNotification(EventNotifications.ACTIVATE_EVENT,param1);
         this.activeEvents[param1.id] = param1.isActive;
      }
      
      public function removeEventById(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:IDOEvent = this.getEventWithId(param1);
         if(_loc3_)
         {
            this.removeEvent(_loc3_,param2);
         }
      }
      
      private function removeEvent(param1:IDOEvent, param2:Boolean) : void
      {
         var _loc3_:int = this.events.indexOf(param1);
         if(_loc3_ != -1)
         {
            this.events.splice(_loc3_,1);
         }
         if(param2)
         {
            this.activeEvents[param1.id] = false;
         }
      }
      
      public function getEvents() : Vector.<IDOEvent>
      {
         return this.events;
      }
      
      public function cleanup() : void
      {
      }
   }
}

