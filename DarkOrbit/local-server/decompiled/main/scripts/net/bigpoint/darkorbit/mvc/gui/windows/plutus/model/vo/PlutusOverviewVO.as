package net.bigpoint.darkorbit.mvc.gui.windows.plutus.model.vo
{
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class PlutusOverviewVO
   {
      
      public const changed:ISignal = new Signal();
      
      private var _playerPoints:uint;
      
      private var _description:String;
      
      private var _lives:int;
      
      public function PlutusOverviewVO()
      {
         super();
      }
      
      public function get playerPoints() : uint
      {
         return this._playerPoints;
      }
      
      public function get playerLives() : int
      {
         return this._lives;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function set playerPoints(param1:uint) : void
      {
         this._playerPoints = param1;
         this.changed.dispatch();
      }
      
      public function set playerLives(param1:int) : void
      {
         this._lives = param1;
         this.changed.dispatch();
      }
      
      public function set description(param1:String) : void
      {
         this._description = param1;
         this.changed.dispatch();
      }
   }
}

