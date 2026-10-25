package net.bigpoint.darkorbit.pattern
{
   public class AudibleResourcePattern extends ResourcePattern
   {
      
      private var soundID:int = -1;
      
      private var _engineLoop:Boolean = false;
      
      public function AudibleResourcePattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      public function getSoundID() : int
      {
         return this.soundID;
      }
      
      public function setSoundID(param1:int) : void
      {
         this.soundID = param1;
      }
      
      public function get engineLoop() : Boolean
      {
         return this._engineLoop;
      }
      
      public function set engineLoop(param1:Boolean) : void
      {
         this._engineLoop = param1;
      }
   }
}

