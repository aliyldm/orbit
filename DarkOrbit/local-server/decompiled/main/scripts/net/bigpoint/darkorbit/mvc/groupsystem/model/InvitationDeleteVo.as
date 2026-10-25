package net.bigpoint.darkorbit.mvc.groupsystem.model
{
   public class InvitationDeleteVo
   {
      
      public static const OUTGOING:int = 1;
      
      public static const INCOMMING:int = 0;
      
      private var _userId:int;
      
      private var _type:int;
      
      public function InvitationDeleteVo(param1:int, param2:int)
      {
         super();
         this._type = param2;
         this._userId = param1;
      }
      
      public function get userId() : int
      {
         return this._userId;
      }
      
      public function get type() : int
      {
         return this._type;
      }
   }
}

