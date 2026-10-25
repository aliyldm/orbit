package net.bigpoint.darkorbit.mvc.events.model.eventVOs
{
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   
   public class ChristmasTreeEvent implements IDOEvent
   {
      
      private var _id:uint;
      
      private var _active:Boolean;
      
      public function ChristmasTreeEvent(param1:uint, param2:Boolean)
      {
         super();
         this._active = param2;
         this._id = param1;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get isActive() : Boolean
      {
         return this._active;
      }
   }
}

