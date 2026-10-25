package net.bigpoint.darkorbit.mvc.events.model.eventVOs
{
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   
   public class EventDominatingFactionEvent implements IDOEvent
   {
      
      private var _dominatingFaction:int;
      
      private var _type:uint;
      
      private var _active:Boolean;
      
      public function EventDominatingFactionEvent(param1:uint, param2:Boolean, param3:uint)
      {
         super();
         this._active = param2;
         this._type = param1;
         this._dominatingFaction = param3;
      }
      
      public function get id() : int
      {
         return this._type;
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
      
      public function get dominatingFaction() : int
      {
         return this._dominatingFaction;
      }
   }
}

