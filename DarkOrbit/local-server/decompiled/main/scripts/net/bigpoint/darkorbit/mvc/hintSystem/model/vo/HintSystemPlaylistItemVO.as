package net.bigpoint.darkorbit.mvc.hintSystem.model.vo
{
   import net.bigpoint.darkorbit.fui.components.core.transitions.ITransitionEffect;
   
   public class HintSystemPlaylistItemVO
   {
      
      private static const DEFAULT_DURATION:uint = 500;
      
      private var _resKey:String;
      
      private var _transitionEffect:ITransitionEffect;
      
      private var _duration:uint = 500;
      
      public function HintSystemPlaylistItemVO(param1:String, param2:ITransitionEffect, param3:uint = 500)
      {
         super();
         this._resKey = param1;
         this._transitionEffect = param2;
         this._duration = param3;
      }
      
      public function get resKey() : String
      {
         return this._resKey;
      }
      
      public function get transitionEffect() : ITransitionEffect
      {
         return this._transitionEffect;
      }
      
      public function get duration() : uint
      {
         return this._duration;
      }
   }
}

