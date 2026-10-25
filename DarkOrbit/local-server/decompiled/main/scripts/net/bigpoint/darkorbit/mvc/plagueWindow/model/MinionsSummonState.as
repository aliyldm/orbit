package net.bigpoint.darkorbit.mvc.plagueWindow.model
{
   public class MinionsSummonState extends AbstractSummonState
   {
      
      private var _currentWave:WaveMapGroup;
      
      public function MinionsSummonState()
      {
         super();
      }
      
      public function get currentWave() : WaveMapGroup
      {
         return this._currentWave;
      }
      
      public function set currentWave(param1:WaveMapGroup) : void
      {
         this._currentWave = param1;
      }
   }
}

