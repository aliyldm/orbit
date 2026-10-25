package net.bigpoint.darkorbit.mvc.hintSystem.model.vo
{
   public class HintSystemPlaylistVO
   {
      
      private var _repeat:Boolean = false;
      
      private var _playlist:Vector.<HintSystemPlaylistItemVO> = new Vector.<HintSystemPlaylistItemVO>();
      
      public function HintSystemPlaylistVO(param1:Vector.<HintSystemPlaylistItemVO>, param2:Boolean)
      {
         super();
         this._playlist = param1;
         this._repeat = param2;
      }
      
      public function get repeat() : Boolean
      {
         return this._repeat;
      }
      
      public function get playlist() : Vector.<HintSystemPlaylistItemVO>
      {
         return this._playlist;
      }
   }
}

