package net.bigpoint.darkorbit.mvc.gui.windows.alienHunt.model.vo
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AlienHuntOverviewVO
   {
      
      public const changed:ISignal = new Signal();
      
      private var _playerPoints:uint;
      
      private var _totalClanPoints:uint;
      
      public function AlienHuntOverviewVO()
      {
         super();
      }
      
      public function get playerPoints() : uint
      {
         return this._playerPoints;
      }
      
      public function set playerPoints(param1:uint) : void
      {
         this._playerPoints = param1;
         this.changed.dispatch();
      }
      
      public function get totalClanPoints() : uint
      {
         return this._totalClanPoints;
      }
      
      public function set totalClanPoints(param1:uint) : void
      {
         this._totalClanPoints = param1;
         this.changed.dispatch();
      }
   }
}

