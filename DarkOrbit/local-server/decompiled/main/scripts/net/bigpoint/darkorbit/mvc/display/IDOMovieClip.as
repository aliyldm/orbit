package net.bigpoint.darkorbit.mvc.display
{
   public interface IDOMovieClip extends IDODisplayObject
   {
      
      function play() : void;
      
      function pause() : void;
      
      function stop() : void;
      
      function get currentFrame() : int;
      
      function set currentFrame(param1:int) : void;
      
      function get numFrames() : int;
      
      function set freezed(param1:Boolean) : void;
   }
}

