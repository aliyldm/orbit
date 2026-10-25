package net.bigpoint.darkorbit.mvc.traininggrounds.model
{
   public class EpicMessageVo
   {
      
      public static const LOW_PRIO:int = 0;
      
      public static const NORMAL_PRIO:int = 1;
      
      private var _message:String;
      
      private var _duration:uint;
      
      private var _prio:int;
      
      private var _soundID:int;
      
      public function EpicMessageVo(param1:String, param2:uint, param3:int = 0, param4:int = -1)
      {
         super();
         this._soundID = param4;
         this._prio = param3;
         this._duration = param2;
         this._message = param1;
      }
      
      public static function sortOnPrio(param1:EpicMessageVo, param2:EpicMessageVo) : int
      {
         return param2.prio - param1.prio;
      }
      
      public function get duration() : uint
      {
         return this._duration;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get prio() : int
      {
         return this._prio;
      }
      
      public function toString() : String
      {
         return "message:" + this._message + " duration:" + this._duration + " prio:" + this._prio + "\n";
      }
      
      public function get soundID() : int
      {
         return this._soundID;
      }
   }
}

