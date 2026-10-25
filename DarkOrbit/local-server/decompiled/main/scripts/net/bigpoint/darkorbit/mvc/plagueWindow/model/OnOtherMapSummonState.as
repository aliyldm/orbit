package net.bigpoint.darkorbit.mvc.plagueWindow.model
{
   public class OnOtherMapSummonState extends AbstractSummonState
   {
      
      private var _maps:Vector.<int> = new Vector.<int>(0);
      
      public function OnOtherMapSummonState()
      {
         super();
      }
      
      public function get maps() : Vector.<int>
      {
         return this._maps;
      }
      
      public function set maps(param1:Vector.<int>) : void
      {
         this._maps = param1;
      }
   }
}

