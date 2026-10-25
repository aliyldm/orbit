package net.bigpoint.darkorbit.net.netty
{
   public class SocketSessionCache
   {
      
      private var messageLength:uint = 0;
      
      private var ready:Boolean = false;
      
      public function SocketSessionCache()
      {
         super();
      }
      
      public function isReady() : Boolean
      {
         return this.ready;
      }
      
      public function reset() : void
      {
         this.messageLength = 0;
         this.ready = false;
      }
      
      public function setLength(param1:uint) : void
      {
         this.messageLength = param1;
         this.ready = true;
      }
      
      public function getLength() : uint
      {
         return this.messageLength;
      }
   }
}

