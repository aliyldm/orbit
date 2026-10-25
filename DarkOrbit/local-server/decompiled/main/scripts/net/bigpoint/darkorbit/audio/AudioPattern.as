package net.bigpoint.darkorbit.audio
{
   import net.bigpoint.darkorbit.pattern.ResourcePattern;
   
   public class AudioPattern extends ResourcePattern
   {
      
      private var loop:Boolean;
      
      private var volume:Number = 1;
      
      private var _soundbank:String;
      
      private var _interval:Number;
      
      private var _intervalFluctuation:int = 0;
      
      private var _isVoice:Boolean = false;
      
      public function AudioPattern(param1:int, param2:String = null)
      {
         super(param1,null);
         this._soundbank = param2;
      }
      
      public function isLoop() : Boolean
      {
         return this.loop;
      }
      
      public function setLoop(param1:Boolean) : void
      {
         this.loop = param1;
      }
      
      public function isVoice() : Boolean
      {
         return this._isVoice;
      }
      
      public function setVoice(param1:Boolean) : void
      {
         this._isVoice = param1;
      }
      
      public function getVolume() : Number
      {
         return this.volume;
      }
      
      public function setVolume(param1:Number) : void
      {
         this.volume = param1;
      }
      
      public function get soundbank() : String
      {
         return this._soundbank;
      }
      
      public function get interval() : Number
      {
         return this._interval;
      }
      
      public function set interval(param1:Number) : void
      {
         this._interval = param1 * 1000;
      }
      
      public function get intervalFluctuation() : int
      {
         return this._intervalFluctuation;
      }
      
      public function set intervalFluctuation(param1:int) : void
      {
         this._intervalFluctuation = param1 * 1000;
      }
   }
}

